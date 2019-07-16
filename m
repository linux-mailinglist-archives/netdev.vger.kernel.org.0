Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0F56ABB0
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 17:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387904AbfGPP01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 11:26:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbfGPP00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 11:26:26 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 308BA3D95A;
        Tue, 16 Jul 2019 15:26:26 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-89.ams2.redhat.com [10.36.116.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCDF71001B05;
        Tue, 16 Jul 2019 15:26:24 +0000 (UTC)
Date:   Tue, 16 Jul 2019 17:26:23 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, Andreas Steinmetz <ast@domdv.de>
Subject: Re: [PATCH net] net: fix use-after-free in __netif_receive_skb_core
Message-ID: <20190716152623.GA9074@bistromath.localdomain>
References: <e909b8fe24b9eac71de52c4f80f7f3f6e5770199.1562766613.git.sd@queasysnail.net>
 <62ad16f6-c33a-407e-2f55-9be382b7ec52@solarflare.com>
 <20190710224724.GA28254@bistromath.localdomain>
 <8166b82f-8430-1441-32e7-540c1829754e@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8166b82f-8430-1441-32e7-540c1829754e@solarflare.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 16 Jul 2019 15:26:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-07-12, 16:29:48 +0100, Edward Cree wrote:
> On 10/07/2019 23:47, Sabrina Dubroca wrote:
> > 2019-07-10, 16:07:43 +0100, Edward Cree wrote:
> >> On 10/07/2019 14:52, Sabrina Dubroca wrote:
> >>> -static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
> >>> +static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> >>>  				    struct packet_type **ppt_prev)
> >>>  {
> >>>  	struct packet_type *ptype, *pt_prev;
> >>>  	rx_handler_func_t *rx_handler;
> >>> +	struct sk_buff *skb = *pskb;
> >> Would it not be simpler just to change all users of skb to *pskb?
> >> Then you avoid having to keep doing "*pskb = skb;" whenever skb changes
> >>  (with concomitant risk of bugs if one gets missed).
> > Yes, that would be less risky. I wrote a version of the patch that did
> > exactly that, but found it really too ugly (both the patch and the
> > resulting code).
> If you've still got that version (or can dig it out of your reflog), can
>  you post it so we can see just how ugly it turns out?

No, I didn't even commit it. Rewrote it now, it's rewriting over 1/4
of the lines. Considering that the patch would need to go in stable, I
don't think that's appropriate.

(This has been only compiled, not actually tested)

diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b2610e3..5fb2a15d42e1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4799,7 +4799,7 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 	return 0;
 }
 
-static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
+static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
 	struct packet_type *ptype, *pt_prev;
@@ -4809,21 +4809,21 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	int ret = NET_RX_DROP;
 	__be16 type;
 
-	net_timestamp_check(!netdev_tstamp_prequeue, skb);
+	net_timestamp_check(!netdev_tstamp_prequeue, *pskb);
 
-	trace_netif_receive_skb(skb);
+	trace_netif_receive_skb(*pskb);
 
-	orig_dev = skb->dev;
+	orig_dev = (*pskb)->dev;
 
-	skb_reset_network_header(skb);
-	if (!skb_transport_header_was_set(skb))
-		skb_reset_transport_header(skb);
-	skb_reset_mac_len(skb);
+	skb_reset_network_header(*pskb);
+	if (!skb_transport_header_was_set(*pskb))
+		skb_reset_transport_header(*pskb);
+	skb_reset_mac_len(*pskb);
 
 	pt_prev = NULL;
 
 another_round:
-	skb->skb_iif = skb->dev->ifindex;
+	(*pskb)->skb_iif = (*pskb)->dev->ifindex;
 
 	__this_cpu_inc(softnet_data.processed);
 
@@ -4831,22 +4831,22 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		int ret2;
 
 		preempt_disable();
-		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		ret2 = do_xdp_generic(rcu_dereference((*pskb)->dev->xdp_prog), *pskb);
 		preempt_enable();
 
 		if (ret2 != XDP_PASS)
 			return NET_RX_DROP;
-		skb_reset_mac_len(skb);
+		skb_reset_mac_len(*pskb);
 	}
 
-	if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
-	    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
-		skb = skb_vlan_untag(skb);
-		if (unlikely(!skb))
+	if ((*pskb)->protocol == cpu_to_be16(ETH_P_8021Q) ||
+	    (*pskb)->protocol == cpu_to_be16(ETH_P_8021AD)) {
+		*pskb = skb_vlan_untag(*pskb);
+		if (unlikely(!*pskb))
 			goto out;
 	}
 
