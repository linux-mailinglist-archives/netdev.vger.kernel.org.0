Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE48F36BE1F
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhD0EMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:12:24 -0400
Received: from inva021.nxp.com ([92.121.34.21]:45128 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhD0EMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:12:23 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C1D1220187C;
        Tue, 27 Apr 2021 06:11:39 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AC6C6201879;
        Tue, 27 Apr 2021 06:11:33 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 34E984029D;
        Tue, 27 Apr 2021 06:11:26 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next, v3, 0/7] Support Ocelot PTP Sync one-step timestamping
Date:   Tue, 27 Apr 2021 12:21:56 +0800
Message-Id: <20210427042203.26258-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to support Ocelot PTP Sync one-step timestamping.
Actually before that, this patch-set cleans up and optimizes the
DSA slave tx timestamp request handling process.

Changes for v2:
	- Split tx timestamp optimization patch.
	- Updated doc patch.
	- Freed skb->cb usage in dsa core driver, and moved to device
	  drivers.
	- Other minor fixes.
Changes for v3:
	- Switched sequence of patch #3 and #4 with rebasing to fix build.
	- Replaced hard coded 48 of memset(skb->cb, 0, 48) with sizeof().

Yangbo Lu (7):
  net: dsa: check tx timestamp request in core driver
  net: dsa: no longer identify PTP packet in core driver
  net: dsa: no longer clone skb in core driver
  net: dsa: free skb->cb usage in core driver
  docs: networking: timestamping: update for DSA switches
  net: mscc: ocelot: convert to ocelot_port_txtstamp_request()
  net: mscc: ocelot: support PTP Sync one-step timestamping

 Documentation/networking/timestamping.rst     | 63 ++++++++------
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   | 28 ++++---
 .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |  4 +-
 drivers/net/dsa/mv88e6xxx/hwtstamp.c          | 26 ++++--
 drivers/net/dsa/mv88e6xxx/hwtstamp.h          | 10 +--
 drivers/net/dsa/ocelot/felix.c                | 19 +++--
 drivers/net/dsa/sja1105/sja1105_main.c        |  2 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 16 ++--
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  4 +-
 drivers/net/ethernet/mscc/ocelot.c            | 83 +++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot_net.c        | 20 ++---
 include/linux/dsa/sja1105.h                   |  3 +-
 include/net/dsa.h                             | 18 +---
 include/soc/mscc/ocelot.h                     | 21 ++++-
 net/dsa/Kconfig                               |  2 +
 net/dsa/slave.c                               | 23 +----
 net/dsa/tag_ocelot.c                          | 27 +-----
 net/dsa/tag_ocelot_8021q.c                    | 41 +++------
 18 files changed, 230 insertions(+), 180 deletions(-)


base-commit: 6d72e7c767acbbdd44ebc7d89c6690b405b32b57
-- 
2.25.1

