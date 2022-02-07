Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C50B4AC7F8
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiBGRwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245428AbiBGRsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:48:17 -0500
Received: from mail.baikalelectronics.ru (mail.baikalelectronics.com [87.245.175.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D431CC0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:48:15 -0800 (PST)
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id D84078030799;
        Mon,  7 Feb 2022 20:48:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru D84078030799
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1644256095;
        bh=rLPiE/be9e44RDr/O+z5JDDdkk+ezE59m/Mx8v4dh+M=;
        h=Date:From:To:CC:Subject:References:In-Reply-To:From;
        b=Ej0GFn+cCyaO5pvI12rN9AXavw8FpSqe8fAR1SlnjtTJJwNK7XaEDoxsfJLMl97Jv
         yQ9GEwQASJLfnIVsG+832JLfPHJBsklcfCYOZt98ixf47tF0F6+RHhijEBAaSRe2VS
         YibEIx1AXoogtocvcHPhHdgUsA2VrSKEXBOO/S2s=
Received: from mobilestation (192.168.152.164) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 7 Feb 2022 20:47:54 +0300
Date:   Mon, 7 Feb 2022 20:48:14 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Alexey Sheplyakov <asheplyakov@basealt.ru>
CC:     Serge Semin <fancer.lancer@gmail.com>, <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <20220207174814.wxhzwi74gbcieu3p@mobilestation>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
 <20220128150642.qidckst5mzkpuyr3@mobilestation>
 <YfuzTO/3XCs+XFOv@asheplyakov-rocket>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YfuzTO/3XCs+XFOv@asheplyakov-rocket>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 02:49:48PM +0400, Alexey Sheplyakov wrote:
> Hello,
> 
> On Fri, Jan 28, 2022 at 06:06:42PM +0300, Serge Semin wrote:
>  
> > My comments regarding the most problematic parts of this patch are
> > below.
> > 
> > On Wed, Jan 26, 2022 at 12:44:55PM +0400, Alexey Sheplyakov wrote:
> > > The gigabit Ethernet controller available in Baikal-T1 and Baikal-M
> > > SoCs is a Synopsys DesignWare MAC IP core, already supported by
> > > the stmmac driver.
> > > 
> > > This patch implements some SoC specific operations (DMA reset and
> > > speed fixup) necessary for Baikal-T1/M variants.
> > > 
> > > Signed-off-by: Alexey Sheplyakov <asheplyakov@basealt.ru>
> > > Signed-off-by: Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
> > > ---
> > >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 +
> > >  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> > >  .../ethernet/stmicro/stmmac/dwmac-baikal.c    | 199 ++++++++++++++++++
> > >  .../ethernet/stmicro/stmmac/dwmac1000_core.c  |   1 +
> > >  .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |  46 ++--
> > >  .../ethernet/stmicro/stmmac/dwmac1000_dma.h   |  26 +++
> > >  .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |   8 +
> > >  7 files changed, 274 insertions(+), 18 deletions(-)
> > >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
> > >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.h
> > > 
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > > index 929cfc22cd0c..d8e6dcb98e6c 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > > @@ -66,6 +66,17 @@ config DWMAC_ANARION
> > >  
> > >  	  This selects the Anarion SoC glue layer support for the stmmac driver.
> > >  
> > > +config DWMAC_BAIKAL
> > > +	tristate "Baikal Electronics GMAC support"
> > > +	default MIPS_BAIKAL_T1
> > > +	depends on OF && (MIPS || ARM64 || COMPILE_TEST)
> > > +	help
> > > +	  Support for gigabit ethernet controller on Baikal Electronics SoCs.
> > > +
> > > +	  This selects the Baikal Electronics SoCs glue layer support for
> > > +	  the stmmac driver. This driver is used for Baikal-T1 and Baikal-M
> > > +	  SoCs gigabit ethernet controller.
> > > +
> > >  config DWMAC_INGENIC
> > >  	tristate "Ingenic MAC support"
> > >  	default MACH_INGENIC
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
> > > index d4e12e9ace4f..ad138062e199 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> > > @@ -14,6 +14,7 @@ stmmac-$(CONFIG_STMMAC_SELFTESTS) += stmmac_selftests.o
> > >  # Ordering matters. Generic driver must be last.
> > >  obj-$(CONFIG_STMMAC_PLATFORM)	+= stmmac-platform.o
> > >  obj-$(CONFIG_DWMAC_ANARION)	+= dwmac-anarion.o
> > > +obj-$(CONFIG_DWMAC_BAIKAL)	+= dwmac-baikal.o
> > >  obj-$(CONFIG_DWMAC_INGENIC)	+= dwmac-ingenic.o
> > >  obj-$(CONFIG_DWMAC_IPQ806X)	+= dwmac-ipq806x.o
> > >  obj-$(CONFIG_DWMAC_LPC18XX)	+= dwmac-lpc18xx.o
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
> > > new file mode 100644
> > > index 000000000000..9133188a5d1b
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
> > > @@ -0,0 +1,199 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +/*
> > > + * Baikal-T1/M SoCs DWMAC glue layer
> > > + *
> > > + * Copyright (C) 2015,2016,2021 Baikal Electronics JSC
> > > + * Copyright (C) 2020-2022 BaseALT Ltd
> > > + * Authors: Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
> > > + *          Alexey Sheplyakov <asheplyakov@basealt.ru>
> > > + */
> > > +
> > > +#include <linux/clk.h>
> > > +#include <linux/iopoll.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of.h>
> > > +#include <linux/platform_device.h>
> > > +
> > > +#include "stmmac.h"
> > > +#include "stmmac_platform.h"
> > > +#include "common.h"
> > > +#include "dwmac_dma.h"
> > > +#include "dwmac1000_dma.h"
> > > +
> > > +#define MAC_GPIO	0x00e0	/* GPIO register */
> > > +#define MAC_GPIO_GPO	BIT(8)	/* Output port */
> > > +
> > > +struct baikal_dwmac {
> > > +	struct device	*dev;
> > > +	struct clk	*tx2_clk;
> > > +};
> > > +
> > 
> > > +static int baikal_dwmac_dma_reset(void __iomem *ioaddr)
> > > +{
> > > +	int err;
> > > +	u32 value;
> > > +
> > > +	/* DMA SW reset */
> > > +	value = readl(ioaddr + DMA_BUS_MODE);
> > > +	value |= DMA_BUS_MODE_SFT_RESET;
> > > +	writel(value, ioaddr + DMA_BUS_MODE);
> > > +
> > > +	usleep_range(100, 120);
> > > +
> > > +	/* Clear PHY reset */
> > > +	value = readl(ioaddr + MAC_GPIO);
> > > +	value |= MAC_GPIO_GPO;
> > > +	writel(value, ioaddr + MAC_GPIO);
> > > +
> > > +	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
> > > +				  !(value & DMA_BUS_MODE_SFT_RESET),
> > > +				  10000, 1000000);
> > > +}
> > > +
> > > +static const struct stmmac_dma_ops baikal_dwmac_dma_ops = {
> > > +	.reset = baikal_dwmac_dma_reset,
> > 
> > First of all this modification is redundant for the platforms not
> > using the GMAC GPOs as resets, and is harmful if these signals are
> > used for something not related with the GMAC interface. Secondly this
> > callback won't properly work for all PHY types (though is acceptable
> > for some simple PHYs, which don't require much initialization or have
> > suitable default setups).
> 

> As a matter of fact with this DMA reset method Ethernet works just fine
> on BFK3.1 board (based on Baikal-T1), TF307-MB-S-D board (Baikal-M),
> LGP-16 system on the module (Baikal-M) [1], and a few other Baikal-M
> based experimental boards. On all these boards Ethernet does NOT work
> with original dwmac_dma_reset.
> 
> [1] https://www.lagrangeproject.com/lagrange-sarmah-som

This doesn't work for my TP SFBT1 and MRBT1 boards. Network traffic is
mainly lost.

> 
> > The problem is in the way the MAC + PHY
> > initialization procedure is designed and in the way the embedded GPIOs
> > are used in the platform. Even if we assume that all DW GMAC/xGBE
> > GPIs/GPOs are used in conjunction with the corresponding GMAC
> > interface (it's wrong in general), the interface open procedure upon
> > return will still leave the PHY uninitialized or initialized with default
> > values. That happens due to the PHY initialization being performed
> > before the MAC initialization in the STMMAC open callback. Since the
> > later implies calling the DW GMAC soft-reset, the former turns to be
> > pointless due to the soft-reset causing the GPO toggle and consequent
> > PHY reset.
> > 
> > So to speak in order to cover all the GPI/GPO usage scenario and in
> > order to fix the problems described above the STMMAC core needs to be
> > also properly modified, which isn't that easy due to the way the
> > driver has evolved to.
> 

> I'm not trying to cover all usage scenarios. The current versions works
> just fine with all Baikal-M and Baikal-T1 boards I've got so far, and
> that is good enough for me.

AFAICS you aren't submitting a driver for the "Boards you've got", but
you claim it's compatible with the Baikal-M/T GMAC (no matter what you
say in the commit message, the driver code says otherwise). As I said
above it appears to be isn't fully compatible. It doesn't work for the
boards I've got. Moreover as I said it might be even harmful for the
platforms, with GPOs used for something reset-unrelated.

> 
> > > +static int dwmac_baikal_probe(struct platform_device *pdev)
> > > +{
> > > +	struct plat_stmmacenet_data *plat_dat;
> > > +	struct stmmac_resources stmmac_res;
> > > +	struct baikal_dwmac *dwmac;
> > > +	int ret;
> > > +
> > > +	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
> > > +	if (!dwmac)
> > > +		return -ENOMEM;
> > > +
> > > +	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > > +	if (ret) {
> > > +		dev_err(&pdev->dev, "no suitable DMA available\n");
> > > +		return ret;
> > > +	}
> > > +
> > > +	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
> > > +	if (IS_ERR(plat_dat)) {
> > > +		dev_err(&pdev->dev, "dt configuration failed\n");
> > > +		return PTR_ERR(plat_dat);
> > > +	}
> > > +
> > > +	dwmac->dev = &pdev->dev;
> > 
> > > +	dwmac->tx2_clk = devm_clk_get_optional(dwmac->dev, "tx2_clk");
> > > +	if (IS_ERR(dwmac->tx2_clk)) {
> > > +		ret = PTR_ERR(dwmac->tx2_clk);
> > > +		dev_err(&pdev->dev, "couldn't get TX2 clock: %d\n", ret);
> > > +		goto err_remove_config_dt;
> > > +	}
> > 
> > The bindings are much more comprehensive than just a single Tx-clock.
> > You are missing them here and in your DT-bindings patch. Please also
> > note you can't make the DT-resources name up without providing a
> > corresponding bindings schema update.
> 

> Can't parse this, sorry. Could you please elaborate what is exactly
> wrong here?

First of all, you don't need to create a special name for the
ordinary RGMII Tx clock source. DW GMAC doesn't care whether it's
doubled or not, just use "tx" here (suffix _clk is also redundant).
Secondly the MAC has got a certain set of the clock sources, embedded
GPIO controller, embedded RGMII Tx delay, Tx/Rx FIFO depths, AXI burst
length, etc. All of that is the device bindings.

> 
> > > +
> > > +	if (dwmac->tx2_clk)
> > > +		plat_dat->fix_mac_speed = baikal_dwmac_fix_mac_speed;
> > > +	plat_dat->bsp_priv = dwmac;
> > > +	plat_dat->has_gmac = 1;
> > > +	plat_dat->enh_desc = 1;
> > > +	plat_dat->tx_coe = 1;
> > > +	plat_dat->rx_coe = 1;
> > 
> > > +	plat_dat->clk_csr = 3;
> > 
> > Instead of fixing the stmmac_clk_csr_set() method you have provided
> > the clk_csr workaround. What if pclk rate is changed? Which BTW is
> > possible. =) In that case you'll get a wrong MDC rate.
> 
> 1) This works for me just fine with all Baikal-M and Baikal-T1 boards
>    I've got so far. 

