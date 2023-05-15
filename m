Return-Path: <netdev+bounces-2592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 257FD702938
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 324D81C20909
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307ACC152;
	Mon, 15 May 2023 09:42:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26455C138
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:42:31 +0000 (UTC)
Received: from fgw21-7.mail.saunalahti.fi (fgw21-7.mail.saunalahti.fi [62.142.5.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276732683
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:42:25 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTP
	id ca086007-f304-11ed-abf4-005056bdd08f;
	Mon, 15 May 2023 12:42:22 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Mon, 15 May 2023 12:42:21 +0300
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <ZGH-fRzbGd_eCASk@surfacebook>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230515063200.301026-7-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 15, 2023 at 02:31:57PM +0800, Jiawen Wu kirjoitti:
> Register GPIO chip and handle GPIO IRQ for SFP socket.

...

> +static int txgbe_gpio_direction_out(struct gpio_chip *chip, unsigned int offset,
> +				    int val)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	unsigned long flags;
> +	u32 set;
> +
> +	spin_lock_irqsave(&wx->gpio_lock, flags);

> +	set = val ? BIT(offset) : 0;

Why is this under the lock?

> +	wr32m(wx, WX_GPIO_DR, BIT(offset), set);
> +	wr32m(wx, WX_GPIO_DDR, BIT(offset), BIT(offset));
> +	spin_unlock_irqrestore(&wx->gpio_lock, flags);
> +
> +	return 0;
> +}

...

> +static void txgbe_toggle_trigger(struct gpio_chip *gc, unsigned int offset)

> +{
> +	struct wx *wx = gpiochip_get_data(gc);
> +	u32 pol;
> +	int val;
> +
> +	pol = rd32(wx, WX_GPIO_POLARITY);

> +	val = gc->get(gc, offset);

Can't you use directly the respective rd32()?

> +	if (val)
> +		pol &= ~BIT(offset);
> +	else
> +		pol |= BIT(offset);
> +
> +	wr32(wx, WX_GPIO_POLARITY, pol);
> +}

...

> +static void txgbe_irq_handler(struct irq_desc *desc)
> +{
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	struct wx *wx = irq_desc_get_handler_data(desc);
> +	struct txgbe *txgbe = wx->priv;
> +	irq_hw_number_t hwirq;
> +	unsigned long gpioirq;
> +	struct gpio_chip *gc;
> +
> +	chained_irq_enter(chip, desc);

Seems spin_lock() call is missing in this function.

> +	gpioirq = rd32(wx, WX_GPIO_INTSTATUS);
> +
> +	gc = txgbe->gpio;
> +	for_each_set_bit(hwirq, &gpioirq, gc->ngpio) {
> +		int gpio = irq_find_mapping(gc->irq.domain, hwirq);
> +		u32 irq_type = irq_get_trigger_type(gpio);
> +
> +		generic_handle_irq(gpio);

Can generic_handle_domain_irq() be used here?

> +		if ((irq_type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
> +			txgbe_toggle_trigger(gc, hwirq);
> +	}
> +
> +	chained_irq_exit(chip, desc);
> +
> +	/* unmask interrupt */
> +	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
> +}

...

> +static int txgbe_gpio_init(struct txgbe *txgbe)
> +{
> +	struct gpio_irq_chip *girq;
> +	struct wx *wx = txgbe->wx;
> +	struct gpio_chip *gc;
> +	struct device *dev;
> +	int ret;

> +	dev = &wx->pdev->dev;

This can be united with the defintion above.

	struct device *dev = &wx->pdev->dev;

> +	gc = devm_kzalloc(dev, sizeof(*gc), GFP_KERNEL);
> +	if (!gc)
> +		return -ENOMEM;
> +
> +	gc->label = devm_kasprintf(dev, GFP_KERNEL, "txgbe_gpio-%x",
> +				   (wx->pdev->bus->number << 8) | wx->pdev->devfn);
> +	gc->base = -1;
> +	gc->ngpio = 6;
> +	gc->owner = THIS_MODULE;
> +	gc->parent = dev;
> +	gc->fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_GPIO]);

Looking at the I²C case, I'm wondering if gpio-regmap can be used for this piece.

> +	gc->get = txgbe_gpio_get;
> +	gc->get_direction = txgbe_gpio_get_direction;
> +	gc->direction_input = txgbe_gpio_direction_in;
> +	gc->direction_output = txgbe_gpio_direction_out;
> +
> +	girq = &gc->irq;
> +	gpio_irq_chip_set_chip(girq, &txgbe_gpio_irq_chip);
> +	girq->parent_handler = txgbe_irq_handler;
> +	girq->parent_handler_data = wx;
> +	girq->num_parents = 1;
> +	girq->parents = devm_kcalloc(dev, girq->num_parents,
> +				     sizeof(*girq->parents), GFP_KERNEL);
> +	if (!girq->parents)
> +		return -ENOMEM;
> +	girq->parents[0] = wx->msix_entries[wx->num_q_vectors].vector;
> +	girq->default_type = IRQ_TYPE_NONE;
> +	girq->handler = handle_bad_irq;
> +
> +	ret = devm_gpiochip_add_data(dev, gc, wx);
> +	if (ret)
> +		return ret;

> +	spin_lock_init(&wx->gpio_lock);

Isn't it too late?

> +	txgbe->gpio = gc;
> +
> +	return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko



