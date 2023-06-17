Return-Path: <netdev+bounces-11753-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B6E73445F
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 00:29:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A4428130F
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 22:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD0A137C;
	Sat, 17 Jun 2023 22:29:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEABEC9
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 22:29:08 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18CC1AA;
	Sat, 17 Jun 2023 15:29:06 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1qAePH-0005ow-24;
	Sat, 17 Jun 2023 22:28:31 +0000
Date: Sun, 18 Jun 2023 00:26:32 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Arnd Bergmann <arnd@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>,
	Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
	Frank Sae <Frank.Sae@motor-comm.com>,
	Michael Walle <michael@walle.cc>,
	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: phy: mediatek: fix compile-test dependencies
Message-ID: <ZI4zGF4MUSclEJK_@pidgin.makrotopia.org>
References: <20230616093009.3511692-1-arnd@kernel.org>
 <ZIxL16HWci5dd7Ah@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIxL16HWci5dd7Ah@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 01:47:35PM +0200, Simon Horman wrote:
> On Fri, Jun 16, 2023 at 11:29:54AM +0200, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The new phy driver attempts to select a driver from another subsystem,
> > but that fails when the NVMEM subsystem is disabled:
> > 
> > WARNING: unmet direct dependencies detected for NVMEM_MTK_EFUSE
> >   Depends on [n]: NVMEM [=n] && (ARCH_MEDIATEK [=n] || COMPILE_TEST [=y]) && HAS_IOMEM [=y]
> >   Selected by [y]:
> >   - MEDIATEK_GE_SOC_PHY [=y] && NETDEVICES [=y] && PHYLIB [=y] && (ARM64 && ARCH_MEDIATEK [=n] || COMPILE_TEST [=y])
> > 
> > I could not see an actual compile time dependency, so presumably this
> > is only needed for for working correctly but not technically a dependency
> 
> nit: for for -> for
>      or
>      for for working correctly -> for correct operation
> 
> > on that particular nvmem driver implementation, so it would likely
> > be safe to remove the select for compile testing.
> > 
> > To keep the spirit of the original 'select', just replace this with a
> > 'depends on' that ensures that the driver will work but does not get in
> > the way of build testing.
> > 
> > Fixes: 98c485eaf509b ("net: phy: add driver for MediaTek SoC built-in GE PHYs")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> I don't know the answer to the question of if this dependency is needed or
> not. But I do agree that it does what it says on the box.

It's not needed to build or load the driver, but the PHY won't function
at all without reading values from the SoCs efuse, and for that the
nvmem driver is required.

Using a simple dependency instead of select will fix it.

Reviewed-by: Daniel Golle <daniel@makrotopia.org>

> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> 

