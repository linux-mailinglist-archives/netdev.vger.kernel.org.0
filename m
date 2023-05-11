Return-Path: <netdev+bounces-1757-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B276FF118
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BD9F28143F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C9E19BD9;
	Thu, 11 May 2023 12:08:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796DF2102
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:08:36 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F8F4230;
	Thu, 11 May 2023 05:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=8ZA3oVnVqNHhpwI3665roub6ECdVmBtX6Sfswr9rqi0=; b=c7fesVzXinQ6B0tzbseSsCVHlU
	nKn2B1cwbU2w50id8z8HUd8I7djNP+ZfQl2FsrAslFf1CdMP5KvGGwd6Y3cOH7VInh76Ij+qM9/Pg
	/pfNzYQODOYcbY2SzogIDQ4Bg3ucdOwv1LRUKOW0f2bgOMcP2NjM4Dx2Z3P1odbkXndw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1px55i-00CY8z-RO; Thu, 11 May 2023 14:08:14 +0200
Date: Thu, 11 May 2023 14:08:14 +0200
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
Subject: Re: [PATCH net-next v2 1/3] net: phy: Allow drivers to always call
 into ->suspend()
Message-ID: <4f43d4cf-f889-46ed-bc20-d9cd2fb88a53@lunn.ch>
References: <20230509223403.1852603-1-f.fainelli@gmail.com>
 <20230509223403.1852603-2-f.fainelli@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509223403.1852603-2-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 03:34:01PM -0700, Florian Fainelli wrote:
> A few PHY drivers are currently attempting to not suspend the PHY when
> Wake-on-LAN is enabled, however that code is not currently executing at
> all due to an early check in phy_suspend().
> 
> This prevents PHY drivers from making an appropriate decisions and put
> the hardware into a low power state if desired.
> 
> In order to allow the PHY drivers to opt into getting their ->suspend
> routine to be called, add a PHY_ALWAYS_CALL_SUSPEND bit which can be
> set. A boolean that tracks whether the PHY or the attached MAC has
> Wake-on-LAN enabled is also provided for convenience.
> 
> If phydev::wol_enabled then the PHY shall not prevent its own
> Wake-on-LAN detection logic from working and shall not prevent the
> Ethernet MAC from receiving packets for matching.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

