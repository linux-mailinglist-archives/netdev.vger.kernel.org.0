Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BD81207EE
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfLPOEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:04:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32982 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfLPOEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:04:01 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so3772972pgk.0
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 06:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Ym7SciDlvx8fLR2cijF98p7DQ5JcVODiKgLxRuHXrdg=;
        b=LScD+18gemiZ3G3aq9DIeVDEGxTGWHDrbkII5kEi96PZ79uxFAv7AZ69jFP1N8cbpG
         /Nn5FS/RzUomVPwYK0ALphcgQeid7i+1LtlvMklpJwamVvfM1pQOpJeekQnqvxDXPqD/
         blY5pgK2pUtjZRQMcUvPjWra/0+h0umKa0jvWP/sRdlq/cA/o+52jPL7U+JfU6juuyGW
         hiyH+C8m8Eb3dJ/GmxCcpo1Jn3RXxVwOjabhdUEU8XOehyMYOsYAUm/zPbot+Z9zHxZ+
         wVhjnMu3ph4ltZ+K73bIyx+Shr/DHKy8q8MJguoya4S2ivzIEBvTNe9MSKLgQ7HkWFNX
         wxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Ym7SciDlvx8fLR2cijF98p7DQ5JcVODiKgLxRuHXrdg=;
        b=gJJOwYBSmuAfccMV3jnGgqND1UUHwM0KP/TqpY9jUplymoobk6Zr2A+0aLr11uHbAB
         LSU4vNZqaS55IhFLxKBo3/ioBrYK3NoqraYfQqBCw0htlEwvgLXz9tOK3PZ/VADH5R4m
         m3nrY8JDU1FbBZgD3ccOap7YAZRKKgKFj/+v75Ob6ipWKbF9loooPLInrlwUaYjYmQkw
         geNV+SYD/GI0/s7TjlZBbj96CVMRjp4Iew0hrv5GlcosEj4TVNkvg653U71nRUyrjO2C
         vgOfWcGghDPQxV9YrP38T97tPDNWvemHWyf5Uk3tlXtJaQ894ubxajspnNJkDedq8Txm
         Sn9w==
X-Gm-Message-State: APjAAAV5qGxzkenLuEFZ1o53aWMGipd40G768p1vqqiX9QHG52WHkJXD
        qSoD2YaAzRAI7aRokOmVJBBpsiSX
X-Google-Smtp-Source: APXvYqwpNkciHo8GUOFnGIVpa2o+uVD9OUlSkOX+Mv3tNJpbxc3Jq3gVtsoc1JTLtGbfSq5+oN0TBg==
X-Received: by 2002:a63:6b07:: with SMTP id g7mr18031829pgc.243.1576505040465;
        Mon, 16 Dec 2019 06:04:00 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id r28sm16590340pgk.39.2019.12.16.06.03.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Dec 2019 06:04:00 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v3 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
Date:   Mon, 16 Dec 2019 19:33:43 +0530
Message-Id: <9e3b73cd6967927fc6654cbdcd7b9e7431441c3f.1576488935.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576488935.git.martin.varghese@nokia.com>
References: <cover.1576488935.git.martin.varghese@nokia.com>
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
   

 include/uapi/linux/openvswitch.h | 23 ++++++++++++++++++++++-
 net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
 net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44c..b7221ad 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -673,6 +673,25 @@ struct ovs_action_push_mpls {
 };
 
 /**
+ * struct ovs_action_ptap_push_mpls - %OVS_ACTION_ATTR_PTAP_PUSH_MPLS action
+ * argument.
+ * @mpls_lse: MPLS label stack entry to push.
+ * @mpls_ethertype: Ethertype to set in the encapsulating ethernet frame.
+ * @l2_tun: Flag to specify the place of insertion of MPLS header.
+ * When true, the MPLS header will be inserted at the start of the packet.
+ * When false, the MPLS header will be inserted at the start of the l3 header.
+ *
+ * The only values @mpls_ethertype should ever be given are %ETH_P_MPLS_UC and
+ * %ETH_P_MPLS_MC, indicating MPLS unicast or multicast. Other are rejected.
+ */
+struct ovs_action_ptap_push_mpls {
+	__be32 mpls_lse;
+	__be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
+	bool l2_tun;
+};
+
+
+/**
  * struct ovs_action_push_vlan - %OVS_ACTION_ATTR_PUSH_VLAN action argument.
  * @vlan_tpid: Tag protocol identifier (TPID) to push.
  * @vlan_tci: Tag control identifier (TCI) to push.  The CFI bit must be set
@@ -892,7 +911,8 @@ struct check_pkt_len_arg {
  * @OVS_ACTION_ATTR_CHECK_PKT_LEN: Check the packet length and execute a set
  * of actions if greater than the specified packet length, else execute
  * another set of actions.
- *
+ * @OVS_ACTION_ATTR_PUSH_MPLS: Push a new MPLS label stack entry at specified
+ * offset from start of packet.
  * Only a single header can be set with a single %OVS_ACTION_ATTR_SET.  Not all
  * fields within a header are modifiable, e.g. the IPv4 protocol and fragment
  * type may not be changed.
@@ -927,6 +947,7 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
+	OVS_ACTION_ATTR_PTAP_PUSH_MPLS, /* struct ovs_action_ptap_push_mpls. */
 
 	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
 				       * from userspace. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 4c83954..5138473 100644
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
+			if (!mpls->l2_tun)
+				mac_len = skb->mac_len;
 
+			err = push_mpls(skb, key, mpls->mpls_lse,
+					mpls->mpls_ethertype, mac_len);
+			break;
+		}
 		case OVS_ACTION_ATTR_POP_MPLS:
 			err = pop_mpls(skb, key, nla_get_be16(a));
 			break;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 65c2e34..8d650e3 100644
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
+			if (!mpls->l2_tun) {
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

