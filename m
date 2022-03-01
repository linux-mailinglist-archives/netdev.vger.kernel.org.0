Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0CB4C9808
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiCAVye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238622AbiCAVy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:54:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D237E7DE19;
        Tue,  1 Mar 2022 13:53:47 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4D763625FE;
        Tue,  1 Mar 2022 22:52:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/8] net/sched: act_ct: Fix flow table lookup failure with no originating ifindex
Date:   Tue,  1 Mar 2022 22:53:37 +0100
Message-Id: <20220301215337.378405-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301215337.378405-1-pablo@netfilter.org>
References: <20220301215337.378405-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

After cited commit optimizted hw insertion, flow table entries are
populated with ifindex information which was intended to only be used
for HW offload. This tuple ifindex is hashed in the flow table key, so
it must be filled for lookup to be successful. But tuple ifindex is only
relevant for the netfilter flowtables (nft), so it's not filled in
act_ct flow table lookup, resulting in lookup failure, and no SW
offload and no offload teardown for TCP connection FIN/RST packets.

To fix this, add new tc ifindex field to tuple, which will
only be used for offloading, not for lookup, as it will not be
part of the tuple hash.

Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tuple iifidx")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  6 +++++-
 net/netfilter/nf_flow_table_offload.c |  6 +++++-
 net/sched/act_ct.c                    | 13 +++++++++----
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..bd59e950f4d6 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -96,6 +96,7 @@ enum flow_offload_xmit_type {
 	FLOW_OFFLOAD_XMIT_NEIGH,
 	FLOW_OFFLOAD_XMIT_XFRM,
 	FLOW_OFFLOAD_XMIT_DIRECT,
+	FLOW_OFFLOAD_XMIT_TC,
 };
 
 #define NF_FLOW_TABLE_ENCAP_MAX		2
@@ -127,7 +128,7 @@ struct flow_offload_tuple {
 	struct { }			__hash;
 
 	u8				dir:2,
-					xmit_type:2,
+					xmit_type:3,
 					encap_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
@@ -142,6 +143,9 @@ struct flow_offload_tuple {
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
+		struct {
+			u32		iifidx;
+		} tc;
 	};
 };
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45..fc4265acd9c4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -110,7 +110,11 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		nf_flow_rule_lwt_match(match, tun_info);
 	}
 
-	key->meta.ingress_ifindex = tuple->iifidx;
+	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_TC)
+		key->meta.ingress_ifindex = tuple->tc.iifidx;
+	else
+		key->meta.ingress_ifindex = tuple->iifidx;
+
 	mask->meta.ingress_ifindex = 0xffffffff;
 
 	if (tuple->encap_num > 0 && !(tuple->in_vlan_ingress & BIT(0)) &&
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 33e70d60f0bf..ec19f625863a 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -361,6 +361,13 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
 	}
 }
 
+static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
+				 struct nf_conn_act_ct_ext *act_ct_ext, u8 dir)
+{
+	entry->tuplehash[dir].tuple.xmit_type = FLOW_OFFLOAD_XMIT_TC;
+	entry->tuplehash[dir].tuple.tc.iifidx = act_ct_ext->ifindex[dir];
+}
+
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
 				  bool tcp)
@@ -385,10 +392,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 
 	act_ct_ext = nf_conn_act_ct_ext_find(ct);
 	if (act_ct_ext) {
-		entry->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx =
-			act_ct_ext->ifindex[IP_CT_DIR_ORIGINAL];
-		entry->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.iifidx =
-			act_ct_ext->ifindex[IP_CT_DIR_REPLY];
+		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_ORIGINAL);
+		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_REPLY);
 	}
 
 	err = flow_offload_add(&ct_ft->nf_ft, entry);
-- 
2.30.2

