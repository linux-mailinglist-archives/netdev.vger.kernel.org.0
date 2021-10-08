Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC73A426FD0
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhJHSBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhJHSBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A0861029;
        Fri,  8 Oct 2021 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633715957;
        bh=VfdMjfieNn0zpitRrlRtRYnUUmMq8GaUviTTUhcHXoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mj0JGvK3XVFjhebiduHAEu9ZnA3iFHYOVRf2qlcqZRhrHf9uy9PuOMcRGhUREfqId
         xMrCOBWbFGKQjVQXMExBmQ7GdTxeW5XZH4lgJ1AYFzfursUvJFykXskk1JoQIyKrYj
         mzWRPMdodWAwOvzxHqrykHCU7wct/AWPuDph07Y9ZLb8Oteb2MOFECdhDllJZT+ZLb
         Tw5HOHBPXYhsQBQtoebN6V13EZ3DTf9S35U5FXYts1LGFoQ/h/4LqG2h0RXzkMK00E
         hGuwCJRlLNcnkG5RNct2OO1lqYrU+qtoLJVu2cn99vUZ9aDp0eUdRitytnDk4kpe/r
         m33HrOz7DJ/PA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH net-next 1/5] ethernet: forcedeth: remove direct netdev->dev_addr writes
Date:   Fri,  8 Oct 2021 10:59:09 -0700
Message-Id: <20211008175913.3754184-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008175913.3754184-1-kuba@kernel.org>
References: <20211008175913.3754184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

forcedeth writes to dev_addr byte by byte, make it use
a local buffer instead. Commit the changes with
eth_hw_addr_set() at the end.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Rain River <rain.1986.08.12@gmail.com>
CC: Zhu Yanjun <zyjzyj2000@gmail.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 49 +++++++++++++------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 3f269f914dac..9b530d7509a4 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -5711,6 +5711,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	u32 phystate_orig = 0, phystate;
 	int phyinitialized = 0;
 	static int printed_version;
+	u8 mac[ETH_ALEN];
 
 	if (!printed_version++)
 		pr_info("Reverse Engineered nForce ethernet driver. Version %s.\n",
@@ -5884,50 +5885,52 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	txreg = readl(base + NvRegTransmitPoll);
 	if (id->driver_data & DEV_HAS_CORRECT_MACADDR) {
 		/* mac address is already in correct order */
-		dev->dev_addr[0] = (np->orig_mac[0] >>  0) & 0xff;
-		dev->dev_addr[1] = (np->orig_mac[0] >>  8) & 0xff;
-		dev->dev_addr[2] = (np->orig_mac[0] >> 16) & 0xff;
-		dev->dev_addr[3] = (np->orig_mac[0] >> 24) & 0xff;
-		dev->dev_addr[4] = (np->orig_mac[1] >>  0) & 0xff;
-		dev->dev_addr[5] = (np->orig_mac[1] >>  8) & 0xff;
+		mac[0] = (np->orig_mac[0] >>  0) & 0xff;
+		mac[1] = (np->orig_mac[0] >>  8) & 0xff;
+		mac[2] = (np->orig_mac[0] >> 16) & 0xff;
+		mac[3] = (np->orig_mac[0] >> 24) & 0xff;
+		mac[4] = (np->orig_mac[1] >>  0) & 0xff;
+		mac[5] = (np->orig_mac[1] >>  8) & 0xff;
 	} else if (txreg & NVREG_TRANSMITPOLL_MAC_ADDR_REV) {
 		/* mac address is already in correct order */
-		dev->dev_addr[0] = (np->orig_mac[0] >>  0) & 0xff;
-		dev->dev_addr[1] = (np->orig_mac[0] >>  8) & 0xff;
-		dev->dev_addr[2] = (np->orig_mac[0] >> 16) & 0xff;
-		dev->dev_addr[3] = (np->orig_mac[0] >> 24) & 0xff;
-		dev->dev_addr[4] = (np->orig_mac[1] >>  0) & 0xff;
-		dev->dev_addr[5] = (np->orig_mac[1] >>  8) & 0xff;
+		mac[0] = (np->orig_mac[0] >>  0) & 0xff;
+		mac[1] = (np->orig_mac[0] >>  8) & 0xff;
+		mac[2] = (np->orig_mac[0] >> 16) & 0xff;
+		mac[3] = (np->orig_mac[0] >> 24) & 0xff;
+		mac[4] = (np->orig_mac[1] >>  0) & 0xff;
+		mac[5] = (np->orig_mac[1] >>  8) & 0xff;
 		/*
 		 * Set orig mac address back to the reversed version.
 		 * This flag will be cleared during low power transition.
 		 * Therefore, we should always put back the reversed address.
 		 */
-		np->orig_mac[0] = (dev->dev_addr[5] << 0) + (dev->dev_addr[4] << 8) +
-			(dev->dev_addr[3] << 16) + (dev->dev_addr[2] << 24);
-		np->orig_mac[1] = (dev->dev_addr[1] << 0) + (dev->dev_addr[0] << 8);
+		np->orig_mac[0] = (mac[5] << 0) + (mac[4] << 8) +
+			(mac[3] << 16) + (mac[2] << 24);
+		np->orig_mac[1] = (mac[1] << 0) + (mac[0] << 8);
 	} else {
 		/* need to reverse mac address to correct order */
-		dev->dev_addr[0] = (np->orig_mac[1] >>  8) & 0xff;
-		dev->dev_addr[1] = (np->orig_mac[1] >>  0) & 0xff;
-		dev->dev_addr[2] = (np->orig_mac[0] >> 24) & 0xff;
-		dev->dev_addr[3] = (np->orig_mac[0] >> 16) & 0xff;
-		dev->dev_addr[4] = (np->orig_mac[0] >>  8) & 0xff;
-		dev->dev_addr[5] = (np->orig_mac[0] >>  0) & 0xff;
+		mac[0] = (np->orig_mac[1] >>  8) & 0xff;
+		mac[1] = (np->orig_mac[1] >>  0) & 0xff;
+		mac[2] = (np->orig_mac[0] >> 24) & 0xff;
+		mac[3] = (np->orig_mac[0] >> 16) & 0xff;
+		mac[4] = (np->orig_mac[0] >>  8) & 0xff;
+		mac[5] = (np->orig_mac[0] >>  0) & 0xff;
 		writel(txreg|NVREG_TRANSMITPOLL_MAC_ADDR_REV, base + NvRegTransmitPoll);
 		dev_dbg(&pci_dev->dev,
 			"%s: set workaround bit for reversed mac addr\n",
 			__func__);
 	}
 
-	if (!is_valid_ether_addr(dev->dev_addr)) {
+	if (is_valid_ether_addr(mac)) {
+		eth_hw_addr_set(dev, mac);
+	} else {
 		/*
 		 * Bad mac address. At least one bios sets the mac address
 		 * to 01:23:45:67:89:ab
 		 */
 		dev_err(&pci_dev->dev,
 			"Invalid MAC address detected: %pM - Please complain to your hardware vendor.\n",
-			dev->dev_addr);
+			mac);
 		eth_hw_addr_random(dev);
 		dev_err(&pci_dev->dev,
 			"Using random MAC address: %pM\n", dev->dev_addr);
-- 
2.31.1

