Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7224F7C70
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244133AbiDGKLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244106AbiDGKLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:11:12 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0FA17288C;
        Thu,  7 Apr 2022 03:09:11 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EF01C6001A;
        Thu,  7 Apr 2022 10:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649326150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KjQVyusI/NoALoNPcEIOjSAiTZnq5f6jB56z0p4Letc=;
        b=CiiKhZRJKSZyARd5BOu5qMZ+Op7VRKn1MfqBUb9bwNiJnp9I3FfdrpmWAZAgUSu7Nxw9YH
        6Wo6VuUVRzlk51gHcu9ZPXspj6mFv5p9Me0JGMDV5V8qHZ95lJXia+ikdb5MIf+YG/zWri
        //xa4EePUiQVQPPUjmZMzHIMNsIICL777xHWly1l6+MwkK1UMjv5+3gc4BMs6pEJb6F31b
        RrYlm6rjpKA0aQzDbJCgCTRO1ETB1EanaMg4AJTKTiU6aa6mSQuRcWWKYrKEFXT6fB3e/3
        z2hR2B5SfRwXzsXnwwR66lMq2UWNKPkDnoyPMhMY7bKwGks8q76I7Xfvle0LtQ==
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
Subject: [PATCH v6 03/10] net: mac802154: Save a global error code on transmissions
Date:   Thu,  7 Apr 2022 12:08:56 +0200
Message-Id: <20220407100903.1695973-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
References: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
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

