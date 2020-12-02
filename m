Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520212CC94A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgLBWAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:00:48 -0500
Received: from www62.your-server.de ([213.133.104.62]:40598 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLBWAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:00:47 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkaAP-0004cQ-CV; Wed, 02 Dec 2020 23:00:05 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkaAP-0002Fq-3M; Wed, 02 Dec 2020 23:00:05 +0100
Subject: Re: [PATCH bpf-next V7 2/8] bpf: fix bpf_fib_lookup helper MTU check
 for SKB ctx
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <160588903254.2817268.4861837335793475314.stgit@firesoul>
 <160588909693.2817268.17116187979657760922.stgit@firesoul>
 <6f9cac4e-a231-ff8d-43a5-828995ca5ec7@iogearbox.net>
Message-ID: <f959017b-5d3c-5cdb-a016-c467a3c9a2fc@iogearbox.net>
Date:   Wed, 2 Dec 2020 23:00:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6f9cac4e-a231-ff8d-43a5-828995ca5ec7@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26006/Wed Dec  2 14:14:18 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/20 10:44 PM, Daniel Borkmann wrote:
> On 11/20/20 5:18 PM, Jesper Dangaard Brouer wrote:
>> BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
>> bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
>> by adjusting fib_params 'tot_len' with the packet length plus the
>> expected encap size. (Just like the bpf_check_mtu helper supports). He
>> discovered that for SKB ctx the param->tot_len was not used, instead
>> skb->len was used (via MTU check in is_skb_forwardable()).
>>
>> Fix this by using fib_params 'tot_len' for MTU check.  If not provided
>> (e.g. zero) then keep existing behaviour intact.
>>
>> Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
>> Reported-by: Carlo Carraro <colrack@gmail.com>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   net/core/filter.c |   14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 1ee97fdeea64..84d77c425fbe 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -5565,11 +5565,21 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>>   #endif
>>       }
>> -    if (!rc) {
>> +    if (rc == BPF_FIB_LKUP_RET_SUCCESS) {
>>           struct net_device *dev;
>> +        u32 mtu;
>>           dev = dev_get_by_index_rcu(net, params->ifindex);
>> -        if (!is_skb_forwardable(dev, skb))
>> +        mtu = READ_ONCE(dev->mtu);
>> +
>> +        /* Using tot_len for (L3) MTU check if provided by user */
>> +        if (params->tot_len && params->tot_len > mtu)
>> +            rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> 
> Is there a reason why we cannot reuse and at the same time optimize the built-in
> bpf_ipv{4,6}_fib_lookup() check_mtu as we do in XDP when params->tot_len was
> specified.. something as presented earlier [0]? My biggest concern for gso skbs
> is that the above might be subject to breakage from one kernel version to another
> if it was filled from the packet. So going back and building upon [0], to be on
> safe side we could have a new flag like below to indicate wanted behavior:

Also means that if params->tot_len from prog input was 0 we won't break either,
and we would be closer to XDP semantics overall which is desirable. Yes, extra
flag for skb case to force it which is not great, but I'm not sure how it would
be compatible without it tbh.

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c3458ec1f30a..d3cd2f47f011 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4934,8 +4934,9 @@ struct bpf_raw_tracepoint_args {
>    * OUTPUT:  Do lookup from egress perspective; default is ingress
>    */
>   enum {
> -    BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
> -    BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
> +    BPF_FIB_LOOKUP_DIRECT        = (1U << 0),
> +    BPF_FIB_LOOKUP_OUTPUT        = (1U << 1),
> +    BPF_FIB_LOOKUP_ALWAYS_MTU_CHECK    = (1U << 2),
>   };
> 
>   enum {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..4fb876ebd6a0 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5547,37 +5547,27 @@ static const struct bpf_func_proto bpf_xdp_fib_lookup_proto = {
>   BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>          struct bpf_fib_lookup *, params, int, plen, u32, flags)
>   {
> -    struct net *net = dev_net(skb->dev);
> -    int rc = -EAFNOSUPPORT;
> +    bool check_mtu = !skb_is_gso(skb) ||
> +             (flags & BPF_FIB_LOOKUP_ALWAYS_MTU_CHECK);
> 
>       if (plen < sizeof(*params))
>           return -EINVAL;
> 
> -    if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
> +    if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT |
> +              BPF_FIB_LOOKUP_ALWAYS_MTU_CHECK))
>           return -EINVAL;
> 
>       switch (params->family) {
>   #if IS_ENABLED(CONFIG_INET)
>       case AF_INET:
> -        rc = bpf_ipv4_fib_lookup(net, params, flags, false);
> -        break;
> +        return bpf_ipv4_fib_lookup(net, params, flags, check_mtu);
>   #endif
>   #if IS_ENABLED(CONFIG_IPV6)
>       case AF_INET6:
> -        rc = bpf_ipv6_fib_lookup(net, params, flags, false);
> -        break;
> +        return bpf_ipv6_fib_lookup(net, params, flags, check_mtu);
>   #endif
>       }
> -
> -    if (!rc) {
> -        struct net_device *dev;
> -
> -        dev = dev_get_by_index_rcu(net, params->ifindex);
> -        if (!is_skb_forwardable(dev, skb))
> -            rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> -    }
> -
> -    return rc;
> +    return -EAFNOSUPPORT;
>   }
> 
>   static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
> 
> 
>    [0] https://lore.kernel.org/bpf/65d8f988-5b41-24c2-8501-7cbbddb1238e@iogearbox.net/
