Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1754BA210
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241487AbiBQNzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 08:55:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbiBQNzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:55:46 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC408273753;
        Thu, 17 Feb 2022 05:55:31 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0B4806019B;
        Thu, 17 Feb 2022 14:54:49 +0100 (CET)
Date:   Thu, 17 Feb 2022 14:55:27 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, coreteam@netfilter.org
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup failure
 with no originating ifindex
Message-ID: <Yg5Tz5ucVAI3zOTs@salvia>
References: <20220217093424.23601-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220217093424.23601-1-paulb@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 11:34:24AM +0200, Paul Blakey wrote:
> After cited commit optimizted hw insertion, flow table entries are
> populated with ifindex information which was intended to only be used
> for HW offload. This tuple ifindex is hashed in the flow table key, so
> it must be filled for lookup to be successful. But tuple ifindex is only
> relevant for the netfilter flowtables (nft), so it's not filled in
> act_ct flow table lookup, resulting in lookup failure, and no SW
> offload and no offload teardown for TCP connection FIN/RST packets.
> 
> To fix this, allow flow tables that don't hash the ifindex.
> Netfilter flow tables will keep using ifindex for a more specific
> offload, while act_ct will not.

Using iif == zero should be enough to specify not set?

> Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tupledx")
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
>  include/net/netfilter/nf_flow_table.h | 8 ++++----
>  net/netfilter/nf_flow_table_core.c    | 6 ++++++
>  net/sched/act_ct.c                    | 3 ++-
>  3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index a3647fadf1cc..9b474414a936 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -64,8 +64,9 @@ struct nf_flowtable_type {
>  };
>  
>  enum nf_flowtable_flags {
> -	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
> -	NF_FLOWTABLE_COUNTER		= 0x2,	/* NFT_FLOWTABLE_COUNTER */
> +	NF_FLOWTABLE_HW_OFFLOAD			= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
> +	NF_FLOWTABLE_COUNTER			= 0x2,	/* NFT_FLOWTABLE_COUNTER */
> +	NF_FLOWTABLE_NO_IFINDEX_FILTERING	= 0x4,	/* Only used by act_ct */
>  };
>  
>  struct nf_flowtable {
> @@ -114,8 +115,6 @@ struct flow_offload_tuple {
>  		__be16			dst_port;
>  	};
>  
> -	int				iifidx;
> -
>  	u8				l3proto;
>  	u8				l4proto;
>  	struct {
> @@ -126,6 +125,7 @@ struct flow_offload_tuple {
>  	/* All members above are keys for lookups, see flow_offload_hash(). */
>  	struct { }			__hash;
>  
> +	int				iifidx;
>  	u8				dir:2,
>  					xmit_type:2,
>  					encap_num:2,
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index b90eca7a2f22..f0cb2c7075c0 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -254,9 +254,15 @@ static u32 flow_offload_hash_obj(const void *data, u32 len, u32 seed)
>  static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
>  					const void *ptr)
>  {
> +	const struct nf_flowtable *flow_table = container_of(arg->ht, struct nf_flowtable,
> +							     rhashtable);
>  	const struct flow_offload_tuple *tuple = arg->key;
>  	const struct flow_offload_tuple_rhash *x = ptr;
>  
> +	if (!(flow_table->flags & NF_FLOWTABLE_NO_IFINDEX_FILTERING) &&
> +	    x->tuple.iifidx != tuple->iifidx)
> +		return 1;
> +
>  	if (memcmp(&x->tuple, tuple, offsetof(struct flow_offload_tuple, __hash)))
>  		return 1;
>  
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index f99247fc6468..22cd32ec9889 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -305,7 +305,8 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>  
>  	ct_ft->nf_ft.type = &flowtable_ct;
>  	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
> -			      NF_FLOWTABLE_COUNTER;
> +			      NF_FLOWTABLE_COUNTER |
> +			      NF_FLOWTABLE_NO_IFINDEX_FILTERING;
>  	err = nf_flow_table_init(&ct_ft->nf_ft);
>  	if (err)
>  		goto err_init;
> -- 
> 2.30.1
> 
