Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC85F431FB8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhJROc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232406AbhJROcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF050610E8;
        Mon, 18 Oct 2021 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567392;
        bh=DhxheYRL1MXr7pefW6gucmrlw+vojeyVl835hc2hudI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwijmnyfN1y9p8Zs04sXabhcYxIdtmPkXNt/Ow+QaIHeGhgbjSEgDAGCdoIUFuVlu
         WV8+GiYV953pEhVlGAy1d+nX5njLLqamxxKzdWuQcjaayPG18DtJbeKCpRd573ftgt
         6d5RRU1afyWxOx4f3ib/PJnl2xMy/VP8W0RTd8skFi5nhp83GIjdh8vlic0VgUQ/qa
         PM3fKiXWOF7MSj55hliAR7OhnB3/XwGKU9NH8hma0vRac66kNpeFJzMXxuV06XFkYS
         M3G/wovU3sBduqyEFMv1OvJ0jLLSyjedXJzYaJeYd7MLdvMz3mmEjEUXVBqcQkmY8Z
         q7RjfIk8k+Lyg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        steve.glendinning@shawell.net
Subject: [PATCH net-next 12/12] ethernet: smsc: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:32 -0700
Message-Id: <20211018142932.1000613-13-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018142932.1000613-1-kuba@kernel.org>
References: <20211018142932.1000613-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Break the address up into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: steve.glendinning@shawell.net
---
 drivers/net/ethernet/smsc/smsc911x.c | 16 +++++++++-------
 drivers/net/ethernet/smsc/smsc9420.c | 18 ++++++++++--------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 73bcc6f2bb6e..7a50ba00f8ae 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2162,13 +2162,15 @@ static void smsc911x_read_mac_address(struct net_device *dev)
 	struct smsc911x_data *pdata = netdev_priv(dev);
 	u32 mac_high16 = smsc911x_mac_read(pdata, ADDRH);
 	u32 mac_low32 = smsc911x_mac_read(pdata, ADDRL);
-
-	dev->dev_addr[0] = (u8)(mac_low32);
-	dev->dev_addr[1] = (u8)(mac_low32 >> 8);
-	dev->dev_addr[2] = (u8)(mac_low32 >> 16);
-	dev->dev_addr[3] = (u8)(mac_low32 >> 24);
-	dev->dev_addr[4] = (u8)(mac_high16);
-	dev->dev_addr[5] = (u8)(mac_high16 >> 8);
+	u8 addr[ETH_ALEN];
+
+	addr[0] = (u8)(mac_low32);
+	addr[1] = (u8)(mac_low32 >> 8);
+	addr[2] = (u8)(mac_low32 >> 16);
+	addr[3] = (u8)(mac_low32 >> 24);
+	addr[4] = (u8)(mac_high16);
+	addr[5] = (u8)(mac_high16 >> 8);
+	eth_hw_addr_set(dev, addr);
 }
 
 /* Initializing private device structures, only called from probe */
diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index d207c0b463ab..d937af18973e 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -416,6 +416,7 @@ static void smsc9420_set_mac_address(struct net_device *dev)
 static void smsc9420_check_mac_address(struct net_device *dev)
 {
 	struct smsc9420_pdata *pd = netdev_priv(dev);
+	u8 addr[ETH_ALEN];
 
 	/* Check if mac address has been specified when bringing interface up */
 	if (is_valid_ether_addr(dev->dev_addr)) {
@@ -427,15 +428,16 @@ static void smsc9420_check_mac_address(struct net_device *dev)
 		 * it will already have been set */
 		u32 mac_high16 = smsc9420_reg_read(pd, ADDRH);
 		u32 mac_low32 = smsc9420_reg_read(pd, ADDRL);
-		dev->dev_addr[0] = (u8)(mac_low32);
-		dev->dev_addr[1] = (u8)(mac_low32 >> 8);
-		dev->dev_addr[2] = (u8)(mac_low32 >> 16);
-		dev->dev_addr[3] = (u8)(mac_low32 >> 24);
-		dev->dev_addr[4] = (u8)(mac_high16);
-		dev->dev_addr[5] = (u8)(mac_high16 >> 8);
-
-		if (is_valid_ether_addr(dev->dev_addr)) {
+		addr[0] = (u8)(mac_low32);
+		addr[1] = (u8)(mac_low32 >> 8);
+		addr[2] = (u8)(mac_low32 >> 16);
+		addr[3] = (u8)(mac_low32 >> 24);
+		addr[4] = (u8)(mac_high16);
+		addr[5] = (u8)(mac_high16 >> 8);
+
+		if (is_valid_ether_addr(addr)) {
 			/* eeprom values are valid  so use them */
+			eth_hw_addr_set(dev, addr);
 			netif_dbg(pd, probe, pd->dev,
 				  "Mac Address is read from EEPROM\n");
 		} else {
-- 
2.31.1

