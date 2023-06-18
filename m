Return-Path: <netdev+bounces-11795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4C37347A8
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54DAB280F70
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4311779C2;
	Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360918F7F
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:41:45 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB9C138
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Content-Disposition:In-Reply-To:References;
	bh=7nSDIyJ4sgy5LMzTS/Cic5o3DS/RxWcC/1lSkTVbkPA=; b=PoibLUvxpOJxBP4gHVZ/PmGSLo
	+AWNzb6MXVoSIzqpKI9GMrnNaHdrEZXU8i9RD5JZlKzbhPnOIrXSlOgwe1msoJfht4yJbZi6P87Cm
	zzom1tFXuvfGRB1O2IIeCXx5BoHTYLhAeEan/CO1KGWC2Fbel8rtMN4QFr1nB9VexGis=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAxLC-00Gr2w-E2; Sun, 18 Jun 2023 20:41:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 net-next 0/9] net: ethernet: Rework EEE
Date: Sun, 18 Jun 2023 20:41:10 +0200
Message-Id: <20230618184119.4017149-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Most MAC drivers get EEE wrong. The API to the PHY is not very
obvious, which is probably why. Rework the API, pushing most of the
EEE handling into phylib core, leaving the MAC drivers to just
enable/disable support for EEE in there change_link call back.

MAC drivers are now expect to indicate to phylib if they support
EEE. This will allow future patches to configure the PHY to advertise
no EEE link modes when EEE is not supported. The information could
also be used to enable SmartEEE if the PHY supports it.

With these changes, the uAPI configuration eee_enable becomes a global
on/off. tx-lpi must also be enabled before EEE is enabled. This fits
the discussion here:

https://lore.kernel.org/netdev/af880ce8-a7b8-138e-1ab9-8c89e662eecf@gmail.com/T/

This patchset puts in place all the infrastructure, and converts one
MAC driver to the new API. Following patchsets will convert other MAC
drivers, extend support into phylink, and when all MAC drivers are
converted to the new scheme, clean up some unneeded code.

v4
--

Only convert one MAC driver
Drop all phylink code
Conform to the uAPI discision.

v3
--
Rework phylink code to add a new callback.
Rework function to indicate clock should be stopped during LPI

Andrew Lunn (8):
  net: phy-c45: Fix genphy_c45_ethtool_set_eee description
  net: phy: Add phydev->enable_tx_lpi to simplify adjust link callbacks
  net: phy: Add helper to set EEE Clock stop enable bit
  net: phy: Keep track of EEE configuration
  net: phy: Immediately call adjust_link if only tx_lpi_enabled changes
  net: phy: Add phy_support_eee() indicating MAC support EEE
  net: fec: Move fec_enet_eee_mode_set() and helper earlier
  net: fec: Fixup EEE

Russell King (1):
  net: add helpers for EEE configuration

 drivers/net/ethernet/freescale/fec_main.c | 88 ++++++++++-------------
 drivers/net/phy/phy-c45.c                 | 20 ++++--
 drivers/net/phy/phy.c                     | 53 +++++++++++++-
 drivers/net/phy/phy_device.c              | 18 +++++
 include/linux/phy.h                       |  9 ++-
 include/net/eee.h                         | 38 ++++++++++
 6 files changed, 165 insertions(+), 61 deletions(-)
 create mode 100644 include/net/eee.h

-- 
2.40.1


