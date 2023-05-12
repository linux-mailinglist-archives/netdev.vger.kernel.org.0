Return-Path: <netdev+bounces-2177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D839700A34
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09CB0281B5F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7A71EA69;
	Fri, 12 May 2023 14:21:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F29C1DDFD
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:21:03 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB4A13868;
	Fri, 12 May 2023 07:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=cpy/pdC3MPfNPFFoZ4/qpPrfXgPArCsSnkFiMVBkX/4=; b=id6JJO3lob5IHK3IHuxFi6lGYr
	oIRzSxyj+OXLv3oPgJaIZMDu1JZFcaGGUlE0MYioIfOo3H3ndYRxtnhc8jo3iTvvcBrNak0b99vri
	wQYAtmxvp1tUsvJBEgL7MAV4nRaFeTS1hCU2ESWabLUY/DcBSZP1tl9aDuoC7hiySGBY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pxTdO-00CfnX-Ak; Fri, 12 May 2023 16:20:38 +0200
Date: Fri, 12 May 2023 16:20:38 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <2b8a8ef8-b98b-42f7-b91d-2a9b05973d57@lunn.ch>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-7-jiawenwu@trustnetic.com>
 <ab8852ce-72e8-4d5b-8c88-772a6c9f1485@lunn.ch>
 <019201d9849c$54e88730$feb99590$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <019201d9849c$54e88730$feb99590$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Is that a hardware requirement, that interrupts only work when the interface is
> > running? Interrupts are not normally conditional like this, at least when the SoC
> > provides the GPIO controller.
> 
> Should we handle the interrupts when interface is not running?

You are adding a generic GPIO controller. It could in theory be used
for anything. GPIO controlled LEDs, buttons, bit-banging MDIO/SPI/I2C,
etc. I would not artificially limit interrupts to just when the
interface is up, unless you need to.

You should also take a look at the SFP code. When does it enable
interrupts? When the SFP device is created, or when phylink_start() is
called? SoC GPIO controllers work all the time, so it could be the SFP
code just assumes interrupts work as soon as the GPIO is
available. With the interface down, try disconnecting/connecting the
fibre and see if /sys/kernel/debug/sfpX/state shows it sees LOS
change.

     Andrew

