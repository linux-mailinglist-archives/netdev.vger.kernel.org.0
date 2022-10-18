Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735016032A0
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiJRSgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiJRSgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:36:45 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD8F9D535;
        Tue, 18 Oct 2022 11:36:42 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A413E20008;
        Tue, 18 Oct 2022 18:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666118201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=grM364ekM+RTKFnQQQrk0yN6QNYjgfQoSoxO5b/tbR0=;
        b=XPADs/sp0Av3U5NC/xC26cXVlM1glgiIiiGrjCeEY87Q/Go5GHG+tSXwQlM28EvEq4laz6
        DAqn9AFzK3DUnZ4tFJehK67G1kWkIjXlA6qLTaWmUUo9OplD+WOd96MNQXXwgcwvvrcXu5
        tBqVzLHjd1D4ujcHBHKddkPE1qMHiSY+qpuu1bgUmPecYN1DzSaNS7v+RlasBzVuoPYPdb
        B0f0Df9XTijjSN8TcYY1ny2cidRU/TCrBq9Scn0IyD7c8Z674cpAmy7D4bd0cLFvWKukY6
        8xvDq54ffqsfdLaMY2E8UnfMt03JpYR9qU3qLdOivpccxR9tQNMamLKbuoK4BA==
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
Subject: [PATCH wpan-next] mac802154: Allow the creation of coordinator interfaces
Date:   Tue, 18 Oct 2022 20:36:39 +0200
Message-Id: <20221018183639.806719-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
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

As a first strep in introducing proper PAN management and association,
we need to be able to create coordinator interfaces which might act as
coordinator or PAN coordinator.

Hence, let's add the minimum support to allow the creation of these
interfaces. This support will be improved later, in particular regarding
the filtering.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/iface.c | 14 ++++++++------
 net/mac802154/main.c  |  2 ++
 net/mac802154/rx.c    | 11 +++++++----
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index d9b50884d34e..682249f3369b 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -262,13 +262,13 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
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
-			if (wpan_dev->iftype == NL802154_IFTYPE_NODE &&
-			    nsdata->wpan_dev.iftype == NL802154_IFTYPE_NODE)
+			if (wpan_dev->iftype != NL802154_IFTYPE_MONITOR &&
+			    nsdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR)
 				return -EBUSY;
 
 			/* check all phy mac sublayer settings are the same.
@@ -565,6 +565,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 	wpan_dev->short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
 
 	switch (type) {
+	case NL802154_IFTYPE_COORD:
 	case NL802154_IFTYPE_NODE:
 		ieee802154_be64_to_le64(&wpan_dev->extended_addr,
 					sdata->dev->dev_addr);
@@ -624,6 +625,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	ieee802154_le64_to_be64(ndev->perm_addr,
 				&local->hw.phy->perm_extended_addr);
 	switch (type) {
+	case NL802154_IFTYPE_COORD:
 	case NL802154_IFTYPE_NODE:
 		ndev->type = ARPHRD_IEEE802154;
 		if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 40fab08df24b..d03ecb747afc 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -219,6 +219,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 	if (hw->flags & IEEE802154_HW_PROMISCUOUS)
 		local->phy->supported.iftypes |= BIT(NL802154_IFTYPE_MONITOR);
+	else
+		local->phy->supported.iftypes &= ~BIT(NL802154_IFTYPE_COORD);
 
 	rc = wpan_phy_register(local->phy);
 	if (rc < 0)
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 2ae23a2f4a09..aca348d7834b 100644
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
 
 	kfree_skb(skb);
-- 
2.34.1

