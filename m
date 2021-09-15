Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9107F40C04A
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbhIOHOo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Sep 2021 03:14:44 -0400
Received: from mail-ua1-f41.google.com ([209.85.222.41]:36423 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236571AbhIOHOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:14:42 -0400
Received: by mail-ua1-f41.google.com with SMTP id u11so1093173uaw.3;
        Wed, 15 Sep 2021 00:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gL3z2tWaeR9gQ68ZsbvDrdBbJQtIPd0iNGfdcj7Yqw0=;
        b=MZnTBoLp0kte0QteC0VOy/nqLcEOBj1ddS6iv29JMD1qpgjYFy8K46SlaZwX2OipnY
         UcfgSIFGW+X8YYRb8RCP3O79yyqQdRajgOvCj2fXaTtSybazm4mb+ynE9h725jkv9tRe
         KqaJNu8mtoeCWZWoxJR8uzf0PlgX3gMIGurD3PkBjyB2g8dba85E8x6UpIOlmowvWBhQ
         U6nkOgwouB4tZb3JNE2+yxZmK9wpP9OIjJixRnhhT/x9HCR7giqAHFEsxiEVTCNZPIUC
         Xj93x2OanYpq/VtRj4VYj72kEb14mrC0ZnlPCcenTpaQsFk+gSfgZGddifTEAj4TUXb8
         73iQ==
X-Gm-Message-State: AOAM530kY5sRhGRAmr8aaOZ+eVkL63VqkvNHSlD9StDb4Uyhtr67LJF5
        cAx3xBzZ9MwFPy101e1jrA+tUHoMIL2a/6bjaH0=
X-Google-Smtp-Source: ABdhPJwMlq/6v9N2i8levGOTrmjVHBDQjw5jjBWFbomargFDdg/nJiQIcblwYe4WWeIs4KIzK7wOuDdDhvdAR/OeHzw=
X-Received: by 2002:ab0:6ec9:: with SMTP id c9mr7777343uav.114.1631690002856;
 Wed, 15 Sep 2021 00:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210915035227.630204-1-linux@roeck-us.net> <20210915035227.630204-2-linux@roeck-us.net>
In-Reply-To: <20210915035227.630204-2-linux@roeck-us.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Sep 2021 09:13:11 +0200
Message-ID: <CAMuHMdXZcrjGAE5OOipKsYpEgk9AZ_hrWKh+v81FMBtQTBv2LA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] compiler.h: Introduce absolute_pointer macro
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-sparse@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Günter,

On Wed, Sep 15, 2021 at 5:52 AM Guenter Roeck <linux@roeck-us.net> wrote:
> absolute_pointer() disassociates a pointer from its originating symbol
> type and context. Use it to prevent compiler warnings/errors such as
>
> drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
> ./arch/m68k/include/asm/string.h:72:25: error:
>         '__builtin_memcpy' reading 6 bytes from a region of size 0
>                 [-Werror=stringop-overread]
>
> Such warnings may be reported by gcc 11.x for string and memory operations
> on fixed addresses.
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: No change
>
>  include/linux/compiler.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index b67261a1e3e9..3d5af56337bd 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -188,6 +188,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
>      (typeof(ptr)) (__ptr + (off)); })
>  #endif
>
> +#define absolute_pointer(val)  RELOC_HIDE((void *)(val), 0)

I guess we're not worried about "val" being evaluated multiple
times inside RELOC_HIDE(), as this is mainly intended for constants?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
