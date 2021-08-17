Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6E63EE0C7
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhHQAUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:20:41 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:47095 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhHQAUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:20:39 -0400
Received: by mail-lf1-f42.google.com with SMTP id u22so6752441lfq.13;
        Mon, 16 Aug 2021 17:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EeSSxZWCjTCKnIGHCtg9XhHy/XSSxUFCkMov+L5HlGg=;
        b=Btl8ELxQZACi5EV4gfV7Y4ZvnUZ9lIyHYzCLqIQ7LUeKpqSgA5Xf4dtk/y5X3Z3htI
         /t09I4YNTuXjHLPdblIjRW8CkNFQ4xhYgF3LrLiLcJJulr1WN54TKiHRwWwzBjlBsa8O
         dPdYwtjGhTvpSNyA71nSSbqSKubKrwz01IWZQoZX7wmUdoW3Xfwq4MwEqZcgYyU/0DHq
         zb0tMdeZPJsGkWTCfKVp9NXhhnVn43pnAONSizlulJ9m8IBLpglymIZ27NoHOcB0MgPx
         o0/NXw1/zKwi+wP7VPu/u3Zd/NfV0hSAdiZM24nIjYVfEu9HHan5a+35lEh0RwLDTVsn
         S65g==
X-Gm-Message-State: AOAM530Y74egIHx7kV36YqI7Kr3lwp0mRi4MOalQeRglwIQiOmJKfn5g
        GKlKp6ePsxJNRWQt4KyoGIO0LhlvvRrQt99RNK4=
X-Google-Smtp-Source: ABdhPJwEBq7zUYKuF+aoAA0lDMmyOLN5qIZdFounGbwl6ge0rOMIwHi+v5Da++UVXJZL4e57MUE0rSyjczVd01UXVeY=
X-Received: by 2002:a19:c112:: with SMTP id r18mr287174lff.531.1629159605630;
 Mon, 16 Aug 2021 17:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210816114840.17502-1-o.rempel@pengutronix.de> <20210816114840.17502-3-o.rempel@pengutronix.de>
In-Reply-To: <20210816114840.17502-3-o.rempel@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 Aug 2021 09:19:54 +0900
Message-ID: <CAMZ6RqJ_KjB0t80ojdy-O0FNuF-JYbWZ4aT5_SrCgWr_Zetf+g@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] can: dev: provide optional GPIO based termination support
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 16 Aug 2021 at 20:48, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> For CAN buses to work, a termination resistor has to be present at both
> ends of the bus. This resistor is usually 120 Ohms, other values may be
> required for special bus topologies.
>
> This patch adds support for a generic GPIO based CAN termination. The
> resistor value has to be specified via device tree, and it can only be
> attached to or detached from the bus. By default the termination is not
> active.
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/can/dev/dev.c | 54 +++++++++++++++++++++++++++++++++++++++
>  include/linux/can/dev.h   |  7 +++++
>  2 files changed, 61 insertions(+)
>
> diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
> index 311d8564d611..b4a6c7a6fc18 100644
> --- a/drivers/net/can/dev/dev.c
> +++ b/drivers/net/can/dev/dev.c
> @@ -15,6 +15,7 @@
>  #include <linux/can/dev.h>
>  #include <linux/can/skb.h>
>  #include <linux/can/led.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/of.h>
>
>  #define MOD_DESC "CAN device driver interface"
> @@ -400,10 +401,57 @@ void close_candev(struct net_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(close_candev);
>
> +static int can_set_termination(struct net_device *ndev, u16 term)
> +{
> +       struct can_priv *priv = netdev_priv(ndev);
> +       int set;
> +
> +       if (term == priv->termination_gpio_ohms[CAN_TERMINATION_GPIO_ENABLED])
> +               set = 1;
> +       else
> +               set = 0;
> +
> +       gpiod_set_value(priv->termination_gpio, set);
> +
> +       return 0;
> +}
> +
> +static int can_get_termination(struct net_device *ndev)
> +{
> +       struct can_priv *priv = netdev_priv(ndev);
> +       struct device *dev = ndev->dev.parent;
> +       struct gpio_desc *gpio;
> +       u16 term;
> +       int ret;
> +
> +       /* Disabling termination by default is the safe choice: Else if many
> +        * bus participants enable it, no communication is possible at all.
> +        */
> +       gpio = devm_gpiod_get_optional(dev, "termination", GPIOD_OUT_LOW);
> +       if (IS_ERR(gpio))
> +               return dev_err_probe(dev, PTR_ERR(gpio),
> +                                    "Cannot get termination-gpios\n");
> +
> +       ret = device_property_read_u16(dev, "termination-ohms", &term);
> +       if (ret)
> +               return ret;
> +
> +       priv->termination_const_cnt = ARRAY_SIZE(priv->termination_gpio_ohms);
> +       priv->termination_const = priv->termination_gpio_ohms;
> +       priv->termination_gpio = gpio;
> +       priv->termination_gpio_ohms[CAN_TERMINATION_GPIO_DISABLED] =
> +               CAN_TERMINATION_DISABLED;
> +       priv->termination_gpio_ohms[CAN_TERMINATION_GPIO_ENABLED] = term;
> +       priv->do_set_termination = can_set_termination;
> +
> +       return 0;
> +}
> +
>  /* Register the CAN network device */
>  int register_candev(struct net_device *dev)
>  {
>         struct can_priv *priv = netdev_priv(dev);
> +       int err;
>
>         /* Ensure termination_const, termination_const_cnt and
>          * do_set_termination consistency. All must be either set or
> @@ -419,6 +467,12 @@ int register_candev(struct net_device *dev)
>         if (!priv->data_bitrate_const != !priv->data_bitrate_const_cnt)
>                 return -EINVAL;
>
> +       if (!priv->termination_const) {
> +               err = can_get_termination(dev);
> +               if (err)
> +                       return err;
> +       }
> +
>         dev->rtnl_link_ops = &can_link_ops;
>         netif_carrier_off(dev);
>
> diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
> index 27b275e463da..82bdc5b09a3a 100644
> --- a/include/linux/can/dev.h
> +++ b/include/linux/can/dev.h
> @@ -32,6 +32,11 @@ enum can_mode {
>         CAN_MODE_SLEEP
>  };
>
> +enum can_termination_gpio {
> +       CAN_TERMINATION_GPIO_DISABLED = 0,
> +       CAN_TERMINATION_GPIO_ENABLED,

I would add a last entry to automatically calculate the length of
the termination_gpio_ohms array.

+       CAN_TERMINATION_GPIO_MAX

> +};
> +
>  /*
>   * CAN common private data
>   */
> @@ -55,6 +60,8 @@ struct can_priv {
>         unsigned int termination_const_cnt;
>         const u16 *termination_const;
>         u16 termination;
> +       struct gpio_desc *termination_gpio;
> +       u16 termination_gpio_ohms[2];

This way, you can replace the constant value 2:

+       u16 termination_gpio_ohms[CAN_TERMINATION_GPIO_MAX];

>
>         enum can_state state;

Yours sincerely,
Vincent
