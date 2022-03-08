Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA93F4D0EB0
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 05:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiCHEaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 23:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiCHEaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 23:30:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94FB220EA
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 20:29:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB2E9CE1179
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 04:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7513C340EB;
        Tue,  8 Mar 2022 04:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646713759;
        bh=3l0f5L8+1qkEitzQ13VA3zt0+T8i6vEHqaJUlonATL4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hE9UmcCHpCjnWLpkt0E5Ae7VIcrG5OYml+1XeE+OAW5Yuam6IE3+sKHgll95f3g4b
         yd07dhZjv86Nw7tksGHpOPMqbE5xZoAD4I+u8B7yyLEa3Phqd4LsHfG2wDDYgALoQT
         sRWXzRfz6tErSPNq4PWxP7zc7Io1JGDCQ3ChVO0w2sQxUitu0moIGjRzOrIoUKdvMI
         6UP4qktewwar5H3o6f48isk/OWub9CLvTpZlngfguF/v6TkOMwwv1dulNUZjBYPuBl
         iHY/b79GjqjJJXW7TY3Q4lLdzEvDJrrgg5Ve+FuF9uFCzvIdFaXPfLsGIxKyHpRAbf
         Vm4RCg3UECMKw==
Date:   Mon, 7 Mar 2022 20:29:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
Message-ID: <20220307202917.04005301@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
References: <20220308030348.258934-1-kuba@kernel.org>
        <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Mar 2022 19:50:10 -0800 Eric Dumazet wrote:
> On Mon, Mar 7, 2022 at 7:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > We observed Tx-heavy workloads causing softirq overload because
> > with increased load and therefore latency the pacing rates fall,
> > pushing TCP to generate smaller and smaller TSO packets.  
> 
> Yes, we saw this behavior but came up with something more generic,
> also helping the common case. Cooking larger TSO is really a function
> of the radius (distance between peers)

Excellent, I was hoping you have a better fix :)

> > It seems reasonable to allow larger packets to be built when
> > system is under stress. TCP already uses the
> >
> >   this_cpu_ksoftirqd() == current
> >
> > condition as an indication of overload for TSQ scheduling.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > Sending as an RFC because it seems reasonable, but really
> > I haven't run any large scale testing, yet. Bumping
> > tcp_min_tso_segs to prevent overloads is okay but it
> > seems like we can do better since we only need coarser
> > pacing once disaster strikes?
> >
> > The downsides are that users may have already increased
> > the value to what's needed during overload, or applied
> > the same logic in out-of-tree CA algo implementations
> > (only BBR implements ca_ops->min_tso_segs() upstream).
> >  
> 
> Unfortunately this would make packetdrill flaky, thus break our tests.
> 
> Also, I would guess the pacing decreases because CWND is small anyway,
> or RTT increases ?

Both increase - CWND can go up to the 256-512 bucket (in a histogram)
but latency gets insane as the machine tries to pump out 2kB segments,
doing a lot of splitting and barely services the ACK from the Rx ring. 

With a Rx ring of a few thousand packets latency crosses 250ms,
in-building. I've seen srtt_us > 1M.

> What CC are you using ?

A mix of CUBIC and DCTCP for this application, primarily DCTCP.

> The issue I see here is that bi modal behavior will cause all kinds of
> artifacts.
> 
> BBR2 has something to give an extra allowance based on min_rtt.
> 
> I think we should adopt this for all CC, because it is not bi-modal,
> and even allow full size TSO packets
> for hosts in the same rack.

Using min_rtt makes perfect sense in the case I saw.

> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 2319531267c6830b633768dea7f0b40a46633ee1..02ec5866a05ffc2920ead95e9a65cc1ba77459c7
> 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1956,20 +1956,34 @@ static bool tcp_nagle_check(bool partial,
> const struct tcp_sock *tp,
>  static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
>                             int min_tso_segs)
>  {
> -       u32 bytes, segs;
> +/* Use min_rtt to help adapt TSO burst size, with smaller min_rtt resulting
> + * in bigger TSO bursts. By default we cut the RTT-based allowance in half
> + * for every 2^9 usec (aka 512 us) of RTT, so that the RTT-based allowance
> + * is below 1500 bytes after 6 * ~500 usec = 3ms.
> + * Default: halve allowance per 2^9 usecs, 512us.
> + */
> +       const u32 rtt_shift = 9;
> +       unsigned long bytes;
> +       u32 r;
> +
> +       bytes = sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift);
> +       /* Budget a TSO/GSO burst size allowance based on min_rtt. For every
> +        * K = 2^tso_rtt_shift microseconds of min_rtt, halve the burst.
> +        * The min_rtt-based burst allowance is: 64 KBytes / 2^(min_rtt/K)
> +        */
> +       r = tcp_min_rtt(tcp_sk(sk)) >> rtt_shift;
> +       if (r < BITS_PER_TYPE(u32))
> +               bytes += GSO_MAX_SIZE >> r;
> +
> +       bytes = min_t(unsigned long, bytes, sk->sk_gso_max_size);
> 
> -       bytes = min_t(unsigned long,
> -                     sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
> -                     sk->sk_gso_max_size);
> 
>         /* Goal is to send at least one packet per ms,
>          * not one big TSO packet every 100 ms.
>          * This preserves ACK clocking and is consistent
>          * with tcp_tso_should_defer() heuristic.
>          */
> -       segs = max_t(u32, bytes / mss_now, min_tso_segs);
> -
> -       return segs;
> +       return max_t(u32, bytes / mss_now, min_tso_segs);
>  }
> 
>  /* Return the number of segments we want in the skb we are transmitting.

