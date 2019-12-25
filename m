Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC62F12A715
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 10:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLYJse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 04:48:34 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26418 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfLYJsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 04:48:31 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 765E440F46;
        Wed, 25 Dec 2019 17:48:25 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, jiri@mellanox.com
Subject: [PATCH net-next 5/5] netfilter: nf_flow_table_offload: add tunnel encap/decap action offload support
Date:   Wed, 25 Dec 2019 17:48:23 +0800
Message-Id: <1577267303-24780-6-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSExCQkJCQkJOSUhKTUhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NTI6Djo4CTg6F0ITTxYRMhAp
        NBFPCjZVSlVKTkxMSU1MSEtOTk1LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhNS0I3Bg++
X-HM-Tid: 0a6f3c751c2c2086kuqy765e440f46
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch add tunnel encap decap action offload in the flowtable
offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 93ff2e6..5fcb4bc 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -476,6 +476,45 @@ static void flow_offload_redirect(const struct flow_offload *flow,
 	dev_hold(rt->dst.dev);
 }
 
+static void flow_offload_encap_tunnel(const struct flow_offload *flow,
+				      enum flow_offload_tuple_dir dir,
+				      struct nf_flow_rule *flow_rule)
+{
+	struct flow_action_entry *entry;
+	struct dst_entry *dst;
+
+	dst = flow->tuplehash[dir].tuple.dst_cache;
+	if (dst->lwtstate) {
+		struct ip_tunnel_info *tun_info;
+
+		tun_info = lwt_tun_info(dst->lwtstate);
+		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
+			entry = flow_action_entry_next(flow_rule);
+			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
+			entry->tunnel = tun_info;
+		}
+	}
+}
+
+static void flow_offload_decap_tunnel(const struct flow_offload *flow,
+				      enum flow_offload_tuple_dir dir,
+				      struct nf_flow_rule *flow_rule)
+{
+	struct flow_action_entry *entry;
+	struct dst_entry *dst;
+
+	dst = flow->tuplehash[!dir].tuple.dst_cache;
+	if (dst->lwtstate) {
+		struct ip_tunnel_info *tun_info;
+
+		tun_info = lwt_tun_info(dst->lwtstate);
+		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
+			entry = flow_action_entry_next(flow_rule);
+			entry->id = FLOW_ACTION_TUNNEL_DECAP;
+		}
+	}
+}
+
 int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
@@ -496,6 +535,10 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 	    flow->flags & FLOW_OFFLOAD_DNAT)
 		flow_offload_ipv4_checksum(net, flow, flow_rule);
 
+	flow_offload_decap_tunnel(flow, dir, flow_rule);
+
+	flow_offload_encap_tunnel(flow, dir, flow_rule);
+
 	flow_offload_redirect(flow, dir, flow_rule);
 
 	return 0;
@@ -519,6 +562,10 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
 
+	flow_offload_decap_tunnel(flow, dir, flow_rule);
+
+	flow_offload_encap_tunnel(flow, dir, flow_rule);
+
 	flow_offload_redirect(flow, dir, flow_rule);
 
 	return 0;
-- 
1.8.3.1

