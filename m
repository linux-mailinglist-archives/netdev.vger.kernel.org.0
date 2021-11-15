Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD8A4500F9
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhKOJSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:18:38 -0500
Received: from mail-yb1-f172.google.com ([209.85.219.172]:38776 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhKOJSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 04:18:22 -0500
Received: by mail-yb1-f172.google.com with SMTP id v64so45030562ybi.5;
        Mon, 15 Nov 2021 01:15:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jyzl7oZfTfctjkCbDjpVsRa/ezMbHf5XSEZ7cgOuE0g=;
        b=yHoi3O63Yyj0yY5wa5oiwVLQ853NE+qzHS53eaA3aTfFxJn9+DAYy9ZbJTVIIJoVdh
         tKh00J75J2zfVLsee0gSJozRnPny0UjVI9kDPcM+dnfNwRmrfYtynumxqmeylylErkLl
         76auhotkYGW7yfyBu02oRdcFqIS1LcfiLBk4S8BMiU6jUja1hyOdybvk7xJKbj1Nmgrn
         9IFoZUeof6HB33QNgLhwQrRxWJlc0HwFYRlGuyG54KjnXtsm/CaURx2E8DLNMP8rKTRo
         lgerOi7BknyKLwHDXDExw3JcsbTInLBJsUYqA8X3BFBkLmfYUusLsxWRzB+Y087TYsJc
         KMWg==
X-Gm-Message-State: AOAM530Ux8j5kx4QBBzznGpZXclgwTqALk+AjSe8FsvQ5Nj1bA9Zpf1Q
        GdWAJrFe7MmIqeY843MICVMadypXxMQRaHSezHG7ogYZsaKHgQ==
X-Google-Smtp-Source: ABdhPJwrV32VxQ+3kGtTABQunws8sfYjJXxMQtaGBbZ51iMbAmJ7LEFHHSOKyt6zRPScDJ2poZ/Ui+emLSD6bmwQ+2E=
X-Received: by 2002:a25:3d1:: with SMTP id 200mr41631260ybd.113.1636967725954;
 Mon, 15 Nov 2021 01:15:25 -0800 (PST)
MIME-Version: 1.0
References: <YZIWT9ATzN611n43@hovoldconsulting.com> <20211115083756.25971-1-paskripkin@gmail.com>
In-Reply-To: <20211115083756.25971-1-paskripkin@gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 15 Nov 2021 18:15:15 +0900
Message-ID: <CAMZ6RqJZqXHLrrbzerR6GzSKqtYE8j8qVSzH-Hdd_zjR6YUv9Q@mail.gmail.com>
Subject: Re: [PATCH v3] can: etas_es58x: fix error handling
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 15 Nov 2021 at 17:37, Pavel Skripkin <paskripkin@gmail.com> wrote:
> When register_candev() fails there are 2 possible device states:
> NETREG_UNINITIALIZED and NETREG_UNREGISTERED. None of them are suitable
> for calling unregister_candev(), because of following checks in
> unregister_netdevice_many():
>
>         if (dev->reg_state == NETREG_UNINITIALIZED)
>                 WARN_ON(1);
> ...
>         BUG_ON(dev->reg_state != NETREG_REGISTERED);
>
> To avoid possible BUG_ON or WARN_ON let's free current netdev before
> returning from es58x_init_netdev() and leave others (registered)
> net devices for es58x_free_netdevs().
>
> Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

> ---
>
> Changes in v3:
>         - Moved back es58x_dev->netdev[channel_idx] initialization,
>           since it's unsafe to intialize it _after_ register_candev()
>           call. Thanks to Johan Hovold <johan@kernel.org> for spotting
>           it

My bad on that. I missed the fact that the netdev_ops becomes
active once register_candev() returns.

> Changes in v2:
>         - Fixed Fixes: tag
>         - Moved es58x_dev->netdev[channel_idx] initialization at the end
>           of the function
>
> ---
>  drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
> index 96a13c770e4a..41c721f2fbbe 100644
> --- a/drivers/net/can/usb/etas_es58x/es58x_core.c
> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
> @@ -2098,8 +2098,11 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
>         netdev->flags |= IFF_ECHO;      /* We support local echo */
>
>         ret = register_candev(netdev);
> -       if (ret)
> +       if (ret) {
> +               free_candev(netdev);
> +               es58x_dev->netdev[channel_idx] = NULL;
>                 return ret;
> +       }
>
>         netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
>                                        es58x_dev->param->dql_min_limit);
> --
> 2.33.1
>
