Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF216B2063
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjCIJna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjCIJnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:43:21 -0500
Received: from m12.mail.163.com (m12.mail.163.com [123.126.96.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29D4C5552C;
        Thu,  9 Mar 2023 01:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=1LAKM
        8ujTmsjgTGR7X/vNMNjwpQJAdiC96EghkHvIIM=; b=V3tmhaUxN5E19Lu4oMuCu
        C8F3LLtelKjSMeOzC9QAfey0k6++9pZ28Tki2rspG4oPrln+sox+M164Swk6qVWm
        T8YOgTRzWTID8iPrq4QDQJJGbi33J6hlJUJT8HLI0Ahs3WMRneYY1gnEgVjIRKZX
        tpsx4OLwTsIjieqPqbjLD0=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by smtp19 (Coremail) with SMTP id R9xpCgAnKa0IqglkPaTXGw--.56707S2;
        Thu, 09 Mar 2023 17:42:33 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net]  net: ethernet: fix use after free bug in ns83820_remove_one due to race condition
Date:   Thu,  9 Mar 2023 17:42:31 +0800
Message-Id: <20230309094231.3808770-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: R9xpCgAnKa0IqglkPaTXGw--.56707S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw45WryrZFyDWFy3KFWDCFg_yoWkXrcEg3
        srZF4Skw4UKr1rtw4UGrsxX34jkr9Y9r9Y9rWDta9Iv343Kws5Cw1kur1fJr48uwnxJFW2
        kry7KFyfA343AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKBT5JUUUUU==
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiQgktU1aEEmftKQAAsW
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ns83820_init_one, dev->tq_refill was bound with queue_refill.

If irq happens, it will call ns83820_irq->ns83820_do_isr.
Then it invokes tasklet_schedule(&dev->rx_tasklet) to start
rx_action function. And rx_action will call ns83820_rx_kick
and finally start queue_refill function.

If we remove the driver without finishing the work, there
may be a race condition between ndev, which may cause UAF
bug.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/net/ethernet/natsemi/ns83820.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 998586872599..285fe0fa33eb 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -2206,6 +2206,7 @@ static void ns83820_remove_one(struct pci_dev *pci_dev)
 	if (!ndev)			/* paranoia */
 		return;
 
+	cancel_work_sync(&dev->tq_refill);
 	ns83820_disable_interrupts(dev); /* paranoia */
 
 	unregister_netdev(ndev);
-- 
2.25.1

