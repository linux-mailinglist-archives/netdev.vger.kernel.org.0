Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3331A616DC4
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 20:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiKBTWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 15:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbiKBTWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 15:22:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB9B60CB
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 12:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667416898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BZIGDbhI9SaXZELg58ASSUlM68piRi+4RDuH98kRuUY=;
        b=WwiSA//6P4GLFWpkt/FUtDGeBU7xKy5wJIfc4BS6XdWj4iLmEtSGJd2p2L35p8/wDnbs2F
        3TxL1bcIhGq34emtOfEBjlK6ZFnrPmDwYDVTMPN1gxVyCs5fihtg0SAlughM93DXH2Vdk7
        RU3uVSZEGB84wtjaN4xhyU/XBaKI9hw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-51Cuz3JVNFC3ntBjowIrQg-1; Wed, 02 Nov 2022 15:21:34 -0400
X-MC-Unique: 51Cuz3JVNFC3ntBjowIrQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E55CE3C10ED6;
        Wed,  2 Nov 2022 19:21:32 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.34.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6FB81121339;
        Wed,  2 Nov 2022 19:21:28 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCHv3 net-next 1/4] net: move the ct helper function to
 nf_conntrack_helper for ovs and tc
References: <cover.1667230381.git.lucien.xin@gmail.com>
        <77bf40ce177056d460cc7ed32ef4d19d1f7b5290.1667230381.git.lucien.xin@gmail.com>
Date:   Wed, 02 Nov 2022 15:21:27 -0400
In-Reply-To: <77bf40ce177056d460cc7ed32ef4d19d1f7b5290.1667230381.git.lucien.xin@gmail.com>
        (Xin Long's message of "Mon, 31 Oct 2022 11:36:07 -0400")
Message-ID: <f7ttu3hf9hk.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> Move ovs_ct_helper from openvswitch to nf_conntrack_helper and rename
> as nf_ct_helper so that it can be used in TC act_ct in the next patch.
> Note that it also adds the checks for the family and proto, as in TC
> act_ct, the packets with correct family and proto are not guaranteed.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Hi Xin,

>  include/net/netfilter/nf_conntrack_helper.h |  2 +
>  net/netfilter/nf_conntrack_helper.c         | 71 +++++++++++++++++++++
>  net/openvswitch/conntrack.c                 | 61 +-----------------
>  3 files changed, 74 insertions(+), 60 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 9939c366f720..6c32e59fc16f 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -115,6 +115,8 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
>  int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
>  			      gfp_t flags);
>  
> +int nf_ct_helper(struct sk_buff *skb, u16 proto);
> +
>  void nf_ct_helper_destroy(struct nf_conn *ct);
>  
>  static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index ff737a76052e..83615e479f87 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -26,7 +26,9 @@
>  #include <net/netfilter/nf_conntrack_extend.h>
>  #include <net/netfilter/nf_conntrack_helper.h>
>  #include <net/netfilter/nf_conntrack_l4proto.h>
> +#include <net/netfilter/nf_conntrack_seqadj.h>
>  #include <net/netfilter/nf_log.h>
> +#include <net/ip.h>
>  
>  static DEFINE_MUTEX(nf_ct_helper_mutex);
>  struct hlist_head *nf_ct_helper_hash __read_mostly;
> @@ -240,6 +242,75 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
>  }
>  EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
>  
> +/* 'skb' should already be pulled to nh_ofs. */
> +int nf_ct_helper(struct sk_buff *skb, u16 proto)

AFAICT, in all the places we call this we will have the nf_conn and
ip_conntrack_info already.  Maybe it makes sense to pass them here
rather than looking up again?  Originally, that information wasn't
available in the calling function - over time this has been added so we
might as well reduce the amount of "extra lookups" performed.

