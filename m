Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC75301BD4
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 13:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbhAXM2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 07:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbhAXM2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 07:28:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9D8C061573;
        Sun, 24 Jan 2021 04:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sT12+RzTF8KSMshcxHPAvGj98cH2WKbMubgiyuYJnWU=; b=fugzomg6SS7kEINiDz5Z2P46m
        nWlnL7DWe3+PgStvZ9p3efLx4p+TrfFMv78o+eYm3wkW3owa0UVTNXZgFKI+AEBKryXF8q3eV70tQ
        MjE/IIOIaFBmTQc3CdK40tw/CF7wd8V5XMcUGVwn0SJWmo8kveiGNzKA7L7hQ6GE01hFpGWkEwywd
        07JyWs+4IOjQRtTzRFL3QpfRJ7vYU1GWrg+uq3tn8LJFdPpB5QbQQmskg3bos8NJkyzNYGZNCcprv
        jdcEY0AnWiOmNvSAfge4A7+Gw/1pBEFByRpPKJdYifIZLDppAqlOSYZBGQiZb4hCaGPAkiusuKR3K
        UoBh6uO3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52100)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l3eV0-0002Mp-TJ; Sun, 24 Jan 2021 12:28:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l3eV0-0001gU-21; Sun, 24 Jan 2021 12:28:10 +0000
Date:   Sun, 24 Jan 2021 12:28:10 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH v2 RFC net-next 03/18] net: mvpp2: add CM3 SRAM memory map
Message-ID: <20210124122809.GV1551@shell.armlinux.org.uk>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-4-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611488647-12478-4-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 01:43:52PM +0200, stefanc@marvell.com wrote:
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

Above, priv->sram_pool will only be non-NULL if the pool has been
initialised.

> +err_cm3:
> +	if (!has_acpi_companion(&pdev->dev) && priv->cm3_base)
> +		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
> +			      MSS_SRAM_SIZE);

So wouldn't:
	if (priv->sram_pool && priv->cm3_base)

be more appropriate here?

> +	if (!has_acpi_companion(&pdev->dev) && priv->cm3_base) {
> +		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
> +			      MSS_SRAM_SIZE);
> +		gen_pool_destroy(priv->sram_pool);
> +	}

Same here.

Why is it correct to call gen_pool_destroy() in the remove path but not
the error path? I think you want to drop this - the pool is created and
destroyed by the SRAM driver, users of it should not be destroying it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
