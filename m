Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08982BB52C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgKTTYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgKTTYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:24:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3D3D221F1;
        Fri, 20 Nov 2020 19:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605900255;
        bh=1ySWsXI4akwGKg1wozybUmYAan1gNyg3JwG/8oblkJ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iXVMFFzxc4Vghl8JF8YYfCJekVLfeOnKtSo04Jq5eTrpYOubpYFLqZ4YfiSEYuC1l
         HerRwcwofvl5hqDbEj4CZWOj8eaqkXvAt0WuawKlKONvnUL4/3uYIwiQnlPZenbbzv
         eV8k2JOmzc7CmI4+p2o4w5Eal3Vm34hKTFLkF7SI=
Date:   Fri, 20 Nov 2020 11:24:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        gnault@redhat.com, marcelo.leitner@gmail.com
Subject: Re: [PATCH net] net/sched: act_mpls: ensure LSE is pullable before
 reading it
Message-ID: <20201120112413.00f42728@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e14a44135817430fc69b3c624895f8584a560975.1605716949.git.dcaratti@redhat.com>
References: <e14a44135817430fc69b3c624895f8584a560975.1605716949.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 17:36:52 +0100 Davide Caratti wrote:
> when 'act_mpls' is used to mangle the LSE, the current value is read from
> the packet with mpls_hdr(): ensure that the label is contained in the skb
> "linear" area.
> 
> Found by code inspection.
> 
> Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/sched/act_mpls.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> index 5c7456e5b5cf..03138ad59e9b 100644
> --- a/net/sched/act_mpls.c
> +++ b/net/sched/act_mpls.c
> @@ -105,6 +105,9 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
>  			goto drop;
>  		break;
>  	case TCA_MPLS_ACT_MODIFY:
> +		if (!pskb_may_pull(skb,
> +				   skb_network_offset(skb) + sizeof(new_lse)))

nit: MPLS_HLEN?

> +			goto drop;
>  		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
>  		if (skb_mpls_update_lse(skb, new_lse))
>  			goto drop;

