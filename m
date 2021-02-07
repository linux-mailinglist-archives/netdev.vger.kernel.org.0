Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30EC312617
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 17:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBGQmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 11:42:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53506 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhBGQmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 11:42:09 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l8n7f-004ghT-5o; Sun, 07 Feb 2021 17:41:19 +0100
Date:   Sun, 7 Feb 2021 17:41:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org, devicetree@vger.kernel.org, robh+dt@kernel.org,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH v8 net-next 03/15] net: mvpp2: add CM3 SRAM memory
 map
Message-ID: <YCAYL+jEVijKQqaa@lunn.ch>
References: <1612685964-21890-1-git-send-email-stefanc@marvell.com>
 <1612685964-21890-4-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612685964-21890-4-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 10:19:12AM +0200, stefanc@marvell.com wrote:
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

For v2 i asked:

> I'm wondering if using a pool even makes sense. The ACPI case just
> ioremap() the memory region. Either this memory is dedicated, and
> then there is no need to use a pool, or the memory is shared, and at
> some point the ACPI code is going to run into problems when some
> other driver also wants access.

There was never an answer to this.

Also, the defer_once stuff is odd. You don't see any other driver do
this. The core decides when to give up probing a device. This is
partially an API problem. of_gen_pool_get() gives you no idea why it
failed. Is the property missing, or has the SRAM not probed yet. If
the answer to my question is yes, a pool does make sense, it would be
good to add an of_gen_pool_get_optional() which returns
ERR_PTR(-EPROBE_DEFER) if the property is in DT, but is not yet
available, NULL if the properties does not exist, and a pointer if
everything goes well.

     Andrew
