Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F8D2C6111
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgK0IkS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Nov 2020 03:40:18 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46372 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgK0IkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:40:16 -0500
Received: by mail-ot1-f67.google.com with SMTP id z23so365706oti.13;
        Fri, 27 Nov 2020 00:40:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/D+lVsFpiig9p8Mfv+F/WnI4wKF69UpUHln9lDG06g4=;
        b=OvGI2LLkQRzeWnjXwcv4a9BF3RX71atfnHf/Y5PY6fvbrzqqEX7jcrwCldbQv9GLpy
         D8zvGJGvQkfVFIk5XZZL9N94Cp6BH74eATxdOFbkuFKEWK5MO2m1bbD8Bx/fA1oKbu0s
         YxNyj4Nc0HH/UMiLlq+7Zb0jlNPKltRbw5EVUXX+KWwtvy7bX2HfLLUegeqtGhAy5BMB
         uhMFch4Mt8DBUbE8QdRRnOqFJurxqXlEFvwNCleXo6mv+FoAv0R7tEppFQTRBrBAuu7Z
         GrkK3JfGSBgSfVkYuWbCEag4jO9Lo3QQLVN9o4D/mEfP22YxAussd4m460Shl8n1PwqJ
         qwYA==
X-Gm-Message-State: AOAM530sxVPmbTv/r6BVfnK9waIhzZDBNLhgE8HwNbMHY41PfivqOp4e
        m3r+YB4S/MLDqydQ9bbxBwEI8Qe59Y0sqHqM0Y4=
X-Google-Smtp-Source: ABdhPJy2I/IdfAm6V2ydZbwLB9NPNLYo9PucEpxX/NL/qzuCx8bfpYwJU7BhpITpgvBGwlFRBVNr8EmnqamS0CIYUsg=
X-Received: by 2002:a9d:686:: with SMTP id 6mr4709371otx.107.1606466415531;
 Fri, 27 Nov 2020 00:40:15 -0800 (PST)
MIME-Version: 1.0
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de> <20201126165950.2554997-2-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20201126165950.2554997-2-u.kleine-koenig@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 27 Nov 2020 09:40:04 +0100
Message-ID: <CAMuHMdW4J0xA6T4AWqZdo1go1kxWqVSSo5JXQpUAM4yWEpDdOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/ps3: make system bus's remove and shutdown
 callbacks return void
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Geoff Levand <geoff@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-block@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

On Thu, Nov 26, 2020 at 6:03 PM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> The driver core ignores the return value of struct device_driver::remove
> because there is only little that can be done. For the shutdown callback
> it's ps3_system_bus_shutdown() which ignores the return value.
>
> To simplify the quest to make struct device_driver::remove return void,
> let struct ps3_system_bus_driver::remove return void, too. All users
> already unconditionally return 0, this commit makes it obvious that
> returning an error code is a bad idea and ensures future users behave
> accordingly.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks for your patch!

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Note that the same can be done for ps3_vuart_port_driver.remove().

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
