Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66990440661
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 02:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhJ3A2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 20:28:01 -0400
Received: from hyperium.qtmlabs.xyz ([194.163.182.183]:48544 "EHLO
        hyperium.qtmlabs.xyz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhJ3A2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 20:28:01 -0400
Received: from dong.kernal.eu (unknown [14.231.159.161])
        by hyperium.qtmlabs.xyz (Postfix) with ESMTPSA id 50DAC8200D9;
        Sat, 30 Oct 2021 02:25:25 +0200 (CEST)
Received: from [192.168.43.218] (unknown [27.78.8.12])
        by dong.kernal.eu (Postfix) with ESMTPSA id F4065444968D;
        Sat, 30 Oct 2021 07:25:20 +0700 (+07)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qtmlabs.xyz; s=syka;
        t=1635553521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RXSuMwz07aHZP6G/nn5AePXv57cWkkfCv5oImXUZORw=;
        b=iZHYnZY2YVzR8SwYCTvH38D3bjHxyntBWMsxW3v4ICjEGrS5hroHf8EbmqS8qJZHMairhR
        ozyrKERb8hjE3lLiuMWBisZ18pW4hNBBxEwba26biZjNUCst1ftrQ+FqLFigroOPOlHRs6
        SmoU/I0Vtpo1grOyUHCr2CvZQN/xSYakgKUqHDMEezJaKThOTgKTyqdvx171wPMOx2aSMp
        /pS0mAXPO4JPv9HkrdqI7K4VVW6d2laup9EwNPHg7vfnOEta4cIqNpzjKT6TvqxU8f3Eb+
        Drt2GkdTf3hsQ7HKswaoBKvQXXDVmn8Oq0+c6dRK7Cow0qP+BW/FcipOwDKIEA==
Message-ID: <285f536d-17dd-86fa-d8cd-08c3d73f60e2@qtmlabs.xyz>
Date:   Sat, 30 Oct 2021 07:25:15 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: Kernel leaks memory in ip6_dst_cache when suppress_prefix is
 present in ipv6 routing rules and a `fib` rule is present in ipv6 nftables
 rules
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e022d597-302d-c061-0830-6ed20aa61e56@qtmlabs.xyz>
 <9015da81-689a-5ff6-c5ca-55c28dec1867@gmail.com>
From:   msizanoen <msizanoen@qtmlabs.xyz>
In-Reply-To: <9015da81-689a-5ff6-c5ca-55c28dec1867@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > exact command? I have not played with nftables.

sudo nft create table inet test
sudo nft create chain inet test test_chain '{ type filter hook 
prerouting priority filter + 10; policy accept; }'
sudo nft add rule inet test test_chain meta nfproto ipv6 fib saddr . 
mark . iif oif missing drop

 > Do you have a stack
 > trace of where the dst reference is getting taken?

         ip6_dst_alloc+5
         ip6_create_rt_rcu+107
         ip6_pol_route_lookup+741
         fib6_rule_action+707
         fib_rules_lookup+342
         fib6_rule_lookup+150
         nft_fib6_eval+354
         nft_do_chain+339
         nft_do_chain_inet+123
         nf_hook_slow+63
         nf_hook_slow_list+129
         ip6_sublist_rcv+606
         ipv6_list_rcv+296
         __netif_receive_skb_list_core+489
         netif_receive_skb_list_internal+433
         napi_complete_done+111
         virtnet_poll+771
         __napi_poll+42
         net_rx_action+547
         __softirqentry_text_start+208
         __irq_exit_rcu+199
         common_interrupt+131
         asm_common_interrupt+30
         native_safe_halt+11
         default_idle+10
         default_idle_call+53
         do_idle+487
         cpu_startup_entry+25
         secondary_startup_64_no_verify+194

Collected using the following bpftrace script:

kretfunc:ip6_dst_alloc { @[(uint64)retval] = kstack(); }
kfunc:ip6_dst_destroy { delete(@[(uint64)args->dst]); }

On 10/30/21 06:53, David Ahern wrote:
> On 10/26/21 8:24 AM, msizanoen wrote:
>> The kernel leaks memory when a `fib` rule is present in ipv6 nftables
>> firewall rules and a suppress_prefix rule
>> is present in the IPv6 routing rules (used by certain tools such as
>> wg-quick). In such scenarios, every incoming
>> packet will leak an allocation in ip6_dst_cache slab cache.
>>
>> After some hours of `bpftrace`-ing and source code reading, I tracked
>> down the issue to this commit:
>>      https://github.com/torvalds/linux/commit/ca7a03c4175366a92cee0ccc4fec0038c3266e26
>>
>>
>> The problem with that patch is that the generic args->flags always have
>> FIB_LOOKUP_NOREF set[1][2] but the
>> ip6-specific flag RT6_LOOKUP_F_DST_NOREF might not be specified, leading
>> to fib6_rule_suppress not
>> decreasing the refcount when needed. This can be fixed by exposing the
>> protocol-specific flags to the
>> protocol specific `suppress` function, and check the protocol-specific
>> `flags` argument for
>> RT6_LOOKUP_F_DST_NOREF instead of the generic FIB_LOOKUP_NOREF when
>> decreasing the refcount.
>>
>> How to reproduce:
>> - Add the following nftables rule to a prerouting chain: `meta nfproto
>> ipv6 fib saddr . mark . iif oif missing drop`
> exact command? I have not played with nftables. Do you have a stack
> trace of where the dst reference is getting taken?
>
>
>> - Run `sudo ip -6 rule add table main suppress_prefixlength 0`
>> - Watch `sudo slabtop -o | grep ip6_dst_cache` memory usage increase
>> with every incoming ipv6 packet
>>
>> Example
>> patch:https://gist.github.com/msizanoen1/36a2853467a9bd34fadc5bb3783fde0f
>>
>> [1]:https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L71
>>
>> [2]:https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L99
>>
>>
>>
