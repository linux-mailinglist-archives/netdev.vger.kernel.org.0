Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9F24839D
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgHRLLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:11:23 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:40374 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHRLLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 07:11:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597749081; x=1629285081;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xhKjqv8pnUy5VV0KN1PSofSe4ljx2S5OxGa+T6u5GUM=;
  b=dX5aXJsYt+7u37bMdUCWv7xlQavoAg9PJns+LvLmE+O5dj59Vbo3JML9
   NKL5nt1+RJMLfhRC1FfrXsIpvr99dDg/D5WvPVy0/flWGLtnqUKvHaU2f
   CqFnPQs9wShw/8J6AdJkAw9L90crYkDTeCYJudm2JU8SnltHZIqxTXwlc
   9tqLOcODp3pkc+7cu30u8ee2SHfBuwF8IX0bc1BW16sYUed7tJ6gP/Zs3
   y1geJDtPZNvWQJmL9BkmHQ2qx1O0Zil5R9Q2RRnHBdqmurWzhRFJ5Dcyl
   p5lUJyebTr9HqeOWnmCi5/FtOrtEw5VHHrDAGs1AuaT43MRbB5knqwgtR
   w==;
IronPort-SDR: XWh/GaUfRNZWKssLad+8pB6nebMe1yCx5rFxAZCvawBZdZVOjQI2DV+H72jPRp9dPUdq8WTLvX
 0aYENTuv9W1k0f3ZnMA7ey/zFnvU/929mb+EsT29+Rp95O2LhsRnPAZoWwb1XGE2eail6z4gzg
 eDvJ3M6KGyLxYxjMJ+Zl/x3FTpQLqXBaP+qFeuF+EDlPNVmoV84y9dnQx/IF3q52btqiZ7okLS
 Umu+Pf0kMLi9V2LAGZuPEodOGtNu21mU8MJF7sIWStNv0OZuOvQxnVVuSbYJj1F2kKZ+O/YB2+
 dp8=
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="85999580"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Aug 2020 04:11:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 04:10:33 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 18 Aug 2020 04:11:18 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v3 0/3] Add phylib support to smsc95xx
Date:   Tue, 18 Aug 2020 13:11:24 +0200
Message-ID: <20200818111127.176422-1-andre.edich@microchip.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow to probe external PHY drivers, this patch series adds use of
phylib to the smsc95xx driver.

Changes in v3:
- Moved all MDI-X functionality to the corresponding phy driver;
- Removed field internal_phy from a struct smsc95xx_priv;
- Initialized field is_internal of a struct phy_device;
- Kconfig: Added selection of PHYLIB and SMSC_PHY for USB_NET_SMSC95XX.

Changes in v2:
- Moved 'net' patches from here to the separate patch series;
- Removed redundant call of the phy_start_aneg after phy_start;
- Removed netif_dbg tracing "speed, duplex, lcladv, and rmtadv";
- mdiobus: added dependency from the usbnet device;
- Moved making of the MII address from 'phy_id' and 'idx' into the
  function mii_address;
- Moved direct MDIO accesses under condition 'if (pdata->internal_phy)',
  as they only need for the internal PHY;
- To be sure, that this set of patches is git-bisectable, tested each
  sub-set of patches to be functional for both, internal and external
  PHYs, including suspend/resume test for the 'devices'
  (5.7.8-1-ARCH, Raspberry Pi 3 Model B).

Andre Edich (3):
  smsc95xx: remove redundant function arguments
  smsc95xx: use usbnet->driver_priv
  smsc95xx: add phylib support

 drivers/net/phy/smsc.c     |  67 ++++++
 drivers/net/usb/Kconfig    |   2 +
 drivers/net/usb/smsc95xx.c | 465 ++++++++++++++-----------------------
 3 files changed, 238 insertions(+), 296 deletions(-)

-- 
2.28.0

