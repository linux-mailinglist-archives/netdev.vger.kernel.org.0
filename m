Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E6F5635D9
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiGAOg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiGAOgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:36:07 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181BA42EE7;
        Fri,  1 Jul 2022 07:31:31 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E2578FF81C;
        Fri,  1 Jul 2022 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a+M4RqfY+ocOOrxrHKUiJ1Db5HIuxHJ2cY1HB8kPzds=;
        b=EB0UEnelF5DEaSNDip2QZXyxnfvQOTemeuUbnbSa1p33M6yq9aNKkYrxZhVrC1ZX8OIH2+
        X4S5/xJ8bfJrXWwOw/1fbNojSpmb8GVR9WZcA/E5KheNbKSGmySuyFoFR9dm3+LLmOHX/5
        EA5o+r2I0MSVFATM2tzpaTI59xhpPexlPT0Y/ZLV/cDoocl/W4BR/NdkVI7dQP2itwi9iK
        +e0dxlIZS0HuM6VTBD/LZ04EPgG5h279QSWnSnV/eHj4Q/H9fbjZQRCaQoF3GxYG5g7Psd
        wkm+xcSnwJbXkhrfqnSVU4wOj3fRkxqzIwH+O6sU+cykDv8qfQszoTBTfSHDcA==
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
Subject: [PATCH wpan-next 17/20] net: ieee802154: Handle limited devices with only datagram support
Date:   Fri,  1 Jul 2022 16:30:49 +0200
Message-Id: <20220701143052.1267509-18-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
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

Some devices, like HardMAC ones can be a bit limited in the way they
handle mac commands. In particular, they might just not support it at
all and instead only be able to transmit and receive regular data
packets. In this case, they cannot be used for any of the internal
management commands that we have introduced so far and must be flagged
accordingly.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   | 3 +++
 net/ieee802154/nl802154.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index d6ff60d900a9..20ac4df9dc7b 100644
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
index 00b03c33e826..b31a0bd36b08 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1404,6 +1404,9 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
 		return -EPERM;
 
+	if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY)
+		return -EOPNOTSUPP;
+
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
@@ -1585,6 +1588,9 @@ nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
 		return -EPERM;
 	}
 
+	if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY)
+		return -EOPNOTSUPP;
+
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
-- 
2.34.1

