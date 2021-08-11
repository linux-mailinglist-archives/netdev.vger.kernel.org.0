Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB57B3E8C5D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhHKIto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:49:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44030 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbhHKItk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:49:40 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id D172760066;
        Wed, 11 Aug 2021 10:48:33 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/10] netfilter: flowtable: remove nf_ct_l4proto_find() call
Date:   Wed, 11 Aug 2021 10:49:00 +0200
Message-Id: <20210811084908.14744-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210811084908.14744-1-pablo@netfilter.org>
References: <20210811084908.14744-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP and UDP are built-in conntrack protocol trackers and the flowtable
only supports for TCP and UDP, remove this call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8fe024a0ae46..ec3dd1c9c8f4 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -180,15 +180,10 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 
 static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 {
-	const struct nf_conntrack_l4proto *l4proto;
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
 	unsigned int timeout;
 
-	l4proto = nf_ct_l4proto_find(l4num);
-	if (!l4proto)
-		return;
-
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
@@ -273,15 +268,10 @@ static const struct rhashtable_params nf_flow_offload_rhash_params = {
 
 unsigned long flow_offload_get_timeout(struct flow_offload *flow)
 {
-	const struct nf_conntrack_l4proto *l4proto;
 	unsigned long timeout = NF_FLOW_TIMEOUT;
 	struct net *net = nf_ct_net(flow->ct);
 	int l4num = nf_ct_protonum(flow->ct);
 
-	l4proto = nf_ct_l4proto_find(l4num);
-	if (!l4proto)
-		return timeout;
-
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
-- 
2.20.1

