Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7C60495E
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiJSOg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiJSOgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:36:08 -0400
X-Greylist: delayed 6270 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Oct 2022 07:20:24 PDT
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C35A1C73DB;
        Wed, 19 Oct 2022 07:20:20 -0700 (PDT)
Received: from relay10.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::230])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 2E88BCE34D;
        Wed, 19 Oct 2022 13:45:52 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 508EC240015;
        Wed, 19 Oct 2022 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666187071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K3jtXA9OC9nO1gMEZNE7SPZvwDlncjWrkcD6y+WRAfg=;
        b=NxOHHtiNnutow+ZQ+pNcNMcFbfTqCzmpxPtKUhY0ufhk7aZdlAjk3GQzOY57A43NCOyDEs
        1PkIM+OhQ88jYECXgjqHj6+Tt/yVs8UMvrqTbzd73r7JJ0UN4FJb63OpQKPq4WcnR1wsEI
        2aqOqsDea6Yloj5rEUdDi2gXk9u99xxBb7CwNuBj7Nfv6slBIQuba+LI5mK40c0k2O/KMH
        Lz3YCPKO8Wofa6C0AHTTTnATTO3MtRz8ryGPbpYfu9tqakpFFtYfrytZeGqShK6hZnWd2I
        THFaXBuV81bbXX5JbQywfngC8vdafBwVqAnB3o5T5vpD23pW1kXf+/80Afe9JA==
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
Subject: [PATCH wpan-next v6 3/3] mac802154: Ensure proper scan-level filtering
Date:   Wed, 19 Oct 2022 15:44:23 +0200
Message-Id: <20221019134423.877169-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221019134423.877169-1-miquel.raynal@bootlin.com>
References: <20221019134423.877169-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We now have a fine grained filtering information so let's ensure proper
filtering in scan mode, which means that only beacons are processed.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/rx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index d1f7b8df41fe..dc9ca2c0ea84 100644
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
+				"drop non-beacon frame (0x%x) during scan\n",
+				mac_cb(skb)->type);
+			goto fail;
+		}
+	}
+
 	switch (mac_cb(skb)->dest.mode) {
 	case IEEE802154_ADDR_NONE:
 		if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
@@ -277,10 +289,6 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	ieee802154_monitors_rx(local, skb);
 
-	/* TODO: Handle upcomming receive path where the PHY is at the
-	 * IEEE802154_FILTERING_NONE level during a scan.
-	 */
-
 	/* Level 1 filtering: Check the FCS by software when relevant */
 	if (local->hw.phy->filtering == IEEE802154_FILTERING_NONE) {
 		crc = crc_ccitt(0, skb->data, skb->len);
-- 
2.34.1