-	if (skb_skip_tc_classify(skb))
+	if (skb_skip_tc_classify(*pskb))
 		goto skip_classify;
 
 	if (pfmemalloc)
@@ -4854,50 +4854,50 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 
 	list_for_each_entry_rcu(ptype, &ptype_all, list) {
 		if (pt_prev)
-			ret = deliver_skb(skb, pt_prev, orig_dev);
+			ret = deliver_skb(*pskb, pt_prev, orig_dev);
 		pt_prev = ptype;
 	}
 
-	list_for_each_entry_rcu(ptype, &skb->dev->ptype_all, list) {
+	list_for_each_entry_rcu(ptype, &(*pskb)->dev->ptype_all, list) {
 		if (pt_prev)
-			ret = deliver_skb(skb, pt_prev, orig_dev);
+			ret = deliver_skb(*pskb, pt_prev, orig_dev);
 		pt_prev = ptype;
 	}
 
 skip_taps:
 #ifdef CONFIG_NET_INGRESS
 	if (static_branch_unlikely(&ingress_needed_key)) {
-		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev);
-		if (!skb)
+		*pskb = sch_handle_ingress(*pskb, &pt_prev, &ret, orig_dev);
+		if (!*pskb)
 			goto out;
 
-		if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
+		if (nf_ingress(*pskb, &pt_prev, &ret, orig_dev) < 0)
 			goto out;
 	}
 #endif
-	skb_reset_tc(skb);
+	skb_reset_tc(*pskb);
 skip_classify:
-	if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
+	if (pfmemalloc && !skb_pfmemalloc_protocol(*pskb))
 		goto drop;
 
