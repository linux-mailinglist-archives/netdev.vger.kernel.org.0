Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C9532DDD7
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 00:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhCDX1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 18:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230415AbhCDX1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 18:27:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12EFE64F79;
        Thu,  4 Mar 2021 23:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614900430;
        bh=A6AuqkK68RQaVxzh67ZABwXTk2uIWVuQYm2y9wjih40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ABHkmxAkSg3QivwPKVDmGgZLWN+CQnfoQu2bhwvw9YCf6NYU+2Xeop2sVSZtNWbEZ
         KcCVL15GABIKxFuBJr8Nww5Cgu4rtjDnQGe9q856dEcClrhkPBu1LOeuGhBEkMS4VW
         diKOnvcPDxQBhXv+pqF2TV+dmn+13Va0SjVJ3sLbRbw3cR2QGetraTArWNLnoA1Iis
         c/o1NfOzXXntqEiLTT7Z5rp9j08Hpg15VEWBlkb4rj0XiGYw9oeC6Us4fXZk5S5Axb
         WclIONnsukznKw62XRZM6eGwfbwpYiHvncMpKrrXAY73LX3jPtOcSNuK4raTdKz3tm
         Anp8H/Bi9UgDA==
Date:   Thu, 4 Mar 2021 15:27:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen
 SYN
Message-ID: <20210304152709.4e91bd8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iLBi=2VzpiUBZPHaPHCeqqoFE-JmB0KAsf-vxaPvkvcxA@mail.gmail.com>
References: <20210302060753.953931-1-kuba@kernel.org>
        <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
        <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
        <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
        <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
        <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
        <20210304210836.bkpqwbvfpkd5fagg@bsd-mbp.dhcp.thefacebook.com>
        <CANn89i+Sf66QknMO7+1gxowhV6g+Bs-DMhnvsvFx8vaqPfBVug@mail.gmail.com>
        <CANn89iLBi=2VzpiUBZPHaPHCeqqoFE-JmB0KAsf-vxaPvkvcxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Mar 2021 22:26:58 +0100 Eric Dumazet wrote:
> It would be nice if tun driver would have the ability to delay TX
> completions by N usecs,
> so that packetdrill tests could be used.
> 
> It is probably not too hard to add such a feature.

Add an ioctl to turn off the skb_orphan, queue the skbs in tun_do_read() 
to free them from a timer?

> I was testing this (note how I also removed the tcp_rearm_rto(sk) call)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 6f450e577975c7be9537338c8a4c0673d7d36c4c..9ef92ca55e530f76ad793d7342442c4ec06165f7
> 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6471,11 +6471,10 @@ static bool tcp_rcv_fastopen_synack(struct
> sock *sk, struct sk_buff *synack,
>         tcp_fastopen_cache_set(sk, mss, cookie, syn_drop, try_exp);
> 
>         if (data) { /* Retransmit unacked data in SYN */
> -               skb_rbtree_walk_from(data) {
> -                       if (__tcp_retransmit_skb(sk, data, 1))
> -                               break;
> -               }
> -               tcp_rearm_rto(sk);
> +               skb_rbtree_walk_from(data)
> +                       tcp_mark_skb_lost(sk, data);
> +
> +               tcp_xmit_retransmit_queue(sk);
>                 NET_INC_STATS(sock_net(sk),
>                                 LINUX_MIB_TCPFASTOPENACTIVEFAIL);
>                 return true;

AFAICT this works great now:

==> TFO case ret:-16 (0) ca_state:0 skb:ffff8881d3513800!
  FREED swapper/5 -- skb 0xffff8881d3513800 freed after: 1us
-----
First:
        __tcp_retransmit_skb+1
        tcp_retransmit_skb+18
        tcp_xmit_retransmit_queue.part.70+339
        tcp_rcv_state_process+2491
        tcp_v6_do_rcv+405
        tcp_v6_rcv+2984

Second:
        __tcp_retransmit_skb+1
        tcp_retransmit_skb+18
        tcp_xmit_retransmit_queue.part.70+339
        tcp_tsq_write.part.71+146
        tcp_tsq_handler+53
        tcp_tasklet_func+181

 sk:0xffff8885adc16f00 skb:ffff8881d3513800 --- 61us acked:1


The other case where we hit RTO after __tcp_retransmit_skb() fails is:

==> non-TFO case ret:-11 (0) ca_state:3 skb:ffff8883d71dd400!
-----
First:
        __tcp_retransmit_skb+1
        tcp_retransmit_skb+18
        tcp_xmit_retransmit_queue.part.70+339
        tcp_ack+2270
        tcp_rcv_established+303
        tcp_v6_do_rcv+190

Second:
        __tcp_retransmit_skb+1
        tcp_retransmit_skb+18
        tcp_retransmit_timer+716
        tcp_write_timer_handler+136
        tcp_write_timer+141
        call_timer_fn+43

 sk:0xffff88801772d340 skb:ffff8883d71dd400 --- 51738us acked:47324

Which I believe is this:

	if (refcount_read(&sk->sk_wmem_alloc) >
	    min_t(u32, sk->sk_wmem_queued + (sk->sk_wmem_queued >> 2),
		  sk->sk_sndbuf))
		return -EAGAIN;

Because __tcp_retransmit_skb() seems to bail before
inet6_sk_rebuild_header gets called. Should we arm TSQ here as well?
