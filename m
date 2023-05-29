Return-Path: <netdev+bounces-6093-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE2CF714CE9
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41FB3280E78
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA578C16;
	Mon, 29 May 2023 15:21:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCBE8C0C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:21:13 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DBDC9
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=j6voMtD1azcFVC8HscMpBAJBVz9lMAaGOVL78wcjH+E=; b=bvROYbAt4bQtGLv/dl8pGlaqxK
	DR6i/+l5MdnkvdB9y1Wn0z60nL2aron9SnQBuWOMJUdwIsVRaMduG9kheWOJZUuNMTweARfddKfgL
	En4QsWh6uGNvvbnWV09qb8Tew2acznCs4pgl0E965f0/nINFEVdgwCwPhJxufgY0XQlA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3egC-00EEqp-Gb; Mon, 29 May 2023 17:21:04 +0200
Date: Mon, 29 May 2023 17:21:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: andy.shevchenko@gmail.com
Cc: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: mdio: add mdio_device_get() and
 mdio_device_put()
Message-ID: <e2c558cf-430d-40df-8829-0f68560bd22f@lunn.ch>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2USm-008PAO-Gx@rmk-PC.armlinux.org.uk>
 <ZHD4Yaf7fgtgOgTS@surfacebook>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHD4Yaf7fgtgOgTS@surfacebook>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 09:20:17PM +0300, andy.shevchenko@gmail.com wrote:
> Fri, May 26, 2023 at 11:14:24AM +0100, Russell King (Oracle) kirjoitti:
> > Add two new operations for a mdio device to manage the refcount on the
> > underlying struct device. This will be used by mdio PCS drivers to
> > simplify the creation and destruction handling, making it easier for
> > users to get it correct.
> 
> ...
> 
> > +static inline void mdio_device_get(struct mdio_device *mdiodev)
> > +{
> > +	get_device(&mdiodev->dev);
> 
> Dunno what is the practice in net, but it makes sense to have the pattern as
> 
> 	if (mdiodev)
> 		return to_mdiodev(get_device(&mdiodev->dev));
> 
> which might be helpful in some cases. This approach is used in many cases in
> the kernel.

The device should exist. If it does not, it is a bug, and the
resulting opps will help find the bug.

	  Andrew

