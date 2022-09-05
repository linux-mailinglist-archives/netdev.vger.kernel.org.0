Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763335ADA45
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiIEUep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiIEUeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:34:37 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B2E11C14;
        Mon,  5 Sep 2022 13:34:31 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 716D4FF810;
        Mon,  5 Sep 2022 20:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662410069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Slc468LkgD295RmgjsCMDnQxSjqHHsk9OAskcoT/osI=;
        b=mEQCKY4LgagvNOTC2/zUD/oEjt0zguGgI7g78AGr6ycg3BBcnQln/keuViDD9VTDyvZ24P
        NQwvPK13YthEabDCDH07BzraCQpnGPX3opBnnAqUwFdc9DiM0Qq5DSNOj4qf/DajsTos96
        wT24Jh23TyxYRHnlAXXOXCbxL0WnBuPTjS/lXSDUyFCM6/dn16Wcty3vb7V+hsr6Zq4Y4v
        z2MNKa2qbe1Zu80TNSSeLPXjDFlspmCWTrqNL01us3TwFWqrfbQqN9GP4JGiGFc+uGTG70
        h+Y0HCBPcFXC4mNn93/EssTBEKaxycnNrxsYmxhX74I3O1+v62oYp9Mnio0OHQ==
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
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan/next v3 7/9] net: mac802154: Ensure proper scan-level filtering
Date:   Mon,  5 Sep 2022 22:34:10 +0200
Message-Id: <20220905203412.1322947-8-miquel.raynal@bootlin.com>
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

We now have a fine grained filtering information so let's ensure proper
filtering in scan mode, which means that only beacons are processed.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/rx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 8a8c5a4a2f28..c43289c0fdd7 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -34,6 +34,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 		       struct sk_buff *skb, const struct ieee802154_hdr *hdr)
 {
 	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+	struct wpan_phy *wpan_phy = sdata->local->hw.phy;
 	__le16 span, sshort;
 	int rc;
 
@@ -42,6 +43,17 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 	span = wpan_dev->pan_id;
 	sshort = wpan_dev->short_addr;
 
+	/* Level 3 filtering: Only beacons are accepted during scans */
+	if (sdata->required_filtering == IEEE802154_FILTERING_3_SCAN &&
+	    sdata->required_filtering > wpan_phy->filtering) {
+		if (mac_cb(skb)->type != IEEE802154_FC_TYPE_BEACON) {
+			dev_dbg(&sdata->dev->dev,
+				"drop !beacon frame (0x%x) during scan\n",
+				mac_cb(skb)->type);
+			goto fail;
+		}
+	}
+
 	switch (mac_cb(skb)->dest.mode) {
 	case IEEE802154_ADDR_NONE:
 		if (hdr->source.mode != IEEE802154_ADDR_NONE)
-- 
2.34.1

