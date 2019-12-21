Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E6C1286BD
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 04:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfLUDVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 22:21:46 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44127 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfLUDVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 22:21:45 -0500
Received: by mail-pf1-f195.google.com with SMTP id 195so5402153pfw.11
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 19:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=EZStfT8Y3+w7g5IMR3LS7oaTKGYlLTmJ96boV7VDtjw=;
        b=ivO35WQ0tjPT9z3TRQ79vwM1fCy9zhYYG9GjCHK6Zg1C5jsS407xuY8LF91O99N4Cr
         U7m/jBJgpau2BNuf1dgniVOPJL1FBB/JAymHm4vsyW7HxewCOLjV1z1g1FiNJomq++DM
         J7mnNL1eYgKtQ/8X6rfKtuuBypTZ9fAT5n4i1SK95uSL1jl+b8iv40ThEQJK0NkpJ/nY
         UA8ZvQT2mvk26vB0AIWsax/BapQEGF1a2BbqlRwcd12ww+yjvLl7kc/m7N73l7fPd+CN
         BIotpFRPcly3rkYJx1V308VceMhUUTIlGx3SyEEYgCHcJ2rGfVVkJBscEe7MvP+1NQGX
         EmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=EZStfT8Y3+w7g5IMR3LS7oaTKGYlLTmJ96boV7VDtjw=;
        b=P1p1GxKGFpsE9bwKtqvfmQ+yBf+HaZHda//6Vl1TslyOGh9DTQ37JJuLiUtdUlnSFu
         aO+dD1uMXmjmr0TUpzJBUH1EIO9YkYyTI44QGVZ70zfm/JadFU2Y/XhskJ+40wAQReNc
         3yDt3u6SyTYEPwAMJn2XumZDWekJWkW8KlyrvLKtyyMEkd78nF1dpL6bsKDFQF4TisBX
         qP/G++UoFHtkTMRJoF074LVYj0tZeRBrWQA0FRKG/gB/74mpSqdgA6fbd9cuDXTKkhPt
         Kmjer8n6YpdZ13f4YM7htApFmDF+lROdwkm15MmlOh0rBY/KLDmvm+KgJeW7OwTDx0VV
         Oytg==
X-Gm-Message-State: APjAAAXKl6YdjS9Lbp3htbaZOBVA9SUHBZpc4p6olwhTCz9F2y63BxJg
        e8mt4mWB6n7+kD7GNtGyWSUTrZ73
X-Google-Smtp-Source: APXvYqxMvlvq0d5fByk45clktHLkQ9gFKV952vXLOvihDuUfcfTnRlhwQryB3+/56QDnjXAsoyAdIg==
X-Received: by 2002:a63:1807:: with SMTP id y7mr17587842pgl.94.1576898504876;
        Fri, 20 Dec 2019 19:21:44 -0800 (PST)
Received: from localhost.localdomain ([42.109.147.248])
        by smtp.gmail.com with ESMTPSA id 200sm14806170pfz.121.2019.12.20.19.21.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 19:21:44 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v5 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
Date:   Sat, 21 Dec 2019 08:50:46 +0530
Message-Id: <4cb29736c3fad6d660df246ef75623db0bd4a864.1576896417.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576896417.git.martin.varghese@nokia.com>
References: <cover.1576896417.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The existing PUSH MPLS action inserts MPLS header between ethernet header
and the IP header. Though this behaviour is fine for L3 VPN where an IP
packet is encapsulated inside a MPLS tunnel, it does not suffice the L2
VPN (l2 tunnelling) requirements. In L2 VPN the MPLS header should
encapsulate the ethernet packet.

The new mpls action ADD_MPLS inserts MPLS header at the start of the
packet or at the start of the l3 header depending on the value of l3 tunnel
flag in the ADD_MPLS arguments.

POP_MPLS action is extended to support ethertype 0x6558.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2:
   - PTAP_POP_MPLS action removed.
   - Special handling for ethertype 0 added in PUSH_MPLS.
   - Refactored push_mpls function to cater existing push_mpls and
     ptap_push_mpls actions.
   - mac len to specify the MPLS header location added in PTAP_PUSH_MPLS
     arguments.

