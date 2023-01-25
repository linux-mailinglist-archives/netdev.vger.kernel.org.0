Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F7167AFB2
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbjAYK3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbjAYK3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:29:36 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53454670F;
        Wed, 25 Jan 2023 02:29:31 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B0D5524000D;
        Wed, 25 Jan 2023 10:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674642570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VwF7m6yQPrH+2jKMyWya18GYJTDXNGB3Acb+NLw3yVA=;
        b=AzOkhTpWp5DQuo4/7shjpfT7fxIJG0wMPFNdS92EhrM+Yp/1MAKL5js2gDqpG7f2tMCQeA
        2V7KZkXmzQ6z1g8YT9PLX0El7CuuGsj8dPQW8SrPkpCuhUYFFnNw2vdP5lCmx7coymKkyX
        9OmzgyM/4XSlVQNjMxJloPLj3814VtexWgjSd6C16GDNLdKa7vd2flmfIMWtN1NIJ9pwhV
        JiSfN8vdxCwPgt7d+jGBFtYN+aHLne2eUc3qwgF3GmsIriLJdnQSRdRSuIMkkPw9yPzRNU
        V3U5Sy+XYDEX35YWUSdqAXZrGGaBaxBUX9jAhgtnsNPDukXQR1r/VBw30Ut8rg==
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
Subject: [PATCH wpan-next v2 2/2] mac802154: Handle basic beaconing
Date:   Wed, 25 Jan 2023 11:29:23 +0100
Message-Id: <20230125102923.135465-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125102923.135465-1-miquel.raynal@bootlin.com>
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
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

