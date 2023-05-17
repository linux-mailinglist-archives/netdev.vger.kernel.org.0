Return-Path: <netdev+bounces-3387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB61706CF7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05F441C20EB3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF711119F;
	Wed, 17 May 2023 15:37:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461564436
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:37:30 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1A7139;
	Wed, 17 May 2023 08:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=THRohlh+qrIfJaD8xBh2JXBEFCjX78n18Ij4ZY5/zzs=; b=Vb
	GMZ1pwH2Qebg4Rq+4SXFXKvxHUuZaAgc5GkKv1iuh5QDUXRJqcAkx1gcjZ73MZFrI4OBNqlBk2AxN
	0lDr4wVIMF0JUak9+RMxeD1oYm4HnzTMbugzpcb1+wbq9hIXQyZS+S+aAoDF3s2nw+X1Tv7xyr0fK
	AyIzuoXW7TihuNk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzIe1-00D9Ct-FS; Wed, 17 May 2023 17:00:49 +0200
Date: Wed, 17 May 2023 17:00:49 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: 'Andy Shevchenko' <andy.shevchenko@gmail.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com>
 <ZGH-fRzbGd_eCASk@surfacebook>
 <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com>
 <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
 <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 10:55:01AM +0800, Jiawen Wu wrote:
> > > > > +   gc = devm_kzalloc(dev, sizeof(*gc), GFP_KERNEL);
> > > > > +   if (!gc)
> > > > > +           return -ENOMEM;
> > > > > +
> > > > > +   gc->label = devm_kasprintf(dev, GFP_KERNEL, "txgbe_gpio-%x",
> > > > > +                              (wx->pdev->bus->number << 8) | wx->pdev->devfn);
> > > > > +   gc->base = -1;
> > > > > +   gc->ngpio = 6;
> > > > > +   gc->owner = THIS_MODULE;
> > > > > +   gc->parent = dev;
> > > > > +   gc->fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_GPIO]);
> > > >
> > > > Looking at the I²C case, I'm wondering if gpio-regmap can be used for this piece.
> > >
> > > I can access this GPIO region directly, do I really need to use regmap?
> > 
> > It's not a matter of access, it's a matter of using an existing
> > wrapper that will give you already a lot of code done there, i.o.w.
> > you don't need to reinvent a wheel.
> 
> I took a look at the gpio-regmap code, when I call devm_gpio_regmap_register(),
> I should provide gpio_regmap_config.irq_domain if I want to add the gpio_irq_chip.
> But in this use, GPIO IRQs are requested by SFP driver. How can I get irq_domain
> before SFP probe? And where do I add IRQ parent handler?
 
I _think_ you are mixing upstream IRQs and downstream IRQs.

Interrupts are arranged in trees. The CPU itself only has one or two
interrupts. e.g. for ARM you have FIQ and IRQ. When the CPU gets an
interrupt, you look in the interrupt controller to see what external
or internal interrupt triggered the CPU interrupt. And that interrupt
controller might indicate the interrupt came from another interrupt
controller. Hence the tree structure. And each node in the tree is
considered an interrupt domain.

A GPIO controller can also be an interrupt controller. It has an
upstream interrupt, going to the controller above it. And it has
downstream interrupts, the GPIO lines coming into it which can cause
an interrupt. And the GPIO interrupt controller is a domain.

So what exactly does gpio_regmap_config.irq_domain mean? Is it the
domain of the upstream interrupt controller? Is it an empty domain
structure to be used by the GPIO interrupt controller? It is very
unlikely to have anything to do with the SFP devices below it.

	 Andrew




