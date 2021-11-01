Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05541441AFA
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 13:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhKAMIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 08:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhKAMIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 08:08:37 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB71CC061714;
        Mon,  1 Nov 2021 05:06:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x66so16107074pfx.13;
        Mon, 01 Nov 2021 05:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/4lV8dXREEDTKjadq2AlC/ht+JUEqVf4ehoa9s9n110=;
        b=MMBknp7hqQRp2J0DnaKuUC3wqZX1+V/CKZA/AcX3F8azcoytMQd/dTqwMIftsCeMBa
         oWgGR8HYwl+UIHCfoEVhZNhd6C8MUJTiZz2Ahw1F+lD+VIhZyTWp5wpkhIARM+yEMaY0
         3bfALpuLwDjh++Q7pg35vOTfk73il7E0WISNNS8VC1gJW7VI299Wh7OMb8OphsY3KaV+
         Tf6Rs6eK30TF39Kw+Vq4ZClDtuy6z627m5mQlYB2HT++Mpy/PoCbGIJW9WhG5HzAB4bX
         UF2e5OSVGcuSUpnv0302eBpWNoqFBOI2NsDuGDzyM7VZqnIcwb2ZI7vXkfL+6NtGgQVB
         f8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/4lV8dXREEDTKjadq2AlC/ht+JUEqVf4ehoa9s9n110=;
        b=pdclBF6NJNoApD1+54h3sNTEbZGP7SlXQnaMPDQ5MRWm79EFqmTy8Uq0FxsGWw83t8
         P/Rk1B1r9uqtz4RuexSw/Gm8iaA4O47wBEx0NR7Aoanf+HHulOd05eetSRgB3H/WRRBM
         CA1mVe3beWc7/Hhq4jSqU5Y/bVW+ZZVmKEofXn054hyJ1VMXrk3Gt+8UfNtK/W2Ox7kn
         SPtpIeMmG2Td1mR7MlQGLMefrdr/llYJFhW6fKTxdEzfrtweQEIVOIUHWWeH+Ule6MOs
         i2zbO2MCNaYhUAPi2++d67Qy8Khgwh7VkWLpm2YJVGDJTivdpfWIafUbeh931A0kkcoS
         YAnQ==
X-Gm-Message-State: AOAM533Ygb4yqAAx9ZxFGgzxaSQWDheM1wRSgXJG7Ne3setavwVlG04t
        yCBzK0WBEBVWoa7lOcOikfB0PDSgIHSJaTqkkV8=
X-Google-Smtp-Source: ABdhPJzFdonX2WyPMlZCEDCCeGdFvZUMkPByGrf71dhpS4JF8mhN/f40eW8/Ef19l2PRZ+VAwroxicnyDIXaJ5Aopns=
X-Received: by 2002:a05:6a00:801:b0:47d:9dc8:5751 with SMTP id
 m1-20020a056a00080100b0047d9dc85751mr28460629pfk.32.1635768363292; Mon, 01
 Nov 2021 05:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211101092134.3357661-1-bigunclemax@gmail.com> <717f9769-aac5-d005-e15a-a6a2ff61bb69@ti.com>
In-Reply-To: <717f9769-aac5-d005-e15a-a6a2ff61bb69@ti.com>
From:   Maxim Kiselev <bigunclemax@gmail.com>
Date:   Mon, 1 Nov 2021 15:05:23 +0300
Message-ID: <CALHCpMg1fHjZFfkEnFmUUrvDLFweQ-4aLX4k2hy24hRm2KiAYA@mail.gmail.com>
Subject: Re: [PATCH] net: davinci_emac: Fix interrupt pacing disable
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Michael Walle <michael@walle.cc>, Sriram <srk@ti.com>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I can write 0 to INTCTRL for ` case EMAC_VERSION_2` but we also
need to handle `default case`

