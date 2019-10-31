Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E47EAE30
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfJaLBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:01:34 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59474 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727366AbfJaLBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:01:05 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 66806C08AA;
        Thu, 31 Oct 2019 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572519662; bh=Q+UDeno5GnhmSyT5W8M9Y8gTmSOsEE9Q4RrmGSlZXyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ZK5LoStkqnbplKc8x9GSOGsuW2/ACUvLLh1+iWqHyzq951If9HCC4BO7kMmgOWGG6
         E963/BaYB8gy2oSXL6VkPvDwMy2GwGErebq26WgRb23+jk7SeXJPFBifEloP6TvFjR
         dUB9RHtMtQQXx6o14wBglNh5j4Tk9lTxAAdkdGxkT16/ByhXSCGrrdk3wdjcY2nspH
         A3brGQsGJAmVTt2s/BKq3qUCVA5p4EWw2tgxJcExmnn94Ho4zAyr7B2rA4IE5koteL
         f+u3A/EAvW8TYIhjfLmr4pRoOKycvun5GYGKImFYnOu+CiNq+dpCi5vCKrCU+kow+D
         OiG4na/hm/VAQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 17088A006E;
        Thu, 31 Oct 2019 11:01:00 +0000 (UTC)
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
Subject: [PATCH net v2 04/10] net: stmmac: selftests: Prevent false positives in filter tests
Date:   Thu, 31 Oct 2019 12:00:42 +0100
Message-Id: <dc16b10c11279308be7ac462980c9c67962d5bde.1572519070.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In L2 tests that filter packets by destination MAC address we need to
prevent false positives that can occur if we add an address that
collides with the existing ones.

To fix this, lets manually check if the new address to be added is
already present in the NIC and use a different one if so. For Hash
filtering this also envolves converting the address to the hash.

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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 134 +++++++++++++++------
 1 file changed, 94 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 0b5db52149bc..f3d8b9336b8e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -6,7 +6,9 @@
  * Author: Jose Abreu <joabreu@synopsys.com>
  */
 
+#include <linux/bitrev.h>
 #include <linux/completion.h>
+#include <linux/crc32.h>
 #include <linux/ethtool.h>
 #include <linux/ip.h>
 #include <linux/phy.h>
@@ -485,12 +487,48 @@ static int stmmac_filter_check(struct stmmac_priv *priv)
 	return -EOPNOTSUPP;
 }
 
