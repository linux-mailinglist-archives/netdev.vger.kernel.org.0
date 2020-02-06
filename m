Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0852154CF8
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 21:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgBFUaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 15:30:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52361 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727773AbgBFUaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 15:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581021003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z291E/1x5v8DcWM3zeu7Nb9fWuhFi4AhP/ykjDvYWqg=;
        b=Mn6VjaWFLG2Eecp20AY+xZWFV9jHUvNEDxT0+JN+dEELl5ONfAlwxfH75uK/i8wTJz7AgH
        urYH+Rsn1VMgRP4aSN31PeghQHU62LiOhlqzW2JZWo+6vNV/F33o0/Hx112tDrHiA2ve0q
        wQpFpHghju7N3seGdREZcXTYW+nAsko=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-FyO0wfTPPYmoYpAH3Dxrgw-1; Thu, 06 Feb 2020 15:30:01 -0500
X-MC-Unique: FyO0wfTPPYmoYpAH3Dxrgw-1
Received: by mail-wr1-f69.google.com with SMTP id v17so4021067wrm.17
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 12:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z291E/1x5v8DcWM3zeu7Nb9fWuhFi4AhP/ykjDvYWqg=;
        b=TSldk/mL+krLc3Dj72yeacn3cUXfTgZjkAIJmdDz1vtOX6HYMbh6INkkpjOkrEuA6P
         Ca7ElDovUz2Epge27svp3+wUsu87EebID7Wbd9CgLMe7ZR736oWiIXlElSlaKbCK8LVW
         SzB+GALcsQpu2eIyzYaSKkbL58kcj6bkcyplC/WOVhyjMvmwBG6hjFB9iIoQrhm2NASz
         34EYkSWvbOWI7c4loWmlS6td5PeKsgGqJL1Xj+oCeLx11azU5im5y5XSFJlIpXEwCXHF
         do6PLlR28g/hbiptt5+sQYI1NXKZLj52ZBDJBF0vACwdQh1P1zhEv1gfp9ccAMWRHU0f
         Gq6Q==
X-Gm-Message-State: APjAAAVTHnkr6ks7wQytgq/niNwv6pS4BNS60g7tc8xnXD1udeLMvIje
        r8j87zmP2uxelICUiX5k5HNhYSDtvaOd7Qv+Avn0yLIe4UlY4DEVDYHmtgj1oaCpk7j9l54lu4L
        sXauectCHiARXmTQt
X-Received: by 2002:a05:600c:2406:: with SMTP id 6mr6534398wmp.30.1581020999840;
        Thu, 06 Feb 2020 12:29:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4e5cIr0sR/wxOKpSWaQ83kcamWWV77wb6Q4pBSz8Ci5PEvdJvohjWQ6TzRukuysS4cox5bg==
X-Received: by 2002:a05:600c:2406:: with SMTP id 6mr6534383wmp.30.1581020999553;
        Thu, 06 Feb 2020 12:29:59 -0800 (PST)
Received: from raver.teknoraver.net (net-2-36-173-8.cust.vodafonedsl.it. [2.36.173.8])
        by smtp.gmail.com with ESMTPSA id y1sm515841wrq.16.2020.02.06.12.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 12:29:59 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jeremy Harris <jgh@redhat.com>
Subject: [PATCH net-next v4] openvswitch: add TTL decrement action
Date:   Thu,  6 Feb 2020 21:29:49 +0100
Message-Id: <20200206202949.6060-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New action to decrement TTL instead of setting it to a fixed value.
This action will decrement the TTL and, in case of expired TTL, drop it
or execute an action passed via a nested attribute.
The default TTL expired action is to drop the packet.

Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.

Tested with a corresponding change in the userspace:

    # ovs-dpctl dump-flows
    in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1
    in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},2
    in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
    in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1

    # ping -c1 192.168.0.2 -t 42
    IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
        192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
    # ping -c1 192.168.0.2 -t 120
    IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
        192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
    # ping -c1 192.168.0.2 -t 1
    #

