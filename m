Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8369D433C2B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJSQca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhJSQca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1C7F61378;
        Tue, 19 Oct 2021 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634661017;
        bh=W9xghcCcnXhNXnZ7J7ltSKmGrsEAnWwQ67SW2rm/EEI=;
        h=From:To:Cc:Subject:Date:From;
        b=lIM1psAEMcappgOVHWuzewbwnQCkQBEdQrZvqrzo30YBCm1ve2D6Q8pRq9F3B/zwo
         4ZTwoeMWXHHQpnZgaFsGPeTXVhk0TDTPI7sksWccLNQQ5e3rrPIZqoJexLvHq/CKGU
         FtkNvonVh3DsjMxFGFIrD+UvtnZfL6ZmEb7fS131hUJlUpzrAIGQoi4ZzJNsLjQdjo
         pUkSC73wMiXbo5mJRyyggdjx7Z4u/nYOTur3tAuLMub71EB7Z5Ijzcq6RiBd7N1EqA
         qWP7cPYpKBPnXkakBCuMEN5BcvpEI5V9eJX49SbEllvhoIZ1X7/NNAFI4LVRYlEerg
         m9u4FgOMUNd3w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH] batman-adv: prepare for const netdev->dev_addr
Date:   Tue, 19 Oct 2021 09:30:07 -0700
Message-Id: <20211019163007.1384352-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr will be constant soon, make sure
the qualifier is propagated thru batman-adv.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mareklindner@neomailbox.ch
CC: sw@simonwunderlich.de
CC: a@unstable.cc
CC: sven@narfation.org
CC: b.a.t.m.a.n@lists.open-mesh.org
---
 net/batman-adv/bridge_loop_avoidance.c | 14 +++++++-------
 net/batman-adv/routing.c               |  3 ++-
 net/batman-adv/tp_meter.c              |  2 +-
 net/batman-adv/tvlv.c                  |  4 ++--
 net/batman-adv/tvlv.h                  |  4 ++--
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 1669744304c5..7242b32fff80 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -254,7 +254,7 @@ batadv_claim_hash_find(struct batadv_priv *bat_priv,
  * Return: backbone gateway if found or NULL otherwise
  */
 static struct batadv_bla_backbone_gw *
-batadv_backbone_hash_find(struct batadv_priv *bat_priv, u8 *addr,
+batadv_backbone_hash_find(struct batadv_priv *bat_priv, const u8 *addr,
 			  unsigned short vid)
 {
 	struct batadv_hashtable *hash = bat_priv->bla.backbone_hash;
@@ -336,7 +336,7 @@ batadv_bla_del_backbone_claims(struct batadv_bla_backbone_gw *backbone_gw)
  * @vid: the VLAN ID
  * @claimtype: the type of the claim (CLAIM, UNCLAIM, ANNOUNCE, ...)
  */
-static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
+static void batadv_bla_send_claim(struct batadv_priv *bat_priv, const u8 *mac,
 				  unsigned short vid, int claimtype)
 {
 	struct sk_buff *skb;
@@ -488,7 +488,7 @@ static void batadv_bla_loopdetect_report(struct work_struct *work)
  * Return: the (possibly created) backbone gateway or NULL on error
  */
 static struct batadv_bla_backbone_gw *
-batadv_bla_get_backbone_gw(struct batadv_priv *bat_priv, u8 *orig,
+batadv_bla_get_backbone_gw(struct batadv_priv *bat_priv, const u8 *orig,
 			   unsigned short vid, bool own_backbone)
 {
 	struct batadv_bla_backbone_gw *entry;
@@ -926,7 +926,7 @@ static bool batadv_handle_request(struct batadv_priv *bat_priv,
  */
 static bool batadv_handle_unclaim(struct batadv_priv *bat_priv,
 				  struct batadv_hard_iface *primary_if,
-				  u8 *backbone_addr, u8 *claim_addr,
+				  const u8 *backbone_addr, const u8 *claim_addr,
 				  unsigned short vid)
 {
 	struct batadv_bla_backbone_gw *backbone_gw;
@@ -964,7 +964,7 @@ static bool batadv_handle_unclaim(struct batadv_priv *bat_priv,
  */
 static bool batadv_handle_claim(struct batadv_priv *bat_priv,
 				struct batadv_hard_iface *primary_if,
-				u8 *backbone_addr, u8 *claim_addr,
+				const u8 *backbone_addr, const u8 *claim_addr,
 				unsigned short vid)
 {
 	struct batadv_bla_backbone_gw *backbone_gw;
@@ -2126,7 +2126,7 @@ batadv_bla_claim_dump_entry(struct sk_buff *msg, u32 portid,
 			    struct batadv_hard_iface *primary_if,
 			    struct batadv_bla_claim *claim)
 {
-	u8 *primary_addr = primary_if->net_dev->dev_addr;
+	const u8 *primary_addr = primary_if->net_dev->dev_addr;
 	u16 backbone_crc;
 	bool is_own;
 	void *hdr;
@@ -2294,7 +2294,7 @@ batadv_bla_backbone_dump_entry(struct sk_buff *msg, u32 portid,
 			       struct batadv_hard_iface *primary_if,
 			       struct batadv_bla_backbone_gw *backbone_gw)
 {
-	u8 *primary_addr = primary_if->net_dev->dev_addr;
+	const u8 *primary_addr = primary_if->net_dev->dev_addr;
 	u16 backbone_crc;
 	bool is_own;
 	int msecs;
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 970d0d7ccc98..83f31494ea4d 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -747,7 +747,8 @@ batadv_reroute_unicast_packet(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	struct batadv_orig_node *orig_node = NULL;
 	struct batadv_hard_iface *primary_if = NULL;
 	bool ret = false;
-	u8 *orig_addr, orig_ttvn;
+	const u8 *orig_addr;
+	u8 orig_ttvn;
 
 	if (batadv_is_my_client(bat_priv, dst_addr, vid)) {
 		primary_if = batadv_primary_if_get_selected(bat_priv);
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 56b9fe97b3b4..fbcb15c7c29b 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -631,9 +631,9 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 	struct batadv_orig_node *orig_node = NULL;
 	const struct batadv_icmp_tp_packet *icmp;
 	struct batadv_tp_vars *tp_vars;
+	const unsigned char *dev_addr;
 	size_t packet_len, mss;
 	u32 rtt, recv_ack, cwnd;
-	unsigned char *dev_addr;
 
 	packet_len = BATADV_TP_PLEN;
 	mss = BATADV_TP_PLEN;
diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index 992773376e51..0cb58eb04093 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -587,8 +587,8 @@ void batadv_tvlv_handler_unregister(struct batadv_priv *bat_priv,
  * @tvlv_value: tvlv content
  * @tvlv_value_len: tvlv content length
  */
-void batadv_tvlv_unicast_send(struct batadv_priv *bat_priv, u8 *src,
-			      u8 *dst, u8 type, u8 version,
+void batadv_tvlv_unicast_send(struct batadv_priv *bat_priv, const u8 *src,
+			      const u8 *dst, u8 type, u8 version,
 			      void *tvlv_value, u16 tvlv_value_len)
 {
 	struct batadv_unicast_tvlv_packet *unicast_tvlv_packet;
diff --git a/net/batman-adv/tvlv.h b/net/batman-adv/tvlv.h
index 54f2a35653d0..4cf8af00fc11 100644
--- a/net/batman-adv/tvlv.h
+++ b/net/batman-adv/tvlv.h
@@ -42,8 +42,8 @@ int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
 				   struct batadv_orig_node *orig_node,
 				   u8 *src, u8 *dst,
 				   void *tvlv_buff, u16 tvlv_buff_len);
-void batadv_tvlv_unicast_send(struct batadv_priv *bat_priv, u8 *src,
-			      u8 *dst, u8 type, u8 version,
+void batadv_tvlv_unicast_send(struct batadv_priv *bat_priv, const u8 *src,
+			      const u8 *dst, u8 type, u8 version,
 			      void *tvlv_value, u16 tvlv_value_len);
 
 #endif /* _NET_BATMAN_ADV_TVLV_H_ */
-- 
2.31.1

