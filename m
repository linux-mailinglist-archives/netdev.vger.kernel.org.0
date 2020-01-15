Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69EA13C9C0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 17:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAOQkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 11:40:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726574AbgAOQku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 11:40:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579106449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cuoFxGvfj/E5m56spHOc2aFS7gn7FCqMWxsYUn1RGaU=;
        b=THTX6LWBgKmgd4T4v5pXw0TykzwZzo8mMOLbPyNX53C2qBG40kodwwVPlHklBeb+ltuGyd
        pvQnd05qYlQozf6qMjlZwY1/4fkVXDlXsGFeFbPNORIE+ekUNVDROgkrH1wqGNISZOIfqa
        2GzpjxSYV2+Yw+kncbrles3VYzxlGpU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-lYfI4hDBMjuZadjstlq4tQ-1; Wed, 15 Jan 2020 11:40:47 -0500
X-MC-Unique: lYfI4hDBMjuZadjstlq4tQ-1
Received: by mail-wr1-f71.google.com with SMTP id w6so8141303wrm.16
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 08:40:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cuoFxGvfj/E5m56spHOc2aFS7gn7FCqMWxsYUn1RGaU=;
        b=WuT3yUx8HzfiTwQxXJWeFa18xWkBOm0M+G38qnesRuhkgezCk0PnJuLD+FkvP8QTO2
         UZbNFCvvHvfBK+5/PJxu9qRIDsXvAWvjPOFqWA945pzu6JqXaZ7xXJVGn6cDKb7ZaEvo
         1fMGXQUyaF8mLuMh6/t609kA+KRh58GHm7fNP8kW6HdnGE5iTxPSsICDeu0TANH7Ou0E
         5/QsXDXqmyz7JXJIndNkROxUiV0BxyvITuX3IGtl2RZagUqljFXZyUEbl/KJdmUSCJHV
         Eb7df1SCLkQtVrkJXsn2udRQYKEwB1ONuqmm+Y3vDk188idC/ljEnBsZ42xJzyBejL7F
         tZgQ==
X-Gm-Message-State: APjAAAWIZgqktD/aEeBXjDWNlrUjVtuBDroPMMpqG+L05dtcpkriwVxk
        Gnq0vb47nW5Ozwl+0V7PBdS8H+1R9VdeDvglbQwIguJoLpIZBBGXfm6KR2hdlOlF796f77kQ8C3
        8wWagGq1iYs+MjYKa
X-Received: by 2002:a1c:5f8a:: with SMTP id t132mr760180wmb.162.1579106445976;
        Wed, 15 Jan 2020 08:40:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUhF1OEW1q+M+fKTUfv0YChLDUicAzacmSFn/VN+DA8ziQnNvczJHXXTu9ytjBzG3hJPbUzg==
X-Received: by 2002:a1c:5f8a:: with SMTP id t132mr760160wmb.162.1579106445704;
        Wed, 15 Jan 2020 08:40:45 -0800 (PST)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c5sm542023wmb.9.2020.01.15.08.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 08:40:44 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3] openvswitch: add TTL decrement action
Date:   Wed, 15 Jan 2020 17:40:30 +0100
Message-Id: <20200115164030.56045-1-mcroce@redhat.com>
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
 include/uapi/linux/openvswitch.h |  2 +
 net/openvswitch/actions.c        | 67 ++++++++++++++++++++++++++++++
 net/openvswitch/flow_netlink.c   | 71 ++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index ae2bff14e7e1..9d3f040847af 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -958,6 +958,7 @@ enum ovs_action_attr {
 	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
 	OVS_ACTION_ATTR_ADD_MPLS,     /* struct ovs_action_add_mpls. */
+	OVS_ACTION_ATTR_DEC_TTL,      /* Nested OVS_DEC_TTL_ATTR_*. */
 
 	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
 				       * from userspace. */
@@ -1050,4 +1051,5 @@ struct ovs_zone_limit {
 	__u32 count;
 };
 
+#define OVS_DEC_TTL_ATTR_EXEC      0
 #endif /* _LINUX_OPENVSWITCH_H */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 7fbfe2adfffa..1b0afc9bf1ad 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -964,6 +964,26 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 	return ovs_dp_upcall(dp, skb, key, &upcall, cutlen);
 }
 
+static int dec_ttl(struct datapath *dp, struct sk_buff *skb,
+		   struct sw_flow_key *key,
+		   const struct nlattr *attr, bool last)
+{
+	/* The first action is always 'OVS_DEC_TTL_ATTR_ARG'. */
+	struct nlattr *dec_ttl_arg = nla_data(attr);
+	u32 nested = nla_get_u32(dec_ttl_arg);
+	int rem = nla_len(attr);
+
+	if (nested) {
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
@@ -1180,6 +1200,45 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
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
@@ -1365,6 +1424,14 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 
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
index 7da4230627f5..0354d5501b70 100644
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
@@ -2495,6 +2496,40 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 	return 0;
 }
 
+static int validate_and_copy_dec_ttl(struct net *net,
+				     const struct nlattr *attr,
+				     const struct sw_flow_key *key,
+				     struct sw_flow_actions **sfa,
+				     __be16 eth_type, __be16 vlan_tci,
+				     u32 mpls_label_count, bool log)
+{
+	u32 nested = true;
+	int start, err;
+
+	if (!nla_len(attr))
+		nested = false;
+
+	start = add_nested_action_start(sfa, OVS_ACTION_ATTR_DEC_TTL, log);
+	if (start < 0)
+		return start;
+
+	err = ovs_nla_add_action(sfa, OVS_DEC_TTL_ATTR_EXEC, &nested,
+				 sizeof(nested), log);
+
+	if (err)
+		return err;
+
+	if (nested) {
+		err = __ovs_nla_copy_actions(net, attr, key, sfa, eth_type,
+					     vlan_tci, mpls_label_count, log);
+		if (err)
+			return err;
+	}
+
+	add_nested_action_end(*sfa, start);
+	return 0;
+}
+
 static int validate_and_copy_clone(struct net *net,
 				   const struct nlattr *attr,
 				   const struct sw_flow_key *key,
@@ -3007,6 +3042,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
 			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
 			[OVS_ACTION_ATTR_ADD_MPLS] = sizeof(struct ovs_action_add_mpls),
+			[OVS_ACTION_ATTR_DEC_TTL] = (u32)-1,
 		};
 		const struct ovs_action_push_vlan *vlan;
 		int type = nla_type(a);
@@ -3267,6 +3303,15 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
@@ -3438,6 +3483,26 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
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
@@ -3538,6 +3603,12 @@ int ovs_nla_put_actions(const struct nlattr *attr, int len, struct sk_buff *skb)
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

