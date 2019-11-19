Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B29102504
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfKSM6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:58:25 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:43765 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbfKSM6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 07:58:25 -0500
Received: by mail-yb1-f194.google.com with SMTP id r201so8696886ybc.10;
        Tue, 19 Nov 2019 04:58:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iGUreshl/jUKAV7h3ePAhyfmas1/gCvv6uy3G++925w=;
        b=XlpXoafkmE7SY7C/5S3OE1/qgzqiFQaJQVKtYoKnU65JQYXwyXiVY6h9XulsLfZUV6
         B0lDQ6KvPfEkYzUF12R9JY0pQSrwibQA5oSpZ+dKuQ01+EGDaqG1UuNV9BSSv2bZ9Q/r
         NB9YOtFRcwqLQBiaDyvgMHY/5tqCqXP5JGdLtDIElrS8kMR0XrKYf1fURGX4QMpRZluN
         bhgap1sWXqBIlViDK3vpCzFruisl5Uoxp/seRGsc6DJmFH6yH3RR+cyk1mnI13kb+wTh
         X5y2evAZuKfS9j0aF7K2MceJdAolNPA4zMrJM8OJ9uJzFuUuI/KTheyo0G1fS/z75cO/
         BS+g==
X-Gm-Message-State: APjAAAUWNq+zEXKpIaGBMGc8dRPEOxeN6Agy1yiMnnmwXVVigbwK4TR3
        jKMmpstTj/InPK68cN4TUFFTL4x1rW0gUlz+SbQ=
X-Google-Smtp-Source: APXvYqxQ2NP8UE+oe01b4UUlC7hZnTSSxNpqCcNRNJakRNjLijISk7RWnwspQrGrEpJONJTektvmRaXS1kTYu7iJUgg=
X-Received: by 2002:a25:a0d3:: with SMTP id i19mr27854070ybm.14.1574168303987;
 Tue, 19 Nov 2019 04:58:23 -0800 (PST)
MIME-Version: 1.0
References: <20191111071347.21712-1-yuehaibing@huawei.com>
In-Reply-To: <20191111071347.21712-1-yuehaibing@huawei.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 19 Nov 2019 18:28:12 +0530
Message-ID: <CAFcVECJQH15y78YPurq_m2bDigQ6EzSCZHZMROHRFe-rJKw88g@mail.gmail.com>
Subject: Re: [PATCH] mdio_bus: Fix PTR_ERR applied after initialization to constant
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>, mail@david-bauer.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 12:53 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix coccinelle warning:
>
> ./drivers/net/phy/mdio_bus.c:67:5-12: ERROR: PTR_ERR applied after initialization to constant on line 62
> ./drivers/net/phy/mdio_bus.c:68:5-12: ERROR: PTR_ERR applied after initialization to constant on line 62
>
> Fix this by using IS_ERR before PTR_ERR
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 71dd6c0dff51 ("net: phy: add support for reset-controller")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/phy/mdio_bus.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 2e29ab8..3587656 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -64,11 +64,12 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
>         if (mdiodev->dev.of_node)
>                 reset = devm_reset_control_get_exclusive(&mdiodev->dev,
>                                                          "phy");
> -       if (PTR_ERR(reset) == -ENOENT ||
> -           PTR_ERR(reset) == -ENOTSUPP)
> -               reset = NULL;
> -       else if (IS_ERR(reset))
> -               return PTR_ERR(reset);
> +       if (IS_ERR(reset)) {
> +               if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOSYS)
> +                       reset = NULL;
> +               else
> +                       return PTR_ERR(reset);
> +       }
>
>         mdiodev->reset_ctrl = reset;
>

Adding Michal Simek to add some test comments.

> --
> 2.7.4
>
>
