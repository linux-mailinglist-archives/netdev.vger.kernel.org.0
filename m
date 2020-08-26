Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E889C252CD2
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 13:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgHZLsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 07:48:46 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:12368 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbgHZLQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 07:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1598440618; x=1629976618;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7cweX0mwMTY5JaWzygL6KXQ9a11XC2CnlpfVVPkYxGw=;
  b=CaJjPWOuaaid74ZrOA3GPKTa5i/XAQd382Hw634fGzcyQ3JxCzGflaDF
   EHUiCSItXxaboe0AjF8/8xccR3PVlkVLOfLsMwNdExhhBM+gXM8CG7Ddt
   miWniQq4RJp/IHpuTBY4kFN8hmU7dR3KeIUtEyNyLHcPafgwEeI//5t0u
   LI9zsF2S8ZpCZm6Syulpck6bhK9dk1b5R8iQ/ELNCdYX09EUfxQaN+gbj
   IIspjLi5mH/iA/9ebRfXj++SY65R/DD4C2DvytIlatuELZPim0B1Tpiyt
   NqZGZK86DicMPbRpblIsHQboaXlg5fPVb1cAnYokR37EO1RcnFdqoTM6P
   Q==;
IronPort-SDR: Z+AEyeI1s7G4jBcZT+LpyjJ/E59uUZle0+H3FW85xlRAhQCEB9t0CFY9V3nRo/RVJEv8l4WDjy
 xkb7NBliRt+C86M1l4dBGcHL/LJZJli5kyHi5k2VCPp94tdzLxJpX2g7boNqlq3WD/Bv8LvaIn
 zLUuJSS2dZpr4Hg0SRFmUsQ1Sgr1E08+/Hpcn/52YCshpUJqRMwN4SnCHPARyqruSezCQGMQYJ
 D5JPtP8lLwWnCC7uBM308XOL85PMXbaA9CpZ3rYhHhj00QnTfqu8z5TOBhhe7fnTstXs5P6MCe
 AHU=
X-IronPort-AV: E=Sophos;i="5.76,355,1592895600"; 
   d="scan'208";a="24284527"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Aug 2020 04:16:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 04:16:04 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 26 Aug 2020 04:16:03 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v5 0/3] Add phylib support to smsc95xx
Date:   Wed, 26 Aug 2020 13:17:14 +0200
Message-ID: <20200826111717.405305-1-andre.edich@microchip.com>
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

Changes in v5:
- Removed all phy_read calls from the smsc95xx driver.

Changes in v4:
- Removed useless inline type qualifier.

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
 drivers/net/usb/smsc95xx.c | 475 +++++++++++++------------------------
 3 files changed, 238 insertions(+), 306 deletions(-)

-- 
2.28.0

