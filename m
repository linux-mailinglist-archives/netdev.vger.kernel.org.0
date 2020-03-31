Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83532198B1A
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 06:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgCaEPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 00:15:04 -0400
Received: from inva020.nxp.com ([92.121.34.13]:39090 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgCaEPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 00:15:04 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8B2091A18AA;
        Tue, 31 Mar 2020 06:15:02 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 526911A07A6;
        Tue, 31 Mar 2020 06:14:56 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 8348340294;
        Tue, 31 Mar 2020 12:14:48 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: [v2, 0/7] Support programmable pins for Ocelot PTP driver
Date:   Tue, 31 Mar 2020 12:11:06 +0800
Message-Id: <20200331041113.15873-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ocelot PTP clock driver had been embedded into ocelot.c driver.
It had supported basic gettime64/settime64/adjtime/adjfine functions
by now which were used by both Ocelot switch and Felix switch.

This patch-set is to move current ptp clock code out of ocelot.c driver
maintaining as a single ocelot_ptp.c driver, and to implement 4
programmable pins with only PTP_PF_PEROUT function for now.
The PTP_PF_EXTTS function will be supported in the future, and it should
be implemented separately for Felix and Ocelot, because of different
hardware interrupt implementation in them.
---
Changes for v2:
	- Put PTP driver under drivers/net/ethernet/mscc/.
	- Dropped MAINTAINERS patch. Kept original maintaining.
	- Initialized PTP separately in ocelot/felix platforms.
	- Supported PPS case in programmable pin.
	- Supported disabling pin function since deadlock is fixed by Richard.
	- Returned -EBUSY if not finding pin available.

Yangbo Lu (7):
  net: mscc: ocelot: move ocelot ptp clock code out of ocelot.c
  net: mscc: ocelot: fix timestamp info if ptp clock does not work
  net: mscc: ocelot: redefine PTP pins
  net: mscc: ocelot: add wave programming registers definitions
  net: mscc: ocelot: support 4 PTP programmable pins
  net: mscc: ocelot: enable PTP programmable pin
  net: dsa: felix: enable PTP programmable pin

 drivers/net/dsa/ocelot/felix.c                     |  27 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   2 +
 drivers/net/ethernet/mscc/Makefile                 |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 | 212 +-------------
 drivers/net/ethernet/mscc/ocelot.h                 |   3 +-
 drivers/net/ethernet/mscc/ocelot_board.c           |  27 ++
 drivers/net/ethernet/mscc/ocelot_ptp.c             | 324 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_regs.c            |   2 +
 include/soc/mscc/ocelot.h                          |  15 +-
 .../net/ethernet => include/soc}/mscc/ocelot_ptp.h |  17 ++
 10 files changed, 417 insertions(+), 214 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_ptp.c
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_ptp.h (52%)

-- 
2.7.4

