Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B52F4A82B3
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242098AbiBCKt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:49:57 -0500
Received: from air.basealt.ru ([194.107.17.39]:38606 "EHLO air.basealt.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230016AbiBCKt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 05:49:57 -0500
Received: by air.basealt.ru (Postfix, from userid 490)
        id 8434458980A; Thu,  3 Feb 2022 10:49:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on
        sa.local.altlinux.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.1
Received: from localhost (unknown [193.43.9.4])
        by air.basealt.ru (Postfix) with ESMTPSA id 7247058958B;
        Thu,  3 Feb 2022 10:49:52 +0000 (UTC)
Date:   Thu, 3 Feb 2022 14:49:48 +0400
From:   Alexey Sheplyakov <asheplyakov@basealt.ru>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <YfuzTO/3XCs+XFOv@asheplyakov-rocket>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
 <20220128150642.qidckst5mzkpuyr3@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128150642.qidckst5mzkpuyr3@mobilestation>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Jan 28, 2022 at 06:06:42PM +0300, Serge Semin wrote:
 
> My comments regarding the most problematic parts of this patch are
> below.
> 
> On Wed, Jan 26, 2022 at 12:44:55PM +0400, Alexey Sheplyakov wrote:
> > The gigabit Ethernet controller available in Baikal-T1 and Baikal-M
> > SoCs is a Synopsys DesignWare MAC IP core, already supported by
> > the stmmac driver.
> > 
> > This patch implements some SoC specific operations (DMA reset and
> > speed fixup) necessary for Baikal-T1/M variants.
> > 
> > Signed-off-by: Alexey Sheplyakov <asheplyakov@basealt.ru>
> > Signed-off-by: Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 +
> >  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> >  .../ethernet/stmicro/stmmac/dwmac-baikal.c    | 199 ++++++++++++++++++
> >  .../ethernet/stmicro/stmmac/dwmac1000_core.c  |   1 +
> >  .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |  46 ++--
> >  .../ethernet/stmicro/stmmac/dwmac1000_dma.h   |  26 +++
> >  .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |   8 +
> >  7 files changed, 274 insertions(+), 18 deletions(-)
> >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
> >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.h
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > index 929cfc22cd0c..d8e6dcb98e6c 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > @@ -66,6 +66,17 @@ config DWMAC_ANARION
> >  
> >  	  This selects the Anarion SoC glue layer support for the stmmac driver.
> >  
> > +config DWMAC_BAIKAL
> > +	tristate "Baikal Electronics GMAC support"
> > +	default MIPS_BAIKAL_T1
> > +	depends on OF && (MIPS || ARM64 || COMPILE_TEST)
> > +	help
> > +	  Support for gigabit ethernet controller on Baikal Electronics SoCs.
> > +
> > +	  This selects the Baikal Electronics SoCs glue layer support for
> > +	  the stmmac driver. This driver is used for Baikal-T1 and Baikal-M
> > +	  SoCs gigabit ethernet controller.
> > +
> >  config DWMAC_INGENIC
> >  	tristate "Ingenic MAC support"
> >  	default MACH_INGENIC
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
> > index d4e12e9ace4f..ad138062e199 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> > +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> > @@ -14,6 +14,7 @@ stmmac-$(CONFIG_STMMAC_SELFTESTS) += stmmac_selftests.o
> >  # Ordering matters. Generic driver must be last.
> >  obj-$(CONFIG_STMMAC_PLATFORM)	+= stmmac-platform.o
> >  obj-$(CONFIG_DWMAC_ANARION)	+= dwmac-anarion.o
> > +obj-$(CONFIG_DWMAC_BAIKAL)	+= dwmac-baikal.o
> >  obj-$(CONFIG_DWMAC_INGENIC)	+= dwmac-ingenic.o
> >  obj-$(CONFIG_DWMAC_IPQ806X)	+= dwmac-ipq806x.o
> >  obj-$(CONFIG_DWMAC_LPC18XX)	+= dwmac-lpc18xx.o
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
> > new file mode 100644
> > index 000000000000..9133188a5d1b
> > --- /dev/null
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
> > @@ -0,0 +1,199 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Baikal-T1/M SoCs DWMAC glue layer
> > + *
> > + * Copyright (C) 2015,2016,2021 Baikal Electronics JSC
> > + * Copyright (C) 2020-2022 BaseALT Ltd
> > + * Authors: Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
> > + *          Alexey Sheplyakov <asheplyakov@basealt.ru>
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include "stmmac.h"
> > +#include "stmmac_platform.h"
> > +#include "common.h"
> > +#include "dwmac_dma.h"
> > +#include "dwmac1000_dma.h"
> > +
> > +#define MAC_GPIO	0x00e0	/* GPIO register */
> > +#define MAC_GPIO_GPO	BIT(8)	/* Output port */
> > +
> > +struct baikal_dwmac {
> > +	struct device	*dev;
> > +	struct clk	*tx2_clk;
> > +};
> > +
> 
> > +static int baikal_dwmac_dma_reset(void __iomem *ioaddr)
> > +{
> > +	int err;
> > +	u32 value;
> > +
> > +	/* DMA SW reset */
> > +	value = readl(ioaddr + DMA_BUS_MODE);
> > +	value |= DMA_BUS_MODE_SFT_RESET;
> > +	writel(value, ioaddr + DMA_BUS_MODE);
> > +
> > +	usleep_range(100, 120);
> > +
> > +	/* Clear PHY reset */
> > +	value = readl(ioaddr + MAC_GPIO);
> > +	value |= MAC_GPIO_GPO;
> > +	writel(value, ioaddr + MAC_GPIO);
> > +
> > +	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
> > +				  !(value & DMA_BUS_MODE_SFT_RESET),
> > +				  10000, 1000000);
> > +}
> > +
> > +static const struct stmmac_dma_ops baikal_dwmac_dma_ops = {
> > +	.reset = baikal_dwmac_dma_reset,
> 
> First of all this modification is redundant for the platforms not
> using the GMAC GPOs as resets, and is harmful if these signals are
> used for something not related with the GMAC interface. Secondly this
> callback won't properly work for all PHY types (though is acceptable
> for some simple PHYs, which don't require much initialization or have
> suitable default setups).

