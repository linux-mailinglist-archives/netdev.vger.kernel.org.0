Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0AE7B35E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbfG3TaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:30:14 -0400
Received: from ja.ssi.bg ([178.16.129.10]:55932 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728677AbfG3TaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 15:30:14 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x6UJTQ1u006069;
        Tue, 30 Jul 2019 22:29:27 +0300
Date:   Tue, 30 Jul 2019 22:29:26 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     hujunwei <hujunwei4@huawei.com>
cc:     wensong@linux-vs.org, horms@verge.net.au, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, Florian Westphal <fw@strlen.de>,
        davem@davemloft.net, Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Mingfangsen <mingfangsen@huawei.com>,
        wangxiaogang3@huawei.com, xuhanbing@huawei.com
Subject: Re: [PATCH net v2] ipvs: Improve robustness to the ipvs sysctl
In-Reply-To: <4a0476d3-57a4-50e0-cae8-9dffc4f4d556@huawei.com>
Message-ID: <alpine.LFD.2.21.1907302226340.4897@ja.home.ssi.bg>
References: <1997375e-815d-137f-20c9-0829a8587ee9@huawei.com> <4a0476d3-57a4-50e0-cae8-9dffc4f4d556@huawei.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 30 Jul 2019, hujunwei wrote:

> From: Junwei Hu <hujunwei4@huawei.com>
> 
> The ipvs module parse the user buffer and save it to sysctl,
> then check if the value is valid. invalid value occurs
> over a period of time.
> Here, I add a variable, struct ctl_table tmp, used to read
> the value from the user buffer, and save only when it is valid.
> I delete proc_do_sync_mode and use extra1/2 in table for the
> proc_dointvec_minmax call.
> 
> Fixes: f73181c8288f ("ipvs: add support for sync threads")
> Signed-off-by: Junwei Hu <hujunwei4@huawei.com>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

	BTW, why ip_vs_zero_all everywhere? Due to old git version?

> ---
> V1->V2:
> - delete proc_do_sync_mode and use proc_dointvec_minmax call.
> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 69 +++++++++++++++++++++---------------------
>  1 file changed, 35 insertions(+), 34 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 060565e..7aed7b0 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1737,12 +1737,18 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
>  	int val = *valp;
>  	int rc;
> 
> -	rc = proc_dointvec(table, write, buffer, lenp, ppos);
> +	struct ctl_table tmp = {
> +		.data = &val,
> +		.maxlen = sizeof(int),
> +		.mode = table->mode,
> +	};
> +
> +	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
>  	if (write && (*valp != val)) {
> -		if ((*valp < 0) || (*valp > 3)) {
> -			/* Restore the correct value */
> +		if (val < 0 || val > 3) {
> +			rc = -EINVAL;
> +		} else {
>  			*valp = val;
> -		} else {
>  			update_defense_level(ipvs);
>  		}
>  	}
> @@ -1756,33 +1762,20 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
>  	int *valp = table->data;
>  	int val[2];
>  	int rc;
> +	struct ctl_table tmp = {
> +		.data = &val,
> +		.maxlen = table->maxlen,
> +		.mode = table->mode,
> +	};
> 
> -	/* backup the value first */
>  	memcpy(val, valp, sizeof(val));
> -
> -	rc = proc_dointvec(table, write, buffer, lenp, ppos);
> -	if (write && (valp[0] < 0 || valp[1] < 0 ||
> -	    (valp[0] >= valp[1] && valp[1]))) {
> -		/* Restore the correct value */
> -		memcpy(valp, val, sizeof(val));
> -	}
> -	return rc;
> -}
> -
> -static int
> -proc_do_sync_mode(struct ctl_table *table, int write,
> -		     void __user *buffer, size_t *lenp, loff_t *ppos)
> -{
> -	int *valp = table->data;
> -	int val = *valp;
> -	int rc;
> -
> -	rc = proc_dointvec(table, write, buffer, lenp, ppos);
> -	if (write && (*valp != val)) {
> -		if ((*valp < 0) || (*valp > 1)) {
> -			/* Restore the correct value */
> -			*valp = val;
> -		}
> +	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
> +	if (write) {
> +		if (val[0] < 0 || val[1] < 0 ||
> +		    (val[0] >= val[1] && val[1]))
> +			rc = -EINVAL;
> +		else
> +			memcpy(valp, val, sizeof(val));
>  	}
>  	return rc;
>  }
> @@ -1795,12 +1788,18 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
>  	int val = *valp;
>  	int rc;
> 
> -	rc = proc_dointvec(table, write, buffer, lenp, ppos);
> +	struct ctl_table tmp = {
> +		.data = &val,
> +		.maxlen = sizeof(int),
> +		.mode = table->mode,
> +	};
> +
> +	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
>  	if (write && (*valp != val)) {
> -		if (*valp < 1 || !is_power_of_2(*valp)) {
> -			/* Restore the correct value */
> +		if (val < 1 || !is_power_of_2(val))
> +			rc = -EINVAL;
> +		else
>  			*valp = val;
> -		}
>  	}
>  	return rc;
>  }
> @@ -1860,7 +1859,9 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
>  		.procname	= "sync_version",
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_do_sync_mode,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_ONE,
>  	},
>  	{
>  		.procname	= "sync_ports",
> -- 
> 1.7.12.4

Regards

--
Julian Anastasov <ja@ssi.bg>
