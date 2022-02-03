Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEFD4A83B3
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350363AbiBCMTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:19:21 -0500
Received: from mail.toke.dk ([45.145.95.12]:41507 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235652AbiBCMTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 07:19:20 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1643890758; bh=PrA6M+49YlGSC+ysxDmsq2PRS2Pmdw5kBFLOBRlSQB4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=npQU5Awt+Xbtok5i0OGMi/3RPF3Llp+Z/DD+8V3pD0PB4OODi7uFXdLBMO3c/NAPF
         GH3fkZ/QflwR/7fjRujd5diT2t8nLLKROyllJN6zfDQ2w7DSNqBhJ0R9LE0tZZ5RFp
         NeoYAFLvgX/mkmpNDrGqyAj5DTT/DbvqB7e6+2SrXNhn3nQYlHWv+yDHLqstPMrME6
         OYddwiJbkEN0uvoBEOF9HEkwKV47gBHo8bAROgcW5+rhu9Jl2oLy3N9f9+nzB0UUcq
         csCU7avg0SKPUhOoUppzGBs0AgFVopKx203uFkHRLQip3E/1aOE0qR2H4qxMIWpcPy
         Id4zcs3KTx0nw==
To:     Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
In-Reply-To: <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de>
 <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
Date:   Thu, 03 Feb 2022 13:19:18 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o83ob0s9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> writes:

> On Wed, Feb 2, 2022 at 4:28 AM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>>
>> Dave suggested a while ago (eleven years by now) "Let's make netif_rx()
>> work in all contexts and get rid of netif_rx_ni()". Eric agreed and
>> pointed out that modern devices should use netif_receive_skb() to avoid
>> the overhead.
>> In the meantime someone added another variant, netif_rx_any_context(),
>> which behaves as suggested.
>>
>> netif_rx() must be invoked with disabled bottom halves to ensure that
>> pending softirqs, which were raised within the function, are handled.
>> netif_rx_ni() can be invoked only from process context (bottom halves
>> must be enabled) because the function handles pending softirqs without
>> checking if bottom halves were disabled or not.
>> netif_rx_any_context() invokes on the former functions by checking
>> in_interrupts().
>>
>> netif_rx() could be taught to handle both cases (disabled and enabled
>> bottom halves) by simply disabling bottom halves while invoking
>> netif_rx_internal(). The local_bh_enable() invocation will then invoke
>> pending softirqs only if the BH-disable counter drops to zero.
>>
>> Add a local_bh_disable() section in netif_rx() to ensure softirqs are
>> handled if needed. Make netif_rx_ni() and netif_rx_any_context() invoke
>> netif_rx() so they can be removed once they are no more users left.
>>
>> Link: https://lkml.kernel.org/r/20100415.020246.218622820.davem@davemloft.net
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> Maybe worth mentioning this commit will show a negative impact, for
> network traffic
> over loopback interface.
>
> My measure of the cost of local_bh_disable()/local_bh_enable() is ~6
> nsec on one of my lab x86 hosts.
>
> Perhaps we could have a generic netif_rx(), and a __netif_rx() for the
> virtual drivers (lo and maybe tunnels).
>
> void __netif_rx(struct sk_buff *skb);
>
> static inline int netif_rx(struct sk_buff *skb)
> {
>    int res;
>     local_bh_disable();
>     res = __netif_rx(skb);
>   local_bh_enable();
>   return res;
> }

+1, this seems like a reasonable solution!

-Toke
