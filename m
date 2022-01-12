Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B04048C9A7
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355741AbiALRe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:34:28 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:55733 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355720AbiALReC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:34:02 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 152B420004;
        Wed, 12 Jan 2022 17:33:58 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 21/27] net: mac802154: Handle beacons requests
Date:   Wed, 12 Jan 2022 18:33:06 +0100
Message-Id: <20220112173312.764660-22-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the core hooks in order to provide the softMAC layer support
for sending beacons. Besides being able to test the full passive
scanning procedure, this will also be used when defining PAN coordinator
status, in order to give a device the right to answer received
BEACON_REQ.

Changing the channels is prohibited while a beacon operation is
ongoing.

The implementation uses a workqueue triggered at a certain interval
depending on the symbol duration for the current channel and the
interval order provided.

Sending beacons in response to an active scan request is not
yet supported.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h |  24 +++++++
 net/ieee802154/header_ops.c     |  29 ++++++++
 net/mac802154/cfg.c             |  41 ++++++++++-
 net/mac802154/ieee802154_i.h    |  13 ++++
 net/mac802154/main.c            |   2 +
 net/mac802154/scan.c            | 119 ++++++++++++++++++++++++++++++++
 6 files changed, 226 insertions(+), 2 deletions(-)

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
index c1e7bbea3058..afba02c31850 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -109,8 +109,10 @@ int ieee802154_change_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 
 	ASSERT_RTNL();
 
-	/* Refuse to change channels during a scanning operation */
-	if (mac802154_scan_is_ongoing(local))
+	/* Refuse to change channels during a scanning operation or when a
+	 * beacons request is ongoing.
+	 */
+	if (mac802154_scan_is_ongoing(local) || local->ongoing_beacons_request)
 		return -EBUSY;
 
 	ret = drv_set_channel(local, page, channel);
@@ -305,6 +307,39 @@ static int mac802154_abort_scan(struct wpan_phy *wpan_phy,
 	return ret;
 }
 
+static int mac802154_send_beacons(struct wpan_phy *wpan_phy,
+				  struct cfg802154_beacons_request *request)
+{
+	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
+	struct ieee802154_sub_if_data *sdata;
+	int ret;
+
+	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(request->wpan_dev);
+
+	ASSERT_RTNL();
+
+	mutex_lock(&local->beacons_lock);
+	ret = mac802154_send_beacons_locked(sdata, request);
+	mutex_unlock(&local->beacons_lock);
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
+	mutex_lock(&local->beacons_lock);
+	ret = mac802154_stop_beacons_locked(local);
+	mutex_unlock(&local->beacons_lock);
+
+	return ret;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static void
 ieee802154_get_llsec_table(struct wpan_phy *wpan_phy,
@@ -514,6 +549,8 @@ const struct cfg802154_ops mac802154_config_ops = {
 	.set_ackreq_default = ieee802154_set_ackreq_default,
 	.trigger_scan = mac802154_trigger_scan,
 	.abort_scan = mac802154_abort_scan,
+	.send_beacons = mac802154_send_beacons,
+	.stop_beacons = mac802154_stop_beacons,
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	.get_llsec_table = ieee802154_get_llsec_table,
 	.lock_llsec_table = ieee802154_lock_llsec_table,
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 5cc3ac8fd4a1..4feb9181ff4f 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -57,6 +57,14 @@ struct ieee802154_local {
 	struct ieee802154_sub_if_data __rcu *scan_sdata;
 	struct delayed_work scan_work;
 
+	/* Beacons handling */
+	bool ongoing_beacons_request;
+	struct mutex beacons_lock;
+	unsigned int beacons_interval;
+	struct delayed_work beacons_work;
+	struct ieee802154_sub_if_data __rcu *beacons_sdata;
+	struct ieee802154_beacon_frame beacon;
+
 	bool started;
 	bool suspended;
 
@@ -189,6 +197,11 @@ static inline bool mac802154_scan_is_ongoing(struct ieee802154_local *local)
 	return atomic_read(&local->scanning);
 }
 
+void mac802154_beacons_work(struct work_struct *work);
+int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_beacons_request *request);
+int mac802154_stop_beacons_locked(struct ieee802154_local *local);
+
 /* interface handling */
 int ieee802154_iface_init(void);
 void ieee802154_iface_exit(void);
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 09e2fc6848cb..f342c7c5165e 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -91,6 +91,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
 	mutex_init(&local->scan_lock);
+	mutex_init(&local->beacons_lock);
 
 	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
 
@@ -98,6 +99,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	INIT_WORK(&local->tx_work, ieee802154_xmit_worker);
 	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_work);
+	INIT_DELAYED_WORK(&local->beacons_work, mac802154_beacons_work);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index 7be63d73caa9..091cf6fdff41 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -17,6 +17,13 @@
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
@@ -104,6 +111,86 @@ static unsigned int mac802154_scan_get_channel_time(u8 duration_order,
 				(BIT(duration_order) + 1));
 }
 
