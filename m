Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9423AA043
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbhFPPrq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Jun 2021 11:47:46 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:46660 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbhFPPqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 11:46:31 -0400
Received: by mail-lj1-f175.google.com with SMTP id b37so4435194ljr.13;
        Wed, 16 Jun 2021 08:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bx6pJveQBPVAV+AJO0rwH2DDFurC6rZ+xmLnsk0p5p0=;
        b=M5dJ2sD5vJNuU9yn/+ll8720MTu2jLo2Fni9RU1MpOSFQpKz81u7B15T93w60E2mNy
         yR9iv/a/y9iaUsu9oyhimakJkw2+lBhvgFHSWtPERT+S2Dhv2dw+RQHXI+JUbx1lezfD
         RvOeHu49POlf/Nc9IEll5cxNdd8PJ3kX9qjb5vtK0laVpo6KcIuW4GmG/x9Xg3HawyGz
         vnBSTGQo60Z5dlw4YE92aEqXjttwYEzmbnjnaT3aDM0sZ2FRDiMoy4DEYXhE02ZlqPyM
         3omOkGepaZthiz3BSG8BNmqzO3r4I8ehJn8UOBuhfTwS9RjGHksbkjhhPKhqCV0PuzEC
         9wTQ==
X-Gm-Message-State: AOAM533t+LyVU97pMGkt189FI3I/grkUYaLCA/B5OYi2suP+rfBdTDr5
        lMzbsesoFRrNz17SKnL9sU1Syb10Bw2Z1mwcvEU=
X-Google-Smtp-Source: ABdhPJyHjZG2mpJuBPJ413x6JX/SXhfTuADPMsO3XYRp3UZ1qcNmx/OzV0bOlGpMYVpyKcLv5gaee8P528z9B5oSWI4=
X-Received: by 2002:a2e:984a:: with SMTP id e10mr397620ljj.331.1623858263457;
 Wed, 16 Jun 2021 08:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr> <20210616094633.fwg6rsyxyvm2zc6d@pengutronix.de>
 <CAMZ6RqLj59+3PrQwTCfK_bVebRBHE=HqCfRb31MU9pRDBPxG8w@mail.gmail.com>
 <20210616142940.wxllr3c55rk66rij@pengutronix.de> <CAMZ6RqJWeexWTGVkEJWMvBs1f=HQOc4zjd-PqPsxKnCr_XDFZQ@mail.gmail.com>
 <20210616144640.l4hjc6mc3ndw25hj@pengutronix.de>
In-Reply-To: <20210616144640.l4hjc6mc3ndw25hj@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 17 Jun 2021 00:44:12 +0900
Message-ID: <CAMZ6RqLZAO3UX=B8yVUse=4DAVG_zGPrdoYpd-7Cp_To58CChw@mail.gmail.com>
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

On Wed. 16 Jun 2021 at 23:46, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 16.06.2021 23:43:35, Vincent MAILHOL wrote:
> > > Sounds good, I'm squashing this patch:
> > >
> > > | diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
> > > | index 6134bbf69c10..d48be574eae7 100644
> > > | --- a/drivers/net/can/dev/netlink.c
> > > | +++ b/drivers/net/can/dev/netlink.c
> > > | @@ -311,7 +311,7 @@ static size_t can_tdc_get_size(const struct net_device *dev)
> > > |         size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCO_MAX */
> > > |         size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCF_MAX */
> > > |
> > > | -       if (priv->tdc.tdco) {
> > > | +       if (can_tdc_is_enabled(priv)) {
> > > |                 size += nla_total_size(sizeof(u32));    /* IFLA_CAN_TDCV */
> > > |                 size += nla_total_size(sizeof(u32));    /* IFLA_CAN_TDCO */
> > > |                 size += nla_total_size(sizeof(u32));    /* IFLA_CAN_TDCF */
> > > | @@ -352,6 +352,7 @@ static size_t can_get_size(const struct net_device *dev)
> > > |                                        priv->data_bitrate_const_cnt);
> > > |         size += sizeof(priv->bitrate_max);                      /* IFLA_CAN_BITRATE_MAX */
> > > |         size += can_tdc_get_size(dev);                          /* IFLA_CAN_TDC */
> > > | +
> > > |         return size;
> > > |  }
> > > |
> > > | @@ -374,7 +375,7 @@ static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
> > > |             nla_put_u32(skb, IFLA_CAN_TDC_TDCF_MAX, tdc_const->tdcf_max))
> > > |                 goto err_cancel;
> > > |
> > > | -       if (priv->tdc.tdco)
> > > | +       if (can_tdc_is_enabled(priv)) {
> > > |                 if (nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdc->tdcv) ||
> > > |                     nla_put_u32(skb, IFLA_CAN_TDC_TDCO, tdc->tdco) ||
> > > |                     nla_put_u32(skb, IFLA_CAN_TDC_TDCF, tdc->tdcf))
> > > | diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
> > > | index 9de6e9053e34..b6d1db1e7258 100644
> > > | --- a/include/linux/can/bittiming.h
> > > | +++ b/include/linux/can/bittiming.h
> > > | @@ -83,6 +83,11 @@ struct can_tdc_const {
> > > |         u32 tdcf_max;
> > > |  };
> > > |
> > > | +static inline bool can_tdc_is_enabled(const struct can_priv *priv)
> >
> > Did you try to compile?
>
> Not before sending that mail :)
>
> > I am not sure if bittiming.h is able to see struct can_priv which is
> > defined in dev.h.
>
> Nope it doesn't, I moved the can_tdc_is_enabled() to
> include/linux/can/dev.h

Ack. It seems to be the only solution…

Moving forward, I will do one more round of tests and send the
patch for iproute2-next (warning, the RFC I sent last month has
some issues, if you wish to test it on your side, please wait).

I will also apply can_tdc_is_enabled() to the etas_es58x driver.

Could you push the recent changes on the testing branch of linux-can-next? It
would be really helpful for me!


Yours sincerely,
Vincent
