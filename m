Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10535635CA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiGAOgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiGAOfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:43 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5503EAAC;
        Fri,  1 Jul 2022 07:31:21 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E7037FF812;
        Fri,  1 Jul 2022 14:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AXuvPXJYdt60CxSbl6iUkQ1RruzyHZ+O7LR+mI3aOrY=;
        b=PQAAOQg23gdZOekF2QuuPdfIvHXrIAU1p1aKTK5gdyG4H+W/7Vs2L6x9L68m3HGT3JNYwu
        hs0DT4G5XpOW8haCuMJRa/GJHd5E+TV+VQLk9G+RmcQbOqD0iFY2vYU8dY21khQ7lJa7bz
        I6mYc1dQPeejaproJpiwDS8KyrYCVMljy9U8pkbKuHe/KmwxQxvuN89Ws7hIkhVeC9CoXa
        VJoK0brJ9MQjgQxTwaNj9Unk1nAPCR8zzU0VRjVnVpkznyAWNjzQJQxm9DIMhH4hLRctAz
        InaGp1VDx/D7jo3In4p6klyQAsENeNDzAwAZ4OYnAmnCNtO2HoCG4XAQ3wHCXA==
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
Subject: [PATCH wpan-next 12/20] net: mac802154: Handle basic beaconing
Date:   Fri,  1 Jul 2022 16:30:44 +0200
Message-Id: <20220701143052.1267509-13-miquel.raynal@bootlin.com>
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

Implement the core hooks in order to provide the softMAC layer support
for sending beacons. Coordinators may be requested to send beacons in a
beacon enabled PAN in order for the other devices around to self
discover the available PANs automatically.

Changing the channels is prohibited while a beacon operation is
ongoing.

The implementation uses a workqueue triggered at a certain interval
depending on the symbol duration for the current channel and the
interval order provided.

Sending beacons in response to a BEACON_REQ frame (ie. answering active
scans) is not yet supported.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h |  24 ++++++
 net/ieee802154/header_ops.c     |  29 +++++++
 net/mac802154/cfg.c             |  39 ++++++++-
 net/mac802154/ieee802154_i.h    |  18 ++++
 net/mac802154/iface.c           |   6 ++
 net/mac802154/main.c            |   2 +
 net/mac802154/scan.c            | 142 ++++++++++++++++++++++++++++++++
 7 files changed, 258 insertions(+), 2 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index 45dff5d11bc8..f7716aeec93b 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -116,6 +116,21 @@ enum ieee802154_frame_type {
 	IEEE802154_EXTENDED_FRAME,
 };
 