+int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
+				  struct cfg802154_beacons_request *request)
+{
+	struct ieee802154_local *local = sdata->local;
+
+	lockdep_assert_held(&local->beacons_lock);
+
+	if (local->ongoing_beacons_request)
+		return -EBUSY;
+
+	local->ongoing_beacons_request = true;
+
+	memset(&local->beacon, 0, sizeof(local->beacon));
+	local->beacon.mhr.fc.type = IEEE802154_BEACON_FRAME;
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
+	local->beacon.mac_pl.pan_coordinator = 1;
+	local->beacon.mac_pl.assoc_permit = 1;
+
+	rcu_assign_pointer(local->beacons_sdata, sdata);
+
+	/* Start the beacon work */
+	local->beacons_interval =
+		mac802154_scan_get_channel_time(request->interval,
+						request->wpan_phy->symbol_duration);
+	ieee802154_queue_delayed_work(&local->hw, &local->beacons_work, 0);
+
+	return 0;
+}
+
+int mac802154_stop_beacons_locked(struct ieee802154_local *local)
+{
+	lockdep_assert_held(&local->beacons_lock);
+
+	if (!local->ongoing_beacons_request)
+		return -ESRCH;
+
+	local->ongoing_beacons_request = false;
+	cancel_delayed_work(&local->beacons_work);
+
+	return 0;
+}
+
+static int mac802154_scan_send_beacon_locked(struct ieee802154_local *local,
+					     struct wpan_dev *wpan_dev)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	lockdep_assert_held(&local->beacons_lock);
+
+	/* Update the sequence number */
+	local->beacon.mhr.seq = atomic_inc_return(&wpan_dev->bsn);
+
+	skb = alloc_skb(IEEE802154_BEACON_SKB_SZ, GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	ret = ieee802154_beacon_push(skb, &local->beacon);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	return drv_xmit_async(local, skb);
+}
+
 void mac802154_scan_work(struct work_struct *work)
 {
 	struct ieee802154_local *local =
@@ -205,6 +292,38 @@ int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
 	return 0;
 }
 
+void mac802154_beacons_work(struct work_struct *work)
+{
+	struct ieee802154_local *local =
+		container_of(work, struct ieee802154_local, beacons_work.work);
+	struct ieee802154_sub_if_data *sdata;
+	struct wpan_dev *wpan_dev;
+	int ret;
+
+	mutex_lock(&local->beacons_lock);
+
+	if (!local->ongoing_beacons_request)
+		goto unlock_mutex;
+
+	if (local->suspended)
+		goto queue_work;
+
+	sdata = rcu_dereference_protected(local->beacons_sdata,
+					  lockdep_is_held(&local->beacons_lock));
+	wpan_dev = &sdata->wpan_dev;
+
+	ret = mac802154_scan_send_beacon_locked(local, wpan_dev);
+	if (ret)
+		pr_err("Error when transmitting beacon (%d)\n", ret);
+
+queue_work:
+	ieee802154_queue_delayed_work(&local->hw, &local->beacons_work,
+				      local->beacons_interval);
+
+unlock_mutex:
+	mutex_unlock(&local->beacons_lock);
+}
+
 int mac802154_scan_process_beacon(struct ieee802154_local *local,
 				  struct sk_buff *skb)
 {
-- 
2.27.0

