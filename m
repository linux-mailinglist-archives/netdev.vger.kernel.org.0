Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99844961DB
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 16:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351229AbiAUPPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 10:15:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47002 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241694AbiAUPPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 10:15:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17E2BB81EDB
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 15:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71558C340E1;
        Fri, 21 Jan 2022 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642778115;
        bh=GUcTaUgstScxbyQvbFHeePm4nU24i+1XX5m4cD2YsfU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EzMoVc3ouvaMGLOiPBzmeUQi8GK54uzRc9zW5UH5Id2+JPeAfq27FLVRIniFiVtrY
         HG18rbOJQrhBi3M+3fQBpKSl0djzC61LNkFl+kE4pcdS9cgOYjTFh8eaTCQh18Ifkn
         +8jdseWBt+KZjMX9Gj/xuRLQzu3nDdjxNTAzkFLes9C0vYnZc1GFKUqSZArg96eBlF
         k6H/fUfoy5ugmjAF4B/FuAL6EqZvespKcLlz8dqD3zQR+Fue0MHtWMCMGcCL7o6WsY
         rvHe5qw+II3JMCo0asw9ovDfj7ql+EVlfqtTsY1DFNRZa1ey3q/nTXLDwmWQ5Y0P38
         X8d7BwDRY0Q+Q==
Date:   Fri, 21 Jan 2022 07:15:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev <netdev@vger.kernel.org>, ycheng@google.com,
        ncardwell@google.com
Subject: Re: [PATCH net] ipv6: gro: flush instead of assuming different
 flows on hop_limit mismatch
Message-ID: <20220121071514.4e80f880@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CANn89iKBchKPeumrdWVOf9onjM2qBm1D5_2CUToi57C+CEwoJw@mail.gmail.com>
References: <20220121011941.1123392-1-kuba@kernel.org>
        <CANn89iKBchKPeumrdWVOf9onjM2qBm1D5_2CUToi57C+CEwoJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jan 2022 00:55:08 -0800 Eric Dumazet wrote:
> On Thu, Jan 20, 2022 at 5:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > IPv6 GRO considers packets to belong to different flows when their
> > hop_limit is different. This seems counter-intuitive, the flow is
> > the same. hop_limit may vary because of various bugs or hacks but
> > that doesn't mean it's okay for GRO to reorder packets.
> >
> > Practical impact of this problem on overall TCP performance
> > is unclear, but TCP itself detects this reordering and bumps
> > TCPSACKReorder resulting in user complaints.
> >
> > Note that the code plays an easy to miss trick by upcasting next_hdr
> > to a u16 pointer and compares next_hdr and hop_limit in one go.
> > Coalesce the flush setting to reduce the instruction count a touch.
> 
> There are downsides to this change.
> 
> We had an internal discussion at Google years ago about this
> difference in behavior of IPv6/IPv4
> 
> We came to the conclusion the IPv6 behavior was better for our needs
> (and we do not care
> much about IPv4 GRO, since Google DC traffic is 99.99% IPv6)
> 
> In our case, we wanted to keep this 'ipv6 feature' because we were
> experimenting with the idea of sending
> TSO packets with different flowlabels, to use different paths in the
> network, to increase nominal
> throughput for WAN flows (one flow would use multiple fiber links)
> 
> The issue with 'ipv4 gro style about ttl mismatch' was that because of
> small differences in RTT for each path,
>  a receiver could very well receive mixed packets.
> 
> Even without playing with ECMP hashes, this scenario can happen if the sender
> uses a bonding device in balance-rr mode.
> 
> After your change, GRO would be defeated and deliver one MSS at a time
> to TCP stack.

Indeed. Sounds like we're trading correctness for an optimization of a
questionable practical application, but our motivation isn't 100% pure
either [1] so whatever way we can fix this is fine by me :)

[1] We have some shenanigans that bump TTL to indicate re-transmitted
packets so we can identify them in the network.

> We implemented SACK compress in TCP stack to avoid extra SACK being
> sent by the receiver
> 
> We have an extension of this SACK compression for TCP flows terminated
> by Google servers,
> since modern TCP stacks do not need the old rule of TCP_FASTRETRANS_THRESH
> DUPACK to start retransmits.
> 
> Something like this pseudo code:
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index dc49a3d551eb919baf5ad812ef21698c5c7b9679..d72554ab70fd2e16ed60dc78a905f4aa1414f8c9
> 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5494,7 +5494,8 @@ static void __tcp_ack_snd_check(struct sock *sk,
> int ofo_possible)
>         }
>         if (tp->dup_ack_counter < TCP_FASTRETRANS_THRESH) {
>                 tp->dup_ack_counter++;
> -               goto send_now;
> +               if (peer_is_using_old_rule_about_fastretrans(tp))
> +                       goto send_now;
>         }
>         tp->compressed_ack++;
>         if (hrtimer_is_queued(&tp->compressed_ack_timer))
> 

Is this something we could upstream / test? peer_is_using.. does not
exist upstream.


Coincidentally, speaking of sending SACKs, my initial testing was on
5.12 kernels and there I saw what appeared to a lay person (me) like
missing ACKs. Receiver would receive segments:

_AB_C_D_E

where _ indicates loss. It'd SACK A, then generate the next SACK after E
(SACKing C D E), sender would rexmit A which makes receiver ACK all 
the way to the end of B. Now sender thinks B arrived after CDE because
it was never sacked.

Perhaps it was fixed by commit a29cb6914681 ("net: tcp better handling
of reordering then loss cases").. or it's a result of some out-of-tree 
hack. I thought I'd mention it tho in case it immediately rings a bell
for anyone.
