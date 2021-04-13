Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127D235D8F1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbhDMHd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:33:57 -0400
Received: from mail-ua1-f44.google.com ([209.85.222.44]:45913 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237567AbhDMHdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:33:54 -0400
Received: by mail-ua1-f44.google.com with SMTP id f4so5020807uad.12;
        Tue, 13 Apr 2021 00:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u6UFjwuyKnQpqmhtaDp8WV1qw1jwfIy1yUFgiKaV5UY=;
        b=tAh9slfyuOEcT93M35aK8CW7kqkE59vjDhsIWtgA16D7CtT7P64dq42H+tG2P6RyBv
         UbWmiVAkgT9HfXmVMBDCDQthz2yOXZXegr9ooDPF5i3koP4STM/G31DPf/MUpmmJbNpa
         G5Q4JlctLMKHQSjgjsxFkkTH22TbHzkNZZcAofHDxpYDnpG6XeAMsNMR+oZDcw2cNxs+
         ZphSk7dqlcgBWoir0UvduT9Oc6LePr0CmcGF6iAH6D20gVc9u0kbG23DWlwgQTsCEpTh
         e1vrjSPekmkMjfOvQ2GH05WPY/NgXUGkFagme4PPB/57Vq2JkCVQjljmX/HHEGsXJNWO
         kJVg==
X-Gm-Message-State: AOAM5306Y7SccntUKGCEAryVOc5FxmjKuxs4wpzvvGWzhJyVsJ4V1ZPW
        7Ub/e5s7ofiKL53fB5V3XRo9B2c5CuPUtU6eCLfcsktoX4I=
X-Google-Smtp-Source: ABdhPJzftKnn6TOjbesfeLhixPr7pqyQbLq0YkT7ZLi3DpLJBP2roway01ukDACwhunwhZgE9cRvfVZzumXQp/dxKLA=
X-Received: by 2002:ab0:3157:: with SMTP id e23mr21121382uam.106.1618299215073;
 Tue, 13 Apr 2021 00:33:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210412132619.7896-1-aford173@gmail.com> <20210412132619.7896-2-aford173@gmail.com>
In-Reply-To: <20210412132619.7896-2-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 13 Apr 2021 09:33:23 +0200
Message-ID: <CAMuHMdU5RfTGs3SCvJX9epKBLOo6o1BQMng49RjrBn+P7QOSeg@mail.gmail.com>
Subject: Re: [PATCH V4 2/2] net: ethernet: ravb: Enable optional refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Mon, Apr 12, 2021 at 3:27 PM Adam Ford <aford173@gmail.com> wrote:
> For devices that use a programmable clock for the AVB reference clock,
> the driver may need to enable them.  Add code to find the optional clock
> and enable it when available.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> ---
> V4:  Eliminate the NULL check when disabling refclk, and add a line
>      to disable the refclk if there is a failure after it's been
>      initialized.

Thanks for the update!

> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2148,6 +2148,13 @@ static int ravb_probe(struct platform_device *pdev)
>                 goto out_release;
>         }
>
> +       priv->refclk = devm_clk_get_optional(&pdev->dev, "refclk");
> +       if (IS_ERR(priv->refclk)) {
> +               error = PTR_ERR(priv->refclk);
> +               goto out_release;

Note that this will call clk_disable_unprepare() in case of failure, which is
fine, as that function is a no-op in case of a failed clock.

> +       }
> +       clk_prepare_enable(priv->refclk);
> +
>         ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
>         ndev->min_mtu = ETH_MIN_MTU;
>
> @@ -2244,6 +2251,7 @@ static int ravb_probe(struct platform_device *pdev)
>         if (chip_id != RCAR_GEN2)
>                 ravb_ptp_stop(ndev);
>  out_release:
> +       clk_disable_unprepare(priv->refclk);
>         free_netdev(ndev);
>
>         pm_runtime_put(&pdev->dev);

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
