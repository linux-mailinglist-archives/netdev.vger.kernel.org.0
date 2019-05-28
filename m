Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097142C4D7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfE1Kxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:53:36 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36610 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfE1Kxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=s7Qw7kQV3M0frNbNWezoUvaapeqqE6aYTrGr7FdZM5c=; b=rX/5Do4CZpbXbTJOC7kJolbxR
        4IgEzkBAK8yyKiy3C5V2bt7VoYIzRKFHNPCDqeIcwRKvhgtHkS1b7QCE3qz6R9kQW0q798ze192DZ
        n0wHeYCmiTD5pYfKoPY3MQ2gPXu9SnE4nCuYPUbUgZn434qeHqCrAMTKYpN0/CTN/q3MbCUCAPt/5
        XpJJgkCgcMkNR9H6kMxdqFCURTBkPKqtcxjlQ8yKfXcPWM8Jm0c4KkCZ/kRgBj6nT5pD9cuu1ee8z
        uE9ejfd+XN17eqsrVPLs5vG8mWfO5iRgekI993vaE3llOCPqlh9m3ORvotmh+teH6sRpWhZptLfJ3
        fsBonmyvQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52672)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVZjT-0005FX-O9; Tue, 28 May 2019 11:53:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVZjP-0003Yf-J9; Tue, 28 May 2019 11:53:23 +0100
Date:   Tue, 28 May 2019 11:53:23 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ruslan Babayev <ruslan@babayev.com>
Cc:     mika.westerberg@linux.intel.com, wsa@the-dreams.de, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [net-next,v3 2/2] net: phy: sfp: enable i2c-bus detection on
 ACPI based systems
Message-ID: <20190528105323.ty6pxxvsh6ccz2l6@shell.armlinux.org.uk>
References: <20190528032213.19839-1-ruslan@babayev.com>
 <20190528032213.19839-3-ruslan@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528032213.19839-3-ruslan@babayev.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 08:22:13PM -0700, Ruslan Babayev wrote:
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

Looks mostly fine to me, thanks.  A few comments below, mostly minor.
The way we handle the non-DT and non-ACPI case needs addressing though.

> ---
>  drivers/net/phy/sfp.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index d4635c2178d1..7a6c8df8899b 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -9,6 +9,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/of.h>
> +#include <linux/acpi.h>
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/rtnetlink.h>

These includes are arranged in alphabetical order, is there a reason
why we need acpi.h out of order here?

> @@ -1783,6 +1784,7 @@ static int sfp_probe(struct platform_device *pdev)
>  {
>  	const struct sff_data *sff;
>  	struct sfp *sfp;
> +	struct i2c_adapter *i2c = NULL;

Please move this one line above, I think that will be neater.

I'm also debating whether we should have it initialised to null - see
below.

>  	bool poll = false;
>  	int irq, err, i;
>  
> @@ -1801,7 +1803,6 @@ static int sfp_probe(struct platform_device *pdev)
>  	if (pdev->dev.of_node) {
>  		struct device_node *node = pdev->dev.of_node;
>  		const struct of_device_id *id;
> -		struct i2c_adapter *i2c;
>  		struct device_node *np;
>  
>  		id = of_match_node(sfp_of_match, node);
> @@ -1818,14 +1819,30 @@ static int sfp_probe(struct platform_device *pdev)
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
> +	} else if (ACPI_COMPANION(&pdev->dev)) {
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
> +	}

If we don't have DT, and we don't have ACPI, there isn't a way that
we can find the I2C adapter, so I think we probably ought to fail the
probe here, rather than...

> +
> +	if (!i2c)
> +		return -EPROBE_DEFER;

deferring in that case.  So, basically:

	struct i2c_adapter *i2c;

	if (pdev->dev.of_node) {
		...
	} else if (ACPI_COMPANION(&pdev->dev)) {
		...
	} else {
		return -EINVAL;
	}

	if (!i2c)
		return -EPROBE_DEFER;

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
