Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F94A1230DC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfLQPvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:51:15 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726858AbfLQPvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576597869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XijYczyDqHXfAeDFm5Dy7aTeb275ezTi27ikqhA20RY=;
        b=aoVKQXHcdxX8A46Y4gJQD6WXFCs+Up1KqPynN/2kzPkTWAR6xxfJKWJXArrQeRW0ZXIojK
        04MA693ckmvDzMayDYFFC4fQDNcX+wYTeJOJdsxVVYeOlarZfvzYRjh3oOsdfmYeE9OFQ/
        L+hW+es5i6kndgebHF2C+xXiwtp2DGk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-qLQJj8VxNXmQ4rNYD0vJfg-1; Tue, 17 Dec 2019 10:51:08 -0500
X-MC-Unique: qLQJj8VxNXmQ4rNYD0vJfg-1
Received: by mail-wr1-f72.google.com with SMTP id f17so5525212wrt.19
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 07:51:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XijYczyDqHXfAeDFm5Dy7aTeb275ezTi27ikqhA20RY=;
        b=XhujMJcFgOq6xYeGkwlSOMPjeVo9ofkjba9PI64Mt1LxKN5wAtRGaaRbK4stEAhZnW
         hgIcHWcdOAkqLWEL7spb2wXM8cxg4U8wk5Epw013RVpnq5IesnfYgVG6kl9DwXwGnbDQ
         7LJoFDPSJV0FoSK8UgjH3p5jgN7itO0oXi14Uv5fJJdxGYFY7CA+K70ao1LyqNooZD0F
         2JhvgmLCDlGnlHITuKiwxBqB0ZeuyAkJUNTn3tT/6dz+BHR5dg4zPaxT89PGTZio/WQW
         1ShWhoP7BTjwOF5cMuRutj+plWdZawwV7BEqWkUrxu0AK5rzcJ0TWQ0oRb3ZzJrGzWJB
         bpYQ==
X-Gm-Message-State: APjAAAW4awCaH9nquhTnkvPuvRNG6X5y8FAjSJ41Oh20DSATjIPuXiYc
        aXP9NY78cHadqaYumzcJkSqlfaMualGwS9ba6k9HGqgUHr9HEM46ZpuYvUxyBGwMVrPvqC97PA0
        UGuvA0miDaupl51Wq
X-Received: by 2002:a5d:620b:: with SMTP id y11mr36908506wru.230.1576597865956;
        Tue, 17 Dec 2019 07:51:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqzaSTOZHc5LohAFsDJV69sJEhq9+/AbqfZTunBRqZNHuSGJh5NmHKxGepwVe9O1eHZuSyBwlA==
X-Received: by 2002:a5d:620b:: with SMTP id y11mr36908473wru.230.1576597865592;
        Tue, 17 Dec 2019 07:51:05 -0800 (PST)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y6sm25751147wrl.17.2019.12.17.07.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:51:04 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>
Subject: [PATCH net-next v2] openvswitch: add TTL decrement action
Date:   Tue, 17 Dec 2019 16:51:02 +0100
Message-Id: <20191217155102.46039-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
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
    in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,1
    in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,2
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

Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/uapi/linux/openvswitch.h |  22 +++++++
 net/openvswitch/actions.c        |  71 +++++++++++++++++++++
 net/openvswitch/flow_netlink.c   | 105 +++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44cd5590..b6684bc04883 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -927,6 +927,7 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
+	OVS_ACTION_ATTR_DEC_TTL,       /* Nested OVS_DEC_TTL_ATTR_*. */
 
 	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
 				       * from userspace. */
@@ -939,6 +940,23 @@ enum ovs_action_attr {
 };
 
 #define OVS_ACTION_ATTR_MAX (__OVS_ACTION_ATTR_MAX - 1)
