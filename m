Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE6318921
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhBKLKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbhBKLGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:06:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7941C061756;
        Thu, 11 Feb 2021 03:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aUMOhZ/r6K5pZQMb5adTT2R7mflcUd6gQF1EZlt7rh0=; b=PUhPuNsuYsvXpCGX7J7lZklpk
        ViW2nNfn6viKIQZYO984pDEFwpaRMcRAOu/BHW7/QP1DqSHqfS4bYC9KzUY64vMYLE7kVPR2k7BMQ
        wI6B8TRv5yvLsnIBQx8VuPd4UGPzwyKIHhRkWzSXD/iU92dcG/Lo4lbdIa1w4SQ8WSD63auxyYbiO
        oLv7XYB4/dO5NFJXIqEgOD4hf5QhWUIzjaI9XRlfsfyGZL3qYuDjn6RvHf8zPeicL+XER1v9XzySS
        w3+kpc6VsfuyDdYKpqFzFF3D1G7qPomAEGtL1c2zuKWJne1jQpnqzI9mrY29xnxP0Z20pnPmZAVtc
        hN9iNht4w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41988)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lA9mi-000613-7N; Thu, 11 Feb 2021 11:05:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lA9mh-00061L-J3; Thu, 11 Feb 2021 11:05:19 +0000
Date:   Thu, 11 Feb 2021 11:05:19 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 03/15] net: mvpp2: add CM3 SRAM memory map
Message-ID: <20210211110519.GA1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-4-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-4-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:48:50PM +0200, stefanc@marvell.com wrote:
> +static int mvpp2_get_sram(struct platform_device *pdev,
> +			  struct mvpp2 *priv)
> +{
> +	struct resource *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +	if (!res) {
> +		if (has_acpi_companion(&pdev->dev))
> +			dev_warn(&pdev->dev, "ACPI is too old, Flow control not supported\n");
> +		else
> +			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");
> +		return 0;
> +	}
> +
> +	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->cm3_base))
> +		return PTR_ERR(priv->cm3_base);
> +
> +	return 0;

You can clean this up to use:

	return PTR_ERR_OR_ZERO(priv->cm3_base);

> +
> +		/* Map CM3 SRAM */
> +		err = mvpp2_get_sram(pdev, priv);
> +		if (err)
> +			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");

It looks to me like mvpp2_get_sram() only fails if we are unable to
_map_ the CM3 SRAM. We are no longer allocating anything from it, so
I think this message needs to be updated.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
