Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579907D217
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 01:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfGaXwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 19:52:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47310 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfGaXwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 19:52:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Z/8fjbB6GIqa8OqZZjiQ3WTsAAPhEVjbBU3v9+5XIIE=; b=ZlgztYtZjDXm02P01Yu4eNfIZT
        ly/I/jMw27KXas0BzEVHXE0amgQVbqABM0R0ZGjFs3VPLlzbCdqV6CNWAmqNeFoDtMBn4wIbvM2e9
        F+O/niXaakVZmVagOQWTHhi3jPFq9NEf+LhfTm9zuXSr2P4wBHOiJFuzc4frQ96BmKOi9iBDdeHIS
        i8w7Ce25MVOJ+RHGKey3FQMqQ5dC53pmrCKvv+yW6gHu6o0KvJ8HhnHejXH9uifCFRcmChuwHbAZ0
        jLidXwQlDs/3J/2fTQ6YpL25pOX6HOTGwpxIG65yP7T/UxcPrmBAoOSkuuuQfxHkznbYNFK4lo+V5
        Y1d97xGg==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=[192.168.1.17])
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hsyO5-0000rm-SG; Wed, 31 Jul 2019 23:52:06 +0000
Subject: Re: [PATCH] net: mdio-octeon: Fix build error and Kconfig warning
To:     Nathan Chancellor <natechancellor@gmail.com>, davem@davemloft.net
Cc:     andrew@lunn.ch, broonie@kernel.org, devel@driverdev.osuosl.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        hkallweit1@gmail.com, kernel-build-reports@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, willy@infradead.org,
        kbuild test robot <lkp@intel.com>
References: <20190731.094150.851749535529247096.davem@davemloft.net>
 <20190731185023.20954-1-natechancellor@gmail.com>
 <b3444283-7a77-ece8-7ac6-41756aa7dc60@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <64f7ef68-c373-5ff5-ff6d-8a7ce0e30798@infradead.org>
Date:   Wed, 31 Jul 2019 16:52:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b3444283-7a77-ece8-7ac6-41756aa7dc60@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/19 2:55 PM, Randy Dunlap wrote:
> On 7/31/19 11:50 AM, Nathan Chancellor wrote:
>> arm allyesconfig warns:
>>
>> WARNING: unmet direct dependencies detected for MDIO_OCTEON
>>   Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=y] && MDIO_BUS [=y]
>> && 64BIT && HAS_IOMEM [=y] && OF_MDIO [=y]
>>   Selected by [y]:
>>   - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC &&
>> NETDEVICES [=y] || COMPILE_TEST [=y])
>>
>> and errors:
>>
>> In file included from ../drivers/net/phy/mdio-octeon.c:14:
>> ../drivers/net/phy/mdio-octeon.c: In function 'octeon_mdiobus_probe':
>> ../drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of
>> function 'writeq'; did you mean 'writeb'?
>> [-Werror=implicit-function-declaration]
>>   111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
>>       |                                    ^~~~~~
>> ../drivers/net/phy/mdio-octeon.c:56:2: note: in expansion of macro
>> 'oct_mdio_writeq'
>>    56 |  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
>>       |  ^~~~~~~~~~~~~~~
>> cc1: some warnings being treated as errors
>>
>> This allows MDIO_OCTEON to be built with COMPILE_TEST as well and
>> includes the proper header for readq/writeq. This does not address
>> the several -Wint-to-pointer-cast and -Wpointer-to-int-cast warnings
>> that appeared as a result of commit 171a9bae68c7 ("staging/octeon:
>> Allow test build on !MIPS") in these files.
>>
>> Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Reported-by: Mark Brown <broonie@kernel.org>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> 
> With today's linux-next (20190731), I am still seeing a Kconfig warning and
> build errors (building for i386):
> 
> and applying Greg's "depends on NETDEVICES" patch and this patch:
> 
> WARNING: unmet direct dependencies detected for MDIO_OCTEON
>   Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=m] && MDIO_BUS [=m] && (64BIT [=n] || COMPILE_TEST [=y]) && HAS_IOMEM [=y] && OF_MDIO [=n]
>   Selected by [m]:
>   - OCTEON_ETHERNET [=m] && STAGING [=y] && (CAVIUM_OCTEON_SOC || COMPILE_TEST [=y]) && NETDEVICES [=y]
> 
> ERROR: "cavium_mdiobus_write" [drivers/net/phy/mdio-octeon.ko] undefined!
> ERROR: "cavium_mdiobus_read" [drivers/net/phy/mdio-octeon.ko] undefined!
> 
> 
> kernel .config file is attached.
> 
> Am I missing another patch?
> 
> thanks.

