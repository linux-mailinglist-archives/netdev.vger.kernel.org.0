Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AFA326541
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBZQHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhBZQHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 11:07:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7119164E28;
        Fri, 26 Feb 2021 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614355589;
        bh=+DfKThjuzi4SbHVxc1YfvrQmVQYHSZPYjQMixzL2dcQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cAxims/6ordAz/2wVSMffL1FRAPscXJw+z+ND93rzDd7QMEq8cNeLbXV85rn0XPEj
         cyt9Xo8/vBUAzajy+eKVNqd+sHkTee4BGScqju2RZ7VxtRA6lToyTCCuQHBg1YggKG
         7Z43TAaEnvh+xdL3KBoxPNT8hg68xSZv2C60PR15/rlkmubdyO6w1+d/xl41QWcWGF
         s/sR+CGfYrn9ZX6jUL0xtyxEsYnkv9d3DyT+IMntjKYgeL/tbxB9q0VrhJlcpxosIv
         FUun2Y//iLPzICNCGdLjJUKpSOeUnKcug7zMd36TYKTjITeoU+cOfGtwzJ73fu4VdU
         iZryTStA17Cyg==
Date:   Fri, 26 Feb 2021 08:06:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: Spurious TCP retransmissions on ack vs kfree_skb reordering
Message-ID: <20210226080628.3e40e037@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iL7XCLBxsUnV3c_5AD8eSJ=jXs6o_KJUjmZAGo6_6sqUg@mail.gmail.com>
References: <20210225152515.2072b5a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210225191552.19b36496@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJwfXFKnSAQpwaBnfrrE01PXyxLUieBxaB0RzyOajCzLQ@mail.gmail.com>
        <CANn89iL7XCLBxsUnV3c_5AD8eSJ=jXs6o_KJUjmZAGo6_6sqUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 11:41:22 +0100 Eric Dumazet wrote:
> On Fri, Feb 26, 2021 at 11:05 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Feb 26, 2021 at 4:15 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> > >
> > > On Thu, 25 Feb 2021 15:25:15 -0800 Jakub Kicinski wrote:  
> > > > Hi!
> > > >
> > > > We see large (4-8x) increase of what looks like TCP RTOs after rising
> > > > the Tx coalescing above Rx coalescing timeout.
> > > >
> > > > Quick tracing of the events seems to indicate that the data has already
> > > > been acked when we enter tcp:tcp_retransmit_skb:  
> > >
> > > Seems like I'm pretty lost here and the tcp:tcp_retransmit_skb events
> > > are less spurious than I thought. Looking at some tcpdump traces we see:
> > >
> > > 0.045277 IP6 A > B: Flags [SEW], seq 2248382925:2248383296, win 61920, options [mss 1440,sackOK,TS val 658870494 ecr 0,nop,wscale 11], length 371
> > >
> > > 0.045348 IP6 B > A: Flags [S.E], seq 961169456, ack 2248382926, win 65535, options [mss 1440,sackOK,TS val 883864022 ecr 658870494,nop,wscale 9], length 0  
> >
> > The SYNACK does not include the prior payload.
> >  
> > > 0.045369 IP6 A > B: Flags [P.], seq 1:372, ack 1, win 31, options [nop,nop,TS val 658870494 ecr 883864022], length 371  
> >
> > So this rtx is not spurious.
> >
> > However in your prior email you wrote :
> >
> > bytes_in:      0
> > bytes_out:   742
> > bytes_acked: 742
> >
> > Are you sure that at the time of the retransmit, bytes_acked was 742 ?
> > I do not see how this could happen.  
> 
> Yes, this packetdrill test confirms TCP INFO stuff seems correct .

Looks like it's TcpExtTCPSpuriousRtxHostQueues - the TFO fails as it
might, but at the time the syn is still not kfree_skb()d because of 
the IRQ coalescing settings, so __tcp_retransmit_skb() returns -EBUSY
and we have to wait for a timeout.

Credit to Neil Spring @FB for figuring it out.
