Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D980C326546
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBZQKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhBZQKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 11:10:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 753A364E28;
        Fri, 26 Feb 2021 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614355759;
        bh=vIfp6DdtdUNU9LR57QYhG0oya5+OrTD7ooC+26LYiqA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YI9k4cPLOdm0dyyqRDmZAVJ47V6T63gB5wcHPmZvJ+NPwhPUUQdzJrJ3lJS57OVbT
         rjW+/Ufdi/XpnqomOv0R6eBstfxRpPjhZhZSvwJQ9JK/7Tjzkcm8kC3U6Vz/35U9J0
         OgGlEh5eM8ImkwICmKH/1uMzuds4NltXbi7h/756A6WLo+lmpCK2xEQbECLfPK7mFI
         bNRCyMHBncaEbGmwBv9rLDLEPYUpWkpx1HyzZ34itnQsk5PX0Z3pq1EXEmBewvmg8J
         AMpQlEHdcGkpp9oG1y0oimJkC61+NKDF6wVF1tsZF0llVR3vGdKY0ciOKVGD2y2Qt1
         30mrGdscNhjKw==
Date:   Fri, 26 Feb 2021 08:09:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: Spurious TCP retransmissions on ack vs kfree_skb reordering
Message-ID: <20210226080918.03617088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