+enum ovs_dec_ttl_attr {
+	OVS_DEC_TTL_ATTR_UNSPEC,
+	OVS_DEC_TTL_ATTR_ACTION_TYPE,    /* Action Type u32 */
+	OVS_DEC_TTL_ATTR_ACTION,         /* nested action */
+	__OVS_DEC_TTL_ATTR_MAX,
+#ifdef __KERNEL__
+	OVS_DEC_TTL_ATTR_ARG          /* struct sample_arg  */
+#endif
+};
+
+#ifdef __KERNEL__
+struct dec_ttl_arg {
+	u32 action_type;            /* dec_ttl action type.*/
+};
+#endif
+
+#define OVS_DEC_TTL_ATTR_MAX (__OVS_DEC_TTL_ATTR_MAX - 1)
 
 /* Meters. */
 #define OVS_METER_FAMILY  "ovs_meter"
@@ -1009,6 +1027,10 @@ enum ovs_ct_limit_attr {
 	__OVS_CT_LIMIT_ATTR_MAX
 };
 
+enum ovs_dec_ttl_action {            /*Actions supported by dec_ttl */
+	OVS_DEC_TTL_ACTION_DROP,
+	OVS_DEC_TTL_ACTION_USER_SPACE
+};
 #define OVS_CT_LIMIT_ATTR_MAX (__OVS_CT_LIMIT_ATTR_MAX - 1)
 
 #define OVS_ZONE_LIMIT_DEFAULT_ZONE -1
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 4c8395462303..5329668732b1 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -960,6 +960,31 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 	return ovs_dp_upcall(dp, skb, key, &upcall, cutlen);
 }
 
+static int dec_ttl(struct datapath *dp, struct sk_buff *skb,
+		   struct sw_flow_key *fk, const struct nlattr *attr, bool last)
+{
+	struct nlattr *actions;
+	struct nlattr *dec_ttl_arg;
+	int rem = nla_len(attr);
+	const struct dec_ttl_arg *arg;
+
+	/* The first action is always OVS_DEC_TTL_ATTR_ARG. */
+	dec_ttl_arg = nla_data(attr);
+	arg = nla_data(dec_ttl_arg);
+	actions = nla_next(dec_ttl_arg, &rem);
+
+	switch (arg->action_type) {
+	case OVS_DEC_TTL_ACTION_DROP:
+		consume_skb(skb);
+		break;
+
+	case OVS_DEC_TTL_ACTION_USER_SPACE:
+		return clone_execute(dp, skb, fk, 0, actions, rem, last, false);
+	}
+
+	return 0;
+}
+
 /* When 'last' is true, sample() should always consume the 'skb'.
  * Otherwise, sample() should keep 'skb' intact regardless what
  * actions are executed within sample().
@@ -1176,6 +1201,44 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
 			     nla_len(actions), last, clone_flow_key);
 }
 
+static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
+{
+	int err;
+
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		struct ipv6hdr *nh = ipv6_hdr(skb);
+
+		err = skb_ensure_writable(skb, skb_network_offset(skb) +
+					  sizeof(*nh));
+		if (unlikely(err))
+			return err;
+
+		if (nh->hop_limit <= 1)
+			return -EHOSTUNREACH;
+
+		key->ip.ttl = --nh->hop_limit;
+	} else {
+		struct iphdr *nh = ip_hdr(skb);
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
+
+	return 0;
+}
+
 /* Execute a list of actions against 'skb'. */
 static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			      struct sw_flow_key *key,
@@ -1347,6 +1410,14 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 
 			break;
 		}
+
+		case OVS_ACTION_ATTR_DEC_TTL:
+			err = execute_dec_ttl(skb, key);
+			if (err == -EHOSTUNREACH) {
+				err = dec_ttl(dp, skb, key, a, true);
+				return err;
+			}
+			break;
 		}
 
 		if (unlikely(err)) {
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 65c2e3458ff5..a9eea2ffb8b0 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -61,6 +61,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
 		case OVS_ACTION_ATTR_RECIRC:
 		case OVS_ACTION_ATTR_TRUNC:
 		case OVS_ACTION_ATTR_USERSPACE:
+		case OVS_ACTION_ATTR_DEC_TTL:
 			break;
 
 		case OVS_ACTION_ATTR_CT:
@@ -2494,6 +2495,59 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 	return 0;
 }
 
