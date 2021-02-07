Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B9C3123AA
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 11:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBGKqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 05:46:22 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:45790 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGKqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 05:46:19 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 790FD440820;
        Sun,  7 Feb 2021 12:45:34 +0200 (IST)
References: <1612685964-21890-1-git-send-email-stefanc@marvell.com>
 <1612685964-21890-4-git-send-email-stefanc@marvell.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, ymarkman@marvell.com,
        devicetree@vger.kernel.org, atenart@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        nadavh@marvell.com, rmk+kernel@armlinux.org.uk, robh+dt@kernel.org,
        thomas.petazzoni@bootlin.com, kuba@kernel.org, mw@semihalf.com,
        davem@davemloft.net, gregory.clement@bootlin.com,
        sebastian.hesselbarth@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH v8 net-next 03/15] net: mvpp2: add CM3 SRAM
 memory map
In-reply-to: <1612685964-21890-4-git-send-email-stefanc@marvell.com>
Date:   Sun, 07 Feb 2021 12:45:34 +0200
Message-ID: <87mtwgxik1.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On Sun, Feb 07 2021, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
>
> This patch adds CM3 memory map and CM3 read/write callbacks.
> No functionality changes.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  7 +++
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 63 +++++++++++++++++++-
>  2 files changed, 67 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index 6bd7e40..aec9179 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -748,6 +748,9 @@
>  #define MVPP2_TX_FIFO_THRESHOLD(kb)	\
>  		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
>  
> +/* MSS Flow control */
> +#define MSS_SRAM_SIZE	0x800
> +
>  /* RX buffer constants */
>  #define MVPP2_SKB_SHINFO_SIZE \
>  	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
> @@ -925,6 +928,7 @@ struct mvpp2 {
>  	/* Shared registers' base addresses */
>  	void __iomem *lms_base;
>  	void __iomem *iface_base;
> +	void __iomem *cm3_base;
>  
>  	/* On PPv2.2, each "software thread" can access the base
>  	 * register through a separate address space, each 64 KB apart
> @@ -996,6 +1000,9 @@ struct mvpp2 {
>  
>  	/* page_pool allocator */
>  	struct page_pool *page_pool[MVPP2_PORT_MAX_RXQ];
> +
> +	/* CM3 SRAM pool */
> +	struct gen_pool *sram_pool;
>  };
>  
>  struct mvpp2_pcpu_stats {
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index a07cf60..307f9fd 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -25,6 +25,7 @@
>  #include <linux/of_net.h>
>  #include <linux/of_address.h>
>  #include <linux/of_device.h>
> +#include <linux/genalloc.h>
>  #include <linux/phy.h>
>  #include <linux/phylink.h>
>  #include <linux/phy/phy.h>
> @@ -6846,6 +6847,44 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
>  	return 0;
>  }
>  
> +static int mvpp2_get_sram(struct platform_device *pdev,
> +			  struct mvpp2 *priv)
> +{
> +	struct device_node *dn = pdev->dev.of_node;
> +	static bool defer_once;
> +	struct resource *res;
> +
> +	if (has_acpi_companion(&pdev->dev)) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +		if (!res) {
> +			dev_warn(&pdev->dev, "ACPI is too old, Flow control not supported\n");
> +			return 0;
> +		}
> +		priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(priv->cm3_base))
> +			return PTR_ERR(priv->cm3_base);
> +	} else {
> +		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
> +		if (!priv->sram_pool) {
> +			if (!defer_once) {
> +				defer_once = true;
> +				/* Try defer once */
> +				return -EPROBE_DEFER;
> +			}
> +			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");

This warning will show on every DT system with no cm3-mem property, right?

> +			return -ENOMEM;
> +		}
> +		/* cm3_base allocated with offset zero into the SRAM since mapping size
> +		 * is equal to requested size.
> +		 */
> +		priv->cm3_base = (void __iomem *)gen_pool_alloc(priv->sram_pool,
> +								MSS_SRAM_SIZE);
> +		if (!priv->cm3_base)
> +			return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
>  static int mvpp2_probe(struct platform_device *pdev)
>  {
>  	const struct acpi_device_id *acpi_id;
> @@ -6902,6 +6941,13 @@ static int mvpp2_probe(struct platform_device *pdev)
>  		priv->iface_base = devm_ioremap_resource(&pdev->dev, res);
>  		if (IS_ERR(priv->iface_base))
>  			return PTR_ERR(priv->iface_base);
> +
> +		/* Map CM3 SRAM */
> +		err = mvpp2_get_sram(pdev, priv);
> +		if (err == -EPROBE_DEFER)
> +			return err;
> +		else if (err)
> +			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");

This one will show as well.

I would not expect that from a patch that makes "no functional change".

baruch

>  	}
>  
>  	if (priv->hw_version == MVPP22 && dev_of_node(&pdev->dev)) {
> @@ -6947,11 +6993,13 @@ static int mvpp2_probe(struct platform_device *pdev)
>  
>  	if (dev_of_node(&pdev->dev)) {
>  		priv->pp_clk = devm_clk_get(&pdev->dev, "pp_clk");
> -		if (IS_ERR(priv->pp_clk))
> -			return PTR_ERR(priv->pp_clk);
> +		if (IS_ERR(priv->pp_clk)) {
> +			err = PTR_ERR(priv->pp_clk);
> +			goto err_cm3;
> +		}
>  		err = clk_prepare_enable(priv->pp_clk);
>  		if (err < 0)
> -			return err;
> +			goto err_cm3;
>  
>  		priv->gop_clk = devm_clk_get(&pdev->dev, "gop_clk");
>  		if (IS_ERR(priv->gop_clk)) {
> @@ -7087,6 +7135,11 @@ static int mvpp2_probe(struct platform_device *pdev)
>  	clk_disable_unprepare(priv->gop_clk);
>  err_pp_clk:
>  	clk_disable_unprepare(priv->pp_clk);
> +err_cm3:
> +	if (priv->sram_pool && priv->cm3_base)
> +		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
> +			      MSS_SRAM_SIZE);
> +
>  	return err;
>  }
>  
> @@ -7127,6 +7180,10 @@ static int mvpp2_remove(struct platform_device *pdev)
>  				  aggr_txq->descs_dma);
>  	}
>  
> +	if (priv->sram_pool && priv->cm3_base)
> +		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
> +			      MSS_SRAM_SIZE);
> +
>  	if (is_acpi_node(port_fwnode))
>  		return 0;


-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
