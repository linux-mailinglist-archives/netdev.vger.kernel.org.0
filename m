Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F2D2E01AD
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 21:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgLUUww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 15:52:52 -0500
Received: from atlmailgw2.ami.com ([63.147.10.42]:59180 "EHLO
        atlmailgw2.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUUww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 15:52:52 -0500
X-AuditID: ac10606f-231ff70000001934-b6-5fe10afa0ac2
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw2.ami.com (Symantec Messaging Gateway) with SMTP id 92.00.06452.BFA01EF5; Mon, 21 Dec 2020 15:52:11 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Mon, 21 Dec 2020 15:52:10 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed, v1 1/1] net: ftgmac100: Change the order of getting MAC address
Date:   Mon, 21 Dec 2020 15:51:57 -0500
Message-ID: <20201221205157.31501-2-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201221205157.31501-1-hongweiz@ami.com>
References: <20201221205157.31501-1-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWyRiBhgu5vrofxBj++ClvsusxhMed8C4vF
        7/N/mS0ubOtjtWhefY7Z4vKuOWwWxxaIWZxqecHiwOFxtX0Xu8eWlTeZPC5+PMbssWlVJ5vH
        +RkLGT0+b5ILYIvisklJzcksSy3St0vgylhwaDt7wQy+io4lJ9gaGB9wdzFyckgImEicnzmN
        vYuRi0NIYBeTxORLjUxQDqPEypmv2UCq2ATUJPZungOWEBFYzSjRs+EXI4jDLNDBKDH1xVd2
        kCphgUCJzq1rGUFsFgFViS0PXjCB2LwCphIbW3azQ+yTl1i94QAziM0pYCZxZOYnFhBbCKjm
        +vZuFoh6QYmTM5+A2cwCEhIHX7xghqiRlbh16DETxBxFiQe/vrNOYBSYhaRlFpKWBYxMqxiF
        EktychMzc9LLjfQSczP1kvNzNzFCgjt/B+PHj+aHGJk4GA8xSnAwK4nwmkndjxfiTUmsrEot
        yo8vKs1JLT7EKM3BoiTOu8r9aLyQQHpiSWp2ampBahFMlomDU6qB8fjM561cAVcazYK/yq3p
        XSNwovFamNfkoghHc/P/s7InNoqGXjUs3C5meevOwRVMR/Tl/GPkXqYrqU5cr2pbffGXSDWL
        TtfNQ7+udWuyXb1Z6Ny6dG2i/JOIE6unpSbyJcp+Z5Pbdua35nvpk1FLDAJNN+b/X/Soby/T
        Kb0NCxNvxizwrSr+osRSnJFoqMVcVJwIANsjPEBcAgAA
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
index 65cd25372020..9be69cbdab96 100644
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
+	/* Read from Chip if not from chip */
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
+	/* Read from Chip if not from device tree */
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

