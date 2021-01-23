Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93630121C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbhAWBsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:48:13 -0500
Received: from www62.your-server.de ([213.133.104.62]:33102 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbhAWBsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 20:48:11 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l381R-0004qy-Iu; Sat, 23 Jan 2021 02:47:29 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l381R-000XKL-8p; Sat, 23 Jan 2021 02:47:29 +0100
Subject: Re: [PATCH bpf-next V12 2/7] bpf: fix bpf_fib_lookup helper MTU check
 for SKB ctx
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <161098881526.108067.7603213364270807261.stgit@firesoul>
 <161098885996.108067.14467274374916086727.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <06f94963-f16b-3339-abf2-6529b474a2f6@iogearbox.net>
Date:   Sat, 23 Jan 2021 02:47:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <161098885996.108067.14467274374916086727.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26057/Fri Jan 22 13:30:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 5:54 PM, Jesper Dangaard Brouer wrote:
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
> V10:
> - Use same method as XDP for 'tot_len' MTU check
> 
> Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
> Reported-by: Carlo Carraro <colrack@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   net/core/filter.c |   13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5beadd659091..d5e6f395cf64 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5569,6 +5569,7 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>   {
>   	struct net *net = dev_net(skb->dev);
>   	int rc = -EAFNOSUPPORT;
> +	bool check_mtu = false;
>   
>   	if (plen < sizeof(*params))
>   		return -EINVAL;
> @@ -5576,22 +5577,28 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>   	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
>   		return -EINVAL;
>   
> +	if (params->tot_len)
> +		check_mtu = true;
> +
>   	switch (params->family) {
>   #if IS_ENABLED(CONFIG_INET)
>   	case AF_INET:
> -		rc = bpf_ipv4_fib_lookup(net, params, flags, false);
> +		rc = bpf_ipv4_fib_lookup(net, params, flags, check_mtu);
>   		break;
>   #endif
>   #if IS_ENABLED(CONFIG_IPV6)
>   	case AF_INET6:
> -		rc = bpf_ipv6_fib_lookup(net, params, flags, false);
> +		rc = bpf_ipv6_fib_lookup(net, params, flags, check_mtu);
>   		break;
>   #endif
>   	}
>   
> -	if (!rc) {
> +	if (rc == BPF_FIB_LKUP_RET_SUCCESS && !check_mtu) {
>   		struct net_device *dev;
>   
> +		/* When tot_len isn't provided by user,
> +		 * check skb against net_device MTU
> +		 */
>   		dev = dev_get_by_index_rcu(net, params->ifindex);
>   		if (!is_skb_forwardable(dev, skb))
>   			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;

Btw, looking at some of the old feedback, looks like [0] got missed somehow. Would
be nice if we could simplify this rather ugly bit with refetching dev for tc.

   [0] https://lore.kernel.org/bpf/f959017b-5d3c-5cdb-a016-c467a3c9a2fc@iogearbox.net/
       https://lore.kernel.org/bpf/f8ff26f0-b1b6-6dd1-738d-4c592a8efdb0@gmail.com/
