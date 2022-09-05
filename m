Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB675ADA47
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiIEUeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiIEUeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:34:37 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626B61274C;
        Mon,  5 Sep 2022 13:34:33 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0AE70FF806;
        Mon,  5 Sep 2022 20:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662410071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QbxqkGaHKi0NxH/H0WQJBiuO9z2O2S8Yads0Qpz0QKw=;
        b=IEnznJlP6m6MD1ueUX+CWufchrzSj58xBil1KfC1Q9WM/sL5G6KtNZoQFUqPufAhP2Exqr
        YlqSRKpNdTuYpGOPnwBUGeihFT8Xowls9g3ovM2bXtx5MHsacRluCta0vg8uArelzE8BQm
        VCOyffqBUz3lXM1cspl3ZIBPgrX75vW6iKKArApUdQ9vPTYraq9+M6lZkcltjdyTQPjYz5
        7v3pLUOTTEALlztt6C+uji1nY32Wq67dblyLHdZ5vkRAQOK22r12IqtvSFdsn7JgYJLGln
        9nwWWRM1bGelgqcSei/8uvbBFfBTF8Yo9w/rQ7kw+LzJH+Ml99OLVLsBe/QLig==
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
Subject: [PATCH wpan/next v3 8/9] net: mac802154: Ensure proper general purpose frame filtering
Date:   Mon,  5 Sep 2022 22:34:11 +0200
Message-Id: <20220905203412.1322947-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the PHYs seem to cope with the standard filtering rules by
default. Some of them might not, like hwsim which is only software, and
in this case advertises its real filtering level with the new
"filtering" internal value.

The core then needs to check what is expected by looking at the PHY
requested filtering level and possibly apply additional filtering
rules.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h |  8 ++++
 net/mac802154/rx.c              | 78 +++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c3294b..1b82bbafe8c7 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -69,6 +69,14 @@ struct ieee802154_hdr_fc {
 #endif
 };
 
+enum ieee802154_frame_version {
+	IEEE802154_2003_STD,
+	IEEE802154_2006_STD,
+	IEEE802154_STD,
+	IEEE802154_RESERVED_STD,
+	IEEE802154_MULTIPURPOSE_STD = IEEE802154_2003_STD,
+};
+
 struct ieee802154_hdr {
 	struct ieee802154_hdr_fc fc;
 	u8 seq;
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c43289c0fdd7..bc46e4a7669d 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -52,6 +52,84 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 				mac_cb(skb)->type);
 			goto fail;
 		}
+	} else if (sdata->required_filtering == IEEE802154_FILTERING_4_FRAME_FIELDS &&
+		   sdata->required_filtering > wpan_phy->filtering) {
+		/* Level 4 filtering: Frame fields validity */
+
+		/* a) Drop reserved frame types */
+		switch (mac_cb(skb)->type) {
+		case IEEE802154_FC_TYPE_BEACON:
+		case IEEE802154_FC_TYPE_DATA:
+		case IEEE802154_FC_TYPE_ACK:
+		case IEEE802154_FC_TYPE_MAC_CMD:
+			break;
+		default:
+			dev_dbg(&sdata->dev->dev, "unrecognized frame type 0x%x\n",
+				mac_cb(skb)->type);
+			goto fail;
+		}
+
+		/* b) Drop reserved frame versions */
+		switch (hdr->fc.version) {
+		case IEEE802154_2003_STD:
+		case IEEE802154_2006_STD:
+		case IEEE802154_STD:
+			break;
+		default:
+			dev_dbg(&sdata->dev->dev,
+				"unrecognized frame version 0x%x\n",
+				hdr->fc.version);
+			goto fail;
+		}
+
+		/* c) PAN ID constraints */
+		if ((mac_cb(skb)->dest.mode == IEEE802154_ADDR_LONG ||
+		     mac_cb(skb)->dest.mode == IEEE802154_ADDR_SHORT) &&
+		    mac_cb(skb)->dest.pan_id != span &&
+		    mac_cb(skb)->dest.pan_id != cpu_to_le16(IEEE802154_PANID_BROADCAST)) {
+			dev_dbg(&sdata->dev->dev,
+				"unrecognized PAN ID %04x\n",
+				le16_to_cpu(mac_cb(skb)->dest.pan_id));
+			goto fail;
+		}
+
+		/* d1) Short address constraints */
+		if (mac_cb(skb)->dest.mode == IEEE802154_ADDR_SHORT &&
+		    mac_cb(skb)->dest.short_addr != sshort &&
+		    mac_cb(skb)->dest.short_addr != cpu_to_le16(IEEE802154_ADDR_BROADCAST)) {
+			dev_dbg(&sdata->dev->dev,
+				"unrecognized short address %04x\n",
+				le16_to_cpu(mac_cb(skb)->dest.short_addr));
+			goto fail;
+		}
+
+		/* d2) Extended address constraints */
+		if (mac_cb(skb)->dest.mode == IEEE802154_ADDR_LONG &&
+		    mac_cb(skb)->dest.extended_addr != wpan_dev->extended_addr) {
+			dev_dbg(&sdata->dev->dev,
+				"unrecognized long address 0x%016llx\n",
+				mac_cb(skb)->dest.extended_addr);
+			goto fail;
+		}
+
+		/* d4) Specific PAN coordinator case (no parent) */
+		if ((mac_cb(skb)->type == IEEE802154_FC_TYPE_DATA ||
+		     mac_cb(skb)->type == IEEE802154_FC_TYPE_MAC_CMD) &&
+		    mac_cb(skb)->dest.mode == IEEE802154_ADDR_NONE) {
+			dev_dbg(&sdata->dev->dev,
+				"relaying is not supported\n");
+			goto fail;
+		}
+	}
+
+	/* e) Beacon frames follow specific PAN ID rules */
+	if (mac_cb(skb)->type == IEEE802154_FC_TYPE_BEACON &&
+	    span != cpu_to_le16(IEEE802154_PANID_BROADCAST) &&
+	    mac_cb(skb)->dest.pan_id != span) {
+		dev_dbg(&sdata->dev->dev,
+			"invalid beacon PAN ID %04x\n",
+			le16_to_cpu(mac_cb(skb)->dest.pan_id));
+		goto fail;
 	}
 
 	switch (mac_cb(skb)->dest.mode) {
-- 
2.34.1

