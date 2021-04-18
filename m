Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FAA3637A5
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhDRVEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:04:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34980 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhDRVEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:53 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 790B663E89;
        Sun, 18 Apr 2021 23:03:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/14] netfilter: flowtable: add vlan pop action offload support
Date:   Sun, 18 Apr 2021 23:04:03 +0200
Message-Id: <20210418210415.4719-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch adds vlan pop action offload in the flowtable offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index dc1d6b4e35f8..b87f8c3ee6c2 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -619,6 +619,7 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 			  struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *other_tuple;
+	const struct flow_offload_tuple *tuple;
 	int i;
 
 	flow_offload_decap_tunnel(flow, dir, flow_rule);
@@ -628,6 +629,20 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
 
+	tuple = &flow->tuplehash[dir].tuple;
+
+	for (i = 0; i < tuple->encap_num; i++) {
+		struct flow_action_entry *entry;
+
+		if (tuple->in_vlan_ingress & BIT(i))
+			continue;
+
+		if (tuple->encap[i].proto == htons(ETH_P_8021Q)) {
+			entry = flow_action_entry_next(flow_rule);
+			entry->id = FLOW_ACTION_VLAN_POP;
+		}
+	}
+
 	other_tuple = &flow->tuplehash[!dir].tuple;
 
 	for (i = 0; i < other_tuple->encap_num; i++) {
-- 
2.30.2

