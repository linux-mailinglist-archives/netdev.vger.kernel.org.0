Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245B16D4573
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjDCNQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjDCNQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:16:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32751994
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aGHqBy6cy7Kw8qUgtS/AEPQroPB/Dfn23UzradvcY3U=; b=jJ9LDb6hQqx84BTqMYRlXqmPy3
        7PcNz7w/ivJEzStSqXhGGR6KbHZNu1+52gFzg9IBSRKsHwXKUdT5mGU3iq+BMVBlMZaLYYe7p5Nda
        lPJiB4HO2Q4O9caJ+C7RMgGc4ceIxectJVGLFv/RK045+Jl+q1PKOol+vm+u0kiyMDJI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjK2o-009Hgu-TH; Mon, 03 Apr 2023 15:16:22 +0200
Date:   Mon, 3 Apr 2023 15:16:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 4/6] net: txgbe: Support GPIO to SFP socket
Message-ID: <462c614a-a786-456b-a0d7-63ac35f1bcc3@lunn.ch>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-5-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403064528.343866-5-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please Cc: The GPIO mailing list, they know more about GPIO drivers
than the netdev people.

> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> index eb89a274083e..dff0d573ee33 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> @@ -1348,7 +1348,8 @@ void wx_free_irq(struct wx *wx)
>  		free_irq(entry->vector, q_vector);
>  	}
>  
> -	free_irq(wx->msix_entries[vector].vector, wx);
> +	if (wx->mac.type == wx_mac_em)
> +		free_irq(wx->msix_entries[vector].vector, wx);
>  }
>  EXPORT_SYMBOL(wx_free_irq);
>  
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> index 072aa2bd3fdc..89bba827edf2 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -79,7 +79,9 @@
>  #define WX_GPIO_INTMASK              0x14834
>  #define WX_GPIO_INTTYPE_LEVEL        0x14838
>  #define WX_GPIO_POLARITY             0x1483C
> +#define WX_GPIO_INTSTATUS            0x14844
>  #define WX_GPIO_EOI                  0x1484C
> +#define WX_GPIO_EXT                  0x14850
>  
>  /*********************** Transmit DMA registers **************************/
>  /* transmit global control */
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
> index ebc46f3be056..b87034e57140 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
> @@ -256,6 +256,7 @@ int txgbe_validate_eeprom_checksum(struct wx *wx, u16 *checksum_val)
>  static void txgbe_reset_misc(struct wx *wx)
>  {
>  	wx_reset_misc(wx);
> +	wr32(wx, WX_GPIO_DDR, 0x32);

No magic numbers, use #define's.

DDR is Data Direction Register? So are you configuring some of the
pins as outputs? Is that needed? The SFP driver will request how it
wants the pins configuring, so there should not be any need to hard
code it here.

>  	txgbe_init_thermal_sensor_thresh(wx);
>  }
>  
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> index 319d56720c06..caaefc20afb9 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> @@ -82,6 +82,10 @@ static int txgbe_enumerate_functions(struct wx *wx)
>   **/
>  static void txgbe_irq_enable(struct wx *wx, bool queues)
>  {
> +	wr32(wx, WX_GPIO_INTEN, TXGBE_GPIOBIT_0 | TXGBE_GPIOBIT_2 | TXGBE_GPIOBIT_3);
> +	wr32(wx, WX_GPIO_INTTYPE_LEVEL, TXGBE_GPIOBIT_0 | TXGBE_GPIOBIT_2 | TXGBE_GPIOBIT_3);

Again, the SFP code will ask that interrupts are enabled for the GPIOs
it is interested in. There should not be any need to hard code
this. Disable all interrupts until they are requested.

> +	wr32(wx, WX_PX_MISC_IEN, TXGBE_PX_MISC_IEN_MASK);
> +
>  	/* unmask interrupt */
>  	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
>  	if (queues)
> @@ -129,17 +133,6 @@ static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> +static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	int val, dir;
> +
> +	dir = chip->get_direction(chip, offset);
> +	if (dir == GPIO_LINE_DIRECTION_IN)
> +		val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
> +	else
> +		val = rd32m(wx, WX_GPIO_DR, BIT(offset));
> +
> +	return !!(val & BIT(offset));
> +}
> +
> +static int txgbe_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	u32 val;
> +
> +	val = rd32(wx, WX_GPIO_DDR);
> +	if (BIT(offset) & val)
> +		return GPIO_LINE_DIRECTION_OUT;
> +
> +	return GPIO_LINE_DIRECTION_IN;
> +}
> +
> +static int txgbe_gpio_direction_in(struct gpio_chip *chip, unsigned int offset)
> +{
> +	return 0;
> +}

This is where the write to DDR should probably happen?

> +
> +static int txgbe_gpio_direction_out(struct gpio_chip *chip, unsigned int offset,
> +				    int val)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	u32 mask;
> +	int dir;
> +
> +	dir = chip->get_direction(chip, offset);
> +	if (dir == GPIO_LINE_DIRECTION_IN)
> +		return 0;

Don't assume in by default.

> +	mask = BIT(offset) | BIT(offset - 1);
> +	if (val)
> +		wr32m(wx, WX_GPIO_DR, mask, mask);
> +	else
> +		wr32m(wx, WX_GPIO_DR, mask, 0);
> +
> +	return 0;
> +}
> +
> +static void txgbe_gpio_irq_ack(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +
> +	wr32(wx, WX_GPIO_EOI, BIT(hwirq));
> +}
> +
> +static void txgbe_gpio_irq_mask(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +
> +	gpiochip_disable_irq(gc, hwirq);
> +
> +	wr32m(wx, WX_GPIO_INTMASK, BIT(hwirq), BIT(hwirq));
> +}
> +
> +static void txgbe_gpio_irq_unmask(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +
> +	gpiochip_enable_irq(gc, hwirq);
> +
> +	wr32m(wx, WX_GPIO_INTMASK, BIT(hwirq), 0);
> +}
> +
> +static int txgbe_gpio_set_type(struct irq_data *d, unsigned int type)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +	u32 level, polarity;
> +
> +	level = rd32(wx, WX_GPIO_INTTYPE_LEVEL);
> +	polarity = rd32(wx, WX_GPIO_POLARITY);
> +
> +	switch (type) {
> +	case IRQ_TYPE_EDGE_BOTH:
> +		level |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +		level |= BIT(hwirq);
> +		polarity |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +		level |= BIT(hwirq);
> +		polarity &= ~BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		level &= ~BIT(hwirq);
> +		polarity |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_LEVEL_LOW:
> +		level &= ~BIT(hwirq);
> +		polarity &= ~BIT(hwirq);
> +		break;
> +	}

You have two bits, level and priority, so 4 states. But you have
handling 5 different types? Please return -EOPNOTSUPP for whatever you
don't support.

> +
> +	if (type & IRQ_TYPE_LEVEL_MASK)
> +		irq_set_handler_locked(d, handle_level_irq);
> +	else if (type & IRQ_TYPE_EDGE_BOTH)
> +		irq_set_handler_locked(d, handle_edge_irq);

I think this is part of the answer to my question above. Please
re-write this code to make it more obvious.

	 Andrew
