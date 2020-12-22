Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6682E0F3C
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 21:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgLVUPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 15:15:33 -0500
Received: from atlmailgw1.ami.com ([63.147.10.40]:63373 "EHLO
        atlmailgw1.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVUPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 15:15:32 -0500
X-AuditID: ac1060b2-a7dff700000017ec-1c-5fe253b9d2da
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw1.ami.com (Symantec Messaging Gateway) with SMTP id B3.1F.06124.AB352EF5; Tue, 22 Dec 2020 15:14:50 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Tue, 22 Dec 2020 15:14:49 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed, v2 1/2] net: ftgmac100: Change the order of getting MAC address
Date:   Tue, 22 Dec 2020 15:14:36 -0500
Message-ID: <20201222201437.5588-2-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201221205157.31501-2-hongweiz@ami.com>
References: <20201221205157.31501-2-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRiBhgu6u4EfxBp3bhC12XeawmHO+hcVi
        0fsZrBa/z/9ltriwrY/Vonn1OWaLy7vmsFkcWyBmcarlBYsDp8fV9l3sHltW3mTy2DnrLrvH
        xY/HmD02repk8zg/YyGjx+dNcgHsUVw2Kak5mWWpRfp2CVwZfybdZCxYy1fRNqGFvYHxA3cX
        IyeHhICJxLn9n1m6GLk4hAR2MUn8+bSDFcphlFj3/woLSBWbgJrE3s1zmEASIgKXGSVudD1h
        BnGYBToYJaa++MoOUiUsECjRd+MUmM0ioCqx9vcONhCbF2jHpZO72CD2yUus3nCAGcTmFDCT
        uNA9C2yDkICpxIq/H5kh6gUlTs58AhZnFpCQOPjiBTNEjazErUOPmSDmKEo8+PWddQKjwCwk
        LbOQtCxgZFrFKJRYkpObmJmTXm6ol5ibqZecn7uJERLwm3Ywtlw0P8TIxMF4iFGCg1lJhNdM
        6n68EG9KYmVValF+fFFpTmrxIUZpDhYlcd5V7kfjhQTSE0tSs1NTC1KLYLJMHJxSDYw31Gq+
        C0rXcljsZ1N+qPhCcLc84zRW/4xlkjem5Yp/Slp9ccbXf8lMufv3Ri19yqc451birHsqWh+4
        XOO8VtbdtUsTqO8Q3KQltsKb5W7Avjur9/0T4LPJv2ixgj1rXkOFgYkew2red5Pnb7CfNWVN
        H8NNqz8n+K5r/j229jFnkH7cDga+JQpKLMUZiYZazEXFiQDA74FxZgIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the order of reading MAC address, try to read it from MAC chip
first, if it's not availabe, then try to read it from device tree.

Fixes: 35c54922dc97 ("ARM: dts: tacoma: Add reserved memory for ramoops")
Signed-off-by: Hongwei Zhang <hongweiz@ami.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 65cd25372020..713e9325bef8 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -184,14 +184,7 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
 	unsigned int l;
 	void *addr;
 
-	addr = device_get_mac_address(priv->dev, mac, ETH_ALEN);
-	if (addr) {
-		ether_addr_copy(priv->netdev->dev_addr, mac);
-		dev_info(priv->dev, "Read MAC address %pM from device tree\n",
-			 mac);
-		return;
-	}
-
+	/* Try to read MAC from chip first */
 	m = ioread32(priv->base + FTGMAC100_OFFSET_MAC_MADR);
 	l = ioread32(priv->base + FTGMAC100_OFFSET_MAC_LADR);
 
@@ -205,7 +198,18 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
 	if (is_valid_ether_addr(mac)) {
 		ether_addr_copy(priv->netdev->dev_addr, mac);
 		dev_info(priv->dev, "Read MAC address %pM from chip\n", mac);
-	} else {
+		return;
+	}
+
+	/* Get MAC from device tree if it cannot be read from the chip */
+	addr = device_get_mac_address(priv->dev, mac, ETH_ALEN);
+	if (addr) {
+		ether_addr_copy(priv->netdev->dev_addr, mac);
+		dev_info(priv->dev, "Read MAC address %pM from device tree\n",
+				mac);
+		return;
+	}
+	else {
 		eth_hw_addr_random(priv->netdev);
 		dev_info(priv->dev, "Generated random MAC address %pM\n",
 			 priv->netdev->dev_addr);
-- 
2.17.1

