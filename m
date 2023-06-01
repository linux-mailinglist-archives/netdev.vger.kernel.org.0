Return-Path: <netdev+bounces-7127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A762571A333
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BB2D281832
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A7822D6A;
	Thu,  1 Jun 2023 15:48:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98E2101D6
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:48:50 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E02E5F;
	Thu,  1 Jun 2023 08:48:39 -0700 (PDT)
X-GND-Sasl: miquel.raynal@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685634518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u/MjtyGaZEMZjWvUHWZ0jFGXVc8+Jc38TnVgJ8GdDxg=;
	b=MX6STOjo9FYLvULhU6sKOOd+ejbthAGvN2oP/dmeVyXcceNYyzgEpjwkaZYucxiR/ot1Oe
	iTBvYSVcTr6eQbD14FiugnRz5NfAj/zh8mFn/SFyWKH844+uULjzYsqTBUHM2eKc+SUU0K
	d67RI8Aim3xMuattCbzUZFW2IY04ah+Optuyv8Vj7/oIjstzT2HIrhxWfeDBe/zBDPoLhf
	WWGixP3xa8CJ2ucycw99TLaXgTR7vcGu6YrpEDJHTveEKgrjBjmmK4QiycDs/qSF742nYz
	EOFeg49KT8vJGs8vvTd4GZLSDjYSU/huIq+ssFgEVrlmbmZomwKs/4fRAI8FkA==
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 9C044C0011;
	Thu,  1 Jun 2023 15:48:36 +0000 (UTC)
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	linux-wpan@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	David Girault <david.girault@qorvo.com>,
	Romuald Despres <romuald.despres@qorvo.com>,
	Frederic Blain <frederic.blain@qorvo.com>,
	Nicolas Schodet <nico@ni.fr.eu.org>,
	Guilhem Imberton <guilhem.imberton@qorvo.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 07/11] mac802154: Handle association requests from peers
Date: Thu,  1 Jun 2023 17:48:13 +0200
Message-Id: <20230601154817.754519-8-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230601154817.754519-1-miquel.raynal@bootlin.com>
References: <20230601154817.754519-1-miquel.raynal@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Coordinators may have to handle association requests from peers which
want to join the PAN. The logic involves:
- Acknowledging the request (done by hardware)
- If requested, a random short address that is free on this PAN should
  be chosen for the device.
- Sending an association response with the short address allocated for
  the peer and expecting it to be ack'ed.

If anything fails during this procedure, the peer is considered not
associated.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h         |   7 ++
 include/net/ieee802154_netdev.h |   6 ++
 net/ieee802154/core.c           |   7 ++
 net/ieee802154/pan.c            |  27 ++++++
 net/mac802154/ieee802154_i.h    |   2 +
 net/mac802154/rx.c              |   8 ++
 net/mac802154/scan.c            | 147 ++++++++++++++++++++++++++++++++
 7 files changed, 204 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 01bc6c2da7b9..4404072365e7 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -582,4 +582,11 @@ struct ieee802154_pan_device *
 cfg802154_device_is_child(struct wpan_dev *wpan_dev,
 			  struct ieee802154_addr *target);
 
+/**
+ * cfg802154_get_free_short_addr - Get a free address among the known devices
+ * @wpan_dev: the wpan device
+ * @return: a random short address expectedly unused on our PAN
+ */
+__le16 cfg802154_get_free_short_addr(struct wpan_dev *wpan_dev);
+
 #endif /* __NET_CFG802154_H */
diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index 16194356cfe7..4de858f9929e 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -211,6 +211,12 @@ struct ieee802154_association_req_frame {
 	struct ieee802154_assoc_req_pl assoc_req_pl;
 };
 
