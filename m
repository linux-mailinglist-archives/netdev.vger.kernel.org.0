Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39372C740D
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgK1Vtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:46 -0500
Received: from mail-ej1-f67.google.com ([209.85.218.67]:37040 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbgK1SYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:24:42 -0500
Received: by mail-ej1-f67.google.com with SMTP id f9so10218329ejw.4;
        Sat, 28 Nov 2020 10:24:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C9o7zSm9LM3znBVdFEtWickxwMIZ+rmX3f1yZZxj4mY=;
        b=Ei0welGCYBda3dQExXMkqWPheOSNw17XANjiA6Zkk0zEil/VYDfnQw2OndhfwOVjU/
         b+xxPaHFmzkYJLTay/vtaBN7kmizLifz7WarehX+Bqlg8PgehUwabs0vMbCNwROURThV
         y3o4mrDyCiyBu5qpKXcHGWXDH8IXR0H2eS1f9qfTz/kqi6rbpf/V7SUztefrsM6Mzl1d
         czxfdaLqBqzxeI7iskb3mr/9eK1sHcEaKYlYACmgdAyX7o/xhR7Wa2yte6LBpKaN0AGv
         bwAi4T/FTJC11qd1ixFPQrPe3tR9p/8qTAuPPrsLLuoBY/J77UgqbxaZ5dkPciyA8ScR
         vvow==
X-Gm-Message-State: AOAM532f0GT2FTF8Rf+lO5xrHGLPErqnIUohsstKLSivjxgU0qcuioaE
        GVKVj/tOXhvOYHY+7XVDHva2kb3qWfY=
X-Google-Smtp-Source: ABdhPJyCKvpoo6i7wQHKKN+cmSr01jgIqgxPsrGc1Jyki6xhfu4SnuRgjHSELog2BzUwN2H0zJSsVg==
X-Received: by 2002:a5d:4604:: with SMTP id t4mr17125843wrq.411.1606567762596;
        Sat, 28 Nov 2020 04:49:22 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id s4sm19916484wro.10.2020.11.28.04.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 04:49:21 -0800 (PST)
Date:   Sat, 28 Nov 2020 13:49:20 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     bongsu.jeon2@gmail.com
Cc:     k.opasiak@samsung.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 3/3] nfc: s3fwrn5: extract the common phy
 blocks
Message-ID: <20201128124920.GB6313@kozik-lap>
References: <1606476138-31992-1-git-send-email-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606476138-31992-1-git-send-email-bongsu.jeon2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 08:22:18PM +0900, bongsu.jeon2@gmail.com wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Extract the common phy blocks to reuse it.
> The UART module will use the common blocks.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
> Changes in v2:
>  - remove the common function's definition in common header file.
>  - make the common phy_common.c file to define the common function.
>  - wrap the lines.
>  - change the Header guard.
>  - remove the unused common function.
> 
>  drivers/nfc/s3fwrn5/Makefile     |   2 +-
>  drivers/nfc/s3fwrn5/i2c.c        | 114 +++++++++++++--------------------------
>  drivers/nfc/s3fwrn5/phy_common.c |  60 +++++++++++++++++++++
>  drivers/nfc/s3fwrn5/phy_common.h |  31 +++++++++++
>  4 files changed, 129 insertions(+), 78 deletions(-)
>  create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
>  create mode 100644 drivers/nfc/s3fwrn5/phy_common.h
> 
> diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
> index d0ffa35..a5279c6 100644
> --- a/drivers/nfc/s3fwrn5/Makefile
> +++ b/drivers/nfc/s3fwrn5/Makefile
> @@ -4,7 +4,7 @@
>  #
>  
>  s3fwrn5-objs = core.o firmware.o nci.o
> -s3fwrn5_i2c-objs = i2c.o
> +s3fwrn5_i2c-objs = i2c.o phy_common.o

Thanks for the changes.

Shouldn't this be part of s3fwrn5.ko? Otherwise you would duplicate the
objects in two modules.