As a matter of fact with this DMA reset method Ethernet works just fine
on BFK3.1 board (based on Baikal-T1), TF307-MB-S-D board (Baikal-M),
LGP-16 system on the module (Baikal-M) [1], and a few other Baikal-M
based experimental boards. On all these boards Ethernet does NOT work
with original dwmac_dma_reset.

[1] https://www.lagrangeproject.com/lagrange-sarmah-som

> The problem is in the way the MAC + PHY
> initialization procedure is designed and in the way the embedded GPIOs
> are used in the platform. Even if we assume that all DW GMAC/xGBE
> GPIs/GPOs are used in conjunction with the corresponding GMAC
> interface (it's wrong in general), the interface open procedure upon
> return will still leave the PHY uninitialized or initialized with default
> values. That happens due to the PHY initialization being performed
> before the MAC initialization in the STMMAC open callback. Since the
> later implies calling the DW GMAC soft-reset, the former turns to be
> pointless due to the soft-reset causing the GPO toggle and consequent
> PHY reset.
> 
> So to speak in order to cover all the GPI/GPO usage scenario and in
> order to fix the problems described above the STMMAC core needs to be
> also properly modified, which isn't that easy due to the way the
> driver has evolved to.

I'm not trying to cover all usage scenarios. The current versions works
just fine with all Baikal-M and Baikal-T1 boards I've got so far, and
that is good enough for me.

> > +static int dwmac_baikal_probe(struct platform_device *pdev)
> > +{
> > +	struct plat_stmmacenet_data *plat_dat;
> > +	struct stmmac_resources stmmac_res;
> > +	struct baikal_dwmac *dwmac;
> > +	int ret;
> > +
> > +	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
> > +	if (!dwmac)
> > +		return -ENOMEM;
> > +
> > +	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "no suitable DMA available\n");
> > +		return ret;
> > +	}
> > +
> > +	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
> > +	if (IS_ERR(plat_dat)) {
> > +		dev_err(&pdev->dev, "dt configuration failed\n");
> > +		return PTR_ERR(plat_dat);
> > +	}
> > +
> > +	dwmac->dev = &pdev->dev;
> 
> > +	dwmac->tx2_clk = devm_clk_get_optional(dwmac->dev, "tx2_clk");
> > +	if (IS_ERR(dwmac->tx2_clk)) {
> > +		ret = PTR_ERR(dwmac->tx2_clk);
> > +		dev_err(&pdev->dev, "couldn't get TX2 clock: %d\n", ret);
> > +		goto err_remove_config_dt;
> > +	}
> 
> The bindings are much more comprehensive than just a single Tx-clock.
> You are missing them here and in your DT-bindings patch. Please also
> note you can't make the DT-resources name up without providing a
> corresponding bindings schema update.

