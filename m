Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E75807C1
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 20:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbfHCSe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 14:34:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40794 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbfHCSe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 14:34:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9M2MLeUnlkFI+r7V5jW757xqZ1JZIPJo/ExJUeqgiJ0=; b=dhCjxP1ZD5hspyeRKNOBJahqAN
        SyZcXf2GlXCQZpho8ysccaeEPWQ9BQArXRLlFmSMaa7rJhAqFRaOMunEBlqkxe0NfCsB4rIB9r5C/
        6bOuh6s4Foanl+nGjiKbrsvtLdxpXs3RrUVHQ/W1PL2OAHi8NrkrGv9xaOplzAVz25dUFE1TNMWlE
        D5JhvdOaEEzCiOBuaJkpWkVpzeYSRxgiKyz23ijfHuA8i7tnn95UxIogpRybJqFzm0ncEPtLW9rcc
        Wg8dsq1Y1qQueayrEyWt/ZftqASLsN1wbCUlhBqWuzTtskV/sS2zVLuBwLvtwpQaJGv50sdk5Rtp4
        hSaqRpwA==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=[192.168.1.17])
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1htyrE-00072c-JW; Sat, 03 Aug 2019 18:34:20 +0000
Subject: Re: [PATCH v2] net: mdio-octeon: Fix Kconfig warnings and build
 errors
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     andrew@lunn.ch, broonie@kernel.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, hkallweit1@gmail.com,
        kernel-build-reports@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        lkp@intel.com, netdev@vger.kernel.org, willy@infradead.org
References: <20190731185023.20954-1-natechancellor@gmail.com>
 <20190803060155.89548-1-natechancellor@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <11bf2f76-1487-7831-e6df-dbec632b3f34@infradead.org>
Date:   Sat, 3 Aug 2019 11:34:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190803060155.89548-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 11:01 PM, Nathan Chancellor wrote:
> After commit 171a9bae68c7 ("staging/octeon: Allow test build on
> !MIPS"), the following combination of configs cause a few Kconfig
> warnings and build errors (distilled from arm allyesconfig and Randy's
> randconfig builds):
> 
>     CONFIG_NETDEVICES=y
>     CONFIG_STAGING=y
>     CONFIG_COMPILE_TEST=y
> 
> and CONFIG_OCTEON_ETHERNET as either a module or built-in.
> 
> WARNING: unmet direct dependencies detected for MDIO_OCTEON
>   Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=y] && MDIO_BUS [=y]
> && 64BIT [=n] && HAS_IOMEM [=y] && OF_MDIO [=n]
>   Selected by [y]:
>   - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC ||
> COMPILE_TEST [=y]) && NETDEVICES [=y]
> 
> In file included from ../drivers/net/phy/mdio-octeon.c:14:
> ../drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of
> function ‘writeq’; did you mean ‘writel’?
> [-Werror=implicit-function-declaration]
>   111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
>       |                                    ^~~~~~
> 
> CONFIG_64BIT is not strictly necessary if the proper readq/writeq
> definitions are included from io-64-nonatomic-lo-hi.h.
> 
> CONFIG_OF_MDIO is not needed when CONFIG_COMPILE_TEST is enabled because
> of commit f9dc9ac51610 ("of/mdio: Add dummy functions in of_mdio.h.").
> 
> Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Works for me. Fixes the reported build errors.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

> ---
> 
> v1 -> v2:
> 
> * Address Randy's reported failure here: https://lore.kernel.org/netdev/b3444283-7a77-ece8-7ac6-41756aa7dc60@infradead.org/
>   by not requiring CONFIG_OF_MDIO when CONFIG_COMPILE_TEST is set.
> 
> * Improve commit message
> 
>  drivers/net/phy/Kconfig       | 4 ++--
>  drivers/net/phy/mdio-cavium.h | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 20f14c5fbb7e..0e3d9e3d3533 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -159,8 +159,8 @@ config MDIO_MSCC_MIIM
>  
>  config MDIO_OCTEON
>  	tristate "Octeon and some ThunderX SOCs MDIO buses"
> -	depends on 64BIT
> -	depends on HAS_IOMEM && OF_MDIO
> +	depends on (64BIT && OF_MDIO) || COMPILE_TEST
> +	depends on HAS_IOMEM
>  	select MDIO_CAVIUM
>  	help
>  	  This module provides a driver for the Octeon and ThunderX MDIO
> diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
> index ed5f9bb5448d..b7f89ad27465 100644
> --- a/drivers/net/phy/mdio-cavium.h
> +++ b/drivers/net/phy/mdio-cavium.h
> @@ -108,6 +108,8 @@ static inline u64 oct_mdio_readq(u64 addr)
>  	return cvmx_read_csr(addr);
>  }
>  #else
> +#include <linux/io-64-nonatomic-lo-hi.h>
> +
>  #define oct_mdio_writeq(val, addr)	writeq(val, (void *)addr)
>  #define oct_mdio_readq(addr)		readq((void *)addr)
>  #endif
> 


-- 
~Randy
