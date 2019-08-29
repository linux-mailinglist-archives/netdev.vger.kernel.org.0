Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAB7A14CB
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfH2JYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:24:18 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:14951 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfH2JYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 05:24:18 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: mXFrx/vA6Ko1qlodqX8ZLmLuJVy2PyCGVgDX+f24Usps4NRsbkG3rrCbqrc4bg5pisGzJOFUJc
 wB8aQXizz/eblA9b5TjaQlQDd39nwIpisjD1B1mWyPRv70LiW7SZiKRF+B1X4tip6lJ1qFkCGF
 8Re7wfxRrh74KxnExC9piYf/qa67VoUAbrcRWST2PjFEyKAC1EvpWJSRULWQIq16RVUSbkCK8W
 9WWle63b+iLKG0Zf+gl7+azfzYgbphYv+sOBDU11DoCL+32zOPzHO/tIzWf3g6JHwQlkzRue/d
 gW4=
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="45437238"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2019 02:24:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 02:24:13 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 29 Aug 2019 02:24:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <andrew@lunn.ch>,
        <allan.nielsen@microchip.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v3 0/2] net: core: Notify on changes to dev->promiscuity
Date:   Thu, 29 Aug 2019 11:22:27 +0200
Message-ID: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the SWITCHDEV_ATTR_ID_PORT_PROMISCUITY switchdev notification type,
used to indicate whenever the dev promiscuity counter is changed.

HW that has bridge capabilities are not required to set their ports in
promisc mode when they are added to the bridge. But it is required to
enable promisc mode if a user space application requires it. Therefore
if the driver listens for events SWITCHDEV_ATTR_ID_PORT_PROMISCUITY and
NETDEV_CHANGEUPPER it is possible to deduce when to add/remove ports in
promisc mode.

v2->v3:
  - stop using feature NETIF_F_HW_BR_CAP
  - renmae subject from 'Add NETIF_F_BW_BR_CAP feature' because this
    feature is not used anymore.

v1->v2:
  - rename feature to NETIF_F_HW_BR_CAP
  - add better description in the commit message and in the code
  - remove the check that all network drivers have same netdev_ops and
    just check for the feature NETIF_F_HW_BR_CAP when setting the
    network port in promisc mode.

Horatiu Vultur (2):
  net: core: Notify on changes to dev->promiscuity.
  net: mscc: Implement promisc mode.

 drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++++++++++++++++++++++
 include/net/switchdev.h            |  1 +
 net/core/dev.c                     |  9 ++++++++
 3 files changed, 57 insertions(+)

-- 
2.7.4