+enum ieee802154_frame_version {
+	IEEE802154_2003_STD,
+	IEEE802154_2006_STD,
+	IEEE802154_STD,
+	IEEE802154_RESERVED_STD,
+	IEEE802154_MULTIPURPOSE_STD = IEEE802154_2003_STD,
+};
+
+enum ieee802154_addressing_mode {
+	IEEE802154_NO_ADDRESSING,
+	IEEE802154_RESERVED,
+	IEEE802154_SHORT_ADDRESSING,
+	IEEE802154_EXTENDED_ADDRESSING,
+};
+
 struct ieee802154_hdr {
 	struct ieee802154_hdr_fc fc;
 	u8 seq;
@@ -124,6 +139,11 @@ struct ieee802154_hdr {
 	struct ieee802154_sechdr sec;
 };
 
+struct ieee802154_beacon_frame {
+	struct ieee802154_hdr mhr;
+	struct ieee802154_beacon_hdr mac_pl;
+};
+
 /* pushes hdr onto the skb. fields of hdr->fc that can be calculated from
  * the contents of hdr will be, and the actual value of those bits in
  * hdr->fc will be ignored. this includes the INTRA_PAN bit and the frame
@@ -149,6 +169,10 @@ int ieee802154_hdr_peek_addrs(const struct sk_buff *skb,
  */
 int ieee802154_hdr_peek(const struct sk_buff *skb, struct ieee802154_hdr *hdr);
 
+/* pushes a beacon frame into an skb */
+int ieee802154_beacon_push(struct sk_buff *skb,
+			   struct ieee802154_beacon_frame *beacon);
+
 int ieee802154_max_payload(const struct ieee802154_hdr *hdr);
 
 static inline int
diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index af337cf62764..bab710aa36f9 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -6,6 +6,7 @@
  * Phoebe Buckheister <phoebe.buckheister@itwm.fraunhofer.de>
  */
 
+#include <linux/crc-ccitt.h>
 #include <linux/ieee802154.h>
 
 #include <net/mac802154.h>
@@ -120,6 +121,34 @@ ieee802154_hdr_push(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 }
 EXPORT_SYMBOL_GPL(ieee802154_hdr_push);
 
+int ieee802154_beacon_push(struct sk_buff *skb,
+			   struct ieee802154_beacon_frame *beacon)
+{
+	struct ieee802154_beacon_hdr *mac_pl = &beacon->mac_pl;
+	struct ieee802154_hdr *mhr = &beacon->mhr;
+	u16 crc;
+	int ret;
+
+	skb_reserve(skb, sizeof(*mhr));
+	ret = ieee802154_hdr_push(skb, mhr);
+	if (ret < 0)
+		return ret;
+
+	skb_reset_mac_header(skb);
+	skb->mac_len = ret;
+
+	skb_put_data(skb, mac_pl, sizeof(*mac_pl));
+
+	if (mac_pl->pend_short_addr_count || mac_pl->pend_ext_addr_count)
+		return -EOPNOTSUPP;
+
+	crc = crc_ccitt(0, skb->data, skb->len);
+	put_unaligned_le16(crc, skb_put(skb, 2));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ieee802154_beacon_push);
+
 static int
 ieee802154_hdr_get_addr(const u8 *buf, int mode, bool omit_pan,
 			struct ieee802154_addr *addr)
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index 1f532d93d870..fed9ad38cbce 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -114,8 +114,8 @@ ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 	    wpan_phy->current_channel == channel)
 		return 0;
 
-	/* Refuse to change channels during a scanning operation */
-	if (mac802154_is_scanning(local))
+	/* Refuse to change channels during scanning or beaconing */
+	if (mac802154_is_scanning(local) || mac802154_is_beaconing(local))
 		return -EBUSY;
 
 	ret = drv_set_channel(local, page, channel);
@@ -298,6 +298,39 @@ static int mac802154_abort_scan(struct wpan_phy *wpan_phy,
 	return ret;
 }
 
