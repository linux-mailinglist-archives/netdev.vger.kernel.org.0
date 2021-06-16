Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA213A9DF0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhFPOpz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Jun 2021 10:45:55 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:37540 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbhFPOpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:45:54 -0400
Received: by mail-lf1-f50.google.com with SMTP id p7so4747159lfg.4;
        Wed, 16 Jun 2021 07:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cvp2mHEQf6K2NmEgmLY5mMra5q/cnwT0U6hmuP4aWWg=;
        b=CXb4XRHnyltsc1VKVLpop0pVYZN97Mbg0Hb9WGFwTyx4ChPw/W4y6pKVAOXdVqVZN7
         A/4LKqbztYYLNsIbr+1O8mmlYFclTjQ6b7ufB5FjvBY3YoY7sPaw8koOCXMgqisAndFy
         JLiNuQs9twnuG7lEeAsolfGlIVxrkmcgU3JgJHindoFjzmSPfq4hsFSg7JF+OJ59O+3t
         xpIaQ+kSn8soNBCsfuy0sU0XM6b5fhMmxZJcLsW9JktmBro0wJXiJHAwORdXBUQjK70s
         ifTimogJqJRpE/tgvvuObB1NORwMSd/NHClZPFCQ7agk1QPqI5A8lAT3qm3cTjsf3DSa
         uBow==
X-Gm-Message-State: AOAM533ey8/KW6U34/br3ab8aIXexzhefx0cNebONWGTN1Ellpoff0oH
        1bRU7u0vZO1H1JsWIqXa+MC7mQHv8meRxI/ZBDw=
X-Google-Smtp-Source: ABdhPJzzKcR2X/FPDGKYSaNfQ+peUf5omp1pYmTrIyN4PYBKzZ/g1ScynelThVaku/b2O9TZzw3VQNy2ZR13qhomz7w=
X-Received: by 2002:a05:6512:3d08:: with SMTP id d8mr5554lfv.393.1623854627094;
 Wed, 16 Jun 2021 07:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr> <20210616094633.fwg6rsyxyvm2zc6d@pengutronix.de>
 <CAMZ6RqLj59+3PrQwTCfK_bVebRBHE=HqCfRb31MU9pRDBPxG8w@mail.gmail.com> <20210616142940.wxllr3c55rk66rij@pengutronix.de>
In-Reply-To: <20210616142940.wxllr3c55rk66rij@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 16 Jun 2021 23:43:35 +0900
Message-ID: <CAMZ6RqJWeexWTGVkEJWMvBs1f=HQOc4zjd-PqPsxKnCr_XDFZQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD Transmitter
 Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 16 Jun 2021 à 23:29, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 16.06.2021 22:53:02, Vincent MAILHOL wrote:
> > On Wed. 16 Jun 2021 at 18:46, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > On 04.06.2021 00:15:50, Vincent Mailhol wrote:
> > > [...]
> > >
> > > > +static size_t can_tdc_get_size(const struct net_device *dev)
> > > > +{
> > > > +     struct can_priv *priv = netdev_priv(dev);
> > > > +     size_t size;
> > > > +
> > > > +     if (!priv->tdc_const)
> > > > +             return 0;
> > > > +
> > > > +     size = nla_total_size(0);                       /* nest IFLA_CAN_TDC */
> > > > +     size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCV_MAX */
> > > > +     size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCO_MAX */
> > > > +     size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCF_MAX */
> > > > +
> > > > +     if (priv->tdc.tdco) {
> > >
> > > Naively I'd say, iff the device has tdc_const give the user space the
> > > tdc parameters, regardless if some value is 0 or not.
> > >
> > > What do you think?
> >
> > I thought about that.
> > The first important remark is that if tdc.tdco is zero, then TDC
> > is off (c.f. documentation of struct can_tdc::tdco).
> >
> > Let me illustrate my vision through examples.
>
> [...]
>
> examples makes sense \o/

Great!

> [...]
>
> > Finally, I have one side comment. It seems to me that you did not
> > understand that the intent of
> > |     if (priv->tdc.tdco)
> > was to actually check whether TDC was on or off. In other words, my
> > code was unclear.
> >
> > I am now thinking to introduce an helper macro:
> > static bool can_tdc_is_enabled(const struct can_priv *priv)
> > |{
> > |    return !!priv->tdc.tdco;
> > |}
> >
> > The code would look more clear like that.
> > -     if (priv->tdc.tdco) {
> > +     if (can_tdc_is_enabled(priv) {
>
> Sounds good, I'm squashing this patch:
>
> | diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
> | index 6134bbf69c10..d48be574eae7 100644
> | --- a/drivers/net/can/dev/netlink.c
> | +++ b/drivers/net/can/dev/netlink.c
> | @@ -311,7 +311,7 @@ static size_t can_tdc_get_size(const struct net_device *dev)
> |         size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCO_MAX */
> |         size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCF_MAX */
> |
> | -       if (priv->tdc.tdco) {
> | +       if (can_tdc_is_enabled(priv)) {
> |                 size += nla_total_size(sizeof(u32));    /* IFLA_CAN_TDCV */
> |                 size += nla_total_size(sizeof(u32));    /* IFLA_CAN_TDCO */
> |                 size += nla_total_size(sizeof(u32));    /* IFLA_CAN_TDCF */
> | @@ -352,6 +352,7 @@ static size_t can_get_size(const struct net_device *dev)
> |                                        priv->data_bitrate_const_cnt);
> |         size += sizeof(priv->bitrate_max);                      /* IFLA_CAN_BITRATE_MAX */
> |         size += can_tdc_get_size(dev);                          /* IFLA_CAN_TDC */
> | +
> |         return size;
> |  }
> |
> | @@ -374,7 +375,7 @@ static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
> |             nla_put_u32(skb, IFLA_CAN_TDC_TDCF_MAX, tdc_const->tdcf_max))
> |                 goto err_cancel;
> |
> | -       if (priv->tdc.tdco)
> | +       if (can_tdc_is_enabled(priv)) {
> |                 if (nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdc->tdcv) ||
> |                     nla_put_u32(skb, IFLA_CAN_TDC_TDCO, tdc->tdco) ||
> |                     nla_put_u32(skb, IFLA_CAN_TDC_TDCF, tdc->tdcf))
> | diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
> | index 9de6e9053e34..b6d1db1e7258 100644
> | --- a/include/linux/can/bittiming.h
> | +++ b/include/linux/can/bittiming.h
> | @@ -83,6 +83,11 @@ struct can_tdc_const {
> |         u32 tdcf_max;
> |  };
> |
> | +static inline bool can_tdc_is_enabled(const struct can_priv *priv)

Did you try to compile? I am not sure if bittiming.h is able to
see struct can_priv which is defined in dev.h.


Yours sincerely,
Vincent

> | +{
> | +       return !!priv->tdc.tdco;
> | +}
> | +
> |  #ifdef CONFIG_CAN_CALC_BITTIMING
> |  int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
> |                        const struct can_bittiming_const *btc);
