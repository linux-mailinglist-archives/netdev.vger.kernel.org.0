Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B142E8A79
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389239AbfJ2OPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:15:23 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:53408 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389225AbfJ2OPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 10:15:22 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 373A7C04DB;
        Tue, 29 Oct 2019 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572358521; bh=w+35Zm06nbcsSx34hHesT2HOr9i1dwp2O4opUncMwW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=jdji5QQ85lQV6kLB27iYYOpkvhjJ9r+r5mnM9v07NDAonbXKiXPyuypJDcMY4RMQB
         AQVXt3MtHcgpkJCE1IO54DtsRz9D1Ux4jDrZB+GkpF4XYrx1CBWGheJMNzsXnZKGgI
         ROmXuQZ2MaeJRkYSkcGA7+IO2hGY23ebA2riaNQiIKzPSGk506u5S6o/muStcbaPLT
         oDAM1Wwfxg1b0pJ4/czoLjPkMRPAzVrLhj56UyfEyyYLxTWJJDiD/upJfG8EbELHqC
         yWpSA4EMj8mFiJ1eHI0Q5QKISqAx34ekxloTVnfKuqSlpAPm+DEb76y2oo8C1Eugb7
         QViggvTYJ+yow==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id D060EA006D;
        Tue, 29 Oct 2019 14:15:14 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 4/9] net: stmmac: selftests: Must remove UC/MC addresses to prevent false positives
Date:   Tue, 29 Oct 2019 15:14:48 +0100
Message-Id: <36d9af9080068c4e38cf50e80b6f2a5eafc9ed99.1572355609.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In L2 tests that filter packets by destination MAC address we need to
remove all addresses that are currently in the device so that we don't
get false positives when running the tests.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 104 +++++++++++++++------
 1 file changed, 76 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 0b5db52149bc..bcc902f44318 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -490,6 +490,8 @@ static int stmmac_test_hfilt(struct stmmac_priv *priv)
 	unsigned char gd_addr[ETH_ALEN] = {0x01, 0xee, 0xdd, 0xcc, 0xbb, 0xaa};
 	unsigned char bd_addr[ETH_ALEN] = {0x01, 0x01, 0x02, 0x03, 0x04, 0x05};
 	struct stmmac_packet_attrs attr = { };
+	struct net_device *dummy_dev;
+	struct netdev_hw_addr *ha;
 	int ret;
 
 	ret = stmmac_filter_check(priv);
@@ -499,9 +501,18 @@ static int stmmac_test_hfilt(struct stmmac_priv *priv)
 	if (netdev_mc_count(priv->dev) >= priv->hw->multicast_filter_bins)
 		return -EOPNOTSUPP;
 
+	dummy_dev = alloc_etherdev(0);
+	if (!dummy_dev)
+		return -ENOMEM;
+
+	/* Remove all MC addresses */
+	netdev_for_each_mc_addr(ha, priv->dev)
+		dev_mc_add(dummy_dev, ha->addr);
+	dev_mc_flush(priv->dev);
+
 	ret = dev_mc_add(priv->dev, gd_addr);
 	if (ret)
-		return ret;
+		goto sync;
 
 	attr.dst = gd_addr;
 
@@ -518,6 +529,11 @@ static int stmmac_test_hfilt(struct stmmac_priv *priv)
 
 cleanup:
 	dev_mc_del(priv->dev, gd_addr);
+sync:
+	/* Restore MC addresses */
+	netdev_for_each_mc_addr(ha, dummy_dev)
+		dev_mc_add(priv->dev, ha->addr);
+	free_netdev(dummy_dev);
 	return ret;
 }
 
@@ -526,14 +542,25 @@ static int stmmac_test_pfilt(struct stmmac_priv *priv)
 	unsigned char gd_addr[ETH_ALEN] = {0x00, 0x01, 0x44, 0x55, 0x66, 0x77};
 	unsigned char bd_addr[ETH_ALEN] = {0x08, 0x00, 0x22, 0x33, 0x44, 0x55};
 	struct stmmac_packet_attrs attr = { };
+	struct net_device *dummy_dev;
+	struct netdev_hw_addr *ha;
 	int ret;
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
 
+	dummy_dev = alloc_etherdev(0);
+	if (!dummy_dev)
+		return -ENOMEM;
+
+	/* Remove all UC addresses */
+	netdev_for_each_uc_addr(ha, priv->dev)
+		dev_uc_add(dummy_dev, ha->addr);
+	dev_uc_flush(priv->dev);
+
 	ret = dev_uc_add(priv->dev, gd_addr);
 	if (ret)
-		return ret;
+		goto sync;
 
 	attr.dst = gd_addr;
 
@@ -550,28 +577,21 @@ static int stmmac_test_pfilt(struct stmmac_priv *priv)
 
 cleanup:
 	dev_uc_del(priv->dev, gd_addr);
+sync:
+	/* Restore UC addresses */
+	netdev_for_each_uc_addr(ha, dummy_dev)
+		dev_uc_add(priv->dev, ha->addr);
+	free_netdev(dummy_dev);
 	return ret;
 }
 
