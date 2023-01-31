Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DA6682AF9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjAaK62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjAaK6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:58:23 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCEDB747;
        Tue, 31 Jan 2023 02:58:19 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8F7FDC0006;
        Tue, 31 Jan 2023 10:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675162698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kphladw6aVDDMpNO5kwcLklYxEcp3WBSofBzSRMZvsU=;
        b=FBDdIiumb627LO/AH+A8MqgYn99zULKhZ48W7/wWkKks2mdZ8EzfzZgcT+CzwEr/zWb8od
        gOfmQ4INHrIYUpYc5s4HSg6iBqkWgQxwl36xVhZrnXZ0FbWzEusiORwQVzdtva/stCvBW/
        3xF4jOZm/i5S5kGtlwsLcdPZXK32T6Xhd4yUHy5HFTi5ii+nUJc/jQ1y6bFushl/PnVylp
        oKzsz4euTyJZJTvPKIf8PQWSvG1aZBNJs6x+k/cAE7q7LJCR1XE9/BdP81K+5b6eTKkQ9N
        jl1nMA1bT4urX8HAx1+2VEU8lH1SUNeLDM+y3VicTgZkEsJ3O18T3XXXtHekBw==
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
Subject: [wpan-next 4/4] mac802154: Handle received BEACON_REQ
Date:   Tue, 31 Jan 2023 11:57:57 +0100
Message-Id: <20230131105757.163034-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131105757.163034-1-miquel.raynal@bootlin.com>
References: <20230131105757.163034-1-miquel.raynal@bootlin.com>
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

When performing an active scan, devices emit BEACON_REQ which
must be answered by other PANs receiving the request, unless they are
already passively sending beacons.

Answering a beacon request becomes a duty when the user tells us to send
beacons and the request provides an interval of 15.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h |  2 +
 net/ieee802154/header_ops.c     | 13 ++++++
 net/mac802154/ieee802154_i.h    | 20 ++++++++++
 net/mac802154/main.c            |  2 +
 net/mac802154/rx.c              | 70 ++++++++++++++++++++++++++++++++-
 net/mac802154/scan.c            | 12 ++++--
 6 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index 257c9b2e9c9a..063313df447d 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -193,6 +193,8 @@ int ieee802154_beacon_push(struct sk_buff *skb,
 			   struct ieee802154_beacon_frame *beacon);
 int ieee802154_mac_cmd_push(struct sk_buff *skb, void *frame,
 			    const void *pl, unsigned int pl_len);
+int ieee802154_mac_cmd_pl_pull(struct sk_buff *skb,
+			       struct ieee802154_mac_cmd_pl *mac_pl);
 
 int ieee802154_max_payload(const struct ieee802154_hdr *hdr);
 
diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index a5ff1017a4b2..41a556be1017 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -307,6 +307,19 @@ ieee802154_hdr_pull(struct sk_buff *skb, struct ieee802154_hdr *hdr)
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
index 7bfd5411a164..c347ec9ff8c9 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -71,6 +71,8 @@ struct ieee802154_local {
 	/* Asynchronous tasks */
 	struct list_head rx_beacon_list;
 	struct work_struct rx_beacon_work;
+	struct list_head rx_mac_cmd_list;
+	struct work_struct rx_mac_cmd_work;
 
 	bool started;
 	bool suspended;
@@ -155,6 +157,22 @@ ieee802154_sdata_running(struct ieee802154_sub_if_data *sdata)
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
@@ -276,6 +294,8 @@ static inline bool mac802154_is_beaconing(struct ieee802154_local *local)
 	return test_bit(IEEE802154_IS_BEACONING, &local->ongoing);
 }
 
+void mac802154_rx_mac_cmd_worker(struct work_struct *work);
+
 /* interface handling */
 int ieee802154_iface_init(void);
 void ieee802154_iface_exit(void);
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index ee23e234b998..357ece67432b 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -90,6 +90,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	INIT_LIST_HEAD(&local->interfaces);
 	INIT_LIST_HEAD(&local->rx_beacon_list);
+	INIT_LIST_HEAD(&local->rx_mac_cmd_list);
 	mutex_init(&local->iflist_mtx);
 
 	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
@@ -100,6 +101,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_worker);
 	INIT_WORK(&local->rx_beacon_work, mac802154_rx_beacon_worker);
 	INIT_DELAYED_WORK(&local->beacon_work, mac802154_beacon_worker);
+	INIT_WORK(&local->rx_mac_cmd_work, mac802154_rx_mac_cmd_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index da0628ee3c89..e2434b4fe514 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -47,6 +47,62 @@ void mac802154_rx_beacon_worker(struct work_struct *work)
 	kfree(mac_pkt);
 }
 
