Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16B95F7599
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJGIxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiJGIxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:53:30 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF5A1162C8;
        Fri,  7 Oct 2022 01:53:29 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4E3B91BF20E;
        Fri,  7 Oct 2022 08:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665132808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CIldazHAuIqlRDzUD3sCJgICBkM0a0VYrJOt14NrvqM=;
        b=YYY811mWLF2cEf8EvyNVxupyOWKvLRSnhrEWmdKiSENok6ZK+ztpwCcR0wTUz+jfe7+lAC
        Ktgk8xPt54/QmDgU/J2tl8I105Q9rWwX5mx3Ugzsz75uK2ABpvZ4jX/XrbqrNTJ05spemO
        yJ9dWB8KwtNK+kaF+9BcYbmVt6LJa1H9C5KIADmnljV5V9qi099mZlIn9Smp84oZhRgChP
        duJSuXlb63cSbZkFSJESuTq4mubjY5rwF5s7QLRNKQ9iycNCl0VZbD/QA7hG8D61GdNt3Y
        Ea3nLRMZK9MdljLp1DEjGjurBXhGsFqdynV+cNLu5Nu6XZrGuRUksGyzUhFEpQ==
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
Subject: [PATCH wpan/next v4 5/8] ieee802154: hwsim: Implement address filtering
Date:   Fri,  7 Oct 2022 10:53:07 +0200
Message-Id: <20221007085310.503366-6-miquel.raynal@bootlin.com>
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

We have access to the address filters being theoretically applied, we
also have access to the actual filtering level applied, so let's add a
proper frame validation sequence in hwsim.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 111 ++++++++++++++++++++++-
 include/net/ieee802154_netdev.h          |   8 ++
 2 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 458be66b5195..84ee948f35bc 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -18,6 +18,7 @@
 #include <linux/netdevice.h>
 #include <linux/device.h>
 #include <linux/spinlock.h>
+#include <net/ieee802154_netdev.h>
 #include <net/mac802154.h>
 #include <net/cfg802154.h>
 #include <net/genetlink.h>
@@ -139,6 +140,113 @@ static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
 	return 0;
 }
 
+static void hwsim_hw_receive(struct ieee802154_hw *hw, struct sk_buff *skb,
+			     u8 lqi)
+{
+	struct ieee802154_hdr hdr;
+	struct hwsim_phy *phy = hw->priv;
+	struct hwsim_pib *pib;
+
+	rcu_read_lock();
+	pib = rcu_dereference(phy->pib);
+
+	if (!pskb_may_pull(skb, 3)) {
+		dev_dbg(hw->parent, "invalid frame\n");
+		goto drop;
+	}
+
+	memcpy(&hdr, skb->data, 3);
+
+	/* Level 4 filtering: Frame fields validity */
+	if (hw->phy->filtering == IEEE802154_FILTERING_4_FRAME_FIELDS) {
+
+		/* a) Drop reserved frame types */
+		switch (mac_cb(skb)->type) {
+		case IEEE802154_FC_TYPE_BEACON:
+		case IEEE802154_FC_TYPE_DATA:
+		case IEEE802154_FC_TYPE_ACK:
+		case IEEE802154_FC_TYPE_MAC_CMD:
+			break;
+		default:
+			dev_dbg(hw->parent, "unrecognized frame type 0x%x\n",
+				mac_cb(skb)->type);
+			goto drop;
+		}
+
+		/* b) Drop reserved frame versions */
+		switch (hdr.fc.version) {
+		case IEEE802154_2003_STD:
+		case IEEE802154_2006_STD:
+		case IEEE802154_STD:
+			break;
+		default:
+			dev_dbg(hw->parent,
+				"unrecognized frame version 0x%x\n",
+				hdr.fc.version);
+			goto drop;
+		}
+
+		/* c) PAN ID constraints */
+		if ((mac_cb(skb)->dest.mode == IEEE802154_ADDR_LONG ||
+		     mac_cb(skb)->dest.mode == IEEE802154_ADDR_SHORT) &&
+		    mac_cb(skb)->dest.pan_id != pib->filt.pan_id &&
+		    mac_cb(skb)->dest.pan_id != cpu_to_le16(IEEE802154_PANID_BROADCAST)) {
+			dev_dbg(hw->parent,
+				"unrecognized PAN ID %04x\n",
+				le16_to_cpu(mac_cb(skb)->dest.pan_id));
+			goto drop;
+		}
+
+		/* d1) Short address constraints */
+		if (mac_cb(skb)->dest.mode == IEEE802154_ADDR_SHORT &&
+		    mac_cb(skb)->dest.short_addr != pib->filt.short_addr &&
+		    mac_cb(skb)->dest.short_addr != cpu_to_le16(IEEE802154_ADDR_BROADCAST)) {
+			dev_dbg(hw->parent,
+				"unrecognized short address %04x\n",
+				le16_to_cpu(mac_cb(skb)->dest.short_addr));
+			goto drop;
+		}
+
+		/* d2) Extended address constraints */
+		if (mac_cb(skb)->dest.mode == IEEE802154_ADDR_LONG &&
+		    mac_cb(skb)->dest.extended_addr != pib->filt.ieee_addr) {
+			dev_dbg(hw->parent,
+				"unrecognized long address 0x%016llx\n",
+				mac_cb(skb)->dest.extended_addr);
+			goto drop;
+		}
+
+		/* d4) Specific PAN coordinator case (no parent) */
+		if ((mac_cb(skb)->type == IEEE802154_FC_TYPE_DATA ||
+		     mac_cb(skb)->type == IEEE802154_FC_TYPE_MAC_CMD) &&
+		    mac_cb(skb)->dest.mode == IEEE802154_ADDR_NONE) {
+			dev_dbg(hw->parent,
+				"relaying is not supported\n");
+			goto drop;
+		}
+
+		/* e) Beacon frames follow specific PAN ID rules */
+		if (mac_cb(skb)->type == IEEE802154_FC_TYPE_BEACON &&
+		    pib->filt.pan_id != cpu_to_le16(IEEE802154_PANID_BROADCAST) &&
+		    mac_cb(skb)->dest.pan_id != pib->filt.pan_id) {
+			dev_dbg(hw->parent,
+				"invalid beacon PAN ID %04x\n",
+				le16_to_cpu(mac_cb(skb)->dest.pan_id));
+			goto drop;
+		}
+        }
+
+	rcu_read_unlock();
+
+	ieee802154_rx_irqsafe(hw, skb, lqi);
+
+	return;
+
+drop:
+	rcu_read_unlock();
+	kfree_skb(skb);
+}
+
 static int hwsim_hw_xmit(struct ieee802154_hw *hw, struct sk_buff *skb)
 {
 	struct hwsim_phy *current_phy = hw->priv;
@@ -166,8 +274,7 @@ static int hwsim_hw_xmit(struct ieee802154_hw *hw, struct sk_buff *skb)
 
 			einfo = rcu_dereference(e->info);
 			if (newskb)
-				ieee802154_rx_irqsafe(e->endpoint->hw, newskb,
-						      einfo->lqi);
+				hwsim_hw_receive(e->endpoint->hw, newskb, einfo->lqi);
 		}
 	}
 	rcu_read_unlock();
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
-- 
2.34.1

