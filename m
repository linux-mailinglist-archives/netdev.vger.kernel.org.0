Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C3D44FE5F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 06:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhKOFbZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Nov 2021 00:31:25 -0500
Received: from mail-yb1-f173.google.com ([209.85.219.173]:35686 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhKOFa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 00:30:57 -0500
Received: by mail-yb1-f173.google.com with SMTP id y3so43554735ybf.2;
        Sun, 14 Nov 2021 21:28:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v5fTG6MNp2HS7i48+J/mKwrj0s8rCtB8xm+WnwI515g=;
        b=xwP3GmKk1+v27vSdf80VphPll9nkCBHQrnR/Rt9/e6G6P/94c8EEo/Qv5bsHOwK9ZE
         6kMuS6iTtSFI3P0Dk3MvcvJuU9jfLcJosXqZFPOOJQDBi4dvMwFGp3cPStWOvyww0LaW
         BQ/SgLSc2V1W+yMEhuQxeBYjCIZdboCiA/2ro5NnAc71UAVa8cIOMwZksqpWedNlyH+m
         Si9CNIU0ooeUgepzUTnQ2t/OQhD7gljR+oPqGlIkjmIuBjWRJHVGze46Lo9xz5fadf45
         z4uX5f10FWVB4qr/KLUpDhnqh26HsJtx8FLsOkEpRtLbnaQobjNdiWKfJ5jlmvMWGlqH
         lMhQ==
X-Gm-Message-State: AOAM532yTzmTkbIGj3sX9p66oKsQgANaoMo6LaM+6d71dp2/YL5L0LkD
        Ecdm28SoP/I+c6DE0Yh4eyXafLNJMx/e3OYyoqU=
X-Google-Smtp-Source: ABdhPJwuscqIaNTF4YFMzPY/Wwze3+G5xvnTV88ZJ9sIH1Ef/hVWXgl/v6PaAQhXN9mU99RnPV1cZs/mKG8GUBncE/s=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr38956699ybt.152.1636954082480;
 Sun, 14 Nov 2021 21:28:02 -0800 (PST)
MIME-Version: 1.0
References: <20211114205839.15316-1-paskripkin@gmail.com>
In-Reply-To: <20211114205839.15316-1-paskripkin@gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 15 Nov 2021 14:27:51 +0900
Message-ID: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
Subject: Re: [PATCH] can: etas_es58x: fix error handling
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

Thanks for the patch!

On Mon. 15 Nov 2021 at 05:58, Pavel Skripkin <paskripkin@gmail.com> wrote:
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
> Fixes: 004653f0abf2 ("can: etas_es58x: add es58x_free_netdevs() to factorize code")

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X
CAN USB interfaces")

The bug existed from the initial commit.  Prior to the
introduction of es58x_free_netdevs(), unregister_candev() was
called in the error handling of es58x_probe():

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/can/usb/etas_es58x/es58x_core.c?id=8537257874e949a59c834cecfd5a063e11b64b0b#n2234

> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
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

A nitpick, but if you don’t mind, I would prefer to set
es58x_dev->netdev[channel_idx] after register_candev() succeeds
so that we do not have to reset it to NULL in the error handling.

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c
b/drivers/net/can/usb/etas_es58x/es58x_core.c
index ce2b9e1ce3af..fb0daad9b9c8 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2091,18 +2091,20 @@ static int es58x_init_netdev(struct
es58x_device *es58x_dev, int channel_idx)
                return -ENOMEM;
        }
        SET_NETDEV_DEV(netdev, dev);
-       es58x_dev->netdev[channel_idx] = netdev;
        es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);

        netdev->netdev_ops = &es58x_netdev_ops;
        netdev->flags |= IFF_ECHO;      /* We support local echo */

        ret = register_candev(netdev);
-       if (ret)
+       if (ret) {
+               free_candev(netdev);
                return ret;
+       }

        netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
                                       es58x_dev->param->dql_min_limit);
+       es58x_dev->netdev[channel_idx] = netdev;

        return ret;
 }

>                 return ret;
> +       }
>
>         netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
>                                        es58x_dev->param->dql_min_limit);
