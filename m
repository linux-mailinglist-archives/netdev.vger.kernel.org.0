Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912EA2D362E
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgLHWYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730393AbgLHWYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:24:00 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52126C061793;
        Tue,  8 Dec 2020 14:23:20 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id w18so10358154vsk.12;
        Tue, 08 Dec 2020 14:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N7VdFbyyCDi1uq6j0l/SA3U8jgEM1OrggvkOS/Hf/OQ=;
        b=EJX+HvXFO17F1iSSmiS2Awhj83og4g6aSeHMNIgEz+7nD0GBW/qvdy4S8g9Sk71K4A
         eEXTVd0+IhSBCao77zjlBUkvyH8fRfFduW9Be9ebt0TxEr7KK+oWXv25c7ccsnvw1q2c
         l42cPgCKFY0jOcHm6YUhrWDnPux7+/eMmNAEzfC2/3IclhKk3wo5PCBcj9/kDMHuKWS/
         5FCdNokOSygirtN0CpRhVf7PlsPk6HI94VpOintTBoMG5wWFIErZtj72VPpz+XObceW/
         DpwCJwmMMDY0nOkIz4py8psHU6jTyNBor+vJdx9MQNMUk89PAAgggmP4lx2oZRraQS/o
         T9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N7VdFbyyCDi1uq6j0l/SA3U8jgEM1OrggvkOS/Hf/OQ=;
        b=lIsTugO6ObzCVajItr3QX4XJB3G0qoY/3+OWkSchu1zmsJ83euukdS/30qAPHHZ5F5
         FDxHHUnO9Ka9QRW0aWT8npxRGazm3WoFH28juCgtllBeQC7sZP2WHstBl27vxDTr7ejd
         2NIcg7rMmCwlVRswmGGeGKH+KVGb0r2hoprvjcXlRdl8r0kiv9163ExTQPiM5s95IKq8
         VOXRRK65Aa2nK6uPJlDQVpxW39/50guitCXZn8SjeFRwQKNNi6m0nhwaoArV/mRFNdlS
         FlVC1ZZjtVFWA71jz+E4GNeh3NZgAiRZcTKsYrOV6mjwbDBfOUVohh9jyDuyTJOcyyfM
         KlJA==
X-Gm-Message-State: AOAM530OsykWEjCc2prkeScFQa1NPW2pISKREmTdvwwKkyhWWfDsE+L+
        XmIE7SUPWTGAYQO83xzbjfwjxct+/rXCOU7712Qb3pA3/FTGjA==
X-Google-Smtp-Source: ABdhPJySeEl56WZqFuf74fCdEKIEsLeySni5nLTfRQZF34XxVCJVf5UA0HU841DR6dXkvVmLiavxiRHVzi8H3pl1sKY=
X-Received: by 2002:a67:d319:: with SMTP id a25mr8662985vsj.57.1607466199202;
 Tue, 08 Dec 2020 14:23:19 -0800 (PST)
MIME-Version: 1.0
References: <20201206034408.31492-1-TheSven73@gmail.com> <20201208115035.74221c31@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208115035.74221c31@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 8 Dec 2020 17:23:08 -0500
Message-ID: <CAGngYiVpToas=offBuPgQ6t8wru64__NQ7MnNDYb0i0E+m6ebw@mail.gmail.com>
Subject: Re: [PATCH net v1 1/2] lan743x: improve performance: fix
 rx_napi_poll/interrupt ping-pong
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 2:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> >
> > +done:
> >       /* update RX_TAIL */
> >       lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
> >                         rx_tail_flags | rx->last_tail);
> > -done:
> > +
>
> I assume this rings the doorbell to let the device know that more
> buffers are available? If so it's a little unusual to do this at the
> end of NAPI poll. The more usual place would be to do this every n
> times a new buffer is allocated (in lan743x_rx_init_ring_element()?)
> That's to say for example ring the doorbell every time a buffer is put
> at an index divisible by 16.

Yes, I believe it tells the device that new buffers have become available.

I wonder why it's so unusual to do this at the end of a napi poll? Omitting
this could result in sub-optimal use of buffers, right?

Example:
- tail is at position 0
- core calls napi_poll(weight=64)
- napi poll consumes 15 buffers and pushes 15 skbs, then ring empty
- index not divisible by 16, so tail is not updated
- weight not reached, so napi poll re-enables interrupts and bails out

Result: now there are 15 buffers which the device could potentially use, but
because the tail wasn't updated, it doesn't know about them.

It does make sense to update the tail more frequently than only at the end
of the napi poll, though?

I'm new to napi polling, so I'm quite interested to learn about this.


> >
> > +     /* up to half of elements in a full rx ring are
> > +      * extension frames. these do not generate skbs.
> > +      * to prevent napi/interrupt ping-pong, limit default
> > +      * weight to the smallest no. of skbs that can be
> > +      * generated by a full rx ring.
> > +      */
> >       netif_napi_add(adapter->netdev,
> >                      &rx->napi, lan743x_rx_napi_poll,
> > -                    rx->ring_size - 1);
> > +                    (rx->ring_size - 1) / 2);
>
> This is rather unusual, drivers should generally pass NAPI_POLL_WEIGHT
> here.

I agree. The problem is that a full ring buffer of 64 buffers will only
contain 32 buffers with network data - the others are timestamps.

So napi_poll(weight=64) can never reach its full weight. Even with a full
buffer, it always assumes that it has to stop polling, and re-enable
interrupts, which results in a ping-pong.

Would it be better to fix the weight counting? Increase the count
for every buffer consumed, instead of for every skb pushed?
