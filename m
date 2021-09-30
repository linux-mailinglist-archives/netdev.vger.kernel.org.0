Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D448E41D3CC
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhI3HC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbhI3HC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 03:02:26 -0400
X-Greylist: delayed 482 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Sep 2021 00:00:44 PDT
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443C8C06161C;
        Thu, 30 Sep 2021 00:00:44 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 86993101EA412;
        Thu, 30 Sep 2021 08:52:38 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 5B5731FD87; Thu, 30 Sep 2021 08:52:38 +0200 (CEST)
Date:   Thu, 30 Sep 2021 08:52:38 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <20210930065238.GA28709@wunner.de>
References: <20210928095538.114207-1-pablo@netfilter.org>
 <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 08:08:53AM +0200, Daniel Borkmann wrote:
> Hm, so in the case of SRv6 users were running into a similar issue
> and commit 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6
> data plane") [0] added a new hook along with a sysctl which defaults
> the new hook to off.
> 
> The rationale for it was given as "the hooks are enabled via
> nf_hooks_lwtunnel sysctl to make sure existing netfilter rulesets
>  do not break." [0,1]
> 
> If the suggestion to flag the skb [2] one way or another from the
> tc forwarding path (e.g. skb bit or per-cpu marker) is not
> technically feasible, then why not do a sysctl toggle like in the
> SRv6 case?

The skb flag *is* technically feasible.  I amended the patches with
the flag and was going to post them this week, but Pablo beat me to
the punch and posted his alternative version, which lacks the flag
but modularizes netfilter ingress/egress processing instead.

Honestly I think a hodge-podge of config options and sysctl toggles
is awful and I would prefer the skb flag you suggested.  I kind of
like your idea of considering tc and netfilter as layers.

FWIW the finished patches *with* the flag are on this branch:
https://github.com/l1k/linux/commits/nft_egress_v5

Below is the "git range-diff" between Pablo's patches and mine
(just the hunks which pertain to the skb flag, plus excerpts
from the commit message).

Would you find the patch set acceptable with this skb flag?

-- >8 --

    +    Alternatively or in addition to netfilter, packets can be classified
    +    with traffic control (tc).  On ingress, packets are classified first by
    +    tc, then by netfilter.  On egress, the order is reversed for symmetry.
    +    Conceptually, tc and netfilter can be thought of as layers, with
    +    netfilter layered above tc.
     
    +    Traffic control is capable of redirecting packets to another interface
    +    (man 8 tc-mirred).  E.g., an ingress packet may be redirected from the
    +    host namespace to a container via a veth connection:
    +    tc ingress (host) -> tc egress (veth host) -> tc ingress (veth container)
     
    +    In this case, netfilter egress classifying is not performed when leaving
    +    the host namespace!  That's because the packet is still on the tc layer.
    +    If tc redirects the packet to a physical interface in the host namespace
    +    such that it leaves the system, the packet is never subjected to
    +    netfilter egress classifying.  That is only logical since it hasn't
    +    passed through netfilter ingress classifying either.
     
    +    Packets can alternatively be redirected at the netfilter layer using
    +    nft fwd.  Such a packet *is* subjected to netfilter egress classifying.
    +    Internally, the skb->nf_skip_egress flag controls whether netfilter is
    +    invoked on egress by __dev_queue_xmit().
    +
    +    Interaction between tc and netfilter is possible by setting and querying
    +    skb->mark.
     
    @@ include/linux/netfilter_netdev.h: static inline int nf_hook_ingress(struct sk_bu
     +static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
     +					     struct net_device *dev)
     +{
    -+	struct nf_hook_entries *e = rcu_dereference(dev->nf_hooks_egress);
    ++	struct nf_hook_entries *e;
     +	struct nf_hook_state state;
     +	int ret;
     +
    ++	if (skb->nf_skip_egress)
    ++		return skb;
    ++
    ++	e = rcu_dereference(dev->nf_hooks_egress);
     +	if (!e)
     +		return skb;
     +
    @@ include/linux/netfilter_netdev.h: static inline int nf_hook_ingress(struct sk_bu
     +		return NULL;
     +	}
     +}
    ++
    ++static inline void nf_skip_egress(struct sk_buff *skb, bool skip)
    ++{
    ++	skb->nf_skip_egress = skip;
    ++}
     +#else /* CONFIG_NETFILTER_EGRESS */
     +static inline bool nf_hook_egress_active(void)
     +{
    @@ include/linux/netfilter_netdev.h: static inline int nf_hook_ingress(struct sk_bu
     +{
     +	return skb;
     +}
    ++
    ++static inline void nf_skip_egress(struct sk_buff *skb, bool skip)
    ++{
    ++}
     +#endif /* CONFIG_NETFILTER_EGRESS */
     +
      static inline void nf_hook_netdev_init(struct net_device *dev)
    @@ include/linux/netfilter_netdev.h: static inline int nf_hook_ingress(struct sk_bu
      
      #endif /* _NETFILTER_NETDEV_H_ */
     
    + ## include/linux/skbuff.h ##
    +@@ include/linux/skbuff.h: typedef unsigned char *sk_buff_data_t;
    +  *	@tc_at_ingress: used within tc_classify to distinguish in/egress
    +  *	@redirected: packet was redirected by packet classifier
    +  *	@from_ingress: packet was redirected from the ingress path
    ++ *	@nf_skip_egress: packet shall skip netfilter egress processing
    +  *	@peeked: this packet has been seen already, so stats have been
    +  *		done for it, don't do them again
    +  *	@nf_trace: netfilter packet trace flag
    +@@ include/linux/skbuff.h: struct sk_buff {
    + #ifdef CONFIG_NET_REDIRECT
    + 	__u8			from_ingress:1;
    + #endif
    ++#ifdef CONFIG_NETFILTER_EGRESS
    ++	__u8			nf_skip_egress:1;
    ++#endif
    + #ifdef CONFIG_TLS_DEVICE
    + 	__u8			decrypted:1;
    + #endif
    +
      ## include/uapi/linux/netfilter.h ##
     @@ include/uapi/linux/netfilter.h: enum nf_inet_hooks {
      
    @@ net/core/dev.c: static int __dev_queue_xmit(struct sk_buff *skb, struct net_devi
     +			if (!skb)
     +				goto out;
     +		}
    ++		nf_skip_egress(skb, true);
      		skb = sch_handle_egress(skb, &rc, dev);
      		if (!skb)
      			goto out;
    @@ net/core/dev.c: static int __dev_queue_xmit(struct sk_buff *skb, struct net_devi
      #endif
      	/* If device/qdisc don't need skb->dst, release it right now while
      	 * its hot in this cpu cache.
    +@@ net/core/dev.c: static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
    + 	if (static_branch_unlikely(&ingress_needed_key)) {
    + 		bool another = false;
    + 
    ++		nf_skip_egress(skb, true);
    + 		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev,
    + 					 &another);
    + 		if (another)
    +@@ net/core/dev.c: static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
    + 		if (!skb)
    + 			goto out;
    + 
    ++		nf_skip_egress(skb, false);
    + 		if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
    + 			goto out;
    + 	}

