Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B9F34537B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhCVX5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhCVX4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:56:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BDB1C061762;
        Mon, 22 Mar 2021 16:56:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9254563134;
        Tue, 23 Mar 2021 00:56:35 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/10] netfilter: flowtable: call dst_check() to fall back to classic forwarding
Date:   Tue, 23 Mar 2021 00:56:26 +0100
Message-Id: <20210322235628.2204-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322235628.2204-1-pablo@netfilter.org>
References: <20210322235628.2204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the route is stale, pass up the packet to the classic forwarding
path for re-evaluation and schedule this flow entry for removal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 714dc083f093..3a8423899def 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -197,14 +197,6 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
-static int nf_flow_offload_dst_check(struct dst_entry *dst)
-{
-	if (unlikely(dst_xfrm(dst)))
-		return dst_check(dst, 0) ? 0 : -1;
-
-	return 0;
-}
-
 static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      const struct nf_hook_state *state,
 				      struct dst_entry *dst)
@@ -256,7 +248,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	flow_offload_refresh(flow_table, flow);
 
-	if (nf_flow_offload_dst_check(&rt->dst)) {
+	if (!dst_check(&rt->dst, 0)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
 	}
@@ -476,7 +468,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	flow_offload_refresh(flow_table, flow);
 
-	if (nf_flow_offload_dst_check(&rt->dst)) {
+	if (!dst_check(&rt->dst, 0)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
 	}
-- 
2.20.1

