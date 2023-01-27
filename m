Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167A667E21E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjA0KqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjA0Kp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:45:59 -0500
X-Greylist: delayed 1452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 Jan 2023 02:45:49 PST
Received: from mail.simonwunderlich.de (mail.simonwunderlich.de [23.88.38.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E16A5D6
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:45:49 -0800 (PST)
Received: from kero.packetmixer.de (p200300c5973eAEd8832e80845eB11F67.dip0.t-ipconnect.de [IPv6:2003:c5:973e:aed8:832e:8084:5eb1:1f67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.simonwunderlich.de (Postfix) with ESMTPSA id 079BFFAFDF;
        Fri, 27 Jan 2023 11:21:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
        s=09092022; t=1674814898; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MK+d6FbIkx5s3HDyrJ2NgoLkQ+O/0R6/CLTiWhdeB6g=;
        b=GBd6K/8Rcw81AvdM5GNzn3NeyjtDCC1+Gd1vz/WZ185lBGIr45CpTyqeqx0DP+vvEGOXfa
        aXhsIAmOgbZL6Z5KkuCBU2QGWB3WhU+rY9SKd9hCJ9W3roohAMjLtUi8gV9vxtDin5elQ4
        8ewaBMv4GbZBzFaY4fQL01GY9Vk99raxrc7Svc0sw80+tTp+0GdSIqgiLXMf3xzV6Me/P9
        ZNKEYQ7n/1z+i9sNIZCNevQm7kjfM7r5cbBMUfG9CBE0X0F4ejApkKz3U0wsr7qpBZ4oHL
        drRCfz4mWe0xXYJVNKuPuvIr3j4u8oOeRxZ2tyhUUfAGlM2k6awDrQ6DJX7xCg==
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5/5] batman-adv: tvlv: prepare for tvlv enabled multicast packet type
Date:   Fri, 27 Jan 2023 11:21:33 +0100
Message-Id: <20230127102133.700173-6-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127102133.700173-1-sw@simonwunderlich.de>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=simonwunderlich.de; s=09092022; t=1674814898;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MK+d6FbIkx5s3HDyrJ2NgoLkQ+O/0R6/CLTiWhdeB6g=;
        b=Mnxkb75BCgQzMmW1g+uOlnH065FHMvpiX7rUz2ViTEet+QenOoGInNPvEBw/ORf+8S28di
        IOxf4+cufA5YBpx94lBno2DfeMR4i/6g2p+pWwYWAeuUDvk6mpe+chNWCdxHqv1vs7caGp
        Iik5SUniKtQ+GVNW5I2YOXH0oMZJTaqHl2BgYJcu2wmOnDRNbiiwdgp6KKpJjMGSxEVFVJ
        mRu2hoQW5MrtcyVgWOFRT+yIvj/42Ic/sFjLwc0FFrC4zwsn0QYDYEYT13sWsH6urmyauK
        ugRZlsvGhc+X2oXLNxCyAKZrF1ztcq7WJCA/Aeu3Wvpm/9sB/5cpnxNh/Ep3hA==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1674814898; a=rsa-sha256;
        cv=none;
        b=xtTwoDH7Vz4bhvvqnsEgpBqkrpK9j87Brgy7O0vU+oyU2lwgFNOsUF5ipe0HcyBLo/U9BAkSiS5HkKUR1e3j4805jEVMXCfUz/OsE8UZdDwLZXcxrDtJ7ub/8ewXvn9vXnUkj/EqTKSgm2cIhzwEGiXQ2NdChywvzYLbrLE4EVHFWAnvo6OSG5kR6axUQoPYwh62qNS5ICmTKUiSjzux40K3D44zP9jjxlEPwQqFLM2pZvRqEpRO5VP1GGI6vjms3DBaimJkoG4sJNDjKPXk+uM0Rhgj3wff4BYrfqOESU780s0tgsw/aTha646D9up5xQVCFPnslzBP3TzFMJ/1yg==
ARC-Authentication-Results: i=1;
        mail.simonwunderlich.de;
        auth=pass smtp.auth=sw@simonwunderlich.de smtp.mailfrom=sw@simonwunderlich.de
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

Prepare TVLV infrastructure for more packet types, in particular the
upcoming batman-adv multicast packet type.

For that swap the OGM vs. unicast-tvlv packet boolean indicator to an
explicit unsigned integer packet type variable. And provide the skb
to a call to batadv_tvlv_containers_process(), as later the multicast
packet's TVLV handler will need to have access not only to the TVLV but
the full skb for forwarding. Forwarding will be invoked from the
multicast packet's TVLVs' contents later.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 include/uapi/linux/batadv_packet.h     |  2 +
 net/batman-adv/bat_v_ogm.c             |  4 +-
 net/batman-adv/distributed-arp-table.c |  2 +-
 net/batman-adv/gateway_common.c        |  2 +-
 net/batman-adv/multicast.c             |  2 +-
 net/batman-adv/network-coding.c        |  2 +-
 net/batman-adv/routing.c               |  7 ++-
 net/batman-adv/translation-table.c     |  4 +-
 net/batman-adv/tvlv.c                  | 71 ++++++++++++++++++--------
 net/batman-adv/tvlv.h                  |  9 ++--
 net/batman-adv/types.h                 |  6 +++
 11 files changed, 74 insertions(+), 37 deletions(-)

diff --git a/include/uapi/linux/batadv_packet.h b/include/uapi/linux/batadv_packet.h
index ea4692c339ce..9204e4494b25 100644
--- a/include/uapi/linux/batadv_packet.h
+++ b/include/uapi/linux/batadv_packet.h
@@ -26,6 +26,7 @@
  * @BATADV_CODED: network coded packets
  * @BATADV_ELP: echo location packets for B.A.T.M.A.N. V
  * @BATADV_OGM2: originator messages for B.A.T.M.A.N. V
+ * @BATADV_MCAST: multicast packet with multiple destination addresses
  *
  * @BATADV_UNICAST: unicast packets carrying unicast payload traffic
  * @BATADV_UNICAST_FRAG: unicast packets carrying a fragment of the original
@@ -42,6 +43,7 @@ enum batadv_packettype {
 	BATADV_CODED            = 0x02,
 	BATADV_ELP		= 0x03,
 	BATADV_OGM2		= 0x04,
+	BATADV_MCAST            = 0x05,
 	/* 0x40 - 0x7f: unicast */
 #define BATADV_UNICAST_MIN     0x40
 	BATADV_UNICAST          = 0x40,
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 96e027364ddd..e710e9afe78f 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -799,8 +799,8 @@ batadv_v_ogm_process_per_outif(struct batadv_priv *bat_priv,
 
 	/* only unknown & newer OGMs contain TVLVs we are interested in */
 	if (seqno_age > 0 && if_outgoing == BATADV_IF_DEFAULT)
-		batadv_tvlv_containers_process(bat_priv, true, orig_node,
-					       NULL, NULL,
+		batadv_tvlv_containers_process(bat_priv, BATADV_OGM2, orig_node,
+					       NULL,
 					       (unsigned char *)(ogm2 + 1),
 					       ntohs(ogm2->tvlv_len));
 
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index fefb51a5f606..6968e55eb971 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -822,7 +822,7 @@ int batadv_dat_init(struct batadv_priv *bat_priv)
 	batadv_dat_start_timer(bat_priv);
 
 	batadv_tvlv_handler_register(bat_priv, batadv_dat_tvlv_ogm_handler_v1,
-				     NULL, BATADV_TVLV_DAT, 1,
+				     NULL, NULL, BATADV_TVLV_DAT, 1,
 				     BATADV_TVLV_HANDLER_OGM_CIFNOTFND);
 	batadv_dat_tvlv_container_update(bat_priv);
 	return 0;
diff --git a/net/batman-adv/gateway_common.c b/net/batman-adv/gateway_common.c
index 9349c76f30c5..6a964a773f57 100644
--- a/net/batman-adv/gateway_common.c
+++ b/net/batman-adv/gateway_common.c
@@ -259,7 +259,7 @@ void batadv_gw_init(struct batadv_priv *bat_priv)
 		atomic_set(&bat_priv->gw.sel_class, 1);
 
 	batadv_tvlv_handler_register(bat_priv, batadv_gw_tvlv_ogm_handler_v1,
-				     NULL, BATADV_TVLV_GW, 1,
+				     NULL, NULL, BATADV_TVLV_GW, 1,
 				     BATADV_TVLV_HANDLER_OGM_CIFNOTFND);
 }
 
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 7e2822c01e00..315394f12c55 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -1818,7 +1818,7 @@ static void batadv_mcast_tvlv_ogm_handler(struct batadv_priv *bat_priv,
 void batadv_mcast_init(struct batadv_priv *bat_priv)
 {
 	batadv_tvlv_handler_register(bat_priv, batadv_mcast_tvlv_ogm_handler,
-				     NULL, BATADV_TVLV_MCAST, 2,
+				     NULL, NULL, BATADV_TVLV_MCAST, 2,
 				     BATADV_TVLV_HANDLER_OGM_CIFNOTFND);
 
 	INIT_DELAYED_WORK(&bat_priv->mcast.work, batadv_mcast_mla_update);
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index ecd871abda34..71ebd0284f95 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -160,7 +160,7 @@ int batadv_nc_mesh_init(struct batadv_priv *bat_priv)
 	batadv_nc_start_timer(bat_priv);
 
 	batadv_tvlv_handler_register(bat_priv, batadv_nc_tvlv_ogm_handler_v1,
-				     NULL, BATADV_TVLV_NC, 1,
+				     NULL, NULL, BATADV_TVLV_NC, 1,
 				     BATADV_TVLV_HANDLER_OGM_CIFNOTFND);
 	batadv_nc_tvlv_container_update(bat_priv);
 	return 0;
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 83f31494ea4d..163cd43c4821 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1073,10 +1073,9 @@ int batadv_recv_unicast_tvlv(struct sk_buff *skb,
 	if (tvlv_buff_len > skb->len - hdr_size)
 		goto free_skb;
 
-	ret = batadv_tvlv_containers_process(bat_priv, false, NULL,
-					     unicast_tvlv_packet->src,
-					     unicast_tvlv_packet->dst,
-					     tvlv_buff, tvlv_buff_len);
+	ret = batadv_tvlv_containers_process(bat_priv, BATADV_UNICAST_TVLV,
+					     NULL, skb, tvlv_buff,
+					     tvlv_buff_len);
 
 	if (ret != NET_RX_SUCCESS) {
 		ret = batadv_route_unicast_packet(skb, recv_if);
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 01d30c1e412c..36ca31252a73 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -4168,11 +4168,11 @@ int batadv_tt_init(struct batadv_priv *bat_priv)
 	}
 
 	batadv_tvlv_handler_register(bat_priv, batadv_tt_tvlv_ogm_handler_v1,
-				     batadv_tt_tvlv_unicast_handler_v1,
+				     batadv_tt_tvlv_unicast_handler_v1, NULL,
 				     BATADV_TVLV_TT, 1, BATADV_NO_FLAGS);
 
 	batadv_tvlv_handler_register(bat_priv, NULL,
-				     batadv_roam_tvlv_unicast_handler_v1,
+				     batadv_roam_tvlv_unicast_handler_v1, NULL,
 				     BATADV_TVLV_ROAM, 1, BATADV_NO_FLAGS);
 
 	INIT_DELAYED_WORK(&bat_priv->tt.work, batadv_tt_purge);
diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index 7ec2e2343884..2a583215d439 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -352,10 +352,9 @@ u16 batadv_tvlv_container_ogm_append(struct batadv_priv *bat_priv,
  *  appropriate handlers
  * @bat_priv: the bat priv with all the soft interface information
  * @tvlv_handler: tvlv callback function handling the tvlv content
- * @ogm_source: flag indicating whether the tvlv is an ogm or a unicast packet
+ * @packet_type: indicates for which packet type the TVLV handler is called
  * @orig_node: orig node emitting the ogm packet
- * @src: source mac address of the unicast packet
- * @dst: destination mac address of the unicast packet
+ * @skb: the skb the TVLV handler is called for
  * @tvlv_value: tvlv content
  * @tvlv_value_len: tvlv content length
  *
@@ -364,15 +363,20 @@ u16 batadv_tvlv_container_ogm_append(struct batadv_priv *bat_priv,
  */
 static int batadv_tvlv_call_handler(struct batadv_priv *bat_priv,
 				    struct batadv_tvlv_handler *tvlv_handler,
-				    bool ogm_source,
+				    u8 packet_type,
 				    struct batadv_orig_node *orig_node,
-				    u8 *src, u8 *dst,
-				    void *tvlv_value, u16 tvlv_value_len)
+				    struct sk_buff *skb, void *tvlv_value,
+				    u16 tvlv_value_len)
 {
+	unsigned int tvlv_offset;
+	u8 *src, *dst;
+
 	if (!tvlv_handler)
 		return NET_RX_SUCCESS;
 
-	if (ogm_source) {
+	switch (packet_type) {
+	case BATADV_IV_OGM:
+	case BATADV_OGM2:
 		if (!tvlv_handler->ogm_handler)
 			return NET_RX_SUCCESS;
 
@@ -383,19 +387,32 @@ static int batadv_tvlv_call_handler(struct batadv_priv *bat_priv,
 					  BATADV_NO_FLAGS,
 					  tvlv_value, tvlv_value_len);
 		tvlv_handler->flags |= BATADV_TVLV_HANDLER_OGM_CALLED;
-	} else {
-		if (!src)
-			return NET_RX_SUCCESS;
-
-		if (!dst)
+		break;
+	case BATADV_UNICAST_TVLV:
+		if (!skb)
 			return NET_RX_SUCCESS;
 
 		if (!tvlv_handler->unicast_handler)
 			return NET_RX_SUCCESS;
 
+		src = ((struct batadv_unicast_tvlv_packet *)skb->data)->src;
+		dst = ((struct batadv_unicast_tvlv_packet *)skb->data)->dst;
+
 		return tvlv_handler->unicast_handler(bat_priv, src,
 						     dst, tvlv_value,
 						     tvlv_value_len);
+	case BATADV_MCAST:
+		if (!skb)
+			return NET_RX_SUCCESS;
+
+		if (!tvlv_handler->mcast_handler)
+			return NET_RX_SUCCESS;
+
+		tvlv_offset = (unsigned char *)tvlv_value - skb->data;
+		skb_set_network_header(skb, tvlv_offset);
+		skb_set_transport_header(skb, tvlv_offset + tvlv_value_len);
+
+		return tvlv_handler->mcast_handler(bat_priv, skb);
 	}
 
 	return NET_RX_SUCCESS;
@@ -405,10 +422,9 @@ static int batadv_tvlv_call_handler(struct batadv_priv *bat_priv,
  * batadv_tvlv_containers_process() - parse the given tvlv buffer to call the
  *  appropriate handlers
  * @bat_priv: the bat priv with all the soft interface information
- * @ogm_source: flag indicating whether the tvlv is an ogm or a unicast packet
+ * @packet_type: indicates for which packet type the TVLV handler is called
  * @orig_node: orig node emitting the ogm packet
- * @src: source mac address of the unicast packet
- * @dst: destination mac address of the unicast packet
+ * @skb: the skb the TVLV handler is called for
  * @tvlv_value: tvlv content
  * @tvlv_value_len: tvlv content length
  *
@@ -416,10 +432,10 @@ static int batadv_tvlv_call_handler(struct batadv_priv *bat_priv,
  * handler callbacks.
  */
 int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
-				   bool ogm_source,
+				   u8 packet_type,
 				   struct batadv_orig_node *orig_node,
-				   u8 *src, u8 *dst,
-				   void *tvlv_value, u16 tvlv_value_len)
+				   struct sk_buff *skb, void *tvlv_value,
+				   u16 tvlv_value_len)
 {
 	struct batadv_tvlv_handler *tvlv_handler;
 	struct batadv_tvlv_hdr *tvlv_hdr;
@@ -441,20 +457,24 @@ int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
 						       tvlv_hdr->version);
 
 		ret |= batadv_tvlv_call_handler(bat_priv, tvlv_handler,
-						ogm_source, orig_node,
-						src, dst, tvlv_value,
+						packet_type, orig_node, skb,
+						tvlv_value,
 						tvlv_value_cont_len);
 		batadv_tvlv_handler_put(tvlv_handler);
 		tvlv_value = (u8 *)tvlv_value + tvlv_value_cont_len;
 		tvlv_value_len -= tvlv_value_cont_len;
 	}
 
-	if (!ogm_source)
+	if (packet_type != BATADV_IV_OGM &&
+	    packet_type != BATADV_OGM2)
 		return ret;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(tvlv_handler,
 				 &bat_priv->tvlv.handler_list, list) {
+		if (!tvlv_handler->ogm_handler)
+			continue;
+
 		if ((tvlv_handler->flags & BATADV_TVLV_HANDLER_OGM_CIFNOTFND) &&
 		    !(tvlv_handler->flags & BATADV_TVLV_HANDLER_OGM_CALLED))
 			tvlv_handler->ogm_handler(bat_priv, orig_node,
@@ -490,7 +510,7 @@ void batadv_tvlv_ogm_receive(struct batadv_priv *bat_priv,
 
 	tvlv_value = batadv_ogm_packet + 1;
 
-	batadv_tvlv_containers_process(bat_priv, true, orig_node, NULL, NULL,
+	batadv_tvlv_containers_process(bat_priv, BATADV_IV_OGM, orig_node, NULL,
 				       tvlv_value, tvlv_value_len);
 }
 
@@ -504,6 +524,10 @@ void batadv_tvlv_ogm_receive(struct batadv_priv *bat_priv,
  * @uptr: unicast tvlv handler callback function. This function receives the
  *  source & destination of the unicast packet as well as the tvlv content
  *  to process.
+ * @mptr: multicast packet tvlv handler callback function. This function
+ *  receives the full skb to process, with the skb network header pointing
+ *  to the current tvlv and the skb transport header pointing to the first
+ *  byte after the current tvlv.
  * @type: tvlv handler type to be registered
  * @version: tvlv handler version to be registered
  * @flags: flags to enable or disable TVLV API behavior
@@ -518,6 +542,8 @@ void batadv_tvlv_handler_register(struct batadv_priv *bat_priv,
 					      u8 *src, u8 *dst,
 					      void *tvlv_value,
 					      u16 tvlv_value_len),
+				  int (*mptr)(struct batadv_priv *bat_priv,
+					      struct sk_buff *skb),
 				  u8 type, u8 version, u8 flags)
 {
 	struct batadv_tvlv_handler *tvlv_handler;
@@ -539,6 +565,7 @@ void batadv_tvlv_handler_register(struct batadv_priv *bat_priv,
 
 	tvlv_handler->ogm_handler = optr;
 	tvlv_handler->unicast_handler = uptr;
+	tvlv_handler->mcast_handler = mptr;
 	tvlv_handler->type = type;
 	tvlv_handler->version = version;
 	tvlv_handler->flags = flags;
diff --git a/net/batman-adv/tvlv.h b/net/batman-adv/tvlv.h
index 4cf8af00fc11..e5697230d991 100644
--- a/net/batman-adv/tvlv.h
+++ b/net/batman-adv/tvlv.h
@@ -9,6 +9,7 @@
 
 #include "main.h"
 
+#include <linux/skbuff.h>
 #include <linux/types.h>
 #include <uapi/linux/batadv_packet.h>
 
@@ -34,14 +35,16 @@ void batadv_tvlv_handler_register(struct batadv_priv *bat_priv,
 					      u8 *src, u8 *dst,
 					      void *tvlv_value,
 					      u16 tvlv_value_len),
+				  int (*mptr)(struct batadv_priv *bat_priv,
+					      struct sk_buff *skb),
 				  u8 type, u8 version, u8 flags);
 void batadv_tvlv_handler_unregister(struct batadv_priv *bat_priv,
 				    u8 type, u8 version);
 int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
-				   bool ogm_source,
+				   u8 packet_type,
 				   struct batadv_orig_node *orig_node,
-				   u8 *src, u8 *dst,
-				   void *tvlv_buff, u16 tvlv_buff_len);
+				   struct sk_buff *skb, void *tvlv_buff,
+				   u16 tvlv_buff_len);
 void batadv_tvlv_unicast_send(struct batadv_priv *bat_priv, const u8 *src,
 			      const u8 *dst, u8 type, u8 version,
 			      void *tvlv_value, u16 tvlv_value_len);
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 758cd797a063..ca9449ec9836 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -2335,6 +2335,12 @@ struct batadv_tvlv_handler {
 			       u8 *src, u8 *dst,
 			       void *tvlv_value, u16 tvlv_value_len);
 
+	/**
+	 * @mcast_handler: handler callback which is given the tvlv payload to
+	 *  process on incoming mcast packet
+	 */
+	int (*mcast_handler)(struct batadv_priv *bat_priv, struct sk_buff *skb);
+
 	/** @type: tvlv type this handler feels responsible for */
 	u8 type;
 
-- 
2.30.2

