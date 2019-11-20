Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7D01035ED
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfKTIXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:23:41 -0500
Received: from inva020.nxp.com ([92.121.34.13]:42402 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfKTIXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 03:23:40 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9488F1A04CB;
        Wed, 20 Nov 2019 09:23:38 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 99C9E1A04AB;
        Wed, 20 Nov 2019 09:23:33 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 3DE53402B0;
        Wed, 20 Nov 2019 16:23:27 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 0/5] Support PTP clock and hardware timestamping for DSA Felix driver
Date:   Wed, 20 Nov 2019 16:23:13 +0800
Message-Id: <20191120082318.3909-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to support PTP clock and hardware timestamping
for DSA Felix driver. Some functions in ocelot.c/ocelot_board.c
driver were reworked/exported, so that DSA Felix driver was able
to reuse them as much as possible.

On TX path, timestamping works on packet which requires timestamp.
The injection header will be configured accordingly, and skb clone
requires timestamp will be added into a list. The TX timestamp
is final handled in threaded interrupt handler when PTP timestamp
FIFO is ready.
On RX path, timestamping is always working. The RX timestamp could
be got from extraction header.

Yangbo Lu (5):
  net: mscc: ocelot: export ocelot_hwstamp_get/set functions
  net: mscc: ocelot: convert to use ocelot_get_txtstamp()
  net: mscc: ocelot: convert to use ocelot_port_add_txtstamp_skb()
  net: dsa: ocelot: define PTP registers for felix_vsc9959
  net: dsa: ocelot: add hardware timestamping support for Felix

 drivers/net/dsa/ocelot/felix.c           |  89 ++++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  16 +++++
 drivers/net/ethernet/mscc/ocelot.c       | 113 +++++++++++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot.h       |   6 --
 drivers/net/ethernet/mscc/ocelot_board.c |  53 +--------------
 include/soc/mscc/ocelot.h                |  13 +++-
 net/dsa/tag_ocelot.c                     |  14 +++-
 7 files changed, 222 insertions(+), 82 deletions(-)

-- 
2.7.4

