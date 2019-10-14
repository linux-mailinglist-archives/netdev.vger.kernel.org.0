Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661A9D6B6A
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731126AbfJNWAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:00:52 -0400
Received: from correo.us.es ([193.147.175.20]:33332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730966AbfJNWAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 18:00:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DAF371694C7
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:00:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCDBBA7E20
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:00:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BE285A7E9E; Tue, 15 Oct 2019 00:00:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94C99FF6C4;
        Tue, 15 Oct 2019 00:00:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 00:00:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 302B7426CCBB;
        Tue, 15 Oct 2019 00:00:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: [PATCH net-next,v4 4/4] net: flow_offload: add flow_rule_print()
Date:   Tue, 15 Oct 2019 00:00:27 +0200
Message-Id: <20191014220027.7500-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191014220027.7500-1-pablo@netfilter.org>
References: <20191014220027.7500-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_offload.h        |  3 ++
 net/core/flow_offload.c           | 85 +++++++++++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_offload.c |  6 ++-
 net/sched/cls_flower.c            |  4 ++
 4 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 78a462d4bfbb..e65007378d38 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -6,6 +6,9 @@
 #include <net/flow_dissector.h>
 #include <linux/rhashtable.h>
 
+struct flow_rule;
+void flow_rule_print(const struct flow_rule *flow_rule);
+
 struct flow_match {
 	struct flow_dissector	*dissector;
 	void			*mask;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index cf52d9c422fa..9ef74e338d3f 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -5,6 +5,91 @@
 #include <linux/rtnetlink.h>
 #include <linux/mutex.h>
 
+void flow_rule_print(const struct flow_rule *flow_rule)
+{
+	const struct flow_action_entry *act;
+	int i;
+
+	pr_info("match : ");
+	if (flow_rule_match_key(flow_rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(flow_rule, &match);
+		pr_info("l3num %hu/%x protocol %u/%x ",
+			match.key->n_proto, match.mask->n_proto,
+			match.key->ip_proto, match.mask->ip_proto);
+	}
+
+	if (flow_rule_match_key(flow_rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(flow_rule, &match);
+		pr_info("src=%pI4/%pI4 dst=%pI4/%pI4 ",
+			&match.key->src, &match.mask->src,
+			&match.key->dst, &match.mask->dst);
+	}
+
+	if (flow_rule_match_key(flow_rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(flow_rule, &match);
+		pr_info("sport %hu/%x dport %hu/%x ",
+			match.key->src, match.mask->src,
+			match.key->dst, match.mask->dst);
+	}
+
+	pr_info("actions(%d): ", flow_rule->action.num_entries);
+	flow_action_for_each(i, act, &flow_rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_DROP:
+			pr_info("drop");
+			break;
+		case FLOW_ACTION_ACCEPT:
+			pr_info("accept");
+			break;
+		case FLOW_ACTION_MANGLE:
+			pr_info("mangle htype=%u offset=%u len=%u ",
+				act->mangle.htype, act->mangle.offset,
+				act->mangle.len);
+			{
+				int k;
+
+				pr_info("val=");
+				for (k = 0; k < act->mangle.len; k++)
+					pr_info("%.2x ", act->mangle.val[k]);
+
+				pr_info(" mask=");
+				for (k = 0; k < act->mangle.len; k++)
+					pr_info("%.2x ", act->mangle.mask[k]);
+
+				pr_info("\n");
+			}
+			break;
+		case FLOW_ACTION_REDIRECT:
+			pr_info("redirect\n");
+			break;
+		case FLOW_ACTION_MIRRED:
+			pr_info("mirred\n");
+			break;
+		case FLOW_ACTION_CSUM:
+			pr_info("checksum\n");
+			break;
+		case FLOW_ACTION_TUNNEL_ENCAP:
+			pr_info("tunnel encap\n");
+			break;
+		case FLOW_ACTION_TUNNEL_DECAP:
+			pr_info("tunnel decap\n");
+			break;
+		default:
+			pr_info("unknown!!!!");
+			break;
+		}
+	}
+
+	pr_info("\n");
+}
+EXPORT_SYMBOL_GPL(flow_rule_print);
+
 struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 {
 	struct flow_rule *rule;
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index e546f759b7a7..f73f5b84be70 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -177,8 +177,12 @@ static int nft_flow_offload_rule(struct nft_chain *chain,
 				     basechain->ops.priority, &extack);
 	cls_flow.command = command;
 	cls_flow.cookie = (unsigned long) rule;
-	if (flow)
+	if (flow) {
 		cls_flow.rule = flow->rule;
+		pr_info("---- nft hw offload ----\n");
+		flow_rule_print(cls_flow.rule);
+		pr_info("--------\n");
+	}
 
 	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flow);
 }
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 74221e3351c3..9beab50474c3 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -453,6 +453,10 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		return 0;
 	}
 
+	pr_info("---- hw offload ----\n");
+	flow_rule_print(cls_flower.rule);
+	pr_info("--------\n");
+
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
 			      skip_sw, &f->flags, &f->in_hw_count, rtnl_held);
 	tc_cleanup_flow_action(&cls_flower.rule->action);
-- 
2.11.0

