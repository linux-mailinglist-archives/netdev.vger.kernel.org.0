Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C595ADA3C
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiIEUei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiIEUe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:34:27 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39CE63A9;
        Mon,  5 Sep 2022 13:34:24 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6A388FF80B;
        Mon,  5 Sep 2022 20:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662410063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCOyVUT9nPRDqNBS6Kq1WeNEeLZAsG/UCFJ9RQuXs1A=;
        b=Bg7nftqoGZ5MiWnjG9lBQItMPOl5rfnkSqqV63LbWYXdk+lH76J6EL8JD3/ZFGLFZ2Os/4
        JNPVmUAwAKfKi0B4qaRcJvMMnD2IbfeZX6wvTqVzD4xPWP9FO0BoSHcjjF789yZHKBRFwg
        pcVxyUnZvOqhK+lYv4V4t6yMemIK3mLfcjTjWhGfvBVpfdkU4kmY717nbzkG+3oG4bxN9E
        L80KEWUs5AaVNyHR0uSRmeQmYG9kLasRPFkUay+5zL6yIpYYwaFj9B6YbI/9mxkyAjnFwE
        I18FvyCWbqNjYoAucPiQ/kRZQx5WR7qi0RqkLec+jtj5nvFge7IKkEAVVrNFoA==
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
Subject: [PATCH wpan/next v3 3/9] net: mac802154: set filter at drv_start()
Date:   Mon,  5 Sep 2022 22:34:06 +0200
Message-Id: <20220905203412.1322947-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h      |  7 +++-
 net/mac802154/cfg.c          |  3 +-
 net/mac802154/driver-ops.h   | 74 +++++++++++++++++++++++++++++++++++-
 net/mac802154/ieee802154_i.h |  4 ++
 net/mac802154/iface.c        | 44 ++++++++-------------
 net/mac802154/rx.c           |  7 +++-
 6 files changed, 106 insertions(+), 33 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 04b996895fc1..7129b404871e 100644
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
index 93df24f75572..363d465f816a 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -67,7 +67,8 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
 		goto wake_up;
 
 	/* restart hardware */
-	ret = drv_start(local);
+	ret = drv_start(local, local->phy->filtering,
+			&local->addr_filt);
 	if (ret)
 		return ret;
 
diff --git a/net/mac802154/driver-ops.h b/net/mac802154/driver-ops.h
index c9d54088a567..1cace614ba11 100644
--- a/net/mac802154/driver-ops.h
+++ b/net/mac802154/driver-ops.h
@@ -129,12 +129,84 @@ drv_set_promiscuous_mode(struct ieee802154_local *local, bool on)
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
+		/* TODO requires a different receive mode setup e.g.
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
+		/* may requested other filtering but for now
+		 * all hardware can support
+		 * IEEE802154_FILTERING_NONE only which is a kind of
+		 * "compatible" mode we just need to filter more in
+		 * mac802154 receive path.
+		 *
+		 * TODO: move to driver and hardware may return more
+		 * higher level filter if supported. Hardware may
+		 * require also a different order how register are
+		 * set which could currently be buggy, so all receive
+		 * parameter need to be moved to the start() callback
+		 * and let the driver go into the mode before it will
+		 * turn on receive handling.
+		 */
+		local->phy->filtering = IEEE802154_FILTERING_NONE;
+		break;
+	case IEEE802154_FILTERING_4_FRAME_FIELDS:
+		/* not error out here for now as if hw doesn't support
+		 * IEEE802154_HW_PROMISCUOUS it's in
+		 * IEEE802154_FILTERING_4_FRAME_FIELDS
+		 * we have only a problem if some user switches and do not
+		 * support IEEE802154_HW_PROMISCUOUS.
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
index 010365a6364e..6c6da0d624e0 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -26,6 +26,8 @@ struct ieee802154_local {
 	struct ieee802154_hw hw;
 	const struct ieee802154_ops *ops;
 
+	/* hardware address filter */
+	struct ieee802154_hw_addr_filt addr_filt;
 	/* ieee802154 phy */
 	struct wpan_phy *phy;
 
@@ -82,6 +84,8 @@ struct ieee802154_sub_if_data {
 	struct ieee802154_local *local;
 	struct net_device *dev;
 
+	enum ieee802154_filtering_level required_filtering;
+
 	unsigned long state;
 	char name[IFNAMSIZ];
 
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 500ed1b81250..bf95e710becc 100644
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
+	local->phy->filtering = sdata->required_filtering;
 
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
+		res = drv_start(local, local->phy->filtering,
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
+	if (sdata->required_filtering != nsdata->required_filtering)
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
+		sdata->required_filtering = IEEE802154_FILTERING_4_FRAME_FIELDS;
 		wpan_dev->header_ops = &ieee802154_header_ops;
 
 		mutex_init(&sdata->sec_mtx);
@@ -600,7 +588,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 	case NL802154_IFTYPE_MONITOR:
 		sdata->dev->needs_free_netdev = true;
 		sdata->dev->netdev_ops = &mac802154_monitor_ops;
-		wpan_dev->promiscuous_mode = true;
+		sdata->required_filtering = IEEE802154_FILTERING_NONE;
 		break;
 	default:
 		BUG();
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c0fd8d0c7f03..369ffd800abf 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -273,7 +273,12 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 	/* Check if transceiver doesn't validate the checksum.
 	 * If not we validate the checksum here.
 	 */
-	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM) {
+	/* TODO do whatever you want here if necessary to filter by
+	 * check on IEEE802154_FILTERING_NONE. And upcomming receive
+	 * path in which state the phy is e.g. scanning.
+	 */
+	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM ||
+	    local->phy->filtering == IEEE802154_FILTERING_NONE) {
 		crc = crc_ccitt(0, skb->data, skb->len);
 		if (crc) {
 			rcu_read_unlock();
-- 
2.34.1

