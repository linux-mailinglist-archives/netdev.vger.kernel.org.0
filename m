Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C7E1B0006
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgDTCv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:51:56 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55732 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgDTCvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:51:15 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BBF541A0638;
        Mon, 20 Apr 2020 04:51:13 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CFBB31A061B;
        Mon, 20 Apr 2020 04:51:08 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 5D8D3402D8;
        Mon, 20 Apr 2020 10:51:02 +0800 (SGT)
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
Subject: [v3, 2/7] net: mscc: ocelot: fix timestamp info if ptp clock does not work
Date:   Mon, 20 Apr 2020 10:46:46 +0800
Message-Id: <20200420024651.47353-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420024651.47353-1-yangbo.lu@nxp.com>
References: <20200420024651.47353-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timestamp info should be only software timestamp capabilities
if ptp clock does not work.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
Changes for v3:
	- None.
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6cfd6dc..bd6692a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1346,6 +1346,12 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 {
 	info->phc_index = ocelot->ptp_clock ?
 			  ptp_clock_index(ocelot->ptp_clock) : -1;
+	if (info->phc_index == -1) {
+		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+					 SOF_TIMESTAMPING_RX_SOFTWARE |
+					 SOF_TIMESTAMPING_SOFTWARE;
+		return 0;
+	}
 	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
 				 SOF_TIMESTAMPING_RX_SOFTWARE |
 				 SOF_TIMESTAMPING_SOFTWARE |
-- 
2.7.4

