Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B31189C05
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgCRMdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:33:22 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59126 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbgCRMdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:33:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jEXsp-0004kd-GV; Wed, 18 Mar 2020 13:33:15 +0100
Date:   Wed, 18 Mar 2020 13:33:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net-next] netfilter: revert introduction of egress hook
Message-ID: <20200318123315.GI979@breakpoint.cc>
References: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
 <20200318100227.GE979@breakpoint.cc>
 <c7c6fb40-06f9-8078-6f76-5dc75a094e25@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c6fb40-06f9-8078-6f76-5dc75a094e25@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 3/18/20 11:02 AM, Florian Westphal wrote:
> > Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > This reverts the following commits:
> > > 
> > >    8537f78647c0 ("netfilter: Introduce egress hook")
> > >    5418d3881e1f ("netfilter: Generalize ingress hook")
> > >    b030f194aed2 ("netfilter: Rename ingress hook include file")
> > > 
> > >  From the discussion in [0], the author's main motivation to add a hook
> > > in fast path is for an out of tree kernel module, which is a red flag
> > > to begin with.
> > 
> > The author did post patches for nftables, i.e. you can hook up rulesets to
> > this new hook point.
> > 
> > > is on future extensions w/o concrete code in the tree yet. Revert as
> > > suggested [1] given the weak justification to add more hooks to critical
> > > fast-path.
> > 
> > Do you have an alternative suggestion on how to expose this?
> 
> Yeah, I think we should not plaster the stack with same/similar hooks that
> achieve the same functionality next to each other over and over at the cost
> of performance for users .. ideally there should just be a single entry point
> that is very lightweight/efficient when not used and can otherwise patch to
> a direct call when in use. Recent work from KP Singh goes into this direction
> with the fmodify_return work [0], so we would have a single static key which
> wraps an empty function call entry which can then be patched by the kernel at
> runtime. Inside that trampoline we can still keep the ordering intact, but
> imho this would overall better reduce overhead when functionality is not used
> compared to the practice of duplication today.

Thanks for explaining.  If I understand this correctly then:

1. sch_handle_egress() becomes a non-inlined function that isn't called
   from __dev_queue_xmit or any other location
2. __dev_queue_xmit calls a dummy do-nothing function wrapped in
   existing egress-static-key
3. kernels sched/tc code can patch the dummy function so it calls
   sch_handle_egress, without userspace changes/awareness
4. netfilter could reuse this even when tc is already patched in, so
   the dummy function does two direct calls.

How does that differ from current code?  One could also re-arrange
things like this (diff below, just for illustration).

The only difference I see vs. my understanding of your proposal is:
1. no additional static key, nf_hook_egress_active() doesn't exist
2. nf_hook_egress exists, but isn't called anywhere, patched-in at runtime
3. sch_handle_egress isn't called anywhere either, patched-in too

Did I get that right? The idea/plan looks good to me, it just looks
like a very marginal difference to me, thats why I'm asking.

Thanks!

diff --git a/net/core/dev.c b/net/core/dev.c
index aeb8ccbbe93b..406ac86b6d6c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3770,13 +3770,24 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 EXPORT_SYMBOL(dev_loopback_xmit);
 
 #ifdef CONFIG_NET_EGRESS
-static struct sk_buff *
+static int nf_egress(struct sk_buff *skb)
+{
+	if (nf_hook_egress_active(skb))
+		return nf_hook_egress(skb);
+
+	return 0;
+}
+
+static noinline struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
-#ifdef CONFIG_NET_CLS_ACT
-	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
+	struct mini_Qdisc *miniq;
 	struct tcf_result cl_res;
 
+	if (nf_egress(skb) < 0)
+		return NULL;
+
+	miniq = rcu_dereference_bh(dev->miniq_egress);
 	if (!miniq)
 		return skb;
 
@@ -3812,19 +3823,6 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 }
 #endif /* CONFIG_NET_EGRESS */
 #ifdef CONFIG_XPS
 static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
 			       struct xps_dev_maps *dev_maps, unsigned int tci)
@@ -4014,9 +4012,6 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 #endif
 #ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
-		if (nf_egress(skb) < 0)
-			goto out;
-
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
