Return-Path: <netdev+bounces-9918-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 041BD72B2D5
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 18:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD4C12811AD
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 16:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7EFCC2E4;
	Sun, 11 Jun 2023 16:25:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983B6441D
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 16:25:17 +0000 (UTC)
Received: from knopi.disroot.org (knopi.disroot.org [178.21.23.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFCF193;
	Sun, 11 Jun 2023 09:25:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 2F9DD404E9;
	Sun, 11 Jun 2023 18:25:13 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from knopi.disroot.org ([127.0.0.1])
	by localhost (disroot.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lz0JV5es22aD; Sun, 11 Jun 2023 18:25:11 +0200 (CEST)
Date: Sun, 11 Jun 2023 18:25:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1686500711; bh=SMUo2wU8cvDmrTvh/k7RZj4r5pRgDBnDLZspNaOqGbI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CVGnAs3j9pM+yQk2Cl+7iOE+SiwMtp4HaEJbGhVk2DMaiB+psZ87p9ywBcsN5EYwr
	 B9SS6k1zLULCCEA3UD1JbcY7IxHNqM/TzVbLufL4IZi2ewbvFjS8liKOfWRUJiHIpe
	 hGjLDbKmk3BT2dfDAyXA+63LaWTerJupYK9yY6t7HLV+tmrtnZxJkejBlcVnWSre7o
	 moLb6FVtZ2gaDOB7q585m6AqNTWAT0GdUndtuUVIKozoXUrg56+LEsfFX/gKEkTEgZ
	 dXa6u8pfx/TPnxkwJ9ja4kdeAtfTSvuN+Thb2HA1BHXKexu65rNFwpwp5EgnLocRk5
	 h0ZGMSOQPajkg==
From: Marco Giorgi <giorgi.marco.96@disroot.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: netdev@vger.kernel.org, u.kleine-koenig@pengutronix.de,
 davem@davemloft.net, michael@walle.cc, kuba@kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net 1/2] nfc: nxp-nci: Fix i2c read on ThinkPad
 hardware
Message-ID: <20230611181707.1227de20@T590-Marco>
In-Reply-To: <07b33c1e-895e-d7d7-a108-0ee5f2812ffa@linaro.org>
References: <20230607170009.9458-1-giorgi.marco.96@disroot.org>
 <20230607170009.9458-2-giorgi.marco.96@disroot.org>
 <07b33c1e-895e-d7d7-a108-0ee5f2812ffa@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Krzysztof,

On Wed, 7 Jun 2023 19:45:25 +0200
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> On 07/06/2023 19:00, Marco Giorgi wrote:
> > Add the IRQ GPIO configuration.  
> 
> Why? Please include reasons in commit msg. What you are doing is quite
> easy to see.

This is my fault, I only put the patch reason in patch [0/2].

Basically, I found out that the mainline driver is not working on my
machine (Lenovo ThinkPad T590).

I suspect that the I2C read IRQ is somehow misconfigured, and it
triggers even when the NFC chip is not ready to be read, resulting in
an error.

In this patch [1/2], I'm adding the "IRQ" GPIO to the driver so its
value can be directly read from the IRQ thread.

In patch [2/2], I'm safely returning from the IRQ thread when the IRQ
GPIO is not active.

> 
> > 
> > Signed-off-by: Marco Giorgi <giorgi.marco.96@disroot.org>
> > ---
> >  drivers/nfc/nxp-nci/i2c.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> > index d4c299be7949..4ba26a958258 100644
> > --- a/drivers/nfc/nxp-nci/i2c.c
> > +++ b/drivers/nfc/nxp-nci/i2c.c
> > @@ -35,6 +35,7 @@ struct nxp_nci_i2c_phy {
> >  
> >  	struct gpio_desc *gpiod_en;
> >  	struct gpio_desc *gpiod_fw;
> > +	struct gpio_desc *gpiod_irq;
> >  
> >  	int hard_fault; /*
> >  			 * < 0 if hardware error occurred (e.g.
> > i2c err) @@ -254,10 +255,12 @@ static irqreturn_t
> > nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id) return IRQ_NONE;
> >  }
> >  
> > +static const struct acpi_gpio_params irq_gpios = { 0, 0, false };
> >  static const struct acpi_gpio_params firmware_gpios = { 1, 0,
> > false }; static const struct acpi_gpio_params enable_gpios = { 2,
> > 0, false }; 
> >  static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
> > +	{ "irq-gpios", &irq_gpios, 1 },
> >  	{ "enable-gpios", &enable_gpios, 1 },
> >  	{ "firmware-gpios", &firmware_gpios, 1 },
> >  	{ }
> > @@ -286,6 +289,12 @@ static int nxp_nci_i2c_probe(struct i2c_client
> > *client) if (r)
> >  		dev_dbg(dev, "Unable to add GPIO mapping table\n");
> >  
> > +	phy->gpiod_irq = devm_gpiod_get(dev, "irq", GPIOD_IN);  
> 
> Bindings do not allow it. Please update bindings... or not, because
> they clearly state that interrupts are already there.
> 
> You need to explain what is this.

Thanks, I will address bindings in future patch versions.

> 
> 
> 
> Best regards,
> Krzysztof
> 

Thanks for your feedback,
Marco.

