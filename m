Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591A52C5A4D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391620AbgKZRND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:13:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45663 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390083AbgKZRNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:13:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id t4so2876968wrr.12;
        Thu, 26 Nov 2020 09:13:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B+JwbRX5D7jOMoJMVkZbNOd3N4wFm8qIVvsU2VkwOVM=;
        b=oMt2YfG7THBBgrVyGNQRFvYer4LrNLx71Psj78Hicj7bCTZxI0LeHlJOq2rLEOL8e+
         BGohjL8K4SM4crdkXsRYL4PmsgwX+VVqzOxZA5C0LftzMrbyidrrt+L7F44z9F5yyWJW
         WF1FiUE+b2ZKEbhmg9CDgdi9Y5+vHNzRnIysBCN+6rDRHam/xxMrgQtDGQYm2I+w1QLI
         IAAxmFNwCdn3149bePf1PLogZqbIiIQXKg1DeSUaq1JmRDuCqO+OLuIMvh+hqHYaobuy
         /wcQ68Lw0soPNoSiuSHcl8Wq6PwkhHBja9SqQTKiY+Fsfr4ebapQeAwT2XNxJ6TUlArm
         NiSA==
X-Gm-Message-State: AOAM533AEiC0qJYjj+voD0++KMoi8oa8m9AM9onsXr28UefiNLCRK4Kz
        ZNGmI+NWGLzaA8T35IAnbyA=
X-Google-Smtp-Source: ABdhPJxXyemia5F/ZfkR2jHobJo6v1C8ogPn4x7DX4gRXFTTH/2zBNo8JRwsGU38eAwIX1AquP0/iA==
X-Received: by 2002:adf:f547:: with SMTP id j7mr5106033wrp.296.1606410779331;
        Thu, 26 Nov 2020 09:12:59 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id b4sm10509565wmc.1.2020.11.26.09.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 09:12:58 -0800 (PST)
Date:   Thu, 26 Nov 2020 18:12:57 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     bongsu.jeon2@gmail.com
Cc:     k.opasiak@samsung.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next 3/3] nfc: s3fwrn5: extract the common phy blocks
Message-ID: <20201126171257.GC4978@kozik-lap>
References: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
 <1606404819-30647-3-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606404819-30647-3-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 12:33:39AM +0900, bongsu.jeon2@gmail.com wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Extract the common phy blocks to reuse it.
> The UART module will use the common blocks.


Hi,

Thanks for the patch. Few comments below.

> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/i2c.c        | 111 ++++++++++++---------------------------
>  drivers/nfc/s3fwrn5/phy_common.h |  86 ++++++++++++++++++++++++++++++
>  2 files changed, 119 insertions(+), 78 deletions(-)
>  create mode 100644 drivers/nfc/s3fwrn5/phy_common.h
> 
> diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> index 9a64eea..cd1b2a7 100644
> --- a/drivers/nfc/s3fwrn5/i2c.c
> +++ b/drivers/nfc/s3fwrn5/i2c.c
> @@ -15,75 +15,30 @@
>  
>  #include <net/nfc/nfc.h>
>  
> -#include "s3fwrn5.h"
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
> @@ -91,7 +46,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
>  	struct s3fwrn5_i2c_phy *phy = phy_id;
>  	int ret;
>  
> -	mutex_lock(&phy->mutex);
> +	mutex_lock(&phy->common.mutex);
>  
>  	phy->irq_skip = false;
>  
> @@ -102,7 +57,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
>  		ret  = i2c_master_send(phy->i2c_dev, skb->data, skb->len);
>  	}
>  
> -	mutex_unlock(&phy->mutex);
> +	mutex_unlock(&phy->common.mutex);
>  
>  	if (ret < 0)
>  		return ret;
> @@ -114,9 +69,9 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
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
> @@ -128,7 +83,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
>  	char hdr[4];
>  	int ret;
>  
> -	hdr_size = (phy->mode == S3FWRN5_MODE_NCI) ?
> +	hdr_size = (phy->common.mode == S3FWRN5_MODE_NCI) ?
>  		NCI_CTRL_HDR_SIZE : S3FWRN5_FW_HDR_SIZE;
>  	ret = i2c_master_recv(phy->i2c_dev, hdr, hdr_size);
>  	if (ret < 0)
> @@ -137,7 +92,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
>  	if (ret < hdr_size)
>  		return -EBADMSG;
>  
> -	data_len = (phy->mode == S3FWRN5_MODE_NCI) ?
> +	data_len = (phy->common.mode == S3FWRN5_MODE_NCI) ?
>  		((struct nci_ctrl_hdr *)hdr)->plen :
>  		((struct s3fwrn5_fw_header *)hdr)->len;
>  
> @@ -157,24 +112,24 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
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
> @@ -184,7 +139,7 @@ static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
>  	}
>  
>  out:
> -	mutex_unlock(&phy->mutex);
> +	mutex_unlock(&phy->common.mutex);
>  
>  	return IRQ_HANDLED;
>  }
> @@ -197,19 +152,19 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
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
> +		phy->common.gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
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
> +		phy->common.gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);

