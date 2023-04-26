Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD906EF8D9
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 18:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbjDZQ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 12:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjDZQ6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 12:58:42 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B06B7AAB
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 09:58:38 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 242AC1C0005;
        Wed, 26 Apr 2023 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1682528317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5WKYrvjQ3I2gze9n0yKF2pJQTDm1xxuPw8LJRuG9Vdk=;
        b=llrjV3HypGN3pgqzOyoJ/A930w/0qgdtVOXJmgAbxLU04EbApWXXSLrFDFFd5THiOpKVeE
        zghRfxovqDM0Hg1ZIl/Y7RNSWjNTphqbsTYdfiNQtImyL761gBOlk7wonwzdBDIcy64hjZ
        lbugeHlJZ09JtEEeICVVBhwFkWmQcPxMGfBdBXEBv6mmRNc3YxzZ78eCMpBQbKasIIlI5k
        r8wurjEr6YYuRmeI3ei/t6ZoOCEEEz3bfq1dluYjRjWibzGgJCn/UALVV/pWloQkFonycZ
        UwZDk88KSjw3PkdJCs4ne8/i934i5s0IsUfSZMsN2U410EWzfsbAKtSzmhz07g==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     glipus@gmail.com
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com
Subject: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
Date:   Wed, 26 Apr 2023 18:58:35 +0200
Message-Id: <20230426165835.443259-1-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230423032437.285014-1-glipus@gmail.com>
References: <20230423032437.285014-1-glipus@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kory Maincent <kory.maincent@bootlin.com>

You patch series work on my side with the macb MAC controller and this
patch.
I don't know if you are waiting for more reviews but it seems good enough
to drop the RFC tag.

---

 drivers/net/ethernet/cadence/macb.h      | 10 ++++++--
 drivers/net/ethernet/cadence/macb_main.c | 15 ++++--------
 drivers/net/ethernet/cadence/macb_ptp.c  | 30 ++++++++++++++----------
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index cfbdd0022764..bc73b080093e 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1350,8 +1350,14 @@ static inline void gem_ptp_do_rxstamp(struct macb *bp, struct sk_buff *skb, stru
 
 	gem_ptp_rxstamp(bp, skb, desc);
 }
-int gem_get_hwtst(struct net_device *dev, struct ifreq *rq);
-int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd);
+
+int gem_get_hwtst(struct net_device *dev,
+		  struct kernel_hwtstamp_config *kernel_config,
+		  struct netlink_ext_ack *extack);
+int gem_set_hwtst(struct net_device *dev,
+		  struct kernel_hwtstamp_config *kernel_config,
+		  struct netlink_ext_ack *extack);
+
 #else
 static inline void gem_ptp_init(struct net_device *ndev) { }
 static inline void gem_ptp_remove(struct net_device *ndev) { }
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 45f63df5bdc4..c1d65be88835 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3402,8 +3402,6 @@ static struct macb_ptp_info gem_ptp_info = {
 	.get_ptp_max_adj = gem_get_ptp_max_adj,
 	.get_tsu_rate	 = gem_get_tsu_rate,
 	.get_ts_info	 = gem_get_ts_info,
-	.get_hwtst	 = gem_get_hwtst,
-	.set_hwtst	 = gem_set_hwtst,
 };
 #endif
 
@@ -3764,15 +3762,6 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	if (!netif_running(dev))
 		return -EINVAL;
 
-	if (!phy_has_hwtstamp(dev->phydev) && bp->ptp_info) {
-		switch (cmd) {
-		case SIOCSHWTSTAMP:
-			return bp->ptp_info->set_hwtst(dev, rq, cmd);
-		case SIOCGHWTSTAMP:
-			return bp->ptp_info->get_hwtst(dev, rq);
-		}
-	}
-
 	return phylink_mii_ioctl(bp->phylink, rq, cmd);
 }
 
@@ -3875,6 +3864,10 @@ static const struct net_device_ops macb_netdev_ops = {
 #endif
 	.ndo_set_features	= macb_set_features,
 	.ndo_features_check	= macb_features_check,
+#ifdef CONFIG_MACB_USE_HWSTAMP
+	.ndo_hwtstamp_get	= gem_get_hwtst,
+	.ndo_hwtstamp_set	= gem_set_hwtst,
+#endif
 };
 
 /* Configure peripheral capabilities according to device tree
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 51d26fa190d7..eddacc5df435 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -374,19 +374,22 @@ static int gem_ptp_set_ts_mode(struct macb *bp,
 	return 0;
 }
 
-int gem_get_hwtst(struct net_device *dev, struct ifreq *rq)
+int gem_get_hwtst(struct net_device *dev,
+		  struct kernel_hwtstamp_config *kernel_config,
+		  struct netlink_ext_ack *extack)
 {
 	struct hwtstamp_config *tstamp_config;
 	struct macb *bp = netdev_priv(dev);
 
+	if (phy_has_hwtstamp(dev->phydev))
+		return phylink_mii_ioctl(bp->phylink, kernel_config->ifr, SIOCGHWTSTAMP);
+
 	tstamp_config = &bp->tstamp_config;
 	if ((bp->hw_dma_cap & HW_DMA_CAP_PTP) == 0)
 		return -EOPNOTSUPP;
 
-	if (copy_to_user(rq->ifr_data, tstamp_config, sizeof(*tstamp_config)))
-		return -EFAULT;
-	else
-		return 0;
+	hwtstamp_config_to_kernel(kernel_config, tstamp_config);
+	return 0;
 }
 
 static void gem_ptp_set_one_step_sync(struct macb *bp, u8 enable)
@@ -401,7 +404,9 @@ static void gem_ptp_set_one_step_sync(struct macb *bp, u8 enable)
 		macb_writel(bp, NCR, reg_val & ~MACB_BIT(OSSMODE));
 }
 
-int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
+int gem_set_hwtst(struct net_device *dev,
+		  struct kernel_hwtstamp_config *kernel_config,
+		  struct netlink_ext_ack *extack)
 {
 	enum macb_bd_control tx_bd_control = TSTAMP_DISABLED;
 	enum macb_bd_control rx_bd_control = TSTAMP_DISABLED;
@@ -409,13 +414,14 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct macb *bp = netdev_priv(dev);
 	u32 regval;
 
+	if (phy_has_hwtstamp(dev->phydev))
+		return phylink_mii_ioctl(bp->phylink, kernel_config->ifr, SIOCSHWTSTAMP);
+
 	tstamp_config = &bp->tstamp_config;
 	if ((bp->hw_dma_cap & HW_DMA_CAP_PTP) == 0)
 		return -EOPNOTSUPP;
 
-	if (copy_from_user(tstamp_config, ifr->ifr_data,
-			   sizeof(*tstamp_config)))
-		return -EFAULT;
+	hwtstamp_config_from_kernel(tstamp_config, kernel_config);
 
 	switch (tstamp_config->tx_type) {
 	case HWTSTAMP_TX_OFF:
@@ -466,9 +472,7 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (gem_ptp_set_ts_mode(bp, tx_bd_control, rx_bd_control) != 0)
 		return -ERANGE;
 
-	if (copy_to_user(ifr->ifr_data, tstamp_config, sizeof(*tstamp_config)))
-		return -EFAULT;
-	else
-		return 0;
+	hwtstamp_config_to_kernel(kernel_config, tstamp_config);
+	return 0;
 }
 
-- 
2.25.1

