Return-Path: <netdev+bounces-3901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C49D6709802
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6555A1C21286
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E506AD34;
	Fri, 19 May 2023 13:13:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4FA8BEE
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:13:20 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E390B9D;
	Fri, 19 May 2023 06:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=AFSGky7UzwQyZmjfo4thsr333FmanWi5jd4y86uGkXY=; b=dW1UqK7HLxMXKzbQIoTP5QQB5L
	FAIblVsqNZiz0j+W3QMaGVbjExUrowSvhe1VrnWLRRgdOEcu+4vRC9zRi/MW0k3Q/oXNqUt+JQUJy
	c5XfEoam/nZaMUc9z5+uz1BXmFF3gHMZRqxgvMqZyNRirfBbwci7nCCcS0zSfDfrkMs4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzzuq-00DKKC-5R; Fri, 19 May 2023 15:13:04 +0200
Date: Fri, 19 May 2023 15:13:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: 'Andy Shevchenko' <andy.shevchenko@gmail.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <f0b571ab-544b-49c3-948f-d592f931673b@lunn.ch>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com>
 <ZGH-fRzbGd_eCASk@surfacebook>
 <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com>
 <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
 <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
 <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch>
 <025b01d9897e$d8894660$899bd320$@trustnetic.com>
 <1e1615b3-566c-490c-8b1a-78f5521ca0b0@lunn.ch>
 <028601d989f9$230ee120$692ca360$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <028601d989f9$230ee120$692ca360$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I have one MSI-X interrupt for all general MAC interrupt (see TXGBE_PX_MISC_IEN_MASK).
> It has 32 bits to indicate various interrupts, GPIOs are the one of them. When GPIO
> interrupt is determined, GPIO_INT_STATUS register should be read to determine
> which GPIO line has changed state.

So you have another interrupt controller above the GPIO interrupt
controller. regmap-gpio is pushing you towards describing this
interrupt controller as a Linux interrupt controller.

When you look at drivers handling interrupts, most leaf interrupt
controllers are not described as Linux interrupt controllers. The
driver interrupt handler reads the interrupt status register and
internally dispatches to the needed handler. This works well when
everything is internal to one driver.

However, here, you have two drivers involved, your MAC driver and a
GPIO driver instantiated by the MAC driver. So i think you are going
to need to described the MAC interrupt controller as a Linux interrupt
controller.

Take a look at the mv88e6xxx driver, which does this. It has two
interrupt controller embedded within it, and they are chained.

> > If you are getting errors when removing the driver it means you are
> > missing some level of undoing what us done in probe. Are you sure
> > regmap_del_irq_chip() is being called on unload?
> 
> I used devm_* all when I registered them.

Look at the ordering. Is regmap_del_irq_chip() being called too late?
I've had problems like this with the mv88e6xxx driver and its
interrupt controllers. I ended up not using devm_ so i had full
control over the order things got undone. In that case, the external
devices was PHYs, with the PHY interrupt being inside the Ethernet
switch, which i exposed using a Linux interrupt controller.

	Andrew

