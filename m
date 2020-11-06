Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832362A9078
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgKFHgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:36:23 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:47984 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgKFHgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:36:22 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2020 02:36:21 EST
Received: from localhost.localdomain (unknown [185.12.128.224])
        by mail.strongswan.org (Postfix) with ESMTPSA id DBDAA4207E;
        Fri,  6 Nov 2020 08:30:43 +0100 (CET)
From:   Martin Willi <martin@strongswan.org>
To:     David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH net] vrf: Fix fast path output packet handling with async Netfilter rules
Date:   Fri,  6 Nov 2020 08:30:30 +0100
Message-Id: <20201106073030.3974927-1-martin@strongswan.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VRF devices use an optimized direct path on output if a default qdisc
is involved, calling Netfilter hooks directly. This path, however, does
not consider Netfilter rules completing asynchronously, such as with
NFQUEUE. The Netfilter okfn() is called for asynchronously accepted
packets, but the VRF never passes that packet down the stack to send
it out over the slave device. Using the slower redirect path for this
seems not feasible, as we do not know beforehand if a Netfilter hook
has asynchronously completing rules.

Fix the use of asynchronously completing Netfilter rules in OUTPUT and
POSTROUTING by using a special completion function that additionally
calls dst_output() to pass the packet down the stack. Also, slightly
adjust the use of nf_reset_ct() so that is called in the asynchronous
case, too.

Fixes: dcdd43c41e60 ("net: vrf: performance improvements for IPv4")
Fixes: a9ec54d1b0cd ("net: vrf: performance improvements for IPv6")
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 drivers/net/vrf.c | 92 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 23 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 60c1aadece89..f2793ffde191 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -608,8 +608,7 @@ static netdev_tx_t vrf_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
-static int vrf_finish_direct(struct net *net, struct sock *sk,
-			     struct sk_buff *skb)
+static void vrf_finish_direct(struct sk_buff *skb)
 {
 	struct net_device *vrf_dev = skb->dev;
 
@@ -628,7 +627,8 @@ static int vrf_finish_direct(struct net *net, struct sock *sk,
 		skb_pull(skb, ETH_HLEN);
 	}
 
-	return 1;
+	/* reset skb device */
+	nf_reset_ct(skb);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -707,15 +707,41 @@ static struct sk_buff *vrf_ip6_out_redirect(struct net_device *vrf_dev,
 	return skb;
 }
 
+static int vrf_output6_direct_finish(struct net *net, struct sock *sk,
+				     struct sk_buff *skb)
+{
+	vrf_finish_direct(skb);
+
+	return vrf_ip6_local_out(net, sk, skb);
+}
+
 static int vrf_output6_direct(struct net *net, struct sock *sk,
 			      struct sk_buff *skb)
 {
+	int err = 1;
+
 	skb->protocol = htons(ETH_P_IPV6);
 
-	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
-			    net, sk, skb, NULL, skb->dev,
-			    vrf_finish_direct,
-			    !(IPCB(skb)->flags & IPSKB_REROUTED));
+	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
+		err = nf_hook(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, sk, skb,
+			      NULL, skb->dev, vrf_output6_direct_finish);
+
+	if (likely(err == 1))
+		vrf_finish_direct(skb);
+
+	return err;
+}
+
+static int vrf_ip6_out_direct_finish(struct net *net, struct sock *sk,
+				     struct sk_buff *skb)
+{
+	int err;
+
+	err = vrf_output6_direct(net, sk, skb);
+	if (likely(err == 1))
+		err = vrf_ip6_local_out(net, sk, skb);
+
+	return err;
 }
 
 static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
@@ -728,18 +754,15 @@ static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
 	skb->dev = vrf_dev;
 
 	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
-		      skb, NULL, vrf_dev, vrf_output6_direct);
+		      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
 
 	if (likely(err == 1))
 		err = vrf_output6_direct(net, sk, skb);
 
-	/* reset skb device */
 	if (likely(err == 1))
-		nf_reset_ct(skb);
-	else
-		skb = NULL;
+		return skb;
 
-	return skb;
+	return NULL;
 }
 
 static struct sk_buff *vrf_ip6_out(struct net_device *vrf_dev,
@@ -919,15 +942,41 @@ static struct sk_buff *vrf_ip_out_redirect(struct net_device *vrf_dev,
 	return skb;
 }
 
+static int vrf_output_direct_finish(struct net *net, struct sock *sk,
+				    struct sk_buff *skb)
+{
+	vrf_finish_direct(skb);
+
+	return vrf_ip_local_out(net, sk, skb);
+}
+
 static int vrf_output_direct(struct net *net, struct sock *sk,
 			     struct sk_buff *skb)
 {
+	int err = 1;
+
 	skb->protocol = htons(ETH_P_IP);
 
-	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
-			    net, sk, skb, NULL, skb->dev,
-			    vrf_finish_direct,
-			    !(IPCB(skb)->flags & IPSKB_REROUTED));
+	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
+		err = nf_hook(NFPROTO_IPV4, NF_INET_POST_ROUTING, net, sk, skb,
+			      NULL, skb->dev, vrf_output_direct_finish);
+
+	if (likely(err == 1))
+		vrf_finish_direct(skb);
+
+	return err;
+}
+
+static int vrf_ip_out_direct_finish(struct net *net, struct sock *sk,
+				    struct sk_buff *skb)
+{
+	int err;
+
+	err = vrf_output_direct(net, sk, skb);
+	if (likely(err == 1))
+		err = vrf_ip_local_out(net, sk, skb);
+
+	return err;
 }
 
 static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
@@ -940,18 +989,15 @@ static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
 	skb->dev = vrf_dev;
 
 	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
-		      skb, NULL, vrf_dev, vrf_output_direct);
+		      skb, NULL, vrf_dev, vrf_ip_out_direct_finish);
 
 	if (likely(err == 1))
 		err = vrf_output_direct(net, sk, skb);
 
-	/* reset skb device */
 	if (likely(err == 1))
-		nf_reset_ct(skb);
-	else
-		skb = NULL;
+		return skb;
 
-	return skb;
+	return NULL;
 }
 
 static struct sk_buff *vrf_ip_out(struct net_device *vrf_dev,
-- 
2.25.1

