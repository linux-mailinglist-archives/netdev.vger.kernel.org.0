Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF375635CE
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiGAOgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiGAOfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:48 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928A071263;
        Fri,  1 Jul 2022 07:31:24 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D1719FF80F;
        Fri,  1 Jul 2022 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZF5emM9qXS5hnATkCC3lefgrlpraWYGAGXQArQJiruA=;
        b=T6RWaa4R/FQDvMj8s0lerQ8N8SK/CdsTJCtqkpu+iZn1LsoNc2HA3MNirqCfHYlZYbRX+a
        S9fmM6dIbRAe8RIlw46rGKp6oll4GfKWz31MuTW/Jt4NHW3GgNxkRku/RfCd0ff7Di+UXd
        DVmYUmQ7waXmton5qz6cjnV3++WYLQSjINrTc5gKx3f4r/c446FUOqh5i/hA/xssw8sJP2
        lP1AKoi7ZXdMF6NnPsJirU+1lHtmaipXmj1rW8bTcw/Q2zXGwzSR4OBNKDBxfH9LGWEDZ6
        jftBaYfEaDrebj2ibuGhbm/kiM3ZgRpPKQluFSFyDywKIXHdj38yJYSxpO44wQ==
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
Subject: [PATCH wpan-next 14/20] net: mac802154: Handle active scanning
Date:   Fri,  1 Jul 2022 16:30:46 +0200
Message-Id: <20220701143052.1267509-15-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
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

Active scan support is based on the current passive scan support,
cheered up with beacon requests sent after every channel change.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h | 18 ++++++++++-
 net/ieee802154/header_ops.c     | 27 ++++++++++++++++
 net/mac802154/ieee802154_i.h    |  1 +
 net/mac802154/scan.c            | 56 +++++++++++++++++++++++++++++++--
 4 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index f7716aeec93b..21e7e3f66c82 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -58,6 +58,10 @@ struct ieee802154_beacon_hdr {
 #endif
 } __packed;
 
+struct ieee802154_mac_cmd_pl {
+	u8  cmd_id;
+} __packed;
+
 struct ieee802154_sechdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	u8 level:3,
@@ -144,6 +148,16 @@ struct ieee802154_beacon_frame {
 	struct ieee802154_beacon_hdr mac_pl;
 };
 
+struct ieee802154_mac_cmd_frame {
+	struct ieee802154_hdr mhr;
+	struct ieee802154_mac_cmd_pl mac_pl;
+};
+
+struct ieee802154_beacon_req_frame {
+	struct ieee802154_hdr mhr;
+	struct ieee802154_mac_cmd_pl mac_pl;
+};
+
 /* pushes hdr onto the skb. fields of hdr->fc that can be calculated from
  * the contents of hdr will be, and the actual value of those bits in
  * hdr->fc will be ignored. this includes the INTRA_PAN bit and the frame
@@ -169,9 +183,11 @@ int ieee802154_hdr_peek_addrs(const struct sk_buff *skb,
  */
 int ieee802154_hdr_peek(const struct sk_buff *skb, struct ieee802154_hdr *hdr);
 
-/* pushes a beacon frame into an skb */
+/* pushes/pulls various frame types into/from an skb */
 int ieee802154_beacon_push(struct sk_buff *skb,
 			   struct ieee802154_beacon_frame *beacon);
+int ieee802154_mac_cmd_push(struct sk_buff *skb, void *frame,
+			    const void *pl, unsigned int pl_len);
 
 int ieee802154_max_payload(const struct ieee802154_hdr *hdr);
 
diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index bab710aa36f9..795d46c7292d 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -121,6 +121,33 @@ ieee802154_hdr_push(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 }
 EXPORT_SYMBOL_GPL(ieee802154_hdr_push);
 
