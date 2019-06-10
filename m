Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCE63B157
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388739AbfFJIzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:55:40 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:41471 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388727AbfFJIzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:55:38 -0400
X-Originating-IP: 90.88.159.246
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id C7707FF810;
        Mon, 10 Jun 2019 08:55:35 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        ymarkman@marvell.com, mw@semihalf.com
Subject: [PATCH net-next 2/3] net: mvpp2: Rename mvpp2_ethtool_counters to mvpp2_ethtool_mib_counters
Date:   Mon, 10 Jun 2019 10:55:28 +0200
Message-Id: <20190610085529.16803-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610085529.16803-1-maxime.chevallier@bootlin.com>
References: <20190610085529.16803-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we'll be adding support for other kind of internal counters, make
clear that the currently supported counters are the MIB counters.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ee653125194e..01380ccb2139 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1267,7 +1267,7 @@ static u64 mvpp2_read_count(struct mvpp2_port *port,
  * Hence, statistics gathered from userspace with ifconfig (software) and
  * ethtool (hardware) cannot be compared.
  */
-static const struct mvpp2_ethtool_counter mvpp2_ethtool_regs[] = {
+static const struct mvpp2_ethtool_counter mvpp2_ethtool_mib_regs[] = {
 	{ MVPP2_MIB_GOOD_OCTETS_RCVD, "good_octets_received", true },
 	{ MVPP2_MIB_BAD_OCTETS_RCVD, "bad_octets_received" },
 	{ MVPP2_MIB_CRC_ERRORS_SENT, "crc_errors_sent" },
@@ -1303,9 +1303,10 @@ static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
 	if (sset == ETH_SS_STATS) {
 		int i;
 
-		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_regs); i++)
+		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++)
 			strscpy(data + i * ETH_GSTRING_LEN,
-			        mvpp2_ethtool_regs[i].string, ETH_GSTRING_LEN);
+				mvpp2_ethtool_mib_regs[i].string,
+				ETH_GSTRING_LEN);
 	}
 }
 
@@ -1320,8 +1321,8 @@ static void mvpp2_gather_hw_statistics(struct work_struct *work)
 	mutex_lock(&port->gather_stats_lock);
 
 	pstats = port->ethtool_stats;
-	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_regs); i++)
-		*pstats++ += mvpp2_read_count(port, &mvpp2_ethtool_regs[i]);
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++)
+		*pstats++ += mvpp2_read_count(port, &mvpp2_ethtool_mib_regs[i]);
 
 	/* No need to read again the counters right after this function if it
 	 * was called asynchronously by the user (ie. use of ethtool).
@@ -1345,14 +1346,14 @@ static void mvpp2_ethtool_get_stats(struct net_device *dev,
 
 	mutex_lock(&port->gather_stats_lock);
 	memcpy(data, port->ethtool_stats,
-	       sizeof(u64) * ARRAY_SIZE(mvpp2_ethtool_regs));
+	       sizeof(u64) * ARRAY_SIZE(mvpp2_ethtool_mib_regs));
 	mutex_unlock(&port->gather_stats_lock);
 }
 
 static int mvpp2_ethtool_get_sset_count(struct net_device *dev, int sset)
 {
 	if (sset == ETH_SS_STATS)
-		return ARRAY_SIZE(mvpp2_ethtool_regs);
+		return ARRAY_SIZE(mvpp2_ethtool_mib_regs);
 
 	return -EOPNOTSUPP;
 }
@@ -4368,8 +4369,8 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 		goto err_free_percpu;
 
 	/* Read the GOP statistics to reset the hardware counters */
-	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_regs); i++)
-		mvpp2_read_count(port, &mvpp2_ethtool_regs[i]);
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++)
+		mvpp2_read_count(port, &mvpp2_ethtool_mib_regs[i]);
 
 	return 0;
 
@@ -5052,7 +5053,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	}
 
 	port->ethtool_stats = devm_kcalloc(&pdev->dev,
-					   ARRAY_SIZE(mvpp2_ethtool_regs),
+					   ARRAY_SIZE(mvpp2_ethtool_mib_regs),
 					   sizeof(u64), GFP_KERNEL);
 	if (!port->ethtool_stats) {
 		err = -ENOMEM;
-- 
2.20.1

