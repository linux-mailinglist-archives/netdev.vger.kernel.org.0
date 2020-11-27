Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FD42C5EDF
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 04:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392301AbgK0DJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 22:09:23 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:26425 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731451AbgK0DJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 22:09:23 -0500
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 5835F5C1C6F;
        Fri, 27 Nov 2020 10:58:00 +0800 (CST)
Subject: Re: [PATCH net-next] net/sched: act_ct: enable stats for HW offloaded
 entries
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org
Cc:     paulb@nvidia.com, ozsh@nvidia.com, ahleihel@nvidia.com,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <94632068-adc5-c803-6176-7562d0ab7451@ucloud.cn>
Date:   Fri, 27 Nov 2020 10:57:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZS0xMTEwfQh0eQk0eVkpNS01PT05DQ0tNSExVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pi46Mgw6Iz0*CDABCxUoAj0t
        Hk8KFBVVSlVKTUtNT09OQ0NLQklDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFISUNJNwY+
X-HM-Tid: 0a7607a2d4fc2087kuqy5835f5c1c6f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/27/2020 2:40 AM, Marcelo Ricardo Leitner wrote:
> By setting NF_FLOWTABLE_COUNTER. Otherwise, the updates added by
> commit ef803b3cf96a ("netfilter: flowtable: add counter support in HW
> offload") are not effective when using act_ct.
>
> While at it, now that we have the flag set, protect the call to
> nf_ct_acct_update() by commit beb97d3a3192 ("net/sched: act_ct: update
> nf_conn_acct for act_ct SW offload in flowtable") with the check on
> NF_FLOWTABLE_COUNTER, as also done on other places.
>
> Note that this shouldn't impact performance as these stats are only
> enabled when net.netfilter.nf_conntrack_acct is enabled.
>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sched/act_ct.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index aba3cd85f284f3e49add31fe65e3b791f2386fa1..bb1ef3b8e77fb6fd6a74b88a65322baea2dc1ed5 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -296,7 +296,8 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>  		goto err_insert;
>  
>  	ct_ft->nf_ft.type = &flowtable_ct;
> -	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD;
> +	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
> +			      NF_FLOWTABLE_COUNTER;
>  	err = nf_flow_table_init(&ct_ft->nf_ft);
>  	if (err)
>  		goto err_init;
> @@ -540,7 +541,8 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
>  	flow_offload_refresh(nf_ft, flow);
>  	nf_conntrack_get(&ct->ct_general);
>  	nf_ct_set(skb, ct, ctinfo);
> -	nf_ct_acct_update(ct, dir, skb->len);
> +	if (nf_ft->flags & NF_FLOWTABLE_COUNTER)
> +		nf_ct_acct_update(ct, dir, skb->len);
>  
>  	return true;
>  }


Acked-by: wenxu <wenxu@ucloud.cn>


BR

wenxu

