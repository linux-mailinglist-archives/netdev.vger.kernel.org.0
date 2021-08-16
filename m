Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A995B3EDADC
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhHPQZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:25:24 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:46614 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhHPQZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 12:25:23 -0400
Received: by mail-lf1-f53.google.com with SMTP id u22so4438186lfq.13;
        Mon, 16 Aug 2021 09:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s93ltM4zeu3R7G1YVItjZfKBrTogP9A0kwUGbOD185A=;
        b=PYWOIfjyaa7IGIVvJPwEbzJO0fF8lXGiyQegBqWI+dPQKUBsAiQdCsUoJMGxwNr2Xq
         1bOkSA57PZjlhZyoOlyJlCHrEU2HFMeY6Cy4isA8VFM1BFGqf1uYrdyDulCMvTbX/0Y2
         EIxOZUg4wuqti346RuUsO3uUzNLAdXWUIgRvaqM5pQvBVqBM3hXGDUq4dEcEg2NauVvw
         esMnz8QVQb6gaxKhucLmGikWASQ8yIyRcxWRSy3h8g9HBel5UwaRVu/f/23wJa4SqvGs
         uNIDj/IS1JoOgFu1P/lQbb6LsJrJ41+gUSWG3lITWALyVPUrqH1+juX+U4ThsyaNxZsH
         iu4g==
X-Gm-Message-State: AOAM530QUQaflvrk/2VYC9yO8V4f64iTMVbbbOGy0iCLrKgULN4kpr09
        LI5gB5InB9/XuXL/FG6qdr6WR5B+R797hqSyYIk=
X-Google-Smtp-Source: ABdhPJzrsn4wxNTabNUj4ff0PEc8kZJtcWUijoWNm1I1HNZCwLiongiQk5FGituS7ZgRN02b9SlLBYvMN6Wuk62hN54=
X-Received: by 2002:ac2:5d27:: with SMTP id i7mr12269045lfb.488.1629131090133;
 Mon, 16 Aug 2021 09:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
 <20210814101728.75334-5-mailhol.vincent@wanadoo.fr> <20210816135113.gpk3fpafiqnhjbw4@pengutronix.de>
In-Reply-To: <20210816135113.gpk3fpafiqnhjbw4@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 Aug 2021 01:24:38 +0900
Message-ID: <CAMZ6RqL8h5U+qZLS23PHCYNZ3Nq+9_sUQ5jTG=G0VRsaYXbbUQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] iplink_can: add new CAN FD bittiming parameters:
 Transmitter Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 16 Aug. 2021 at 22:51, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 14.08.2021 19:17:28, Vincent Mailhol wrote:
> > At high bit rates, the propagation delay from the TX pin to the RX pin
> > of the transceiver causes measurement errors: the sample point on the
> > RX pin might occur on the previous bit.
> >
> > This issue is addressed in ISO 11898-1 section 11.3.3 "Transmitter
> > delay compensation" (TDC).
> >
> > This patch brings command line support to nine TDC parameters which
> > were recently added to the kernel's CAN netlink interface in order to
> > implement TDC:
> >   - IFLA_CAN_TDC_TDCV_MIN: Transmitter Delay Compensation Value
> >     minimum value
> >   - IFLA_CAN_TDC_TDCV_MAX: Transmitter Delay Compensation Value
> >     maximum value
> >   - IFLA_CAN_TDC_TDCO_MIN: Transmitter Delay Compensation Offset
> >     minimum value
> >   - IFLA_CAN_TDC_TDCO_MAX: Transmitter Delay Compensation Offset
> >     maximum value
> >   - IFLA_CAN_TDC_TDCF_MIN: Transmitter Delay Compensation Filter
> >     window minimum value
> >   - IFLA_CAN_TDC_TDCF_MAX: Transmitter Delay Compensation Filter
> >     window maximum value
> >   - IFLA_CAN_TDC_TDCV: Transmitter Delay Compensation Value
> >   - IFLA_CAN_TDC_TDCO: Transmitter Delay Compensation Offset
> >   - IFLA_CAN_TDC_TDCF: Transmitter Delay Compensation Filter window
> >
> > All those new parameters are nested together into the attribute
> > IFLA_CAN_TDC.
> >
> > A tdc-mode parameter allow to specify how to operate. Valid options
> > are:
> >
> >   * auto: the transmitter automatically measures TDCV. As such, TDCV
> >     values can not be manually provided. In this mode, the user must
> >     specify TDCO and may also specify TDCF if supported.
> >
> >   * manual: Use the TDCV value provided by the user are used. In this
> >     mode, the user must specify both TDCV and TDCO and may also
> >     specify TDCF if supported.
> >
> >   * off: TDC is explicitly disabled.
> >
> >   * tdc-mode parameter omitted (default mode): the kernel decides
> >     whether TDC should be enabled or not and if so, it calculates the
> >     TDC values. TDC parameters are an expert option and the average
> >     user is not expected to provide those, thus the presence of this
> >     "default mode".
> >
> > TDCV is always reported in manual mode. In auto mode, TDCV is reported
> > only if the value is available. Especially, the TDCV might not be
> > available if the controller has no feature to report it or if the
> > value in not yet available (i.e. no data sent yet and measurement did
> > not occur).
> >
> > TDCF is reported only if tdcf_max is not zero (i.e. if supported by the controller).
> >
> > For reference, here are a few samples of how the output looks like:
> >
> > $ ip link set can0 type can bitrate 1000000 dbitrate 8000000 fd on tdco 7 tdcf 8 tdc-mode auto
> >
> > $ ip --details link show can0
> > 1:  can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group default qlen 10
> >     link/can  promiscuity 0 minmtu 0 maxmtu 0
> >     can <FD,TDC_AUTO> state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
>               ^^^^^^^^
> This is just the supported mode(s), right?

No, this is the active mode. It should display either TDC_AUTO or
TDC_MANUAL. If both are displayed as you previously experienced,
it is a bug (I will fix).

> >         bitrate 1000000 sample-point 0.750
> >         tq 12 prop-seg 29 phase-seg1 30 phase-seg2 20 sjw 1 brp 1
> >         ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
> >         dbitrate 8000000 dsample-point 0.700
> >         dtq 12 dprop-seg 3 dphase-seg1 3 dphase-seg2 3 dsjw 1 dbrp 1
> >         tdco 7 tdcf 8
> >         ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp_inc 1
> >         tdco 0..127 tdcf 0..127
> >         clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>
> Is there a way to figure out, which tdc mode is currently active?
>
> AFAICS just implicitly:
> - tdco + tdcv   -> manual
> - tdco          -> automatic
> - neither       -> off
>
> correct?

If the TDC const values are reported (at least tdco) the controller
supports TDC.

The flags listed between brackets <FD, TDC_AUTO, CC-LEN8-DLC, ...>
are the active flags (this is not only true for TDC but also for
all other ctrlmodes).

There is no way to know which of the modes are supported. The
reason is that netlink only reports
can_priv->ctrlmode (c.f. IFLA_CAN_CTRLMODE), not
can_priv->ctrlmode_supported. We would need to add a
IFLA_CAN_CTRLMODE_SUPPORTED to the netlink interface in order to
confirm the supported mode.

Currently, the only ways are to either look at the kernel source
code or to test the command and see whether it is supported or
not.


Yours sincerely,
Vincent
