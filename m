Return-Path: <netdev+bounces-1747-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9826FF0A6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B84601C20F12
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 176E419BBE;
	Thu, 11 May 2023 11:46:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6528F73
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:46:47 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7AF2D42;
	Thu, 11 May 2023 04:46:46 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1px4ks-0008OX-25;
	Thu, 11 May 2023 11:46:42 +0000
Date: Thu, 11 May 2023 13:44:48 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH net-next 0/8] Improvements for RealTek 2.5G Ethernet PHYs
Message-ID: <ZFzVMHCTMeiTB4T1@pidgin.makrotopia.org>
References: <cover.1683756691.git.daniel@makrotopia.org>
 <018df89a-c3d2-1bda-9966-7f06b24f87f2@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <018df89a-c3d2-1bda-9966-7f06b24f87f2@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 07:29:21AM +0200, Heiner Kallweit wrote:
> On 11.05.2023 00:53, Daniel Golle wrote:
> > Improve support for RealTek 2.5G Ethernet PHYs (RTL822x series).
> > The PHYs can operate with Clause-22 and Clause-45 MDIO.
> > [...]
> 
> Has this series been tested with RTL8125A/B to ensure that the internal
> PHY use case still works?

The series has been present in OpenWrt for a while now and initially
contained a bug which broke the RTL8221 PCIe RealTek NICs. It has since been
resolved and re-tested, and it seems all fine:

https://github.com/openwrt/openwrt/commit/998b9731577dedc7747dcfa412e4543dabaaa131#r110201620

I assume that quite some OpenWrt users may use RTL8125B PCIe NICs, but I
have asked in the OpenWrt forum for testing results including this series:

https://forum.openwrt.org/t/nanopi-r6s-kernel-6-1-intergration/154677/3?u=daniel

As the r8169 driver is not using phylink and uses C22 to connect to the
PHY the main difference which will affect these devices is that
genphy_soft_reset will be called as a result of
r8169_hw_phy_config->phy_init_hw->(phydrv).soft_reset

Also note the r8169 driver always sets the interface mode to either
PHY_INTERFACE_MODE_GMII or PHY_INTERFACE_MODE_MII in
r8169_phy_connect() before calling phy_connect_direct(). While this is
certainly not technically correct for the 2.5G NICs in the strict sense,
it does have the desired effect that the newly introduced function
rtl8221b_config_init() just returns without making any changes.


