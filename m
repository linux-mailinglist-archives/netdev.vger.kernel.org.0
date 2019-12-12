Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7132311CFF2
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 15:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfLLOfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 09:35:23 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34025 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729603AbfLLOfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 09:35:23 -0500
Received: by mail-pl1-f193.google.com with SMTP id x17so682156pln.1
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 06:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=o5Rn1ETBXxi4OF0erG0H313y1J32intQWjv/Yi621dI=;
        b=KO2nsRaRL1Ij+8LEMLL64qjezrZKHt6YQPQQ3cDdkE6hS60vNLhXQR83frXldLG5qa
         smSGOImCUa83M84UWA1fMj2eiFsPCEgAJc7egGuS7Pu3WJ8x8ut258qsueKVQuVQBV08
         2iUTIIhDXU77jpt3T6f23ZbJGsMLKndniRA22/3vEcU2/np7NfgmZZ2oXbH3F9QNAK23
         vBOdaUjFZJKcBcdzf7trgUgub586/Yd2gQlJJIZO3lWGHjz0HNrpzcGMVMJev0dSclw4
         VyfYptwIMio+PePqZkB6NtKGAr1j4M9TWev/TCX93EwjyhJRwMmy50yZ5YwU+ePfSDlH
         rpCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=o5Rn1ETBXxi4OF0erG0H313y1J32intQWjv/Yi621dI=;
        b=OcAqJiWDfmahKrxr6l39HG4BXYBICzyzX0szJiykbnQ4pXAoxGXbwcmn9rQK+OhtbN
         4pQvoYPMQdKZSKEIxpxRaSHaehA/auZUJASwCXPIf9GLNAbkfn4qS1jKLJMCZQYn4IZJ
         kWMD3ovDygscLNIf3Im2rFpUeVHNLO3QkVoB/kDJ4zr1R8FTXjTPMaZJaQPXdQF3R0rM
         FhUQe9oi0MHukVjqoiof9QAQ4dZ/pAAqljnjyRsttKYOD6oaR37k0woGdrwjq+34FyED
         mlsDz8lHP7PAk0CCM5qeTRdDLINs/2UUcTzPsRxBvMQkonj66wJfcuLlYSw6Dy+CYZUx
         hI/g==
X-Gm-Message-State: APjAAAUNvfkEpd3jqU4pza+NKLIhq57QEh+ddPYX4TkYArryhdNPmrg8
        lE4HQNuZ/MKXFm69huBSR7lecDOc
X-Google-Smtp-Source: APXvYqwF+2u0RrgM2HYpcj7Y5hqjQdj7V9x1O1TT/2jqYUm6fbCJdUhD1NrmtD3WOsvzHacnnSwAWQ==
X-Received: by 2002:a17:902:bb98:: with SMTP id m24mr9826188pls.260.1576161322256;
        Thu, 12 Dec 2019 06:35:22 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id f34sm7347402pgl.54.2019.12.12.06.35.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 06:35:21 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v2 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
Date:   Thu, 12 Dec 2019 20:05:16 +0530
Message-Id: <20aaa5257be38bb50e04b1e596ad05b7deea5ddc.1576157907.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576157907.git.martin.varghese@nokia.com>
References: <cover.1576157907.git.martin.varghese@nokia.com>
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

The new mpls action PTAP_PUSH_MPLS inserts MPLS header at specified offset
from the start of packet.

A special handling is added for ethertype 0 in the existing POP MPLS action.
Value 0 in ethertype indicates the tunnelled packet is ethernet.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 include/uapi/linux/openvswitch.h | 21 ++++++++++++++++++++-
 net/openvswitch/actions.c        | 26 ++++++++++++++++++++------
 net/openvswitch/flow_netlink.c   | 15 +++++++++++++++
 3 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44c..aaf7d3a 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -673,6 +673,23 @@ struct ovs_action_push_mpls {
 };
 
 /**
+ * struct ovs_action_ptap_push_mpls - %OVS_ACTION_ATTR_PTAP_PUSH_MPLS action
+ * argument.
+ * @mpls_lse: MPLS label stack entry to push.
+ * @mpls_ethertype: Ethertype to set in the encapsulating ethernet frame.
+ * @mac_len: Offset from start of packet at which MPLS header is pushed.
+ *
+ * The only values @mpls_ethertype should ever be given are %ETH_P_MPLS_UC and
+ * %ETH_P_MPLS_MC, indicating MPLS unicast or multicast. Other are rejected.
+ */
+struct ovs_action_ptap_push_mpls {
+	__be32 mpls_lse;
+	__be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
+	__u16 mac_len;
+};
+
+
+/**
  * struct ovs_action_push_vlan - %OVS_ACTION_ATTR_PUSH_VLAN action argument.
  * @vlan_tpid: Tag protocol identifier (TPID) to push.
  * @vlan_tci: Tag control identifier (TCI) to push.  The CFI bit must be set
@@ -892,7 +909,8 @@ struct check_pkt_len_arg {
  * @OVS_ACTION_ATTR_CHECK_PKT_LEN: Check the packet length and execute a set
  * of actions if greater than the specified packet length, else execute
  * another set of actions.
- *
+ * @OVS_ACTION_ATTR_PUSH_MPLS: Push a new MPLS label stack entry at specified
+ * offset from start of packet.
  * Only a single header can be set with a single %OVS_ACTION_ATTR_SET.  Not all
  * fields within a header are modifiable, e.g. the IPv4 protocol and fragment
  * type may not be changed.
@@ -927,6 +945,7 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
+	OVS_ACTION_ATTR_PTAP_PUSH_MPLS,    /* struct ovs_action_push_mpls. */
 
 	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
 				       * from userspace. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 4c83954..00e4517 100644
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
 
+	if (!skb->mac_len && !ethertype)
+		key->mac_proto = MAC_PROTO_ETHERNET;
+
 	invalidate_flow_key(key);
 	return 0;
 }
@@ -1229,10 +1233,20 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
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
 
+			err = push_mpls(skb, key, mpls->mpls_lse,
+					mpls->mpls_ethertype, mpls->mac_len);
+			break;
+		}
 		case OVS_ACTION_ATTR_POP_MPLS:
 			err = pop_mpls(skb, key, nla_get_be16(a));
 			break;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 65c2e34..b7c80fd 100644
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
@@ -3072,6 +3074,19 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 		case OVS_ACTION_ATTR_RECIRC:
 			break;
 
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
+			const struct ovs_action_push_mpls *mpls = nla_data(a);
+
+			eth_type = mpls->mpls_ethertype;
+			if (mac_proto != MAC_PROTO_NONE) {
+				mpls_label_count = 1;
+				mac_proto = MAC_PROTO_NONE;
+			} else {
+				mpls_label_count++;
+			}
+			break;
+		}
+
 		case OVS_ACTION_ATTR_PUSH_MPLS: {
 			const struct ovs_action_push_mpls *mpls = nla_data(a);
 
-- 
1.8.3.1

