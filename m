Return-Path: <netdev+bounces-647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 932A76F8CFB
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D94B41C21A4A
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1721C184;
	Sat,  6 May 2023 00:03:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B2F180
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 00:03:36 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A5C5FD1
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 17:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=rmlrbiHyrYBQluLuXve/L/om6E/VtT2zEjxSvF5eG5U=; b=fDiFiNpCqps89h+YUrLvcBD6c9
	yNp31bh1mEtHgalapI2AuULex3+IiVGCsfTL3m8pkrfNNV57DHbmzyUytIGI7lUOnstt/2q+B08N7
	IFzWHE46zd1BhgGoHfuQrVP/TPZ9OyNoXjFaSvoQvcqmYSihV2JSp53JLX8ycZ0zvFVU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pv5Oe-00C2Jv-Fy; Sat, 06 May 2023 02:03:32 +0200
Date: Sat, 6 May 2023 02:03:32 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lorenz Brun <lorenz@brun.one>
Cc: netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Quirks for exotic SFP module
Message-ID: <d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
References: <C157UR.RELZCR5M9XI83@brun.one>
 <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
 <CQF7UR.5191D6UPT6U8@brun.one>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CQF7UR.5191D6UPT6U8@brun.one>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > 
> > >  But the module internally has an AR8033 1000BASE-X to RGMII
> > > converter which
> > >  is then connected to the modem SoC, so as far as I am aware this is
> > >  incorrect and could cause Linux to do things like autonegotiation
> > > which
> > >  definitely does not work here.
> > 
> > Is there anything useful to be gained by talking to the PHY? Since it
> > appears to be just a media converter, i guess the PHY having link is
> > not useful. Does the LOS GPIO tell you about the G.Fast modem status?

> AFAIK you cannot talk to the PHY as there isn't really an Ethernet PHY.

So i2c-detect does not find anything other than at address 0x50?

Often the PHY can be access via an MDIO bus over I2C at some other
address on the bus. The linux SFP code might be trying, even
succeeding, in instantiating such a bus and finding the PHY. And then
a PHY driver will be loaded to drive the PHY. This is how Copper SFP
modules work. However, most Copper SFP use a Marvell PHY, not
Atheros. And RollBall SFP use a different MDIO over i2c protocol.

> I actually haven't checked the LOS GPIO. This thing runs ~1MiB of firmware
> and two different proprietary management protocols which I've
> reverse-engineered over which you can get tons of data about the current
> modem and link status. You need those to boot the SoC anyways. The TX
> disable GPIO puts the modem SoC into reset state and is used in case you use
> a host-based watchdog for the module.

So i guess you are not passing the GPIO for TX disable in your DT
blob. And maybe not LOS. If you do, it must be doing something
sensible, because phylink does not allow the carrier to go up if LOS
is active. Although the EEPROM can indicate LOS is not
implemented. But that assumes the EEPROM contents are sane.

Russell King will be interested in a binary dump from ethtool -m.

   Andrew