The lines here should wrap at 80 character.

> +		if (!gpio_is_valid(phy->common.gpio_fw_wake))
>  			return -ENODEV;
>  	}
>  
> @@ -226,8 +181,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
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
> @@ -237,17 +192,17 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
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
> +	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->common.gpio_fw_wake,
> +				    GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
> +	ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);

Please wrap the lines.

>  	if (ret < 0)
>  		return ret;
>  
> @@ -255,7 +210,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
>  		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
>  		S3FWRN5_I2C_DRIVER_NAME, phy);
>  	if (ret)
> -		s3fwrn5_remove(phy->ndev);
> +		s3fwrn5_remove(phy->common.ndev);
>  
>  	return ret;
>  }
> @@ -264,7 +219,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
>  {
>  	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
>  
> -	s3fwrn5_remove(phy->ndev);
> +	s3fwrn5_remove(phy->common.ndev);
>  
>  	return 0;
>  }
> diff --git a/drivers/nfc/s3fwrn5/phy_common.h b/drivers/nfc/s3fwrn5/phy_common.h
> new file mode 100644
> index 0000000..14f7690
> --- /dev/null
> +++ b/drivers/nfc/s3fwrn5/phy_common.h
> @@ -0,0 +1,86 @@
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
> +#ifndef __LOCAL_PHY_COMMON_H
> +#define __LOCAL_PHY_COMMON_H

Header guard: __NFC_S3FWRN5_PHY_COMMON_H

> +
> +#include "s3fwrn5.h"

This include should not be needed.

> +
> +#define S3FWRN5_EN_WAIT_TIME 20
> +
> +struct phy_common {
> +	struct nci_dev *ndev;
> +
> +	int gpio_en;
> +	int gpio_fw_wake;
> +
> +	struct mutex mutex;
> +
> +	enum s3fwrn5_mode mode;
> +};
> +
> +static inline void s3fwrn5_phy_set_wake(void *phy_id, bool wake)
> +{

All these should go to a C source file. If needed - GPL exported.

> +	struct phy_common *phy = phy_id;
> +
> +	mutex_lock(&phy->mutex);
> +	gpio_set_value(phy->gpio_fw_wake, wake);
> +	msleep(S3FWRN5_EN_WAIT_TIME);
> +	mutex_unlock(&phy->mutex);
> +}
> +
> +static inline bool s3fwrn5_phy_power_ctrl(struct phy_common *phy,
> +					  enum s3fwrn5_mode mode)
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
> +static inline void s3fwrn5_phy_set_mode(void *phy_id, enum s3fwrn5_mode mode)
> +{

This looks unused. If you need it only for your next chip, add it with
next patch (the patch adding the user).

Best regards,
Krzysztof
