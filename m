Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7675635E3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiGAOg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiGAOfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:50 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571CC40A2D;
        Fri,  1 Jul 2022 07:31:30 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 585D2FF804;
        Fri,  1 Jul 2022 14:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N/c8KJYzrH4UpNN2gGsN4AV+w1huFAwhTl00KUPNMTI=;
        b=ThAS7hnecdjoGAIYatZ6wuzATGcgOV0R4bxleJL/ksInOp47iuIdM6xojWyBgrUKl3sXzb
        5qGcervITTrqAGa9DYvV1h1kXzSLina1ekEGu1hCX1wDJOGAR9X/mdaxMU2Lbs/8xHfPO0
        KBxHS+UapXgqCjD4dH8bbvbBZGRS87jg8mwCMnp03XfZOc/vsEoaA+644fRCrCnGq/dW/z
        SRRIZ4gWvdf4OyozjXG2WcE63IpP/CL0Gq49EGNbBem1LlVp4GBlztT3UEdkzQtkfKNf00
        erDSgP5jNyx1iTPfOURKZDp8gr/4qYdetI12lofdY885/NHAISFTEOrvxpTF9A==
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
Subject: [PATCH wpan-next 16/20] net: mac802154: Handle received BEACON_REQ
Date:   Fri,  1 Jul 2022 16:30:48 +0200
Message-Id: <20220701143052.1267509-17-miquel.raynal@bootlin.com>
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

When performing an active scan, devices emit BEACON_REQ which
must be answered by other PANs receiving the request, unless they are
already passively sending beacons.

Answering a beacon request becomes a duty when the user tells us to send
beacons and the request provides an interval of 15.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h |  2 ++
 net/ieee802154/header_ops.c     | 13 +++++++
 net/mac802154/ieee802154_i.h    | 20 +++++++++++
 net/mac802154/main.c            |  2 ++
 net/mac802154/rx.c              | 62 ++++++++++++++++++++++++++++++++-
 net/mac802154/scan.c            | 12 ++++---
 6 files changed, 106 insertions(+), 5 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index 21e7e3f66c82..d1152bff8b9b 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -188,6 +188,8 @@ int ieee802154_beacon_push(struct sk_buff *skb,
 			   struct ieee802154_beacon_frame *beacon);
 int ieee802154_mac_cmd_push(struct sk_buff *skb, void *frame,
 			    const void *pl, unsigned int pl_len);
+int ieee802154_mac_cmd_pl_pull(struct sk_buff *skb,
+			       struct ieee802154_mac_cmd_pl *mac_pl);
 
 int ieee802154_max_payload(const struct ieee802154_hdr *hdr);
 
diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index 795d46c7292d..8d81221dd119 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -316,6 +316,19 @@ ieee802154_hdr_pull(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 }
 EXPORT_SYMBOL_GPL(ieee802154_hdr_pull);
 
+int ieee802154_mac_cmd_pl_pull(struct sk_buff *skb,
+			       struct ieee802154_mac_cmd_pl *mac_pl)
+{
+	if (!pskb_may_pull(skb, sizeof(*mac_pl)))
+		return -EINVAL;
+
+	memcpy(mac_pl, skb->data, sizeof(*mac_pl));
+	skb_pull(skb, sizeof(*mac_pl));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ieee802154_mac_cmd_pl_pull);
+
 int
 ieee802154_hdr_peek_addrs(const struct sk_buff *skb, struct ieee802154_hdr *hdr)
 {
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 86a384942e6f..a366d4901d70 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -72,6 +72,8 @@ struct ieee802154_local {
 	/* Asynchronous tasks */
 	struct list_head rx_beacon_list;
 	struct work_struct rx_beacon_work;
+	struct list_head rx_mac_cmd_list;
+	struct work_struct rx_mac_cmd_work;
 
 	bool started;
 	bool suspended;
@@ -146,6 +148,22 @@ ieee802154_sdata_running(struct ieee802154_sub_if_data *sdata)
 	return test_bit(SDATA_STATE_RUNNING, &sdata->state);
 }
 
+static inline int ieee802154_get_mac_cmd(struct sk_buff *skb, u8 *mac_cmd)
+{
+	struct ieee802154_mac_cmd_pl mac_pl;
+	int ret;
+
+	if (mac_cb(skb)->type != IEEE802154_FC_TYPE_MAC_CMD)
+		return -EINVAL;
+
+	ret = ieee802154_mac_cmd_pl_pull(skb, &mac_pl);
+	if (ret)
+		return ret;
+
+	*mac_cmd = mac_pl.cmd_id;
+	return 0;
+}
+
 extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
@@ -258,6 +276,8 @@ static inline bool mac802154_is_beaconing(struct ieee802154_local *local)
 	return test_bit(IEEE802154_IS_BEACONING, &local->ongoing);
 }
 
+void mac802154_rx_mac_cmd_worker(struct work_struct *work);
+
 /* interface handling */
 int ieee802154_iface_init(void);
 void ieee802154_iface_exit(void);
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 826a0d2ce395..a6ffae53d53c 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -90,6 +90,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	INIT_LIST_HEAD(&local->interfaces);
 	INIT_LIST_HEAD(&local->rx_beacon_list);
+	INIT_LIST_HEAD(&local->rx_mac_cmd_list);
 	mutex_init(&local->iflist_mtx);
 	mutex_init(&local->device_lock);
 	mutex_init(&local->scan_lock);
