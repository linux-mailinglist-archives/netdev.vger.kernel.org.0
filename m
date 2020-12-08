Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691142D3729
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgLHXvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729665AbgLHXvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 18:51:03 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FF7C061793
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 15:50:22 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id z136so333094iof.3
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 15:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hdL0m5JgFJe1EpPesWikdrSf9jXdSBdwbL4TxHVvvOk=;
        b=NzY69DPYhNIzwXHVZei4rEkY+5RtZDtn0aCrOkx/uPRICVZIHrkfQbrlaRl+WQdGWY
         T3u2EBHoGUDpiUaRXsVSR6EcxAG/qffWWgalhmZ067BzOJYuh1MkEe4gr8uvvZ21NVM1
         Pgp/sezauXFiu6bpz+LiR/EJ8zmuwZLU9hfKF2t5TVCnztZsYu9+jdmuhe0KJYNHzqQa
         i7E8SgSWb7JiVQhROomVLR8FKZfVb0hEFC9zflx0fgYMDLGWoGwFiT794TGqcbBC5Vs+
         q5Bp/+B51GnRNr9aQFsyDbcz0fzywlcqVdfOGV+pTLeywo8FhhokE+ZlTPEs3JGl1F+G
         /Ftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hdL0m5JgFJe1EpPesWikdrSf9jXdSBdwbL4TxHVvvOk=;
        b=lLXrciVFS6lpnKbPBiRwIjHRDQz8tbIWhQBzqUQMVpNyy+ga2nefV9ev2br2d1dpoy
         UhP6Fgp6WvjAAOJuJ3M4LID++4crehpdHdcxI89e66kMQb/PK51B8PKG+6jTdIKwn1YA
         /PzX4rRKaGK5HtCFhV830UJdadQ5I4amggJex558CF9Uk6PStPZR+PxT0SA5GmdLCXbr
         klDFO1oMpnpXuP719Zg2Ag9RTsE5JeGbaq6WIeiKJnjpfQTkjBujsvoJvQtPbooXnGiS
         C7iYDchzq5CtaYUawJWQAYsJSyr2kmQQiKbIatnrTaLdpgKQkZKMSkyR5zt3JKfGIWbM
         OKdw==
X-Gm-Message-State: AOAM532btz+NtkPC7kBkvt4EpT/4ChxlRAWyuARVfi1wJp8paJnGtSDi
        zYkNKrYHn/QaplNOvDrtUZWpZzsmnY6Ui7iF5hp74Q==
X-Google-Smtp-Source: ABdhPJy0s478dGQDlOWaOEFsZDMsEl/YWBNiwlPctX36Fwxt4h7/a2eHUrlWaQN7j4J0v/D9VBTLvueMBo7CH2SHf7U=
X-Received: by 2002:a6b:c8c1:: with SMTP id y184mr264930iof.99.1607471421992;
 Tue, 08 Dec 2020 15:50:21 -0800 (PST)
