Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD8C30185A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbhAWU0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbhAWUZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 15:25:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17C4C22BF3;
        Sat, 23 Jan 2021 20:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611433512;
        bh=8uPDQuS/kos5Jy0bgtah0hZxcbG5TC3djav2RF5Zefc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fejr20ytvuXgah+6wDOK7oPaqUoFezWydMF4y+dcarMFq8RyGMqRSMCPBCn3emcQw
         yfHVxcOXXqhlMCNNy7/KWJ6AYGmsckieszWC89Yo5xL9Y5BRk4hM4TRUoxY9L8hcT0
         x6AUvx/Q0VbJamyZrkZLFLswf/gDuH/fHMdbu00LHQKEXpnOD7lFXLMZZBAIzbDTok
         9nncrc1B54cYvfp1JmdJtRw78JFklS1usA29eAD4wQph1UdD/fYASdxq1GdYOFiXgQ
         0TlmAyfxgKIKZ7n/0QvJ+4BGPkxayOTHehwDzwgqFR6xfXfXREuA5xW6vl28qicRQh
         W49GrpJpZZ4oQ==
Date:   Sat, 23 Jan 2021 12:25:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes
 from DISORDER to OPEN
Message-ID: <20210123122510.2c8a4a0f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADVnQy=Htibc9H2bDy8T47F76kEmtWn-ZwJNtQXr2RaR0X6_dw@mail.gmail.com>
References: <20210122172703.39cfff6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1611413231-13731-1-git-send-email-yangpc@wangsu.com>
        <CADVnQy=Htibc9H2bDy8T47F76kEmtWn-ZwJNtQXr2RaR0X6_dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 13:25:23 -0500 Neal Cardwell wrote:
> On Sat, Jan 23, 2021 at 9:15 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> >
> > On Sat, Jan 23, 2021 at 9:27 AM "Jakub Kicinski" <kuba@kernel.org> wrote:  
> > >
> > > On Fri, 22 Jan 2021 11:53:46 +0100 Eric Dumazet wrote:  
> > > > On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:  
> > > > >
> > > > > When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> > > > > an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> > > > > change from DISORDER to OPEN. If the sender is app-limited, it can only
> > > > > wait for the RTO timer to expire and retransmit.
> > > > >
> > > > > The reason for this is that the TLP timer is set before CA_STATE changes
> > > > > in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> > > > > until after tcp_fastretrans_alert() returns and remove the
> > > > > FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
> > > > >
> > > > > This commit has two additional benefits:
> > > > > 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> > > > > avoid spurious RTO caused by RTO timer early expires.
> > > > > 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> > > > > timer is set.
> > > > >
> > > > > Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> > > > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > > > Cc: Neal Cardwell <ncardwell@google.com>  
> > > >
> > > > This looks like a very nice patch, let me run packetdrill tests on it.
> > > >
> > > > By any chance, have you cooked a packetdrill test showing the issue
> > > > (failing on unpatched kernel) ?  
> > >
> > > Any guidance on backporting / fixes tag? (once the packetdrill
> > > questions are satisfied)  
> >
> > By reading the commits, we can add:
> > Fixes: df92c8394e6e ("tcp: fix xmit timer to only be reset if data ACKed/SACKed")  
> 
> Thanks for the fix and the packetdrill test!
> 
> Eric ran our internal packetdrill test suite and all the changes in
> behavior with your patch all look like fixes to me.
> 
> Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks!

> The Fixes: tag you suggest also looks good to me. (It seems like
> patchwork did not pick it up from your email and add it to the commit
> message automatically, BTW?)

Indeed, we haven't worked that out yet in patchwork.kernel.org, but
it's no big deal, normally we can add manually. In this case seems 
like Yuchung asked for a small rewrite to the commit message so I'd
appreciate a full repost.
