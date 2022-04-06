Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9827D4F6717
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiDFRbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239153AbiDFRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:31:25 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B77251F1C;
        Wed,  6 Apr 2022 08:34:50 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 56977200012;
        Wed,  6 Apr 2022 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649259287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KjQVyusI/NoALoNPcEIOjSAiTZnq5f6jB56z0p4Letc=;
        b=e3h1nFX+0HQsgueFl5N2sCaJg3CZDnUKFAhArksGiGR4z24o2w/AN1/3pIJqQ73z5lLGYj
        Jh+Lxs46tpuOfg3KYalFNVDJUWaEfuqubwBhZfiyHkpYPBUMbQ0HW2zhA1nZ3Tp+pqvLaY
        XmwztizgWAnc+wLScjqEX4BJHqrqdJ+/4UqeBY7ggXkHq4H3K+j20idfnPyne33tJn1wOa
        tjiKpbhPCHdSMBF1YaPCfiW9BO1ZXQjt9kZqT8u6lij5qUCVScWG3DirLbLpj4OQFTtFkc
        BS+v5h7uNHkSIAe8+kUy3vRwWwgXXN0llphMi/kLjTMmHOD9GNlOFLowl2TEaw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v5 03/11] net: mac802154: Save a global error code on transmissions
Date:   Wed,  6 Apr 2022 17:34:33 +0200
Message-Id: <20220406153441.1667375-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
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

So far no error is returned from a failing transmission. However it
might sometimes be useful, and particularly easy to use during sync
transfers (for certain MLME commands). Let's create an internal variable
for that, global to the device. Right now only success are registered,
which is rather useless, but soon we will have more situations filling
this field.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 2 ++
 net/mac802154/util.c         | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 702560acc8ce..1381e6a5e180 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -56,6 +56,8 @@ struct ieee802154_local {
 
 	struct sk_buff *tx_skb;
 	struct work_struct tx_work;
+	/* A negative Linux error code or a null/positive MLME error status */
+	int tx_result;
 };
 
 enum {
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index f2078238718b..0bf46f174de3 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -58,8 +58,11 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 			      bool ifs_handling)
 {
+	struct ieee802154_local *local = hw_to_local(hw);
+
+	local->tx_result = IEEE802154_SUCCESS;
+
 	if (ifs_handling) {
-		struct ieee802154_local *local = hw_to_local(hw);
 		u8 max_sifs_size;
 
 		/* If transceiver sets CRC on his own we need to use lifs
-- 
2.27.0

