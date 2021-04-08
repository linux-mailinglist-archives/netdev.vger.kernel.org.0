Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADD5358B9C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhDHRp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhDHRpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 13:45:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99897C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 10:45:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lUYiM-0000kx-RV; Thu, 08 Apr 2021 19:45:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] net: dccp: use net_generic storage
Date:   Thu,  8 Apr 2021 19:45:02 +0200
Message-Id: <20210408174502.1625-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DCCP is virtually never used, so no need to use space in struct net for it.

Put the pernet ipv4/v6 socket in the dccp ipv4/ipv6 modules instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/net_namespace.h |  4 ----
 include/net/netns/dccp.h    | 12 ------------
 net/dccp/ipv4.c             | 24 ++++++++++++++++++++----
 net/dccp/ipv6.c             | 24 ++++++++++++++++++++----
 4 files changed, 40 insertions(+), 24 deletions(-)
 delete mode 100644 include/net/netns/dccp.h

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 3802c8322ab0..fa5887143f0d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -22,7 +22,6 @@
 #include <net/netns/nexthop.h>
 #include <net/netns/ieee802154_6lowpan.h>
 #include <net/netns/sctp.h>
-#include <net/netns/dccp.h>
 #include <net/netns/netfilter.h>
 #include <net/netns/x_tables.h>
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
@@ -130,9 +129,6 @@ struct net {
 #if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
 	struct netns_sctp	sctp;
 #endif
-#if defined(CONFIG_IP_DCCP) || defined(CONFIG_IP_DCCP_MODULE)
-	struct netns_dccp	dccp;
-#endif
 #ifdef CONFIG_NETFILTER
 	struct netns_nf		nf;
 	struct netns_xt		xt;
diff --git a/include/net/netns/dccp.h b/include/net/netns/dccp.h
deleted file mode 100644
index cdbc4f5b8390..000000000000
--- a/include/net/netns/dccp.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __NETNS_DCCP_H__
-#define __NETNS_DCCP_H__
-
-struct sock;
-
-struct netns_dccp {
-	struct sock *v4_ctl_sk;
-	struct sock *v6_ctl_sk;
-};
-
-#endif
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 2455b0c0e486..ffc601a3b329 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -23,14 +23,21 @@
 #include <net/tcp_states.h>
 #include <net/xfrm.h>
 #include <net/secure_seq.h>
+#include <net/netns/generic.h>
 
 #include "ackvec.h"
 #include "ccid.h"
 #include "dccp.h"
 #include "feat.h"
 
+struct dccp_v4_pernet {
+	struct sock *v4_ctl_sk;
+};
+
+static unsigned int dccp_v4_pernet_id __read_mostly;
+
 /*
- * The per-net dccp.v4_ctl_sk socket is used for responding to
+ * The per-net v4_ctl_sk socket is used for responding to
  * the Out-of-the-blue (OOTB) packets. A control sock will be created
  * for this socket at the initialization time.
  */
@@ -513,7 +520,8 @@ static void dccp_v4_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	struct sk_buff *skb;
 	struct dst_entry *dst;
 	struct net *net = dev_net(skb_dst(rxskb)->dev);
-	struct sock *ctl_sk = net->dccp.v4_ctl_sk;
+	struct dccp_v4_pernet *pn;
+	struct sock *ctl_sk;
 
 	/* Never send a reset in response to a reset. */
 	if (dccp_hdr(rxskb)->dccph_type == DCCP_PKT_RESET)
@@ -522,6 +530,8 @@ static void dccp_v4_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	if (skb_rtable(rxskb)->rt_type != RTN_LOCAL)
 		return;
 
+	pn = net_generic(net, dccp_v4_pernet_id);
+	ctl_sk = pn->v4_ctl_sk;
 	dst = dccp_v4_route_skb(net, ctl_sk, rxskb);
 	if (dst == NULL)
 		return;
@@ -1005,16 +1015,20 @@ static struct inet_protosw dccp_v4_protosw = {
 
 static int __net_init dccp_v4_init_net(struct net *net)
 {
+	struct dccp_v4_pernet *pn = net_generic(net, dccp_v4_pernet_id);
+
 	if (dccp_hashinfo.bhash == NULL)
 		return -ESOCKTNOSUPPORT;
 
-	return inet_ctl_sock_create(&net->dccp.v4_ctl_sk, PF_INET,
+	return inet_ctl_sock_create(&pn->v4_ctl_sk, PF_INET,
 				    SOCK_DCCP, IPPROTO_DCCP, net);
 }
 
 static void __net_exit dccp_v4_exit_net(struct net *net)
 {
-	inet_ctl_sock_destroy(net->dccp.v4_ctl_sk);
+	struct dccp_v4_pernet *pn = net_generic(net, dccp_v4_pernet_id);
+
+	inet_ctl_sock_destroy(pn->v4_ctl_sk);
 }
 
 static void __net_exit dccp_v4_exit_batch(struct list_head *net_exit_list)
@@ -1026,6 +1040,8 @@ static struct pernet_operations dccp_v4_ops = {
 	.init	= dccp_v4_init_net,
 	.exit	= dccp_v4_exit_net,
 	.exit_batch = dccp_v4_exit_batch,
+	.id	= &dccp_v4_pernet_id,
+	.size   = sizeof(struct dccp_v4_pernet),
 };
 
 static int __init dccp_v4_init(void)
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 2be5c69824f9..6f5304db5a67 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -27,13 +27,20 @@
 #include <net/ip6_checksum.h>
 #include <net/xfrm.h>
 #include <net/secure_seq.h>
+#include <net/netns/generic.h>
 #include <net/sock.h>
 
 #include "dccp.h"
 #include "ipv6.h"
 #include "feat.h"
 
-/* The per-net dccp.v6_ctl_sk is used for sending RSTs and ACKs */
+struct dccp_v6_pernet {
+	struct sock *v6_ctl_sk;
+};
+
+static unsigned int dccp_v6_pernet_id __read_mostly;
+
+/* The per-net v6_ctl_sk is used for sending RSTs and ACKs */
 
 static const struct inet_connection_sock_af_ops dccp_ipv6_mapped;
 static const struct inet_connection_sock_af_ops dccp_ipv6_af_ops;
@@ -254,7 +261,8 @@ static void dccp_v6_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	struct sk_buff *skb;
 	struct flowi6 fl6;
 	struct net *net = dev_net(skb_dst(rxskb)->dev);
-	struct sock *ctl_sk = net->dccp.v6_ctl_sk;
+	struct dccp_v6_pernet *pn;
+	struct sock *ctl_sk;
 	struct dst_entry *dst;
 
 	if (dccp_hdr(rxskb)->dccph_type == DCCP_PKT_RESET)
@@ -263,6 +271,8 @@ static void dccp_v6_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	if (!ipv6_unicast_destination(rxskb))
 		return;
 
+	pn = net_generic(net, dccp_v6_pernet_id);
+	ctl_sk = pn->v6_ctl_sk;
 	skb = dccp_ctl_make_reset(ctl_sk, rxskb);
 	if (skb == NULL)
 		return;
@@ -1089,16 +1099,20 @@ static struct inet_protosw dccp_v6_protosw = {
 
 static int __net_init dccp_v6_init_net(struct net *net)
 {
+	struct dccp_v6_pernet *pn = net_generic(net, dccp_v6_pernet_id);
+
 	if (dccp_hashinfo.bhash == NULL)
 		return -ESOCKTNOSUPPORT;
 
-	return inet_ctl_sock_create(&net->dccp.v6_ctl_sk, PF_INET6,
+	return inet_ctl_sock_create(&pn->v6_ctl_sk, PF_INET6,
 				    SOCK_DCCP, IPPROTO_DCCP, net);
 }
 
 static void __net_exit dccp_v6_exit_net(struct net *net)
 {
-	inet_ctl_sock_destroy(net->dccp.v6_ctl_sk);
+	struct dccp_v6_pernet *pn = net_generic(net, dccp_v6_pernet_id);
+
+	inet_ctl_sock_destroy(pn->v6_ctl_sk);
 }
 
 static void __net_exit dccp_v6_exit_batch(struct list_head *net_exit_list)
@@ -1110,6 +1124,8 @@ static struct pernet_operations dccp_v6_ops = {
 	.init   = dccp_v6_init_net,
 	.exit   = dccp_v6_exit_net,
 	.exit_batch = dccp_v6_exit_batch,
+	.id	= &dccp_v6_pernet_id,
+	.size   = sizeof(struct dccp_v6_pernet),
 };
 
 static int __init dccp_v6_init(void)
-- 
2.26.3

