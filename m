Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E82A87C85
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 16:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407113AbfHIOUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 10:20:03 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41046 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfHIOUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 10:20:03 -0400
Received: by mail-qk1-f194.google.com with SMTP id g17so1061588qkk.8;
        Fri, 09 Aug 2019 07:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqpS6f4iYT2/EOjyhlDBwimFIDoQ2vjPU9zyXzeymVs=;
        b=tgGY1n0aBq1wKRyOE9mbT7s3RsuCu6FgHAPajrNs49W6xNDNuuAvZ3HM4L/hXgys30
         QLAl3mnAEJtFOeRw0fAmJ3LdBx9nq05hQzg6knN7Znykfb3fvo2IKs+zjhUQS6cqpQ22
         ijEhehP3zy+v71aQfpVYsClxRfSlxGL1afgYfvjqNRkOjk6HDu6IudEsXfphJTGM9srJ
         1cf1PFaTftLzRizDDHjfVsAfDksMVPT8I8y9TjWH3YbXUoT36edrLBuPhlKaYMmFvASN
         YVVEEv+FOIq6FRRJYScZoLazV2uYwS9UDTEkuhjW53AHvuB1d1WadYnxXGpeWrLEZO3x
         JdOg==
X-Gm-Message-State: APjAAAXDxVeskRlnapr5AGSYvOW7zYvbLNyU2j9d+P3tgbQ2sICMtZW8
        gXGXkxW76cxl4mqtx5W0BbbONm+N7oOR9WnLzeo=
X-Google-Smtp-Source: APXvYqy/OT0e+ifcdg76ad6xNKU9QCStCMIG/+ooQXzRuWl//U3NqYzpdPro7Befy76nezGoQdOa5mEAGNXNhGehJZQ=
X-Received: by 2002:a37:4ac3:: with SMTP id x186mr17754552qka.138.1565360402354;
 Fri, 09 Aug 2019 07:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-6-arnd@arndb.de>
 <CA+rxa6p4gD7+6-aRyd4-V4TvkyMiUh9ueMLc6ggBaDC=LG7fQg@mail.gmail.com>
In-Reply-To: <CA+rxa6p4gD7+6-aRyd4-V4TvkyMiUh9ueMLc6ggBaDC=LG7fQg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 9 Aug 2019 16:19:46 +0200
Message-ID: <CAK8P3a0Do2=80bOEgi2=773rtek3wkHuQNESePZijy8f6pWJAg@mail.gmail.com>
Subject: Re: [PATCH 05/14] gpio: lpc32xx: allow building on non-lpc32xx targets
To:     Sylvain Lemieux <slemieux.tyco@gmail.com>
Cc:     soc@kernel.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 10:02 PM Sylvain Lemieux <slemieux.tyco@gmail.com> wrote:

> >
> > +       gpio_reg_base = devm_platform_ioremap_resource(pdev, 0);
> > +       if (gpio_reg_base)
> > +               return -ENXIO;
>
> The probe function will always return an error.
> Please replace the previous 2 lines with:
>     if (IS_ERR(gpio_reg_base))
>         return PTR_ERR(gpio_reg_base);
>
> You can add my acked-by and tested-by in the v2 patch.
> Acked-by: Sylvain Lemieux <slemieux.tyco@gmail.com>
> Tested-by: Sylvain Lemieux <slemieux.tyco@gmail.com>

Ok, fixed now, along with addressing Bartosz' concerns.

       Arnd
