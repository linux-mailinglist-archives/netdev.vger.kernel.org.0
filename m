Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8CF313857
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhBHPns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:43:48 -0500
Received: from www62.your-server.de ([213.133.104.62]:55680 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbhBHPmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:42:14 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l98fF-000E8Z-Uo; Mon, 08 Feb 2021 16:41:26 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l98fF-000P5I-Kx; Mon, 08 Feb 2021 16:41:25 +0100
Subject: Re: [PATCH bpf-next V15 2/7] bpf: fix bpf_fib_lookup helper MTU check
 for SKB ctx
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, David Ahern <dsahern@kernel.org>
References: <161228314075.576669.15427172810948915572.stgit@firesoul>
 <161228321177.576669.11521750082473556168.stgit@firesoul>
 <ada19e5b-87be-ff39-45ba-ff0025bf1de9@iogearbox.net>
 <20210208145713.4ee3e9ba@carbon> <20210208162056.44b0236e@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <547131a3-5125-d419-8e61-0fc675d663a8@iogearbox.net>
Date:   Mon, 8 Feb 2021 16:41:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210208162056.44b0236e@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26074/Mon Feb  8 13:20:40 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 4:20 PM, Jesper Dangaard Brouer wrote:
> On Mon, 8 Feb 2021 14:57:13 +0100
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>> On Fri, 5 Feb 2021 01:06:35 +0100
>> Daniel Borkmann <daniel@iogearbox.net> wrote:
>>> On 2/2/21 5:26 PM, Jesper Dangaard Brouer wrote:
>>>> BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
>>>> bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
>>>> by adjusting fib_params 'tot_len' with the packet length plus the expected
>>>> encap size. (Just like the bpf_check_mtu helper supports). He discovered
>>>> that for SKB ctx the param->tot_len was not used, instead skb->len was used
>>>> (via MTU check in is_skb_forwardable() that checks against netdev MTU).
>>>>
>>>> Fix this by using fib_params 'tot_len' for MTU check. If not provided (e.g.
>>>> zero) then keep existing TC behaviour intact. Notice that 'tot_len' for MTU
>>>> check is done like XDP code-path, which checks against FIB-dst MTU.
[...]
>>>> -	if (!rc) {
>>>> -		struct net_device *dev;
>>>> -
>>>> -		dev = dev_get_by_index_rcu(net, params->ifindex);
>>>> +	if (rc == BPF_FIB_LKUP_RET_SUCCESS && !check_mtu) {
>>>> +		/* When tot_len isn't provided by user,
>>>> +		 * check skb against net_device MTU
>>>> +		 */
>>>>    		if (!is_skb_forwardable(dev, skb))
>>>>    			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
>>>
>>> ... so using old cached dev from above will result in wrong MTU check &
>>> subsequent passing of wrong params->mtu_result = dev->mtu this way.
>>
>> Yes, you are right, params->ifindex have a chance to change in the calls.
>> So, our attempt to save an ifindex lookup (dev_get_by_index_rcu) is not
>> correct.
>>
>>> So one
>>> way to fix is that we would need to pass &dev to bpf_ipv{4,6}_fib_lookup().
>>
>> Ok, I will try to code it up, and see how ugly it looks, but I'm no
>> longer sure that it is worth saving this ifindex lookup, as it will
>> only happen if BPF-prog didn't specify params->tot_len.
> 
> I guess we can still do this as an "optimization", but the dev/ifindex
> will very likely be another at this point.

I would say for sake of progress, lets ship your series w/o this optimization so
it can land, and we revisit this later on independent from here. Actually DavidA
back then acked the old poc patch I posted, so maybe that's worth a revisit as
well but needs more testing first.

Thanks,
Daniel