+struct ieee802154_association_resp_frame {
+	struct ieee802154_hdr mhr;
+	struct ieee802154_mac_cmd_pl mac_pl;
+	struct ieee802154_assoc_resp_pl assoc_resp_pl;
+};
+
 struct ieee802154_disassociation_notif_frame {
 	struct ieee802154_hdr mhr;
 	struct ieee802154_mac_cmd_pl mac_pl;
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 8bf01bb7e858..39674db64336 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -200,11 +200,18 @@ EXPORT_SYMBOL(wpan_phy_free);
 
 static void cfg802154_free_peer_structures(struct wpan_dev *wpan_dev)
 {
+	struct ieee802154_pan_device *child, *tmp;
+
 	mutex_lock(&wpan_dev->association_lock);
 
 	if (wpan_dev->parent)
 		kfree(wpan_dev->parent);
 
+	list_for_each_entry_safe(child, tmp, &wpan_dev->children, node) {
+		list_del(&child->node);
+		kfree(child);
+	}
+
 	wpan_dev->association_generation++;
 
 	mutex_unlock(&wpan_dev->association_lock);
diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
index 477e8dad0cf0..7756906c201d 100644
--- a/net/ieee802154/pan.c
+++ b/net/ieee802154/pan.c
@@ -66,3 +66,30 @@ cfg802154_device_is_child(struct wpan_dev *wpan_dev,
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(cfg802154_device_is_child);
+
+__le16 cfg802154_get_free_short_addr(struct wpan_dev *wpan_dev)
+{
+	struct ieee802154_pan_device *child;
+	__le16 addr;
+
+	lockdep_assert_held(&wpan_dev->association_lock);
+
+	do {
+		get_random_bytes(&addr, 2);
+		if (addr == cpu_to_le16(IEEE802154_ADDR_SHORT_BROADCAST) ||
+		    addr == cpu_to_le16(IEEE802154_ADDR_SHORT_UNSPEC))
+			continue;
+
+		if (wpan_dev->parent && wpan_dev->parent->short_addr == addr)
+			continue;
+
+		list_for_each_entry(child, &wpan_dev->children, node)
+			if (child->short_addr == addr)
+				continue;
+
+		break;
+	} while (1);
+
+	return addr;
+}
+EXPORT_SYMBOL_GPL(cfg802154_get_free_short_addr);
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 92252f86c69c..432bfa87249e 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -318,6 +318,8 @@ static inline bool mac802154_is_associating(struct ieee802154_local *local)
 int mac802154_send_disassociation_notif(struct ieee802154_sub_if_data *sdata,
 					struct ieee802154_pan_device *target,
 					u8 reason);
+int mac802154_process_association_req(struct ieee802154_sub_if_data *sdata,
+				      struct sk_buff *skb);
 
 /* interface handling */
 int ieee802154_iface_init(void);
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index d0e08613a36b..96040b63a4fc 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -102,6 +102,14 @@ void mac802154_rx_mac_cmd_worker(struct work_struct *work)
 		mac802154_process_association_resp(mac_pkt->sdata, mac_pkt->skb);
 		break;
 
+	case IEEE802154_CMD_ASSOCIATION_REQ:
+		dev_dbg(&mac_pkt->sdata->dev->dev, "processing ASSOC REQ\n");
+		if (mac_pkt->sdata->wpan_dev.iftype != NL802154_IFTYPE_COORD)
+			break;
+
+		mac802154_process_association_req(mac_pkt->sdata, mac_pkt->skb);
+		break;
+
 	default:
 		break;
 	}
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index e2f2e1235ec6..9f55b2314fe5 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -697,3 +697,150 @@ int mac802154_send_disassociation_notif(struct ieee802154_sub_if_data *sdata,
 	dev_dbg(&sdata->dev->dev, "DISASSOC ACK received from %8phC\n", &teaddr);
 	return 0;
 }
+
+static int
+mac802154_send_association_resp_locked(struct ieee802154_sub_if_data *sdata,
+				       struct ieee802154_pan_device *target,
+				       struct ieee802154_assoc_resp_pl *assoc_resp_pl)
+{
+	u64 teaddr = swab64((__force u64)target->extended_addr);
+	struct ieee802154_association_resp_frame frame = {};
+	struct ieee802154_local *local = sdata->local;
+	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+	struct sk_buff *skb;
+	int ret;
+
+	frame.mhr.fc.type = IEEE802154_FC_TYPE_MAC_CMD;
+	frame.mhr.fc.security_enabled = 0;
+	frame.mhr.fc.frame_pending = 0;
+	frame.mhr.fc.ack_request = 1; /* We always expect an ack here */
+	frame.mhr.fc.intra_pan = 1;
+	frame.mhr.fc.dest_addr_mode = IEEE802154_EXTENDED_ADDRESSING;
+	frame.mhr.fc.version = IEEE802154_2003_STD;
+	frame.mhr.fc.source_addr_mode = IEEE802154_EXTENDED_ADDRESSING;
+	frame.mhr.seq = 10;
+	frame.mhr.source.mode = IEEE802154_ADDR_LONG;
+	frame.mhr.source.extended_addr = wpan_dev->extended_addr;
+	frame.mhr.dest.mode = IEEE802154_ADDR_LONG;
+	frame.mhr.dest.pan_id = wpan_dev->pan_id;
+	frame.mhr.dest.extended_addr = target->extended_addr;
+	frame.mhr.seq = atomic_inc_return(&wpan_dev->dsn) & 0xFF;
+	frame.mac_pl.cmd_id = IEEE802154_CMD_ASSOCIATION_RESP;
+
+	skb = alloc_skb(IEEE802154_MAC_CMD_SKB_SZ + sizeof(*assoc_resp_pl),
+			GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	skb->dev = sdata->dev;
+
+	ret = ieee802154_mac_cmd_push(skb, &frame, assoc_resp_pl,
+				      sizeof(*assoc_resp_pl));
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	ret = ieee802154_mlme_tx_locked(local, sdata, skb);
+	if (ret) {
+		dev_warn(&sdata->dev->dev,
+			 "No ASSOC RESP ACK received from %8phC\n", &teaddr);
+		if (ret > 0)
+			ret = (ret == IEEE802154_NO_ACK) ? -EREMOTEIO : -EIO;
+		return ret;
+	}
+
+	return 0;
+}
+
+int mac802154_process_association_req(struct ieee802154_sub_if_data *sdata,
+				      struct sk_buff *skb)
+{
+	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+	struct ieee802154_addr *src = &mac_cb(skb)->source;
+	struct ieee802154_addr *dest = &mac_cb(skb)->dest;
+	struct ieee802154_assoc_resp_pl assoc_resp_pl = {};
+	struct ieee802154_assoc_req_pl assoc_req_pl;
+	struct ieee802154_pan_device *child, *exchild;
+	struct ieee802154_addr tmp = {};
+	u64 ceaddr;
+	int ret;
+
+	if (skb->len != sizeof(assoc_req_pl))
+		return -EINVAL;
+
+	if (unlikely(src->mode != IEEE802154_EXTENDED_ADDRESSING))
+		return -EINVAL;
+
+	if (unlikely(dest->pan_id != wpan_dev->pan_id))
+		return -ENODEV;
+
+	if (dest->mode == IEEE802154_EXTENDED_ADDRESSING &&
+	    unlikely(dest->extended_addr != wpan_dev->extended_addr))
+		return -ENODEV;
+	else if (dest->mode == IEEE802154_SHORT_ADDRESSING &&
+		 unlikely(dest->short_addr != wpan_dev->short_addr))
+		return -ENODEV;
+
+	mutex_lock(&wpan_dev->association_lock);
+
+	memcpy(&assoc_req_pl, skb->data, sizeof(assoc_req_pl));
+	if (assoc_req_pl.assoc_type) {
+		dev_err(&skb->dev->dev, "Fast associations not supported yet\n");
+		ret = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	child = kzalloc(sizeof(*child), GFP_KERNEL);
+	if (!child) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	child->extended_addr = src->extended_addr;
+	child->mode = IEEE802154_EXTENDED_ADDRESSING;
+	ceaddr = swab64((__force u64)child->extended_addr);
+
+	assoc_resp_pl.status = IEEE802154_ASSOCIATION_SUCCESSFUL;
+	if (assoc_req_pl.alloc_addr) {
+		assoc_resp_pl.short_addr = cfg802154_get_free_short_addr(wpan_dev);
+		child->mode = IEEE802154_SHORT_ADDRESSING;
+	} else {
+		assoc_resp_pl.short_addr = cpu_to_le16(IEEE802154_ADDR_SHORT_UNSPEC);
+	}
+	child->short_addr = assoc_resp_pl.short_addr;
+	dev_dbg(&sdata->dev->dev,
+		"Accepting ASSOC REQ from child %8phC, providing short address 0x%04x\n",
+		&ceaddr, le16_to_cpu(child->short_addr));
+
+	ret = mac802154_send_association_resp_locked(sdata, child, &assoc_resp_pl);
+	if (ret) {
+		kfree(child);
+		goto unlock;
+	}
+
+	dev_dbg(&sdata->dev->dev,
+		"Successful association with new child %8phC\n", &ceaddr);
+
+	/* Ensure this child is not already associated (might happen due to
+	 * retransmissions), in this case drop the ex structure.
+	 */
+	tmp.mode = child->mode;
+	if (tmp.mode == IEEE802154_SHORT_ADDRESSING)
+		tmp.short_addr = child->short_addr;
+	else
+		tmp.extended_addr = child->extended_addr;
+	exchild = cfg802154_device_is_child(wpan_dev, &tmp);
+	if (exchild) {
+		dev_dbg(&sdata->dev->dev,
+			"Child %8phC was already known\n", &ceaddr);
+		list_del(&exchild->node);
+	}
+
+	list_add(&child->node, &wpan_dev->children);
+	wpan_dev->association_generation++;
+
+unlock:
+	mutex_unlock(&wpan_dev->association_lock);
+	return ret;
+}
-- 
2.34.1


