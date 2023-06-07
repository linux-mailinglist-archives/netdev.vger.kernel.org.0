Return-Path: <netdev+bounces-8811-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44192725DD7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:58:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABD5D1C20C7C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7810D33C93;
	Wed,  7 Jun 2023 11:58:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4257488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:58:05 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B5C1BC7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9AFR6mA7nyUjPg8uYh+KbM98y8y1Y0m+aiFjJYlr1YU=; b=0Ndio7giu2kU6NWp+A+Z2xfhMg
	kuV3L5Eyi0gc+ik7mZyYOjfOMIXCxP1ldyk6tjmMI3cXv+LOnF2Vg1dCrgUSgZqyc9qHSGoZrnWkB
	YO6+vKxz+K913BBx6gVdM2SRDwvvVTVB4O0rAU6yFjDCdpT0q0mBJPjAfjSeHjmQ8pG8a/Nt3ifQm
	/mFjFeDN0XiqaLtueDf8xPZgjaA0GKCCUvX7a7TdIGoZHxsobr5eb+pTrEPdRMfHUS/A2FIRS4i+D
	K8tU0bsUKivpdpib5+n/S7OJfLKbI2CjvB8PUgxDSGDLZwb2XiOx1Y/exvom/GjQs77CQ36xihBTc
	QvCDETxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39158)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6rnS-0007KL-UY; Wed, 07 Jun 2023 12:57:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6rnP-0008Bj-LM; Wed, 07 Jun 2023 12:57:47 +0100
Date: Wed, 7 Jun 2023 12:57:47 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 00/11] complete Lynx mdio device handling
Message-ID: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This series completes the mdio device lifetime handling for Lynx PCS
users which do not create their own mdio device, but instead fetch
it using a firmware description - namely the DPAA2 and FMAN_MEMAC
drivers.

In a previous patch set, lynx_pcs_create() was modified to increase
the mdio device refcount, and lynx_pcs_destroy() to drop that
refcount.

The first two patches change these two drivers to put the reference
which they hold immediately after lynx_pcs_create(), effectively
handing the responsibility for maintaining the refcount to the Lynx
PCS driver.

A side effect of the first two patches is that lynx_get_mdio_device()
is no longer used, so patch 3 removes it.

Patch 4 adds a new helper - lynx_pcs_create_fwnode(), which creates
a Lynx PCS instance from the fwnode.

Patch 5 and 6 convert the two drivers to make use of this new helper,
which simply has to find the mdio device, and then create the Lynx
PCS from that.

With those conversions done, lynx_pcs_create() is no longer required
outside pcs-lynx.c, so remove it from public view.

Patch 8 we changes lynx_pcs_create() to return an error-pointer rather
than NULL to bring consistency to the return style, and means that we
can remove the NULL-to-error-pointer conversion from both
lynx_pcs_create_fwnode() and lynx_pcs_create_mdiodev().

Patch 9 adds a check for the fwnode being available, and returns an
-ENODEV error pointer if unavailable.

Patch 10 removes this check from DPAA2, detecting the error pointer
value to continue printing the helpful message.

Patch 11 removes this check from fman_memac, and in doing so fixes a
bug where if the node is unavailable, the reference count is not
dropped.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 32 +++++++-------
 drivers/net/ethernet/freescale/fman/fman_memac.c | 18 ++------
 drivers/net/pcs/pcs-lynx.c                       | 54 +++++++++++++++++-------
 include/linux/pcs-lynx.h                         |  4 +-
 4 files changed, 58 insertions(+), 50 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