=D0=BF=D0=BD, 1 =D0=BD=D0=BE=D1=8F=D0=B1. 2021 =D0=B3. =D0=B2 14:54, Grygor=
ii Strashko <grygorii.strashko@ti.com>:
>
>
>
> On 01/11/2021 11:21, Maxim Kiselev wrote:
> > This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
> > disable rx irq coalescing.
> >
> > Previously we could enable rx irq coalescing via ethtool
> > (For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
> > it because this part rejects 0 value:
> >
> >         if (!coal->rx_coalesce_usecs)
> >                 return -EINVAL;
> >
> > Fixes: 84da2658a619 ("TI DaVinci EMAC : Implement interrupt pacing
> > functionality.")
> >
> > Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
> > ---
> >   drivers/net/ethernet/ti/davinci_emac.c | 77 ++++++++++++++-----------=
-
> >   1 file changed, 41 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ether=
net/ti/davinci_emac.c
> > index e8291d8488391..a3a02c4e5eb68 100644
> > --- a/drivers/net/ethernet/ti/davinci_emac.c
> > +++ b/drivers/net/ethernet/ti/davinci_emac.c
> > @@ -417,46 +417,47 @@ static int emac_set_coalesce(struct net_device *n=
dev,
> >                            struct netlink_ext_ack *extack)
> >   {
> >       struct emac_priv *priv =3D netdev_priv(ndev);
> > -     u32 int_ctrl, num_interrupts =3D 0;
> > +     u32 int_ctrl =3D 0, num_interrupts =3D 0;
> >       u32 prescale =3D 0, addnl_dvdr =3D 1, coal_intvl =3D 0;
> >
> > -     if (!coal->rx_coalesce_usecs)
> > -             return -EINVAL;
> > -
> >       coal_intvl =3D coal->rx_coalesce_usecs;
>
> Wouldn't be more simple if you just handle !coal->rx_coalesce_usecs here =
and exit?
> it seems you can just write 0 t0 INTCTRL.
>
> >
> >       switch (priv->version) {
> >       case EMAC_VERSION_2:
> > -             int_ctrl =3D  emac_ctrl_read(EMAC_DM646X_CMINTCTRL);
> > -             prescale =3D priv->bus_freq_mhz * 4;
> > -
> > -             if (coal_intvl < EMAC_DM646X_CMINTMIN_INTVL)
> > -                     coal_intvl =3D EMAC_DM646X_CMINTMIN_INTVL;
> > -
> > -             if (coal_intvl > EMAC_DM646X_CMINTMAX_INTVL) {
> > -                     /*
> > -                      * Interrupt pacer works with 4us Pulse, we can
> > -                      * throttle further by dilating the 4us pulse.
> > -                      */
> > -                     addnl_dvdr =3D EMAC_DM646X_INTPRESCALE_MASK / pre=
scale;
> > -
> > -                     if (addnl_dvdr > 1) {
> > -                             prescale *=3D addnl_dvdr;
> > -                             if (coal_intvl > (EMAC_DM646X_CMINTMAX_IN=
TVL
> > -                                                     * addnl_dvdr))
> > -                                     coal_intvl =3D (EMAC_DM646X_CMINT=
MAX_INTVL
> > -                                                     * addnl_dvdr);
> > -                     } else {
> > -                             addnl_dvdr =3D 1;
> > -                             coal_intvl =3D EMAC_DM646X_CMINTMAX_INTVL=
;
> > +             if (coal->rx_coalesce_usecs) {
> > +                     int_ctrl =3D  emac_ctrl_read(EMAC_DM646X_CMINTCTR=
L);
> > +                     prescale =3D priv->bus_freq_mhz * 4;
> > +
> > +                     if (coal_intvl < EMAC_DM646X_CMINTMIN_INTVL)
> > +                             coal_intvl =3D EMAC_DM646X_CMINTMIN_INTVL=
;
> > +
> > +                     if (coal_intvl > EMAC_DM646X_CMINTMAX_INTVL) {
> > +                             /*
> > +                              * Interrupt pacer works with 4us Pulse, =
we can
> > +                              * throttle further by dilating the 4us p=
ulse.
> > +                              */
> > +                             addnl_dvdr =3D
> > +                                     EMAC_DM646X_INTPRESCALE_MASK / pr=
escale;
> > +
> > +                             if (addnl_dvdr > 1) {
> > +                                     prescale *=3D addnl_dvdr;
> > +                                     if (coal_intvl > (EMAC_DM646X_CMI=
NTMAX_INTVL
> > +                                                             * addnl_d=
vdr))
> > +                                             coal_intvl =3D (EMAC_DM64=
6X_CMINTMAX_INTVL
> > +                                                             * addnl_d=
vdr);
> > +                             } else {
> > +                                     addnl_dvdr =3D 1;
> > +                                     coal_intvl =3D EMAC_DM646X_CMINTM=
AX_INTVL;
> > +                             }
> >                       }
> > -             }
> >
> > -             num_interrupts =3D (1000 * addnl_dvdr) / coal_intvl;
> > +                     num_interrupts =3D (1000 * addnl_dvdr) / coal_int=
vl;
> > +
> > +                     int_ctrl |=3D EMAC_DM646X_INTPACEEN;
> > +                     int_ctrl &=3D (~EMAC_DM646X_INTPRESCALE_MASK);
> > +                     int_ctrl |=3D (prescale & EMAC_DM646X_INTPRESCALE=
_MASK);
> > +             }
> >
> > -             int_ctrl |=3D EMAC_DM646X_INTPACEEN;
> > -             int_ctrl &=3D (~EMAC_DM646X_INTPRESCALE_MASK);
> > -             int_ctrl |=3D (prescale & EMAC_DM646X_INTPRESCALE_MASK);
> >               emac_ctrl_write(EMAC_DM646X_CMINTCTRL, int_ctrl);
> >
> >               emac_ctrl_write(EMAC_DM646X_CMRXINTMAX, num_interrupts);
> > @@ -466,17 +467,21 @@ static int emac_set_coalesce(struct net_device *n=
dev,
> >       default:
> >               int_ctrl =3D emac_ctrl_read(EMAC_CTRL_EWINTTCNT);
> >               int_ctrl &=3D (~EMAC_DM644X_EWINTCNT_MASK);
> > -             prescale =3D coal_intvl * priv->bus_freq_mhz;
> > -             if (prescale > EMAC_DM644X_EWINTCNT_MASK) {
> > -                     prescale =3D EMAC_DM644X_EWINTCNT_MASK;
> > -                     coal_intvl =3D prescale / priv->bus_freq_mhz;
> > +
> > +             if (coal->rx_coalesce_usecs) {
> > +                     prescale =3D coal_intvl * priv->bus_freq_mhz;
> > +                     if (prescale > EMAC_DM644X_EWINTCNT_MASK) {
> > +                             prescale =3D EMAC_DM644X_EWINTCNT_MASK;
> > +                             coal_intvl =3D prescale / priv->bus_freq_=
mhz;
> > +                     }
> >               }
> > +
> >               emac_ctrl_write(EMAC_CTRL_EWINTTCNT, (int_ctrl | prescale=
));
> >
> >               break;
> >       }
> >
> > -     printk(KERN_INFO"Set coalesce to %d usecs.\n", coal_intvl);
> > +     netdev_info(ndev, "Set coalesce to %d usecs.\n", coal_intvl);
> >       priv->coal_intvl =3D coal_intvl;
> >
> >       return 0;
> >
>
> --
> Best regards,
> grygorii
