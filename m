Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CB93EC701
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 05:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbhHODio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 23:38:44 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:41879 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbhHODim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 23:38:42 -0400
Received: by mail-lj1-f171.google.com with SMTP id h9so21850099ljq.8;
        Sat, 14 Aug 2021 20:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OcuDfg9eRzXnneI6MaY2x1oxJrEEIkpSAcdBbgk2tSY=;
        b=qs/R5JUgNf/cW5nfGxtjuxQKrCroMShkOv8KTP+yDD5L/jjy8H7ZVw2M9XIcz1fyv1
         OKrW3tZUi73yawDUrCUWXSZ5zsD9Re1a+adE+RWgnmtOPsOVsNxiiu2wEOP2RHpnHTGQ
         jz2sAKO+Uc89Hr4zzPPK2ZvUttXTizYOmGlm9s45xySBL9oVumWnaCyzBADvfeLUfoNw
         Z+5h3JFzidRSd9oPY4RZy5IRssl2AfZPzSsi/hLG75+BKoKBk7fh/YqLEapMHbGQm4JO
         iRhdvKrpcCj8ni64UdUn42fEbGndBKTGttRLFi0ppF+c2lezEDRcQOrxV35GeTmaLNpt
         l5cA==
X-Gm-Message-State: AOAM531yXN1egb5Q7HPs3DARkHZWG5OU/Ngp6dhHtbeJBOJQ7kxNyX/I
        UWziW5jC6PEeVP+vg3h11OTbb65Z41WisXftRYU=
X-Google-Smtp-Source: ABdhPJyif2ZkJLuuFm70vHJAj82zpUbjVTbhQiuYDK/+RB7TpkMZu/R60v/795ppO7PQpfNqMhAhA3411UpEUroRGsY=
X-Received: by 2002:a2e:a4ba:: with SMTP id g26mr1317635ljm.254.1628998692179;
 Sat, 14 Aug 2021 20:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210814091750.73931-1-mailhol.vincent@wanadoo.fr>
 <20210814091750.73931-6-mailhol.vincent@wanadoo.fr> <20210814111243.biquurwkyzmhmsad@pengutronix.de>
In-Reply-To: <20210814111243.biquurwkyzmhmsad@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 15 Aug 2021 12:38:00 +0900
Message-ID: <CAMZ6RqK9pBP3VH7s78G90KXWe6nnm_bs+xbT+v-N3uBS3VSW6g@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] can: netlink: add interface for CAN-FD Transmitter
 Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 14 Aug 2021 at 20:12, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 14.08.2021 18:17:48, Vincent Mailhol wrote:
> [...]
>
> >  static int can_changelink(struct net_device *dev, struct nlattr *tb[],
> >                         struct nlattr *data[],
> >                         struct netlink_ext_ack *extack)
> >  {
> >       struct can_priv *priv = netdev_priv(dev);
> > +     u32 tdc_mask = 0;
> >       int err;
> >
> >       /* We need synchronization with dev->stop() */
> > @@ -107,6 +179,7 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
> >               struct can_ctrlmode *cm;
> >               u32 ctrlstatic;
> >               u32 maskedflags;
> > +             u32 tdc_flags;
> >
> >               /* Do not allow changing controller mode while running */
> >               if (dev->flags & IFF_UP)
> > @@ -138,7 +211,18 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
> >                       dev->mtu = CAN_MTU;
> >                       memset(&priv->data_bittiming, 0,
> >                              sizeof(priv->data_bittiming));
> > +                     memset(&priv->tdc, 0, sizeof(priv->tdc));
> > +                     priv->ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
> >               }
> > +
> > +             tdc_flags = cm->flags & CAN_CTRLMODE_TDC_MASK;
> > +             /* CAN_CTRLMODE_TDC_{AUTO,MANUAL} are mutually exclusive */
> > +             if (tdc_flags == CAN_CTRLMODE_TDC_MASK)
> > +                     return -EOPNOTSUPP;
> > +             /* If one of CAN_CTRLMODE_TDC_* is set then TDC must be set */
> > +             if (tdc_flags && !data[IFLA_CAN_TDC])
> > +                     return -EOPNOTSUPP;
>
> These don't need information form the can_priv, right? So these checks
> can be moved to can_validate()?

ACK. Actually, this comment applies not only to can_changelink()
but also to can_tdc_changelink().  I just sent a v5 where I made
sure to move all the checks that do not rely on can_priv to
can_validate().


Yours sincerely,
Vincent
