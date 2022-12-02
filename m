Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CBC6401B1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiLBIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiLBIMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:12:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4475AF66
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:12:36 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1p119p-0005AB-QP; Fri, 02 Dec 2022 09:12:29 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1p119o-001lGj-8w; Fri, 02 Dec 2022 09:12:29 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1p119m-00BfDp-Sd; Fri, 02 Dec 2022 09:12:26 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v5 06/11] wifi: rtw88: iterate over vif/sta list non-atomically
Date:   Fri,  2 Dec 2022 09:12:19 +0100
Message-Id: <20221202081224.2779981-7-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221202081224.2779981-1-s.hauer@pengutronix.de>
References: <20221202081224.2779981-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses ieee80211_iterate_active_interfaces_atomic()
and ieee80211_iterate_stations_atomic() in several places and does
register accesses in the iterators. This doesn't cope with upcoming
USB support as registers can only be accessed non-atomically.

Split these into a two stage process: First use the atomic iterator
functions to collect all active interfaces or stations on a list, then
iterate over the list non-atomically and call the iterator on each
entry.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Suggested-by: Ping-Ke shih <pkshih@realtek.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes since v1:
    - Change subject
    - Add some lockdep_assert_held(&rtwdev->mutex);
    - make locally used functions static
    - Add comment how &rtwdev->mutex protects us from stations/interfaces
      being deleted between collecting them and iterating over them.

 drivers/net/wireless/realtek/rtw88/phy.c  |   6 +-
 drivers/net/wireless/realtek/rtw88/ps.c   |   2 +-
 drivers/net/wireless/realtek/rtw88/util.c | 103 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/util.h |  12 ++-
 4 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index bd7d05e080848..128e75a81bf3c 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -300,7 +300,7 @@ static void rtw_phy_stat_rssi(struct rtw_dev *rtwdev)
 
 	data.rtwdev = rtwdev;
 	data.min_rssi = U8_MAX;
-	rtw_iterate_stas_atomic(rtwdev, rtw_phy_stat_rssi_iter, &data);
+	rtw_iterate_stas(rtwdev, rtw_phy_stat_rssi_iter, &data);
 
 	dm_info->pre_min_rssi = dm_info->min_rssi;
 	dm_info->min_rssi = data.min_rssi;
@@ -544,7 +544,7 @@ static void rtw_phy_ra_info_update(struct rtw_dev *rtwdev)
 	if (rtwdev->watch_dog_cnt & 0x3)
 		return;
 
-	rtw_iterate_stas_atomic(rtwdev, rtw_phy_ra_info_update_iter, rtwdev);
+	rtw_iterate_stas(rtwdev, rtw_phy_ra_info_update_iter, rtwdev);
 }
 
 static u32 rtw_phy_get_rrsr_mask(struct rtw_dev *rtwdev, u8 rate_idx)
@@ -597,7 +597,7 @@ static void rtw_phy_rrsr_update(struct rtw_dev *rtwdev)
 	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
 
 	dm_info->rrsr_mask_min = RRSR_RATE_ORDER_MAX;
-	rtw_iterate_stas_atomic(rtwdev, rtw_phy_rrsr_mask_min_iter, rtwdev);
+	rtw_iterate_stas(rtwdev, rtw_phy_rrsr_mask_min_iter, rtwdev);
 	rtw_write32(rtwdev, REG_RRSR, dm_info->rrsr_val_init & dm_info->rrsr_mask_min);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
index c93da743681fc..11594940d6b00 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -61,7 +61,7 @@ int rtw_leave_ips(struct rtw_dev *rtwdev)
 		return ret;
 	}
 
-	rtw_iterate_vifs_atomic(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
+	rtw_iterate_vifs(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
 
 	rtw_coex_ips_notify(rtwdev, COEX_IPS_LEAVE);
 
diff --git a/drivers/net/wireless/realtek/rtw88/util.c b/drivers/net/wireless/realtek/rtw88/util.c
index cdfd66a85075a..ff3c269fb1a72 100644
--- a/drivers/net/wireless/realtek/rtw88/util.c
+++ b/drivers/net/wireless/realtek/rtw88/util.c
@@ -105,3 +105,106 @@ void rtw_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
 		*mcs = rate - DESC_RATEMCS0;
 	}
 }
