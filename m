Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B83EDA47
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhHPP44 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Aug 2021 11:56:56 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:43830 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbhHPP4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:56:55 -0400
Received: by mail-lf1-f46.google.com with SMTP id i9so14663410lfg.10;
        Mon, 16 Aug 2021 08:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c9l+YE7WNjbQ5edK008G+h5CMzV9oRtp+Y4bgi0QHY0=;
        b=bKvlsqM3m6mnY+adcVXlDjBVqzBCbajL0FLmE3hrzCmTFuOXO0U0mOy3WCOVsAPOdD
         w1DWrwiTDsGHC16n4orvRzbqRHuVpVB5c4NFsRaFOxjBCiN96AH6HpZrg9Ryjqy6kKO2
         GitiEQEbpv3d9ALa5B8+LtCS9++nIoML/E+Ma5ah/VGCneiNHCskFKlB1GiIEKtAUOj6
         FJNlPykxmyFwNMRafryp1ytyR2WAdCq1QtD8QnU+Fiz6T33uTK34N0VzKuWe23YxNkJy
         bWT5W5vX1i8+iOyOktqVor/bnT/Iysa/n8VdOdbgoMNF7Z0+uG7eNCEbCcnXipbpfyWU
         1LTQ==
X-Gm-Message-State: AOAM530NKmhc/lQQbuQNxX24DPh9nHt1IHz05quSbzj/0XYZ/wj8+0qK
        3NAI7KyEs9Dt2UlfBpktVWjJ4MYjDfHGiYb4iQc=
X-Google-Smtp-Source: ABdhPJzaDdNoQPM2AJ4T551pYOs232Gpl7KZcd8TXogLSorum/PF+ss8KS2j5+K7K2WZvhcMxHg4Ocz5JSffzulF3is=
X-Received: by 2002:ac2:4e8c:: with SMTP id o12mr12617089lfr.374.1629129382855;
 Mon, 16 Aug 2021 08:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr> <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de> <79691916e4280970f583a54cd5010ece025a1c53.camel@esd.eu>