+static int validate_and_copy_dec_ttl(struct net *net, const struct nlattr *attr,
+				     const struct sw_flow_key *key,
+				     struct sw_flow_actions **sfa,
+				     __be16 eth_type, __be16 vlan_tci,
+				     u32 mpls_label_count, bool log)
+{
+	struct nlattr *attrs[OVS_DEC_TTL_ATTR_MAX + 1] = { 0 };
+	const struct nlattr *action_type, *action;
+	struct nlattr *a;
+	int rem, start, err;
+	struct dec_ttl_arg arg;
+
+	nla_for_each_nested(a, attr, rem) {
+		int type = nla_type(a);
+
+		if (!type || type > OVS_DEC_TTL_ATTR_MAX || attrs[type])
+			return -EINVAL;
+
+		attrs[type] = a;
+	}
+	if (rem)
+		return -EINVAL;
+
+	action_type = attrs[OVS_DEC_TTL_ATTR_ACTION_TYPE];
+	if (!action_type || nla_len(action_type) != sizeof(u32))
+		return -EINVAL;
+
+	start = add_nested_action_start(sfa, OVS_ACTION_ATTR_DEC_TTL, log);
+	if (start < 0)
+		return start;
+
+	arg.action_type = nla_get_u32(action_type);
+	err = ovs_nla_add_action(sfa, OVS_DEC_TTL_ATTR_ARG,
+				 &arg, sizeof(arg), log);
+	if (err)
+		return err;
+
+	if (arg.action_type == OVS_DEC_TTL_ACTION_USER_SPACE) {
+		action = attrs[OVS_DEC_TTL_ATTR_ACTION];
+		if (!action || (nla_len(action) && nla_len(action) < NLA_HDRLEN))
+			return -EINVAL;
+
+		err = __ovs_nla_copy_actions(net, action, key, sfa, eth_type,
+					     vlan_tci, mpls_label_count, log);
+		if (err)
+			return err;
+	}
+
+	add_nested_action_end(*sfa, start);
+
+	return 0;
+}
+
 static int validate_and_copy_clone(struct net *net,
 				   const struct nlattr *attr,
 				   const struct sw_flow_key *key,
@@ -3005,6 +3059,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			[OVS_ACTION_ATTR_METER] = sizeof(u32),
 			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
 			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
+			[OVS_ACTION_ATTR_DEC_TTL] = (u32)-1,
 		};
 		const struct ovs_action_push_vlan *vlan;
 		int type = nla_type(a);
@@ -3233,6 +3288,15 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
@@ -3404,6 +3468,41 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
 	return err;
 }
 
+static int dec_ttl_action_to_attr(const struct nlattr *att, struct sk_buff *skb)
+{
+	struct nlattr *start, *ac_start = NULL, *dec_ttl;
+	int err = 0, rem = nla_len(att);
+	const struct dec_ttl_arg *arg;
+	struct nlattr *actions;
+
+	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_DEC_TTL);
+	if (!start)
+		return -EMSGSIZE;
+
+	dec_ttl = nla_data(att);
+	arg = nla_data(dec_ttl);
+	actions = nla_next(dec_ttl, &rem);
+
+	if (nla_put_u32(skb, OVS_DEC_TTL_ATTR_ACTION_TYPE, arg->action_type)) {
+		nla_nest_cancel(skb, start);
+		return -EMSGSIZE;
+	}
+
+	if (arg->action_type == OVS_DEC_TTL_ACTION_USER_SPACE) {
+		ac_start = nla_nest_start_noflag(skb, OVS_DEC_TTL_ATTR_ACTION);
+		if (!ac_start) {
+			nla_nest_cancel(skb, ac_start);
+			nla_nest_cancel(skb, start);
+			return -EMSGSIZE;
+		}
+		err = ovs_nla_put_actions(actions, rem, skb);
+		nla_nest_end(skb, ac_start);
+	}
+	nla_nest_end(skb, start);
+
+	return err;
+}
+
 static int set_action_to_attr(const struct nlattr *a, struct sk_buff *skb)
 {
 	const struct nlattr *ovs_key = nla_data(a);
@@ -3504,6 +3603,12 @@ int ovs_nla_put_actions(const struct nlattr *attr, int len, struct sk_buff *skb)
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
2.23.0

