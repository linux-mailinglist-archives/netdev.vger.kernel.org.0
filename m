Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D2646DF6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLHLDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLHLDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:03:04 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F060B7F;
        Thu,  8 Dec 2022 03:01:24 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NSWLt6dS9znTmV;
        Thu,  8 Dec 2022 18:57:10 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Dec
 2022 19:01:21 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <kevin.curtis@farsite.co.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <lizetao1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: farsync: Fix kmemleak when rmmods farsync
Date:   Thu, 8 Dec 2022 20:05:40 +0800
Message-ID: <20221208120540.3758720-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two memory leaks reported by kmemleak:

  unreferenced object 0xffff888114b20200 (size 128):
    comm "modprobe", pid 4846, jiffies 4295146524 (age 401.345s)
    hex dump (first 32 bytes):
      e0 62 57 09 81 88 ff ff e0 62 57 09 81 88 ff ff  .bW......bW.....
      01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
      [<ffffffff83d35c78>] __hw_addr_add_ex+0x198/0x6c0
      [<ffffffff83d3989d>] dev_addr_init+0x13d/0x230
      [<ffffffff83d1063d>] alloc_netdev_mqs+0x10d/0xe50
      [<ffffffff82b4a06e>] alloc_hdlcdev+0x2e/0x80
      [<ffffffffa016a741>] fst_add_one+0x601/0x10e0 [farsync]
      ...

  unreferenced object 0xffff88810b85b000 (size 1024):
    comm "modprobe", pid 4846, jiffies 4295146523 (age 401.346s)
    hex dump (first 32 bytes):
      00 00 b0 02 00 c9 ff ff 00 70 0a 00 00 c9 ff ff  .........p......
      00 00 00 f2 00 00 00 f3 0a 00 00 00 02 00 00 00  ................
    backtrace:
      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
      [<ffffffffa016a294>] fst_add_one+0x154/0x10e0 [farsync]
      [<ffffffff82060e83>] local_pci_probe+0xd3/0x170
      ...

The root cause is traced to the netdev and fst_card_info are not freed
when removes one fst in fst_remove_one(), which may trigger oom if
repeated insmod and rmmod module.

Fix it by adding free_netdev() and kfree() in fst_remove_one(), just as
the operations on the error handling path in fst_add_one().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/net/wan/farsync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 6a212c085435..5b01642ca44e 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2545,6 +2545,7 @@ fst_remove_one(struct pci_dev *pdev)
 		struct net_device *dev = port_to_dev(&card->ports[i]);
 
 		unregister_hdlc_device(dev);
+		free_netdev(dev);
 	}
 
 	fst_disable_intr(card);
@@ -2564,6 +2565,7 @@ fst_remove_one(struct pci_dev *pdev)
 				  card->tx_dma_handle_card);
 	}
 	fst_card_array[card->card_no] = NULL;
+	kfree(card);
 }
 
 static struct pci_driver fst_driver = {
-- 
2.31.1

