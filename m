Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E750A6BDFD9
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 04:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCQD4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 23:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCQD4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 23:56:03 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A4156153;
        Thu, 16 Mar 2023 20:56:02 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Pd9Fm6FY9z17LVQ;
        Fri, 17 Mar 2023 11:53:00 +0800 (CST)
Received: from huawei.com (10.67.175.88) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Fri, 17 Mar
 2023 11:55:59 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <3chas3@gmail.com>
CC:     <lizetao1@huawei.com>, <linux-atm-general@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] atm: idt77252: fix kmemleak when rmmod idt77252
Date:   Fri, 17 Mar 2023 03:52:28 +0000
Message-ID: <20230317035228.2635209-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.88]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are memory leaks reported by kmemleak:

  unreferenced object 0xffff888106500800 (size 128):
    comm "modprobe", pid 1017, jiffies 4297787785 (age 67.152s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<00000000970ce626>] __kmem_cache_alloc_node+0x20c/0x380
      [<00000000fb5f78d9>] kmalloc_trace+0x2f/0xb0
      [<000000000e947e2a>] idt77252_init_one+0x2847/0x3c90 [idt77252]
      [<000000006efb048e>] local_pci_probe+0xeb/0x1a0
    ...

  unreferenced object 0xffff888106500b00 (size 128):
    comm "modprobe", pid 1017, jiffies 4297787785 (age 67.152s)
    hex dump (first 32 bytes):
      00 20 3d 01 80 88 ff ff 00 20 3d 01 80 88 ff ff  . =...... =.....
      f0 23 3d 01 80 88 ff ff 00 20 3d 01 00 00 00 00  .#=...... =.....
    backtrace:
      [<00000000970ce626>] __kmem_cache_alloc_node+0x20c/0x380
      [<00000000fb5f78d9>] kmalloc_trace+0x2f/0xb0
      [<00000000f451c5be>] alloc_scq.constprop.0+0x4a/0x400 [idt77252]
      [<00000000e6313849>] idt77252_init_one+0x28cf/0x3c90 [idt77252]

The root cause is traced to the vc_maps which alloced in open_card_oam()
are not freed in close_card_oam(). The vc_maps are used to record
open connections, so when close a vc_map in close_card_oam(), the memory
should be freed. Moreover, the ubr0 is not closed when close a idt77252
device, leading to the memory leak of vc_map and scq_info.

Fix them by adding kfree in close_card_oam() and implementing new
close_card_ubr0() to close ubr0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/atm/idt77252.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index eec0cc2144e0..060f32b0def3 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2909,6 +2909,7 @@ close_card_oam(struct idt77252_dev *card)
 
 				recycle_rx_pool_skb(card, &vc->rcv.rx_pool);
 			}
+			kfree(vc);
 		}
 	}
 }
@@ -2952,6 +2953,16 @@ open_card_ubr0(struct idt77252_dev *card)
 	return 0;
 }
 
+static void
+close_card_ubr0(struct idt77252_dev *card)
+{
+	struct vc_map *vc;
+
+	vc = card->vcs[0];
+	free_scq(card, vc->scq);
+	kfree(vc);
+}
+
 static int
 idt77252_dev_open(struct idt77252_dev *card)
 {
@@ -3001,6 +3012,7 @@ static void idt77252_dev_close(struct atm_dev *dev)
 	struct idt77252_dev *card = dev->dev_data;
 	u32 conf;
 
+	close_card_ubr0(card);
 	close_card_oam(card);
 
 	conf = SAR_CFG_RXPTH |	/* enable receive path           */
-- 
2.25.1

