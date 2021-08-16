Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E1E3EDA42
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbhHPP4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:56:19 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:34366 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbhHPPuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:50:19 -0400
Received: by mail-lf1-f45.google.com with SMTP id z2so35435641lft.1;
        Mon, 16 Aug 2021 08:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1RrMYnjLcEjbaWCeYQWEl72GHA2LIxAj1CAuE6WyvjU=;
        b=N+8ws2WcfYOXkQWM3B9pHu6q6hPGnPv5iQlRruDCw421g/YQm8lSguKPkkWQ986pjU
         omimytkXE+uw8YsOSwzyGjpS8ZIT6NDlfPXDhpwzuhjbRMcD0y/WTChRX8wEGRPRWzpT
         j67x5SrrVFK55qPB7uUSaO2Ag9qa2jOT+hwPuAM4pkIV+ooGGFMmObaWIyHRR37GxusH
         Mm+n9ZAsfZNqMp3XTnCF9YydmYSATc11XAiR4x93Nk+kWa4eYcpW37u+IWfBlbF9cjb7
         nwVCZkuaih4B81YTNZpGXYn2PwdgA+j9VN0Hd08no9MsWigTJiphHewEMROGsvnbklML
         ue9w==
X-Gm-Message-State: AOAM532ho+zSdvwd/rYLibtQYBjcrNcdmdYmaDrMAz1FlC6bNLiTkxCO
        IgBvIqzSOxqGZ2nU0JWSI6YlS31BisXe/2xpXVc=
X-Google-Smtp-Source: ABdhPJxLm5wNO6rjdv1vpYb147NxYSvsj/uTA47/uByyf/y6TKWv4ytocrDnjX95VFZvivzWIKU0Tv3S+K8vQr5Ug6Q=
X-Received: by 2002:a05:6512:a84:: with SMTP id m4mr12180928lfu.393.1629128986570;
 Mon, 16 Aug 2021 08:49:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr> <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de> <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <20210816134342.w3bc5zjczwowcjr4@pengutronix.de>
In-Reply-To: <20210816134342.w3bc5zjczwowcjr4@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 Aug 2021 00:49:35 +0900
Message-ID: <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
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

On Mon. 16 Aug 2021 at 22:43, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 16.08.2021 14:33:09, Marc Kleine-Budde wrote:
> > On 16.08.2021 14:25:19, Marc Kleine-Budde wrote:
> > ...
> The following sequence doesn't clear "tdcv" properly:
>
> | ip link set dev mcp251xfd0 down; \
> | ip link set mcp251xfd0 txqueuelen 10 up type can \
> |     sample-point 0.8 bitrate 500000  \
> |     dsample-point 0.8 dbitrate 2000000 fd on \
> |     tdc-mode manual tdco 11 tdcv 22
> |
> | ip link set dev mcp251xfd0 down; \
> | ip link set mcp251xfd0 txqueuelen 10 up type can \
> |     sample-point 0.8 bitrate 500000  \
> |     dsample-point 0.8 dbitrate 2000000 fd on
>
> | Aug 16 15:10:43 rpi4b8 kernel: mcp251xfd spi0.0 mcp251xfd0: mcp251xfd_set_bittiming: tdco=11 tdcv=22 mode=manual
> | Aug 16 15:10:43 rpi4b8 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): mcp251xfd0: link becomes ready
> | Aug 16 15:10:59 rpi4b8 kernel: mcp251xfd spi0.0 mcp251xfd0: mcp251xfd_set_bittiming: tdco=16 tdcv=22 mode=automatic
> | Aug 16 15:10:59 rpi4b8 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): mcp251xfd0: link becomes ready

This is intended. Documentation of can_tdc::tdcv states that:
 *      CAN_CTRLMODE_TDC_AUTO is set: The transceiver dynamically
 *      measures @tdcv for each transmitted CAN FD frame and the
 *      value provided here should be ignored.

And indeed, here you are in automatic mode, so can_tdc::tdcv
should be ignored. And, if you do:

| ip --details link show mcp251xfd0

TDCV should not be reported (unless you implemented the callback
function do_get_auto_tdcv(), in which case, it will report
whatever value was measured by your controller).

> neither does "tdc-mode off":
>
> | Aug 16 15:12:18 rpi4b8 kernel: mcp251xfd spi0.0 mcp251xfd0: mcp251xfd_set_bittiming: tdco=11 tdcv=22 mode=off
> | Aug 16 15:12:18 rpi4b8 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): mcp251xfd0: link becomes ready

Same here. can_tdc doc reads:
 *    N.B. CAN_CTRLMODE_TDC_AUTO and CAN_CTRLMODE_TDC_MANUAL are
 *    mutually exclusive. Only one can be set at a time. If both
 *    CAN_TDC_CTRLMODE_AUTO and CAN_TDC_CTRLMODE_MANUAL are unset,
 *    TDC is disabled and all the values of this structure should be
 *    ignored.

