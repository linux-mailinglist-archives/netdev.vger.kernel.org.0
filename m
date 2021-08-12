Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ED13EA008
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhHLH7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:59:20 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:37764 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbhHLH7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 03:59:19 -0400
Received: by mail-ot1-f49.google.com with SMTP id n1-20020a9d1e810000b0290514da4485e4so3970877otn.4;
        Thu, 12 Aug 2021 00:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/ncPUMWRzuoT6QJYELKwlU0BgmoIDJcS93owKa4aQw=;
        b=fcwncY2XChnbHL8+g9CtjWFdN8J3Y0ZGJNeFRV0f4+W2oIs87zIM0XWkXY50CGgpi+
         wnWr0IuPF32FUA1pb6VI/rTVyLCR/qSryOLdecMxzdWRZ588Hm+AfzS4l5xcbeU9POkr
         4TBBY9d4f6ZTGr0XWU61OiIkEKaNq3WUa2lGuCHuUulen8V5Np3dvu3lKYO0R1nKY414
         QbDwW/NYNWtxSj1y0xjIsmdz8cVPkEF69C/XxR1O3Kpmd+UKcjiJgUMObROIEJVn8Yd1
         H90tXswW5DwocP0uXQcGI5z5a2RO/2FLlizpL8hI48TiX9DYbUVGridB0PyrRXZhYzBH
         Ey/Q==
X-Gm-Message-State: AOAM533P91RpccxiyDwNrxwGbjYU6Wkr5xKq3w1G01cImgKSL36lim/6
        eba+taKaLHarIeO/Z8Wv9/czhukCubuo1dARUJo=
X-Google-Smtp-Source: ABdhPJzRx4DoSQmjlMVEFvIED3P2QiAjTjTCsI3NUK0wpsGFqXc7wZ7wC82ke5ZGw8/LLBBp+dw87XThevOJQQAhuxA=
X-Received: by 2002:a9d:86e:: with SMTP id 101mr2608555oty.114.1628755134711;
 Thu, 12 Aug 2021 00:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com> <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
 <OS0PR01MB5922BF48F95DD5576A79994F86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922BF48F95DD5576A79994F86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 12 Aug 2021 09:58:43 +0200
Message-ID: <CAMuHMdVCyMD6u2KxKb_c2LR8DGAY86F69=TSRDK0C5GPwrO7Eg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver data
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

On Thu, Aug 12, 2021 at 9:26 AM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> > -----Original Message-----
> > On Mon, Aug 2, 2021 at 12:27 PM Biju Das <biju.das.jz@bp.renesas.com>
> > wrote:
> > > The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC
> > > are similar to the R-Car Ethernet AVB IP. With a few changes in the
> > > driver we can support both IPs.
> > >
> > > Currently a runtime decision based on the chip type is used to
> > > distinguish the HW differences between the SoC families.
> > >
> > > The number of TX descriptors for R-Car Gen3 is 1 whereas on R-Car Gen2
> > > and RZ/G2L it is 2. For cases like this it is better to select the
> > > number of TX descriptors by using a structure with a value, rather
> > > than a runtime decision based on the chip type.
> > >
> > > This patch adds the num_tx_desc variable to struct ravb_hw_info and
> > > also replaces the driver data chip type with struct ravb_hw_info by
> > > moving chip type to it.
> > >
> > > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >
> > Thanks for your patch!
> >
> > > --- a/drivers/net/ethernet/renesas/ravb.h
> > > +++ b/drivers/net/ethernet/renesas/ravb.h
> > > @@ -988,6 +988,11 @@ enum ravb_chip_id {
> > >         RCAR_GEN3,
> > >  };
> > >
> > > +struct ravb_hw_info {
> > > +       enum ravb_chip_id chip_id;
> > > +       int num_tx_desc;
> >
> > Why not "unsigned int"? ...
> > This comment applies to a few more subsequent patches.
>
> To avoid signed and unsigned comparison warnings.
>
> >
> > > +};
> > > +
> > >  struct ravb_private {
> > >         struct net_device *ndev;
> > >         struct platform_device *pdev;
> > > @@ -1040,6 +1045,8 @@ struct ravb_private {
> > >         unsigned txcidm:1;              /* TX Clock Internal Delay Mode
> > */
> > >         unsigned rgmii_override:1;      /* Deprecated rgmii-*id behavior
> > */
> > >         int num_tx_desc;                /* TX descriptors per packet */
> >
> > ... oh, here's the original culprit.
>
> Exactly, this the reason.
>
> Do you want me to change this into unsigned int? Please let me know.

Up to you (or the maintainer? ;-)

For new fields (in the other patches), I would use unsigned for all
unsigned values.  Signed values have more pitfalls related to
undefined behavior.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
