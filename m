Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6604122EA16
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 12:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgG0KdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 06:33:08 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47618 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgG0KdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 06:33:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D1B62200879;
        Mon, 27 Jul 2020 12:33:06 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 16A7A200870;
        Mon, 27 Jul 2020 12:33:03 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 1EA1C40243;
        Mon, 27 Jul 2020 12:32:58 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        laurent brando <laurent.brando@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: [PATCH] net: mscc: ocelot: fix hardware timestamp dequeue logic
Date:   Mon, 27 Jul 2020 18:26:14 +0800
Message-Id: <20200727102614.24570-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: laurent brando <laurent.brando@nxp.com>

The next hw timestamp should be snapshoot to the read registers
only once the current timestamp has been read.
If none of the pending skbs matches the current HW timestamp
just gracefully flush the available timestamp by reading it.

Signed-off-by: laurent brando <laurent.brando@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e05a48c..82bde07 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -731,21 +731,21 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 
 		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
 
-		/* Next ts */
-		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
+		/* Get the h/w timestamp */
+		ocelot_get_hwtimestamp(ocelot, &ts);
 
 		if (unlikely(!skb_match))
 			continue;
 
-		/* Get the h/w timestamp */
-		ocelot_get_hwtimestamp(ocelot, &ts);
-
 		/* Set the timestamp into the skb */
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
 		skb_tstamp_tx(skb_match, &shhwtstamps);
 
 		dev_kfree_skb_any(skb_match);
+
+		/* Next ts */
+		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
 	}
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
-- 
2.7.4