Co-developed-by: Bindiya Kurle <bindiyakurle@gmail.com>
Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/uapi/linux/openvswitch.h |  7 ++++
 net/openvswitch/actions.c        | 67 ++++++++++++++++++++++++++++++
 net/openvswitch/flow_netlink.c   | 70 ++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index ae2bff14e7e1..9b14519e74d9 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -958,6 +958,7 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
 	OVS_ACTION_ATTR_ADD_MPLS,     /* struct ovs_action_add_mpls. */
+	OVS_ACTION_ATTR_DEC_TTL,      /* Nested OVS_DEC_TTL_ATTR_*. */
 
 	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
 				       * from userspace. */
@@ -1050,4 +1051,10 @@ struct ovs_zone_limit {
 	__u32 count;
 };
 
+enum ovs_dec_ttl_attr {
+	OVS_DEC_TTL_ATTR_UNSPEC,
+	OVS_DEC_TTL_ATTR_ACTION,	/* Nested struct nlattr */
+	__OVS_DEC_TTL_ATTR_MAX
+};
+
 #endif /* _LINUX_OPENVSWITCH_H */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 7fbfe2adfffa..fc0efd8833c8 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -964,6 +964,25 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 	return ovs_dp_upcall(dp, skb, key, &upcall, cutlen);
 }
 
+static int dec_ttl_exception_handler(struct datapath *dp, struct sk_buff *skb,
+				     struct sw_flow_key *key,
+				     const struct nlattr *attr, bool last)
+{
+	/* The first action is always 'OVS_DEC_TTL_ATTR_ARG'. */
+	struct nlattr *dec_ttl_arg = nla_data(attr);
+	int rem = nla_len(attr);
+
+	if (nla_len(dec_ttl_arg)) {
+		struct nlattr *actions = nla_next(dec_ttl_arg, &rem);
+
+		if (actions)
+			return clone_execute(dp, skb, key, 0, actions, rem,
+					     last, false);
+	}
+	consume_skb(skb);
+	return 0;
+}
+
 /* When 'last' is true, sample() should always consume the 'skb'.
  * Otherwise, sample() should keep 'skb' intact regardless what
  * actions are executed within sample().
@@ -1180,6 +1199,45 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
 			     nla_len(actions), last, clone_flow_key);
 }
 
+static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
+{
+	int err;
+
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		struct ipv6hdr *nh;
+
+		err = skb_ensure_writable(skb, skb_network_offset(skb) +
+					  sizeof(*nh));
+		if (unlikely(err))
+			return err;
+
+		nh = ipv6_hdr(skb);
+
+		if (nh->hop_limit <= 1)
+			return -EHOSTUNREACH;
+
+		key->ip.ttl = --nh->hop_limit;
+	} else {
+		struct iphdr *nh;
+		u8 old_ttl;
+
+		err = skb_ensure_writable(skb, skb_network_offset(skb) +
+					  sizeof(*nh));
+		if (unlikely(err))
+			return err;
+
+		nh = ip_hdr(skb);
+		if (nh->ttl <= 1)
+			return -EHOSTUNREACH;
+
+		old_ttl = nh->ttl--;
+		csum_replace2(&nh->check, htons(old_ttl << 8),
+			      htons(nh->ttl << 8));
+		key->ip.ttl = nh->ttl;
+	}
+	return 0;
+}
+
 /* Execute a list of actions against 'skb'. */
 static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			      struct sw_flow_key *key,
@@ -1365,6 +1423,15 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 
 			break;
 		}
+
+		case OVS_ACTION_ATTR_DEC_TTL:
+			err = execute_dec_ttl(skb, key);
+			if (err == -EHOSTUNREACH) {
+				err = dec_ttl_exception_handler(dp, skb, key,
+								a, true);
+				return err;
+			}
+			break;
 		}
 
 		if (unlikely(err)) {
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 7da4230627f5..2bb05700ee5c 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -80,6 +80,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
 		case OVS_ACTION_ATTR_METER:
 		case OVS_ACTION_ATTR_CHECK_PKT_LEN:
 		case OVS_ACTION_ATTR_ADD_MPLS:
+		case OVS_ACTION_ATTR_DEC_TTL:
 		default:
 			return true;
 		}
@@ -2495,6 +2496,39 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 	return 0;
 }
 
+static int validate_and_copy_dec_ttl(struct net *net,
+				     const struct nlattr *attr,
+				     const struct sw_flow_key *key,
+				     struct sw_flow_actions **sfa,
+				     __be16 eth_type, __be16 vlan_tci,
+				     u32 mpls_label_count, bool log)
+{
+	int start, err;
+	u32 nested = true;
+
+	if (!nla_len(attr))
+		return ovs_nla_add_action(sfa, OVS_ACTION_ATTR_DEC_TTL,
+					  NULL, 0, log);
+
+	start = add_nested_action_start(sfa, OVS_ACTION_ATTR_DEC_TTL, log);
+	if (start < 0)
+		return start;
+
+	err = ovs_nla_add_action(sfa, OVS_DEC_TTL_ATTR_ACTION, &nested,
+				 sizeof(nested), log);
+
+	if (err)
+		return err;
+
+	err = __ovs_nla_copy_actions(net, attr, key, sfa, eth_type,
+					vlan_tci, mpls_label_count, log);
+	if (err)
+		return err;
+
+	add_nested_action_end(*sfa, start);
+	return 0;
+}
+
 static int validate_and_copy_clone(struct net *net,
 				   const struct nlattr *attr,
 				   const struct sw_flow_key *key,
@@ -3007,6 +3041,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
 			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
 			[OVS_ACTION_ATTR_ADD_MPLS] = sizeof(struct ovs_action_add_mpls),
+			[OVS_ACTION_ATTR_DEC_TTL] = (u32)-1,
 		};
 		const struct ovs_action_push_vlan *vlan;
 		int type = nla_type(a);
@@ -3267,6 +3302,15 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			break;
 		}
 
+		case OVS_ACTION_ATTR_DEC_TTL:
+			err = validate_and_copy_dec_ttl(net, a, key, sfa,
+							eth_type, vlan_tci,
+							mpls_label_count, log);
+			if (err)
+				return err;
+			skip_copy = true;
+			break;
+
 		default:
 			OVS_NLERR(log, "Unknown Action type %d", type);
 			return -EINVAL;
@@ -3438,6 +3482,26 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
 	return err;
 }
 
+static int dec_ttl_action_to_attr(const struct nlattr *attr,
+				  struct sk_buff *skb)
+{
+	int err = 0, rem = nla_len(attr);
+	struct nlattr *start;
+
+	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_DEC_TTL);
+
+	if (!start)
+		return -EMSGSIZE;
+
+	err = ovs_nla_put_actions(nla_data(attr), rem, skb);
+	if (err)
+		nla_nest_cancel(skb, start);
+	else
+		nla_nest_end(skb, start);
+
+	return err;
+}
+
 static int set_action_to_attr(const struct nlattr *a, struct sk_buff *skb)
 {
 	const struct nlattr *ovs_key = nla_data(a);
@@ -3538,6 +3602,12 @@ int ovs_nla_put_actions(const struct nlattr *attr, int len, struct sk_buff *skb)
 				return err;
 			break;
 
+		case OVS_ACTION_ATTR_DEC_TTL:
+			err = dec_ttl_action_to_attr(a, skb);
+			if (err)
+				return err;
+			break;
+
 		default:
 			if (nla_put(skb, type, nla_len(a), nla_data(a)))
 				return -EMSGSIZE;
-- 
2.24.1

