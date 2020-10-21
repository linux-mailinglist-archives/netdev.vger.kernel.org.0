Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294C9294704
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 05:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411767AbgJUDhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 23:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406750AbgJUDhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 23:37:15 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B027FC0613CE;
        Tue, 20 Oct 2020 20:37:15 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id r7so1085203qkf.3;
        Tue, 20 Oct 2020 20:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TvMvPvEIzkDzHLBTHLVaGKI3I8TYc8uxn0Gzgfn1fYM=;
        b=S0yF5moQ3zgsfWshFIIAsq+ESTQkQc+axIoz5jeRWLvLrMvOEWoRrIYk4T4LJdCota
         Mi8kln4clBqAqESVvBTY8RSFa3TGx4K3La5VVj6r9HCs3TuCtwtuR5aSGEIGs46CyE+T
         ISl0n2RWmR8iN+HDOkSz6srw3eWvcuLDJZhdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TvMvPvEIzkDzHLBTHLVaGKI3I8TYc8uxn0Gzgfn1fYM=;
        b=U3MKmyIJKsBO4KwquvBN3CbFB3y+89qP7qXtAWXh9tBcI4HrfFzl5DpXlZQoQA1XDX
         5JQo9KRBAf9E2FxeBVRmTcOURX7K9hME0xoN+8nwc6lF76Pwh2rr9JVF/fbDiiHqdyFt
         tswmFGcRQ7JUlyswJwa9WIa2p4WYS/qQXE8jbCG4xyT6N0HkkNELRqIAGyL+D5VesCfE
         xhEJLWy6qlqaMHHIyDS0zPlDQyRK6rDZrL35YKl/9ippxk38MDdbuPmTs9J9tGObVexO
         If85BtTu37e5LCRChmv+nsB3c7wmTUP1hzF55ZkjK13vWAsvzlKjJ7vye9+M3ch8/MO9
         fI9w==
X-Gm-Message-State: AOAM531rV4gZekktj0rGzSB9ep66NkZhYswwf5Nd2nPO21G/kV/q7WOK
        cNPeer4j6V+VuUe01Xq5mUyElOZVeN1peO+YjHSYUL+gSJs=
X-Google-Smtp-Source: ABdhPJy50X7s92E4yQURmrw0y3qAXYcHTHBJ+PGZaS5kTRxKsjzOAJtZumbrwf36JRnsvarnNvoJ5csQLlmSLnGY/1o=
X-Received: by 2002:a37:48cc:: with SMTP id v195mr1446238qka.66.1603251434714;
 Tue, 20 Oct 2020 20:37:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201020220639.130696-1-joel@jms.id.au> <86480db3977cfbf6750209c34a28c8f042be55fb.camel@kernel.crashing.org>
In-Reply-To: <86480db3977cfbf6750209c34a28c8f042be55fb.camel@kernel.crashing.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 21 Oct 2020 03:37:02 +0000
Message-ID: <CACPK8XfmdUdoke8q=z02ijk89=3ZezTfjOmcr9PX3jnpmvAZPw@mail.gmail.com>
Subject: Re: [PATCH] net: ftgmac100: Ensure tx descriptor updates are visible
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 at 00:00, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> On Wed, 2020-10-21 at 08:36 +1030, Joel Stanley wrote:
> > We must ensure the tx descriptor updates are visible before updating
> > the tx pointer.
> >
> > This resolves the tx hangs observed on the 2600 when running iperf:
>
> To clarify the comment here. This doesn't ensure they are visible to
> the hardware but to other CPUs. This is the ordering vs start_xmit and
> tx_complete.

Thanks. Let me know if this makes sense, or if I'm completely off the mark.

How is this for the commit message:

This resolves the tx hangs observed on the 2600 when running iperf.
This is ensuring the setting of the OWN bit in txdes0 of the
descriptor is visible to other CPUs before updating the pointer. Doing
this provides ordering between start_xmit and tx_complete.

