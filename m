Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DED444411D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhKCMMx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Nov 2021 08:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbhKCMMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 08:12:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49697C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 05:10:16 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1miF5l-00024e-1x; Wed, 03 Nov 2021 13:10:09 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1miF5i-000A5d-Ej; Wed, 03 Nov 2021 13:10:06 +0100
Message-ID: <430b152167a1fdfb5ca66f1db702759f36d0ed56.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wells Lu <wells.lu@sunplus.com>
Date:   Wed, 03 Nov 2021 13:10:06 +0100
In-Reply-To: <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
         <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-03 at 19:02 +0800, Wells Lu wrote:
[...]
> diff --git a/drivers/net/ethernet/sunplus/l2sw_driver.c b/drivers/net/ethernet/sunplus/l2sw_driver.c
> new file mode 100644
> index 0000000..3dfd0dd
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/l2sw_driver.c
> @@ -0,0 +1,779 @@
[...]
> +static int l2sw_probe(struct platform_device *pdev)
> +{
> +	struct l2sw_common *comm;
> +	struct resource *r_mem;
> +	struct net_device *net_dev, *net_dev2;
> +	struct l2sw_mac *mac, *mac2;
> +	u32 mode;
> +	int ret = 0;
> +	int rc;
> +
> +	if (platform_get_drvdata(pdev))
> +		return -ENODEV;
> +
> +	// Allocate memory for l2sw 'common' area.
> +	comm = kmalloc(sizeof(*comm), GFP_KERNEL);

I'd use devm_kzalloc() here for initialization and to simplify the
cleanup path.

> +	if (!comm)
> +		return -ENOMEM;
> +	pr_debug(" comm = %p\n", comm);

What is this useful for?

> +	memset(comm, '\0', sizeof(struct l2sw_common));

Not needed with kzalloc, See above.

[...]
> +	// Get memory resoruce 0 from dts.
> +	r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (r_mem) {
> +		pr_debug(" res->name = \"%s\", r_mem->start = %pa\n", r_mem->name, &r_mem->start);
> +		if (l2sw_reg_base_set(devm_ioremap(&pdev->dev, r_mem->start,
> +						   (r_mem->end - r_mem->start + 1))) != 0) {
> +			pr_err(" ioremap failed!\n");
> +			ret = -ENOMEM;
> +			goto out_free_comm;
> +		}
> +	} else {
> +		pr_err(" No MEM resource 0 found!\n");
> +		ret = -ENXIO;
> +		goto out_free_comm;
> +	}
> +
> +	// Get memory resoruce 1 from dts.
> +	r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (r_mem) {
> +		pr_debug(" res->name = \"%s\", r_mem->start = %pa\n", r_mem->name, &r_mem->start);
> +		if (moon5_reg_base_set(devm_ioremap(&pdev->dev, r_mem->start,
> +						    (r_mem->end - r_mem->start + 1))) != 0) {
> +			pr_err(" ioremap failed!\n");
> +			ret = -ENOMEM;
> +			goto out_free_comm;
> +		}
> +	} else {
> +		pr_err(" No MEM resource 1 found!\n");
> +		ret = -ENXIO;
> +		goto out_free_comm;
> +	}

Using devm_ioremap_resource() would simplify both a lot.

[...]
> +	comm->rstc = devm_reset_control_get(&pdev->dev, NULL);

Please use devm_reset_control_get_exclusive().

> +	if (IS_ERR(comm->rstc)) {
> +		dev_err(&pdev->dev, "Failed to retrieve reset controller!\n");
> +		ret = PTR_ERR(comm->rstc);
> +		goto out_free_comm;
> +	}
> +
> +	// Enable clock.
> +	clk_prepare_enable(comm->clk);
> +	udelay(1);
> +
> +	ret = reset_control_assert(comm->rstc);

No need to assign to ret if you ignore it anyway.

> +	udelay(1);
> +	ret = reset_control_deassert(comm->rstc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to deassert reset line (err = %d)!\n", ret);
> +		ret = -ENODEV;
> +		goto out_free_comm;
> +	}
> +	udelay(1);

regards
Philipp
