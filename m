Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CF449AA87
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1326180AbiAYDkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1319383AbiAYDIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 22:08:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D315C0A887D
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 16:02:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C445B815F8
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062F6C340E4;
        Tue, 25 Jan 2022 00:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643068962;
        bh=l+Muon+youxJk8rLUdxAhN+AQfcNX18OV4rAIbcXGv8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aZWVlczf0eP/OAZ5x0IkMcFhOpkn1432fiKipqIeu2eUWgIeXf7shjBy9Vo5E4nDP
         GSrUOjvM3vie4yVCGBe3bN35xlSlwX21++IE0uVBVBIITeMUbINTHzBdnaz6IAwCDL
         yfmQpX846i9dDV2HXiTpmSv9+61oC9Z7/WFwCXlw02yO2AE7VD7sKsTrQXflbzLKeT
         UIEzALmIGbXqQkvTDjtvGvausRgiE2UTm/DMA+QSsmKE1V9gglz908PL0vimqtZn2W
         5uOfrYk+rDzg5e7D4GA8Lk+WNfgsRom4NIi+9STOVxTT7YCXVEgf+qIV+5x7d5v9q2
         lJ6ia+1zGsXig==
Date:   Mon, 24 Jan 2022 16:02:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH net] ipv6: gro: flush instead of assuming different
 flows on hop_limit mismatch
Message-ID: <20220124160240.02a451bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CANn89iJY=oDHY+Fe=u+GHeb07LCUC305rwLehsE2Wq1TcidP8Q@mail.gmail.com>
References: <20220121011941.1123392-1-kuba@kernel.org>
        <CANn89iKBchKPeumrdWVOf9onjM2qBm1D5_2CUToi57C+CEwoJw@mail.gmail.com>
        <20220121071514.4e80f880@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CANn89iJY=oDHY+Fe=u+GHeb07LCUC305rwLehsE2Wq1TcidP8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the delay I had to do some homework and more tests.

On Fri, 21 Jan 2022 08:37:12 -0800 Eric Dumazet wrote:
> On Fri, Jan 21, 2022 at 7:15 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > We implemented SACK compress in TCP stack to avoid extra SACK being
> > > sent by the receiver
> > >
> > > We have an extension of this SACK compression for TCP flows terminated
> > > by Google servers,
> > > since modern TCP stacks do not need the old rule of TCP_FASTRETRANS_THRESH
> > > DUPACK to start retransmits.
> > >
> > > Something like this pseudo code:
> > >
> > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > index dc49a3d551eb919baf5ad812ef21698c5c7b9679..d72554ab70fd2e16ed60dc78a905f4aa1414f8c9
> > > 100644
> > > --- a/net/ipv4/tcp_input.c
> > > +++ b/net/ipv4/tcp_input.c
> > > @@ -5494,7 +5494,8 @@ static void __tcp_ack_snd_check(struct sock *sk,
> > > int ofo_possible)
> > >         }
> > >         if (tp->dup_ack_counter < TCP_FASTRETRANS_THRESH) {
> > >                 tp->dup_ack_counter++;
> > > -               goto send_now;
> > > +               if (peer_is_using_old_rule_about_fastretrans(tp))
> > > +                       goto send_now;
> > >         }
> > >         tp->compressed_ack++;
> > >         if (hrtimer_is_queued(&tp->compressed_ack_timer))
> > >  
> >
> > Is this something we could upstream / test? peer_is_using.. does not
> > exist upstream.  
> 
> Sure, because we do not have a standardized way (at SYN SYNACK time)
> to advertise
> that the stack is not 10 years old.
> 
> This could be a per net-ns sysctl, or a per socket flag, or a per cgroup flag.
> 
> In our case, we do negotiate special TCP options, and allow these options
> only from internal communications.
> 
> (So we store this private bit in the socket itself)

This does not fix the problem, unfortunately. I still see TCP detecting
reordering based on SACK if re-transmits have higher TTL.

> > Coincidentally, speaking of sending SACKs, my initial testing was on
> > 5.12 kernels and there I saw what appeared to a lay person (me) like
> > missing ACKs. Receiver would receive segments:
> >
> > _AB_C_D_E
> >
> > where _ indicates loss. It'd SACK A, then generate the next SACK after E
> > (SACKing C D E), sender would rexmit A which makes receiver ACK all
> > the way to the end of B. Now sender thinks B arrived after CDE because
> > it was never sacked.
> >
> > Perhaps it was fixed by commit a29cb6914681 ("net: tcp better handling
> > of reordering then loss cases").. or it's a result of some out-of-tree
> > hack. I thought I'd mention it tho in case it immediately rings a bell
> > for anyone.  
> 
> Could all the missing SACK have been lost ?

I had tcpdump on both ends, but I can't repro any more with the GRO fix
applied. Maybe it was also related to that. Somehow.

> Writing a packetdrill test for this scenario should not be too hard.