Changes in v3:
   - Special handling for ethertype 0 removed.
   - Added support for ether type 0x6558.
   - Removed mac len from PTAP_PUSH_MPLS argument list
   - used l2_tun flag to distinguish l2 and l3 tunnelling.
   - Extended PTAP_PUSH_MPLS handling to cater PUSH_MPLS action also.

Changes in v4:
   - Removed extra blank lines.
   - Replaced bool l2_tun with u16 tun flags in
     struct ovs_action_ptap_push_mpls.

Changes in v5:
   - Renamed PTAP_PUSH_MPLS action to ADD_MPLS.
   - Replaced l2 tunnel flag with l3 tunnel flag.
   - In ADD_MPLS configuration, the code to check for l2 header is
     changed from (mac_proto != MAC_PROTO_NONE) to
     (mac_proto == MAC_PROTO_ETHERNET).

 include/uapi/linux/openvswitch.h | 31 +++++++++++++++++++++++++++++++
 net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
 net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44c..ae2bff1 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -673,6 +673,32 @@ struct ovs_action_push_mpls {
 };
 
 /**
+ * struct ovs_action_add_mpls - %OVS_ACTION_ATTR_ADD_MPLS action
+ * argument.
+ * @mpls_lse: MPLS label stack entry to push.
+ * @mpls_ethertype: Ethertype to set in the encapsulating ethernet frame.
+ * @tun_flags: MPLS tunnel attributes.
+ *
+ * The only values @mpls_ethertype should ever be given are %ETH_P_MPLS_UC and
+ * %ETH_P_MPLS_MC, indicating MPLS unicast or multicast. Other are rejected.
+ */
+struct ovs_action_add_mpls {
+	__be32 mpls_lse;
+	__be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
+	__u16 tun_flags;
+};
+
+#define OVS_MPLS_L3_TUNNEL_FLAG_MASK  (1 << 0) /* Flag to specify the place of
+						* insertion of MPLS header.
+						* When false, the MPLS header
+						* will be inserted at the start
+						* of the packet.
+						* When true, the MPLS header
+						* will be inserted at the start
+						* of the l3 header.
+						*/
+
+/**
  * struct ovs_action_push_vlan - %OVS_ACTION_ATTR_PUSH_VLAN action argument.
  * @vlan_tpid: Tag protocol identifier (TPID) to push.
  * @vlan_tci: Tag control identifier (TCI) to push.  The CFI bit must be set
@@ -892,6 +918,10 @@ struct check_pkt_len_arg {
  * @OVS_ACTION_ATTR_CHECK_PKT_LEN: Check the packet length and execute a set
  * of actions if greater than the specified packet length, else execute
  * another set of actions.
+ * @OVS_ACTION_ATTR_ADD_MPLS: Push a new MPLS label stack entry at the
+ * start of the packet or at the start of the l3 header depending on the value
+ * of l3 tunnel flag in the tun_flags field of OVS_ACTION_ATTR_ADD_MPLS
+ * argument.
  *
  * Only a single header can be set with a single %OVS_ACTION_ATTR_SET.  Not all
  * fields within a header are modifiable, e.g. the IPv4 protocol and fragment
@@ -927,6 +957,7 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
+	OVS_ACTION_ATTR_ADD_MPLS,     /* struct ovs_action_add_mpls. */
 
 	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
 				       * from userspace. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 4c83954..7fbfe2a 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -161,16 +161,17 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			      const struct nlattr *attr, int len);
 
 static int push_mpls(struct sk_buff *skb, struct sw_flow_key *key,
-		     const struct ovs_action_push_mpls *mpls)
+		     __be32 mpls_lse, __be16 mpls_ethertype, __u16 mac_len)
 {
 	int err;
 
-	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype,
-			    skb->mac_len,
-			    ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET);
+	err = skb_mpls_push(skb, mpls_lse, mpls_ethertype, mac_len, !!mac_len);
 	if (err)
 		return err;
 
