Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B357C206
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 03:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiGUB6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 21:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiGUB6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 21:58:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F3C6E2D6;
        Wed, 20 Jul 2022 18:58:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so134781pjf.2;
        Wed, 20 Jul 2022 18:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ftZmQnNxSbBgGxR5gxqXE4IdbtT6X/p5Ec8B9Vn+x7g=;
        b=qrRsvYIvHunFmKLnL0KKZbsoF09Zae5Nyxvvp2JUqqOcFmHuOoxROb4Y6mPqazxavg
         rGfHsgv+zn+DUzRYJ4SbH/V2z3b2JKQL9j7fTxh3dYNw1cgM3P5MaCtBBFzaV3SvqqcM
         pNfoobD89tofIJPydUuJrl5oJDVQ2pBV8TpDI3lHn6paymKtf1UxTHC4EgwMY/fmh4iI
         Im5gckNJ/CB1WldghugzlBjcs1wZRPQH6d73De7jcFjsmIWIpq56LOYdaa4N7cZMs2+R
         fEQXwhvMuf3m4rwTLSkBVeQhLxkSGDL+e+xt3BCoyjvokTPaRnI7ILbaYaAFF6EeV/gk
         06JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftZmQnNxSbBgGxR5gxqXE4IdbtT6X/p5Ec8B9Vn+x7g=;
        b=bgPqM32J6aAQ+p27skfNSn6NHm9QUHhjHZUown9xabM3yGfSq7qVhzd9SvmJBWzixC
         14MP9CukMSeymDi3EWiv2EP1DraV3Kv5/WOxoagwioW+yypyTg2ABGdmkgh9/uUrGdrD
         gYPnXUPr5MMCekz1uLJqRerYvwWmY1XUvRh59GfOg7tVw6J0mjWRFsb89A/p+RRpI06i
         137H26k600L0n7763paPvnxSn6zdSPRHNRqpycWEKv56UBHhYfnShywCJf4FTmV0G15V
         Rd9Tssjnk3meCD/C2PF01iXv4oI5nXVNCmAEIJlTeI9s3y/EGQ0YSw4qBWz0Yi6ry6ER
         L/kw==
X-Gm-Message-State: AJIora9NZvHVunUigUogkWPqYDaKhybJ6konO0cPQvi1Og+uXjck715P
        9YhEE4aIhSwrO2Kc1vqOQmkmo6Ltjpot9b6en68=
X-Google-Smtp-Source: AGRyM1t6N7pQcjCsI7OAPPR2xzUGupyIxto7KPa5rosYau5ExUl6th5F/uXzTmwuWKLkGf+X0VhV2mO9Jk/JkPR4BUk=
X-Received: by 2002:a17:90a:b785:b0:1f1:be59:a607 with SMTP id
 m5-20020a17090ab78500b001f1be59a607mr8540324pjr.84.1658368695502; Wed, 20 Jul
 2022 18:58:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220715072951.859586-1-dario.binacchi@amarulasolutions.com>
In-Reply-To: <20220715072951.859586-1-dario.binacchi@amarulasolutions.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Thu, 21 Jul 2022 07:28:03 +0530
Message-ID: <CAFqt6zaMnfGhwxnnJrbW1eoiGy46-WNUe8H-iqztRmZW5Z8jfQ@mail.gmail.com>
Subject: Re: [PATCH v3] can: slcan: do not sleep with a spin lock held
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, ltp@lists.linux.it,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        kbuild test robot <lkp@intel.com>,
        Richard Palethorpe <rpalethorpe@suse.de>,
        kernel test robot <oliver.sang@intel.com>, lkp@lists.01.org,
        Jiri Slaby <jirislaby@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 1:00 PM Dario Binacchi
<dario.binacchi@amarulasolutions.com> wrote:
>
> We can't call close_candev() with a spin lock held, so release the lock
> before calling it. After calling close_candev(), we can update the
> fields of the private `struct can_priv' without having to acquire the
> lock.

But here we are updating private 'struct can_priv' before close_candev() while
taking the lock.  If we go by change logs, then spin_unlock_bh() need to called
before close_candev() and we can update the private 'struct can_priv'
in existing place.

>
> Fixes: c4e54b063f42f ("can: slcan: use CAN network device driver API")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/linux-kernel/Ysrf1Yc5DaRGN1WE@xsang-OptiPlex-9020/
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>
> ---
>
> Changes in v3:
> - Update the commit message.
> - Reset sl->rcount and sl->xleft before releasing the spin lock.
>
> Changes in v2:
> - Release the lock just before calling the close_candev().
>
>  drivers/net/can/slcan/slcan-core.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
> index 54d29a410ad5..d40ddc596596 100644
> --- a/drivers/net/can/slcan/slcan-core.c
> +++ b/drivers/net/can/slcan/slcan-core.c
> @@ -689,15 +689,14 @@ static int slc_close(struct net_device *dev)
>                 clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
>         }
>         netif_stop_queue(dev);
> +       sl->rcount   = 0;
> +       sl->xleft    = 0;
> +       spin_unlock_bh(&sl->lock);
>         close_candev(dev);
>         sl->can.state = CAN_STATE_STOPPED;
>         if (sl->can.bittiming.bitrate == CAN_BITRATE_UNKNOWN)
>                 sl->can.bittiming.bitrate = CAN_BITRATE_UNSET;
>
> -       sl->rcount   = 0;
> -       sl->xleft    = 0;
> -       spin_unlock_bh(&sl->lock);
> -
>         return 0;
>  }
>
> --
> 2.32.0
>
>
