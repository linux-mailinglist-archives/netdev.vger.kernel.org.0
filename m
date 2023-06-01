Return-Path: <netdev+bounces-7082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28FF2719B77
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4A2F28175E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C2123435;
	Thu,  1 Jun 2023 12:02:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B86423429
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 12:02:39 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA24EE71;
	Thu,  1 Jun 2023 05:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=KV3wHUujsSOxU/oeIXKi+3r4Hg4NKOWlza+5RYzc5H4=; b=RnpPZu0KctrNBkYvsUddgdvG37
	dzbZhCKkPvYGI3KbQgO0PbpGVaP/2i6L7q0IOb87fkppGlNM6EQmQhbKZhVl+UjWzqjXsy16cvjFS
	WD9CLqPNm0nmOZggyZEGW+hj0/e6KOZN7AZYi2UBREAhKQv1L1y84aBVuVuYChIzRdd8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q4h04-00EZ39-6U; Thu, 01 Jun 2023 14:01:52 +0200
Date: Thu, 1 Jun 2023 14:01:52 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Andreas Svensson <andreas.svensson@axis.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	kernel@axis.com, Baruch Siach <baruch@tkos.co.il>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Increase wait after reset
 deactivation
Message-ID: <133860f9-e745-44ce-9b74-c5d990cf92db@lunn.ch>
References: <20230530145223.1223993-1-andreas.svensson@axis.com>
 <be44dfe3-b4cb-4fd5-b4bd-23eec4bd401c@lunn.ch>
 <f89e203a-af77-9661-1003-0e9370ff6fab@axis.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f89e203a-af77-9661-1003-0e9370ff6fab@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

 On Thu, Jun 01, 2023 at 11:10:58AM +0200, Andreas Svensson wrote:
> On 5/30/23 19:28, Andrew Lunn wrote:
> > On Tue, May 30, 2023 at 04:52:23PM +0200, Andreas Svensson wrote:
> > > A switch held in reset by default needs to wait longer until we can
> > > reliably detect it.
> > > 
> > > An issue was observed when testing on the Marvell 88E6393X (Link Street).
> > > The driver failed to detect the switch on some upstarts. Increasing the
> > > wait time after reset deactivation solves this issue.
> > > 
> > > The updated wait time is now also the same as the wait time in the
> > > mv88e6xxx_hardware_reset function.
> > 
> > Do you have an EEPROM attached and content in it?
> 
> There's no EEPROM attached to the switch in our design.
> 
> > 
> > It is not necessarily the reset itself which is the problem, but how
> > long it takes after the reset to read the contents of the
> > EEPROM. While it is doing that, is does not respond on the MDIO
> > bus. Which is why mv88e6xxx_hardware_reset() polls for that to
> > complete.
> 
> Ok, yes that makes sense. I could add the mv88e6xxx_g1_wait_eeprom_done
> function after the reset deactivation.

I don't think that works, because how to talk to the switch is not
determined until after the switch has been detected.

> The datasheet for 88E6393X also states that it needs at least 10ms
> before it's ready. But I suppose this varies from switch to switch.

O.K, let go with this change and see if anybody really complains. We
can always add a DT property later.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

You probably need to repost with my Reviewed-by added, now that Paolo
has changed the status of the patch.

    Andrew

