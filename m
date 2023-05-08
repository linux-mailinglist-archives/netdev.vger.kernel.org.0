Return-Path: <netdev+bounces-931-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D32E36FB69A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 199991C20A3D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA1111185;
	Mon,  8 May 2023 19:03:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35DC5682
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:03:08 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A259E619C;
	Mon,  8 May 2023 12:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=c8e/6VIk230VODNeSrZf7IikSsjzhni/A+W73DH4nTU=; b=Wi35jIlHnk5ma7uxV1feO5J8kZ
	rSEKLwH5CgcbTxO30CjzC3hdnMSLc4jKheKiHFdB6zSU5q2Obwxofifmpp0K862PVZtmIpn1Ubzza
	Qd9qiuXRwjro+ExjO1kFkflhdr1jiAvdb3DMUzOxEwFB9D5SBIsu3QUghf11uyqIlLP0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pw685-00CDta-OE; Mon, 08 May 2023 21:02:37 +0200
Date: Mon, 8 May 2023 21:02:37 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: Let drivers check Wake-on-LAN
 status
Message-ID: <a4a76d54-c264-4ed8-8784-93ea392615e8@lunn.ch>
References: <20230508184309.1628108-1-f.fainelli@gmail.com>
 <20230508184309.1628108-2-f.fainelli@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508184309.1628108-2-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 11:43:07AM -0700, Florian Fainelli wrote:
> A few PHY drivers are currently attempting to not suspend the PHY when
> Wake-on-LAN is enabled, however that code is not currently executing at
> all due to an early check in phy_suspend().
> 
> This prevents PHY drivers from making an appropriate decisions and put
> the hardware into a low power state if desired.
> 
> In order to allow the PHY framework to always call into the PHY driver's
> ->suspend routine whether Wake-on-LAN is enabled or not, provide a
> phydev::wol_enabled boolean that tracks whether the PHY or the attached
> MAC has Wake-on-LAN enabled.
> 
> If phydev::wol_enabled then the PHY shall not prevent its own
> Wake-on-LAN detection logic from working and shall not prevent the
> Ethernet MAC from receiving packets for matching.

Hi Florian

Did you look at using late_suspend for this? Then there would not be
any need to change all these drivers which are happy as they are.

It actually looks like late_suspend is what you want anyway, when you
say you want to turn the matching hardware on as late as possible.

    Andrew