MIME-Version: 1.0
References: <20201206034408.31492-1-TheSven73@gmail.com> <20201208115035.74221c31@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVpToas=offBuPgQ6t8wru64__NQ7MnNDYb0i0E+m6ebw@mail.gmail.com> <20201208152948.006606b3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208152948.006606b3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Dec 2020 00:50:10 +0100
Message-ID: <CANn89iKxjQawkMBCg5Mt=eMgqvD_cpYSs4664GoGZFrMTgWJFw@mail.gmail.com>
Subject: Re: [PATCH net v1 1/2] lan743x: improve performance: fix
 rx_napi_poll/interrupt ping-pong
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 12:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 8 Dec 2020 17:23:08 -0500 Sven Van Asbroeck wrote:
> > On Tue, Dec 8, 2020 at 2:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > >
> > > > +done:
> > > >       /* update RX_TAIL */
> > > >       lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
> > > >                         rx_tail_flags | rx->last_tail);
> > > > -done:
> > > > +
> > >
> > > I assume this rings the doorbell to let the device know that more
> > > buffers are available? If so it's a little unusual to do this at the
> > > end of NAPI poll. The more usual place would be to do this every n
> > > times a new buffer is allocated (in lan743x_rx_init_ring_element()?)
> > > That's to say for example ring the doorbell every time a buffer is put
> > > at an index divisible by 16.
> >
> > Yes, I believe it tells the device that new buffers have become available.
> >
> > I wonder why it's so unusual to do this at the end of a napi poll? Omitting
> > this could result in sub-optimal use of buffers, right?
> >
> > Example:
> > - tail is at position 0
> > - core calls napi_poll(weight=64)
> > - napi poll consumes 15 buffers and pushes 15 skbs, then ring empty
> > - index not divisible by 16, so tail is not updated
> > - weight not reached, so napi poll re-enables interrupts and bails out
> >
> > Result: now there are 15 buffers which the device could potentially use, but
> > because the tail wasn't updated, it doesn't know about them.
>
> Perhaps 16 for a device with 64 descriptors is rather high indeed.
> Let's say 8. If the device misses 8 packet buffers on the ring,
> that should be negligible.
>

mlx4 uses 8 as the threshold ( mlx4_en_refill_rx_buffers())

> Depends on the cost of the CSR write, usually packet processing is
> putting a lot of pressure on the memory subsystem of the CPU, hence
> amortizing the write over multiple descriptors helps. The other thing
> is that you could delay the descriptor writes to write full cache lines,
> but I don't think that will help on IMX6.
>
> > It does make sense to update the tail more frequently than only at the end
> > of the napi poll, though?
> >
> > I'm new to napi polling, so I'm quite interested to learn about this.
>
> There is a tracepoint which records how many packets NAPI has polled:
> napi:napi_poll, you can see easily what your system is doing.
>
> What you want to avoid is the situation where the device already used
> up all the descriptors by the time driver finishes the Rx processing.
> That'd result in drops. So the driver should push the buffers back to
> the device reasonably early.
>
> With a ring of 64 descriptors and NAPI budget of 64 it's not unlikely
> that the ring will be completely used when processing runs.
>
> > > > +     /* up to half of elements in a full rx ring are
> > > > +      * extension frames. these do not generate skbs.
> > > > +      * to prevent napi/interrupt ping-pong, limit default
> > > > +      * weight to the smallest no. of skbs that can be
> > > > +      * generated by a full rx ring.
> > > > +      */
> > > >       netif_napi_add(adapter->netdev,
> > > >                      &rx->napi, lan743x_rx_napi_poll,
> > > > -                    rx->ring_size - 1);
> > > > +                    (rx->ring_size - 1) / 2);
> > >
> > > This is rather unusual, drivers should generally pass NAPI_POLL_WEIGHT
> > > here.
> >
> > I agree. The problem is that a full ring buffer of 64 buffers will only
> > contain 32 buffers with network data - the others are timestamps.
> >
> > So napi_poll(weight=64) can never reach its full weight. Even with a full
> > buffer, it always assumes that it has to stop polling, and re-enable
> > interrupts, which results in a ping-pong.
>
> Interesting I don't think we ever had this problem before. Let me CC
> Eric to see if he has any thoughts on the case. AFAIU you should think
> of the weight as way of arbitrating between devices (if there is more
> than one).

Driver could be called with an arbitrary budget (of 64),
and if its ring buffer has been depleted, return @budget instead of skb counts,
and not ream the interrupt

if (count < budget && !rx_ring_fully_processed) {
    if (napi_complete_done(napi, count))
          ream_irqs();
   return count;
}
return budget;


>
> NAPI does not do any deferral (in wall clock time terms) of processing,
> so the only difference you may get for lower weight is that softirq
> kthread will get a chance to kick in earlier.
>
> > Would it be better to fix the weight counting? Increase the count
> > for every buffer consumed, instead of for every skb pushed?
>
