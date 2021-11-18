Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C358455727
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 09:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244698AbhKRIm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 03:42:58 -0500
Received: from mail-vk1-f178.google.com ([209.85.221.178]:33464 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242185AbhKRImz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 03:42:55 -0500
Received: by mail-vk1-f178.google.com with SMTP id d130so3379869vke.0;
        Thu, 18 Nov 2021 00:39:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRhaJP30xRfGoC6YfQR1gJhdJCfA0BcIWGwc3ucBNgY=;
        b=eP4RJ2wYhz2Aod0sWLHh3u8VGOjWWffBO5antXYK6ZvykOLwg7Fk65vJOafO9wWeoH
         Za1eTahl3P8stzkWSetnagkc0eq4V8gnnYOeTOCdelO7W/S85KFeJzoMpF2Qhmiy6yss
         gOdb/O8SK5LyV6wVljcRRDdq70Et5UV2TRoF/EeNABiMKALQRPyA+IzGuoLBmut7zEw7
         kn+VgGfIlZEXtGSXoQqskd5fqmTpKEHYcvfh8aLRD54+4jcDUUkn4t3Az8BbzCD+jy8T
         Qeo7V9YUgsRtl0L4Y1zltWfiVfzgZlC4JcZ/ueEOOje3XNE50SsR734xvbsdkbgk/2A9
         VZ4Q==
X-Gm-Message-State: AOAM531G8DZAIkZ7M4XEa0o7UmqaB+Osz1iMmHO9jTKF6utvsIKVGx3R
        +Rta+oSKWhcLYUyTj88guhZFP4H0ZPLVhg==
X-Google-Smtp-Source: ABdhPJw6TFS2OAxiO9CEBXu37PgWmucGjUZy3O0qTJmxjSvOWLW3HvjdYpV98A4hxhApXn5vYYnZXg==
X-Received: by 2002:a05:6122:2158:: with SMTP id m24mr34049603vkd.1.1637224794868;
        Thu, 18 Nov 2021 00:39:54 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id 92sm1396828uav.9.2021.11.18.00.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 00:39:54 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id o1so12010161uap.4;
        Thu, 18 Nov 2021 00:39:54 -0800 (PST)
X-Received: by 2002:a05:6102:2910:: with SMTP id cz16mr78807614vsb.9.1637224794088;
 Thu, 18 Nov 2021 00:39:54 -0800 (PST)
MIME-Version: 1.0
References: <1637204329-3314-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1637204329-3314-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 18 Nov 2021 09:39:42 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXL4nfiq8B-PtAiQmCQkZMBP8t-CUBO4bbMZumiA=QpaQ@mail.gmail.com>
Message-ID: <CAMuHMdXL4nfiq8B-PtAiQmCQkZMBP8t-CUBO4bbMZumiA=QpaQ@mail.gmail.com>
Subject: Re: [PATCH -next v2] ethernet: renesas: Use div64_ul instead of do_div
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yang,

On Thu, Nov 18, 2021 at 4:13 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
> do_div() does a 64-by-32 division. Here the divisor is an
> unsigned long which on some platforms is 64 bit wide. So use
> div64_ul instead of do_div to avoid a possible truncation.
>
> Eliminate the following coccicheck warning:
> ./drivers/net/ethernet/renesas/ravb_main.c:2492:1-7: WARNING:
> do_div() does a 64-by-32 division, please consider using div64_ul instead.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2489,7 +2489,7 @@ static int ravb_set_gti(struct net_device *ndev)
>                 return -EINVAL;
>
>         inc = 1000000000ULL << 20;
> -       do_div(inc, rate);
> +       inc = div64_ul(inc, rate);
>
>         if (inc < GTI_TIV_MIN || inc > GTI_TIV_MAX) {
>                 dev_err(dev, "gti.tiv increment 0x%llx is outside the range 0x%x - 0x%x\n",

Please also replace

    #include <asm/div64.h>

by

#include <linux/math64.h>

With that added:

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
