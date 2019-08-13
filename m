Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE7D8B80C
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfHMMHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32951 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHMMHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id n190so10351841pgn.0;
        Tue, 13 Aug 2019 05:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TZkJV6sDt2PGGk4lDoLb18E0qN5uD7qf4OWOBYTWxJo=;
        b=eh9JUsLYnROz/ziqwHGkkG0/lBGISitAGttCNaZL0Ohxlqm6D3h/K2yzjBi6+KMLqx
         Jc+XbnTwk6HmpODz32leCcB0sqqhy9VFPMAHCjHGoBBsdANuuMXS9XzwrdPzdAUqmy2T
         3WgaFdqQyM51Qre+/YsaAYT+Wx9oyo7k4C4A1E6DXDYZIrogonxdI8kYl/5+AF77XyZG
         AlxI0Y1r32FxqHJJL7r4ZSihis7sqJHCezzIiLzrqrpDzQmnIKfk4azbq3WWJZ76gOvT
         Cr8beFMzaZxgVuRUNWN/v8eGuiub1XsZuLsDtf9SQxxXc3B5pBuPsDGxAQqvDDWI2RoG
         7WMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TZkJV6sDt2PGGk4lDoLb18E0qN5uD7qf4OWOBYTWxJo=;
        b=sUGSTnbihJNzwvIbKRaXv+Ok71wSqilA9UJ89b/oH6JtlmKnFb3SnIOz9KeOCQ5pSy
         eKRHwx8t7UdqAH1X9TdP/sHczLc+iflwiVoopWxmAt/YKeZ3BvWS5QXXHVOYH/4SJh3O
         leDuM56YvnClKs2i8qsTIU4VFHi2dQq9jxEb5l3Qpsz6MNGsBKml2IiW00p/SUkkzDap
         CtUGPlmTin45G6FVHTXz6m5k6b9yRyfaJqmm1DwSE0Ntu0FJ5T6NER3BETtvWdEa0ENe
         ccyktK2qIXdigaqiLHZp2OE14tKG80MsgKkX6Tg0jiuqM546Ib5UJ+pg3aVjka9HlA4A
         fjLQ==
X-Gm-Message-State: APjAAAWLuI5SQqJ15AJ5DmBfDZDcNnUqwiW2armX/UW1Mj83tCs5WOe1
        a1Nj9zcsHh/PeeW4S6fUu76azXq1
X-Google-Smtp-Source: APXvYqwPB2b7TjAbWVfEWXftR6YR8tilpJQtS+MKbETkJQgA3p7aadPNPk+bER7YfeoDE9iLUMTTlg==
X-Received: by 2002:aa7:8f29:: with SMTP id y9mr10828587pfr.27.1565698070196;
        Tue, 13 Aug 2019 05:07:50 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:49 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 08/14] xdp_flow: Implement flow replacement/deletion logic in xdp_flow kmod
Date:   Tue, 13 Aug 2019 21:05:52 +0900
Message-Id: <20190813120558.6151-9-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As struct flow_rule has descrete storages for flow_dissector and
key/mask containers, we need to serialize them in some way to pass them
to UMH.

Convert flow_rule into flow key form used in xdp_flow bpf prog and
pass it.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/xdp_flow_kern_mod.c | 334 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 331 insertions(+), 3 deletions(-)

diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
index 9cf527d..fe925db 100644
--- a/net/xdp_flow/xdp_flow_kern_mod.c
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -3,13 +3,266 @@
 #include <linux/module.h>
 #include <linux/umh.h>
 #include <linux/sched/signal.h>
+#include <linux/rhashtable.h>
 #include <net/pkt_cls.h>
 #include <net/flow_offload_xdp.h>
 #include "msgfmt.h"
 
+struct xdp_flow_rule {
+	struct rhash_head ht_node;
+	unsigned long cookie;
+	struct xdp_flow_key key;
+	struct xdp_flow_key mask;
+};
+
+static const struct rhashtable_params rules_params = {
+	.key_len = sizeof(unsigned long),
+	.key_offset = offsetof(struct xdp_flow_rule, cookie),
+	.head_offset = offsetof(struct xdp_flow_rule, ht_node),
+	.automatic_shrinking = true,
+};
+
+static struct rhashtable rules;
+
 extern char xdp_flow_umh_start;
 extern char xdp_flow_umh_end;
 
