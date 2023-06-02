Return-Path: <netdev+bounces-7512-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F1E720829
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17DC51C2111B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A0D33304;
	Fri,  2 Jun 2023 17:11:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6F6848B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45636C4339B;
	Fri,  2 Jun 2023 17:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685725859;
	bh=y0lpwKHeDieUbztqCjByBGf79YkIRbAyA2zbccdV6QY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CPzUW5zpAWCfZs686/YDBP/5aWt3BLJ1v71AHDc9N+7js7+v6uAltrYJsPisrWyCy
	 gYbcb4NEX+PPiG8PQSI/EM2WGF9SztOsi5E1+Lq15tQ9AzuC9flFErJrFSMxBQ2uNy
	 H9xfMp5/kX73ZYkWfhwSplnPk1UcihvnRNYnlUut34dJyNmS3+3n8mQukWelkH3WIP
	 VIBB7qSOfomuEjdU0pMXVPLdQQMIm4GqwKQGA6UhYPzRsbqblKON2D0GZ5eKBbgjNQ
	 3Bl/9s956CAiTm8jOBgmDkJUnToArkt8kTqCRcOQp1zRegMUQzGpEIPyZsY41DxEcC
	 6wEEAZzxwrQrA==
Date: Fri, 2 Jun 2023 10:10:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleksij Rempel <linux@rempel-privat.de>,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
Message-ID: <20230602101058.7faf94bf@kernel.org>
In-Reply-To: <ZHoaF6O0Vlq9pikF@shell.armlinux.org.uk>
References: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
	<20230601213345.3aaee66a@kernel.org>
	<20230601213509.7ef8f199@kernel.org>
	<ZHmt9c9VsYxcoXaI@shell.armlinux.org.uk>
	<20230602090539.6a4fa374@kernel.org>
	<ZHoWN0uO30P/y9hv@shell.armlinux.org.uk>
	<ZHoaF6O0Vlq9pikF@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Jun 2023 17:34:31 +0100 Russell King (Oracle) wrote:
> On Fri, Jun 02, 2023 at 05:17:59PM +0100, Russell King (Oracle) wrote:
> > On Fri, Jun 02, 2023 at 09:05:39AM -0700, Jakub Kicinski wrote:  
> > > Wait, did the version I proposed not work?
> > > 
> > > https://lore.kernel.org/all/20230530121910.05b9f837@kernel.org/  
> > 
> > If we're into the business of throwing web URLs at each other for
> > messages we've already read, here's my one for you which contains
> > the explanation why your one is broken, and proposing my solution.
> > 
> > https://lore.kernel.org/all/ZHZmBBDSVMf1WQWI@shell.armlinux.org.uk/
> > 
> > To see exactly why yours is broken, see the paragraph starting
> > "The elephant in the room..."

Ah, yes, sorry, I'll admit I didn't get what you mean by the elephant
paragraph when I read that.

> If you don't like my solution, then I suppose another possibility would
> be:
> 
> #define __phy_poll_read(phydev, regnum, val) \
> 	({ \
> 		int __err; \
> 		__err = phy_read(phydev, regnum); \
> 		if (__err >= 0) \
> 			val = __err; \
> 		__err; \
> 	})
> 
> #define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
>                                 timeout_us, sleep_before_read) \
> ({ \
> 	int __ret, __err; \
> 	__ret = read_poll_timeout(__phy_poll_read, __err, \
> 				  __err < 0 || (cond), \
> 		sleep_us, timeout_us, sleep_before_read, phydev, regnum, val); \
> 	if (__err < 0) \
> 		__ret = __err; \
> ...
> 
> but that brings with it the possibility of using an uninitialised
> "val" (e.g. if phy_read() returns an error on the first iteration.)
> and is way more horrid and even less easy to understand.
> 
> Remember that we default to *not* warning about uninitialised variables
> when building the kernel, so this won't produce a warning - which I
> guess is probably why you didn't notice that your suggestion left "val"
> uninitialised.

Right :(  Let's keep the patch as is.

