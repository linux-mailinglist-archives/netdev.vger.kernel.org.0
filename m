Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745F23EFEBA
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbhHRIJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:09:40 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:33561 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238650AbhHRIJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:09:38 -0400
Received: by mail-lj1-f172.google.com with SMTP id n7so3629744ljq.0;
        Wed, 18 Aug 2021 01:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zS3HmGadTV/ONEUOpne6IQWm4IBd42AxFALL1jwUdAk=;
        b=bpsTizG81nzqZZb4mMT4MYy+MNPh3DyB65e7F9Yag5xXP1ql5xzPwdWWMBp+rdHW3N
         1Ez3BrKMH+iupIseDou1kapDEGXbdU2qd4FPMxnFosg8GbBwDhMN6un3NXiJJKAXXXcr
         IBPfk5deMBv36hj006pKtxUkehpwPu6OR3kzIsb+X8m8hp4zEhch3CiCbb9FULSwxSbu
         K9aVnTxqNWxWG1nG94T3nF+JNfJumdc8hT1E3jXYozYDR5K57C+IXj7HZcre0/apcdta
         8E+462Vw1YBn5fVRL3RkO7mqaZTupCUhpkHPkKqfWioZoMdulDiq+DAJavHNtoKYlN7m
         OeLg==
X-Gm-Message-State: AOAM530DxnTinbkStZ3xRgQSgV+ZGRlK9sHz33bTQkcD5IVVX0uAV5MQ
        u7p+r3NJTUNUWXFftsIgd57H+u1NFd0BlSR4IVw=
X-Google-Smtp-Source: ABdhPJyEQpgstBeIffhtaQMrcR3+Gd2+TUMkttxus/h5F9v1P7W7b2JxpAhr6zSfbO97feFAtn1PfYRm+9LIiggYxgM=
X-Received: by 2002:a2e:9c08:: with SMTP id s8mr6828658lji.331.1629274142982;
 Wed, 18 Aug 2021 01:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-6-mailhol.vincent@wanadoo.fr> <20210817195551.wwgu7dnhb6qyvo7n@pengutronix.de>
In-Reply-To: <20210817195551.wwgu7dnhb6qyvo7n@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 18 Aug 2021 17:08:51 +0900
Message-ID: <CAMZ6RqLj94UU_b8dDAzinVsLaV6pBR-cWbHmjwGhx3vfWiKt_g@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] can: netlink: add interface for CAN-FD Transmitter
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

On Wed 18 Aug 2021 at 04:55, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 15.08.2021 12:32:46, Vincent Mailhol wrote:
> > +static int can_tdc_changelink(struct net_device *dev, const struct nlattr *nla,
> > +                           struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb_tdc[IFLA_CAN_TDC_MAX + 1];
> > +     struct can_priv *priv = netdev_priv(dev);
> > +     struct can_tdc *tdc = &priv->tdc;
> > +     const struct can_tdc_const *tdc_const = priv->tdc_const;
> > +     int err;
> > +
> > +     if (!tdc_const || !can_tdc_is_enabled(priv))
> > +             return -EOPNOTSUPP;
> > +
> > +     if (dev->flags & IFF_UP)
> > +             return -EBUSY;
> > +
> > +     err = nla_parse_nested(tb_tdc, IFLA_CAN_TDC_MAX, nla,
> > +                            can_tdc_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (tb_tdc[IFLA_CAN_TDC_TDCV]) {
> > +             u32 tdcv = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCV]);
> > +
> > +             if (tdcv < tdc_const->tdcv_min || tdcv > tdc_const->tdcv_max)
> > +                     return -EINVAL;
> > +
> > +             tdc->tdcv = tdcv;
>
> You have to assign to a temporary struct first, and set the priv->tdc
> after complete validation, otherwise you end up with inconsistent
> values.

Actually, copying the temporary structure to priv->tdc is not an
atomic operation. Here, you are only reducing the window, not
closing it.

> > +     }
> > +
> > +     if (tb_tdc[IFLA_CAN_TDC_TDCO]) {
> > +             u32 tdco = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCO]);
> > +
> > +             if (tdco < tdc_const->tdco_min || tdco > tdc_const->tdco_max)
> > +                     return -EINVAL;
> > +
> > +             tdc->tdco = tdco;
> > +     }
> > +
> > +     if (tb_tdc[IFLA_CAN_TDC_TDCF]) {
> > +             u32 tdcf = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCF]);
> > +
> > +             if (tdcf < tdc_const->tdcf_min || tdcf > tdc_const->tdcf_max)
> > +                     return -EINVAL;
> > +
> > +             tdc->tdcf = tdcf;
> > +     }
> > +
> > +     return 0;
> > +}
>
> To reproduce (ip pseudo-code only :D ):
>
> ip down
> ip up tdc-mode manual tdco 111 tdcv 33  # 111 is out of range, 33 is valid
> ip down
> ip up                                   # results in tdco=0 tdcv=33 mode=manual

I do not think that this PoC would work because, thankfully, the
netlink interface uses a mutex to prevent this issue from
occurring.

That mutex is defined in:
https://elixir.bootlin.com/linux/latest/source/net/core/rtnetlink.c#L68

Each time a netlink message is sent to the kernel, it would be
dispatched by rtnetlink_rcv_msg() which will make sure to lock
the mutex before doing so:
https://elixir.bootlin.com/linux/latest/source/net/core/rtnetlink.c#L5551

A funny note is that because the mutex is global, if you run two
ip command in a row:

| ip link set can0 type can bitrate 500000
| ip link set can1 up

the second one will wait for the first one to finish even if it
is on a different network device.

To conclude, I do not think this needs to be fixed.


Yours sincerely,
Vincent