> +{
> +	const struct nf_conntrack_helper *helper;
> +	const struct nf_conn_help *help;
> +	enum ip_conntrack_info ctinfo;
> +	unsigned int protoff;
> +	struct nf_conn *ct;
> +	int err;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
> +		return NF_ACCEPT;
> +
> +	help = nfct_help(ct);
> +	if (!help)
> +		return NF_ACCEPT;
> +
> +	helper = rcu_dereference(help->helper);
> +	if (!helper)
> +		return NF_ACCEPT;
> +
> +	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
> +	    helper->tuple.src.l3num != proto)
> +		return NF_ACCEPT;
> +
> +	switch (proto) {
> +	case NFPROTO_IPV4:
> +		protoff = ip_hdrlen(skb);
> +		proto = ip_hdr(skb)->protocol;
> +		break;
> +	case NFPROTO_IPV6: {
> +		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> +		__be16 frag_off;
> +		int ofs;
> +
> +		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
> +				       &frag_off);
> +		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
> +			pr_debug("proto header not found\n");
> +			return NF_ACCEPT;
> +		}
> +		protoff = ofs;
> +		proto = nexthdr;
> +		break;
> +	}
> +	default:
> +		WARN_ONCE(1, "helper invoked on non-IP family!");
> +		return NF_DROP;
> +	}
> +
> +	if (helper->tuple.dst.protonum != proto)
> +		return NF_ACCEPT;
> +
> +	err = helper->help(skb, protoff, ct, ctinfo);
> +	if (err != NF_ACCEPT)
> +		return err;
> +
> +	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
> +	 * FTP with NAT) adusting the TCP payload size when mangling IP
> +	 * addresses and/or port numbers in the text-based control connection.
> +	 */
> +	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
> +	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
> +		return NF_DROP;
> +	return NF_ACCEPT;
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_helper);
> +
>  /* appropriate ct lock protecting must be taken by caller */
>  static int unhelp(struct nf_conn *ct, void *me)
>  {
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index c7b10234cf7c..19b5c54615c8 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -434,65 +434,6 @@ static int ovs_ct_set_labels(struct nf_conn *ct, struct sw_flow_key *key,
>  	return 0;
>  }
>  
> -/* 'skb' should already be pulled to nh_ofs. */
> -static int ovs_ct_helper(struct sk_buff *skb, u16 proto)
> -{
> -	const struct nf_conntrack_helper *helper;
> -	const struct nf_conn_help *help;
> -	enum ip_conntrack_info ctinfo;
> -	unsigned int protoff;
> -	struct nf_conn *ct;
> -	int err;
> -
> -	ct = nf_ct_get(skb, &ctinfo);
> -	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
> -		return NF_ACCEPT;
> -
> -	help = nfct_help(ct);
> -	if (!help)
> -		return NF_ACCEPT;
> -
> -	helper = rcu_dereference(help->helper);
> -	if (!helper)
> -		return NF_ACCEPT;
> -
> -	switch (proto) {
> -	case NFPROTO_IPV4:
> -		protoff = ip_hdrlen(skb);
> -		break;
> -	case NFPROTO_IPV6: {
> -		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> -		__be16 frag_off;
> -		int ofs;
> -
> -		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
> -				       &frag_off);
> -		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
> -			pr_debug("proto header not found\n");
> -			return NF_ACCEPT;
> -		}
> -		protoff = ofs;
> -		break;
> -	}
> -	default:
> -		WARN_ONCE(1, "helper invoked on non-IP family!");
> -		return NF_DROP;
> -	}
> -
> -	err = helper->help(skb, protoff, ct, ctinfo);
> -	if (err != NF_ACCEPT)
> -		return err;
> -
> -	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
> -	 * FTP with NAT) adusting the TCP payload size when mangling IP
> -	 * addresses and/or port numbers in the text-based control connection.
> -	 */
> -	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
> -	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
> -		return NF_DROP;
> -	return NF_ACCEPT;
> -}
> -
>  /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
>   * value if 'skb' is freed.
>   */
> @@ -1038,7 +979,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>  		 */
>  		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
>  					      info->commit) &&
> -		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
> +		    nf_ct_helper(skb, info->family) != NF_ACCEPT) {
>  			return -EINVAL;
>  		}

