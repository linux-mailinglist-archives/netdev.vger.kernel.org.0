Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C0BCFA40
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbfJHMoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:44:38 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39271 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730316AbfJHMoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 08:44:38 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so16555102qki.6;
        Tue, 08 Oct 2019 05:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qsTHL7dnG8pTfXN3LiTylz/fXdfLYFshNaGXKMPCVSA=;
        b=ndycrZXm5sWbkE8ubUEk9cHyMk62s58AO9SvQliIZdhmcGyVW6JB7R2Wp5Do1V2PaJ
         /hd6EOGnUQEJsWwJ8mHEXm9+21fl7spIUcZt6cR1YZ96BjWJc49O0fzW7e+7a8uQWMmR
         mmMplhG2HZ7tYZ5LXMunI5Uukp1MZNqsrrBiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qsTHL7dnG8pTfXN3LiTylz/fXdfLYFshNaGXKMPCVSA=;
        b=HDVpAeKzrl0o30ruahzWKxCpJFY433/BQylhRUsQ7XfzhgDno01c8+d3hvw8IIZQEH
         Gu/IcQ6eds17B+ni4q67lU2WKORHjB8UFJBRcQrc0Moi55XFtKHWg8L1DZr3mco/n/Nt
         Py4ivGAS6f8a0BP/PocvYHW5n3Oi6mc/JrdLwXaDMD9JCYAZM5xrZQ6m7HN53fLAfgUR
         Kek2bfOdd1DUnWtXwrmwcEE2sP03Jc8iXFyq2YtYLvnpmZEUVw3MVEzUI1ZIp4UuBiNJ
         yOZwqeoaPz1gYY0V9vBmScoUFQ/n4zCq3H/Tr6Akwov3Z8a7GrQQJV5ZoKl8HwOvYKSz
         gcfw==
X-Gm-Message-State: APjAAAXZ3ktZvn6yUSpNaqnqqpcx9ujz7zAxOrrxUddgNEvV1XsQqHha
        YnKJWtK5o/lsdFRxb8LoH06k0gkz9uv5iwSoWz4=
X-Google-Smtp-Source: APXvYqxEAEDnOLwffSmG/Z2LwTVkYy576Ya72Q2Xui9eD1qyySpI9l4M3DUkH5opaUufU4sk4GAaGv+dFqEtKObKxJQ=
X-Received: by 2002:a37:a44f:: with SMTP id n76mr7330825qke.414.1570538677073;
 Tue, 08 Oct 2019 05:44:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191008115143.14149-1-andrew@aj.id.au> <20191008115143.14149-4-andrew@aj.id.au>
In-Reply-To: <20191008115143.14149-4-andrew@aj.id.au>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 8 Oct 2019 12:44:25 +0000
Message-ID: <CACPK8XfmtW9AY7QyBVkWJPvTQncV5o1DVkDwaPUa+ARVYZ4wJQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 at 11:50, Andrew Jeffery <andrew@aj.id.au> wrote:
>
> The 50MHz RCLK has to be enabled before the RMII interface will function.
>
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 35 +++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 9b7af94a40bb..9ff791fb0449 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -90,6 +90,9 @@ struct ftgmac100 {
>         struct mii_bus *mii_bus;
>         struct clk *clk;
>
> +       /* 2600 RMII clock gate */
> +       struct clk *rclk;
> +
>         /* Link management */
>         int cur_speed;
>         int cur_duplex;
> @@ -1718,12 +1721,14 @@ static void ftgmac100_ncsi_handler(struct ncsi_dev *nd)
>                    nd->link_up ? "up" : "down");
>  }
>
> -static void ftgmac100_setup_clk(struct ftgmac100 *priv)
> +static int ftgmac100_setup_clk(struct ftgmac100 *priv)
>  {
> -       priv->clk = devm_clk_get(priv->dev, NULL);
> -       if (IS_ERR(priv->clk))
> -               return;
> +       struct clk *clk;
>
> +       clk = devm_clk_get(priv->dev, NULL /* MACCLK */);
> +       if (IS_ERR(clk))
> +               return PTR_ERR(clk);
> +       priv->clk = clk;
>         clk_prepare_enable(priv->clk);
>
>         /* Aspeed specifies a 100MHz clock is required for up to
> @@ -1732,6 +1737,14 @@ static void ftgmac100_setup_clk(struct ftgmac100 *priv)
>          */
>         clk_set_rate(priv->clk, priv->use_ncsi ? FTGMAC_25MHZ :
>                         FTGMAC_100MHZ);
> +
> +       /* RCLK is for RMII, typically used for NCSI. Optional because its not
> +        * necessary if it's the 2400 MAC or the MAC is configured for RGMII
> +        */

Or for non-ASPEED users of this driver, assuming they exist.

Reviewed-by: Joel Stanley <joel@jms.id.au>


> +       priv->rclk = devm_clk_get_optional(priv->dev, "RCLK");
> +       clk_prepare_enable(priv->rclk);
> +
> +       return 0;
>  }
>
>  static int ftgmac100_probe(struct platform_device *pdev)
> @@ -1853,8 +1866,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
>                         goto err_setup_mdio;
>         }
>
> -       if (priv->is_aspeed)
> -               ftgmac100_setup_clk(priv);
> +       if (priv->is_aspeed) {
> +               err = ftgmac100_setup_clk(priv);
> +               if (err)
> +                       goto err_ncsi_dev;
> +       }
>
>         /* Default ring sizes */
>         priv->rx_q_entries = priv->new_rx_q_entries = DEF_RX_QUEUE_ENTRIES;
> @@ -1886,8 +1902,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
>
>         return 0;
>
> -err_ncsi_dev:
>  err_register_netdev:
> +       if (priv->rclk)
> +               clk_disable_unprepare(priv->rclk);
> +       clk_disable_unprepare(priv->clk);
> +err_ncsi_dev:
>         ftgmac100_destroy_mdio(netdev);
>  err_setup_mdio:
>         iounmap(priv->base);
> @@ -1909,6 +1928,8 @@ static int ftgmac100_remove(struct platform_device *pdev)
>
>         unregister_netdev(netdev);
>
> +       if (priv->rclk)
> +               clk_disable_unprepare(priv->rclk);
>         clk_disable_unprepare(priv->clk);
>
>         /* There's a small chance the reset task will have been re-queued,
> --
> 2.20.1
>