+static bool mac802154_should_answer_beacon_req(struct ieee802154_local *local)
+{
+	struct cfg802154_beacon_request *beacon_req;
+	unsigned int interval;
+
+	rcu_read_lock();
+	beacon_req = rcu_dereference(local->beacon_req);
+	if (!beacon_req) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	interval = beacon_req->interval;
+	rcu_read_unlock();
+
+	if (!mac802154_is_beaconing(local))
+		return false;
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
+	mac_pkt = list_first_entry_or_null(&local->rx_mac_cmd_list,
+					   struct cfg802154_mac_pkt, node);
+	if (!mac_pkt)
+		return;
+
+	rc = ieee802154_get_mac_cmd(mac_pkt->skb, &mac_cmd);
+	if (rc)
+		goto out;
+
+	switch (mac_cmd) {
+	case IEEE802154_CMD_BEACON_REQ:
+		dev_dbg(&mac_pkt->sdata->dev->dev, "processing BEACON REQ\n");
+		if (!mac802154_should_answer_beacon_req(local))
+			break;
+
+		queue_delayed_work(local->mac_wq, &local->beacon_work, 0);
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
@@ -140,8 +196,20 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 		list_add_tail(&mac_pkt->node, &sdata->local->rx_beacon_list);
 		queue_work(sdata->local->mac_wq, &sdata->local->rx_beacon_work);
 		return NET_RX_SUCCESS;
-	case IEEE802154_FC_TYPE_ACK:
+
 	case IEEE802154_FC_TYPE_MAC_CMD:
+		dev_dbg(&sdata->dev->dev, "MAC COMMAND received\n");
+		mac_pkt = kzalloc(sizeof(*mac_pkt), GFP_ATOMIC);
+		if (!mac_pkt)
+			goto fail;
+
+		mac_pkt->skb = skb_get(skb);
+		mac_pkt->sdata = sdata;
+		list_add_tail(&mac_pkt->node, &sdata->local->rx_mac_cmd_list);
+		queue_work(sdata->local->mac_wq, &sdata->local->rx_mac_cmd_work);
+		return NET_RX_SUCCESS;
+
+	case IEEE802154_FC_TYPE_ACK:
 		goto fail;
 
 	case IEEE802154_FC_TYPE_DATA:
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index 082c450f2a97..2c21a03fa625 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -385,6 +385,7 @@ void mac802154_beacon_worker(struct work_struct *work)
 	struct cfg802154_beacon_request *beacon_req;
 	struct ieee802154_sub_if_data *sdata;
 	struct wpan_dev *wpan_dev;
+	u8 interval;
 	int ret;
 
 	rcu_read_lock();
@@ -405,6 +406,7 @@ void mac802154_beacon_worker(struct work_struct *work)
 	}
 
 	wpan_dev = beacon_req->wpan_dev;
+	interval = beacon_req->interval;
 
 	rcu_read_unlock();
 
@@ -414,7 +416,7 @@ void mac802154_beacon_worker(struct work_struct *work)
 		dev_err(&sdata->dev->dev,
 			"Beacon could not be transmitted (%d)\n", ret);
 
-	if (local->beacon_interval >= 0)
+	if (interval < IEEE802154_ACTIVE_SCAN_DURATION)
 		queue_delayed_work(local->mac_wq, &local->beacon_work,
 				   local->beacon_interval);
 }
@@ -471,13 +473,17 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
 	local->beacon.mhr.source.pan_id = request->wpan_dev->pan_id;
 	local->beacon.mhr.source.extended_addr = request->wpan_dev->extended_addr;
 	local->beacon.mac_pl.beacon_order = request->interval;
-	local->beacon.mac_pl.superframe_order = request->interval;
+	if (request->interval <= IEEE802154_MAX_SCAN_DURATION)
+		local->beacon.mac_pl.superframe_order = request->interval;
 	local->beacon.mac_pl.final_cap_slot = 0xf;
 	local->beacon.mac_pl.battery_life_ext = 0;
-	/* TODO: Fill this field depending on the coordinator capacity */
+	/* TODO: Fill this field with the coordinator situation in the network */
 	local->beacon.mac_pl.pan_coordinator = 1;
 	local->beacon.mac_pl.assoc_permit = 1;
 
+	if (request->interval == IEEE802154_ACTIVE_SCAN_DURATION)
+		return 0;
+
 	/* Start the beacon work */
 	local->beacon_interval =
 		mac802154_scan_get_channel_time(request->interval,
-- 
2.34.1

