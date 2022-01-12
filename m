Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2613648C9AF
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355761AbiALRea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:34:30 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:58677 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350095AbiALReF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:34:05 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 53A692001A;
        Wed, 12 Jan 2022 17:34:02 +0000 (UTC)
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
Subject: [wpan-next v2 23/27] net: mac802154: Add support for active scans
Date:   Wed, 12 Jan 2022 18:33:08 +0100
Message-Id: <20220112173312.764660-24-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Active scan support is based on the current passive scan support,
cheered up with beacon requests sent after every channel change.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h | 14 ++++++++-
 net/ieee802154/header_ops.c     | 25 +++++++++++++++++
 net/mac802154/ieee802154_i.h    |  1 +
 net/mac802154/scan.c            | 50 +++++++++++++++++++++++++++++++--
 4 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index f7716aeec93b..1bf1a4e508a2 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -58,6 +58,11 @@ struct ieee802154_beacon_hdr {
 #endif
 } __packed;
 
+struct ieee802154_mac_cmd_pl {
+	u8  cmd_id;
+	/* TODO: content depending on the cmd_id */
+} __packed;
+
 struct ieee802154_sechdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	u8 level:3,
@@ -139,6 +144,11 @@ struct ieee802154_hdr {
 	struct ieee802154_sechdr sec;
 };
 
+struct ieee802154_beacon_req_frame {
+	struct ieee802154_hdr mhr;
+	struct ieee802154_mac_cmd_pl mac_pl;
+};
+
 struct ieee802154_beacon_frame {
 	struct ieee802154_hdr mhr;
 	struct ieee802154_beacon_hdr mac_pl;
@@ -169,7 +179,9 @@ int ieee802154_hdr_peek_addrs(const struct sk_buff *skb,
  */
 int ieee802154_hdr_peek(const struct sk_buff *skb, struct ieee802154_hdr *hdr);
 
-/* pushes a beacon frame into an skb */
+/* pushes a beacon_req or a beacon frame into an skb */
+int ieee802154_beacon_req_push(struct sk_buff *skb,
+			       struct ieee802154_beacon_req_frame *breq);
 int ieee802154_beacon_push(struct sk_buff *skb,
 			   struct ieee802154_beacon_frame *beacon);
 
diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index bab710aa36f9..c31a9e429a14 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -121,6 +121,31 @@ ieee802154_hdr_push(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 }
 EXPORT_SYMBOL_GPL(ieee802154_hdr_push);
 
+int ieee802154_beacon_req_push(struct sk_buff *skb,
+			       struct ieee802154_beacon_req_frame *breq)
+{
+	struct ieee802154_mac_cmd_pl *mac_pl = &breq->mac_pl;
+	struct ieee802154_hdr *mhr = &breq->mhr;
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
+	crc = crc_ccitt(0, skb->data, skb->len);
+	put_unaligned_le16(crc, skb_put(skb, 2));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ieee802154_beacon_req_push);
+
 int ieee802154_beacon_push(struct sk_buff *skb,
 			   struct ieee802154_beacon_frame *beacon)
 {
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 4feb9181ff4f..19c840500bd8 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -56,6 +56,7 @@ struct ieee802154_local {
 	struct cfg802154_scan_request __rcu *scan_req;
 	struct ieee802154_sub_if_data __rcu *scan_sdata;
 	struct delayed_work scan_work;
+	struct ieee802154_beacon_req_frame beacon_req;
 
 	/* Beacons handling */
 	bool ongoing_beacons_request;
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index 091cf6fdff41..a3ff65d5bb7a 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -19,10 +19,15 @@
 
 #define IEEE802154_BEACON_MHR_SZ 13
 #define IEEE802154_BEACON_PL_SZ 4
+#define IEEE802154_BEACON_REQ_MHR_SZ 7
+#define IEEE802154_BEACON_REQ_PL_SZ 1
 #define IEEE802154_CRC_SZ 2
 #define IEEE802154_BEACON_SKB_SZ (IEEE802154_BEACON_MHR_SZ + \
 				  IEEE802154_BEACON_PL_SZ + \
 				  IEEE802154_CRC_SZ)
+#define IEEE802154_BEACON_REQ_SKB_SZ (IEEE802154_BEACON_REQ_MHR_SZ + \
+				      IEEE802154_BEACON_REQ_PL_SZ +  \
+				      IEEE802154_CRC_SZ)
 
 static bool mac802154_check_promiscuous(struct ieee802154_local *local)
 {
@@ -167,6 +172,41 @@ int mac802154_stop_beacons_locked(struct ieee802154_local *local)
 	return 0;
 }
 
+static int mac802154_scan_prepare_beacon_req(struct ieee802154_local *local)
+{
+	memset(&local->beacon_req, 0, sizeof(local->beacon_req));
+	local->beacon_req.mhr.fc.type = IEEE802154_FC_TYPE_MAC_CMD;
+	local->beacon_req.mhr.fc.dest_addr_mode = IEEE802154_SHORT_ADDRESSING;
+	local->beacon_req.mhr.fc.version = IEEE802154_2003_STD;
+	local->beacon_req.mhr.fc.source_addr_mode = IEEE802154_NO_ADDRESSING;
+	local->beacon_req.mhr.dest.mode = IEEE802154_ADDR_SHORT;
+	local->beacon_req.mhr.dest.pan_id = cpu_to_le16(IEEE802154_PANID_BROADCAST);
+	local->beacon_req.mhr.dest.short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
+	local->beacon_req.mac_pl.cmd_id = IEEE802154_CMD_BEACON_REQ;
+
+	return 0;
+}
+
+static int mac802154_scan_send_beacon_req_locked(struct ieee802154_local *local)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	lockdep_assert_held(&local->scan_lock);
+
+	skb = alloc_skb(IEEE802154_BEACON_REQ_SKB_SZ, GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	ret = ieee802154_beacon_req_push(skb, &local->beacon_req);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	return drv_xmit_async(local, skb);
+}
+
 static int mac802154_scan_send_beacon_locked(struct ieee802154_local *local,
 					     struct wpan_dev *wpan_dev)
 {
@@ -236,6 +276,9 @@ void mac802154_scan_work(struct work_struct *work)
 		ieee802154_set_symbol_duration(local->phy);
 	} while (ret);
 
+	if (scan_req->type == NL802154_SCAN_ACTIVE)
+		mac802154_scan_send_beacon_req_locked(local);
+
 queue_work:
 	scan_duration = mac802154_scan_get_channel_time(scan_req->duration,
 							local->phy->symbol_duration);
@@ -262,8 +305,8 @@ int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
 	if (mac802154_scan_is_ongoing(local))
 		return -EBUSY;
 
-	/* TODO: support other scanning type */
-	if (request->type != NL802154_SCAN_PASSIVE)
+	if (request->type != NL802154_SCAN_PASSIVE &&
+	    request->type != NL802154_SCAN_ACTIVE)
 		return -EOPNOTSUPP;
 
 	/* Store scanning parameters */
@@ -276,6 +319,9 @@ int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
 	else
 		local->scan_addr = cpu_to_le64(get_unaligned_be64(sdata->dev->dev_addr));
 
+	if (request->type == NL802154_SCAN_ACTIVE)
+		mac802154_scan_prepare_beacon_req(local);
+
 	local->scan_channel_idx = -1;
 	atomic_set(&local->scanning, 1);
 
-- 
2.27.0

