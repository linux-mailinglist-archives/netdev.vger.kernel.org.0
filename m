Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE42D3ED8B5
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhHPOLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:11:15 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:34340 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhHPOLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:11:13 -0400
Received: by mail-lf1-f45.google.com with SMTP id z2so34783990lft.1;
        Mon, 16 Aug 2021 07:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBogRPOPppta5F1L9M+H6FLMAUp3xVfVteZhfXnb2q4=;
        b=jmfA9S/+JpJkExV6dS5M+3f/qiMnegC/hhp1Q3SjjiUAdij/ukN67eu55WFl3IuNJw
         OjX8QjRHiTGBY+yhoVxHacqG5FDBpL2Cy0yNucJek8iuHcSL9aFy8Ej/JhTaDvRVBqIb
         Fv4dMlKNkoHHRnqPRygHhVbHb6Or5bxgf1WyRGr8mlPjprtel3w+9LNy4WH2gWy5+7tO
         CCrPEBpLFwYkXwqbInlXMuRt4I0R1tc9UDXeQw1ECfmIBYwOKYp9eaHxLtyhShrZvBSK
         HSVa0K/J8iyzzPpWT7W6pyV2w5tfwuexudFy+pUJKkE3nIdXb9K1jgcn6c9Q2xu64bpK
         INmQ==
X-Gm-Message-State: AOAM531FARdRjpy+WiOVc0k3Z3QwmWogNAGYTy3Po3GERhPBch+X4vQx
        sQ3p6WL5OB1kn5ZRuhegZti5NN3ZHfz8QFiXhcs=
X-Google-Smtp-Source: ABdhPJzFtjalDhfmirenO6s4EPO+uTs73yG035abSYq/TXFVv2pt/k7QnnBHWXQ7jPUkLkwDmp6hyz6yHkZ1BS93cYc=
X-Received: by 2002:a19:c112:: with SMTP id r18mr11227013lff.531.1629123040998;
 Mon, 16 Aug 2021 07:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr> <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de> <20210816123309.pfa57tke5hrycqae@pengutronix.de>
In-Reply-To: <20210816123309.pfa57tke5hrycqae@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 16 Aug 2021 23:10:29 +0900
Message-ID: <CAMZ6RqK0vTtCkSM7Lim2TQCZyYTYvKYsFVwWDnyNaFghwqToXg@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 16 Aug 2021 at 21:33, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 16.08.2021 14:25:19, Marc Kleine-Budde wrote:
> > > > I'm not sure, if we talked about the mcp251xfd's tcdo, valid values are
> > > > -64...63.
> > >
> > > Yes! Stefan shed some light on this. The mcp251xfd uses a tdco
> > > value which is relative to the sample point.
> >
> > I don't read the documentation this way....
> >
> > > | SSP = TDCV + absolute TDCO
> > > |     = TDCV + SP + relative TDCO
> > >
> > > Consequently:
> > > | relative TDCO = absolute TDCO - SP
> >
> > In the mcp15xxfd family manual
> > (http://ww1.microchip.com/downloads/en/DeviceDoc/MCP251XXFD-CAN-FD-Controller-Module-Family-Reference-Manual-20005678B.pdf)
> > in the 2mbit/s data bit rate example in table 3-5 (page 21) it says:
> >
> > | DTSEG1  15 DTQ
> > | DTSEG2   4 DTQ
> > | TDCO    15 DTQ
> >
> > The mcp251xfd driver uses 15, the framework calculates 16 (== Sync Seg+
> > tseg1, which is correct), and relative tdco would be 0:
> >
> > | mcp251xfd_set_bittiming: tdco=15, priv->tdc.tdc=16, relative_tdco=0
> >
> > Here the output with the patched ip tool:
>
> Sorry, the previous output was not using the sample points of the
> example in the data sheet, this is the fixed output:
>
> | 6: mcp251xfd0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
> |     link/can  promiscuity 0 minmtu 0 maxmtu 0
> |     can <FD,TDC_AUTO> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 100
> |           bitrate 500000 sample-point 0.800
> |           tq 25 prop-seg 31 phase-seg1 32 phase-seg2 16 sjw 1 brp 1
> |           mcp251xfd: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp_inc 1
> |           dbitrate 2000000 dsample-point 0.800
> |           dtq 25 dprop-seg 7 dphase-seg1 8 dphase-seg2 4 dsjw 1 dbrp 1
> |           tdco 16
> |           mcp251xfd: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp_inc 1
> |           tdco 0..127
> |           clock 40000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus spi parentdev spi0.0

After the discussion I had with Stefan, I assumed mcp251xxfd also
used relative TDCO.  However, in the mcp15xxfd family manual,
Equation 3-10: "Secondary Sample Point" on page 18 states that:

| SSP = TDCV + TDCO

As I commented above, this is the formula of the absolute
TDCO. Furthermore, in the example you shared, TDCO is
16 (absolute), not 0 (relative).

*BUT*, if this is the absolute TDCO, I just do not get how it can
be negative (I already elaborated on this in the past: if you
subtract from TDCV, you are measuring the previous bit...)

Another thing which is misleading to me is that the mcp15xxfd
family manual lists the min and max values for most of the
bittiming parameters but not for TDCO.

Finally, I did a bit of research and found that:
http://ww1.microchip.com/downloads/en/DeviceDoc/Section_56_Controller_Area_Network_with_Flexible_Data_rate_DS60001549A.pdf

This is *not* the mcp25xxfd datasheet but it is still from
Microship and as you will see, it is mostly similar to the
mcp25xxfd except for, you guessed it, the TDCO.

It reads:
| TDCMOD<1:0>: Transmitter Delay Compensation Mode bits
| Secondary Sample Point (SSP).
| 10 = Auto; measure delay and add CFDxDBTCFG.TSEG1; add TDCO
| 11 = Auto; measure delay and add CFDxDBTCFG.TSEG1; add TDCO
| 01 = Manual; Do not measure, use TDCV plus TDCO from the register
| 00 = Disable

| TDCO<6:0>: Transmitter Delay Compensation Offset bits
| Secondary Sample Point (SSP). Two's complement; offset can be
positive, zero, or negative.
| 1111111 = -64 x SYSCLK
| .
| .
| .
| 0111111 = 63 x SYSCLK
| .
| .
| .
| 0000000 = 0 x SYSCLK

Here, you can clearly see that the TDCO has the exact same range
as the one of the mcp25xxfd but the description of TDCMOD
changes, telling us that:

| SSP = TDCV (measured delay) + CFDxDBTCFG.TSEG1 (sample point) + TDCO

Which means this is a relative TDCO.

I just do not get how two documents from Microchip can have the
TDCO relative range of -64..63 but use a different formula. I am
sorry but at that point, I just do not understand what is going
on with your controller...