>  
>  obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
>  obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o
> diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> index 9a64eea..207f970 100644
> --- a/drivers/nfc/s3fwrn5/i2c.c
> +++ b/drivers/nfc/s3fwrn5/i2c.c
> @@ -16,74 +16,30 @@
>  #include <net/nfc/nfc.h>
>  
>  #include "s3fwrn5.h"
> +#include "phy_common.h"
>  
>  #define S3FWRN5_I2C_DRIVER_NAME "s3fwrn5_i2c"
>  
> -#define S3FWRN5_EN_WAIT_TIME 20
> -
>  struct s3fwrn5_i2c_phy {
> +	struct phy_common common;
>  	struct i2c_client *i2c_dev;
> -	struct nci_dev *ndev;
> -
> -	int gpio_en;
> -	int gpio_fw_wake;
> -
> -	struct mutex mutex;
>  
> -	enum s3fwrn5_mode mode;
>  	unsigned int irq_skip:1;
>  };
>  
> -static void s3fwrn5_i2c_set_wake(void *phy_id, bool wake)
> -{
> -	struct s3fwrn5_i2c_phy *phy = phy_id;
> -
> -	mutex_lock(&phy->mutex);
> -	gpio_set_value(phy->gpio_fw_wake, wake);
> -	msleep(S3FWRN5_EN_WAIT_TIME);
> -	mutex_unlock(&phy->mutex);
> -}
> -
>  static void s3fwrn5_i2c_set_mode(void *phy_id, enum s3fwrn5_mode mode)
>  {
>  	struct s3fwrn5_i2c_phy *phy = phy_id;
>  
> -	mutex_lock(&phy->mutex);
> +	mutex_lock(&phy->common.mutex);
>  
> -	if (phy->mode == mode)
> +	if (s3fwrn5_phy_power_ctrl(&phy->common, mode) == false)
>  		goto out;
>  
> -	phy->mode = mode;
> -
> -	gpio_set_value(phy->gpio_en, 1);
> -	gpio_set_value(phy->gpio_fw_wake, 0);
> -	if (mode == S3FWRN5_MODE_FW)
> -		gpio_set_value(phy->gpio_fw_wake, 1);
> -
> -	if (mode != S3FWRN5_MODE_COLD) {
> -		msleep(S3FWRN5_EN_WAIT_TIME);
> -		gpio_set_value(phy->gpio_en, 0);
> -		msleep(S3FWRN5_EN_WAIT_TIME);
> -	}
> -
>  	phy->irq_skip = true;
>  
>  out:
> -	mutex_unlock(&phy->mutex);
> -}
> -
> -static enum s3fwrn5_mode s3fwrn5_i2c_get_mode(void *phy_id)
> -{
> -	struct s3fwrn5_i2c_phy *phy = phy_id;
> -	enum s3fwrn5_mode mode;
> -
> -	mutex_lock(&phy->mutex);
> -
> -	mode = phy->mode;
> -
> -	mutex_unlock(&phy->mutex);
> -
> -	return mode;
> +	mutex_unlock(&phy->common.mutex);
>  }
>  
>  static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
> @@ -91,7 +47,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
>  	struct s3fwrn5_i2c_phy *phy = phy_id;
>  	int ret;
>  
> -	mutex_lock(&phy->mutex);
> +	mutex_lock(&phy->common.mutex);
>  
>  	phy->irq_skip = false;
>  
> @@ -102,7 +58,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
>  		ret  = i2c_master_send(phy->i2c_dev, skb->data, skb->len);
>  	}
>  
> -	mutex_unlock(&phy->mutex);
> +	mutex_unlock(&phy->common.mutex);
>  
>  	if (ret < 0)
>  		return ret;
> @@ -114,9 +70,9 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
>  }
>  
>  static const struct s3fwrn5_phy_ops i2c_phy_ops = {
> -	.set_wake = s3fwrn5_i2c_set_wake,
> +	.set_wake = s3fwrn5_phy_set_wake,
>  	.set_mode = s3fwrn5_i2c_set_mode,
> -	.get_mode = s3fwrn5_i2c_get_mode,
> +	.get_mode = s3fwrn5_phy_get_mode,
>  	.write = s3fwrn5_i2c_write,
>  };
>  
> @@ -128,7 +84,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
>  	char hdr[4];
>  	int ret;
>  
> -	hdr_size = (phy->mode == S3FWRN5_MODE_NCI) ?
> +	hdr_size = (phy->common.mode == S3FWRN5_MODE_NCI) ?
>  		NCI_CTRL_HDR_SIZE : S3FWRN5_FW_HDR_SIZE;
>  	ret = i2c_master_recv(phy->i2c_dev, hdr, hdr_size);
>  	if (ret < 0)
> @@ -137,7 +93,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
>  	if (ret < hdr_size)
>  		return -EBADMSG;
>  
> -	data_len = (phy->mode == S3FWRN5_MODE_NCI) ?
> +	data_len = (phy->common.mode == S3FWRN5_MODE_NCI) ?
>  		((struct nci_ctrl_hdr *)hdr)->plen :
>  		((struct s3fwrn5_fw_header *)hdr)->len;
>  
> @@ -157,24 +113,24 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
>  	}
>  
>  out:
> -	return s3fwrn5_recv_frame(phy->ndev, skb, phy->mode);
> +	return s3fwrn5_recv_frame(phy->common.ndev, skb, phy->common.mode);
>  }
>  
>  static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
>  {
>  	struct s3fwrn5_i2c_phy *phy = phy_id;
>  
> -	if (!phy || !phy->ndev) {
> +	if (!phy || !phy->common.ndev) {
>  		WARN_ON_ONCE(1);
>  		return IRQ_NONE;
>  	}
>  
> -	mutex_lock(&phy->mutex);
> +	mutex_lock(&phy->common.mutex);
>  
>  	if (phy->irq_skip)
>  		goto out;
>  
> -	switch (phy->mode) {
> +	switch (phy->common.mode) {
>  	case S3FWRN5_MODE_NCI:
>  	case S3FWRN5_MODE_FW:
>  		s3fwrn5_i2c_read(phy);
> @@ -184,7 +140,7 @@ static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
>  	}
>  
>  out:
> -	mutex_unlock(&phy->mutex);
> +	mutex_unlock(&phy->common.mutex);
>  
>  	return IRQ_HANDLED;
>  }
> @@ -197,19 +153,21 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
>  	if (!np)
>  		return -ENODEV;
>  
> -	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> -	if (!gpio_is_valid(phy->gpio_en)) {
> +	phy->common.gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> +	if (!gpio_is_valid(phy->common.gpio_en)) {
>  		/* Support also deprecated property */
> -		phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
> -		if (!gpio_is_valid(phy->gpio_en))
> +		phy->common.gpio_en =
> +				of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);

This is not a proper wrapping. Wrapping happens on function arguments.

> +		if (!gpio_is_valid(phy->common.gpio_en))
>  			return -ENODEV;
>  	}
>  
> -	phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> -	if (!gpio_is_valid(phy->gpio_fw_wake)) {
> +	phy->common.gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> +	if (!gpio_is_valid(phy->common.gpio_fw_wake)) {
>  		/* Support also deprecated property */
> -		phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
> -		if (!gpio_is_valid(phy->gpio_fw_wake))
> +		phy->common.gpio_fw_wake =
> +				of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
> +		if (!gpio_is_valid(phy->common.gpio_fw_wake))

The same.

>  			return -ENODEV;
>  	}
>  
> @@ -226,8 +184,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
>  	if (!phy)
>  		return -ENOMEM;
>  
> -	mutex_init(&phy->mutex);
> -	phy->mode = S3FWRN5_MODE_COLD;
> +	mutex_init(&phy->common.mutex);
> +	phy->common.mode = S3FWRN5_MODE_COLD;
>  	phy->irq_skip = true;
>  
>  	phy->i2c_dev = client;
> @@ -237,17 +195,19 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_en,
> -		GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
> +	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->common.gpio_en,
> +				    GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_fw_wake,
> -		GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
> +	ret = devm_gpio_request_one(&phy->i2c_dev->dev,
> +				    phy->common.gpio_fw_wake,
> +				    GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
> +	ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev,
> +			    &i2c_phy_ops);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -255,7 +215,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
>  		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
>  		S3FWRN5_I2C_DRIVER_NAME, phy);
>  	if (ret)
> -		s3fwrn5_remove(phy->ndev);
> +		s3fwrn5_remove(phy->common.ndev);
>  
>  	return ret;
>  }
> @@ -264,7 +224,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
>  {
>  	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
>  
> -	s3fwrn5_remove(phy->ndev);
> +	s3fwrn5_remove(phy->common.ndev);
>  
>  	return 0;
>  }
> diff --git a/drivers/nfc/s3fwrn5/phy_common.c b/drivers/nfc/s3fwrn5/phy_common.c
> new file mode 100644
> index 0000000..e333764
> --- /dev/null
> +++ b/drivers/nfc/s3fwrn5/phy_common.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Link Layer for Samsung S3FWRN5 NCI based Driver
> + *
> + * Copyright (C) 2015 Samsung Electrnoics
> + * Robert Baldyga <r.baldyga@samsung.com>
> + * Copyright (C) 2020 Samsung Electrnoics
> + * Bongsu Jeon <bongsu.jeon@samsung.com>
> + */
> +
> +#include <linux/gpio.h>
> +#include <linux/delay.h>

You need also mutex.h (it seems original code did not have it but since
you move things around it's a new code basically).

> +
> +#include "s3fwrn5.h"
> +#include "phy_common.h"
> +
> +void s3fwrn5_phy_set_wake(void *phy_id, bool wake)
> +{
> +	struct phy_common *phy = phy_id;
> +
> +	mutex_lock(&phy->mutex);
> +	gpio_set_value(phy->gpio_fw_wake, wake);
> +	msleep(S3FWRN5_EN_WAIT_TIME);
> +	mutex_unlock(&phy->mutex);
> +}
> +
> +bool s3fwrn5_phy_power_ctrl(struct phy_common *phy, enum s3fwrn5_mode mode)
> +{
> +	if (phy->mode == mode)
> +		return false;
> +
> +	phy->mode = mode;
> +
> +	gpio_set_value(phy->gpio_en, 1);
> +	gpio_set_value(phy->gpio_fw_wake, 0);
> +	if (mode == S3FWRN5_MODE_FW)
> +		gpio_set_value(phy->gpio_fw_wake, 1);
> +
> +	if (mode != S3FWRN5_MODE_COLD) {
> +		msleep(S3FWRN5_EN_WAIT_TIME);
> +		gpio_set_value(phy->gpio_en, 0);
> +		msleep(S3FWRN5_EN_WAIT_TIME);
> +	}
> +
> +	return true;
> +}
> +
> +enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id)
> +{
> +	struct phy_common *phy = phy_id;
> +	enum s3fwrn5_mode mode;
> +
> +	mutex_lock(&phy->mutex);
> +
> +	mode = phy->mode;
> +
> +	mutex_unlock(&phy->mutex);
> +
> +	return mode;
> +}
> diff --git a/drivers/nfc/s3fwrn5/phy_common.h b/drivers/nfc/s3fwrn5/phy_common.h
> new file mode 100644
> index 0000000..b920f7f
> --- /dev/null
> +++ b/drivers/nfc/s3fwrn5/phy_common.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * Link Layer for Samsung S3FWRN5 NCI based Driver
> + *
> + * Copyright (C) 2015 Samsung Electrnoics
> + * Robert Baldyga <r.baldyga@samsung.com>
> + * Copyright (C) 2020 Samsung Electrnoics
> + * Bongsu Jeon <bongsu.jeon@samsung.com>
> + */
> +
> +#ifndef __NFC_S3FWRN5_PHY_COMMON_H
> +#define __NFC_S3FWRN5_PHY_COMMON_H
> +
> +#define S3FWRN5_EN_WAIT_TIME 20
> +
> +struct phy_common {
> +	struct nci_dev *ndev;

You need a header for nci_dev type.

> +
> +	int gpio_en;
> +	int gpio_fw_wake;
> +
> +	struct mutex mutex;

You need a header include for mutex.

> +
> +	enum s3fwrn5_mode mode;

Indeed now it won't work - you use an enum without its declaration. The
s3fwrn5_mode enum looks more like a property of the phy and after this
patch would be used only once in i2c.c and once in core.c.

How is it going to be used in your new driver - I cannot check because
you did not post it. You should post this refactoring with new users of
the API, so we could see bigger picture.

Your original idea - with the s3fwrn5.h include here - looks more
logical than moving the enum s3fwrn5_mode here.

Best regards,
Krzysztof
