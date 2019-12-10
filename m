Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB10118202
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLJIRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:17:22 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36774 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJIRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:17:22 -0500
Received: by mail-pj1-f65.google.com with SMTP id n96so7098938pjc.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 00:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=K55KNTjkjJ7irysGvgrdyzlzyOdVV3T0pQX3zX4XK2M=;
        b=mNqQH6OnywRp78ouHccxOof4fZi53jsfPyj1SEygaSxI7UzrPX4+5UOboIBEGmJZAJ
         qX5c92azQAVTEu4m+vCTC3+6xVKxAtX+6NDLnlna2mp1f+4vQeciYQpP8YEI+aezs2iI
         3G2TgMgZH4xSETiiRbzzaDvZqiiOkSy7XWDOapnk0s0X+oduTDpaeQJYywlKBDHOnsZc
         25fhhakjub2WnxLdkB+tBXmqOUB2YoUcUqwAbB9ASLG5vq/tz4lIZKvJCD+KIgPCPHvX
         pvYZTA1s7X+h54H7p5mvLNRahd0W3Ch93nwx5EIPFqNB68Hdn1FYR+46zgvrLqoAfLPO
         RPhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=K55KNTjkjJ7irysGvgrdyzlzyOdVV3T0pQX3zX4XK2M=;
        b=EKX5UE8yEyTqy4P5WWMcbW8ahJgV5HZ9qpmndSl7p518eBRGM0FmMj+t+LONuesPiz
         66bC0qcghlWhG6X7jjgv53vkuslHlmerl2nfpcR+ajui4ZygmWhNeR+Z1Mum8db/1FuM
         5OEGRXRWwA+9MFDvKIkk8tYrQCM3Em+g5JRNuNOEf9ucex/12+0QZChUroVvU6ksVz0L
         znXm62FvelwAplKvMd8l1LSdAsH34Bq6O3GhmAfR3A/6Vw3jNL72JYOzOetHmtq1oLCR
         FpxH46STnMx1Ofd9Dyq17aTFIot302CgOp3PkAn/k12invPQP/ciRR9VqPgWn+qex35o
         ca6w==
X-Gm-Message-State: APjAAAUVfQDGG4fXvETuOGF24j/32RU7UrCAkVWseEbTS2lPjh/NKjjl
        GktVI+2ClNvJl3rNoyVnUY/GZHNJ
X-Google-Smtp-Source: APXvYqxyOE1rqHDWBuKkE4nsHYLc83EQNvvGCBakWJ/A8qdAA2hqq2NQLUbRT5iSIeEjfKo9x1Nvpg==
X-Received: by 2002:a17:90a:e28e:: with SMTP id d14mr4246664pjz.56.1575965841616;
        Tue, 10 Dec 2019 00:17:21 -0800 (PST)
Received: from martin-VirtualBox.in.alcatel-lucent.com ([1.39.147.184])
        by smtp.gmail.com with ESMTPSA id q7sm2183888pfb.44.2019.12.10.00.17.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Dec 2019 00:17:21 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
Date:   Tue, 10 Dec 2019 13:46:41 +0530
Message-Id: <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575964218.git.martin.varghese@nokia.com>
References: <cover.1575964218.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
between ethernet header and the IP header. Though this behaviour is fine
for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
the MPLS header should encapsulate the ethernet packet.

The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
MPLS header from start of the packet respectively.

PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
@ethertype - Ethertype of MPLS header.

PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
@ethertype - Ethertype of next header following the popped MPLS header.
             Value 0 in ethertype indicates the tunnelled packet is
             ethernet.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 include/uapi/linux/openvswitch.h |  2 ++
 net/openvswitch/actions.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 net/openvswitch/flow_netlink.c   | 21 +++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44c..af05062 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -927,6 +927,8 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
+	OVS_ACTION_ATTR_PTAP_PUSH_MPLS,    /* struct ovs_action_push_mpls. */
+	OVS_ACTION_ATTR_PTAP_POP_MPLS,     /* __be16 ethertype. */
 
 	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
 				       * from userspace. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 4c83954..d43c37e 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -160,6 +160,38 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			      struct sw_flow_key *key,
 			      const struct nlattr *attr, int len);
 
+static int push_ptap_mpls(struct sk_buff *skb, struct sw_flow_key *key,
+			  const struct ovs_action_push_mpls *mpls)
+{
+	int err;
+
+	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype,
+			    0, false);
+	if (err)
+		return err;
+
+	key->mac_proto = MAC_PROTO_NONE;
+	invalidate_flow_key(key);
+	return 0;
+}
+
+static int ptap_pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
+			 const __be16 ethertype)
+{
+	int err;
+
+	err = skb_mpls_pop(skb, ethertype, skb->mac_len,
+			   ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET);
+	if (err)
+		return err;
+
+	if (!ethertype)
+		key->mac_proto = MAC_PROTO_ETHERNET;
+
+	invalidate_flow_key(key);
+	return 0;
+}
+
 static int push_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 		     const struct ovs_action_push_mpls *mpls)
 {
@@ -1233,10 +1265,18 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			err = push_mpls(skb, key, nla_data(a));
 			break;
 
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+			err = push_ptap_mpls(skb, key, nla_data(a));
+			break;
+
 		case OVS_ACTION_ATTR_POP_MPLS:
 			err = pop_mpls(skb, key, nla_get_be16(a));
 			break;
 
+		case OVS_ACTION_ATTR_PTAP_POP_MPLS:
+			err = ptap_pop_mpls(skb, key, nla_get_be16(a));
+			break;
+
 		case OVS_ACTION_ATTR_PUSH_VLAN:
 			err = push_vlan(skb, key, nla_data(a));
 			break;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 65c2e34..4a68aae 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -79,6 +79,8 @@ static bool actions_may_change_flow(const struct nlattr *actions)
 		case OVS_ACTION_ATTR_SET_MASKED:
 		case OVS_ACTION_ATTR_METER:
 		case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+		case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
+		case OVS_ACTION_ATTR_PTAP_POP_MPLS:
 		default:
 			return true;
 		}
@@ -3005,6 +3007,8 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			[OVS_ACTION_ATTR_METER] = sizeof(u32),
 			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
 			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
+			[OVS_ACTION_ATTR_PTAP_PUSH_MPLS] = sizeof(struct ovs_action_push_mpls),
+			[OVS_ACTION_ATTR_PTAP_POP_MPLS] = sizeof(__be16),
 		};
 		const struct ovs_action_push_vlan *vlan;
 		int type = nla_type(a);
@@ -3072,6 +3076,19 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
 
@@ -3092,6 +3109,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			break;
 		}
 
+		case OVS_ACTION_ATTR_PTAP_POP_MPLS:
+			if (mac_proto != MAC_PROTO_NONE)
+				return -EINVAL;
+
 		case OVS_ACTION_ATTR_POP_MPLS: {
 			__be16  proto;
 			if (vlan_tci & htons(VLAN_CFI_MASK) ||
-- 
1.8.3.1

