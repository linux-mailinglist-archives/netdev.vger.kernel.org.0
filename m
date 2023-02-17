Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4E769B018
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBQQAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjBQQAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:00:48 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D604553EE9;
        Fri, 17 Feb 2023 08:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=TD/a4E0ry0yHp6CnCA73l03dkLjoV7YAC0/qw9WCwbo=; b=N/E+Zo035RXoAOladyHaDfvHfi
        2DoE5azOJsZ/iqRsbPYhQZKCrvjUzwOMt0n0kHa9BKeukD8V5syWGqQSGJBvPhCRX8h8fY4JgJLdr
        Ljd5aOoY2VCxm/9gjY/11wIbh+G2ci3Fs/t12EjzG/K3ZaRW8meqPmpQTr3057OjJmZbBtRpSKgvM
        8d4N4RW6Qkvg33vjy4lul7GDkgDNV9ga7sdizwnvNSppX2st/DAlUO2/Haj1ua/+yvdJvEGmdYk5K
        L3T3Nn3SmCASwdz0c+5BzBPjKncqIQ+mXzgREDmzc2CZHkCJzTkIwbjz+W2QJmKlYSIA7jtSeyBV0
        /ek50vBw==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT3A8-000FCp-1M; Fri, 17 Feb 2023 17:00:40 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT3A7-000DQY-PN; Fri, 17 Feb 2023 17:00:39 +0100
Subject: Re: [PATCH bpf-next 3/4] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for
 bpf_fib_lookup
To:     Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        netdev@vger.kernel.org, kernel-team@meta.com
References: <20230217004150.2980689-1-martin.lau@linux.dev>
 <20230217004150.2980689-4-martin.lau@linux.dev>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dd4e2b92-53c9-6973-86ff-8cb04913c3ca@iogearbox.net>
Date:   Fri, 17 Feb 2023 17:00:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230217004150.2980689-4-martin.lau@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26815/Fri Feb 17 09:41:01 2023)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 1:41 AM, Martin KaFai Lau wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> The bpf_fib_lookup() also looks up the neigh table.
> This was done before bpf_redirect_neigh() was added.
> 
> In the use case that does not manage the neigh table
> and requires bpf_fib_lookup() to lookup a fib to
> decide if it needs to redirect or not, the bpf prog can
> depend only on using bpf_redirect_neigh() to lookup the
> neigh. It also keeps the neigh entries fresh and connected.
> 
> This patch adds a bpf_fib_lookup flag, SKIP_NEIGH, to avoid
> the double neigh lookup when the bpf prog always call
> bpf_redirect_neigh() to do the neigh lookup.
> 
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> ---
>   include/uapi/linux/bpf.h       |  1 +
>   net/core/filter.c              | 33 +++++++++++++++++++++++----------
>   tools/include/uapi/linux/bpf.h |  1 +
>   3 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 1503f61336b6..6c1956e36c97 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
[...]
> @@ -5838,21 +5836,28 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   	if (likely(nhc->nhc_gw_family != AF_INET6)) {
>   		if (nhc->nhc_gw_family)
>   			params->ipv4_dst = nhc->nhc_gw.ipv4;
> -
> -		neigh = __ipv4_neigh_lookup_noref(dev,
> -						 (__force u32)params->ipv4_dst);
>   	} else {
>   		struct in6_addr *dst = (struct in6_addr *)params->ipv6_dst;
>   
>   		params->family = AF_INET6;
>   		*dst = nhc->nhc_gw.ipv6;
> -		neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
>   	}
>   
> +	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
> +		goto set_fwd_params;
> +
> +	if (params->family == AF_INET6)

Nit, would have probably more intuitive to keep the same test also here
(nhc->nhc_gw_family != AF_INET6), but either way, lgtm.

Are you still required to fill the params->smac in bpf_fib_set_fwd_params()
in that case, meaning, shouldn't bpf_redirect_neigh() take care of it as well
from neigh_output()? Looks unnecessary and could be moved out too.

(Took in first 2 in the meantime which look good.)

> +		neigh = __ipv6_neigh_lookup_noref_stub(dev, params->ipv6_dst);
> +	else
> +		neigh = __ipv4_neigh_lookup_noref(dev,
> +						  (__force u32)params->ipv4_dst);
> +
>   	if (!neigh || !(neigh->nud_state & NUD_VALID))
>   		return BPF_FIB_LKUP_RET_NO_NEIGH;
> +	memcpy(params->dmac, neigh->ha, ETH_ALEN);
>   
> -	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
> +set_fwd_params:
> +	return bpf_fib_set_fwd_params(params, dev, mtu);
