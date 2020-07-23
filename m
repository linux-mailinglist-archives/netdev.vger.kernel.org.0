Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF7422AE72
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgGWLzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:55:19 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3710 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWLzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595505319; x=1627041319;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y4ED+BN2kLneOnH227xhFWP2IwCEJZDkJGbtYrncwHc=;
  b=GGU6AYKp5jW8XzTUeWr77f+5wFoFV19NNMlf27eBggnhG7fYTZbLT4/6
   YZBzKLeW9lJyC/pS/K8WCMdmCV5hSMhoUkUE5c+RQeiW/30e6lB14Ok0N
   KqepyFkvLw84di91bkqDdtdGLiyz5III2qatE36UrICBdjZPm9pTFbk7t
   LCosHKFJgDybwtvKlQjP6O6sEgLLUhKQth/kmJdQK0iOlAKmOVT6y+hO7
   oft5LAJFMdUGyJGQ6SqKGpQ+okfVhGKYrl/OH/N53r6K+2SdNkoF75gMz
   G1L1UBtNrY4hFRlji5UORbkPxI71/wzzr5dArfVYl1okHrhfWES9iTbEH
   g==;
IronPort-SDR: iINZKfvm4mk42+Z58GoDKXqjjDmEl6qaHGm7Skmu5iyxll4vx/DzaBzVwb3z6y8gcLuhHCIa6C
 uiKqzfHuI3IwhXyIvjnfPsXmy14MqOpRUqlq90q8CGnKjn2p1y6xdVUKR94sWIqQ7sIgW0RcsV
 CEgjx2z78ykm1PkcWlttcJaRfDaiFJHCi68+D6cEoQ1XPTK62rmln/XkkKf7AUJWotaJSWNqXL
 Gb4gGmebVcJEnOpjBvJlR6FQnSv5uzhmJwUhZO/vpZ9EYvsiVRwVHCoTf9mmhXLV50IlVND6J9
 I2w=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="84332634"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 04:55:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 04:54:35 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 04:54:34 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v2 0/6] Add PAL support to smsc95xx
Date:   Thu, 23 Jul 2020 13:55:01 +0200
Message-ID: <20200723115507.26194-1-andre.edich@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow to probe external PHY drivers, this patch series adds use of
Phy Abstraction Layer to the smsc95xx driver.

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

Andre Edich (6):
  smsc95xx: remove redundant function arguments
  smsc95xx: use usbnet->driver_priv
  smsc95xx: add PAL support to use external PHY drivers
  smsc95xx: remove redundant link status checking
  smsc95xx: use PAL framework read/write functions
  smsc95xx: use PHY framework instead of MII library

 drivers/net/usb/smsc95xx.c | 413 +++++++++++++++++--------------------
 1 file changed, 194 insertions(+), 219 deletions(-)

-- 
2.27.0

