Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FFF6EF7E2
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbjDZPpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbjDZPpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:45:20 -0400
Received: from fgw22-7.mail.saunalahti.fi (fgw22-7.mail.saunalahti.fi [62.142.5.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE45524B
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:45:18 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
        by fgw22.mail.saunalahti.fi (Halon) with ESMTP
        id 562943cb-e449-11ed-a9de-005056bdf889;
        Wed, 26 Apr 2023 18:45:16 +0300 (EEST)
From:   andy.shevchenko@gmail.com
Date:   Wed, 26 Apr 2023 18:45:14 +0300
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        jsd@semihalf.com, ose.Abreu@synopsys.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [RFC PATCH net-next v5 2/9] i2c: designware: Add driver support
 for Wangxun 10Gb NIC
Message-ID: <ZElCHGho-szyySGC@surfacebook>
References: <20230426071434.452717-1-jiawenwu@trustnetic.com>
 <20230426071434.452717-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426071434.452717-3-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 26, 2023 at 03:14:27PM +0800, Jiawen Wu kirjoitti:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
> 
> Introduce the property "i2c-dw-flags" to match device data for software
> node case. Since IO resource was mapped on the ethernet driver, add a model
> quirk to get resource from platform info.
> 
> The exists IP limitations are dealt as workarounds:
> - IP does not support interrupt mode, it works on polling mode.
> - Additionally set FIFO depth address the chip issue.

Thanks for an update, my comments below.

...

>  		goto done_nolock;
>  	}
>  
> +	if ((dev->flags & MODEL_MASK) == MODEL_WANGXUN_SP) {
> +		ret = txgbe_i2c_dw_xfer_quirk(adap, msgs, num);
> +		goto done_nolock;
> +	}

	switch (dev->flags & MODEL_MASK) {
	case AMD:
		...
	case WANGXUN:
		...
	default:
		break;
	}

...

> +static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev->dev);
> +	struct resource *r;
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!r)
> +		return -ENODEV;
> +
> +	dev->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
> +
> +	return PTR_ERR_OR_ZERO(dev->base);
> +}

Redundant. See below.

...

>  	case MODEL_BAIKAL_BT1:
>  		ret = bt1_i2c_request_regs(dev);
>  		break;
> +	case MODEL_WANGXUN_SP:
> +		ret = txgbe_i2c_request_regs(dev);

How is it different to...

> +		break;
>  	default:
>  		dev->base = devm_platform_ioremap_resource(pdev, 0);

...this one?

...

>  	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);

> +	if (!dev->flags)

No need to check this. Just define priorities (I would go with above to be
higher priority).

> +		device_property_read_u32(&pdev->dev, "i2c-dw-flags", &dev->flags);

Needs to be added to the Device Tree bindings I believe.

But wait, don't we have other ways to detect your hardware at probe time and
initialize flags respectively?

-- 
With Best Regards,
Andy Shevchenko


