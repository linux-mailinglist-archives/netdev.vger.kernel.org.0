Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1630248BD1
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgHRQnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:43:41 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:37069 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgHRQnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597769019; x=1629305019;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=StIIR+Ntm5gormpsCMZ8gVy8DO4kYJGNrh4T/MLXslk=;
  b=cy3BblwP373WgAO14C04p+Z+GQUTZEsRVIsBvWrCF51r9zG5BKP6kxh9
   Jehuaia/YHOBkChAoq6NDuSeg4RNqAYcGroMhiIYAJyIJ07KZNUGdoSeR
   U5IBhIP0d2uBfDMrzcPOqvohMejJN2xi/qBjK6vRkB4Q1bzoQY3JUAn1p
   4Hv0P/nwl+JZgmjH2exUu4lKAL3fkOY7Shaarrz+eCxTDXnpLrO/srV2b
   vJJAeTxLYDL4g0iZIDec1Hop5hmLHB6F9fua//aTRSwEUqYoyh+Xgz4AI
   IMj9pLpAX8VPYeWJLWYZsxDumt6LyFi2hCRWmJLoiTxCZv2MbELwyEeoh
   g==;
IronPort-SDR: wZbAp6wnAPoMyKWZk0idpzBzOZ7yBQ28LahJauqD7Uqh9WMJbYLNNWvUiX5BVAL1lEe6B8m6RH
 Kn/Jl1IyhUaYwVZf6RpsGRyRdGSL8tFaIUioIdG25sJKyCxAYzEdT2kE72jVRd3+AQ1BXSrcbD
 H8JSTaadejA/r/6FU38A9LFG52t7QqMkpHJkWLHIL+RkQk42S0saneRDvqv9F6w+NwvdMoJJgB
 2Xaavd0iejV8XE2MTSgz8IF2AoDUshrW6t+f3TsiJoWd1Kw32dYF9r1VxlCZtiyncKi1qPcPGa
 tyQ=
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="83959367"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Aug 2020 09:43:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 09:42:48 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 18 Aug 2020 09:42:47 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v4 0/3] Add phylib support to smsc95xx
Date:   Tue, 18 Aug 2020 18:44:00 +0200
Message-ID: <20200818164403.209985-1-andre.edich@microchip.com>
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
 drivers/net/usb/smsc95xx.c | 465 ++++++++++++++-----------------------
 3 files changed, 238 insertions(+), 296 deletions(-)

-- 
2.28.0

