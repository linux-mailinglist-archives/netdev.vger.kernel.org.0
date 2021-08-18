Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8493EFF51
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhHRIiF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Aug 2021 04:38:05 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:39486 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbhHRIiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:38:04 -0400
Received: by mail-lf1-f45.google.com with SMTP id t9so3010466lfc.6;
        Wed, 18 Aug 2021 01:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yw9a+hq6cSXXfXu6TM/7Zyf0Zb4A07Jxt9yZYTBacBI=;
        b=HGBJy2QOqhVTIuDkmP2UpKaAisBw3lDzNA3AaeUb3KDa5Ewo6PWA5Ozowt9cTB9sye
         TOoSmPmTWA2iEPQpCXjnbD3tpxV7cp0pcWW2DVHgg8PpPTmlBWs/msN7Iz6W+tzty29/
         DCTFVYbi4gwUl1jychfSC28+7osp7H0FAw0nOl8+RxslG8i9nfzMzw52my6nUByo5RM0
         PpqfkoR7dmzhpWM9defah91uNA31UY3I1Pt7/vaCrR0hUjiNRYzb7DUpCF1mOnFntYPL
         F7T5X+Jheg444qxI2QgHysI7l3IrzNIQw9ItYKeE8UmhATgdYGdDC6t2UkJ7GtG0hi3y
         C63w==
X-Gm-Message-State: AOAM5314ho17bugwKXtUQF+pKW57Oe8Hs0mi3N0drzxN6rhgLnUfnpbx
        mnsFRaz/F3adw4wq0FnzGL6f1Zw5/phpQrTUMwc=
X-Google-Smtp-Source: ABdhPJyBQaepossLMH42svZ5QNxoYsHOuJc3w70JY+LKV/KBYSy4/y74UlZ7szItwxg7D6ZHLKzemXBDKWl1NlwUXgg=
X-Received: by 2002:a05:6512:3aa:: with SMTP id v10mr5613342lfp.393.1629275848891;
 Wed, 18 Aug 2021 01:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-6-mailhol.vincent@wanadoo.fr> <20210817195551.wwgu7dnhb6qyvo7n@pengutronix.de>
 <CAMZ6RqLj94UU_b8dDAzinVsLaV6pBR-cWbHmjwGhx3vfWiKt_g@mail.gmail.com> <20210818081934.6f23ghoom2dkv53m@pengutronix.de>
In-Reply-To: <20210818081934.6f23ghoom2dkv53m@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 18 Aug 2021 17:37:17 +0900
Message-ID: <CAMZ6Rq+PPH8mCayZg1ghftfoU8_y8rzAtO=Of2F5VZxcBKn4KA@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] can: netlink: add interface for CAN-FD Transmitter
 Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 18 Aug 2021 à 17:19, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 18.08.2021 17:08:51, Vincent MAILHOL wrote:
> > On Wed 18 Aug 2021 at 04:55, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > On 15.08.2021 12:32:46, Vincent Mailhol wrote:
> > > > +static int can_tdc_changelink(struct net_device *dev, const struct nlattr *nla,
> > > > +                           struct netlink_ext_ack *extack)
> > > > +{
> > > > +     struct nlattr *tb_tdc[IFLA_CAN_TDC_MAX + 1];
> > > > +     struct can_priv *priv = netdev_priv(dev);
> > > > +     struct can_tdc *tdc = &priv->tdc;
> > > > +     const struct can_tdc_const *tdc_const = priv->tdc_const;
> > > > +     int err;
> > > > +
> > > > +     if (!tdc_const || !can_tdc_is_enabled(priv))
> > > > +             return -EOPNOTSUPP;
> > > > +
> > > > +     if (dev->flags & IFF_UP)
> > > > +             return -EBUSY;
> > > > +
> > > > +     err = nla_parse_nested(tb_tdc, IFLA_CAN_TDC_MAX, nla,
> > > > +                            can_tdc_policy, extack);
> > > > +     if (err)
> > > > +             return err;
> > > > +
> > > > +     if (tb_tdc[IFLA_CAN_TDC_TDCV]) {
> > > > +             u32 tdcv = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCV]);
> > > > +
> > > > +             if (tdcv < tdc_const->tdcv_min || tdcv > tdc_const->tdcv_max)
> > > > +                     return -EINVAL;
> > > > +
> > > > +             tdc->tdcv = tdcv;
> > >
> > > You have to assign to a temporary struct first, and set the priv->tdc
> > > after complete validation, otherwise you end up with inconsistent
> > > values.
> >
> > Actually, copying the temporary structure to priv->tdc is not an
> > atomic operation. Here, you are only reducing the window, not
> > closing it.
>
> It's not a race I'm fixing.
>
> >
> > > > +     }
> > > > +
> > > > +     if (tb_tdc[IFLA_CAN_TDC_TDCO]) {
> > > > +             u32 tdco = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCO]);
> > > > +
> > > > +             if (tdco < tdc_const->tdco_min || tdco > tdc_const->tdco_max)
> > > > +                     return -EINVAL;
> > > > +
> > > > +             tdc->tdco = tdco;
> > > > +     }
> > > > +
> > > > +     if (tb_tdc[IFLA_CAN_TDC_TDCF]) {
> > > > +             u32 tdcf = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCF]);
> > > > +
> > > > +             if (tdcf < tdc_const->tdcf_min || tdcf > tdc_const->tdcf_max)
> > > > +                     return -EINVAL;
> > > > +
> > > > +             tdc->tdcf = tdcf;
> > > > +     }
> > > > +
> > > > +     return 0;
> > > > +}
> > >
> > > To reproduce (ip pseudo-code only :D ):
> > >
> > > ip down
> > > ip up tdc-mode manual tdco 111 tdcv 33  # 111 is out of range, 33 is valid
> > > ip down
> > > ip up                                   # results in tdco=0 tdcv=33 mode=manual
> >
> > I do not think that this PoC would work because, thankfully, the
> > netlink interface uses a mutex to prevent this issue from
> > occurring.
>
> It works, I've tested it :)
>
> > That mutex is defined in:
> > https://elixir.bootlin.com/linux/latest/source/net/core/rtnetlink.c#L68
> >
> > Each time a netlink message is sent to the kernel, it would be
> > dispatched by rtnetlink_rcv_msg() which will make sure to lock
> > the mutex before doing so:
> > https://elixir.bootlin.com/linux/latest/source/net/core/rtnetlink.c#L5551
> >
> > A funny note is that because the mutex is global, if you run two
> > ip command in a row:
> >
> > | ip link set can0 type can bitrate 500000
> > | ip link set can1 up
> >
> > the second one will wait for the first one to finish even if it
> > is on a different network device.
> >
> > To conclude, I do not think this needs to be fixed.
>
> It's not a race. Consider this command:
>
> | ip up tdc-mode manual tdco 111 tdcv 33  # 111 is out of range, 33 is valid
>
> tdcv is checked first and valid, then it's assigned to the priv->tdc.
> tdco is checked second and invalid, then can_tdc_changelink() returns -EINVAL.
>
> tdc ends up being half set :(
>
> So the setting of tdc is inconsistent and when you do a "ip down" "ip
> up" then it results in a tdco=0 tdcv=33 mode=manual.

My bad. Now I understand the issue.
I was confused because tdco=111 is in the valid range of my driver...
I will squash your patch.

Actually, I think that there is one more thing which needs to be
fixed: If can_tdc_changelink() fails (e.g. value out of range),
the CAN_CTRLMODE_TDC_AUTO or CAN_CTRLMODE_TDC_MANUAL would still
be set, meaning that can_tdc_is_enabled() would return true. So I
will add a "fail" branch to clear the flags.


Yours sincerely,
Vincent
