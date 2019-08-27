Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A0D9EBAF
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 16:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfH0O6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 10:58:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45029 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfH0O6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 10:58:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so12830759pgl.11
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 07:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YUmQvmE5jf4PSQSn031V6nO1WFPnl12Acb8du50TUyQ=;
        b=kCaQ4mlLlV+m3TuchMHUedXBkopwgB1L7cBEvGB46HBznh6j0VNaLFFM3FMCvOo1qD
         m051ExFyPWdbEIk55SzqGshWbH69SUzQX3f6oXzyP1/88+3qoSQcdzxTEZxFpTEIHh/5
         qNyvBELo44AnspwxW3OadfVm1mhzaT43+4873xe7DbGsSO5p/KIy9HXMu8t3N+e3+3ad
         A94Ctu9GT3GNK6fHZ3ldj6K6AnhPXVZ2diiTivadIJHld3OobiDCbHWdH15u8nlYVm1V
         iBqWwCe/lpepr7ZevsfBOYwuNHHGrXMxKeXRyPlKZMdiuMUQM7Tt2OSC6S+WDHaTC/+G
         XbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YUmQvmE5jf4PSQSn031V6nO1WFPnl12Acb8du50TUyQ=;
        b=SxviiYFpupZ2ar9EfsfUVQxI1oYnoSVliyPY+whZK/R2GjAbYrm8KDR4sk7Fuonv0H
         3QkhHrRF5/o+zC6R/pH+HU9Sb4rA5SMIZh+FMRvq+P6lG+pKVeaG0fo8kmEGSt9ZuveJ
         T3fATJZrc8ebVFXaivE8QyOZYHtQn1OS+tWLyOkAFMIXA0fvIgcTV1FI6CZpyQi+Vp4A
         V4/Q2XTQSlEmbg9PQyg2O7+9WX5ZYtpCGnSBApWDsS74+pjCXBXpN+oWGo1gpY8CddgY
         TDk+UVERZohj+xJ6Lt/y2M2aRsI31lXImdE2INYetXHOA0Dm7BDP8xyIMhyyFUqKm4dm
         dr7w==
X-Gm-Message-State: APjAAAUAn58JZGKs72VtEIrLNkDHwWV/HF7CKuB+t4Ub6s7JvsACguE/
        7HhOSuihGnhB52BGRy3ksZL0+SYE
X-Google-Smtp-Source: APXvYqw6qD7Sauf81OxmQ3B/GOMPWR/+ZaKlOsoyyvyUftAgHrAP71UYv+An0XTpBwSXcwN9OPFTbQ==
X-Received: by 2002:a05:6a00:46:: with SMTP id i6mr26984198pfk.196.1566917893978;
        Tue, 27 Aug 2019 07:58:13 -0700 (PDT)
Received: from gizo.domain (97-115-90-227.ptld.qwest.net. [97.115.90.227])
        by smtp.gmail.com with ESMTPSA id k64sm17502626pge.65.2019.08.27.07.58.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 07:58:13 -0700 (PDT)
From:   Greg Rose <gvrose8192@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     joe@wand.net.nz, Greg Rose <gvrose8192@gmail.com>
Subject: [PATCH V3 net 1/2] openvswitch: Properly set L4 keys on "later" IP fragments
Date:   Tue, 27 Aug 2019 07:58:09 -0700
Message-Id: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
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
V1 - V2: Broke out key l3l4 extraction
V2 - V3: Remove code that cleared SW_FLOW_KEY_INVALID for l3l4
         extraction
---
 net/openvswitch/conntrack.c |   5 ++
 net/openvswitch/flow.c      | 155 +++++++++++++++++++++++++-------------------
 net/openvswitch/flow.h      |   1 +
 3 files changed, 95 insertions(+), 66 deletions(-)

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
index bc89e16..005f762 100644
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
@@ -788,6 +725,92 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
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
+	return key_extract_l3l4(skb, key);
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

