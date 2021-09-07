Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A234C402992
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344667AbhIGNUd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Sep 2021 09:20:33 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:47021 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344724AbhIGNUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 09:20:32 -0400
Received: by mail-vs1-f47.google.com with SMTP id s15so8246557vst.13;
        Tue, 07 Sep 2021 06:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NHI+Pa7kQm8rs0bBC5L8bJlvdPPgIa62Ob/UtuDMfVo=;
        b=df5LRqNTmWMKzNUkgSZQBwj70o8WE4k0V+1cvCahE8ooMLArhOelkpOJxttMr+snr0
         wrSTGRI/Ittfpk/yocK9ziWI1hO3e0Uz+t1UVDSp+J7HijSMLMSClS9jYB3QyoQFUDpi
         hGVIitwHouCtAgPHd3aUYmZYjVziHmwFjDXThiqtbLEFGfMg2F5ZYgUsNPqDCvy8Q8PL
         n+8udWb4I4uWb2e4IfLBx63wHjbmWNKhxm9LDkU11JMvcL9CqqPqJrCEBLxJ7hmOUZq6
         k5N1nY0xHQ8lPj7BgH38pMnRheHdpFaycDyy79ghfsntVi3ZFt2hAOK9sH1797pyB6wB
         52Ow==
X-Gm-Message-State: AOAM530h4W9Yc+Fw7sgFLR6Z0jyoo9mTBz4SBDVq4wCAuLJtlhpQkdFx
        3HnIM47yZKShshZpXBrpMT/riQ0qI4mW83sqVDE=
X-Google-Smtp-Source: ABdhPJyFDgzbOAm3DT5TW8C/JmvVRnf5aqaNGBYl8TmqWSW5JkUFQhEcuKHa4G5bdVnVAP4VA+KYdw1JqqC9fxc/j2w=
X-Received: by 2002:a67:3289:: with SMTP id y131mr9094859vsy.37.1631020765432;
 Tue, 07 Sep 2021 06:19:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210907131046.117800-1-arnd@kernel.org>
In-Reply-To: <20210907131046.117800-1-arnd@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Sep 2021 15:19:13 +0200
Message-ID: <CAMuHMdX8CnSZaJ31RB0cefZjZiU3czvo-8RSSHeUGJDgwND0Cg@mail.gmail.com>
Subject: Re: [PATCH] ne2000: fix unused function warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Armin Wolf <W_Armin@gmx.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

Thanks for your patch!

On Tue, Sep 7, 2021 at 3:10 PM Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Geert noticed a warning on MIPS TX49xx:
>
> drivers/net/ethernet/8390/ne.c:909:20: warning: ‘ne_add_devices’ defined but not used [-Wunused-function]

And on Atari.

>
> Move the function into the #ifdef section that contains its
> only caller.

What about the second caller inside #ifdef MODULE?

> Fixes: 4228c3942821 ("make legacy ISA probe optional")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> --- a/drivers/net/ethernet/8390/ne.c
> +++ b/drivers/net/ethernet/8390/ne.c
> @@ -906,22 +906,6 @@ static struct platform_driver ne_driver = {
>         },
>  };
>
> -static void __init ne_add_devices(void)
> -{
> -       int this_dev;
> -       struct platform_device *pdev;
> -
> -       for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
> -               if (pdev_ne[this_dev])
> -                       continue;
> -               pdev = platform_device_register_simple(
> -                       DRV_NAME, this_dev, NULL, 0);
> -               if (IS_ERR(pdev))
> -                       continue;
> -               pdev_ne[this_dev] = pdev;
> -       }
> -}
> -
>  #ifdef MODULE
>  static int __init ne_init(void)
>  {
> @@ -953,6 +937,22 @@ static int __init ne_init(void)
>  module_init(ne_init);
>
>  #ifdef CONFIG_NETDEV_LEGACY_INIT
> +static void __init ne_add_devices(void)
> +{
> +       int this_dev;
> +       struct platform_device *pdev;
> +
> +       for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
> +               if (pdev_ne[this_dev])
> +                       continue;
> +               pdev = platform_device_register_simple(
> +                       DRV_NAME, this_dev, NULL, 0);
> +               if (IS_ERR(pdev))
> +                       continue;
> +               pdev_ne[this_dev] = pdev;
> +       }
> +}
> +
>  struct net_device * __init ne_probe(int unit)
>  {
>         int this_dev;
> --
> 2.29.2
>


--
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
