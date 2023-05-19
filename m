Return-Path: <netdev+bounces-3907-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 203A3709828
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 095471C21291
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E062DDB1;
	Fri, 19 May 2023 13:24:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031537C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:24:57 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8230CE;
	Fri, 19 May 2023 06:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=yLx9VzoDWbBqJmTZ++/Rgv4qWRRHxJCH7fo4Hi8SvFM=; b=Z9H4TKxWGRt9jxCZOoCjFNBp5N
	6fDon5lgZx72hAYHl5dnnHyXNzBpvCT2wRoCsSr6RmQZAEIElG7ZcFHNGSnEGtmxSJCMvuDsWFg6L
	RBh8nbRF0ZQXJEsm160RdvcFON9Q2rnVSjYdKo12qO+GV47MR76B5Bt4K0zWLP/aQcXw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q0068-00DKOH-CK; Fri, 19 May 2023 15:24:44 +0200
Date: Fri, 19 May 2023 15:24:44 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: 'Andy Shevchenko' <andy.shevchenko@gmail.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <3abf6e14-7029-4a52-a360-353870a9906a@lunn.ch>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com>
 <ZGH-fRzbGd_eCASk@surfacebook>
 <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com>
 <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
 <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
 <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch>
 <025b01d9897e$d8894660$899bd320$@trustnetic.com>
 <1e1615b3-566c-490c-8b1a-78f5521ca0b0@lunn.ch>
 <02ad01d98a2b$4cd080e0$e67182a0$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02ad01d98a2b$4cd080e0$e67182a0$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> It's true for the problem of name, but there is another problem. SFP driver has
> successfully got gpio_desc, then it failed to get gpio_irq from gpio_desc (with error
> return -517). I traced the function gpiod_to_irq():

-517 is a number you learn after a while. -EPROBE_DEFFER. So the GPIO
controller is not fully ready when the SFP driver tries to use it.

I guess this is the missing upstream interrupt. You need to get the
order correct:

Register the MAC interrupt controller
Instantiate the regmap-gpio controller
Instantiate the I2C bus master
Instantiate the SPF devices
Instantiate PHYLINK.

	Andrew

