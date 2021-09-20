Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC00F411611
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 15:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbhITNsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 09:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbhITNsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 09:48:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9ADC061574;
        Mon, 20 Sep 2021 06:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nQzyMh+urw6WUq63Kn0aHKa2iC8R1rXkh2yrDjrMkFU=; b=ZtekXSxH/omWRqKFHxlbKlQMOW
        brX242NaJfTMBSEoVKrT7YY/LTCjbmCsTctOcpy8dC7VsR0dakTf7n+gLDPf2Uu3oZH6SZAGdVvUB
        FeW6lssjgs/H6RAc1VNYlP0mfVpntOVBs92+JlJo4T8J28uWtDxMDiRYBZxCSKp1Y5rguDhtn001+
        7eX35WKbNrPhMNed9vElTPaxpY/By8aFMra1A2UPptlsZ0lW+IdhI6f0bJsNYioksIuHNK8UU0F9e
        P5z/p+10BzTk+fa2JkEX2kgm+FG6wHpgT97fhwYMlseC44DlltJ0P7CnOGBCfl6QcflGJNy8BZCVS
        MszGurwA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54672)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mSJcs-0001fR-P1; Mon, 20 Sep 2021 14:46:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mSJcs-0002LG-31; Mon, 20 Sep 2021 14:46:30 +0100
Date:   Mon, 20 Sep 2021 14:46:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 09/12] net: lan966x: add the basic lan966x
 driver
Message-ID: <YUiQtrIodmyAZ476@shell.armlinux.org.uk>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-10-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-10-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:52:15AM +0200, Horatiu Vultur wrote:
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> new file mode 100644
> index 000000000000..2984f510ae27
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -0,0 +1,350 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include <asm/memory.h>
> +#include <linux/module.h>
> +#include <linux/if_bridge.h>
> +#include <linux/iopoll.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_net.h>
> +#include <linux/reset.h>
> +
> +#include "lan966x_main.h"
> +
> +#define READL_SLEEP_US			10
> +#define READL_TIMEOUT_US		100000000
> +
> +#define IO_RANGES 2
> +
> +static const struct of_device_id lan966x_match[] = {
> +	{ .compatible = "microchip,lan966x-switch" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, mchp_lan966x_match);
> +
> +struct lan966x_main_io_resource {
> +	enum lan966x_target id;
> +	phys_addr_t offset;
> +	int range;
> +};
> +
> +static const struct lan966x_main_io_resource lan966x_main_iomap[] =  {
> +	{ TARGET_CPU,                   0xc0000, 0 }, /* 0xe00c0000 */
> +	{ TARGET_ORG,                         0, 1 }, /* 0xe2000000 */
> +	{ TARGET_GCB,                    0x4000, 1 }, /* 0xe2004000 */
> +	{ TARGET_QS,                     0x8000, 1 }, /* 0xe2008000 */
> +	{ TARGET_CHIP_TOP,              0x10000, 1 }, /* 0xe2010000 */
> +	{ TARGET_REW,                   0x14000, 1 }, /* 0xe2014000 */
> +	{ TARGET_SYS,                   0x28000, 1 }, /* 0xe2028000 */
> +	{ TARGET_HSIO,                  0x2c000, 1 }, /* 0xe202c000 */
> +	{ TARGET_DEV,                   0x34000, 1 }, /* 0xe2034000 */
> +	{ TARGET_DEV +  1,              0x38000, 1 }, /* 0xe2038000 */
> +	{ TARGET_DEV +  2,              0x3c000, 1 }, /* 0xe203c000 */
> +	{ TARGET_DEV +  3,              0x40000, 1 }, /* 0xe2040000 */
> +	{ TARGET_DEV +  4,              0x44000, 1 }, /* 0xe2044000 */
> +	{ TARGET_DEV +  5,              0x48000, 1 }, /* 0xe2048000 */
> +	{ TARGET_DEV +  6,              0x4c000, 1 }, /* 0xe204c000 */
> +	{ TARGET_DEV +  7,              0x50000, 1 }, /* 0xe2050000 */
> +	{ TARGET_QSYS,                 0x100000, 1 }, /* 0xe2100000 */
> +	{ TARGET_AFI,                  0x120000, 1 }, /* 0xe2120000 */
> +	{ TARGET_ANA,                  0x140000, 1 }, /* 0xe2140000 */
> +};
> +
> +static int lan966x_create_targets(struct platform_device *pdev,
> +				  struct lan966x *lan966x)
> +{
> +	struct resource *iores[IO_RANGES];
> +	void __iomem *iomem[IO_RANGES];
> +	void __iomem *begin[IO_RANGES];
> +	int idx;
> +
> +	for (idx = 0; idx < IO_RANGES; idx++) {
> +		iores[idx] = platform_get_resource(pdev, IORESOURCE_MEM,
> +						   idx);
> +		iomem[idx] = devm_ioremap(&pdev->dev,
> +					  iores[idx]->start,
> +					  resource_size(iores[idx]));

This is buggy. If platform_get_resource() returns NULL, you will oops
the kernel.

In any case, this code will be ripe for janitor patching. Please
consider using devm_platform_ioremap_resource() now, before someone
converts your code to use this function.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