In-Reply-To: <79691916e4280970f583a54cd5010ece025a1c53.camel@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 Aug 2021 00:56:11 +0900
Message-ID: <CAMZ6Rq+j-x-xHCsPsJyzstLgRy6SLvvONyfaCVexJ6O-0JrQaA@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
To:     =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>
Cc:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 16 Aug 2021 at 22:49, Stefan Mätje <Stefan.Maetje@esd.eu> wrote:
> Hi Vincent,
>
> I would like to add some comments below:
>
> Am Montag, den 16.08.2021, 14:25 +0200 schrieb Marc Kleine-Budde:
> > On 16.08.2021 19:24:43, Vincent MAILHOL wrote:
> > > On Mon. 16 Aug 2021 at 17:42, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > > On 15.08.2021 12:32:43, Vincent Mailhol wrote:
> > > > > ISO 11898-1 specifies in section 11.3.3 "Transmitter delay
> > > > > compensation" that "the configuration range for [the] SSP position
> > > > > shall be at least 0 to 63 minimum time quanta."
> > > > >
> > > > > Because SSP = TDCV + TDCO, it means that we should allow both TDCV and
> > > > > TDCO to hold zero value in order to honor SSP's minimum possible
> > > > > value.
> > > > >
> > > > > However, current implementation assigned special meaning to TDCV and
> > > > > TDCO's zero values:
> > > > >   * TDCV = 0 -> TDCV is automatically measured by the transceiver.
> > > > >   * TDCO = 0 -> TDC is off.
> > > > >
> > > > > In order to allow for those values to really be zero and to maintain
> > > > > current features, we introduce two new flags:
> > > > >   * CAN_CTRLMODE_TDC_AUTO indicates that the controller support
> > > > >     automatic measurement of TDCV.
> > > > >   * CAN_CTRLMODE_TDC_MANUAL indicates that the controller support
> > > > >     manual configuration of TDCV. N.B.: current implementation failed
> > > > >     to provide an option for the driver to indicate that only manual
> > > > >     mode was supported.
> > > > >
> > > > > TDC is disabled if both CAN_CTRLMODE_TDC_AUTO and
> > > > > CAN_CTRLMODE_TDC_MANUAL flags are off, c.f. the helper function
> > > > > can_tdc_is_enabled() which is also introduced in this patch.
> > > >
> > > > Nitpick: We can only say that TDC is disabled, if the driver supports
> > > > the TDC interface at all, which is the case if tdc_const is set.
> > >
> > > I would argue that saying that a device does not support TDC is
> > > equivalent to saying that TDC is always disabled for that device.
> > > Especially, the function can_tdc_is_enabled() can be used even if
> > > the device does not support TDC (even if there is no benefit
> > > doing so).
> > >
> > > Do you still want me to rephrase this part?
> > >
> > > > > Also, this patch adds three fields: tdcv_min, tdco_min and tdcf_min to
> > > > > struct can_tdc_const. While we are not convinced that those three
> > > > > fields could be anything else than zero, we can imagine that some
> > > > > controllers might specify a lower bound on these. Thus, those minimums
> > > > > are really added "just in case".
> > > >
> > > > I'm not sure, if we talked about the mcp251xfd's tcdo, valid values are
> > > > -64...63.
> > >
> > > Yes! Stefan shed some light on this. The mcp251xfd uses a tdco
> > > value which is relative to the sample point.
> >
> > I don't read the documentation this way....
>
> @Vincent: I have to agree with Marc here. Perhaps my email
> https://lore.kernel.org/linux-can/094d8a2eab2177e5a5143f96cf745b26897e1793.camel@esd.eu/
> was also misleading. I also referred there to a MicroChip Excel sheet
> (https://ww1.microchip.com/downloads/en/DeviceDoc/MCP2517FD%20Bit%20Time%20Calculations%20-%20UG.xlsx)
> that describes the calculation of the bit timing and the TDCO. The values calculated
> there correspond to the SPO from the above email. Microchip calculates the TDCO as
> TDCO = (DPRSEG + DPH1SEG) * DBRP.
> Thus, as already discussed, negative values are not purposeful.
>
> Sorry, that that email was misleading. So far I've seen now only the ESDACC
> controller has a "relative" TDCO register value where a negative value may
> be sensible.

So many misleading things on this absolute/relative TDCO topic.
But be sure of one thing: your help has been precious!

> > > > SSP = TDCV + absolute TDCO
> > > >     = TDCV + SP + relative TDCO
> > >
> > > Consequently:
> > > > relative TDCO = absolute TDCO - SP
> >
> > In the mcp15xxfd family manual
> > (http://ww1.microchip.com/downloads/en/DeviceDoc/MCP251XXFD-CAN-FD-Controller-Module-Family-Reference-Manual-20005678B.pdf)
> > in the 2mbit/s data bit rate example in table 3-5 (page 21) it says:
> >
> > > DTSEG1  15 DTQ
> > > DTSEG2   4 DTQ
> > > TDCO    15 DTQ
> >
> > The mcp251xfd driver uses 15, the framework calculates 16 (== Sync Seg+
> > tseg1, which is correct), and relative tdco would be 0:
> >
> > > mcp251xfd_set_bittiming: tdco=15, priv->tdc.tdc=16, relative_tdco=0
> >
> > Here the output with the patched ip tool:
> >
> > > 4: mcp251xfd0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
> > >     link/can  promiscuity 0 minmtu 0 maxmtu 0
> > >     can <FD,TDC_AUTO> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 100
> > >           bitrate 500000 sample-point 0.875
> > >           tq 25 prop-seg 34 phase-seg1 35 phase-seg2 10 sjw 1 brp 1
> > >           mcp251xfd: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp_inc 1
> > >           dbitrate 2000000 dsample-point 0.750
> > >           dtq 25 dprop-seg 7 dphase-seg1 7 dphase-seg2 5 dsjw 1 dbrp 1
> > >           tdco 15
> > >           mcp251xfd: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp_inc 1
> > >           tdco 0..127
> > >           clock 40000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus spi parentdev spi0.0
> >
> >
> > > Which is also why TDCO can be negative.
> > >
> > > I added an helper function can_tdc_get_relative_tdco() in the
> > > fourth path of this series:
> > > https://lore.kernel.org/linux-can/20210814091750.73931-5-mailhol.vincent@wanadoo.fr/T/#u
> > >
> > > Devices which use the absolute TDCO can directly use
> > > can_priv->tdc.tdco. Devices which use the relative TDCO such as
> > > the mcp251xfd should use this helper function instead.
> >
> > Don't think so....
>
> @Vincent: Perhaps you should not implement this helper function as it is only needed
> for the ESDACC so far.

Lets first wait for the response from Microchip and if indeed
mcp25xxfd does not use a relative TDCO, I am fine to remove this
from the series. In such a case, do not hesitate to steal the patch
for your ESD driver.


Yours sincerely,
Vincent
