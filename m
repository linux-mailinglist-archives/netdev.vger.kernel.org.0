Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8400732C4AE
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhCDAQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354283AbhCDAH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 19:07:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8C6C64F42;
        Thu,  4 Mar 2021 00:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614816437;
        bh=Cp69LfU3E0Jl+O7BluBIRN9GzlV1F83qSnc8AEys/VQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f7GUZooSy51cGbI3nKPk7NhxOEyCXmJrr5RoJopqq0b0UHpUsniDqD1Q7AsyEesk0
         kuER9jcXNjVGJAjOTCtz0fiwxI1aOHbJPLzldMhESJaebHhd/vwtKOQx2akAn8hZDM
         AJvPhBkYjen5deG1o5/VtE70NgPmWbUdlLaPiU4hh5yRtPd1lrkVuRJ9vNobxMY470
         eNW6qsLqRhFnEHebcU54BbifpQInr+7kuydsN5uC5Stfby9bHXsueJpX70yi9PNFlW
         9Ts12KQzVgZg1sYI8lHM2Nl1GFd9cJ23ydVSZLpQi73fpvHYxxHgPwJG7dviJci8wV
         WTq0yEpv4wLmg==
Date:   Wed, 3 Mar 2021 16:07:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen
 SYN
Message-ID: <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
References: <20210302060753.953931-1-kuba@kernel.org>
        <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
        <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Mar 2021 13:35:53 -0800 Alexander Duyck wrote:
> On Tue, Mar 2, 2021 at 1:37 PM Eric Dumazet <edumazet@google.com> wrote:
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
> >
> > Alternative is that drivers unable to TX complete their skbs in a
> > reasonable time should call skb_orphan()
> >  to avoid skb_unclone() penalties (and this skb_still_in_host_queue() issue)
> >
> > If you really want to play and delay TX completions, maybe provide a
> > way to disable skb_still_in_host_queue() globally,
> > using a static key ?  
> 
> The problem as I see it is that the original fclone isn't what we sent
> out on the wire and that is confusing things. What we sent was a SYN
> with data, but what we have now is just a data frame that hasn't been
> put out on the wire yet.

Not sure I understand why it's the key distinction here. Is it
re-transmitting part of the frame or having different flags?
Is re-transmit of half of a GSO skb also considered not the same?

To me the distinction is that the receiver has implicitly asked
us for the re-transmission. If it was requested by SACK we should 
ignore "in_queue" for the first transmission as well, even if the
skb state is identical.

> I wonder if we couldn't get away with doing something like adding a
> fourth option of SKB_FCLONE_MODIFIED that we could apply to fastopen
> skbs? That would keep the skb_still_in_host queue from triggering as
> we would be changing the state from SKB_FCLONE_ORIG to
> SKB_FCLONE_MODIFIED for the skb we store in the retransmit queue. In
> addition if we have to clone it again and the fclone reference count
> is 1 we could reset it back to SKB_FCLONE_ORIG.

The unused value of fclone was tempting me as well :)

AFAICT we have at least these options:

1 - don't use a fclone skb [v1]

2 - mark the fclone as "special" at Tx to escape the "in queue" check

3 - indicate to retansmit that we're sure initial tx is out [v2]

4 - same as above but with a bool / flag instead of negative seg

5 - use the fclone bits but mark them at Rx when we see a rtx request

6 - check the skb state in retransmit to match the TFO case (IIUC
    Yuchung's suggestion)

#5 is my favorite but I didn't know how to extend it to fast
re-transmits so I just stuck to the suggestion from the ML :)

WDYT? Eric, Yuchung?
