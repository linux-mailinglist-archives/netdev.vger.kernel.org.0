Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA12A9CB5C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfHZIOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:14:44 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:42666 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfHZIOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:14:43 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: z3+gMa6lHQJiOt2w+Y+z1SBhMnOd+ErKsQoMCsa7YeEyO0N88kZ96F8NUPmha3S5TN8Qn8QrPl
 Yi/ypLXTd7XiKpe4Cg25m3UCFshDhY+1jXPuVWE2cdCqB+cCDB/K3V9CAMFKfdPARv7AO83Faa
 GmHGV3sBZ+PW/y2YEeW3k8ZWDFdmL8quLnsU2IVR0cfiKLmDES10wZok9k7jGAAK7MAxObF63m
 L18H6KWqg+wfSex0oR6JjCDS/aQ9qeo+c488iIL+wgFY9y8k2A/FvFklZksRwFJ7AhrnBWx28I
 xBQ=
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="45573013"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Aug 2019 01:14:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 26 Aug 2019 01:14:41 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 26 Aug 2019 01:14:39 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <allan.nielsen@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 0/3] Add NETIF_F_HW_BR_CAP feature
Date:   Mon, 26 Aug 2019 10:11:12 +0200
Message-ID: <1566807075-775-1-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a network port is added to a bridge then the port is added in
promisc mode. Some HW that has bridge capabilities(can learn, forward,
flood etc the frames) they are disabling promisc mode in the network
driver when the port is added to the SW bridge.

This patch adds the feature NETIF_F_HW_BR_CAP so that the network ports
that have this feature will not be set in promisc mode when they are
added to a SW bridge.

In this way the HW that has bridge capabilities don't need to send all the
traffic to the CPU and can also implement the promisc mode and toggle it
using the command 'ip link set dev swp promisc on'

v1 -> v2
  - rename feature to NETIF_F_HW_BR_CAP
  - add better description in the commit message and in the code
  - remove the check that all network driver have same netdev_ops and
    just check for the feature NETIF_F_HW_BR_CAP when setting the network
    port in promisc mode.


Horatiu Vultur (3):
  net: Add NETIF_HW_BR_CAP feature
  net: mscc: Use NETIF_F_HW_BR_CAP
  net: mscc: Implement promisc mode.

 drivers/net/ethernet/mscc/ocelot.c | 26 ++++++++++++++++++++++++--
 include/linux/netdev_features.h    |  6 ++++++
 net/bridge/br_if.c                 | 11 ++++++++++-
 net/core/ethtool.c                 |  1 +
 4 files changed, 41 insertions(+), 3 deletions(-)

-- 
2.7.4