This initial patchset has no security support (llsec).

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h |  16 ++++
 net/ieee802154/header_ops.c     |  24 +++++
 net/mac802154/cfg.c             |  31 ++++++-
 net/mac802154/ieee802154_i.h    |  18 ++++
 net/mac802154/iface.c           |   3 +
 net/mac802154/llsec.c           |   5 +-
 net/mac802154/main.c            |   1 +
 net/mac802154/scan.c            | 151 ++++++++++++++++++++++++++++++++
 8 files changed, 246 insertions(+), 3 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index 2f2196049a86..da8a3e648c7a 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -129,6 +129,13 @@ enum ieee802154_frame_version {
 	IEEE802154_MULTIPURPOSE_STD = IEEE802154_2003_STD,
 };
 
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
@@ -137,6 +144,11 @@ struct ieee802154_hdr {
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
@@ -162,6 +174,10 @@ int ieee802154_hdr_peek_addrs(const struct sk_buff *skb,
  */
 int ieee802154_hdr_peek(const struct sk_buff *skb, struct ieee802154_hdr *hdr);
 
+/* pushes a beacon frame into an skb */
+int ieee802154_beacon_push(struct sk_buff *skb,
+			   struct ieee802154_beacon_frame *beacon);
+
 int ieee802154_max_payload(const struct ieee802154_hdr *hdr);
 
 static inline int
diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index af337cf62764..35d384dfe29d 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -120,6 +120,30 @@ ieee802154_hdr_push(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 }
 EXPORT_SYMBOL_GPL(ieee802154_hdr_push);
 
+int ieee802154_beacon_push(struct sk_buff *skb,
+			   struct ieee802154_beacon_frame *beacon)
+{
+	struct ieee802154_beacon_hdr *mac_pl = &beacon->mac_pl;
+	struct ieee802154_hdr *mhr = &beacon->mhr;
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
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ieee802154_beacon_push);
+
 static int
 ieee802154_hdr_get_addr(const u8 *buf, int mode, bool omit_pan,
 			struct ieee802154_addr *addr)
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index 187cebcaf233..5c3cb019f751 100644
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
@@ -290,6 +290,31 @@ static int mac802154_abort_scan(struct wpan_phy *wpan_phy,
 	return mac802154_abort_scan_locked(local, sdata);
 }
 
+static int mac802154_send_beacons(struct wpan_phy *wpan_phy,
+				  struct cfg802154_beacon_request *request)
+{
+	struct ieee802154_sub_if_data *sdata;
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(request->wpan_dev);
+
+	ASSERT_RTNL();
+
+	return mac802154_send_beacons_locked(sdata, request);
+}
+
+static int mac802154_stop_beacons(struct wpan_phy *wpan_phy,
+				  struct wpan_dev *wpan_dev)
+{
+	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
+	struct ieee802154_sub_if_data *sdata;
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(wpan_dev);
+
+	ASSERT_RTNL();
+
+	return mac802154_stop_beacons_locked(local, sdata);
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static void
 ieee802154_get_llsec_table(struct wpan_phy *wpan_phy,
@@ -499,6 +524,8 @@ const struct cfg802154_ops mac802154_config_ops = {
 	.set_ackreq_default = ieee802154_set_ackreq_default,
 	.trigger_scan = mac802154_trigger_scan,
 	.abort_scan = mac802154_abort_scan,
+	.send_beacons = mac802154_send_beacons,
+	.stop_beacons = mac802154_stop_beacons,
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	.get_llsec_table = ieee802154_get_llsec_table,
 	.lock_llsec_table = ieee802154_lock_llsec_table,
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 0e4db967bd1d..63bab99ed368 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -23,6 +23,7 @@
 
 enum ieee802154_ongoing {
 	IEEE802154_IS_SCANNING = BIT(0),
+	IEEE802154_IS_BEACONING = BIT(1),
 };
 
 /* mac802154 device private data */
@@ -60,6 +61,12 @@ struct ieee802154_local {
 	struct cfg802154_scan_request __rcu *scan_req;
 	struct delayed_work scan_work;
 
+	/* Beaconing */
+	unsigned int beacon_interval;
+	struct ieee802154_beacon_frame beacon;
+	struct cfg802154_beacon_request __rcu *beacon_req;
+	struct delayed_work beacon_work;
+
 	/* Asynchronous tasks */
 	struct list_head rx_beacon_list;
 	struct work_struct rx_beacon_work;
@@ -257,6 +264,17 @@ static inline bool mac802154_is_scanning(struct ieee802154_local *local)
 	return test_bit(IEEE802154_IS_SCANNING, &local->ongoing);
 }
 
+void mac802154_beacon_worker(struct work_struct *work);
+int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_beacon_request *request);
+int mac802154_stop_beacons_locked(struct ieee802154_local *local,
+				  struct ieee802154_sub_if_data *sdata);
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
index a5958d323ea3..9d59caeb74e0 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -305,6 +305,9 @@ static int mac802154_slave_close(struct net_device *dev)
 	if (mac802154_is_scanning(local))
 		mac802154_abort_scan_locked(local, sdata);
 
+	if (mac802154_is_beaconing(local))
+		mac802154_stop_beacons_locked(local, sdata);
+
 	netif_stop_queue(dev);
 	local->open_count--;
 
diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index 55550ead2ced..8d2eabc71bbe 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -707,7 +707,10 @@ int mac802154_llsec_encrypt(struct mac802154_llsec *sec, struct sk_buff *skb)
 
 	hlen = ieee802154_hdr_pull(skb, &hdr);
 
-	if (hlen < 0 || hdr.fc.type != IEEE802154_FC_TYPE_DATA)
+	/* TODO: control frames security support */
+	if (hlen < 0 ||
+	    (hdr.fc.type != IEEE802154_FC_TYPE_DATA &&
+	     hdr.fc.type != IEEE802154_FC_TYPE_BEACON))
 		return -EINVAL;
 
 	if (!hdr.fc.security_enabled ||
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index b1111279e06d..ee23e234b998 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -99,6 +99,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_WORK(&local->sync_tx_work, ieee802154_xmit_sync_worker);
 	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_worker);
 	INIT_WORK(&local->rx_beacon_work, mac802154_rx_beacon_worker);
+	INIT_DELAYED_WORK(&local->beacon_work, mac802154_beacon_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index 56056b9c93c1..cfbe20b1ec5e 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -16,6 +16,11 @@
 #include "driver-ops.h"
 #include "../ieee802154/nl802154.h"
 
+#define IEEE802154_BEACON_MHR_SZ 13
+#define IEEE802154_BEACON_PL_SZ 4
+#define IEEE802154_BEACON_SKB_SZ (IEEE802154_BEACON_MHR_SZ + \
+				  IEEE802154_BEACON_PL_SZ)
+
 /* mac802154_scan_cleanup_locked() must be called upon scan completion or abort.
  * - Completions are asynchronous, not locked by the rtnl and decided by the
  *   scan worker.
@@ -286,3 +291,149 @@ int mac802154_process_beacon(struct ieee802154_local *local,
 
 	return 0;
 }
+
+static int mac802154_transmit_beacon(struct ieee802154_local *local,
+				     struct wpan_dev *wpan_dev)
+{
+	struct cfg802154_beacon_request *beacon_req;
+	struct ieee802154_sub_if_data *sdata;
+	struct sk_buff *skb;
+	int ret;
+
+	/* Update the sequence number */
+	local->beacon.mhr.seq = atomic_inc_return(&wpan_dev->bsn) & 0xFF;
+
+	skb = alloc_skb(IEEE802154_BEACON_SKB_SZ, GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	rcu_read_lock();
+	beacon_req = rcu_dereference(local->beacon_req);
+	if (unlikely(!beacon_req)) {
+		rcu_read_unlock();
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(beacon_req->wpan_dev);
+	skb->dev = sdata->dev;
+
+	rcu_read_unlock();
+
+	ret = ieee802154_beacon_push(skb, &local->beacon);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	return ieee802154_subif_start_xmit(skb, sdata->dev);
+}
+
+void mac802154_beacon_worker(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, beacon_work.work);
+	struct cfg802154_beacon_request *beacon_req;
+	struct ieee802154_sub_if_data *sdata;
+	struct wpan_dev *wpan_dev;
+	int ret;
+
+	rcu_read_lock();
+	beacon_req = rcu_dereference(local->beacon_req);
+	if (unlikely(!beacon_req)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(beacon_req->wpan_dev);
+
+	/* Wait an arbitrary amount of time in case we cannot use the device */
+	if (local->suspended || !ieee802154_sdata_running(sdata)) {
+		rcu_read_unlock();
+		queue_delayed_work(local->mac_wq, &local->beacon_work,
+				   msecs_to_jiffies(1000));
+		return;
+	}
+
+	wpan_dev = beacon_req->wpan_dev;
+
+	rcu_read_unlock();
+
+	dev_dbg(&sdata->dev->dev, "Sending beacon\n");
+	ret = mac802154_transmit_beacon(local, wpan_dev);
+	if (ret)
+		dev_err(&sdata->dev->dev,
+			"Beacon could not be transmitted (%d)\n", ret);
+
+	if (local->beacon_interval >= 0)
+		queue_delayed_work(local->mac_wq, &local->beacon_work,
+				   local->beacon_interval);
+}
+
+int mac802154_stop_beacons_locked(struct ieee802154_local *local,
+				  struct ieee802154_sub_if_data *sdata)
+{
+	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+	struct cfg802154_beacon_request *request;
+
+	ASSERT_RTNL();
+
+	if (!mac802154_is_beaconing(local))
+		return -ESRCH;
+
+	clear_bit(IEEE802154_IS_BEACONING, &local->ongoing);
+	cancel_delayed_work(&local->beacon_work);
+	request = rcu_replace_pointer(local->beacon_req, NULL, 1);
+	if (!request)
+		return 0;
+	kfree_rcu(request);
+
+	nl802154_beaconing_done(wpan_dev);
+
+	return 0;
+}
+
+int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_beacon_request *request)
+{
+	struct ieee802154_local *local = sdata->local;
+
+	ASSERT_RTNL();
+
+	if (mac802154_is_beaconing(local))
+		mac802154_stop_beacons_locked(local, sdata);
+
+	/* Store beaconing parameters */
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
+	local->beacon.mac_pl.assoc_permit = 1;
+
+	/* Start the beacon work */
+	local->beacon_interval =
+		mac802154_scan_get_channel_time(request->interval,
+						request->wpan_phy->symbol_duration);
+	queue_delayed_work(local->mac_wq, &local->beacon_work, 0);
+
+	return 0;
+}
-- 
2.34.1