-static int stmmac_dummy_sync(struct net_device *netdev, const u8 *addr)
-{
-	return 0;
-}
-
-static void stmmac_test_set_rx_mode(struct net_device *netdev)
-{
-	/* As we are in test mode of ethtool we already own the rtnl lock
-	 * so no address will change from user. We can just call the
-	 * ndo_set_rx_mode() callback directly */
-	if (netdev->netdev_ops->ndo_set_rx_mode)
-		netdev->netdev_ops->ndo_set_rx_mode(netdev);
-}
-
 static int stmmac_test_mcfilt(struct stmmac_priv *priv)
 {
 	unsigned char uc_addr[ETH_ALEN] = {0x00, 0x01, 0x44, 0x55, 0x66, 0x77};
 	unsigned char mc_addr[ETH_ALEN] = {0x01, 0x01, 0x44, 0x55, 0x66, 0x77};
 	struct stmmac_packet_attrs attr = { };
+	struct net_device *dummy_dev;
+	struct netdev_hw_addr *ha;
 	int ret;
 
 	if (stmmac_filter_check(priv))
@@ -579,13 +599,21 @@ static int stmmac_test_mcfilt(struct stmmac_priv *priv)
 	if (!priv->hw->multicast_filter_bins)
 		return -EOPNOTSUPP;
 
-	/* Remove all MC addresses */
-	__dev_mc_unsync(priv->dev, NULL);
-	stmmac_test_set_rx_mode(priv->dev);
+	dummy_dev = alloc_etherdev(0);
+	if (!dummy_dev)
+		return -ENOMEM;
+
+	/* Remove all UC and MC addresses */
+	netdev_for_each_uc_addr(ha, priv->dev)
+		dev_uc_add(dummy_dev, ha->addr);
+	netdev_for_each_mc_addr(ha, priv->dev)
+		dev_mc_add(dummy_dev, ha->addr);
+	dev_uc_flush(priv->dev);
+	dev_mc_flush(priv->dev);
 
 	ret = dev_uc_add(priv->dev, uc_addr);
 	if (ret)
-		goto cleanup;
+		goto sync;
 
 	attr.dst = uc_addr;
 
@@ -602,8 +630,13 @@ static int stmmac_test_mcfilt(struct stmmac_priv *priv)
 
 cleanup:
 	dev_uc_del(priv->dev, uc_addr);
-	__dev_mc_sync(priv->dev, stmmac_dummy_sync, NULL);
-	stmmac_test_set_rx_mode(priv->dev);
+sync:
+	/* Restore UC and MC addresses */
+	netdev_for_each_uc_addr(ha, dummy_dev)
+		dev_uc_add(priv->dev, ha->addr);
+	netdev_for_each_mc_addr(ha, dummy_dev)
+		dev_mc_add(priv->dev, ha->addr);
+	free_netdev(dummy_dev);
 	return ret;
 }
 
@@ -612,6 +645,8 @@ static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 	unsigned char uc_addr[ETH_ALEN] = {0x00, 0x01, 0x44, 0x55, 0x66, 0x77};
 	unsigned char mc_addr[ETH_ALEN] = {0x01, 0x01, 0x44, 0x55, 0x66, 0x77};
 	struct stmmac_packet_attrs attr = { };
+	struct net_device *dummy_dev;
+	struct netdev_hw_addr *ha;
 	int ret;
 
 	if (stmmac_filter_check(priv))
@@ -619,13 +654,21 @@ static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 	if (!priv->hw->multicast_filter_bins)
 		return -EOPNOTSUPP;
 
-	/* Remove all UC addresses */
-	__dev_uc_unsync(priv->dev, NULL);
-	stmmac_test_set_rx_mode(priv->dev);
+	dummy_dev = alloc_etherdev(0);
+	if (!dummy_dev)
+		return -ENOMEM;
+
+	/* Remove all UC and MC addresses */
+	netdev_for_each_uc_addr(ha, priv->dev)
+		dev_uc_add(dummy_dev, ha->addr);
+	netdev_for_each_mc_addr(ha, priv->dev)
+		dev_mc_add(dummy_dev, ha->addr);
+	dev_uc_flush(priv->dev);
+	dev_mc_flush(priv->dev);
 
 	ret = dev_mc_add(priv->dev, mc_addr);
 	if (ret)
-		goto cleanup;
+		goto sync;
 
 	attr.dst = mc_addr;
 
@@ -642,8 +685,13 @@ static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 
 cleanup:
 	dev_mc_del(priv->dev, mc_addr);
-	__dev_uc_sync(priv->dev, stmmac_dummy_sync, NULL);
-	stmmac_test_set_rx_mode(priv->dev);
+sync:
+	/* Restore UC and MC addresses */
+	netdev_for_each_uc_addr(ha, dummy_dev)
+		dev_uc_add(priv->dev, ha->addr);
+	netdev_for_each_mc_addr(ha, dummy_dev)
+		dev_mc_add(priv->dev, ha->addr);
+	free_netdev(dummy_dev);
 	return ret;
 }
 
-- 
2.7.4

