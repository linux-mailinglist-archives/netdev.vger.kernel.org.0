Return-Path: <netdev+bounces-2005-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B116FFF0D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E17282819BC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDCCC7F6;
	Fri, 12 May 2023 02:48:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF40A7E9
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 02:48:00 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B213D4EC4
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 19:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=kffY5owKTXj0+ffGnRxeg0Dy51WAwkmg5zeS2kJv07Y=; b=PM
	9nnn0/NIEP6s8FjLpnX63XCGxYgkUo4Vl/CK4mV0oRhphAE2V21w246sttwQuw7O+6Ce28ZGejCsg
	uR1jU3U0/U3hoca9mahKv0L0Ke9xWPmqOHOk597he64Zqx6AuID77U5I0ir7Pm40tb3XiCG3KaM3A
	zjmCpjmHBgmVw7c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pxIp2-00CcMv-67; Fri, 12 May 2023 04:47:56 +0200
Date: Fri, 12 May 2023 04:47:56 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Ron Eggler <ron.eggler@mistywest.com>
Cc: netdev@vger.kernel.org
Subject: Re: PHY VSC8531 MDIO data not reflected in ethernet/ sub-module
Message-ID: <9fbcac7f-9d12-4a42-9f2f-345c37585ff4@lunn.ch>
References: <2cc45d13-78e5-d5c1-3147-1b44efc6a291@mistywest.com>
 <69d0d5d9-5ed0-4254-adaf-cf3f85c103b9@lunn.ch>
 <759ac0e2-9d5e-17ea-83e2-573a762492c2@mistywest.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <759ac0e2-9d5e-17ea-83e2-573a762492c2@mistywest.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I don't see it being invoked every Seconds but it gets invoked on boot, I
> added debug logs and see the following:

What should happen is when the MAC driver call phy_start(), it either
starts polling the PHY or it enabled interrupts. If it is not polling,
then is sounds like you have interrupts setup for the PHY. Scatter
some more debug prints around and about and see which is true.

> state = UP which means it's ready to start auto negotiation(in
> phy_state_machine())  but instead in phy_check_link_status(), phydev->state
> should be set to  PHY_RUNNING but it only can get set to PHY_RUNNING when
> phydev->link is 1 (in phy_check_link_status()):

Yep. Either via polling, or interrupts, the state machine will change
to state RUNNING.

> 
> >    phy_read_status()->
> >      phydev->drv->read_status()
> > or
> >      genphy_read_status()
> > 
> > Check what these are doing, why do they think the link is down.
> 
> Yes, so in phy_read_status, phydev->drv->read_status appears to be set but I
> cannot figure out where it gets set. (I obviously need to find the function
> to find why the link isn't read correctly).

Since this is a microchip PHY, i would expect vsc85xx_read_status().

> I temporarily set phydev->drv->read_status to 0 to force invocation of
> genphy_read_status() function to see how that would work.
> 
> genphy_update_link(0 is called from genphy_read_status() and I get the below
> data:
> 
> [    6.795480] DEBUG: in genphy_update_link(), after phy_read() bmcr 4160
> [    6.805225] DEBUG: in genphy_update_link(), bmcr 0x1040 & 0x200
> [    6.815730] DEBUG: in genphy_read_status(), genphy_update_link() 0
> phydev->autoneg 1, phydev->link 0
> 
> 
> Could it be that the link needs a second to come up when when the network
> drivers get started and hence I should make sure that the polling once a
> second works (which currently doesn't appear to be the case)? Am I missing a
> configuration option?

auto-neg takes a little over 1 second. Polling does not care, if it is
not up this time, it might be the next. If you are using interrupts,
then you need to ensure the interrupt actually fires when auto-neg is
complete.

	Andrew

