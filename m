Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3813741F4
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhEEQmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:42:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234584AbhEEQku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 12:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620232793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bVHcdV+QfuIXFPGC7MpOh1cBl4GamW8QEqmRJjVFYdg=;
        b=dUK05Z9Gq6IJk1hzYqn6vLG85RCp/h2Dx4KrWAN1d3953/8REyYSvvouyHCbfXk4YIM0Mg
        3jQvKTqcqywc+UfpiI9Z3Qv3O/pA82egWczGfsbKxUeH3f6J7FnxYSyyRnso8OzOG6BPBT
        GZn/3BN8YsEKOMe33vGKLlQKOGbyCfs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-r4Uj3j8GPIaabh8v6bJDRw-1; Wed, 05 May 2021 12:39:51 -0400
X-MC-Unique: r4Uj3j8GPIaabh8v6bJDRw-1
Received: by mail-pl1-f198.google.com with SMTP id t3-20020a170902e843b02900eec200979aso968579plg.9
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 09:39:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=bVHcdV+QfuIXFPGC7MpOh1cBl4GamW8QEqmRJjVFYdg=;
        b=eH6tVgcFjx5bEALkZKzrfyPH2wKSx5vZT1gzIm9OxA6CUExPtu6AK65CFF1ZulWqAs
         WO2oiUmDWcJvUHvozwnzxC2RIOObItQeY+WBp6fwsSqt6V5IDlGp278OMLr5clMOQh0h
         yQ74ZRn18ARyiA0kClMbQgJCm2Wn02du4BFS+5yG1a6Amzh9Dez7n5Mg5kdwYhE6DXc5
         mefDdpTP0Qt1xuDLIpwim+n7RJYk3O73Xq3CBvt8P9ROtTq//GQ5OQN84yPJUu3s/+kv
         nGymTH28k7cZmH7O8BpcNjskn8fsBb89pfVODA5x1MvAe0YCJ/3+tNA5AC8Ceg8hFwE9
         R2qA==
X-Gm-Message-State: AOAM531TGS0p3uWCT5vP9Fmbtn9gfPoiS1AUhYInuQdqvu3PeBSn5m53
        qRt9HhN4UJJ59xS8S2y2n8Xtyn91sIUZaz07FH3aAuhqN0gZMgadbEQSVp7pmNURNU1a/dT1xnY
        cIeJkkpU5jvljQe6+dBUH1hMIT/9/dJjP
X-Received: by 2002:a17:902:ecce:b029:ee:cf77:3b22 with SMTP id a14-20020a170902ecceb02900eecf773b22mr19028206plh.46.1620232785906;
        Wed, 05 May 2021 09:39:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwgl4+P8hfY/hFF5TtyOGgll0QKd8gaXaBzeDky7jWtWwjBkE5+S32pJC2o4fmdcltU2MGyaCPagRSbqBCYFw=
X-Received: by 2002:a17:902:ecce:b029:ee:cf77:3b22 with SMTP id
 a14-20020a170902ecceb02900eecf773b22mr19028188plh.46.1620232785647; Wed, 05
 May 2021 09:39:45 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 5 May 2021 09:39:45 -0700
From:   mleitner@redhat.com
References: <1620212166-29031-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1620212166-29031-1-git-send-email-paulb@nvidia.com>
Date:   Wed, 5 May 2021 09:39:45 -0700
Message-ID: <CALnP8ZZVfAFFZctpSayzH2yTUZD3obAxCT4Z2r+WDY=RcacM_Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: act_ct: Offload connections with
 commit action
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 01:56:06PM +0300, Paul Blakey wrote:
> Currently established connections are not offloaded if the filter has a
> "ct commit" action. This behavior will not offload connections of the
> following scenario:
>
> $ tc_filter add dev $DEV ingress protocol ip prio 1 flower \
>   ct_state -trk \
>   action ct commit action goto chain 1
>
> $ tc_filter add dev $DEV ingress protocol ip chain 1 prio 1 flower \
>   action mirred egress redirect dev $DEV2
>
> $ tc_filter add dev $DEV2 ingress protocol ip prio 1 flower \
>   action ct commit action goto chain 1
>
> $ tc_filter add dev $DEV2 ingress protocol ip prio 1 chain 1 flower \
>   ct_state +trk+est \
>   action mirred egress redirect dev $DEV
>
> Offload established connections, regardless of the commit flag.
>
> Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
>  net/sched/act_ct.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index ec7a1c438df9..b1473a1aecdd 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -984,7 +984,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	 */
>  	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
>  	if (!cached) {
> -		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
> +		if (tcf_ct_flow_table_lookup(p, skb, family)) {

Took me a while to realize that a zone check is not needed here
because when committing to a different zone it will check the new
flowtable here already. Otherwise, for commits, the zone update was
enforced in the few lines below.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

>  			skip_add = true;
>  			goto do_nat;
>  		}
> @@ -1022,10 +1022,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  		 * even if the connection is already confirmed.
>  		 */
>  		nf_conntrack_confirm(skb);
> -	} else if (!skip_add) {
> -		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>  	}
>
> +	if (!skip_add)
> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
> +
>  out_push:
>  	skb_push_rcsum(skb, nh_ofs);
>
> --
> 2.30.1
>

