Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BD42C2585
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387510AbgKXMRt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Nov 2020 07:17:49 -0500
Received: from mail-ej1-f68.google.com ([209.85.218.68]:43275 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbgKXMRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:17:48 -0500
Received: by mail-ej1-f68.google.com with SMTP id k27so28112790ejs.10;
        Tue, 24 Nov 2020 04:17:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VUOwed7/avy6Sfz8h2pEiBST+7n37x1MRVNbS7uJ1/c=;
        b=AUIz8s49eJQg6vWRozBalrD4GfY8DTzT7qzUNiqapb9+0o7yAJ3f98gu5asTYww4ml
         5flgpeG2wrNOfNfqcHOWWBSC5/zfPjAHooaWHr5nF2PXz8RxFvgGYrV5L9o/RpQn7Scn
         mDcNa+TYklb0SEkFSbaO4Ga9yxXm0Gt1hpMhKkNC7cYMGxx60S1i+M7IdlUaL5nMuGe6
         2ZrlAheHbN+NLR9tRTDkK5RIrQPmh+G1AsOUyk6UPaOzZy4OA6CYh1okPH7yl2u7jn1Q
         4Hm+I3rInHmrsqoAU7mNell8ai8epY98wgWc07g4n3aVHY+Qtqy3TSPApD//14bjRmFB
         /FLw==
X-Gm-Message-State: AOAM530BCpN2ybaGuL++cUQ91ASS9xg7kiQMohB9ZQCfgJ+6CI+zw7Dv
        3whNC+j8g1xlOSpjfmDY1/k=
X-Google-Smtp-Source: ABdhPJyFvPWTFflUiBH2trFrIJCnrRiTpXbadgQlvJnJj6jm3c56JHDp0y58SUwUeKMKS2nz+qlf9A==
X-Received: by 2002:a17:906:a856:: with SMTP id dx22mr4164864ejb.134.1606220266162;
        Tue, 24 Nov 2020 04:17:46 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id g20sm6898192ejk.3.2020.11.24.04.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 04:17:44 -0800 (PST)
Date:   Tue, 24 Nov 2020 13:17:42 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v7 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20201124121742.GA35334@kozik-lap>
References: <20201124120330.32445-1-l.stelmach@samsung.com>
 <CGME20201124120337eucas1p268c7e3147ea36e62d40d252278c5dcb7@eucas1p2.samsung.com>
 <20201124120330.32445-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201124120330.32445-4-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 01:03:30PM +0100, Łukasz Stelmach wrote:
> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
> supports SPI connection.
> 
> The driver has been ported from the vendor kernel for ARTIK5[2]
> boards. Several changes were made to adapt it to the current kernel
> which include:
> 
> + updated DT configuration,
> + clock configuration moved to DT,
> + new timer, ethtool and gpio APIs,
> + dev_* instead of pr_* and custom printk() wrappers,
> + removed awkward vendor power managemtn.
> + introduced ethtool tunable to control SPI compression
> 
> [1] https://www.asix.com.tw/products.php?op=pItemdetail&PItemID=104;65;86&PLine=65
> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-artik/
> 
> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> chips are not compatible. Hence, two separate drivers are required.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  MAINTAINERS                                |    6 +
>  drivers/net/ethernet/Kconfig               |    1 +
>  drivers/net/ethernet/Makefile              |    1 +
>  drivers/net/ethernet/asix/Kconfig          |   35 +
>  drivers/net/ethernet/asix/Makefile         |    6 +
>  drivers/net/ethernet/asix/ax88796c_ioctl.c |  221 ++++
>  drivers/net/ethernet/asix/ax88796c_ioctl.h |   26 +
>  drivers/net/ethernet/asix/ax88796c_main.c  | 1132 ++++++++++++++++++++
>  drivers/net/ethernet/asix/ax88796c_main.h  |  561 ++++++++++
>  drivers/net/ethernet/asix/ax88796c_spi.c   |  112 ++
>  drivers/net/ethernet/asix/ax88796c_spi.h   |   69 ++
>  include/uapi/linux/ethtool.h               |    1 +
>  net/ethtool/common.c                       |    1 +
>  13 files changed, 2172 insertions(+)
>  create mode 100644 drivers/net/ethernet/asix/Kconfig
>  create mode 100644 drivers/net/ethernet/asix/Makefile
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 14b8ec0bb58b..930dc859d4f7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2812,6 +2812,12 @@ S:	Maintained
>  F:	Documentation/hwmon/asc7621.rst
>  F:	drivers/hwmon/asc7621.c
>  
> +ASIX AX88796C SPI ETHERNET ADAPTER
> +M:	Łukasz Stelmach <l.stelmach@samsung.com>
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/net/asix,ax99706c-spi.yaml

Wrong file name.

Best regards,
Krzysztof


> +F:	drivers/net/ethernet/asix/ax88796c_*
> +
