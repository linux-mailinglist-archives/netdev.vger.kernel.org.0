Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E16123FD8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLRG4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:56:17 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40279 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfLRG4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:56:16 -0500
Received: by mail-pg1-f195.google.com with SMTP id k25so735822pgt.7
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=+E2tHh3PlsozlJKxVBujqed7OziRZZeh0g8FuYWyqIo=;
        b=H7rDdKM3HLNvyZoqDzHWbsNKeckod2jL/l9sHg5fngeSc1v1YGiy50gg2qmr07ZEsd
         +lwiQl9i2GPdRA0qfUKB4XrqGuiCLQ7YVq7ZYVAJ/9pzuH5qVGZURF/Sp5wk2fGo2th8
         NA1WUdhdfM1NK6ATmaAVvI49bZR+LiNxZNuootr0icPANHE8Xtp6ZkLGCHCWIAQJEUbz
         mXv5fTgCmLEbNRRzy2vkMNQJeIJ6kHdVPMg8UDulm56R7heG+STuAgclc/4uGPsyrjc2
         5bm3tbYFeljabdVWAC9jz5Z6LPxxV+d0DoMRXCLUsGO0Td+F6aQGOPGD3DjYkhTRYgPF
         uU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=+E2tHh3PlsozlJKxVBujqed7OziRZZeh0g8FuYWyqIo=;
        b=nQCsJrwfrujzcez1US6cn+7neVYJirw2rP0quvs0BvNcP03HPy1olazlhY6c8e9iZY
         rZ2kONjE3WEzKskXut0HcT4jDqTCZVd03ZMwPxcttIslPw5bS011yj8Z+LhPZc+32z4h
         jLR6SJ4lPxLu9btRZWkT9G8Qy5tSmUYRUe/PZDkcYeetgWbIKbRnzEqEZDc5Yax7/ZXo
         yW9Wrs/5WRrnN3kh8abJDosHQ7k57QNowE8bqxzYiZK0WUMqbItfWGGaUi0duX5lJVNs
         ByXUuTfk7/tfY2PPYXfRBCQgiUOtg+tIkE2qDO8hjxmxNFtyQliZuhcvUgEFHiy9r4I9
         SVug==
X-Gm-Message-State: APjAAAUQ4fxjmigj8SI3pg0jfW6vSp/8Lf5Ujy5Ldtoa4kOqcg9gQWk9
        uPtc8AWavjCj3NTIf2+wZiveASOl
X-Google-Smtp-Source: APXvYqz2XKQx9TQJSFGIxIyCnjii+tQ/3nUPCcYLZisbCX8CYNtVDcQ6woSXeiBGJgr7omMW++aWVQ==
X-Received: by 2002:aa7:8f33:: with SMTP id y19mr1296121pfr.47.1576652175284;
        Tue, 17 Dec 2019 22:56:15 -0800 (PST)
Received: from localhost.localdomain ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id x21sm1464498pfn.164.2019.12.17.22.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 22:56:14 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v4 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
Date:   Wed, 18 Dec 2019 12:18:38 +0530
Message-Id: <f78a4e44caac82f0f1db5c89dfd30696c2cb192e.1576648350.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576648350.git.martin.varghese@nokia.com>
References: <cover.1576648350.git.martin.varghese@nokia.com>
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

The new mpls action PTAP_PUSH_MPLS inserts MPLS header at the start of the
packet or at the start of the l3 header depending on the value of l2 tunnel
flag in the PTAP_PUSH_MPLS arguments.

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

 include/uapi/linux/openvswitch.h | 31 +++++++++++++++++++++++++++++++
 net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
 net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44c..d9461ce 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -673,6 +673,32 @@ struct ovs_action_push_mpls {
 };
 
 /**
+ * struct ovs_action_ptap_push_mpls - %OVS_ACTION_ATTR_PTAP_PUSH_MPLS action
+ * argument.
+ * @mpls_lse: MPLS label stack entry to push.
+ * @mpls_ethertype: Ethertype to set in the encapsulating ethernet frame.
+ * @tun_flags: MPLS tunnel attributes.
+ *
+ * The only values @mpls_ethertype should ever be given are %ETH_P_MPLS_UC and
+ * %ETH_P_MPLS_MC, indicating MPLS unicast or multicast. Other are rejected.
+ */
+struct ovs_action_ptap_push_mpls {
+	__be32 mpls_lse;
+	__be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
+	__u16 tun_flags;
+};
+
+#define OVS_MPLS_L2_TUNNEL_FLAG_MASK  (1 << 0) /* Flag to specify the place of
+						* insertion of MPLS header.
+						* When true, the MPLS header
+						* will be inserted at the start
+						* of the packet.
+						* When false, the MPLS header
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
+ * @OVS_ACTION_ATTR_PTAP_PUSH_MPLS: Push a new MPLS label stack entry at the
+ * start of the packet or at the start of the l3 header depending on the value
+ * of l2 tunnel flag in the tun_flags field of OVS_ACTION_ATTR_PTAP_PUSH_MPLS
+ * argument.
  *
  * Only a single header can be set with a single %OVS_ACTION_ATTR_SET.  Not all
  * fields within a header are modifiable, e.g. the IPv4 protocol and fragment
@@ -927,6 +957,7 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
+	OVS_ACTION_ATTR_PTAP_PUSH_MPLS, /* struct ovs_action_ptap_push_mpls. */
 
 	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
 				       * from userspace. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 4c83954..24c12ad 100644
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
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
+			struct ovs_action_ptap_push_mpls *mpls = nla_data(a);
+			__u16 mac_len = 0;
+
+			if (!(mpls->tun_flags & OVS_MPLS_L2_TUNNEL_FLAG_MASK))
+				mac_len = skb->mac_len;
 
+			err = push_mpls(skb, key, mpls->mpls_lse,
+					mpls->mpls_ethertype, mac_len);
+			break;
+		}
 		case OVS_ACTION_ATTR_POP_MPLS:
 			err = pop_mpls(skb, key, nla_get_be16(a));
 			break;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 65c2e34..85fe7df 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -79,6 +79,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
 		case OVS_ACTION_ATTR_SET_MASKED:
 		case OVS_ACTION_ATTR_METER:
 		case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
 		default:
 			return true;
 		}
@@ -3005,6 +3006,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			[OVS_ACTION_ATTR_METER] = sizeof(u32),
 			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
 			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
+			[OVS_ACTION_ATTR_PTAP_PUSH_MPLS] = sizeof(struct ovs_action_ptap_push_mpls),
 		};
 		const struct ovs_action_push_vlan *vlan;
 		int type = nla_type(a);
@@ -3072,6 +3074,33 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 		case OVS_ACTION_ATTR_RECIRC:
 			break;
 
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
+			const struct ovs_action_ptap_push_mpls *mpls = nla_data(a);
+
+			if (!eth_p_mpls(mpls->mpls_ethertype))
+				return -EINVAL;
+
+			if (!(mpls->tun_flags & OVS_MPLS_L2_TUNNEL_FLAG_MASK)) {
+				if (vlan_tci & htons(VLAN_CFI_MASK) ||
+				    (eth_type != htons(ETH_P_IP) &&
+				     eth_type != htons(ETH_P_IPV6) &&
+				     eth_type != htons(ETH_P_ARP) &&
+				     eth_type != htons(ETH_P_RARP) &&
+				     !eth_p_mpls(eth_type)))
+					return -EINVAL;
+				mpls_label_count++;
+			} else {
+				if (mac_proto != MAC_PROTO_NONE) {
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

