Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF72B2D981
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfE2Jvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:51:48 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52858 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2Jvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:51:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/f5EUi1XSNAC84dFYL879FX4cNgbBocAhTsspiFEMmM=; b=Mb/5bBw9hFyvPrY55boHa39rj
        ib0qLtTMnflxzIhaiPSM+5tEWPJAvwnuevi6bjfDqdUykvTEJWa28IzySLFN4N+/qs/2DYEna8mFa
        leqjBJ2EcRoFWRui0WuN+G62YwX1jGsH2PpMEKB1IwwwIM5/Co/LJjayb+13442iDMM2MW3UnRhcV
        kueS+oGuk3VI2Ix1T1iwMHWjeIYAuaMu9aN9YU3+jcv6OQEQdtfgPK+DNn+JQTdskYue5UZSuOKhP
        MTTVv5DkJCMgcwNd4DHKqWTboP511OfvEkUF9OO/bBIRaSWTcfWNwLxEx9NdETgWHOEiCtaL+ag5X
        EgxjAOIhA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38354)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVvFC-0003SV-LV; Wed, 29 May 2019 10:51:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVvF5-0004RQ-Gh; Wed, 29 May 2019 10:51:31 +0100
Date:   Wed, 29 May 2019 10:51:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ruslan Babayev <ruslan@babayev.com>
Cc:     mika.westerberg@linux.intel.com, wsa@the-dreams.de, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [net-next,v4 2/2] net: phy: sfp: enable i2c-bus detection on
 ACPI based systems
Message-ID: <20190529095131.ans67yioljyklqol@shell.armlinux.org.uk>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190528230233.26772-3-ruslan@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528230233.26772-3-ruslan@babayev.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 04:02:33PM -0700, Ruslan Babayev wrote:
> Lookup I2C adapter using the "i2c-bus" device property on ACPI based
> systems similar to how it's done with DT.
> 
> An example DSD describing an SFP on an ACPI based system:
> 
> Device (SFP0)
> {
>     Name (_HID, "PRP0001")
>     Name (_CRS, ResourceTemplate()
>     {
>         GpioIo(Exclusive, PullDefault, 0, 0, IoRestrictionNone,
>                "\\_SB.PCI0.RP01.GPIO", 0, ResourceConsumer)
>             { 0, 1, 2, 3, 4 }
>     })
>     Name (_DSD, Package ()
>     {
>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>         Package () {
>             Package () { "compatible", "sff,sfp" },
>             Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
>             Package () { "maximum-power-milliwatt", 1000 },
>             Package () { "tx-disable-gpios", Package () { ^SFP0, 0, 0, 1} },
>             Package () { "reset-gpio",       Package () { ^SFP0, 0, 1, 1} },
>             Package () { "mod-def0-gpios",   Package () { ^SFP0, 0, 2, 1} },
>             Package () { "tx-fault-gpios",   Package () { ^SFP0, 0, 3, 0} },
>             Package () { "los-gpios",        Package () { ^SFP0, 0, 4, 1} },
>         },
>     })
> }
> 
> Device (PHY0)
> {
>     Name (_HID, "PRP0001")
>     Name (_DSD, Package ()
>     {
>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>         Package () {
>             Package () { "compatible", "ethernet-phy-ieee802.3-c45" },
>             Package () { "sfp", \_SB.PCI0.RP01.SFP0 },
>             Package () { "managed", "in-band-status" },
>             Package () { "phy-mode", "sgmii" },
>         },
>     })
> }
> 
> Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
> Cc: xe-linux-external@cisco.com

This looks fine now, thanks.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

> ---
>  drivers/net/phy/sfp.c | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index d4635c2178d1..554acc869c25 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1,4 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0
> +#include <linux/acpi.h>
>  #include <linux/ctype.h>
>  #include <linux/delay.h>
>  #include <linux/gpio/consumer.h>
> @@ -1782,6 +1783,7 @@ static void sfp_cleanup(void *data)
>  static int sfp_probe(struct platform_device *pdev)
>  {
>  	const struct sff_data *sff;
> +	struct i2c_adapter *i2c;
>  	struct sfp *sfp;
>  	bool poll = false;
>  	int irq, err, i;
> @@ -1801,7 +1803,6 @@ static int sfp_probe(struct platform_device *pdev)
>  	if (pdev->dev.of_node) {
>  		struct device_node *node = pdev->dev.of_node;
>  		const struct of_device_id *id;
> -		struct i2c_adapter *i2c;
>  		struct device_node *np;
>  
>  		id = of_match_node(sfp_of_match, node);
> @@ -1818,14 +1819,32 @@ static int sfp_probe(struct platform_device *pdev)
>  
>  		i2c = of_find_i2c_adapter_by_node(np);
>  		of_node_put(np);
> -		if (!i2c)
> -			return -EPROBE_DEFER;
> -
> -		err = sfp_i2c_configure(sfp, i2c);
> -		if (err < 0) {
> -			i2c_put_adapter(i2c);
> -			return err;
> +	} else if (has_acpi_companion(&pdev->dev)) {
> +		struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
> +		struct fwnode_handle *fw = acpi_fwnode_handle(adev);
> +		struct fwnode_reference_args args;
> +		struct acpi_handle *acpi_handle;
> +		int ret;
> +
> +		ret = acpi_node_get_property_reference(fw, "i2c-bus", 0, &args);
> +		if (ACPI_FAILURE(ret) || !is_acpi_device_node(args.fwnode)) {
> +			dev_err(&pdev->dev, "missing 'i2c-bus' property\n");
> +			return -ENODEV;
>  		}
> +
> +		acpi_handle = ACPI_HANDLE_FWNODE(args.fwnode);
> +		i2c = i2c_acpi_find_adapter_by_handle(acpi_handle);
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	if (!i2c)
> +		return -EPROBE_DEFER;
> +
> +	err = sfp_i2c_configure(sfp, i2c);
> +	if (err < 0) {
> +		i2c_put_adapter(i2c);
> +		return err;
>  	}
>  
>  	for (i = 0; i < GPIO_MAX; i++)
> -- 
> 2.19.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
