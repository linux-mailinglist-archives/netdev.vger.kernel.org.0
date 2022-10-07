Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86C45F7594
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJGIx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJGIxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:53:23 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AADB1176F1;
        Fri,  7 Oct 2022 01:53:22 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F3B811BF216;
        Fri,  7 Oct 2022 08:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665132800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAhlBTLSk9kODXAxIVraXLcKuNjmfn5Ql30eDQkz2Zk=;
        b=Ic6+sP8SgYnX6/da5OWUi7lNk4GaCXAIXX+NX+YaUbydGIxlrlW6YiIZUsduAHDScIk70S
        LTh5LRu3Ot37LeBdrVwzOkb4Kz9Ex3PegFZ2xndFo+r8YAIWQbuilEA6Ybum7OillqSzVU
        k8CgnupoGmhXN3zJsK+dnHHFsocoLmXcweuyOenm4v2+/9kfHv3DqoqOFmzcq7OJppvsBk
        hvamAAiuR918KSm/QMxuv48bCRrautFMfeJGrMCvueOPrDItYWS4wDf85JhXxxKuZ4Sn0K
        NX2W9nuuMfrL3Mb/oJfckAhn1McitWeDFRizYkipiB0zgDfApFMS+Fu4ZTYBqg==
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
Subject: [PATCH wpan/next v4 2/8] mac802154: move receive parameters above start
Date:   Fri,  7 Oct 2022 10:53:04 +0200
Message-Id: <20221007085310.503366-3-miquel.raynal@bootlin.com>
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

This patch moves all receive parameters above the drv_start()
functionality to make it accessibile in the drv_start() function.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/driver-ops.h | 210 ++++++++++++++++++-------------------
 1 file changed, 105 insertions(+), 105 deletions(-)

diff --git a/net/mac802154/driver-ops.h b/net/mac802154/driver-ops.h
index d23f0db98015..c9d54088a567 100644
--- a/net/mac802154/driver-ops.h
+++ b/net/mac802154/driver-ops.h
@@ -24,6 +24,111 @@ drv_xmit_sync(struct ieee802154_local *local, struct sk_buff *skb)
 	return local->ops->xmit_sync(&local->hw, skb);
 }
 