I've changed APB clock to 200MHz on my platform. Now MDC lane is
clocked with 7.69MHz, which is out of what DW GMAC doc requires. Both
CSR and MDC clocks aren't fixed for a generic Baikal-T/M platform your
driver claims to be compatible with. So to speak this config is wrong.

> 2) I avoid changes in the generic stmmac code on purpose to keep the risk
>    of regressions minimal.

Good for you, but being afraid of introducing a regression in one place isn't
a good excuse of adding a broken code in another.

>  
> > > +	plat_dat->setup = baikal_dwmac_setup;
> > > +
> > > +	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> > > +	if (ret)
> > > +		goto err_remove_config_dt;
> > > +
> > > +	return 0;
> > > +
> > > +err_remove_config_dt:
> > > +	stmmac_remove_config_dt(pdev, plat_dat);
> > > +	return ret;
> > > +}
> > > +
> > > +static const struct of_device_id dwmac_baikal_match[] = {
> > 
> > > +	{ .compatible = "baikal,dwmac" },
> > 
> > Even though Baikal-T1 and Baikal-M1 have been synthesized with almost
> > identical IP-cores I wouldn't suggest to use the same compatible
> > string for both of them. At least those are different platforms with
> > different reference signals parameters. So it would be much better to
> > use the naming like "baikal,bt1-gmac" and "baikal,bm1-gmac" here.
> 
> OK, makes sense.
> 
> > 
> > > +	{ }
> > > +};
> > > +MODULE_DEVICE_TABLE(of, dwmac_baikal_match);
> > > +
> > > +static struct platform_driver dwmac_baikal_driver = {
> > > +	.probe	= dwmac_baikal_probe,
> > > +	.remove	= stmmac_pltfr_remove,
> > > +	.driver	= {
> > > +		.name = "baikal-dwmac",
> > > +		.pm = &stmmac_pltfr_pm_ops,
> > > +		.of_match_table = of_match_ptr(dwmac_baikal_match)
> > > +	}
> > > +};
> > > +module_platform_driver(dwmac_baikal_driver);
> > > +
> > > +MODULE_DESCRIPTION("Baikal-T1/M DWMAC driver");
> > > +MODULE_LICENSE("GPL");
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> > > index 76edb9b72675..7b8a955d98a9 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> > > @@ -563,3 +563,4 @@ int dwmac1000_setup(struct stmmac_priv *priv)
> > >  
> > >  	return 0;
> > >  }
> > > +EXPORT_SYMBOL_GPL(dwmac1000_setup);
> > 
> > As I said providing a platform-specific reset method won't solve the
> > problem with the PHYs resetting on each interface up/down procedures.
> > So exporting this method and the methods below will be just useless
> > since the provided fix isn't complete.
> 

> When the experiment and a theory disagree the experiment always wins.
> With this driver Ethernet works just fine with
> 
> * BFK3.1 board (Baikal-T1 reference boards)
> * TF307-MB-S-D board (Baikal-M)
> * LGP-16 system on the module (Baikal-M)
> 
> It might or might not work with other boards (although I haven't got
> such boards myself yet).

Well, we've got the boards for which it doesn't work.

> 
> Last but not least, if this driver is such a wrong and incomplete, why
> Baikal Electronics ships it in its vendor kernel [2]?
> 
> [2] https://github.com/baikalelectronics/kernel/blob/v5.4_BE-aarch64_stable/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
>     https://share.baikalelectronics.ru/index.php/s/Zi4tmLzpjCYccKb (warning: links are js-wrapped)
> 

Really? Backward question then. Do you want a wrong and incomplete
driver being integrated into the kernel? As I see it, you do. But we
don't. We want the mainline kernel to be stable, portable, and not
having temporal solutions "working for my case, and the rest doesn't
bother me".

-Sergey