If I add this to drivers/staging/octeon/Kconfig:
	select MDIO_OCTEON
+	select MDIO_CAVIUM
	help

then the build succeeds.

This isn't being done by make *config because MDIO_OCTEON depends on OF_MDIO,
which is not set in my .config file, so the "select MDIO_CAVIUM" in MDIO_OCTEON
is not done.

However, there are lots of type/cast warnings in both mdio-octeon and mdio-cavium:

../drivers/net/phy/mdio-octeon.c: In function ‘octeon_mdiobus_probe’:
../drivers/net/phy/mdio-octeon.c:48:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   (u64)devm_ioremap(&pdev->dev, mdio_phys, regsize);
   ^
In file included from ../drivers/net/phy/mdio-octeon.c:14:0:
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-octeon.c:56:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-octeon.c:77:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-octeon.c: In function ‘octeon_mdiobus_remove’:
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-octeon.c:91:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
  ^~~~~~~~~~~~~~~

and

  CC [M]  drivers/net/phy/mdio-cavium.o
In file included from ../drivers/net/phy/mdio-cavium.c:11:0:
../drivers/net/phy/mdio-cavium.c: In function ‘cavium_mdiobus_set_mode’:
../drivers/net/phy/mdio-cavium.h:114:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_readq(addr)  readq((void *)addr)
                                     ^
../drivers/net/phy/mdio-cavium.c:21:16: note: in expansion of macro ‘oct_mdio_readq’
  smi_clk.u64 = oct_mdio_readq(p->register_base + SMI_CLK);
                ^~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-cavium.c:24:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_clk.u64, p->register_base + SMI_CLK);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.c: In function ‘cavium_mdiobus_c45_addr’:
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-cavium.c:39:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_wr.u64, p->register_base + SMI_WR_DAT);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-cavium.c:47:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:114:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_readq(addr)  readq((void *)addr)
                                     ^
../drivers/net/phy/mdio-cavium.c:54:16: note: in expansion of macro ‘oct_mdio_readq’
   smi_wr.u64 = oct_mdio_readq(p->register_base + SMI_WR_DAT);
                ^~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.c: In function ‘cavium_mdiobus_read’:
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-cavium.c:86:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:114:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_readq(addr)  readq((void *)addr)
                                     ^
../drivers/net/phy/mdio-cavium.c:93:16: note: in expansion of macro ‘oct_mdio_readq’
   smi_rd.u64 = oct_mdio_readq(p->register_base + SMI_RD_DAT);
                ^~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.c: In function ‘cavium_mdiobus_write’:
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-cavium.c:125:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_wr.u64, p->register_base + SMI_WR_DAT);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:113:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
                                                ^
../drivers/net/phy/mdio-cavium.c:131:2: note: in expansion of macro ‘oct_mdio_writeq’
  oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
  ^~~~~~~~~~~~~~~
../drivers/net/phy/mdio-cavium.h:114:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
 #define oct_mdio_readq(addr)  readq((void *)addr)
                                     ^
../drivers/net/phy/mdio-cavium.c:138:16: note: in expansion of macro ‘oct_mdio_readq’
   smi_wr.u64 = oct_mdio_readq(p->register_base + SMI_WR_DAT);
                ^~~~~~~~~~~~~~




>> ---
>>  drivers/net/phy/Kconfig       | 2 +-
>>  drivers/net/phy/mdio-cavium.h | 2 ++
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
>> index 20f14c5fbb7e..ed2edf4b5b0e 100644
>> --- a/drivers/net/phy/Kconfig
>> +++ b/drivers/net/phy/Kconfig
>> @@ -159,7 +159,7 @@ config MDIO_MSCC_MIIM
>>  
>>  config MDIO_OCTEON
>>  	tristate "Octeon and some ThunderX SOCs MDIO buses"
>> -	depends on 64BIT
>> +	depends on 64BIT || COMPILE_TEST
>>  	depends on HAS_IOMEM && OF_MDIO
>>  	select MDIO_CAVIUM
>>  	help
>> diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
>> index ed5f9bb5448d..b7f89ad27465 100644
>> --- a/drivers/net/phy/mdio-cavium.h
>> +++ b/drivers/net/phy/mdio-cavium.h
>> @@ -108,6 +108,8 @@ static inline u64 oct_mdio_readq(u64 addr)
>>  	return cvmx_read_csr(addr);
>>  }
>>  #else
>> +#include <linux/io-64-nonatomic-lo-hi.h>
>> +
>>  #define oct_mdio_writeq(val, addr)	writeq(val, (void *)addr)
>>  #define oct_mdio_readq(addr)		readq((void *)addr)
>>  #endif
>>
> 
> 


-- 
~Randy