Can't parse this, sorry. Could you please elaborate what is exactly
wrong here?

> > +
> > +	if (dwmac->tx2_clk)
> > +		plat_dat->fix_mac_speed = baikal_dwmac_fix_mac_speed;
> > +	plat_dat->bsp_priv = dwmac;
> > +	plat_dat->has_gmac = 1;
> > +	plat_dat->enh_desc = 1;
> > +	plat_dat->tx_coe = 1;
> > +	plat_dat->rx_coe = 1;
> 
> > +	plat_dat->clk_csr = 3;
> 
> Instead of fixing the stmmac_clk_csr_set() method you have provided
> the clk_csr workaround. What if pclk rate is changed? Which BTW is
> possible. =) In that case you'll get a wrong MDC rate.

1) This works for me just fine with all Baikal-M and Baikal-T1 boards
   I've got so far. 
2) I avoid changes in the generic stmmac code on purpose to keep the risk
   of regressions minimal.
 
> > +	plat_dat->setup = baikal_dwmac_setup;
> > +
> > +	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> > +	if (ret)
> > +		goto err_remove_config_dt;
> > +
> > +	return 0;
> > +
> > +err_remove_config_dt:
> > +	stmmac_remove_config_dt(pdev, plat_dat);
> > +	return ret;
> > +}
> > +
> > +static const struct of_device_id dwmac_baikal_match[] = {
> 
> > +	{ .compatible = "baikal,dwmac" },
> 
> Even though Baikal-T1 and Baikal-M1 have been synthesized with almost
> identical IP-cores I wouldn't suggest to use the same compatible
> string for both of them. At least those are different platforms with
> different reference signals parameters. So it would be much better to
> use the naming like "baikal,bt1-gmac" and "baikal,bm1-gmac" here.

OK, makes sense.

> 
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, dwmac_baikal_match);
> > +
> > +static struct platform_driver dwmac_baikal_driver = {
> > +	.probe	= dwmac_baikal_probe,
> > +	.remove	= stmmac_pltfr_remove,
> > +	.driver	= {
> > +		.name = "baikal-dwmac",
> > +		.pm = &stmmac_pltfr_pm_ops,
> > +		.of_match_table = of_match_ptr(dwmac_baikal_match)
> > +	}
> > +};
> > +module_platform_driver(dwmac_baikal_driver);
> > +
> > +MODULE_DESCRIPTION("Baikal-T1/M DWMAC driver");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> > index 76edb9b72675..7b8a955d98a9 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> > @@ -563,3 +563,4 @@ int dwmac1000_setup(struct stmmac_priv *priv)
> >  
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL_GPL(dwmac1000_setup);
> 
> As I said providing a platform-specific reset method won't solve the
> problem with the PHYs resetting on each interface up/down procedures.
> So exporting this method and the methods below will be just useless
> since the provided fix isn't complete.

When the experiment and a theory disagree the experiment always wins.
With this driver Ethernet works just fine with

* BFK3.1 board (Baikal-T1 reference boards)
* TF307-MB-S-D board (Baikal-M)
* LGP-16 system on the module (Baikal-M)

It might or might not work with other boards (although I haven't got
such boards myself yet).

Last but not least, if this driver is such a wrong and incomplete, why
Baikal Electronics ships it in its vendor kernel [2]?

[2] https://github.com/baikalelectronics/kernel/blob/v5.4_BE-aarch64_stable/drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c
    https://share.baikalelectronics.ru/index.php/s/Zi4tmLzpjCYccKb (warning: links are js-wrapped)

