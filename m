Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD93B75AC
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388404AbfISJGM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Sep 2019 05:06:12 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46885 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388194AbfISJGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 05:06:12 -0400
Received: by mail-ot1-f65.google.com with SMTP id f21so2369902otl.13;
        Thu, 19 Sep 2019 02:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wDQS67j3lG7TwomTYu6phRtQVo+Lq0+3xuq57RPV6D8=;
        b=i1wJ+zoQWcdeFJPKz4EmDzW6m0EliuvcQPuUNzIcZtgWhqgeLwuxiR68NdnizJJDgG
         IHPXTyhCEax+zzvWHGjCxIvtqGgU9BCCvdqAtXiFQa/z3j/HEtvgt3K6ly6YVkfP02p7
         XG/IHq2mXhiRezcDi9JSkPbq5e5LgtF4OiaORJRbq8jpFfZotrNbLkF2dyEzAGF8PQoo
         k+IxIBy8F3Nl+cGMv3kM9jUafBhQ5We1vZW05zedARE9kUEdpg9BfMuUAMgECwfcWJIz
         Vy8q8ZQS+AbvbTEqiI4yKqKYeiMseEVTmIOHWGK8GXrN7Zvv88+u0nWNCAJ4hrUJRq2r
         8q/g==
X-Gm-Message-State: APjAAAVxtZsBodgZQtPUOAh0zuEHBpjmUNADTTEx2ABlB1FrqBAU3SMe
        xDUY7bonLGG7/oGrjuzKMsKZlpmdcBgdfGvM1bc=
X-Google-Smtp-Source: APXvYqzkCVuzCTBNypl4Lg61PDxEIAb1NQVdXkZR4+Hm131qcRPrUobeyAbVKE3pL8YI02rUdNiF6OshW6FylYOc9ac=
X-Received: by 2002:a9d:4d0d:: with SMTP id n13mr5907611otf.297.1568883971244;
 Thu, 19 Sep 2019 02:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190731.094150.851749535529247096.davem@davemloft.net>
 <20190731185023.20954-1-natechancellor@gmail.com> <b3444283-7a77-ece8-7ac6-41756aa7dc60@infradead.org>
 <64f7ef68-c373-5ff5-ff6d-8a7ce0e30798@infradead.org>
In-Reply-To: <64f7ef68-c373-5ff5-ff6d-8a7ce0e30798@infradead.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 19 Sep 2019 11:06:00 +0200
Message-ID: <CAMuHMdXya55UJttU1xvX5+-N658Xqfa0k8sSKTGbtdBHgPEFcg@mail.gmail.com>
Subject: Re: [PATCH] net: mdio-octeon: Fix build error and Kconfig warning
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        driverdevel <devel@driverdev.osuosl.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        kbuild test robot <lkp@intel.com>,
        kernel-build-reports@lists.linaro.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mark Brown <broonie@kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 1:52 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> However, there are lots of type/cast warnings in both mdio-octeon and mdio-cavium:
>
> ../drivers/net/phy/mdio-octeon.c: In function ‘octeon_mdiobus_probe’:
> ../drivers/net/phy/mdio-octeon.c:48:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>    (u64)devm_ioremap(&pdev->dev, mdio_phys, regsize);
>    ^

cavium_mdiobus.register_base should be "void __iomem *" instead of "u64",
and the cast should be dropped.

> In file included from ../drivers/net/phy/mdio-octeon.c:14:0:
> ../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>  #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
>                                                 ^

... which allows to drop this cast as well.

Casts are evil, and usually a sign that you're doing something wrong.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
