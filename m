Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BC560DE2F
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiJZJfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiJZJfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:35:20 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A42B87B5;
        Wed, 26 Oct 2022 02:35:18 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 373CC20008;
        Wed, 26 Oct 2022 09:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666776913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ta0+wXqa6XOPcVnr/7JpSYm1H6aQ50LsVs8vTurfd/k=;
        b=U3gi7uKXwGd/bYubkZLXvPR8gazXm65Sg8jEbv5UvX4FOg7GjbPi9fMl3FPlJz2R/7y4AA
        5MTREdUVuqMfCFNeuJlSxEboZ32V7LXRe7NaBYv9EAdSG+RwgcUmZH2iGPAgdf5giHDI05
        fHbTz0HifBTwPOI+ZjkBp6eIt7Q1cPAxQ1Ce3R4lfx2AWw78KYefmUZee7q0Wn+4gtEppi
        mLsbS5El+jJpAnHKouHCJYBJ7H1AEh3bhNhIQ+mAF6scnGqtPFO7wObdHqG32+IrKG+uoU
        +XAZczh07NIZdO/DYB0yyjBS76u2CS5EOC3bYjucKQpGWH1PSjyC5lAcW+5tVQ==
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 3/3] mac802154: Allow the creation of coordinator interfaces
Date:   Wed, 26 Oct 2022 11:35:02 +0200
Message-Id: <20221026093502.602734-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221026093502.602734-1-miquel.raynal@bootlin.com>
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a first strep in introducing proper PAN management and association,
we need to be able to create coordinator interfaces which might act as
coordinator or PAN coordinator.

Hence, let's add the minimum support to allow the creation of these
interfaces.

Even though the necessary logic to handle several interfaces on the same
device is added to make this future move easier, in practice only
several interfaces of type MONITOR are allowed at the same time. The
other combinations are not allowed (interface creation is possible but
only one can be opened at a time) because, with a single PHY featuring a
single set of address filters, we cannot afford handling two distinct
interfaces (with different address filters or filtering requirements):
* Having 2 NODEs, 2 COORDs or 1 NODE + 1 COORD
  -> cannot work because the address filters would be different
* Having 1 MONITOR + either 1 NODE or 1 COORD
  -> cannot work because the filtering levels are incompatible

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/iface.c | 14 ++++++++------
 net/mac802154/main.c  |  2 +-
 net/mac802154/rx.c    | 11 +++++++----
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index f21132dd82cf..7de2f843379c 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -261,13 +261,13 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
 		if (nsdata != sdata && ieee802154_sdata_running(nsdata)) {
 			int ret;
 
-			/* TODO currently we don't support multiple node types
-			 * we need to run skb_clone at rx path. Check if there
-			 * exist really an use case if we need to support
-			 * multiple node types at the same time.
+			/* TODO currently we don't support multiple node/coord
+			 * types we need to run skb_clone at rx path. Check if
+			 * there exist really an use case if we need to support
+			 * multiple node/coord types at the same time.
 			 */
-			if (sdata->wpan_dev.iftype == NL802154_IFTYPE_NODE &&
-			    nsdata->wpan_dev.iftype == NL802154_IFTYPE_NODE)
+			if (sdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR &&
+			    nsdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR)
 				return -EBUSY;
 
 			/* check all phy mac sublayer settings are the same.
@@ -564,6 +564,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 	wpan_dev->short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
 
 	switch (type) {
+	case NL802154_IFTYPE_COORD:
 	case NL802154_IFTYPE_NODE:
 		ieee802154_be64_to_le64(&wpan_dev->extended_addr,
 					sdata->dev->dev_addr);
@@ -623,6 +624,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	ieee802154_le64_to_be64(ndev->perm_addr,
 				&local->hw.phy->perm_extended_addr);
 	switch (type) {
+	case NL802154_IFTYPE_COORD:
 	case NL802154_IFTYPE_NODE:
 		ndev->type = ARPHRD_IEEE802154;
 		if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 40fab08df24b..3ed31daf7b9c 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -107,7 +107,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	phy->supported.lbt = NL802154_SUPPORTED_BOOL_FALSE;
 
 	/* always supported */
-	phy->supported.iftypes = BIT(NL802154_IFTYPE_NODE);
+	phy->supported.iftypes = BIT(NL802154_IFTYPE_NODE) | BIT(NL802154_IFTYPE_COORD);
 
 	return &local->hw;
 }
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 9f3e72a278cb..95633ae45510 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -208,6 +208,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 	int ret;
 	struct ieee802154_sub_if_data *sdata;
 	struct ieee802154_hdr hdr;
+	struct sk_buff *skb2;
 
 	ret = ieee802154_parse_frame_start(skb, &hdr);
 	if (ret) {
@@ -217,7 +218,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 	}
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->wpan_dev.iftype != NL802154_IFTYPE_NODE)
+		if (sdata->wpan_dev.iftype == NL802154_IFTYPE_MONITOR)
 			continue;
 
 		if (!ieee802154_sdata_running(sdata))
@@ -230,9 +231,11 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 		    sdata->required_filtering == IEEE802154_FILTERING_4_FRAME_FIELDS)
 			continue;
 
-		ieee802154_subif_frame(sdata, skb, &hdr);
-		skb = NULL;
-		break;
+		skb2 = skb_clone(skb, GFP_ATOMIC);
+		if (skb2) {
+			skb2->dev = sdata->dev;
+			ieee802154_subif_frame(sdata, skb2, &hdr);
+		}
 	}
 }
 
-- 
2.34.1