+static inline int drv_set_pan_id(struct ieee802154_local *local, __le16 pan_id)
+{
+	struct ieee802154_hw_addr_filt filt;
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->set_hw_addr_filt) {
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+
+	filt.pan_id = pan_id;
+
+	trace_802154_drv_set_pan_id(local, pan_id);
+	ret = local->ops->set_hw_addr_filt(&local->hw, &filt,
+					    IEEE802154_AFILT_PANID_CHANGED);
+	trace_802154_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline int
+drv_set_extended_addr(struct ieee802154_local *local, __le64 extended_addr)
+{
+	struct ieee802154_hw_addr_filt filt;
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->set_hw_addr_filt) {
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+
+	filt.ieee_addr = extended_addr;
+
+	trace_802154_drv_set_extended_addr(local, extended_addr);
+	ret = local->ops->set_hw_addr_filt(&local->hw, &filt,
+					    IEEE802154_AFILT_IEEEADDR_CHANGED);
+	trace_802154_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline int
+drv_set_short_addr(struct ieee802154_local *local, __le16 short_addr)
+{
+	struct ieee802154_hw_addr_filt filt;
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->set_hw_addr_filt) {
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+
+	filt.short_addr = short_addr;
+
+	trace_802154_drv_set_short_addr(local, short_addr);
+	ret = local->ops->set_hw_addr_filt(&local->hw, &filt,
+					    IEEE802154_AFILT_SADDR_CHANGED);
+	trace_802154_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline int
+drv_set_pan_coord(struct ieee802154_local *local, bool is_coord)
+{
+	struct ieee802154_hw_addr_filt filt;
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->set_hw_addr_filt) {
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+
+	filt.pan_coord = is_coord;
+
+	trace_802154_drv_set_pan_coord(local, is_coord);
+	ret = local->ops->set_hw_addr_filt(&local->hw, &filt,
+					    IEEE802154_AFILT_PANC_CHANGED);
+	trace_802154_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline int
+drv_set_promiscuous_mode(struct ieee802154_local *local, bool on)
+{
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->set_promiscuous_mode) {
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+
+	trace_802154_drv_set_promiscuous_mode(local, on);
+	ret = local->ops->set_promiscuous_mode(&local->hw, on);
+	trace_802154_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int drv_start(struct ieee802154_local *local)
 {
 	int ret;
@@ -138,93 +243,6 @@ drv_set_cca_ed_level(struct ieee802154_local *local, s32 mbm)
 	return ret;
 }
 
-static inline int drv_set_pan_id(struct ieee802154_local *local, __le16 pan_id)
-{
-	struct ieee802154_hw_addr_filt filt;
-	int ret;
-
-	might_sleep();
-
-	if (!local->ops->set_hw_addr_filt) {
-		WARN_ON(1);
-		return -EOPNOTSUPP;
-	}
-
-	filt.pan_id = pan_id;
-
-	trace_802154_drv_set_pan_id(local, pan_id);
-	ret = local->ops->set_hw_addr_filt(&local->hw, &filt,
-					    IEEE802154_AFILT_PANID_CHANGED);
-	trace_802154_drv_return_int(local, ret);
-	return ret;
-}
-
-static inline int
-drv_set_extended_addr(struct ieee802154_local *local, __le64 extended_addr)
-{
-	struct ieee802154_hw_addr_filt filt;
-	int ret;
-
-	might_sleep();
-
-	if (!local->ops->set_hw_addr_filt) {
-		WARN_ON(1);
-		return -EOPNOTSUPP;
-	}
-
-	filt.ieee_addr = extended_addr;
-
-	trace_802154_drv_set_extended_addr(local, extended_addr);
-	ret = local->ops->set_hw_addr_filt(&local->hw, &filt,
-					    IEEE802154_AFILT_IEEEADDR_CHANGED);
-	trace_802154_drv_return_int(local, ret);
-	return ret;
-}
-
-static inline int
-drv_set_short_addr(struct ieee802154_local *local, __le16 short_addr)
-{
-	struct ieee802154_hw_addr_filt filt;
-	int ret;
-
-	might_sleep();
-
-	if (!local->ops->set_hw_addr_filt) {
-		WARN_ON(1);
-		return -EOPNOTSUPP;
-	}
-
-	filt.short_addr = short_addr;
-
-	trace_802154_drv_set_short_addr(local, short_addr);
-	ret = local->ops->set_hw_addr_filt(&local->hw, &filt,
-					    IEEE802154_AFILT_SADDR_CHANGED);
-	trace_802154_drv_return_int(local, ret);
-	return ret;
-}
-
-static inline int
-drv_set_pan_coord(struct ieee802154_local *local, bool is_coord)
-{
-	struct ieee802154_hw_addr_filt filt;
-	int ret;
-
-	might_sleep();
-
-	if (!local->ops->set_hw_addr_filt) {
-		WARN_ON(1);
-		return -EOPNOTSUPP;
-	}
-
-	filt.pan_coord = is_coord;
-
-	trace_802154_drv_set_pan_coord(local, is_coord);
-	ret = local->ops->set_hw_addr_filt(&local->hw, &filt,
-					    IEEE802154_AFILT_PANC_CHANGED);
-	trace_802154_drv_return_int(local, ret);
-	return ret;
-}
-
 static inline int
 drv_set_csma_params(struct ieee802154_local *local, u8 min_be, u8 max_be,
 		    u8 max_csma_backoffs)
@@ -264,22 +282,4 @@ drv_set_max_frame_retries(struct ieee802154_local *local, s8 max_frame_retries)
 	return ret;
 }
 
-static inline int
-drv_set_promiscuous_mode(struct ieee802154_local *local, bool on)
-{
-	int ret;
-
-	might_sleep();
-
-	if (!local->ops->set_promiscuous_mode) {
-		WARN_ON(1);
-		return -EOPNOTSUPP;
-	}
-
-	trace_802154_drv_set_promiscuous_mode(local, on);
-	ret = local->ops->set_promiscuous_mode(&local->hw, on);
-	trace_802154_drv_return_int(local, ret);
-	return ret;
-}
-
 #endif /* __MAC802154_DRIVER_OPS */
-- 
2.34.1