and then I'll put:

        /* Ensure the descriptor config is visible to other CPUs before setting
         * the tx pointer. This ensures ordering against start_xmit which checks
          * the OWN bit before proceeding.
         */

and similar for tx_complete?

>
> Cheers,
> Ben.
>
> > root@ast2600:~# iperf3 -c 192.168.86.146 -R
> > Connecting to host 192.168.86.146, port 5201
> > Reverse mode, remote host 192.168.86.146 is sending
> > [  5] local 192.168.86.173 port 43886 connected to 192.168.86.146
> > port 5201
> > [ ID] Interval           Transfer     Bitrate
> > [  5]   0.00-1.00   sec  90.7 MBytes   760 Mbits/sec
> > [  5]   1.00-2.00   sec  91.7 MBytes   769 Mbits/sec
> > [  5]   2.00-3.00   sec  91.7 MBytes   770 Mbits/sec
> > [  5]   3.00-4.00   sec  91.7 MBytes   769 Mbits/sec
> > [  5]   4.00-5.00   sec  91.8 MBytes   771 Mbits/sec
> > [  5]   5.00-6.00   sec  91.8 MBytes   771 Mbits/sec
> > [  5]   6.00-7.00   sec  91.9 MBytes   771 Mbits/sec
> > [  5]   7.00-8.00   sec  91.4 MBytes   767 Mbits/sec
> > [  5]   8.00-9.00   sec  91.3 MBytes   766 Mbits/sec
> > [  5]   9.00-10.00  sec  91.9 MBytes   771 Mbits/sec
> > [  5]  10.00-11.00  sec  91.8 MBytes   770 Mbits/sec
> > [  5]  11.00-12.00  sec  91.8 MBytes   770 Mbits/sec
> > [  5]  12.00-13.00  sec  90.6 MBytes   761 Mbits/sec
> > [  5]  13.00-14.00  sec  45.2 KBytes   370 Kbits/sec
> > [  5]  14.00-15.00  sec  0.00 Bytes  0.00 bits/sec
> > [  5]  15.00-16.00  sec  0.00 Bytes  0.00 bits/sec
> > [  5]  16.00-17.00  sec  0.00 Bytes  0.00 bits/sec
> > [  5]  17.00-18.00  sec  0.00 Bytes  0.00 bits/sec
> > [   67.031671] ------------[ cut here ]------------
> > [   67.036870] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:442
> > dev_watchdog+0x2dc/0x300
> > [   67.046123] NETDEV WATCHDOG: eth2 (ftgmac100): transmit queue 0
> > timed out
> >
> > Fixes: 52c0cae87465 ("ftgmac100: Remove tx descriptor accessors")
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
> > ---
> >  drivers/net/ethernet/faraday/ftgmac100.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> > b/drivers/net/ethernet/faraday/ftgmac100.c
> > index 331d4bdd4a67..15cdfeb135b0 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -653,6 +653,11 @@ static bool ftgmac100_tx_complete_packet(struct
> > ftgmac100 *priv)
> >       ftgmac100_free_tx_packet(priv, pointer, skb, txdes, ctl_stat);
> >       txdes->txdes0 = cpu_to_le32(ctl_stat & priv-
> > >txdes0_edotr_mask);
> >
> > +     /* Ensure the descriptor config is visible before setting the
> > tx
> > +      * pointer.
> > +      */
> > +     smp_wmb();
> > +
> >       priv->tx_clean_pointer = ftgmac100_next_tx_pointer(priv,
> > pointer);
> >
> >       return true;
> > @@ -806,6 +811,11 @@ static netdev_tx_t
> > ftgmac100_hard_start_xmit(struct sk_buff *skb,
> >       dma_wmb();
> >       first->txdes0 = cpu_to_le32(f_ctl_stat);
> >
> > +     /* Ensure the descriptor config is visible before setting the
> > tx
> > +      * pointer.
> > +      */
> > +     smp_wmb();
> > +
> >       /* Update next TX pointer */
> >       priv->tx_pointer = pointer;
> >
>