+static int mac802154_send_beacons(struct wpan_phy *wpan_phy,
+				  struct cfg802154_beacon_request *request)
+{
+	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
+	struct ieee802154_sub_if_data *sdata;
+	int ret;
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(request->wpan_dev);
+
+	ASSERT_RTNL();
+
+	mutex_lock(&local->beacon_lock);
+	ret = mac802154_send_beacons_locked(sdata, request);
+	mutex_unlock(&local->beacon_lock);
+
+	return ret;
+}
+
+static int mac802154_stop_beacons(struct wpan_phy *wpan_phy,
+				  struct wpan_dev *wpan_dev)
+{
+	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
+	int ret;
+
+	ASSERT_RTNL();
+
+	mutex_lock(&local->beacon_lock);
+	ret = mac802154_stop_beacons_locked(local);
+	mutex_unlock(&local->beacon_lock);
+
+	return ret;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static void
 ieee802154_get_llsec_table(struct wpan_phy *wpan_phy,
@@ -507,6 +540,8 @@ const struct cfg802154_ops mac802154_config_ops = {
 	.set_ackreq_default = ieee802154_set_ackreq_default,
 	.trigger_scan = mac802154_trigger_scan,
 	.abort_scan = mac802154_abort_scan,
+	.send_beacons = mac802154_send_beacons,
+	.stop_beacons = mac802154_stop_beacons,
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	.get_llsec_table = ieee802154_get_llsec_table,
 	.lock_llsec_table = ieee802154_lock_llsec_table,
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 46394e2e0486..f70848b60469 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -23,6 +23,7 @@
 
 enum ieee802154_ongoing {
 	IEEE802154_IS_SCANNING = BIT(0),
+	IEEE802154_IS_BEACONING = BIT(1),
 };
 
 /* mac802154 device private data */
@@ -60,6 +61,13 @@ struct ieee802154_local {
 	struct cfg802154_scan_request __rcu *scan_req;
 	struct delayed_work scan_work;
 
+	/* Beaconing */
+	struct mutex beacon_lock;
+	unsigned int beacon_interval;
+	struct ieee802154_beacon_frame beacon;
+	struct cfg802154_beacon_request __rcu *beacon_req;
+	struct delayed_work beacon_work;
+
 	/* Asynchronous tasks */
 	struct list_head rx_beacon_list;
 	struct work_struct rx_beacon_work;
@@ -239,6 +247,16 @@ static inline bool mac802154_is_scanning(struct ieee802154_local *local)
 	return test_bit(IEEE802154_IS_SCANNING, &local->ongoing);
 }
 
+void mac802154_beacon_worker(struct work_struct *work);
+int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_beacon_request *request);
+int mac802154_stop_beacons_locked(struct ieee802154_local *local);
+
+static inline bool mac802154_is_beaconing(struct ieee802154_local *local)
+{
+	return test_bit(IEEE802154_IS_BEACONING, &local->ongoing);
+}
+
 /* interface handling */
 int ieee802154_iface_init(void);
 void ieee802154_iface_exit(void);
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 431cc544dbf2..54719d3d19c1 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -321,6 +321,12 @@ static int mac802154_slave_close(struct net_device *dev)
 		mutex_unlock(&local->scan_lock);
 	}
 
+	if (mac802154_is_beaconing(local)) {
+		mutex_lock(&local->beacon_lock);
+		mac802154_stop_beacons_locked(local);
+		mutex_unlock(&local->beacon_lock);
+	}
+
 	mutex_lock(&local->device_lock);
 
 	netif_stop_queue(dev);
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 604fbc5b07df..826a0d2ce395 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -93,6 +93,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	mutex_init(&local->iflist_mtx);
 	mutex_init(&local->device_lock);
 	mutex_init(&local->scan_lock);
+	mutex_init(&local->beacon_lock);
 
 	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
 
@@ -101,6 +102,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_WORK(&local->sync_tx_work, ieee802154_xmit_sync_worker);
 	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_worker);
 	INIT_WORK(&local->rx_beacon_work, mac802154_rx_beacon_worker);
