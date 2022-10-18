Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C54360329B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiJRSft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJRSfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:35:48 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD8987FA5;
        Tue, 18 Oct 2022 11:35:45 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D9097240005;
        Tue, 18 Oct 2022 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666118144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=f9v9AXm9wprdn9biVpha9awd8UfQaoNNNblXXhJgyzg=;
        b=FpbJ49GtvG4kRgpgFPSmJl1njhPmfEKcI38s+PzspaltBoxwtU+13bJHuM5mUneGqO/+1Y
        F8bz5hkWxooJYkgn8NCgoOoIj4bBFxHSeBlWnMxtsvSxlGk4N4aTgk9qwx0c2Md2CBWLiK
        5QnbF7wCgzoJcUzmYHDEGSdg4s5Baa4dj5J/Lk0cAXGjWTTH+sYYxTlVBbcVvIhN+iTW8x
        WPex0/rq9Ug3je9gzUMujPckuYWIO9ca+FopPMs0dWvQnCIVEGAeWIwM5mz7/KFgtKUgOl
        LUV4IvMvlj4jrNl3btgabd1OhAr/sa3PNUNwwRn2znPSjaHOM9j1dco9qSoOqA==
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
Subject: [PATCH wpan-next v5] mac802154: Ensure proper scan-level filtering
Date:   Tue, 18 Oct 2022 20:35:40 +0200
Message-Id: <20221018183540.806471-1-miquel.raynal@bootlin.com>
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

We now have a fine grained filtering information so let's ensure proper
filtering in scan mode, which means that only beacons are processed.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---

Changes in v4:
* dev_dbg call with: s/!beacon/non-beacon/.
* Rebased on top of wpan-next but there is still a commit that has not
  been merged (went through a fixes PR), but is already in Linus' tree
  and was present in my branch when I generated this patch.

 net/mac802154/rx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 14bc646b9ab7..2ae23a2f4a09 100644
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
 		if (hdr->source.mode != IEEE802154_ADDR_NONE)
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