@@ -103,6 +104,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_worker);
 	INIT_WORK(&local->rx_beacon_work, mac802154_rx_beacon_worker);
 	INIT_DELAYED_WORK(&local->beacon_work, mac802154_beacon_worker);
+	INIT_WORK(&local->rx_mac_cmd_work, mac802154_rx_mac_cmd_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 0b1cf8c85ee9..4688ce00ba9c 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -53,6 +53,55 @@ void mac802154_rx_beacon_worker(struct work_struct *work)
 	mutex_unlock(&local->scan_lock);
 }
 
+static bool mac802154_should_answer_beacon_req(struct ieee802154_local *local)
+{
+	struct cfg802154_beacon_request *beacon_req;
+	unsigned int interval;
+
+	if (!mac802154_is_beaconing(local))
+		return false;
+
+	mutex_lock(&local->beacon_lock);
+	beacon_req = rcu_dereference_protected(local->beacon_req,
+					       &local->beacon_lock);
+	interval = beacon_req->interval;
+	mutex_unlock(&local->beacon_lock);
+
+	return interval == IEEE802154_ACTIVE_SCAN_DURATION;
+}
+
+void mac802154_rx_mac_cmd_worker(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, rx_mac_cmd_work);
+	struct cfg802154_mac_pkt *mac_pkt;
+	u8 mac_cmd;
+	int rc;
+
+	mac_pkt = list_first_entry(&local->rx_mac_cmd_list,
+				   struct cfg802154_mac_pkt, node);
+
+	rc = ieee802154_get_mac_cmd(mac_pkt->skb, &mac_cmd);
+	if (rc)
+		goto out;
+
+	switch (mac_cmd) {
+	case IEEE802154_CMD_BEACON_REQ:
+		if (!mac802154_should_answer_beacon_req(local))
+			break;
+
+		queue_delayed_work(local->workqueue, &local->beacon_work, 0);
+		break;
+	default:
+		break;
+	}
+
+out:
+	list_del(&mac_pkt->node);
+	kfree_skb(mac_pkt->skb);
+	kfree(mac_pkt);
+}
+
 static int
 ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 		       struct sk_buff *skb, const struct ieee802154_hdr *hdr)
@@ -131,8 +180,19 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 		list_add_tail(&mac_pkt->node, &sdata->local->rx_beacon_list);
 		queue_work(sdata->local->workqueue, &sdata->local->rx_beacon_work);
 		goto success;
-	case IEEE802154_FC_TYPE_ACK:
+
 	case IEEE802154_FC_TYPE_MAC_CMD:
+		mac_pkt = kzalloc(sizeof(*mac_pkt), GFP_ATOMIC);
+		if (!mac_pkt)
+			goto fail;
+
+		mac_pkt->skb = skb_get(skb);
+		mac_pkt->sdata = sdata;
+		list_add_tail(&mac_pkt->node, &sdata->local->rx_mac_cmd_list);
+		queue_work(sdata->local->workqueue, &sdata->local->rx_mac_cmd_work);
+		goto success;
+
+	case IEEE802154_FC_TYPE_ACK:
 		goto fail;
 
 	case IEEE802154_FC_TYPE_DATA:
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index b9bb784bf388..c102184e8de4 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -376,7 +376,7 @@ void mac802154_beacon_worker(struct work_struct *work)
 		pr_err("Error when transmitting beacon (%d)\n", ret);
 
 queue_work:
-	if (local->beacon_interval >= 0)
+	if (beacon_req->interval < IEEE802154_ACTIVE_SCAN_DURATION)
 		queue_delayed_work(local->workqueue, &local->beacon_work,
 				   local->beacon_interval);
 
@@ -393,7 +393,7 @@ static void mac802154_end_beaconing(struct ieee802154_local *local)
 					       &local->beacon_lock);
 	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(beacon_req->wpan_dev);
 
-	if (local->beacon_interval >= 0)
+	if (beacon_req->interval < IEEE802154_ACTIVE_SCAN_DURATION)
 		cancel_delayed_work(&local->beacon_work);
 
 	clear_bit(IEEE802154_IS_BEACONING, &local->ongoing);
@@ -441,13 +441,17 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
 	local->beacon.mhr.source.pan_id = cpu_to_le16(request->wpan_dev->pan_id);
 	local->beacon.mhr.source.extended_addr = cpu_to_le64(request->wpan_dev->extended_addr);
 	local->beacon.mac_pl.beacon_order = request->interval;
-	local->beacon.mac_pl.superframe_order = request->interval;
+	if (request->interval <= IEEE802154_MAX_SCAN_DURATION)
+		local->beacon.mac_pl.superframe_order = request->interval;
 	local->beacon.mac_pl.final_cap_slot = 0xf;
 	local->beacon.mac_pl.battery_life_ext = 0;
-	/* TODO: Fill this field depending on the coordinator capacity */
+	/* TODO: Fill this field with the coordinator situation in the network */
 	local->beacon.mac_pl.pan_coordinator = 1;
 	local->beacon.mac_pl.assoc_permit = 0;
 
+	if (request->interval == IEEE802154_ACTIVE_SCAN_DURATION)
+		return 0;
+
 	/* Start the beacon work */
 	local->beacon_interval =
 		mac802154_scan_get_channel_time(request->interval,
-- 
2.34.1

