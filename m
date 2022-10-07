Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA175F7595
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJGIxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJGIx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:53:26 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD81115C19;
        Fri,  7 Oct 2022 01:53:24 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 139181BF217;
        Fri,  7 Oct 2022 08:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665132803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRhp4lVorJGBI3gu38yqOKha0/uLT4sMRBxfLKWwGKE=;
        b=QjQHBzi8jC8xoVVeaRYEM64E/DVRLkeACQwP4P+J7Swp/4TxrLUoxUW0E/im0fq/7sfekd
        chru8H3MbYcktXEg+H9BGEKepd0Xpdzc7EFBxx5LturuAuhI2dwHpqrAPiwTCC9iZk2h9t
        oewRGTwSH/A5si9J/ITiTMwViyjny9O1gIpsQSmwvXHl47OoqQZenX5M+tW5m+a32ijsL+
        3fZMh5U39nbGDzrS4uI3AhDBV8ll1XR2aP8bvscTPt91TY4DeelZGPNQGEy67b/97Yc43u
        75HAj7qso71pxnokuFxkp+QZUaQ2Pig/phg2lhdYSPgSmw/qItYGPVfJrHFhsA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan/next v4 3/8] mac802154: set filter at drv_start()
Date:   Fri,  7 Oct 2022 10:53:05 +0200
Message-Id: <20221007085310.503366-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221007085310.503366-1-miquel.raynal@bootlin.com>
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

The current filtering level is set on the first interface up on a wpan
phy. If we support scan functionality we need to change the filtering
level on the fly on an operational phy and switching back again.

This patch will move the receive mode parameter e.g. address filter and
promiscuous mode to the drv_start() functionality to allow changing the
receive mode on an operational phy not on first ifup only. In future this
should be handled on driver layer because each hardware has it's own way
to enter a specific filtering level. However this should offer to switch
to mode IEEE802154_FILTERING_NONE and back to
IEEE802154_FILTERING_4_FRAME_FIELDS.

Only IEEE802154_FILTERING_4_FRAME_FIELDS and IEEE802154_FILTERING_NONE
are somewhat supported by current hardware. All other filtering levels
can be supported in future but will end in IEEE802154_FILTERING_NONE as
the receive part can kind of "emulate" those receive paths by doing
additional filtering routines.

There are in total three filtering levels in the code:
- the per-interface default level (should not be changed)
- the required per-interface level (mac commands may play with it)
- the actual per-PHY (hw) level that is currently in use

Signed-off-by: Alexander Aring <aahringo@redhat.com>
[<miquel.raynal@bootlin.com: Add the third filtering variable]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h      |  7 +++-
 net/mac802154/cfg.c          |  2 +-
 net/mac802154/driver-ops.h   | 71 +++++++++++++++++++++++++++++++++++-
 net/mac802154/ieee802154_i.h | 12 ++++++
 net/mac802154/iface.c        | 44 ++++++++--------------
 net/mac802154/rx.c           | 12 +++++-
 6 files changed, 115 insertions(+), 33 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 428cece22205..e1481f9cf049 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -223,6 +223,11 @@ struct wpan_phy {
 	atomic_t hold_txs;
 	wait_queue_head_t sync_txq;
 
+	/* Current filtering level on reception.
+	 * Only allowed to be changed if phy is not operational.
+	 */
+	enum ieee802154_filtering_level filtering;
+
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
@@ -374,8 +379,6 @@ struct wpan_dev {
 
 	bool lbt;
 
-	bool promiscuous_mode;
-
 	/* fallback for acknowledgment bit setting */
 	bool ackreq;
 };
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index 93df24f75572..dc2d918fac68 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -67,7 +67,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
 		goto wake_up;
 
 	/* restart hardware */
-	ret = drv_start(local);
+	ret = drv_start(local, local->phy->filtering, &local->addr_filt);
 	if (ret)
 		return ret;
 
diff --git a/net/mac802154/driver-ops.h b/net/mac802154/driver-ops.h
index c9d54088a567..a7af3f0ddb3e 100644
--- a/net/mac802154/driver-ops.h
+++ b/net/mac802154/driver-ops.h
@@ -129,12 +129,81 @@ drv_set_promiscuous_mode(struct ieee802154_local *local, bool on)
 	return ret;
 }
 