-	if (skb_vlan_tag_present(skb)) {
+	if (skb_vlan_tag_present(*pskb)) {
 		if (pt_prev) {
-			ret = deliver_skb(skb, pt_prev, orig_dev);
+			ret = deliver_skb(*pskb, pt_prev, orig_dev);
 			pt_prev = NULL;
 		}
-		if (vlan_do_receive(&skb))
+		if (vlan_do_receive(pskb))
 			goto another_round;
-		else if (unlikely(!skb))
+		else if (unlikely(!*pskb))
 			goto out;
 	}
 
-	rx_handler = rcu_dereference(skb->dev->rx_handler);
+	rx_handler = rcu_dereference((*pskb)->dev->rx_handler);
 	if (rx_handler) {
 		if (pt_prev) {
-			ret = deliver_skb(skb, pt_prev, orig_dev);
+			ret = deliver_skb(*pskb, pt_prev, orig_dev);
 			pt_prev = NULL;
 		}
-		switch (rx_handler(&skb)) {
+		switch (rx_handler(pskb)) {
 		case RX_HANDLER_CONSUMED:
 			ret = NET_RX_SUCCESS;
 			goto out;
@@ -4912,29 +4912,29 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		}
 	}
 
-	if (unlikely(skb_vlan_tag_present(skb))) {
+	if (unlikely(skb_vlan_tag_present(*pskb))) {
 check_vlan_id:
-		if (skb_vlan_tag_get_id(skb)) {
+		if (skb_vlan_tag_get_id(*pskb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
 			 * find vlan device.
 			 */
-			skb->pkt_type = PACKET_OTHERHOST;
-		} else if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
-			   skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
+			(*pskb)->pkt_type = PACKET_OTHERHOST;
+		} else if ((*pskb)->protocol == cpu_to_be16(ETH_P_8021Q) ||
+			   (*pskb)->protocol == cpu_to_be16(ETH_P_8021AD)) {
 			/* Outer header is 802.1P with vlan 0, inner header is
 			 * 802.1Q or 802.1AD and vlan_do_receive() above could
 			 * not find vlan dev for vlan id 0.
 			 */
-			__vlan_hwaccel_clear_tag(skb);
-			skb = skb_vlan_untag(skb);
-			if (unlikely(!skb))
+			__vlan_hwaccel_clear_tag(*pskb);
+			*pskb = skb_vlan_untag(*pskb);
+			if (unlikely(!*pskb))
 				goto out;
-			if (vlan_do_receive(&skb))
+			if (vlan_do_receive(pskb))
 				/* After stripping off 802.1P header with vlan 0
 				 * vlan dev is found for inner header.
 				 */
 				goto another_round;
-			else if (unlikely(!skb))
+			else if (unlikely(!*pskb))
 				goto out;
 			else
 				/* We have stripped outer 802.1P vlan 0 header.
@@ -4944,40 +4944,40 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 				goto check_vlan_id;
 		}
 		/* Note: we might in the future use prio bits
-		 * and set skb->priority like in vlan_do_receive()
+		 * and set (*pskb)->priority like in vlan_do_receive()
 		 * For the time being, just ignore Priority Code Point
 		 */
-		__vlan_hwaccel_clear_tag(skb);
+		__vlan_hwaccel_clear_tag(*pskb);
 	}
 
-	type = skb->protocol;
+	type = (*pskb)->protocol;
 
 	/* deliver only exact match when indicated */
 	if (likely(!deliver_exact)) {
-		deliver_ptype_list_skb(skb, &pt_prev, orig_dev, type,
+		deliver_ptype_list_skb(*pskb, &pt_prev, orig_dev, type,
 				       &ptype_base[ntohs(type) &
 						   PTYPE_HASH_MASK]);
 	}
 
-	deliver_ptype_list_skb(skb, &pt_prev, orig_dev, type,
+	deliver_ptype_list_skb(*pskb, &pt_prev, orig_dev, type,
 			       &orig_dev->ptype_specific);
 
-	if (unlikely(skb->dev != orig_dev)) {
-		deliver_ptype_list_skb(skb, &pt_prev, orig_dev, type,
-				       &skb->dev->ptype_specific);
+	if (unlikely((*pskb)->dev != orig_dev)) {
+		deliver_ptype_list_skb(*pskb, &pt_prev, orig_dev, type,
+				       &(*pskb)->dev->ptype_specific);
 	}
 
 	if (pt_prev) {
-		if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
+		if (unlikely(skb_orphan_frags_rx(*pskb, GFP_ATOMIC)))
 			goto drop;
 		*ppt_prev = pt_prev;
 	} else {
 drop:
 		if (!deliver_exact)
-			atomic_long_inc(&skb->dev->rx_dropped);
+			atomic_long_inc(&(*pskb)->dev->rx_dropped);
 		else
-			atomic_long_inc(&skb->dev->rx_nohandler);
-		kfree_skb(skb);
+			atomic_long_inc(&(*pskb)->dev->rx_nohandler);
+		kfree_skb(*pskb);
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
 		 */
@@ -4994,7 +4994,7 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
 	struct packet_type *pt_prev = NULL;
 	int ret;
 
-	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+	ret = __netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 	if (pt_prev)
 		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
 					 skb->dev, pt_prev, orig_dev);
@@ -5072,7 +5072,7 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 		struct packet_type *pt_prev = NULL;
 
 		skb_list_del_init(skb);
-		__netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+		__netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 		if (!pt_prev)
 			continue;
 		if (pt_curr != pt_prev || od_curr != orig_dev) {


> Here's a thought, how about switching round the return-vs-pass-by-pointer
>  and writing:
> 
> static struct sk_buff *__netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>                                                 struct packet_type **ppt_prev, int *ret)
> ?
> (Although, you might want to rename 'ret' in that case.)
> 
> Does that make things any less ugly?

That seems more reasonable (also only compiled so far):

diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b2610e3..e09b6a14851c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4799,8 +4799,8 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 	return 0;
 }
 
-static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
-				    struct packet_type **ppt_prev)
+static struct sk_buff *__netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
+						struct packet_type **ppt_prev, int *retp)
 {
 	struct packet_type *ptype, *pt_prev;
 	rx_handler_func_t *rx_handler;
@@ -4834,8 +4834,10 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
 		preempt_enable();
 
-		if (ret2 != XDP_PASS)
-			return NET_RX_DROP;
+		if (ret2 != XDP_PASS) {
+			*retp = NET_RX_DROP;
+			return NULL;
+		}
 		skb_reset_mac_len(skb);
 	}
 
@@ -4985,7 +4987,8 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	}
 
 out:
-	return ret;
+	*retp = ret;
+	return skb;
 }
 
 static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
@@ -4994,7 +4997,7 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
 	struct packet_type *pt_prev = NULL;
 	int ret;
 
-	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+	skb = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev, &ret);
 	if (pt_prev)
 		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
 					 skb->dev, pt_prev, orig_dev);
@@ -5070,9 +5073,10 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 	list_for_each_entry_safe(skb, next, head, list) {
 		struct net_device *orig_dev = skb->dev;
 		struct packet_type *pt_prev = NULL;
+		int ret;
 
 		skb_list_del_init(skb);
-		__netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+		skb = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev, &ret);
 		if (!pt_prev)
 			continue;
 		if (pt_curr != pt_prev || od_curr != orig_dev) {


-- 
Sabrina
