Return-Path: <netdev+bounces-7482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80FC47206D0
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB02B1C20F08
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384FB1C751;
	Fri,  2 Jun 2023 16:05:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84F61B909
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F442C433D2;
	Fri,  2 Jun 2023 16:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685721940;
	bh=4sswC/KO7WS/nNG1kv1Txkpug4QgL5N0WE8G9sOlGzY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZbKiFxYtXX85JY5+AVzF4GkfxLBoXNjLvgUm7pVcW1nV/JjyjxxnhMJqEOTg7jaZ/
	 t8RU8jecvAgq0+GYGQqAwjsAEVm2/A1RaMk/dYn0KPBmk2fJ82W3+626cenlnjhJLA
	 XiGRi86zmd8nEaxwZoxozNxZX22zyzj2Fb4d1g6YCoNUbmSSo2JETd7zZRmTxgOYpg
	 E0S5iiLLQYiU+Ts4AfNrcFbrUph8GTr415bn2lHxRZqi8hF4oVUri3Da8u5NH3C2lQ
	 9ZyOieK11Q9WbDSjhfOcK4YJiWLKU2yMEhd+opeXNQEw40/pnrRUC9jYVltOc1HmSq
	 hYKkejtWoYr+g==
Date: Fri, 2 Jun 2023 09:05:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleksij Rempel <linux@rempel-privat.de>,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
Message-ID: <20230602090539.6a4fa374@kernel.org>
In-Reply-To: <ZHmt9c9VsYxcoXaI@shell.armlinux.org.uk>
References: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
	<20230601213345.3aaee66a@kernel.org>
	<20230601213509.7ef8f199@kernel.org>
	<ZHmt9c9VsYxcoXaI@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Jun 2023 09:53:09 +0100 Russell King (Oracle) wrote:
> > Yes it is :)  All this to save the single line of assignment
> > after the read_poll_timeout() "call" ?  
> 
> Okay, so it seems you don't like it. We can't fix it then, and we'll
> have to go with the BUILD_BUG_ON() forcing all users to use a signed
> varable (which better be larger than a s8 so negative errnos can fit)
> or we just rely on Dan to report the problems.

Wait, did the version I proposed not work?

https://lore.kernel.org/all/20230530121910.05b9f837@kernel.org/

I just think the assignment inside the first argument is unnecessarily
unreadable. Maybe it's just me.

