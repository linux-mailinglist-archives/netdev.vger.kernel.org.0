Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEC6109B69
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfKZJm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:42:56 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38220 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfKZJm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:42:56 -0500
Received: by mail-ed1-f67.google.com with SMTP id s10so15705118edi.5;
        Tue, 26 Nov 2019 01:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9bfdvk/BCYnBIN3lkt7QnRugpNhrBl4MqK4VJoegeaQ=;
        b=JyhC0a7WITO/qRb5QCbT71KZ6Nm+N7oCBp7ZhwJpZGQkhllijWbZ6ViWR2QQQy9XwR
         nP6bpB41eJiu4660U1Xgm+2ouCZH7fON7EMPTE2Rz/b13dyL4o3spO6XvGOAzFhGI/OS
         36+wXRGSTwQwBZ5wrpNCXFT7xAYUiTdFauMuJA2Q83O9Tt1x/UB+vLysF9rUpHIu+LTb
         W5alaHEXz6iWYRvIJdyMVK9Z3Ot9ulPOg4S1szYmRh2wOH37hDgnANDUtqug9I+M8b9E
         cssCeOvVSTJYOcGVkKw5b/y7Gdm1MK8zn5xpw2k67Jkvh+Vj53cV7WGR8CX8kPRiZcSr
         azpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9bfdvk/BCYnBIN3lkt7QnRugpNhrBl4MqK4VJoegeaQ=;
        b=S0h2zo2PU+gxNZLZUdjl5MaTxZt6YKIt+2A3fPCfuRwITemSaBGA9ul+0fJWN1Wv+s
         z02+rJKBGfYUXLjLcWQWN/og2eEZLGC0pLvNFnbDRAu1W4XajE/3DKwOhD+N3wPyS/5n
         PqYnv32RsOsIT+7BvH4pvpA5z5jKeZrOloYGEkPOus3KZg4x/5Zf9uJSttWmpK0EOsvO
         Kad+pBPEmPqO1ACRctEt2QJVqi+FiVKgPj6hyY2xIhZeZZJPfAHgTyTF3xyGuZrPaY1/
         peK3XQ2nZIYCAo6SyMHcS8fp6gBkeMpVor/RI5gxkt8z5VVLgJmnoEpPZouuQuB/qlzR
         fuSg==
X-Gm-Message-State: APjAAAWQ5cW8TJubgYvmXEVcp+mDuzEiNt7Y8kE2/DmGhcil1j2nsTnK
        GNCRH6Vc2qbY56Mud5O6YlrTni1WgOpw690gDHk=
X-Google-Smtp-Source: APXvYqyks7TiuCgvDEvHQo/6h3yAGojsPacxZkIOZyOWkCRlk0kc3juTtgdDjeLpfULEVNal73vtemHWYNM5TPheU3U=
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr41915513ejq.133.1574761374033;
 Tue, 26 Nov 2019 01:42:54 -0800 (PST)
MIME-Version: 1.0
References: <20191126093008.19742-1-o.rempel@pengutronix.de>
In-Reply-To: <20191126093008.19742-1-o.rempel@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 26 Nov 2019 11:42:42 +0200
Message-ID: <CA+h21hrs0Fo3-xS4GNwyFhJmbk+_xeY+WxondH06GWbH5PJFYg@mail.gmail.com>
Subject: Re: [PATCH v2] net: dsa: sja1105: print info about probed chip only
 after everything was done.
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Tue, 26 Nov 2019 at 11:30, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Currently we will get "Probed switch chip" notification multiple times
> if first probe failed by some reason. To avoid this confusing notifications move
> dev_info to the end of probe.
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

The merge window just opened yesterday:
http://vger.kernel.org/~davem/net-next.html.
Come back in 2 weeks with this patch for net-next.

>  drivers/net/dsa/sja1105/sja1105_main.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index aa140662c7c2..34544b1c30dc 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -2191,8 +2191,6 @@ static int sja1105_probe(struct spi_device *spi)
>                 return rc;
>         }
>
> -       dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
> -
>         ds = dsa_switch_alloc(dev, SJA1105_NUM_PORTS);
>         if (!ds)
>                 return -ENOMEM;
> @@ -2218,7 +2216,13 @@ static int sja1105_probe(struct spi_device *spi)
>
>         sja1105_tas_setup(ds);
>
> -       return dsa_register_switch(priv->ds);
> +       rc = dsa_register_switch(priv->ds);
> +       if (rc)
> +               return rc;
> +
> +       dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
> +
> +       return 0;
>  }
>
>  static int sja1105_remove(struct spi_device *spi)
> --
> 2.24.0
>

Thanks,
-Vladimir
