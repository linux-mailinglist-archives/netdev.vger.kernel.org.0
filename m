Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127039D7B9
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbfHZUqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:46:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46897 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfHZUqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:46:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id m3so11270302pgv.13
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 13:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WfNfmvDIl8+20GCBOvA/ClA6LfWT8yG8LtUMQTFz/IY=;
        b=BgJW1IOlcVRVk1IV39rXxJ7RpKUP8R6NKVqKt+7TdObrbYEqNSTOFvig+nReK2pnOM
         2ccYagImcGek+1Juq+iDRScp8YezwQJIN90+idrtksKD1+MohNhxRd2Dh+ljh4qaOejq
         tsR9zq21KlwuNQDBaDYOhZNc99i8O5DQgyZjsNeAtTH+2S+EcPBV5xW3ufrnJJfkexoI
         YbSuAmvFLUTLNBpCf79jXixXKtmmQWtjA/RFId/m7FzQghgDW79EN2V80tAo3/VEkfx7
         ZztemcwZKg7T6yL7tsvpMtWBxRs4VC2CJ4P6TrKzWQ5E2MZmkAf9f9h67ookAECRheT/
         fElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WfNfmvDIl8+20GCBOvA/ClA6LfWT8yG8LtUMQTFz/IY=;
        b=UluWvMtC4WVr63lBtxOjvwl6MUT2E9Ea2Xgcm5Wg8LtorAGV6TBPQemW91B3xJvtRe
         DzMuyHighdzz0st3c5vnpBvBzLsl5PZn7fyd/Z/0LH4iwJOrxHXVhgn3vzgKYURzFguT
         1h8XzgoIJnByGesHX42vt1wIU/qh+2Sop+IxZi+Gjs6v9YYRSes6q8dzatVVGa4EPwN1
         dRxLbPQoKiwYm+SpQKjf0T05cIxzH/Fis7D5yTG/muCEcq//UuEaay2T8RhPiC+IXgz4
         hy79gEfhEzQWX/cBGvIpItyYns7F56Y70Y8leVk7+ShWU91C4u9QMe/8Rxr2l9Sw+aXP
         n3Ew==
X-Gm-Message-State: APjAAAVHBmSyxNTg7LiLbuuBDSAOpHt7vEWZrl+yqAGv92L92wC2APhm
        bPLQvhm6HRXEs/I9s8BWUiuIw9CF
X-Google-Smtp-Source: APXvYqxwPoyJCnorwfVb+FALAfeQChYYm7BFp27JHaUSastMY8kPTu/vr4AsogKBFJxoY/xqyxO5ug==
X-Received: by 2002:a63:c246:: with SMTP id l6mr18394289pgg.210.1566852365693;
        Mon, 26 Aug 2019 13:46:05 -0700 (PDT)
Received: from gizo.domain (97-115-90-227.ptld.qwest.net. [97.115.90.227])
        by smtp.gmail.com with ESMTPSA id ev3sm941223pjb.3.2019.08.26.13.46.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 13:46:03 -0700 (PDT)
From:   Greg Rose <gvrose8192@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     joe@wand.net.nz, Greg Rose <gvrose8192@gmail.com>
Subject: [PATCH V2 net 1/2] openvswitch: Properly set L4 keys on "later" IP fragments
Date:   Mon, 26 Aug 2019 13:45:58 -0700
Message-Id: <1566852359-8028-1-git-send-email-gvrose8192@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IP fragments are reassembled before being sent to conntrack, the
key from the last fragment is used.  Unless there are reordering
issues, the last fragment received will not contain the L4 ports, so the
key for the reassembled datagram won't contain them.  This patch updates
the key once we have a reassembled datagram.

The handle_fragments() function works on L3 headers so we pull the L3/L4
flow key update code from key_extract into a new function
'key_extract_l3l4'.  Then we add a another new function
ovs_flow_key_update_l3l4() and export it so that it is accessible by
handle_fragments() for conntrack packet reassembly.

Co-authored by: Justin Pettit <jpettit@ovn.org>
Signed-off-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/conntrack.c |   5 ++
 net/openvswitch/flow.c      | 161 ++++++++++++++++++++++++++------------------
 net/openvswitch/flow.h      |   1 +
 3 files changed, 101 insertions(+), 66 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index d8da647..05249eb 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -525,6 +525,11 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
 		return -EPFNOSUPPORT;
 	}
 
+	/* The key extracted from the fragment that completed this datagram
+	 * likely didn't have an L4 header, so regenerate it.
+	 */
+	ovs_flow_key_update_l3l4(skb, key);
+
 	key->ip.frag = OVS_FRAG_TYPE_NONE;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index bc89e16..ea12ee6 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -523,78 +523,15 @@ static int parse_nsh(struct sk_buff *skb, struct sw_flow_key *key)
 }
 
 /**
- * key_extract - extracts a flow key from an Ethernet frame.
+ * key_extract_l3l4 - extracts L3/L4 header information.
  * @skb: sk_buff that contains the frame, with skb->data pointing to the
- * Ethernet header
+ *       L3 header
  * @key: output flow key
  *
- * The caller must ensure that skb->len >= ETH_HLEN.
- *
- * Returns 0 if successful, otherwise a negative errno value.
- *
- * Initializes @skb header fields as follows:
- *
- *    - skb->mac_header: the L2 header.
- *
- *    - skb->network_header: just past the L2 header, or just past the
- *      VLAN header, to the first byte of the L2 payload.
- *
- *    - skb->transport_header: If key->eth.type is ETH_P_IP or ETH_P_IPV6
- *      on output, then just past the IP header, if one is present and
- *      of a correct length, otherwise the same as skb->network_header.
- *      For other key->eth.type values it is left untouched.
- *
- *    - skb->protocol: the type of the data starting at skb->network_header.
- *      Equals to key->eth.type.
  */
