Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F7732B3D5
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839537AbhCCEH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2359600AbhCBWBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 17:01:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C2F064F35;
        Tue,  2 Mar 2021 22:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614722432;
        bh=B9c2VzkpIcZyYNBFukF+tKhaPcdFpEx6jHlBb/abw7Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jsfPkLf6YVtzwHbx1jUAkk2wrIJilnqY+HDAtZ1GhVaQqVhhKC/z0aX1ZzHaP5Vtm
         pkZQYcQyH+YtZ9saq3dTUO/Z2dHIP8NqVYGsmWitGgBbjhICn2lb+Um0O9UT8QK4ji
         2fQJlTVaynbREe8E1i8MIJlHe/S175/+BQrJaGzCZ+5pzzbSMHui2Z/0wRcBdyZt+a
         t69SkAPj7R1VN5TgPV8JEHWv6vmkeeG8fuHtjEOzQq5o6m3iDZeY30Qv5qgX5ytbUE
         yCXH4MSRW1jOt24GdvVXr4ZH2okwTG25oiw4KsL0kMmlPcuIwQzcaekSoeVX8aWcpH
         OlZSC4JZOet1A==
Date:   Tue, 2 Mar 2021 14:00:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen
 SYN
Message-ID: <20210302140030.2db20ce4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAK6E8=fL7HP3ObOrUtR=UbR5ZrCDjc0qQ-t7cD9oUMorWFsKwg@mail.gmail.com>
References: <20210302060753.953931-1-kuba@kernel.org>
        <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
        <CAK6E8=fL7HP3ObOrUtR=UbR5ZrCDjc0qQ-t7cD9oUMorWFsKwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 12:52:14 -0800 Yuchung Cheng wrote:
> On Tue, Mar 2, 2021 at 11:58 AM Eric Dumazet <edumazet@google.com> wrote:
> > On Tue, Mar 2, 2021 at 7:08 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > When receiver does not accept TCP Fast Open it will only ack
> > > the SYN, and not the data. We detect this and immediately queue
> > > the data for (re)transmission in tcp_rcv_fastopen_synack().
> > >
> > > In DC networks with very low RTT and without RFS the SYN-ACK
> > > may arrive before NIC driver reported Tx completion on
> > > the original SYN. In which case skb_still_in_host_queue()
> > > returns true and sender will need to wait for the retransmission
> > > timer to fire milliseconds later.
> > >
> > > Revert back to non-fast clone skbs, this way
> > > skb_still_in_host_queue() won't prevent the recovery flow
> > > from completing.
> > >
> > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > Fixes: 355a901e6cf1 ("tcp: make connect() mem charging friendly")  
> >
> > Hmmm, not sure if this Fixes: tag makes sense.
> >
> > Really, if we delay TX completions by say 10 ms, other parts of the
> > stack will misbehave anyway.
> >
> > Also, backporting this patch up to linux-3.19 is going to be tricky.
> >
> > The real issue here is that skb_still_in_host_queue() can give a false positive.
> >
> > I have mixed feelings here, as you can read my answer :/
> >
> > Maybe skb_still_in_host_queue() signal should not be used when a part
> > of the SKB has been received/acknowledged by the remote peer
> > (in this case the SYN part).  
> 
> Thank you Eric and Jakub for working on the TFO issue.
> 
> I like this option the most because it's more generic and easy to understand. 

I'm assuming by "this" you mean v1 - as far as understanding goes we
can polish v2. I think Eric just shared a quick example, but perhaps 
we could add an explicit bool to __tcp_retransmit_skb() called expl_req
or such to signify that the rtx was explicitly requested by the
receiver and therefore we can skip the "in queue" check? Or add some
flags to the call?

If everyone is okay with targeting -next the new argument won't be an
issue.

> Is it easy to implement by checking snd_una etc?

That is to detect TFO retransmits in __tcp_retransmit_skb() by matching
the connections state, like acked == 1?
