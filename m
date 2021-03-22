Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB23634537F
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhCVX5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhCVX4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:56:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA0AFC061763;
        Mon, 22 Mar 2021 16:56:44 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1E69A63136;
        Tue, 23 Mar 2021 00:56:36 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/10] netfilter: flowtable: refresh timeout after dst and writable checks
Date:   Tue, 23 Mar 2021 00:56:27 +0100
Message-Id: <20210322235628.2204-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322235628.2204-1-pablo@netfilter.org>
References: <20210322235628.2204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refresh the timeout (and retry hardware offload) once the skbuff dst
is confirmed to be current and after the skbuff is made writable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3a8423899def..3be58b6d60af 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -246,8 +246,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
-	flow_offload_refresh(flow_table, flow);
-
 	if (!dst_check(&rt->dst, 0)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
@@ -256,6 +254,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
+	flow_offload_refresh(flow_table, flow);
+
 	iph = ip_hdr(skb);
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
 
@@ -466,8 +466,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				sizeof(*ip6h)))
 		return NF_ACCEPT;
 
-	flow_offload_refresh(flow_table, flow);
-
 	if (!dst_check(&rt->dst, 0)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
@@ -476,6 +474,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, sizeof(*ip6h) + hdrsize))
 		return NF_DROP;
 
+	flow_offload_refresh(flow_table, flow);
+
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
 
-- 
2.20.1

