Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D4739F08C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhFHIRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:17:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8080 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhFHIRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:45 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzjfQ1ZPbzYrps;
        Tue,  8 Jun 2021 16:13:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 04/16] net: farsync: move out assignment in if condition
Date:   Tue, 8 Jun 2021 16:12:30 +0800
Message-ID: <1623139962-34847-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
References: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Should not use assignment in if condition.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index a5fe605..8db9c84 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1252,7 +1252,8 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 	}
 
 	/* Allocate SKB */
-	if ((skb = dev_alloc_skb(len)) == NULL) {
+	skb = dev_alloc_skb(len);
+	if (!skb) {
 		dbg(DBG_RX, "intr_rx: can't allocate buffer\n");
 
 		dev->stats.rx_dropped++;
@@ -1344,7 +1345,8 @@ do_bottom_half_tx(struct fst_card_info *card)
 			 * bit on the next buffer we think we can use
 			 */
 			spin_lock_irqsave(&card->card_lock, flags);
-			if ((txq_length = port->txqe - port->txqs) < 0) {
+			txq_length = port->txqe - port->txqs;
+			if (txq_length < 0) {
 				/*
 				 * This is the case where one has wrapped and the
 				 * maths gives us a negative number
@@ -1633,7 +1635,8 @@ check_started_ok(struct fst_card_info *card)
 		return;
 	}
 	/* Firmware status flag, 0x00 = initialising, 0x01 = OK, 0xFF = fail */
-	if ((i = FST_RDB(card, taskStatus)) == 0x01) {
+	i = FST_RDB(card, taskStatus);
+	if (i == 0x01) {
 		card->state = FST_RUNNING;
 	} else if (i == 0xFF) {
 		pr_err("Firmware initialisation failed. Card halted\n");
@@ -2292,7 +2295,8 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * Check there is room in the port txq
 	 */
 	spin_lock_irqsave(&card->card_lock, flags);
-	if ((txq_length = port->txqe - port->txqs) < 0) {
+	txq_length = port->txqe - port->txqs;
+	if (txq_length < 0) {
 		/*
 		 * This is the case where the next free has wrapped but the
 		 * last used hasn't
@@ -2432,12 +2436,14 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	/* Try to enable the device */
-	if ((err = pci_enable_device(pdev)) != 0) {
+	err = pci_enable_device(pdev);
+	if (err) {
 		pr_err("Failed to enable card. Err %d\n", -err);
 		goto enable_fail;
 	}
 
-	if ((err = pci_request_regions(pdev, "FarSync")) !=0) {
+	err = pci_request_regions(pdev, "FarSync");
+	if (err) {
 		pr_err("Failed to allocate regions. Err %d\n", -err);
 		goto regions_fail;
 	}
@@ -2446,12 +2452,14 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	card->pci_conf = pci_resource_start(pdev, 1);
 	card->phys_mem = pci_resource_start(pdev, 2);
 	card->phys_ctlmem = pci_resource_start(pdev, 3);
-	if ((card->mem = ioremap(card->phys_mem, FST_MEMSIZE)) == NULL) {
+	card->mem = ioremap(card->phys_mem, FST_MEMSIZE);
+	if (!card->mem) {
 		pr_err("Physical memory remap failed\n");
 		err = -ENODEV;
 		goto ioremap_physmem_fail;
 	}
-	if ((card->ctlmem = ioremap(card->phys_ctlmem, 0x10)) == NULL) {
+	card->ctlmem = ioremap(card->phys_ctlmem, 0x10);
+	if (!card->ctlmem) {
 		pr_err("Control memory remap failed\n");
 		err = -ENODEV;
 		goto ioremap_ctlmem_fail;
-- 
2.8.1