Indeed, both CAN_TDC_CTRLMODE_{AUTO,MANUAL} are unset so all the
fields of can_tdc shall be ignored. You can also confirm that the
netlink interface does not report any tof he TDC parameters.

That said, if you want me to clear the garbage values, I can do
so. I will just add some code with no actual purpose to the
netlink interface.

> ---
>
> We have 4 operations:
> - tdc-mode off                  switch off tdc altogether
> - tdc-mode manual tdco X tdcv Y configure X and Y for tdco and tdcv
> - tdc-mode auto tdco X          configure X tdco and
>                                 controller measures tdcv automatically
> - /* nothing */                 configure default value for tdco
>                                 controller measures tdcv automatically

The "nothing" does one more thing: it decides whether TDC should
be activated or not.

> The /* nothing */ operation is what the old "ip" tool does, so we're
> backwards compatible here (using the old "ip" tool on an updated
> kernel/driver).

That's true but this isn't the real intent. By doing this design,
I wanted the user to be able to transparently use TDC while
continuing to use the exact same ip commands she or he is used
to using.

> At first glance it's a bit non-intuitive that you have to specify
> nothing for the "full" automatic mode.

I have the opposite opinion: at the end, the TDC is no more than
one other bittiming parameter. The current interface requires, at
minimum, to turn "fd" flag on and to specify the dbittiming and
voila. I want to keep the number of required command line to a
minimum. This way, the TL;DR users would still get a working
environment on CAN buses with high bitrates.

For example, when you want the sample-point to be automatically
calculated, you give "nothing". You do not have to
state "sample-point auto" or anything else. I want the same for
the TDC.

> Oh, I just noticed:
>
> | ip link set dev mcp251xfd0 down; \
> | ip link set mcp251xfd0 txqueuelen 10 up type can \
> |     sample-point 0.8 bitrate 500000  \
> |     dsample-point 0.8 dbitrate 2000000 fd on \
> |     tdc-mode manual tdco 11 tdcv 22
>
> followed by:
>
> | ip link set dev mcp251xfd0 down; \
> | ip link set mcp251xfd0 txqueuelen 10 up type can
>
> We stay in manual mode:
>
> | Aug 16 15:27:47 rpi4b8 kernel: mcp251xfd spi0.0 mcp251xfd0: mcp251xfd_set_bittiming: tdco=11 tdcv=22 mode=manual
>
> | 8: mcp251xfd0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
> |     link/can  promiscuity 0 minmtu 0 maxmtu 0
> |     can <FD,TDC_AUTO,TDC_MANUAL> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 100

That's a bug. It should be impossible to have both TDC_AUTO and
TDC_MANUAL at the same time.

> |           bitrate 500000 sample-point 0.800
> |           tq 25 prop-seg 31 phase-seg1 32 phase-seg2 16 sjw 1 brp 1
> |           mcp251xfd: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp_inc 1
> |           dbitrate 2000000 dsample-point 0.800
> |           dtq 25 dprop-seg 7 dphase-seg1 8 dphase-seg2 4 dsjw 1 dbrp 1
> |           tdcv 22 tdco 11
> |           mcp251xfd: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp_inc 1
> |           tdcv 0..63 tdco 0..63
> |           clock 40000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus spi parentdev spi0.0

Sorry, but can I confirm what you did here? You stated that you
did those four commands in this order:

> | ip link set dev mcp251xfd0 down; \
> | ip link set mcp251xfd0 txqueuelen 10 up type can \
> |     sample-point 0.8 bitrate 500000  \
> |     dsample-point 0.8 dbitrate 2000000 fd on \
> |     tdc-mode manual tdco 11 tdcv 22
> | ip link set dev mcp251xfd0 down; \
> | ip link set mcp251xfd0 txqueuelen 10 up type can

So now, you should be in Classical CAN (fd flag off) but the
results of iproute2 shows that FD is on... Is there one missing
step?

> I have to give "fd on" + the bit timing parameters to go to the full
> automatic mode again:
>
> | Aug 16 15:32:46 rpi4b8 kernel: mcp251xfd spi0.0 mcp251xfd0: mcp251xfd_set_bittiming: tdco=16 tdcv=22 mode=automatic
>
>
> Does it make sense to let "mode auto" without a tdco value switch the
> controller into full automatic mode and /* nothing */ not tough the tdc
> config at all? If the full automatic mode is power on default mode, then
> new kernel/drivers are compatible with old the old ip tool.

If we do so, some users will forget to turn it on. Now, this
might not be a big issue, but in the near future, when CAN buses
with high bitrate (4M or more) reach production, you will start
to see complains online of users not understanding why they get
errors on their bus (because the average user will have no clue
of what TDC is). I tried to propose the most dummy proofed
approach (the compatibility with old ip tools is not the goal).

> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