-static inline int drv_start(struct ieee802154_local *local)
+static inline int drv_start(struct ieee802154_local *local,
+			    enum ieee802154_filtering_level level,
+			    const struct ieee802154_hw_addr_filt *addr_filt)
 {
 	int ret;
 
 	might_sleep();
 
+	/* setup receive mode parameters e.g. address mode */
+	if (local->hw.flags & IEEE802154_HW_AFILT) {
+		ret = drv_set_pan_id(local, addr_filt->pan_id);
+		if (ret < 0)
+			return ret;
+
+		ret = drv_set_short_addr(local, addr_filt->short_addr);
+		if (ret < 0)
+			return ret;
+
+		ret = drv_set_extended_addr(local, addr_filt->ieee_addr);
+		if (ret < 0)
+			return ret;
+	}
+
+	switch (level) {
+	case IEEE802154_FILTERING_NONE:
+		fallthrough;
+	case IEEE802154_FILTERING_1_FCS:
+		fallthrough;
+	case IEEE802154_FILTERING_2_PROMISCUOUS:
+		/* TODO: Requires a different receive mode setup e.g.
+		 * at86rf233 hardware.
+		 */
+		fallthrough;
+	case IEEE802154_FILTERING_3_SCAN:
+		if (local->hw.flags & IEEE802154_HW_PROMISCUOUS) {
+			ret = drv_set_promiscuous_mode(local, true);
+			if (ret < 0)
+				return ret;
+		} else {
+			return -EOPNOTSUPP;
+		}
+
+		/* In practice other filtering levels can be requested, but as
+		 * for now most hardware/drivers only support
+		 * IEEE802154_FILTERING_NONE, we fallback to this actual
+		 * filtering level in hardware and make our own additional
+		 * filtering in mac802154 receive path.
+		 *
+		 * TODO: Move this logic to the device drivers as hardware may
+		 * support more higher level filters. Hardware may also require
+		 * a different order how register are set, which could currently
+		 * be buggy, so all received parameters need to be moved to the
+		 * start() callback and let the driver go into the mode before
+		 * it will turn on receive handling.
+		 */
+		local->phy->filtering = IEEE802154_FILTERING_NONE;
+		break;
+	case IEEE802154_FILTERING_4_FRAME_FIELDS:
+		/* Do not error out if IEEE802154_HW_PROMISCUOUS because we
+		 * expect the hardware to operate at the level
+		 * IEEE802154_FILTERING_4_FRAME_FIELDS anyway.
+		 */
+		if (local->hw.flags & IEEE802154_HW_PROMISCUOUS) {
+			ret = drv_set_promiscuous_mode(local, false);
+			if (ret < 0)
+				return ret;
+		}
+
+		local->phy->filtering = IEEE802154_FILTERING_4_FRAME_FIELDS;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	trace_802154_drv_start(local);
 	local->started = true;
 	smp_mb();
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 010365a6364e..509e0172fe82 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -26,6 +26,8 @@ struct ieee802154_local {
 	struct ieee802154_hw hw;
 	const struct ieee802154_ops *ops;
 
+	/* hardware address filter */
+	struct ieee802154_hw_addr_filt addr_filt;
 	/* ieee802154 phy */
 	struct wpan_phy *phy;
 
@@ -82,6 +84,16 @@ struct ieee802154_sub_if_data {
 	struct ieee802154_local *local;
 	struct net_device *dev;
 
+	/* Each interface starts and works in nominal state at a given filtering
+	 * level given by iface_default_filtering, which is set once for all at
+	 * the interface creation and should not evolve over time. For some MAC
+	 * operations however, the filtering level may change temporarily, as
+	 * reflected in the required_filtering field. The actual filtering at
+	 * the PHY level may be different and is shown in struct wpan_phy.
+	 */
+	enum ieee802154_filtering_level iface_default_filtering;
+	enum ieee802154_filtering_level required_filtering;
+
 	unsigned long state;
 	char name[IFNAMSIZ];
 
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 500ed1b81250..d9b50884d34e 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -147,25 +147,12 @@ static int ieee802154_setup_hw(struct ieee802154_sub_if_data *sdata)
 	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
 	int ret;
 
-	if (local->hw.flags & IEEE802154_HW_PROMISCUOUS) {
-		ret = drv_set_promiscuous_mode(local,
-					       wpan_dev->promiscuous_mode);
-		if (ret < 0)
-			return ret;
-	}
+	sdata->required_filtering = sdata->iface_default_filtering;
 
 	if (local->hw.flags & IEEE802154_HW_AFILT) {
-		ret = drv_set_pan_id(local, wpan_dev->pan_id);
-		if (ret < 0)
-			return ret;
-
-		ret = drv_set_extended_addr(local, wpan_dev->extended_addr);
-		if (ret < 0)
-			return ret;
-
-		ret = drv_set_short_addr(local, wpan_dev->short_addr);
-		if (ret < 0)
-			return ret;
+		local->addr_filt.pan_id = wpan_dev->pan_id;
+		local->addr_filt.ieee_addr = wpan_dev->extended_addr;
+		local->addr_filt.short_addr = wpan_dev->short_addr;
 	}
 
 	if (local->hw.flags & IEEE802154_HW_LBT) {
@@ -206,7 +193,8 @@ static int mac802154_slave_open(struct net_device *dev)
 		if (res)
 			goto err;
 
-		res = drv_start(local);
+		res = drv_start(local, sdata->required_filtering,
+				&local->addr_filt);
 		if (res)
 			goto err;
 	}
@@ -223,15 +211,16 @@ static int mac802154_slave_open(struct net_device *dev)
 
 static int
 ieee802154_check_mac_settings(struct ieee802154_local *local,
-			      struct wpan_dev *wpan_dev,
-			      struct wpan_dev *nwpan_dev)
+			      struct ieee802154_sub_if_data *sdata,
+			      struct ieee802154_sub_if_data *nsdata)
 {
+	struct wpan_dev *nwpan_dev = &nsdata->wpan_dev;
+	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+
 	ASSERT_RTNL();
 
-	if (local->hw.flags & IEEE802154_HW_PROMISCUOUS) {
-		if (wpan_dev->promiscuous_mode != nwpan_dev->promiscuous_mode)
-			return -EBUSY;
-	}
+	if (sdata->iface_default_filtering != nsdata->iface_default_filtering)
+		return -EBUSY;
 
 	if (local->hw.flags & IEEE802154_HW_AFILT) {
 		if (wpan_dev->pan_id != nwpan_dev->pan_id ||
@@ -285,8 +274,7 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
 			/* check all phy mac sublayer settings are the same.
 			 * We have only one phy, different values makes trouble.
 			 */
-			ret = ieee802154_check_mac_settings(local, wpan_dev,
-							    &nsdata->wpan_dev);
+			ret = ieee802154_check_mac_settings(local, sdata, nsdata);
 			if (ret < 0)
 				return ret;
 		}
@@ -586,7 +574,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 		sdata->dev->priv_destructor = mac802154_wpan_free;
 		sdata->dev->netdev_ops = &mac802154_wpan_ops;
 		sdata->dev->ml_priv = &mac802154_mlme_wpan;
-		wpan_dev->promiscuous_mode = false;
+		sdata->iface_default_filtering = IEEE802154_FILTERING_4_FRAME_FIELDS;
 		wpan_dev->header_ops = &ieee802154_header_ops;
 
 		mutex_init(&sdata->sec_mtx);
@@ -600,7 +588,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 	case NL802154_IFTYPE_MONITOR:
 		sdata->dev->needs_free_netdev = true;
 		sdata->dev->netdev_ops = &mac802154_monitor_ops;
-		wpan_dev->promiscuous_mode = true;
+		sdata->iface_default_filtering = IEEE802154_FILTERING_NONE;
 		break;
 	default:
 		BUG();
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c0fd8d0c7f03..b68d62335f66 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -270,10 +270,20 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	ieee802154_monitors_rx(local, skb);
 
+	/* TODO: Avoid delivering frames received at the level
+	 * IEEE802154_FILTERING_NONE on interfaces not expecting it because of
+	 * the missing auto ACK handling feature.
+	 */
+
+	/* TODO: Handle upcomming receive path where the PHY is at the
+	 * IEEE802154_FILTERING_NONE level during a scan.
+	 */
+
 	/* Check if transceiver doesn't validate the checksum.
 	 * If not we validate the checksum here.
 	 */
-	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM) {
+	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM ||
+	    local->phy->filtering == IEEE802154_FILTERING_NONE) {
 		crc = crc_ccitt(0, skb->data, skb->len);
 		if (crc) {
 			rcu_read_unlock();
-- 
2.34.1

