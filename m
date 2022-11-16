Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2444B62CD32
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiKPVye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiKPVyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:54:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D7F22CE1E
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 13:54:32 -0800 (PST)
Date:   Wed, 16 Nov 2022 22:54:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net-next 5/5] net: move the nat function to nf_nat_core
 for ovs and tc
Message-ID: <Y3VcEiOlB5OG0XFS@salvia>
References: <cover.1668527318.git.lucien.xin@gmail.com>
 <488fbfa082eb8a0ab81622a7c13c26b6fd8a0602.1668527318.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <488fbfa082eb8a0ab81622a7c13c26b6fd8a0602.1668527318.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:50:57AM -0500, Xin Long wrote:
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index e29e4ccb5c5a..1c72b8caa24e 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -784,6 +784,137 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_inet_fn);
>  
> +/* Modelled after nf_nat_ipv[46]_fn().
> + * range is only used for new, uninitialized NAT state.
> + * Returns either NF_ACCEPT or NF_DROP.
> + */
> +static int nf_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
> +			     enum ip_conntrack_info ctinfo, int *action,
> +			     const struct nf_nat_range2 *range,
> +			     enum nf_nat_manip_type maniptype)
> +{
> +	__be16 proto = skb_protocol(skb, true);
> +	int hooknum, err = NF_ACCEPT;
> +
> +	/* See HOOK2MANIP(). */
> +	if (maniptype == NF_NAT_MANIP_SRC)
> +		hooknum = NF_INET_LOCAL_IN; /* Source NAT */
> +	else
> +		hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
> +
> +	switch (ctinfo) {
> +	case IP_CT_RELATED:
> +	case IP_CT_RELATED_REPLY:
> +		if (proto == htons(ETH_P_IP) &&
> +		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> +			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
> +							   hooknum))
> +				err = NF_DROP;
> +			goto out;
> +		} else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
> +			__be16 frag_off;
> +			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> +			int hdrlen = ipv6_skip_exthdr(skb,
> +						      sizeof(struct ipv6hdr),
> +						      &nexthdr, &frag_off);
> +
> +			if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> +				if (!nf_nat_icmpv6_reply_translation(skb, ct,
> +								     ctinfo,
> +								     hooknum,
> +								     hdrlen))
> +					err = NF_DROP;
> +				goto out;
> +			}
> +		}
> +		/* Non-ICMP, fall thru to initialize if needed. */
> +		fallthrough;
> +	case IP_CT_NEW:
> +		/* Seen it before?  This can happen for loopback, retrans,
> +		 * or local packets.
> +		 */
> +		if (!nf_nat_initialized(ct, maniptype)) {
> +			/* Initialize according to the NAT action. */
> +			err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
> +				/* Action is set up to establish a new
> +				 * mapping.
> +				 */
> +				? nf_nat_setup_info(ct, range, maniptype)
> +				: nf_nat_alloc_null_binding(ct, hooknum);
> +			if (err != NF_ACCEPT)
> +				goto out;
> +		}
> +		break;
> +
> +	case IP_CT_ESTABLISHED:
> +	case IP_CT_ESTABLISHED_REPLY:
> +		break;
> +
> +	default:
> +		err = NF_DROP;
> +		goto out;
> +	}
> +
> +	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> +	if (err == NF_ACCEPT)
> +		*action |= (1 << maniptype);
> +out:
> +	return err;
> +}
> +
> +int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
> +	      enum ip_conntrack_info ctinfo, int *action,
> +	      const struct nf_nat_range2 *range, bool commit)
> +{
> +	enum nf_nat_manip_type maniptype;
> +	int err, ct_action = *action;
> +
> +	*action = 0;
> +
> +	/* Add NAT extension if not confirmed yet. */
> +	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> +		return NF_ACCEPT;   /* Can't NAT. */
> +
> +	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> +	    (ctinfo != IP_CT_RELATED || commit)) {
> +		/* NAT an established or related connection like before. */
> +		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> +			/* This is the REPLY direction for a connection
> +			 * for which NAT was applied in the forward
> +			 * direction.  Do the reverse NAT.
> +			 */
> +			maniptype = ct->status & IPS_SRC_NAT
> +				? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> +		else
> +			maniptype = ct->status & IPS_SRC_NAT
> +				? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> +	} else if (ct_action & (1 << NF_NAT_MANIP_SRC)) {
> +		maniptype = NF_NAT_MANIP_SRC;
> +	} else if (ct_action & (1 << NF_NAT_MANIP_DST)) {
> +		maniptype = NF_NAT_MANIP_DST;
> +	} else {
> +		return NF_ACCEPT;
> +	}
> +
> +	err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
> +	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> +		if (ct->status & IPS_SRC_NAT) {
> +			if (maniptype == NF_NAT_MANIP_SRC)
> +				maniptype = NF_NAT_MANIP_DST;
> +			else
> +				maniptype = NF_NAT_MANIP_SRC;
> +
> +			err = nf_ct_nat_execute(skb, ct, ctinfo, action, range,
> +						maniptype);
> +		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> +			err = nf_ct_nat_execute(skb, ct, ctinfo, action, NULL,
> +						NF_NAT_MANIP_SRC);
> +		}
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_nat);

I'd suggest you move this code to nf_nat_ovs.c or such so we remember
these symbols are used by act_ct.c and ovs.
