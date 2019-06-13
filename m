Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B0644A15
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfFMSA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:00:26 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52098 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfFMSA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QqBYpCy9poBhIFTyghikbxuPHZgS3I094QUO8bPWRNc=; b=iwxf7Nysd9QFbabhwwOgvwM/6
        7KiTJ3j3vfhQz70Qkk7Ql0b8PB7DxGM1MuBTuS3AaQXfNwfcKtUFfvcN5eR7kBGyTc/al4iTE9mkX
        cD9yS2WPhI9gN9vtVtjlMZbS1UfTiEeXSUIuWJKiQrF3spgTJ1G1T+JDVHB967P3Xjo8dVA+DjXqT
        J0SiFqQacluMXhcsmW6FjpP2m/4dYgDY4xS6cHW6Az7PRAwFHSYs6LDVKhO97fJ5zvbKn/rnyRYdT
        Dj5ps+AinHssULJCIStegydvy9NZFFkS9WQ/lZdQOMovkw5c3SPMQTIUGn2DHhjFiNfSNZkyXeesl
        m6Bd7u7+A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53016)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbU1L-0004fk-DJ; Thu, 13 Jun 2019 19:00:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbU1I-0001Pu-JB; Thu, 13 Jun 2019 19:00:16 +0100
Date:   Thu, 13 Jun 2019 19:00:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ruslan Babayev <ruslan@babayev.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: sfp: clean up a condition
Message-ID: <20190613180016.ekg55vzkuczapfpl@shell.armlinux.org.uk>
References: <20190613065102.GA16334@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613065102.GA16334@mwanda>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 09:51:02AM +0300, Dan Carpenter wrote:
> The acpi_node_get_property_reference() doesn't return ACPI error codes,
> it just returns regular negative kernel error codes.  This patch doesn't
> affect run time, it's just a clean up.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/phy/sfp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index a991c80e6567..8a99307c1c39 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1848,7 +1848,7 @@ static int sfp_probe(struct platform_device *pdev)
>  		int ret;
>  
>  		ret = acpi_node_get_property_reference(fw, "i2c-bus", 0, &args);
> -		if (ACPI_FAILURE(ret) || !is_acpi_device_node(args.fwnode)) {
> +		if (ret || !is_acpi_device_node(args.fwnode)) {
>  			dev_err(&pdev->dev, "missing 'i2c-bus' property\n");
>  			return -ENODEV;

If "ret" is a Linux error code, should we print its value when reporting
the error so we know why the failure occurred, and propagate the error
code?

>  		}
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
