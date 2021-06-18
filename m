Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162933ACD77
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhFROaP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Jun 2021 10:30:15 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:44641 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhFROaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:30:14 -0400
Received: by mail-lj1-f180.google.com with SMTP id d2so14288161ljj.11;
        Fri, 18 Jun 2021 07:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UBoh1jmBuVPR6JwKtiqhFyNi/ivq1pysrv5qHXiGQLQ=;
        b=M2WlcGE9gyLdpSSoi3B2hIDn9eGDMoJLpujGGzM61l4d6oAj9rxa3SBspsCdEwwhcc
         P8P+S9Ds9vzyP44M8M8RvOeZ+ZoJoHriHwick8pXH69Zt5WI71YHjR7e2RBHxkFlinV1
         TPkLtxLtMxYKK4GRsIW23K88fr837jsVuzHDW3ujIYl9AxongYTuHYzi6R8DO2WPTnUD
         A1eLhV82nHoqTOxLB/n8vJKeRh2bUaCZ8gLf4HC2xyh812MoRVWR20fbTbSVnXFkMOCd
         +sBgR8qilaO+xI+8j65cJX1GNSCD+rBVe9KFErFRtLRcdtIs4D1bXstXf7r6z8EkiVdu
         Lrgg==
X-Gm-Message-State: AOAM530b0vxM5tF5FHT99k07161PY5NMAzKY8yI3qpJJ1GFZMEL0JsUN
        +r6enbd0VBIa0ZKPMd4+LvIN2SDNeggkO/eeQt8=
X-Google-Smtp-Source: ABdhPJwtzLC0kznSOUto6wgZpYrSEnYo1butXso9RvSLb4S7NH7Yp8IoW54JtBsqXzVmsJoUJpJztw46iYqcfxMrSSU=
X-Received: by 2002:a2e:9016:: with SMTP id h22mr7590517ljg.331.1624026483866;
 Fri, 18 Jun 2021 07:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr> <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
 <CAMZ6RqJn5z-9PfkcJdiS6aG+qCPnifXDwH26ZEwo8-=id=TXbw@mail.gmail.com>
 <CAMZ6RqKrPQkPy-dAiQjAB4aKnqeaNx+L-cro8F_mc2VPgOD4Jw@mail.gmail.com> <20210618124447.47cy7hyqp53d4tjh@pengutronix.de>
In-Reply-To: <20210618124447.47cy7hyqp53d4tjh@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 18 Jun 2021 23:27:52 +0900
Message-ID: <CAMZ6RqJCZB6Q79JYfxD7PGboPwMndDQRKsuUEk5Q34fj2vOcYg@mail.gmail.com>
Subject: Re: CAN-FD Transmitter Delay Compensation (TDC) on mcp2518fd
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Kopp <thomas.kopp@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 18 Jun 2021 at 21:44, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 18.06.2021 20:17:51, Vincent MAILHOL wrote:
> > > > I just noticed in the mcp2518fd data sheet:
> > > >
> > > > | bit 14-8 TDCO[6:0]: Transmitter Delay Compensation Offset bits;
> > > > | Secondary Sample Point (SSP) Two’s complement; offset can be positive,
> > > > | zero, or negative.
> > > > |
> > > > | 011 1111 = 63 x TSYSCLK
> > > > | ...
> > > > | 000 0000 = 0 x TSYSCLK
> > > > | ...
> > > > | 111 1111 = –64 x TSYSCLK
> > > >
> > > > Have you takes this into account?
> > >
> > > I have not. And I fail to understand what would be the physical
> > > meaning if TDCO is zero or negative.
>
> The mcp25xxfd family data sheet says:
>
> | SSP = TDCV + TDCO
>
> > > TDCV indicates the position of the bit start on the RX pin.
>
> If I understand correctly in automatic mode TDCV is measured by the CAN
> controller and reflects the transceiver delay.

Yes. I phrased it poorly but this is what I wanted to say. It is
the delay to propagate from the TX pin to the RX pin.

If TDCO = 0 then SSP = TDCV + 0 = TDCV thus the measurement
occurs at the bit start on the RX pin.

> I don't know why you want
> to subtract a time from that....
>
> The rest of the relevant registers:
>
> | TDCMOD[1:0]: Transmitter Delay Compensation Mode bits; Secondary Sample Point (SSP)
> | 10-11 = Auto; measure delay and add TDCO.
> | 01 = Manual; Do not measure, use TDCV + TDCO from register
> | 00 = TDC Disabled
> |
> | TDCO[6:0]: Transmitter Delay Compensation Offset bits; Secondary Sample Point (SSP)
> | Two’s complement; offset can be positive, zero, or negative.
> | 011 1111 = 63 x TSYSCLK
> | ...
> | 000 0000 = 0 x TSYSCLK
> | ...
> | 111 1111 = –64 x TSYSCLK
> |
> | TDCV[5:0]: Transmitter Delay Compensation Value bits; Secondary Sample Point (SSP)
> | 11 1111 = 63 x TSYSCLK
> | ...
> | 00 0000 = 0 x TSYSCLK

Aside from the negative TDCO, the rest is standard stuff. We can
note the absence of the TDCF but that's not a blocker.

> > > If TDCO is zero, the measurement occurs on the bit start when all
> > > the ringing occurs. That is a really bad choice to do the
> > > measurement. If it is negative, it means that you are measuring the
> > > previous bit o_O !?
>
> I don't know...
>
> > > Maybe I am missing something but I just do not get it.
> > >
> > > I believe you started to implement the mcp2518fd.
>
> No I've just looked into the register description.

OK. For your information, the ETAS ES58x FD devices do not allow
the use of manual mode for TDCV. The microcontroller from
Microchip supports it but ETAS firmware only exposes the
automatic TDCV mode. So it can not be used to test what would
occur if SSP = 0.

I will prepare a patch to allow zero value for both TDCV and
TDCO (I am a bit sad because I prefer the current design, but if
ISO allows it, I feel like I have no choice).  However, I refuse
to allow the negative TDCO value unless someone is able to
explain the rationale.


Yours sincerely,
Vincent