+	INIT_DELAYED_WORK(&local->beacon_work, mac802154_beacon_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index c74f6c3baa95..3dd11ec86d06 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -16,6 +16,13 @@
 #include "driver-ops.h"
 #include "../ieee802154/nl802154.h"
 
+#define IEEE802154_BEACON_MHR_SZ 13
+#define IEEE802154_BEACON_PL_SZ 4
+#define IEEE802154_CRC_SZ 2
+#define IEEE802154_BEACON_SKB_SZ (IEEE802154_BEACON_MHR_SZ + \
+				  IEEE802154_BEACON_PL_SZ + \
+				  IEEE802154_CRC_SZ)
+
 static bool mac802154_check_promiscuous(struct ieee802154_local *local)
 {
 	struct ieee802154_sub_if_data *sdata;
@@ -262,3 +269,138 @@ int mac802154_process_beacon(struct ieee802154_local *local,
 
 	return 0;
 }
+
+static int mac802154_transmit_beacon_locked(struct ieee802154_local *local,
+					    struct wpan_dev *wpan_dev)
+{
+	struct cfg802154_beacon_request *beacon_req;
+	struct ieee802154_sub_if_data *sdata;
+	struct sk_buff *skb;
+	int ret;
+
+	lockdep_assert_held(&local->beacon_lock);
+
+	/* Update the sequence number */
+	local->beacon.mhr.seq = atomic_inc_return(&wpan_dev->bsn);
+
+	skb = alloc_skb(IEEE802154_BEACON_SKB_SZ, GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	beacon_req = rcu_dereference_protected(local->beacon_req,
+					       &local->beacon_lock);
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(beacon_req->wpan_dev);
+	skb->dev = sdata->dev;
+
+	ret = ieee802154_beacon_push(skb, &local->beacon);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	return ieee802154_mlme_tx_one(local, sdata, skb);
+}
+
+void mac802154_beacon_worker(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, beacon_work.work);
+	struct cfg802154_beacon_request *beacon_req;
+	int ret;
+
+	mutex_lock(&local->beacon_lock);
+
+	if (!mac802154_is_beaconing(local))
+		goto unlock_mutex;
+
+	if (local->suspended)
+		goto queue_work;
+
+	beacon_req = rcu_dereference_protected(local->beacon_req,
+					       &local->beacon_lock);
+
+	ret = mac802154_transmit_beacon_locked(local, beacon_req->wpan_dev);
+	if (ret)
+		pr_err("Error when transmitting beacon (%d)\n", ret);
+
+queue_work:
+	if (local->beacon_interval >= 0)
+		queue_delayed_work(local->workqueue, &local->beacon_work,
+				   local->beacon_interval);
+
+unlock_mutex:
+	mutex_unlock(&local->beacon_lock);
+}
+
+static void mac802154_end_beaconing(struct ieee802154_local *local)
+{
+	struct cfg802154_beacon_request *beacon_req;
+	struct ieee802154_sub_if_data *sdata;
+
+	beacon_req = rcu_dereference_protected(local->beacon_req,
+					       &local->beacon_lock);
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(beacon_req->wpan_dev);
+
+	if (local->beacon_interval >= 0)
+		cancel_delayed_work(&local->beacon_work);
+
+	clear_bit(IEEE802154_IS_BEACONING, &local->ongoing);
+	nl802154_end_beaconing(beacon_req->wpan_dev, beacon_req);
+}
+
+int mac802154_stop_beacons_locked(struct ieee802154_local *local)
+{
+	lockdep_assert_held(&local->beacon_lock);
+
+	if (!mac802154_is_beaconing(local))
+		return -ESRCH;
+
+	mac802154_end_beaconing(local);
+
+	return 0;
+}
+
+int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_beacon_request *request)
+{
+	struct ieee802154_local *local = sdata->local;
+
+	lockdep_assert_held(&local->beacon_lock);
+
+	if (mac802154_is_beaconing(local))
+		mac802154_stop_beacons_locked(local);
+
+	/* Store scanning parameters */
+	rcu_assign_pointer(local->beacon_req, request);
+
+	set_bit(IEEE802154_IS_BEACONING, &local->ongoing);
+
+	memset(&local->beacon, 0, sizeof(local->beacon));
+	local->beacon.mhr.fc.type = IEEE802154_FC_TYPE_BEACON;
+	local->beacon.mhr.fc.security_enabled = 0;
+	local->beacon.mhr.fc.frame_pending = 0;
+	local->beacon.mhr.fc.ack_request = 0;
+	local->beacon.mhr.fc.intra_pan = 0;
+	local->beacon.mhr.fc.dest_addr_mode = IEEE802154_NO_ADDRESSING;
+	local->beacon.mhr.fc.version = IEEE802154_2003_STD;
+	local->beacon.mhr.fc.source_addr_mode = IEEE802154_EXTENDED_ADDRESSING;
+	atomic_set(&request->wpan_dev->bsn, -1);
+	local->beacon.mhr.source.mode = IEEE802154_ADDR_LONG;
+	local->beacon.mhr.source.pan_id = cpu_to_le16(request->wpan_dev->pan_id);
+	local->beacon.mhr.source.extended_addr = cpu_to_le64(request->wpan_dev->extended_addr);
+	local->beacon.mac_pl.beacon_order = request->interval;
+	local->beacon.mac_pl.superframe_order = request->interval;
+	local->beacon.mac_pl.final_cap_slot = 0xf;
+	local->beacon.mac_pl.battery_life_ext = 0;
+	/* TODO: Fill this field depending on the coordinator capacity */
+	local->beacon.mac_pl.pan_coordinator = 1;
+	local->beacon.mac_pl.assoc_permit = 0;
+
+	/* Start the beacon work */
+	local->beacon_interval =
+		mac802154_scan_get_channel_time(request->interval,
+						request->wpan_phy->symbol_duration);
+	queue_delayed_work(local->workqueue, &local->beacon_work, 0);
+
+	return 0;
+}
-- 
2.34.1

