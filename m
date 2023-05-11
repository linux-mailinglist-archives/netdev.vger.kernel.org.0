Return-Path: <netdev+bounces-1914-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5A86FF836
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F768281837
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A9D6FD3;
	Thu, 11 May 2023 17:16:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C832068B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:16:42 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF88C6597;
	Thu, 11 May 2023 10:16:40 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1px9u9-0001cR-35;
	Thu, 11 May 2023 17:16:38 +0000
Date: Thu, 11 May 2023 19:14:48 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH net-next 0/8] Improvements for RealTek 2.5G Ethernet PHYs
Message-ID: <ZF0iiDIZQzR8vMvm@pidgin.makrotopia.org>
References: <cover.1683756691.git.daniel@makrotopia.org>
 <55c11fd9-54cf-4460-a10c-52ff62b46a4c@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55c11fd9-54cf-4460-a10c-52ff62b46a4c@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 02:28:15AM +0200, Andrew Lunn wrote:
> On Thu, May 11, 2023 at 12:53:22AM +0200, Daniel Golle wrote:
> > Improve support for RealTek 2.5G Ethernet PHYs (RTL822x series).
> > The PHYs can operate with Clause-22 and Clause-45 MDIO.
> > 
> > When using Clause-45 it is desireable to avoid rate-adapter mode and
> > rather have the MAC interface mode follow the PHY speed. The PHYs
> > support 2500Base-X for 2500M, and Cisco SGMII for 1000M/100M/10M.
> 
> I don't see what clause-45 has to do with this. The driver knows that
> both C22 and C45 addresses spaces exists in the hardware. It can do
> reads/writes on both. If the bus master does not support C45, C45 over
> C22 will be performed by the core.

My understanding is/was that switching the SerDes interface mode is only
intended with Clause-45 PHYs, derived from this comment and code:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/phylink.c#n1661


Hence I concluded that for Clause-22 PHYs we expect the interface mode
to always remain the same, while many Clause-45 PHYs require switching
the SerDes interface mode depending on the speed of the external link.
Trying to use interface mode switching (in the .read_status function)
with is_c45 == false also just didn't work well:

https://github.com/openwrt/openwrt/pull/11990#issuecomment-1503160296


Up to 1000M this has no really been a problem, as the Cisco SGMII SerDes
supports 10M, 100M and 1000M speeds. Starting with 2500M things have
became more complicated, and we usually have the choice of either have
the MAC<->PHY link operate at a contant mode and speed (e.g. 2500Base-X)
or having to switch the MAC<->PHY interface mode (e.g. between
2500Base-X and SGMII) depending on whether the link speed on the
external interface is 2500M or not.

Looking at PHYs which support speeds beyond one gigabit/sec due to the
higher complexity and need for a larger register space most of them are
managed using Clause-45 MDIO. 2500Base-T PHYs are kind of the exception
because some of them (esp. RealTek) are still mostly being managed using
Clause-22 MDIO using proprietary paging mechanisms to enlarge the
register space.

I also don't like overloading the meaning of is_c45 to decide whether
rate-adapter mode should be used or not, neither do I like the idea to
tie the use of phylink to using SGMII in-band-status or not -- but at
this point both do correlate and there aren't any other feature flags or
validation methods to do it in a better way. In the end this can also
just be solved by documenation, ie. makeing sure that those facts are
well understood: interface mode switching only being supported when
using Clause-45 MDIO and also the fact that phylink expects operating
Cisco SGMII without in-band-status when connecting to a managed PHY.


