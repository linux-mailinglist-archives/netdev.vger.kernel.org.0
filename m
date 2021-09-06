Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFBC401CDD
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 16:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243235AbhIFOTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 10:19:03 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:36371 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242521AbhIFOS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 10:18:58 -0400
Received: by mail-lj1-f169.google.com with SMTP id p15so11631809ljn.3;
        Mon, 06 Sep 2021 07:17:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2EwqJcWnHUqv05vUvZldGspuNe7xKxXkBQ2oaQaV/Ps=;
        b=VoDyMzGiQCXssI4Oo9nlFkHBRICBRyXluko9IDyB48vb/7NFLQo8H0D2PbXbvpJc0K
         F3sBJJGNOfNfcnA9MsHwwwyJnILI70W1E7k32t3zY5wg9a/qeGuzY0P+neoFwk+ZmnxV
         fyOQCn0gZb7cA5xANVVPed08Epqjjv1JarWIQ+EGsiYoHQDh8hm/DSQGE6Pzs4nRZEz9
         sLGwgGN+lhcn+Jm4oZcLgKKT0UCs5FalgJWabASZRhx3u5vcYyFBvOvMV6NcBdQML5pj
         OiXjGh1Aj4WK1A7Uku3oOJoCpjstFnEnt7FTMO5nPx67I/nZnAQE8bs6MrRacSv61ves
         rNBA==
X-Gm-Message-State: AOAM530oqKXkgACsyUGUBcN96xprccxdZ37OvxAqjyxFePB29KG3havC
        jNHcBLe5Tn0rXAxgXg4Msj6/1H8aKcR48Wn7k/TJ2Qm51qs=
X-Google-Smtp-Source: ABdhPJxZ9cXoPyU5eEgKGQ26M1q9Nd7oYzXFOVWIv3RLeYEwFqjjewpW2MXRpaKJIx2YeOAUe9l5mJRyDp1yjSRkyCM=
X-Received: by 2002:a2e:b558:: with SMTP id a24mr10799644ljn.225.1630937872011;
 Mon, 06 Sep 2021 07:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210903071704.455855-1-mailhol.vincent@wanadoo.fr> <20210906081805.dyd74xfu74gcnslg@pengutronix.de>
In-Reply-To: <20210906081805.dyd74xfu74gcnslg@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 6 Sep 2021 23:17:40 +0900
Message-ID: <CAMZ6Rq+tNxU5ePDivMdwkbZK_hyao9hSyd0DrXnF503Qk1duqw@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] can: netlink: prevent incoherent can
 configuration in case of early return
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 6 Sep 2021 at 17:18, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 03.09.2021 16:17:04, Vincent Mailhol wrote:
> > struct can_priv has a set of flags (can_priv::ctrlmode) which are
> > correlated with the other fields of the structure. In
> > can_changelink(), those flags are set first and copied to can_priv. If
> > the function has to return early, for example due to an out of range
> > value provided by the user, then the global configuration might become
> > incoherent.
> >
> > Example: the user provides an out of range dbitrate (e.g. 20
> > Mbps). The command fails (-EINVAL), however the FD flag was already
> > set resulting in a configuration where FD is on but the databittiming
> > parameters are empty.
> >
> > * Illustration of above example *
> >
> > | $ ip link set can0 type can bitrate 500000 dbitrate 20000000 fd on
> > | RTNETLINK answers: Invalid argument
> > | $ ip --details link show can0
> > | 1: can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group default qlen 10
> > |     link/can  promiscuity 0 minmtu 0 maxmtu 0
> > |     can <FD> state STOPPED restart-ms 0
> >            ^^ FD flag is set without any of the databittiming parameters...
> > |       bitrate 500000 sample-point 0.875
> > |       tq 12 prop-seg 69 phase-seg1 70 phase-seg2 20 sjw 1
> > |       ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp-inc 1
> > |       ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp-inc 1
> > |       clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> >
> > To prevent this from happening, we do a local copy of can_priv, work
> > on it, an copy it at the very end of the function (i.e. only if all
> > previous checks succeeded).
>
> I don't like the optimization of using a static priv. If it's too big to
> be allocated on the stack, allocate it on the heap, i.e. using
> kmemdup()/kfree().

The static declaration is only an issue of coding style, correct?
Or is there an actual risk of doing so?
This is for my understanding, I will remove the static
declaration regardless of your answer.

On my x86_64 machine, sizeof(priv) is 448 and if I declare priv on the stack:
| $ objdump -d drivers/net/can/dev/netlink.o | ./scripts/checkstack.pl
| 0x00000000000002100 can_changelink []:            1200

So I will allocate it on the heap.

N.B. In above figures CONFIG_CAN_LEDS is *off* because that driver
was tagged as broken in:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=30f3b42147ba6f29bc95c1bba34468740762d91b

> > Once this done, there is no more need to have a temporary variable for
> > a specific parameter. As such, the bittiming and data bittiming (bt
> > and dbt) are directly written to the temporary priv variable.
> >
> > Finally, function can_calc_tdco() was retrieving can_priv from the
> > net_device and directly modifying it. We changed the prototype so that
> > it instead writes its changes into our temporary priv variable.
>
> Is it possible to split this into a separate patch, so that the part
> without the tdco can be backported more easily to older kernels not
> having tdco? The patch fixing the tdco would be the 2nd patch...

ACK. I will send a v3 with that split.

> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> > Resending because I got no answers on:
> > https://lore.kernel.org/linux-can/20210823024750.702542-1-mailhol.vincent@wanadoo.fr/T/#u
> > (I guess everyone bas busy with the upcoming merge window)
>
> Busy yes, but not with the merge window :)
>
> > I am not sure whether or not this needs a "Fixes" tag. Just in case,
> > there it is:
> >
> > Fixes: 9859ccd2c8be ("can: introduce the data bitrate configuration for CAN FD")
>
> ...if it's possible to split this patch into 2 parts, add individual
> fixes tags to them.

ACK.


> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
