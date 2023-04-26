Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D7C6EF848
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 18:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbjDZQTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 12:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbjDZQTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 12:19:23 -0400
Received: from fgw23-7.mail.saunalahti.fi (fgw23-7.mail.saunalahti.fi [62.142.5.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CC27AA0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 09:19:17 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
        by fgw23.mail.saunalahti.fi (Halon) with ESMTP
        id 15da8e56-e44e-11ed-b972-005056bdfda7;
        Wed, 26 Apr 2023 19:19:15 +0300 (EEST)
From:   andy.shevchenko@gmail.com
Date:   Wed, 26 Apr 2023 19:19:14 +0300
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        jsd@semihalf.com, ose.Abreu@synopsys.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [RFC PATCH net-next v5 4/9] net: txgbe: Register I2C platform
 device
Message-ID: <ZElPAnXAM-EwbUNe@surfacebook>
References: <20230426071434.452717-1-jiawenwu@trustnetic.com>
 <20230426071434.452717-5-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426071434.452717-5-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 26, 2023 at 03:14:29PM +0800, Jiawen Wu kirjoitti:
> Register the platform device to use Designware I2C bus master driver.

...

> +static int txgbe_i2c_register(struct txgbe *txgbe)
> +{
> +	struct pci_dev *pdev = txgbe->wx->pdev;
> +	struct platform_device_info info = {};
> +	struct platform_device *i2c_dev;
> +	struct resource res[2] = {};
> +
> +	info.parent = &pdev->dev;
> +	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
> +	info.name = "i2c_designware";
> +	info.id = (pdev->bus->number << 8) | pdev->devfn;

> +	res[0].start = pci_resource_start(pdev, 0) + TXGBE_I2C_BASE;
> +	res[0].end = pci_resource_start(pdev, 0) + TXGBE_I2C_BASE + 0x100 - 1;
> +	res[0].flags = IORESOURCE_MEM;

DEFINE_RES_MEM()

> +	res[1].start = pdev->irq;
> +	res[1].end = pdev->irq;
> +	res[1].flags = IORESOURCE_IRQ;

DEFINE_RES_IRQ()

> +	info.res = res;
> +	info.num_res = 2;

ARRAY_SIZE()

> +	i2c_dev = platform_device_register_full(&info);
> +	if (IS_ERR(i2c_dev))
> +		return PTR_ERR(i2c_dev);
> +
> +	txgbe->i2c_dev = i2c_dev;
> +
> +	return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko


