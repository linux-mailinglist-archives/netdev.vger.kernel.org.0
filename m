Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1374310153
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhBEAHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:07:23 -0500
Received: from www62.your-server.de ([213.133.104.62]:60740 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhBEAHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 19:07:21 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l7odw-000208-RC; Fri, 05 Feb 2021 01:06:36 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l7odw-000LFw-IN; Fri, 05 Feb 2021 01:06:36 +0100
Subject: Re: [PATCH bpf-next V15 2/7] bpf: fix bpf_fib_lookup helper MTU check
 for SKB ctx
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <161228314075.576669.15427172810948915572.stgit@firesoul>
 <161228321177.576669.11521750082473556168.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ada19e5b-87be-ff39-45ba-ff0025bf1de9@iogearbox.net>
Date:   Fri, 5 Feb 2021 01:06:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <161228321177.576669.11521750082473556168.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26070/Thu Feb  4 13:22:39 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 5:26 PM, Jesper Dangaard Brouer wrote:
> BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
> bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
> by adjusting fib_params 'tot_len' with the packet length plus the expected
> encap size. (Just like the bpf_check_mtu helper supports). He discovered
> that for SKB ctx the param->tot_len was not used, instead skb->len was used
> (via MTU check in is_skb_forwardable() that checks against netdev MTU).
> 
> Fix this by using fib_params 'tot_len' for MTU check. If not provided (e.g.
> zero) then keep existing TC behaviour intact. Notice that 'tot_len' for MTU
> check is done like XDP code-path, which checks against FIB-dst MTU.
> 
> V13:
> - Only do ifindex lookup one time, calling dev_get_by_index_rcu().
> 
> V10:
> - Use same method as XDP for 'tot_len' MTU check
> 
> Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
> Reported-by: Carlo Carraro <colrack@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
[...]

I was about to apply the series just now, but on a last double check there is
a subtle logic bug in here that still needs fixing unfortunately. :/ See below:

> @@ -5568,7 +5565,9 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>   	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
>   {
>   	struct net *net = dev_net(skb->dev);
> +	struct net_device *dev;
>   	int rc = -EAFNOSUPPORT;
> +	bool check_mtu = false;
>   
>   	if (plen < sizeof(*params))
>   		return -EINVAL;
> @@ -5576,23 +5575,30 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>   	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
>   		return -EINVAL;
>   
> +	dev = dev_get_by_index_rcu(net, params->ifindex);
> +	if (unlikely(!dev))
> +		return -ENODEV;

Based on your earlier idea, you try to avoid refetching the dev this way, so
here it's being looked up via params->ifindex provided from the BPF prog ...

> +	if (params->tot_len)
> +		check_mtu = true;
> +
>   	switch (params->family) {
>   #if IS_ENABLED(CONFIG_INET)
>   	case AF_INET:
> -		rc = bpf_ipv4_fib_lookup(net, params, flags, false);
> +		rc = bpf_ipv4_fib_lookup(net, dev, params, flags, check_mtu);

... however, bpf_ipv{4,6}_fib_lookup() might change params->ifindex here to
indicate nexthop output dev:

[...]
         dev = nhc->nhc_dev;

         params->rt_metric = res.fi->fib_priority;
         params->ifindex = dev->ifindex;
[...]

>   		break;
>   #endif
>   #if IS_ENABLED(CONFIG_IPV6)
>   	case AF_INET6:
> -		rc = bpf_ipv6_fib_lookup(net, params, flags, false);
> +		rc = bpf_ipv6_fib_lookup(net, dev, params, flags, check_mtu);
>   		break;
>   #endif
>   	}
>   
> -	if (!rc) {
> -		struct net_device *dev;
> -
> -		dev = dev_get_by_index_rcu(net, params->ifindex);
> +	if (rc == BPF_FIB_LKUP_RET_SUCCESS && !check_mtu) {
> +		/* When tot_len isn't provided by user,
> +		 * check skb against net_device MTU
> +		 */
>   		if (!is_skb_forwardable(dev, skb))
>   			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;

... so using old cached dev from above will result in wrong MTU check &
subsequent passing of wrong params->mtu_result = dev->mtu this way. So one
way to fix is that we would need to pass &dev to bpf_ipv{4,6}_fib_lookup().

>   	}
> 
> 

Thanks,
Daniel