+int ieee802154_mac_cmd_push(struct sk_buff *skb, void *f,
+			    const void *pl, unsigned int pl_len)
+{
+	struct ieee802154_mac_cmd_frame *frame = f;
+	struct ieee802154_mac_cmd_pl *mac_pl = &frame->mac_pl;
+	struct ieee802154_hdr *mhr = &frame->mhr;
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
+	skb_put_data(skb, pl, pl_len);
+
+	crc = crc_ccitt(0, skb->data, skb->len);
+	put_unaligned_le16(crc, skb_put(skb, 2));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ieee802154_mac_cmd_push);
+
 int ieee802154_beacon_push(struct sk_buff *skb,
 			   struct ieee802154_beacon_frame *beacon)
 {
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index f70848b60469..86a384942e6f 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -58,6 +58,7 @@ struct ieee802154_local {
 	/* Scanning */
 	struct mutex scan_lock;
 	int scan_channel_idx;
+	struct ieee802154_beacon_req_frame scan_beacon_req;
 	struct cfg802154_scan_request __rcu *scan_req;
 	struct delayed_work scan_work;
 
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index 3dd11ec86d06..b9bb784bf388 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -18,10 +18,15 @@
 
 #define IEEE802154_BEACON_MHR_SZ 13
 #define IEEE802154_BEACON_PL_SZ 4
+#define IEEE802154_MAC_CMD_MHR_SZ 7
+#define IEEE802154_MAC_CMD_PL_SZ 1
 #define IEEE802154_CRC_SZ 2
 #define IEEE802154_BEACON_SKB_SZ (IEEE802154_BEACON_MHR_SZ + \
 				  IEEE802154_BEACON_PL_SZ + \
 				  IEEE802154_CRC_SZ)
+#define IEEE802154_MAC_CMD_SKB_SZ (IEEE802154_MAC_CMD_MHR_SZ + \
+				   IEEE802154_MAC_CMD_PL_SZ +  \
+				   IEEE802154_CRC_SZ)
 
 static bool mac802154_check_promiscuous(struct ieee802154_local *local)
 {
@@ -128,6 +133,44 @@ void mac802154_flush_queued_beacons(struct ieee802154_local *local)
 	}
 }
 
+static int mac802154_scan_prepare_beacon_req(struct ieee802154_local *local)
+{
+	memset(&local->scan_beacon_req, 0, sizeof(local->scan_beacon_req));
+	local->scan_beacon_req.mhr.fc.type = IEEE802154_FC_TYPE_MAC_CMD;
+	local->scan_beacon_req.mhr.fc.dest_addr_mode = IEEE802154_SHORT_ADDRESSING;
+	local->scan_beacon_req.mhr.fc.version = IEEE802154_2003_STD;
+	local->scan_beacon_req.mhr.fc.source_addr_mode = IEEE802154_NO_ADDRESSING;
+	local->scan_beacon_req.mhr.dest.mode = IEEE802154_ADDR_SHORT;
+	local->scan_beacon_req.mhr.dest.pan_id = cpu_to_le16(IEEE802154_PANID_BROADCAST);
+	local->scan_beacon_req.mhr.dest.short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
+	local->scan_beacon_req.mac_pl.cmd_id = IEEE802154_CMD_BEACON_REQ;
+
+	return 0;
+}
+
+static int mac802154_transmit_beacon_req_locked(struct ieee802154_local *local,
+						struct ieee802154_sub_if_data *sdata)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	lockdep_assert_held(&local->scan_lock);
+
+	skb = alloc_skb(IEEE802154_MAC_CMD_SKB_SZ, GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	skb->dev = sdata->dev;
+
+	ret = ieee802154_mac_cmd_push(skb, &local->scan_beacon_req, NULL, 0);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	return ieee802154_mlme_tx(local, sdata, skb);
+}
+
 void mac802154_scan_worker(struct work_struct *work)
 {
 	struct ieee802154_local *local =
@@ -173,6 +216,12 @@ void mac802154_scan_worker(struct work_struct *work)
 		mac802154_flush_queued_beacons(local);
 	} while (ret);
 
+	if (scan_req->type == NL802154_SCAN_ACTIVE) {
+		ret = mac802154_transmit_beacon_req_locked(local, sdata);
+		if (ret)
+			pr_err("Error when transmitting beacon request (%d)\n", ret);
+	}
+
 queue_work:
 	scan_duration = mac802154_scan_get_channel_time(scan_req->duration,
 							local->phy->symbol_duration);
@@ -195,13 +244,16 @@ int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
 	if (mac802154_is_scanning(local))
 		return -EBUSY;
 
-	/* TODO: support other scanning type */
-	if (request->type != NL802154_SCAN_PASSIVE)
+	if (request->type != NL802154_SCAN_PASSIVE &&
+	    request->type != NL802154_SCAN_ACTIVE)
 		return -EOPNOTSUPP;
 
 	/* Store scanning parameters */
 	rcu_assign_pointer(local->scan_req, request);
 
+	if (request->type == NL802154_SCAN_ACTIVE)
+		mac802154_scan_prepare_beacon_req(local);
+
 	/* Software scanning requires to set promiscuous mode, so we need to
 	 * pause the Tx queue during the entire operation.
 	 */
-- 
2.34.1