+
+struct rtw_stas_entry {
+	struct list_head list;
+	struct ieee80211_sta *sta;
+};
+
+struct rtw_iter_stas_data {
+	struct rtw_dev *rtwdev;
+	struct list_head list;
+};
+
+static void rtw_collect_sta_iter(void *data, struct ieee80211_sta *sta)
+{
+	struct rtw_iter_stas_data *iter_stas = data;
+	struct rtw_stas_entry *stas_entry;
+
+	stas_entry = kmalloc(sizeof(*stas_entry), GFP_ATOMIC);
+	if (!stas_entry)
+		return;
+
+	stas_entry->sta = sta;
+	list_add_tail(&stas_entry->list, &iter_stas->list);
+}
+
+void rtw_iterate_stas(struct rtw_dev *rtwdev,
+		      void (*iterator)(void *data,
+				       struct ieee80211_sta *sta),
+		      void *data)
+{
+	struct rtw_iter_stas_data iter_data;
+	struct rtw_stas_entry *sta_entry, *tmp;
+
+	/* &rtwdev->mutex makes sure no stations can be removed between
+	 * collecting the stations and iterating over them.
+	 */
+	lockdep_assert_held(&rtwdev->mutex);
+
+	iter_data.rtwdev = rtwdev;
+	INIT_LIST_HEAD(&iter_data.list);
+
+	ieee80211_iterate_stations_atomic(rtwdev->hw, rtw_collect_sta_iter,
+					  &iter_data);
+
+	list_for_each_entry_safe(sta_entry, tmp, &iter_data.list,
+				 list) {
+		list_del_init(&sta_entry->list);
+		iterator(data, sta_entry->sta);
+		kfree(sta_entry);
+	}
+}
+
+struct rtw_vifs_entry {
+	struct list_head list;
+	struct ieee80211_vif *vif;
+	u8 mac[ETH_ALEN];
+};
+
+struct rtw_iter_vifs_data {
+	struct rtw_dev *rtwdev;
+	struct list_head list;
+};
+
+static void rtw_collect_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct rtw_iter_vifs_data *iter_stas = data;
+	struct rtw_vifs_entry *vifs_entry;
+
+	vifs_entry = kmalloc(sizeof(*vifs_entry), GFP_ATOMIC);
+	if (!vifs_entry)
+		return;
+
+	vifs_entry->vif = vif;
+	ether_addr_copy(vifs_entry->mac, mac);
+	list_add_tail(&vifs_entry->list, &iter_stas->list);
+}
+
+void rtw_iterate_vifs(struct rtw_dev *rtwdev,
+		      void (*iterator)(void *data, u8 *mac,
+				       struct ieee80211_vif *vif),
+		      void *data)
+{
+	struct rtw_iter_vifs_data iter_data;
+	struct rtw_vifs_entry *vif_entry, *tmp;
+
+	/* &rtwdev->mutex makes sure no interfaces can be removed between
+	 * collecting the interfaces and iterating over them.
+	 */
+	lockdep_assert_held(&rtwdev->mutex);
+
+	iter_data.rtwdev = rtwdev;
+	INIT_LIST_HEAD(&iter_data.list);
+
+	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   rtw_collect_vif_iter, &iter_data);
+
+	list_for_each_entry_safe(vif_entry, tmp, &iter_data.list,
+				 list) {
+		list_del_init(&vif_entry->list);
+		iterator(data, vif_entry->mac, vif_entry->vif);
+		kfree(vif_entry);
+	}
+}
diff --git a/drivers/net/wireless/realtek/rtw88/util.h b/drivers/net/wireless/realtek/rtw88/util.h
index 0c23b5069be0b..dc89655254002 100644
--- a/drivers/net/wireless/realtek/rtw88/util.h
+++ b/drivers/net/wireless/realtek/rtw88/util.h
@@ -7,9 +7,6 @@
 
 struct rtw_dev;
 
-#define rtw_iterate_vifs(rtwdev, iterator, data)                               \
-	ieee80211_iterate_active_interfaces(rtwdev->hw,                        \
-			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
 #define rtw_iterate_vifs_atomic(rtwdev, iterator, data)                        \
 	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,                 \
 			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
@@ -20,6 +17,15 @@ struct rtw_dev;
 #define rtw_iterate_keys_rcu(rtwdev, vif, iterator, data)		       \
 	ieee80211_iter_keys_rcu((rtwdev)->hw, vif, iterator, data)
 
+void rtw_iterate_vifs(struct rtw_dev *rtwdev,
+		      void (*iterator)(void *data, u8 *mac,
+				       struct ieee80211_vif *vif),
+		      void *data);
+void rtw_iterate_stas(struct rtw_dev *rtwdev,
+		      void (*iterator)(void *data,
+				       struct ieee80211_sta *sta),
+				       void *data);
+
 static inline u8 *get_hdr_bssid(struct ieee80211_hdr *hdr)
 {
 	__le16 fc = hdr->frame_control;
-- 
2.30.2

