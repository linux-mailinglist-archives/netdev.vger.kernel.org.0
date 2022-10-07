Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDCA5F7593
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJGIx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJGIxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:53:22 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B511162FD;
        Fri,  7 Oct 2022 01:53:19 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C6A831BF205;
        Fri,  7 Oct 2022 08:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665132798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7MK4V10vbFBI3AVz/S5EIiJ3u8faPmx5sl9OTZrAey8=;
        b=l1WnnvBJefmFixPzXoOWMOLFXzYwFbGxjxipYE8GAPr6uYTP3vUCf7GYFOtyStme657wYO
        6ptRUehfkqfRU5TAsEzQ9HlcSBm7VFeforDE5OT3rC8p3qfdxDrBqSp12VNpEtRzB+SuXg
        d4otfNjb4H4H+xLlwP+cySilkpFCilsBr7DBKUvM282oqLWRLQgCKHHUpCVFQgrDbFv1vf
        hhbsvW7kuWW7VU5vI/uuc7l5uQrYHo3leocvJzEZidnJnKcutwqnLIGj/GfFW0bJettiU1
        WnmlgPpthXK2akjkpJfy2S4az3fM2cwOckwKQGgZw0sCd4p342Hdh0WkSqJ3ZA==
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
Subject: [PATCH wpan/next v4 1/8] mac802154: Introduce filtering levels
Date:   Fri,  7 Oct 2022 10:53:03 +0200
Message-Id: <20221007085310.503366-2-miquel.raynal@bootlin.com>
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

The 802154 specification details several filtering levels in which the
PHY and the MAC could be. The amount of filtering will vary if they are
in promiscuous mode or in scanning mode. Otherwise they are expected to
do some very basic checks, such as enforcing the frame validity. Either
the PHY is able to do so, and the MAC has nothing to do, or the PHY has
a lower filtering level than expected and the MAC should take over.

For now we just define these levels in an enumeration.

In a second time, we will add a per-PHY parameter showing the expected
filtering level as well as a per device current filtering level, and
will initialize all these fields.

In a third time, we will use them to apply more filtering by software
when the PHY is limited.

Indeed, if the drivers know they cannot reach the requested level of
filtering, they will overwrite the "current filtering" parameter so that
it reflects what they do. Then, in the core, the expected filtering
level will be used to decide whether some additional software processing
is needed or not.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/ieee802154.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
index f1f9412b6ac6..0303eb84d596 100644
--- a/include/linux/ieee802154.h
+++ b/include/linux/ieee802154.h
@@ -276,6 +276,30 @@ enum {
 	IEEE802154_SYSTEM_ERROR = 0xff,
 };
 
+/**
+ * enum ieee802154_filtering_level - Filtering levels applicable to a PHY
+ *
+ * @IEEE802154_FILTERING_NONE: No filtering at all, what is received is
+ *	forwarded to the softMAC
+ * @IEEE802154_FILTERING_1_FCS: First filtering level, frames with an invalid
+ *	FCS should be dropped
+ * @IEEE802154_FILTERING_2_PROMISCUOUS: Second filtering level, promiscuous
+ *	mode as described in the spec, identical in terms of filtering to the
+ *	level one on PHY side, but at the MAC level the frame should be
+ *	forwarded to the upper layer directly
+ * @IEEE802154_FILTERING_3_SCAN: Third filtering level, scan related, where
+ *	only beacons must be processed, all remaining traffic gets dropped
+ * @IEEE802154_FILTERING_4_FRAME_FIELDS: Fourth filtering level actually
+ *	enforcing the validity of the content of the frame with various checks
+ */
+enum ieee802154_filtering_level {
+	IEEE802154_FILTERING_NONE,
+	IEEE802154_FILTERING_1_FCS,
+	IEEE802154_FILTERING_2_PROMISCUOUS,
+	IEEE802154_FILTERING_3_SCAN,
+	IEEE802154_FILTERING_4_FRAME_FIELDS,
+};
+
 /* frame control handling */
 #define IEEE802154_FCTL_FTYPE		0x0003
 #define IEEE802154_FCTL_ACKREQ		0x0020
-- 
2.34.1

