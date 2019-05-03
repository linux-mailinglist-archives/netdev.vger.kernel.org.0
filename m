Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E1813173
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfECPui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:50:38 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51986 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728172AbfECPui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:50:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hMaSK-0004Wj-2q; Fri, 03 May 2019 17:50:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 3/6] xfrm: remove init_flags indirection from xfrm_state_afinfo
Date:   Fri,  3 May 2019 17:46:16 +0200
Message-Id: <20190503154619.32352-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190503154619.32352-1-fw@strlen.de>
References: <20190503154619.32352-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is only one implementation of this function; just call it directly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  1 -
 net/ipv4/xfrm4_state.c |  8 --------
 net/xfrm/xfrm_state.c  | 17 +++--------------
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 8ac6d4d617cc..5d1c2bdee91e 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -352,7 +352,6 @@ struct xfrm_state_afinfo {
 	const struct xfrm_type		*type_map[IPPROTO_MAX];
 	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
 
-	int			(*init_flags)(struct xfrm_state *x);
 	int			(*tmpl_sort)(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n);
 	int			(*state_sort)(struct xfrm_state **dst, struct xfrm_state **src, int n);
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index 018448e222af..62c96da38b4e 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -15,13 +15,6 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/export.h>
 
-static int xfrm4_init_flags(struct xfrm_state *x)
-{
-	if (xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc)
-		x->props.flags |= XFRM_STATE_NOPMTUDISC;
-	return 0;
-}
-
 int xfrm4_extract_header(struct sk_buff *skb)
 {
 	const struct iphdr *iph = ip_hdr(skb);
@@ -43,7 +36,6 @@ static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.proto			= IPPROTO_IPIP,
 	.eth_proto		= htons(ETH_P_IP),
 	.owner			= THIS_MODULE,
-	.init_flags		= xfrm4_init_flags,
 	.output			= xfrm4_output,
 	.output_finish		= xfrm4_output_finish,
 	.extract_input		= xfrm4_extract_input,
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 42662d9e8b5e..636b055570e7 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2256,25 +2256,14 @@ int xfrm_state_mtu(struct xfrm_state *x, int mtu)
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
-	const struct xfrm_state_afinfo *afinfo;
 	const struct xfrm_mode *inner_mode;
 	const struct xfrm_mode *outer_mode;
 	int family = x->props.family;
 	int err;
 
-	err = -EAFNOSUPPORT;
-	afinfo = xfrm_state_get_afinfo(family);
-	if (!afinfo)
-		goto error;
-
-	err = 0;
-	if (afinfo->init_flags)
-		err = afinfo->init_flags(x);
-
-	rcu_read_unlock();
-
-	if (err)
-		goto error;
+	if (family == AF_INET &&
+	    xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc)
+		x->props.flags |= XFRM_STATE_NOPMTUDISC;
 
 	err = -EPROTONOSUPPORT;
 
-- 
2.21.0