+	if (!mac_len)
+		key->mac_proto = MAC_PROTO_NONE;
+
 	invalidate_flow_key(key);
 	return 0;
 }
@@ -185,6 +186,9 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 	if (err)
 		return err;
 
+	if (ethertype == htons(ETH_P_TEB))
+		key->mac_proto = MAC_PROTO_ETHERNET;
+
 	invalidate_flow_key(key);
 	return 0;
 }
@@ -1229,10 +1233,24 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			execute_hash(skb, key, a);
 			break;
 
-		case OVS_ACTION_ATTR_PUSH_MPLS:
-			err = push_mpls(skb, key, nla_data(a));
+		case OVS_ACTION_ATTR_PUSH_MPLS: {
+			struct ovs_action_push_mpls *mpls = nla_data(a);
+
+			err = push_mpls(skb, key, mpls->mpls_lse,
+					mpls->mpls_ethertype, skb->mac_len);
 			break;
+		}
+		case OVS_ACTION_ATTR_ADD_MPLS: {
+			struct ovs_action_add_mpls *mpls = nla_data(a);
+			__u16 mac_len = 0;
+
+			if (mpls->tun_flags & OVS_MPLS_L3_TUNNEL_FLAG_MASK)
+				mac_len = skb->mac_len;
 
+			err = push_mpls(skb, key, mpls->mpls_lse,
+					mpls->mpls_ethertype, mac_len);
+			break;
+		}
 		case OVS_ACTION_ATTR_POP_MPLS:
 			err = pop_mpls(skb, key, nla_get_be16(a));
 			break;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 65c2e34..7da4230 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -79,6 +79,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
 		case OVS_ACTION_ATTR_SET_MASKED:
 		case OVS_ACTION_ATTR_METER:
 		case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+		case OVS_ACTION_ATTR_ADD_MPLS:
 		default:
 			return true;
 		}
@@ -3005,6 +3006,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			[OVS_ACTION_ATTR_METER] = sizeof(u32),
 			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
 			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
+			[OVS_ACTION_ATTR_ADD_MPLS] = sizeof(struct ovs_action_add_mpls),
 		};
 		const struct ovs_action_push_vlan *vlan;
 		int type = nla_type(a);
@@ -3072,6 +3074,33 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 		case OVS_ACTION_ATTR_RECIRC:
 			break;
 
+		case OVS_ACTION_ATTR_ADD_MPLS: {
+			const struct ovs_action_add_mpls *mpls = nla_data(a);
+
+			if (!eth_p_mpls(mpls->mpls_ethertype))
+				return -EINVAL;
+
+			if (mpls->tun_flags & OVS_MPLS_L3_TUNNEL_FLAG_MASK) {
+				if (vlan_tci & htons(VLAN_CFI_MASK) ||
+				    (eth_type != htons(ETH_P_IP) &&
+				     eth_type != htons(ETH_P_IPV6) &&
+				     eth_type != htons(ETH_P_ARP) &&
+				     eth_type != htons(ETH_P_RARP) &&
+				     !eth_p_mpls(eth_type)))
+					return -EINVAL;
+				mpls_label_count++;
+			} else {
+				if (mac_proto == MAC_PROTO_ETHERNET) {
+					mpls_label_count = 1;
+					mac_proto = MAC_PROTO_NONE;
+				} else {
+					mpls_label_count++;
+				}
+			}
+			eth_type = mpls->mpls_ethertype;
+			break;
+		}
+
 		case OVS_ACTION_ATTR_PUSH_MPLS: {
 			const struct ovs_action_push_mpls *mpls = nla_data(a);
 
@@ -3109,6 +3138,11 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			 * recirculation.
 			 */
 			proto = nla_get_be16(a);
+
+			if (proto == htons(ETH_P_TEB) &&
+			    mac_proto != MAC_PROTO_NONE)
+				return -EINVAL;
+
 			mpls_label_count--;
 
 			if (!eth_p_mpls(proto) || !mpls_label_count)
-- 
1.8.3.1