+static int xdp_flow_parse_actions(struct xdp_flow_actions *actions,
+				  struct flow_action *flow_action,
+				  struct netlink_ext_ack *extack)
+{
+	const struct flow_action_entry *act;
+	int i;
+
+	if (!flow_action_has_entries(flow_action))
+		return 0;
+
+	if (flow_action->num_entries > MAX_XDP_FLOW_ACTIONS)
+		return -ENOBUFS;
+
+	flow_action_for_each(i, act, flow_action) {
+		struct xdp_flow_action *action = &actions->actions[i];
+
+		switch (act->id) {
+		case FLOW_ACTION_ACCEPT:
+			action->id = XDP_FLOW_ACTION_ACCEPT;
+			break;
+		case FLOW_ACTION_DROP:
+			action->id = XDP_FLOW_ACTION_DROP;
+			break;
+		case FLOW_ACTION_REDIRECT:
+		case FLOW_ACTION_VLAN_PUSH:
+		case FLOW_ACTION_VLAN_POP:
+		case FLOW_ACTION_VLAN_MANGLE:
+		case FLOW_ACTION_MANGLE:
+		case FLOW_ACTION_CSUM:
+			/* TODO: implement these */
+			/* fall through */
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
+			return -EOPNOTSUPP;
+		}
+	}
+	actions->num_actions = flow_action->num_entries;
+
+	return 0;
+}
+
+static int xdp_flow_parse_ports(struct xdp_flow_key *key,
+				struct xdp_flow_key *mask,
+				struct flow_cls_offload *f, u8 ip_proto)
+{
+	const struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_match_ports match;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS))
+		return 0;
+
+	if (ip_proto != IPPROTO_TCP && ip_proto != IPPROTO_UDP) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Only UDP and TCP keys are supported");
+		return -EINVAL;
+	}
+
+	flow_rule_match_ports(rule, &match);
+
+	key->l4port.src = match.key->src;
+	mask->l4port.src = match.mask->src;
+	key->l4port.dst = match.key->dst;
+	mask->l4port.dst = match.mask->dst;
+
+	return 0;
+}
+
+static int xdp_flow_parse_tcp(struct xdp_flow_key *key,
+			      struct xdp_flow_key *mask,
+			      struct flow_cls_offload *f, u8 ip_proto)
+{
+	const struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_match_tcp match;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP))
+		return 0;
+
+	if (ip_proto != IPPROTO_TCP) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "TCP keys supported only for TCP");
+		return -EINVAL;
+	}
+
+	flow_rule_match_tcp(rule, &match);
+
+	key->tcp.flags = match.key->flags;
+	mask->tcp.flags = match.mask->flags;
+
+	return 0;
+}
+
+static int xdp_flow_parse_ip(struct xdp_flow_key *key,
+			     struct xdp_flow_key *mask,
+			     struct flow_cls_offload *f, __be16 n_proto)
+{
+	const struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_match_ip match;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP))
+		return 0;
+
+	if (n_proto != htons(ETH_P_IP) && n_proto != htons(ETH_P_IPV6)) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "IP keys supported only for IPv4/6");
+		return -EINVAL;
+	}
+
+	flow_rule_match_ip(rule, &match);
+
+	key->ip.ttl = match.key->ttl;
+	mask->ip.ttl = match.mask->ttl;
+	key->ip.tos = match.key->tos;
+	mask->ip.tos = match.mask->tos;
+
+	return 0;
+}
+
+static int xdp_flow_parse(struct xdp_flow_key *key, struct xdp_flow_key *mask,
+			  struct xdp_flow_actions *actions,
+			  struct flow_cls_offload *f)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
+	__be16 n_proto = 0, n_proto_mask = 0;
+	u16 addr_type = 0;
+	u8 ip_proto = 0;
+	int err;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_TCP) |
+	      BIT(FLOW_DISSECTOR_KEY_IP) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN))) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported key");
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+
+		n_proto = match.key->n_proto;
+		n_proto_mask = match.mask->n_proto;
+		if (n_proto == htons(ETH_P_ALL)) {
+			n_proto = 0;
+			n_proto_mask = 0;
+		}
+
+		key->eth.type = n_proto;
+		mask->eth.type = n_proto_mask;
+
+		if (match.mask->ip_proto) {
+			ip_proto = match.key->ip_proto;
+			key->ip.proto = ip_proto;
+			mask->ip.proto = match.mask->ip_proto;
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(rule, &match);
+
+		ether_addr_copy(key->eth.dst, match.key->dst);
+		ether_addr_copy(mask->eth.dst, match.mask->dst);
+		ether_addr_copy(key->eth.src, match.key->src);
+		ether_addr_copy(mask->eth.src, match.mask->src);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+
+		key->vlan.tpid = match.key->vlan_tpid;
+		mask->vlan.tpid = match.mask->vlan_tpid;
+		key->vlan.tci = htons(match.key->vlan_id |
+				      (match.key->vlan_priority <<
+				       VLAN_PRIO_SHIFT));
+		mask->vlan.tci = htons(match.mask->vlan_id |
+				       (match.mask->vlan_priority <<
+					VLAN_PRIO_SHIFT));
+	}
+
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
+
+		key->ipv4.src = match.key->src;
+		mask->ipv4.src = match.mask->src;
+		key->ipv4.dst = match.key->dst;
+		mask->ipv4.dst = match.mask->dst;
+	}
+
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(rule, &match);
+
+		key->ipv6.src = match.key->src;
+		mask->ipv6.src = match.mask->src;
+		key->ipv6.dst = match.key->dst;
+		mask->ipv6.dst = match.mask->dst;
+	}
+
+	err = xdp_flow_parse_ports(key, mask, f, ip_proto);
+	if (err)
+		return err;
+	err = xdp_flow_parse_tcp(key, mask, f, ip_proto);
+	if (err)
+		return err;
+
+	err = xdp_flow_parse_ip(key, mask, f, n_proto);
+	if (err)
+		return err;
+
+	// TODO: encapsulation related tasks
+
+	return xdp_flow_parse_actions(actions, &rule->action,
+					   f->common.extack);
+}
+
 static void shutdown_umh(void)
 {
 	struct task_struct *tsk;
@@ -60,12 +313,78 @@ static int transact_umh(struct mbox_request *req, u32 *id)
 
 static int xdp_flow_replace(struct net_device *dev, struct flow_cls_offload *f)
 {
-	return -EOPNOTSUPP;
+	struct xdp_flow_rule *rule;
+	struct mbox_request *req;
+	int err;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	req->flow.priority = f->common.prio >> 16;
+	err = xdp_flow_parse(&req->flow.key, &req->flow.mask,
+			     &req->flow.actions, f);
+	if (err)
+		goto err_parse;
+
+	rule->cookie = f->cookie;
+	rule->key = req->flow.key;
+	rule->mask = req->flow.mask;
+	err = rhashtable_insert_fast(&rules, &rule->ht_node, rules_params);
+	if (err)
+		goto err_parse;
+
+	req->cmd = XDP_FLOW_CMD_REPLACE;
+	req->ifindex = dev->ifindex;
+	err = transact_umh(req, NULL);
+	if (err)
+		goto err_umh;
+out:
+	kfree(req);
+
+	return err;
+err_umh:
+	rhashtable_remove_fast(&rules, &rule->ht_node, rules_params);
+err_parse:
+	kfree(rule);
+	goto out;
 }
 
 int xdp_flow_destroy(struct net_device *dev, struct flow_cls_offload *f)
 {
-	return -EOPNOTSUPP;
+	struct mbox_request *req;
+	struct xdp_flow_rule *rule;
+	int err;
+
+	rule = rhashtable_lookup_fast(&rules, &f->cookie, rules_params);
+	if (!rule)
+		return 0;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->flow.priority = f->common.prio >> 16;
+	req->flow.key = rule->key;
+	req->flow.mask = rule->mask;
+	req->cmd = XDP_FLOW_CMD_DELETE;
+	req->ifindex = dev->ifindex;
+	err = transact_umh(req, NULL);
+
+	kfree(req);
+
+	if (!err) {
+		rhashtable_remove_fast(&rules, &rule->ht_node, rules_params);
+		kfree(rule);
+	}
+
+	return err;
 }
 
 static int xdp_flow_setup_flower(struct net_device *dev,
@@ -267,7 +586,11 @@ static int start_umh(void)
 
 static int __init load_umh(void)
 {
-	int err = 0;
+	int err;
+
+	err = rhashtable_init(&rules, &rules_params);
+	if (err)
+		return err;
 
 	mutex_lock(&xdp_flow_ops.lock);
 	if (!xdp_flow_ops.stop) {
@@ -283,8 +606,12 @@ static int __init load_umh(void)
 	xdp_flow_ops.setup = &xdp_flow_setup;
 	xdp_flow_ops.start = &start_umh;
 	xdp_flow_ops.module = THIS_MODULE;
+
+	mutex_unlock(&xdp_flow_ops.lock);
+	return 0;
 err:
 	mutex_unlock(&xdp_flow_ops.lock);
+	rhashtable_destroy(&rules);
 	return err;
 }
 
@@ -297,6 +624,7 @@ static void __exit fini_umh(void)
 	xdp_flow_ops.setup = NULL;
 	xdp_flow_ops.setup_cb = NULL;
 	mutex_unlock(&xdp_flow_ops.lock);
+	rhashtable_destroy(&rules);
 }
 module_init(load_umh);
 module_exit(fini_umh);
-- 
1.8.3.1

