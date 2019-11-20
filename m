Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9794D1035EE
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfKTIXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:23:41 -0500
Received: from inva021.nxp.com ([92.121.34.21]:52214 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfKTIXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 03:23:41 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3B4C62002C2;
        Wed, 20 Nov 2019 09:23:39 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 41A7220087B;
        Wed, 20 Nov 2019 09:23:34 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 4E4D5402B3;
        Wed, 20 Nov 2019 16:23:28 +0800 (SGT)
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
Subject: [PATCH 1/5] net: mscc: ocelot: export ocelot_hwstamp_get/set functions
Date:   Wed, 20 Nov 2019 16:23:14 +0800
Message-Id: <20191120082318.3909-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120082318.3909-1-yangbo.lu@nxp.com>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export ocelot_hwstamp_get/set functions so that DSA driver
is able to reuse them.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 8 ++++----
 include/soc/mscc/ocelot.h          | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 90c46ba..7302724 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1049,15 +1049,14 @@ static int ocelot_get_port_parent_id(struct net_device *dev,
 	return 0;
 }
 
-static int ocelot_hwstamp_get(struct ocelot *ocelot, int port,
-			      struct ifreq *ifr)
+int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	return copy_to_user(ifr->ifr_data, &ocelot->hwtstamp_config,
 			    sizeof(ocelot->hwtstamp_config)) ? -EFAULT : 0;
 }
+EXPORT_SYMBOL(ocelot_hwstamp_get);
 
-static int ocelot_hwstamp_set(struct ocelot *ocelot, int port,
-			      struct ifreq *ifr)
+int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct hwtstamp_config cfg;
@@ -1120,6 +1119,7 @@ static int ocelot_hwstamp_set(struct ocelot *ocelot, int port,
 
 	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
 }
+EXPORT_SYMBOL(ocelot_hwstamp_set);
 
 static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index a836afe..2bac4bc 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -533,6 +533,8 @@ int ocelot_fdb_del(struct ocelot *ocelot, int port,
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged);
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
+int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
+int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts);
 
-- 
2.7.4