-static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
+static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
 {
 	int error;
-	struct ethhdr *eth;
-
-	/* Flags are always used as part of stats */
-	key->tp.flags = 0;
-
-	skb_reset_mac_header(skb);
-
-	/* Link layer. */
-	clear_vlan(key);
-	if (ovs_key_mac_proto(key) == MAC_PROTO_NONE) {
-		if (unlikely(eth_type_vlan(skb->protocol)))
-			return -EINVAL;
-
-		skb_reset_network_header(skb);
-		key->eth.type = skb->protocol;
-	} else {
-		eth = eth_hdr(skb);
-		ether_addr_copy(key->eth.src, eth->h_source);
-		ether_addr_copy(key->eth.dst, eth->h_dest);
-
-		__skb_pull(skb, 2 * ETH_ALEN);
-		/* We are going to push all headers that we pull, so no need to
-		* update skb->csum here.
-		*/
-
-		if (unlikely(parse_vlan(skb, key)))
-			return -ENOMEM;
-
-		key->eth.type = parse_ethertype(skb);
-		if (unlikely(key->eth.type == htons(0)))
-			return -ENOMEM;
-
-		/* Multiple tagged packets need to retain TPID to satisfy
-		 * skb_vlan_pop(), which will later shift the ethertype into
-		 * skb->protocol.
-		 */
-		if (key->eth.cvlan.tci & htons(VLAN_CFI_MASK))
-			skb->protocol = key->eth.cvlan.tpid;
-		else
-			skb->protocol = key->eth.type;
-
-		skb_reset_network_header(skb);
-		__skb_push(skb, skb->data - skb_mac_header(skb));
-	}
-	skb_reset_mac_len(skb);
 
 	/* Network layer. */
 	if (key->eth.type == htons(ETH_P_IP)) {
@@ -788,6 +725,98 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 	return 0;
 }
 
+/**
+ * key_extract - extracts a flow key from an Ethernet frame.
+ * @skb: sk_buff that contains the frame, with skb->data pointing to the
+ * Ethernet header
+ * @key: output flow key
+ *
+ * The caller must ensure that skb->len >= ETH_HLEN.
+ *
+ * Returns 0 if successful, otherwise a negative errno value.
+ *
+ * Initializes @skb header fields as follows:
+ *
+ *    - skb->mac_header: the L2 header.
+ *
+ *    - skb->network_header: just past the L2 header, or just past the
+ *      VLAN header, to the first byte of the L2 payload.
+ *
+ *    - skb->transport_header: If key->eth.type is ETH_P_IP or ETH_P_IPV6
+ *      on output, then just past the IP header, if one is present and
+ *      of a correct length, otherwise the same as skb->network_header.
+ *      For other key->eth.type values it is left untouched.
+ *
+ *    - skb->protocol: the type of the data starting at skb->network_header.
+ *      Equals to key->eth.type.
+ */
+static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
+{
+	struct ethhdr *eth;
+
+	/* Flags are always used as part of stats */
+	key->tp.flags = 0;
+
+	skb_reset_mac_header(skb);
+
+	/* Link layer. */
+	clear_vlan(key);
+	if (ovs_key_mac_proto(key) == MAC_PROTO_NONE) {
+		if (unlikely(eth_type_vlan(skb->protocol)))
+			return -EINVAL;
+
+		skb_reset_network_header(skb);
+		key->eth.type = skb->protocol;
+	} else {
+		eth = eth_hdr(skb);
+		ether_addr_copy(key->eth.src, eth->h_source);
+		ether_addr_copy(key->eth.dst, eth->h_dest);
+
+		__skb_pull(skb, 2 * ETH_ALEN);
+		/* We are going to push all headers that we pull, so no need to
+		 * update skb->csum here.
+		 */
+
+		if (unlikely(parse_vlan(skb, key)))
+			return -ENOMEM;
+
+		key->eth.type = parse_ethertype(skb);
+		if (unlikely(key->eth.type == htons(0)))
+			return -ENOMEM;
+
+		/* Multiple tagged packets need to retain TPID to satisfy
+		 * skb_vlan_pop(), which will later shift the ethertype into
+		 * skb->protocol.
+		 */
+		if (key->eth.cvlan.tci & htons(VLAN_CFI_MASK))
+			skb->protocol = key->eth.cvlan.tpid;
+		else
+			skb->protocol = key->eth.type;
+
+		skb_reset_network_header(skb);
+		__skb_push(skb, skb->data - skb_mac_header(skb));
+	}
+
+	skb_reset_mac_len(skb);
+
+	/* Fill out L3/L4 key info, if any */
+	return key_extract_l3l4(skb, key);
+}
+
+/* In the case of conntrack fragment handling it expects L3 headers,
+ * add a helper.
+ */
+int ovs_flow_key_update_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
+{
+	int res;
+
+	res = key_extract_l3l4(skb, key);
+	if (!res)
+		key->mac_proto &= ~SW_FLOW_KEY_INVALID;
+
+	return res;
+}
+
 int ovs_flow_key_update(struct sk_buff *skb, struct sw_flow_key *key)
 {
 	int res;
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index a5506e2..b830d5f 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -270,6 +270,7 @@ void ovs_flow_stats_get(const struct sw_flow *, struct ovs_flow_stats *,
 u64 ovs_flow_used_time(unsigned long flow_jiffies);
 
 int ovs_flow_key_update(struct sk_buff *skb, struct sw_flow_key *key);
+int ovs_flow_key_update_l3l4(struct sk_buff *skb, struct sw_flow_key *key);
 int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 			 struct sk_buff *skb,
 			 struct sw_flow_key *key);
-- 
1.8.3.1

