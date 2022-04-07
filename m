Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CCA4F775B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiDGHYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiDGHYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:24:10 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033A4DBB;
        Thu,  7 Apr 2022 00:22:11 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l7so3531039ejn.2;
        Thu, 07 Apr 2022 00:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwGQPeLGONcDmqJfPIeESPpipQ500aFLCZgIRy5zqZ0=;
        b=cGpUq0EaSPKZUmC5xLx1Jzohz8q2BA0SCfgkM8wrethxxkDt/+g2N32fYAJT3XYV7c
         gQbz6QMaUUd43OLUA3Qr9ybm972y3GG09XSDuFu30DSIEbHhMHSFAgUidWPsz8GrgGeW
         s7tbaW4vOsf45FRd0naJvDCrCyKtKsWV4L7c0X8uFXIFfWJcIPONICfRuDmKWStRxSCw
         O51niQQXIBWe/kqVxIekXIQ/hHMRE3f0A3lQ3oU7dB+SGmXs9PVY3nPhJ24PTFgfotQd
         B8VGD/Fzr7+dIrGtF2FRhhrKgQ9sbMeozCRly8MMFIdcZp6QMqHRMmi7EmTJnuHLjSxB
         q5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwGQPeLGONcDmqJfPIeESPpipQ500aFLCZgIRy5zqZ0=;
        b=eSHnZOiNGhZwGg8k5lAaG1nZZs4y1xnXp4A6nZNaNTohPEfwBw8onMMr/DLnQ0Ls1L
         0wUXekcsyykhAqCxj/qwUMFSoKYTxpBWMlVWU/XCS83HM/cSKk7zT9F0KhAcV9K48mBN
         7dxoBJUbIejmY4LL5k+f4Bzavi9vWA7GWO2Wex711nf6p1anzQrSxNIJyHtFxnzuugnJ
         bEMXe1V46OWh3zJfWm8z6mauFG+4jKf7+fMZPNclNcUwUYeHEoVKuMe7y5+DQ6U8kmcN
         vC3fllTzwm9daE9AVQOVuSW6uG3tFNj97Et1I6ir0csQh9YGjo+eFIFdHHhoCXsPogAU
         dT1Q==
X-Gm-Message-State: AOAM532PCUE5LW8a8rvdvhLWKz2RBemkwgSllZGY6IIxXzJ8v/6QK6iV
        7/WW/qjbHKE0qN/jj80nJvNR9dfusThSxiRjhHE=
X-Google-Smtp-Source: ABdhPJzQRq8/eIccgTS4Y7+Q3Go4ejR4ddyxfTtgPRrDE8QiY00n90m58Se3srjqqXXHUSIg52T71GhZZnCQSkeWe4o=
X-Received: by 2002:a17:907:8a26:b0:6e1:2646:ef23 with SMTP id
 sc38-20020a1709078a2600b006e12646ef23mr12386094ejc.109.1649316129522; Thu, 07
 Apr 2022 00:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649310812.git.duoming@zju.edu.cn> <9ca3ab0b40c875b6019f32f031c68a1ae80dd73a.1649310812.git.duoming@zju.edu.cn>
In-Reply-To: <9ca3ab0b40c875b6019f32f031c68a1ae80dd73a.1649310812.git.duoming@zju.edu.cn>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Thu, 7 Apr 2022 00:21:58 -0700
Message-ID: <CAMo8BfLG_u2z2HwY9Qo6cFgNoSrrz2mS2iD+rtj-uyrKhZYmLw@mail.gmail.com>
Subject: Re: [PATCH 11/11] arch: xtensa: platforms: Fix deadlock in rs_close()
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, jgg@ziepe.ca, wg@grandegger.com,
        mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        jes@trained-monkey.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, alexander.deucher@amd.com,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>, linux-rdma@vger.kernel.org,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-hippi@sunsite.dk, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Duoming,

On Wed, Apr 6, 2022 at 11:38 PM Duoming Zhou <duoming@zju.edu.cn> wrote:
>
> There is a deadlock in rs_close(), which is shown
> below:
>
>    (Thread 1)              |      (Thread 2)
>                            | rs_open()
> rs_close()                 |  mod_timer()
>  spin_lock_bh() //(1)      |  (wait a time)
>  ...                       | rs_poll()
>  del_timer_sync()          |  spin_lock() //(2)
>  (wait timer to stop)      |  ...
>
> We hold timer_lock in position (1) of thread 1 and
> use del_timer_sync() to wait timer to stop, but timer handler
> also need timer_lock in position (2) of thread 2.
> As a result, rs_close() will block forever.

I agree with this.

> This patch extracts del_timer_sync() from the protection of
> spin_lock_bh(), which could let timer handler to obtain
> the needed lock.

Looking at the timer_lock I don't really understand what it protects.
It looks like it is not needed at all.

Also, I see that rs_poll rewinds the timer regardless of whether del_timer_sync
was called or not, which violates del_timer_sync requirements.

> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  arch/xtensa/platforms/iss/console.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
> index 81d7c7e8f7e..d431b61ae3c 100644
> --- a/arch/xtensa/platforms/iss/console.c
> +++ b/arch/xtensa/platforms/iss/console.c
> @@ -51,8 +51,10 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
>  static void rs_close(struct tty_struct *tty, struct file * filp)
>  {
>         spin_lock_bh(&timer_lock);
> -       if (tty->count == 1)
> +       if (tty->count == 1) {
> +               spin_unlock_bh(&timer_lock);
>                 del_timer_sync(&serial_timer);
> +       }
>         spin_unlock_bh(&timer_lock);

Now in case tty->count == 1 the timer_lock would be unlocked twice.

-- 
Thanks.
-- Max