+static bool stmmac_hash_check(struct stmmac_priv *priv, unsigned char *addr)
+{
+	int mc_offset = 32 - priv->hw->mcast_bits_log2;
+	struct netdev_hw_addr *ha;
+	u32 hash, hash_nr;
+
+	/* First compute the hash for desired addr */
+	hash = bitrev32(~crc32_le(~0, addr, 6)) >> mc_offset;
+	hash_nr = hash >> 5;
+	hash = 1 << (hash & 0x1f);
+
+	/* Now, check if it collides with any existing one */
+	netdev_for_each_mc_addr(ha, priv->dev) {
+		u32 nr = bitrev32(~crc32_le(~0, ha->addr, ETH_ALEN)) >> mc_offset;
+		if (((nr >> 5) == hash_nr) && ((1 << (nr & 0x1f)) == hash))
+			return false;
+	}
+
+	/* No collisions, address is good to go */
+	return true;
+}
+
+static bool stmmac_perfect_check(struct stmmac_priv *priv, unsigned char *addr)
+{
+	struct netdev_hw_addr *ha;
+
+	/* Check if it collides with any existing one */
+	netdev_for_each_uc_addr(ha, priv->dev) {
+		if (!memcmp(ha->addr, addr, ETH_ALEN))
+			return false;
+	}
+
+	/* No collisions, address is good to go */
+	return true;
+}
+
 static int stmmac_test_hfilt(struct stmmac_priv *priv)
 {
-	unsigned char gd_addr[ETH_ALEN] = {0x01, 0xee, 0xdd, 0xcc, 0xbb, 0xaa};
-	unsigned char bd_addr[ETH_ALEN] = {0x01, 0x01, 0x02, 0x03, 0x04, 0x05};
+	unsigned char gd_addr[ETH_ALEN] = {0xf1, 0xee, 0xdd, 0xcc, 0xbb, 0xaa};
+	unsigned char bd_addr[ETH_ALEN] = {0xf1, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct stmmac_packet_attrs attr = { };
-	int ret;
+	int ret, tries = 256;
 
 	ret = stmmac_filter_check(priv);
 	if (ret)
@@ -499,6 +537,16 @@ static int stmmac_test_hfilt(struct stmmac_priv *priv)
 	if (netdev_mc_count(priv->dev) >= priv->hw->multicast_filter_bins)
 		return -EOPNOTSUPP;
 
+	while (--tries) {
+		/* We only need to check the bd_addr for collisions */
+		bd_addr[ETH_ALEN - 1] = tries;
+		if (stmmac_hash_check(priv, bd_addr))
+			break;
+	}
+
+	if (!tries)
+		return -EOPNOTSUPP;
+
 	ret = dev_mc_add(priv->dev, gd_addr);
 	if (ret)
 		return ret;
@@ -523,13 +571,25 @@ static int stmmac_test_hfilt(struct stmmac_priv *priv)
 
 static int stmmac_test_pfilt(struct stmmac_priv *priv)
 {
-	unsigned char gd_addr[ETH_ALEN] = {0x00, 0x01, 0x44, 0x55, 0x66, 0x77};
-	unsigned char bd_addr[ETH_ALEN] = {0x08, 0x00, 0x22, 0x33, 0x44, 0x55};
+	unsigned char gd_addr[ETH_ALEN] = {0xf0, 0x01, 0x44, 0x55, 0x66, 0x77};
+	unsigned char bd_addr[ETH_ALEN] = {0xf0, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct stmmac_packet_attrs attr = { };
-	int ret;
+	int ret, tries = 256;
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
+	if (netdev_uc_count(priv->dev) >= priv->hw->unicast_filter_entries)
+		return -EOPNOTSUPP;
+
+	while (--tries) {
+		/* We only need to check the bd_addr for collisions */
+		bd_addr[ETH_ALEN - 1] = tries;
+		if (stmmac_perfect_check(priv, bd_addr))
+			break;
+	}
+
+	if (!tries)
+		return -EOPNOTSUPP;
 
 	ret = dev_uc_add(priv->dev, gd_addr);
 	if (ret)
@@ -553,39 +613,31 @@ static int stmmac_test_pfilt(struct stmmac_priv *priv)
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
-	unsigned char uc_addr[ETH_ALEN] = {0x00, 0x01, 0x44, 0x55, 0x66, 0x77};
-	unsigned char mc_addr[ETH_ALEN] = {0x01, 0x01, 0x44, 0x55, 0x66, 0x77};
+	unsigned char uc_addr[ETH_ALEN] = {0xf0, 0xff, 0xff, 0xff, 0xff, 0xff};
+	unsigned char mc_addr[ETH_ALEN] = {0xf1, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct stmmac_packet_attrs attr = { };
-	int ret;
+	int ret, tries = 256;
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
-	if (!priv->hw->multicast_filter_bins)
+	if (netdev_uc_count(priv->dev) >= priv->hw->unicast_filter_entries)
 		return -EOPNOTSUPP;
 
-	/* Remove all MC addresses */
-	__dev_mc_unsync(priv->dev, NULL);
-	stmmac_test_set_rx_mode(priv->dev);
+	while (--tries) {
+		/* We only need to check the mc_addr for collisions */
+		mc_addr[ETH_ALEN - 1] = tries;
+		if (stmmac_hash_check(priv, mc_addr))
+			break;
+	}
+
+	if (!tries)
+		return -EOPNOTSUPP;
 
 	ret = dev_uc_add(priv->dev, uc_addr);
 	if (ret)
-		goto cleanup;
+		return ret;
 
 	attr.dst = uc_addr;
 
@@ -602,30 +654,34 @@ static int stmmac_test_mcfilt(struct stmmac_priv *priv)
 
 cleanup:
 	dev_uc_del(priv->dev, uc_addr);
-	__dev_mc_sync(priv->dev, stmmac_dummy_sync, NULL);
-	stmmac_test_set_rx_mode(priv->dev);
 	return ret;
 }
 
 static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 {
-	unsigned char uc_addr[ETH_ALEN] = {0x00, 0x01, 0x44, 0x55, 0x66, 0x77};
-	unsigned char mc_addr[ETH_ALEN] = {0x01, 0x01, 0x44, 0x55, 0x66, 0x77};
+	unsigned char uc_addr[ETH_ALEN] = {0xf0, 0xff, 0xff, 0xff, 0xff, 0xff};
+	unsigned char mc_addr[ETH_ALEN] = {0xf1, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct stmmac_packet_attrs attr = { };
-	int ret;
+	int ret, tries = 256;
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
-	if (!priv->hw->multicast_filter_bins)
+	if (netdev_mc_count(priv->dev) >= priv->hw->multicast_filter_bins)
 		return -EOPNOTSUPP;
 
-	/* Remove all UC addresses */
-	__dev_uc_unsync(priv->dev, NULL);
-	stmmac_test_set_rx_mode(priv->dev);
+	while (--tries) {
+		/* We only need to check the uc_addr for collisions */
+		uc_addr[ETH_ALEN - 1] = tries;
+		if (stmmac_perfect_check(priv, uc_addr))
+			break;
+	}
+
+	if (!tries)
+		return -EOPNOTSUPP;
 
 	ret = dev_mc_add(priv->dev, mc_addr);
 	if (ret)
-		goto cleanup;
+		return ret;
 
 	attr.dst = mc_addr;
 
@@ -642,8 +698,6 @@ static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 
 cleanup:
 	dev_mc_del(priv->dev, mc_addr);
-	__dev_uc_sync(priv->dev, stmmac_dummy_sync, NULL);
-	stmmac_test_set_rx_mode(priv->dev);
 	return ret;
 }
 
-- 
2.7.4

