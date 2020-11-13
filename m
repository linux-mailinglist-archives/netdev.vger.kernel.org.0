Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F892B13C5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgKMBS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMBS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 20:18:57 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10CF216C4;
        Fri, 13 Nov 2020 01:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605230336;
        bh=StksmFtB0kwpwHLya+TX/PQtEa4ngP8taHmRVpTis/I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pFoNyv0af6GLhs3mLjRKY6BAbgd8mgmovKtE6IpePT8om792p8D2QJVlH82ZdA4jk
         M7ryyRBZ84PAhI3plFW8KHJMQPDO23mxzouoo3LEJLN0nyBOG0xeVCA6QHtmDISv23
         PFvbIqhgUt3hO/Q41NrKseS0HqfgaEbism5keluU=
Date:   Thu, 12 Nov 2020 17:18:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] nfc: s3fwrn82: Add driver for Samsung S3FWRN82 NFC Chip
Message-ID: <20201112171855.0f942722@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112082047epcms2p3c164a73f89b1bdf2be97fe5e2c6936d2@epcms2p3>
References: <CGME20201112082047epcms2p3c164a73f89b1bdf2be97fe5e2c6936d2@epcms2p3>
        <20201112082047epcms2p3c164a73f89b1bdf2be97fe5e2c6936d2@epcms2p3>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 17:20:47 +0900 Bongsu Jeon wrote:
> Add driver for Samsung S3FWRN82 NFC controller.
> S3FWRN82 is using NCI protocol and I2C communication interface.
> 
> Signed-off-by: bongsujeon <bongsu.jeon@samsung.com>

Please put [PATCH net-next] in the subject so we know this will go into
the net-next tree.

> diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt b/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
> new file mode 100644
> index 000000000000..03ed880e1c7f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
> @@ -0,0 +1,30 @@
> +* Samsung S3FWRN82 NCI NFC Controller
> +
> +Required properties:
> +- compatible: Should be "samsung,s3fwrn82-i2c".
> +- reg: address on the bus
> +- interrupts: GPIO interrupt to which the chip is connected
> +- en-gpios: Output GPIO pin used for enabling/disabling the chip
> +- wake-gpios: Output GPIO pin used to enter firmware mode and
> +  sleep/wakeup control
> +
> +Example:
> +
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    i2c4 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        s3fwrn82@27 {
> +            compatible = "samsung,s3fwrn82-i2c";
> +            reg = <0x27>;
> +
> +            interrupt-parent = <&gpa1>;
> +            interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
> +
> +            en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
> +            wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
> +        };
> +    };

AFAIK the device tree bindings need to be in a separate patch, and you
need to CC the device tree mailing list and maintainers on that patch.

> +config NFC_S3FWRN82
> +	tristate
> +	help
> +	  Core driver for Samsung S3FWRN82 NFC chip. Contains core utilities
> +	  of chip. It's intended to be used by PHYs to avoid duplicating lots
> +	  of common code.

If this is only selected by other drivers you can skip the help and
make this option invisible in kconfig.

> +config NFC_S3FWRN82_I2C
> +	tristate "Samsung S3FWRN82 I2C support"
> +	depends on NFC_NCI && I2C
> +	select NFC_S3FWRN82
> +	default n

default n is unnecessary, when default is not specified 'n' is already
the default

> +	help
> +	  This module adds support for an I2C interface to the S3FWRN82 chip.
> +	  Select this if your platform is using the I2C bus.
> +
> +	  To compile this driver as a module, choose m here. The module will
> +	  be called s3fwrn82_i2c.ko.
> +	  Say N if unsure.

> +#define S3FWRN82_NFC_PROTOCOLS  (NFC_PROTO_JEWEL_MASK | \
> +				NFC_PROTO_MIFARE_MASK | \
> +				NFC_PROTO_FELICA_MASK | \
> +				NFC_PROTO_ISO14443_MASK | \
> +				NFC_PROTO_ISO14443_B_MASK | \
> +				NFC_PROTO_ISO15693_MASK)
> +
> +static int s3fwrn82_nci_open(struct nci_dev *ndev)
> +{
> +	struct s3fwrn82_info *info = nci_get_drvdata(ndev);
> +
> +	if (s3fwrn82_get_mode(info) != S3FWRN82_MODE_COLD)
> +		return  -EBUSY;

double space


> +int s3fwrn82_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
> +	const struct s3fwrn82_phy_ops *phy_ops)

Please align the continuation lines properly. Please use checkpatch
--strict to check your patches.

> +{
> +	struct s3fwrn82_info *info;
> +	int ret;
> +
> +	info = devm_kzalloc(pdev, sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->phy_id = phy_id;
> +	info->pdev = pdev;
> +	info->phy_ops = phy_ops;
> +	mutex_init(&info->mutex);
> +
> +	s3fwrn82_set_mode(info, S3FWRN82_MODE_COLD);
> +
> +	info->ndev = nci_allocate_device(&s3fwrn82_nci_ops,
> +		S3FWRN82_NFC_PROTOCOLS, 0, 0);

same here

> +	if (!info->ndev)
> +		return -ENOMEM;
> +
> +	nci_set_parent_dev(info->ndev, pdev);
> +	nci_set_drvdata(info->ndev, info);
> +
> +	ret = nci_register_device(info->ndev);
> +	if (ret < 0) {
> +		nci_free_device(info->ndev);
> +		return ret;
> +	}
> +
> +	*ndev = info->ndev;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(s3fwrn82_probe);

> +static int s3fwrn82_i2c_parse_dt(struct i2c_client *client)
> +{
> +	struct s3fwrn82_i2c_phy *phy = i2c_get_clientdata(client);
> +	struct device_node *np = client->dev.of_node;
> +
> +	if (!np)
> +		return -ENODEV;
> +
> +	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> +	if (!gpio_is_valid(phy->gpio_en)) {
> +		return -ENODEV;
> +	}

brackets around single line statements are unnecessary

> +	phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> +	if (!gpio_is_valid(phy->gpio_fw_wake)) {
> +		return -ENODEV;
> +	}

here as well

> +	return 0;
> +}

> +static inline int s3fwrn82_set_mode(struct s3fwrn82_info *info,
> +	enum s3fwrn82_mode mode)
> +{
> +	if (!info->phy_ops->set_mode)
> +		return -ENOTSUPP;

EOPNOTSUPP is a better error code, ENOTSUPP is internal to the kernel
and best avoided

