Return-Path: <netdev+bounces-4680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A419F70DD7D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FB8D1C20D24
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF6F1E50A;
	Tue, 23 May 2023 13:32:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA054A84C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:32:48 +0000 (UTC)
Received: from smtp.missinglinkelectronics.com (smtp.missinglinkelectronics.com [162.55.135.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BC5CA;
	Tue, 23 May 2023 06:32:46 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp.missinglinkelectronics.com (Postfix) with ESMTP id DB07E2066D;
	Tue, 23 May 2023 15:32:44 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at missinglinkelectronics.com
Received: from smtp.missinglinkelectronics.com ([127.0.0.1])
	by localhost (mail.missinglinkelectronics.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xbQzKADQGLtw; Tue, 23 May 2023 15:32:44 +0200 (CEST)
Received: from nucnuc.mle (p578c5bfe.dip0.t-ipconnect.de [87.140.91.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: david)
	by smtp.missinglinkelectronics.com (Postfix) with ESMTPSA id 60A8720484;
	Tue, 23 May 2023 15:32:44 +0200 (CEST)
Date: Tue, 23 May 2023 15:32:36 +0200
From: David Epping <david.epping@missinglinkelectronics.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v2 0/3] net: phy: mscc: support VSC8501
Message-ID: <20230523133236.GA7185@nucnuc.mle>
References: <20230523090405.10655-1-david.epping@missinglinkelectronics.com>
 <c613298d-53bc-46ef-9cb2-4b385e21ba7b@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c613298d-53bc-46ef-9cb2-4b385e21ba7b@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 03:16:51PM +0200, Andrew Lunn wrote:
> > - I left the mutex_lock(&phydev->lock) in the
> >   vsc85xx_update_rgmii_cntl() function, as I'm not sure whether it
> >   is required to repeatedly access phydev->interface and
> >   phy_interface_is_rgmii(phydev) in a consistent way.
> 
> Just adding to Russell comment.
> 
> As a general rule of thumb, if your driver is doing something which no
> other driver is doing, you have to consider if it is correct. A PHY
> driver taking phydev->lock is very unusual. So at minimum you should
> be able to explain why it is needed. And when it comes to locking,
> locking is hard, so you really should understand it.
> 
> Now the mscc is an odd device, because it has multiple PHYs in the
> package, and a number of registers are shared between these PHYs. So
> it does have different locking requirements to most PHYs. However, i
> don't think that is involved here. Those oddities are hidden behind
> phy_base_write() and phy_base_read().
> 
> 	Andrew

Russell, Andrew,

as you stated, locking is hard, and I am not in detail familiar with
the mscc driver and the supported PHYs behavior. Also, I only have
VSC8501, the single PHY chip, and none of the multi PHY chips to test.
And testing these corner cases and race conditions is hard anyways.
Thus my current patch is not touching the locking code at all, and
assumes the current mainline code is correct in that regard.
Because I don't understand all implications, I'm hesitant to change
the existing locking scheme.
Maybe this can be a separate patch? In the current patch set I'm not
making the situation worse (unlike the first one where I added locks
which Russell pointed out).
If you insist and all agree the locks should be removed with this
patch set, I'll update it of course.

