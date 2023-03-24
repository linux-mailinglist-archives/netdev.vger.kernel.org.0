Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256096C7CFC
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCXLGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjCXLGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:06:06 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F6B23653;
        Fri, 24 Mar 2023 04:06:05 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 822801C0019;
        Fri, 24 Mar 2023 11:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679655964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xpm9J1//h3pf1KRFo8vfe6W7cNzA/ZMeIybRxIKCmLs=;
        b=HNgt+9vjZ7rczNcxNcDA1sudpjxIgPVFLRga7uxvJvkNhqR7+dneVSo8HiAGEwGhkWw9r5
        v2Pag+JLkeXR6GVfxWFARTJMnmh8NCl/5MzisPnziw6eIUlwz3zTxSbkCFAy6g6xL4y62p
        I+vD0MyHUTIBNO38vTyaMI9WJSDDJIA6Wc6Qr44ObzMxgA2FJvJv8iggxqDtqKDbW7eOMq
        ebIE+t/T4L+XDw1rUIt3lBa8nBQw3VKBSIIc0nerUWsiWEtF2GD0USTeQ+yQ3H4VB1j+ev
        E8iYTgWg8WiOu5WnquWgJGEK4aU3USwdTFLCSUnX7BwbBE7nx2q2Vs5MaW4b/Q==
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
Subject: [PATCH wpan-next 1/2] net: ieee802154: Handle limited devices with only datagram support
Date:   Fri, 24 Mar 2023 12:05:57 +0100
Message-Id: <20230324110558.90707-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324110558.90707-1-miquel.raynal@bootlin.com>
References: <20230324110558.90707-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices, like HardMAC ones can be a bit limited in the way they
handle mac commands. In particular, they might just not support it at
all and instead only be able to transmit and receive regular data
packets. In this case, they cannot be used for any of the internal
management commands that we have introduced so far and must be flagged
accordingly.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   |  3 +++
 net/ieee802154/nl802154.c | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 0c2778a836db..e00057984489 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -178,12 +178,15 @@ wpan_phy_cca_cmp(const struct wpan_phy_cca *a, const struct wpan_phy_cca *b)
  *	setting.
  * @WPAN_PHY_FLAG_STATE_QUEUE_STOPPED: Indicates that the transmit queue was
  *	temporarily stopped.
+ * @WPAN_PHY_FLAG_DATAGRAMS_ONLY: Indicates that transceiver is only able to
+ *	send/receive datagrams.
  */
 enum wpan_phy_flags {
 	WPAN_PHY_FLAG_TXPOWER		= BIT(1),
 	WPAN_PHY_FLAG_CCA_ED_LEVEL	= BIT(2),
 	WPAN_PHY_FLAG_CCA_MODE		= BIT(3),
 	WPAN_PHY_FLAG_STATE_QUEUE_STOPPED = BIT(4),
+	WPAN_PHY_FLAG_DATAGRAMS_ONLY	= BIT(5),
 };
 
 struct wpan_phy {
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 0ecc49d9c8c9..052c1ecfa300 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1417,6 +1417,11 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY) {
+		NL_SET_ERR_MSG(info->extack, "PHY only supports datagrams");
+		return -EOPNOTSUPP;
+	}
+
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
@@ -1584,6 +1589,11 @@ nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
 		return -EPERM;
 	}
 
+	if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY) {
+		NL_SET_ERR_MSG(info->extack, "PHY only supports datagrams");
+		return -EOPNOTSUPP;
+	}
+
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
-- 
2.34.1

