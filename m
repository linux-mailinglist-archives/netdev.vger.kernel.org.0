Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576403EE0A0
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhHQAAk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Aug 2021 20:00:40 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:34362 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbhHQAAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:00:39 -0400
Received: by mail-lf1-f42.google.com with SMTP id z2so37900010lft.1;
        Mon, 16 Aug 2021 17:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=601QTk9x8q1XOYs3oKrDgDv7STyt52GrIGTI0Goheng=;
        b=rx7wlZvee1Ar4ZYym104Rm1nVY8TvY1O1Qji1a4tWVsYxv7ho+ukeEDx5gwdUDh+6B
         ZYndH9VSWKY/SCMHwXwSF1AyGx44ffhQb7hFbdzt9FPeYqflHVwQzAyc/pbEZq9uZnK/
         chB4TLELYS2L5NbSNRZ9JnXbocWcM8uxIRXYf0Sto3Z7hvY2OW04PmQma/w9tjZ66+Fx
         yeYY9jx/FzYaKHx9xs53mot613h+Ubq+4RcabP+aIpefXKAfOay0gJ9l3u9R5moyCLUF
         M1YtNPl97g6EZ/LPONpe0gDgCn7C6BXIbvD8KQ3e5H+NU5A+izHNnD/TOXgs0GD6hUzn
         WbiA==
X-Gm-Message-State: AOAM530HcJhNKiTEnhPgGkOBlwCl+dO/oa06Ua2gnzPmhorYrqwgWA3q
        eFv9Q2EnDvVDj6OkRTfAGw2Ba0dSyNhPPvDN+7A=
X-Google-Smtp-Source: ABdhPJxXKDQqlq7gKz6qrbx8m1xu2lpcJQywJ/BUK6IeoSstTMAqyuNhJj1/VwH/cn54/4LNxST9O1xbSeP7WWSt/ww=
X-Received: by 2002:ac2:5ec7:: with SMTP id d7mr268462lfq.234.1629158405947;
 Mon, 16 Aug 2021 17:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
 <20210814101728.75334-5-mailhol.vincent@wanadoo.fr> <20210816135113.gpk3fpafiqnhjbw4@pengutronix.de>
 <CAMZ6RqL8h5U+qZLS23PHCYNZ3Nq+9_sUQ5jTG=G0VRsaYXbbUQ@mail.gmail.com>
In-Reply-To: <CAMZ6RqL8h5U+qZLS23PHCYNZ3Nq+9_sUQ5jTG=G0VRsaYXbbUQ@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 Aug 2021 08:59:54 +0900
Message-ID: <CAMZ6RqJd7Mhg4sJnV+r_1bztiqLAS1oTTzg5cWWEpe4nnupXvw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] iplink_can: add new CAN FD bittiming parameters:
 Transmitter Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue.17 Aug 2021 à 01:24, Vincent MAILHOL <mailhol.vincent@wanadoo.fr> wrote:
> On Mon. 16 Aug. 2021 at 22:51, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > On 14.08.2021 19:17:28, Vincent Mailhol wrote:
> > > At high bit rates, the propagation delay from the TX pin to the RX pin
> > > of the transceiver causes measurement errors: the sample point on the
> > > RX pin might occur on the previous bit.
> > >
> > > This issue is addressed in ISO 11898-1 section 11.3.3 "Transmitter
> > > delay compensation" (TDC).
> > >
> > > This patch brings command line support to nine TDC parameters which
> > > were recently added to the kernel's CAN netlink interface in order to
> > > implement TDC:
> > >   - IFLA_CAN_TDC_TDCV_MIN: Transmitter Delay Compensation Value
> > >     minimum value
> > >   - IFLA_CAN_TDC_TDCV_MAX: Transmitter Delay Compensation Value
> > >     maximum value
> > >   - IFLA_CAN_TDC_TDCO_MIN: Transmitter Delay Compensation Offset
> > >     minimum value
> > >   - IFLA_CAN_TDC_TDCO_MAX: Transmitter Delay Compensation Offset
> > >     maximum value
> > >   - IFLA_CAN_TDC_TDCF_MIN: Transmitter Delay Compensation Filter
> > >     window minimum value
> > >   - IFLA_CAN_TDC_TDCF_MAX: Transmitter Delay Compensation Filter
> > >     window maximum value
> > >   - IFLA_CAN_TDC_TDCV: Transmitter Delay Compensation Value
> > >   - IFLA_CAN_TDC_TDCO: Transmitter Delay Compensation Offset
> > >   - IFLA_CAN_TDC_TDCF: Transmitter Delay Compensation Filter window
> > >
> > > All those new parameters are nested together into the attribute
> > > IFLA_CAN_TDC.
> > >
> > > A tdc-mode parameter allow to specify how to operate. Valid options
> > > are:
> > >
> > >   * auto: the transmitter automatically measures TDCV. As such, TDCV
> > >     values can not be manually provided. In this mode, the user must
> > >     specify TDCO and may also specify TDCF if supported.
> > >
> > >   * manual: Use the TDCV value provided by the user are used. In this
> > >     mode, the user must specify both TDCV and TDCO and may also
> > >     specify TDCF if supported.
> > >
> > >   * off: TDC is explicitly disabled.
> > >
> > >   * tdc-mode parameter omitted (default mode): the kernel decides
> > >     whether TDC should be enabled or not and if so, it calculates the
> > >     TDC values. TDC parameters are an expert option and the average
> > >     user is not expected to provide those, thus the presence of this
> > >     "default mode".
> > >
> > > TDCV is always reported in manual mode. In auto mode, TDCV is reported
> > > only if the value is available. Especially, the TDCV might not be
> > > available if the controller has no feature to report it or if the
> > > value in not yet available (i.e. no data sent yet and measurement did
> > > not occur).
> > >
> > > TDCF is reported only if tdcf_max is not zero (i.e. if supported by the controller).
> > >
> > > For reference, here are a few samples of how the output looks like:
> > >
> > > $ ip link set can0 type can bitrate 1000000 dbitrate 8000000 fd on tdco 7 tdcf 8 tdc-mode auto
> > >
> > > $ ip --details link show can0
> > > 1:  can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group default qlen 10
> > >     link/can  promiscuity 0 minmtu 0 maxmtu 0
> > >     can <FD,TDC_AUTO> state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
> >               ^^^^^^^^
> > This is just the supported mode(s), right?
>
> No, this is the active mode. It should display either TDC_AUTO or
> TDC_MANUAL. If both are displayed as you previously experienced,
> it is a bug (I will fix).
>
> > >         bitrate 1000000 sample-point 0.750
> > >         tq 12 prop-seg 29 phase-seg1 30 phase-seg2 20 sjw 1 brp 1
> > >         ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
> > >         dbitrate 8000000 dsample-point 0.700
> > >         dtq 12 dprop-seg 3 dphase-seg1 3 dphase-seg2 3 dsjw 1 dbrp 1
> > >         tdco 7 tdcf 8
> > >         ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp_inc 1
> > >         tdco 0..127 tdcf 0..127
> > >         clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> >
> > Is there a way to figure out, which tdc mode is currently active?
> >
> > AFAICS just implicitly:
> > - tdco + tdcv   -> manual
> > - tdco          -> automatic
> > - neither       -> off
> >
> > correct?
>
> If the TDC const values are reported (at least tdco) the controller
> supports TDC.
>
> The flags listed between brackets <FD, TDC_AUTO, CC-LEN8-DLC, ...>
> are the active flags (this is not only true for TDC but also for
> all other ctrlmodes).
>
> There is no way to know which of the modes are supported. The
> reason is that netlink only reports
> can_priv->ctrlmode (c.f. IFLA_CAN_CTRLMODE), not
> can_priv->ctrlmode_supported. We would need to add a
> IFLA_CAN_CTRLMODE_SUPPORTED to the netlink interface in order to
> confirm the supported mode.

On a second thought, it is actually possible to deduce some of
the supported modes (not all) through the can_tdc_const values
because tdcv_{min,max} are only reported if
CAN_CTRLMODE_TDC_MANUAL is supported.
So:

  - both tdcv_{min,max} and tdco_{min,max} reported ->
    CAN_CTRLMODE_TDC_MANUAL is supported for
    sure. CAN_CTRLMODE_TDC_AUTO might or might not be supported.

  - only tdco_{min,max} reported -> only CAN_CTRLMODE_TDC_AUTO is
    supported (that's the case for the es58x device).

  - none reported -> device is not TDC capable.

  - tdcf_{min,max} reported -> device supports TDCF and the
    reverse is also true.

  - other combinations are incorrect and should not be reported.

> Currently, the only ways are to either look at the kernel source
> code or to test the command and see whether it is supported or
> not.
>
>
> Yours sincerely,
> Vincent
