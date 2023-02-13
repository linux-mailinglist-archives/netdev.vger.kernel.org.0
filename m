Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6EF694D7B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjBMQzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjBMQzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:55:02 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC0F20063;
        Mon, 13 Feb 2023 08:54:25 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 16BAA240006;
        Mon, 13 Feb 2023 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676307263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VcItgcpjdYGStTDDBNRcZBHTnvUfT0kMegrHxomcHyw=;
        b=WbVneJBcfJDQ8SakjRgGIOXGdgCLMUifLtnIV6F7NTyrK4umPi9XCKeaRqzB0v3vvnPjjb
        3AcEUbTvEXGR2ZKGMnsO0OaD/9prKJLhRF/Z0uq0GLzaAN9whJIpxhtnhun24PhldXJaBG
        wI+F797esUsr2tRFfSA/7NPxshxPrpL83owuiXxNTaDSph6uKf5HEtRco7BOR4mNjhAduP
        3p0ZhCJ6xCZtgg9CCmGMmVPvX6N38f5k2M4VuVNHQSQ9QlZ3yaa1YmCTUDAwGArfChkSpe
        2BqJ8Ssfte/BS5QW7xTVteIzj2LZ3AXddlM/62tn+NlmtroTiZWEsyNE3NRpLA==
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
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>
Subject: [PATCH wpan 4/6] mac802154: Send beacons using the MLME Tx path
Date:   Mon, 13 Feb 2023 17:54:12 +0100
Message-Id: <20230213165414.1168401-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
References: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using ieee802154_subif_start_xmit() to bypass the net queue when
sending beacons is broken because it does not acquire the
HARD_TX_LOCK(), hence not preventing datagram buffers to be smashed by
beacons upon contention situation. Using the mlme_tx helper is not the
best fit either but at least it is not buggy and has little-to-no
performance hit. More details are given in the comment explaining this
choice in the code.

Fixes: 18fa625292e9 ("mac802154: Handle basic beaconing")
Reported-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/scan.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index 8f98efec7753..fff41e59099e 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -326,7 +326,25 @@ static int mac802154_transmit_beacon(struct ieee802154_local *local,
 		return ret;
 	}
 
-	return ieee802154_subif_start_xmit(skb, sdata->dev);
+	/* Using the MLME transmission helper for sending beacons is a bit
+	 * overkill because we do not really care about the final outcome.
+	 *
+	 * Even though, going through the whole net stack with a regular
+	 * dev_queue_xmit() is not relevant either because we want beacons to be
+	 * sent "now" rather than go through the whole net stack scheduling
+	 * (qdisc & co).
+	 *
+	 * Finally, using ieee802154_subif_start_xmit() would only be an option
+	 * if we had a generic transmit helper which would acquire the
+	 * HARD_TX_LOCK() to prevent buffer handling conflicts with regular
+	 * packets.
+	 *
+	 * So for now we keep it simple and send beacons with our MLME helper,
+	 * even if it stops the ieee802154 queue entirely during these
+	 * transmissions, wich anyway does not have a huge impact on the
+	 * performances given the current design of the stack.
+	 */
+	return ieee802154_mlme_tx(local, sdata, skb);
 }
 
 void mac802154_beacon_worker(struct work_struct *work)
-- 
2.34.1

