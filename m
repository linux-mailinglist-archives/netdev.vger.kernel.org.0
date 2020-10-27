Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D4E29C933
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1830507AbgJ0TrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:47:13 -0400
Received: from mailout11.rmx.de ([94.199.88.76]:43422 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506943AbgJ0TrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 15:47:12 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4CLMff6G64z43sx;
        Tue, 27 Oct 2020 20:47:06 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CLMf80tPcz2TTJr;
        Tue, 27 Oct 2020 20:46:40 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.166) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 27 Oct
 2020 20:46:39 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: dsa: microchip: fix race condition
Date:   Tue, 27 Oct 2020 20:45:34 +0100
Message-ID: <20201027194534.23600-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.166]
X-RMX-ID: 20201027-204640-4CLMf80tPcz2TTJr-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 8098bd69bc4e925070313b1b95d03510f4f24738 ]

Between queuing the delayed work and finishing the setup of the dsa
ports, the process may sleep in request_module() (via
phy_device_create()) and the queued work may be executed prior to the
switch net devices being registered. In ksz_mib_read_work(), a NULL
dereference will happen within netof_carrier_ok(dp->slave).

Not queuing the delayed work in ksz_init_mib_timer() makes things even
worse because the work will now be queued for immediate execution
(instead of 2000 ms) in ksz_mac_link_down() via
dsa_port_link_register_of().

Call tree:
ksz9477_i2c_probe()
\--ksz9477_switch_register()
   \--ksz_switch_register()
      +--dsa_register_switch()
      |  \--dsa_switch_probe()
      |     \--dsa_tree_setup()
      |        \--dsa_tree_setup_switches()
      |           +--dsa_switch_setup()
      |           |  +--ksz9477_setup()
      |           |  |  \--ksz_init_mib_timer()
      |           |  |     |--/* Start the timer 2 seconds later. */
      |           |  |     \--schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
      |           |  \--__mdiobus_register()
      |           |     \--mdiobus_scan()
      |           |        \--get_phy_device()
      |           |           +--get_phy_id()
      |           |           \--phy_device_create()
      |           |              |--/* sleeping, ksz_mib_read_work() can be called meanwhile */
      |           |              \--request_module()
      |           |
      |           \--dsa_port_setup()
      |              +--/* Called for non-CPU ports */
      |              +--dsa_slave_create()
      |              |  +--/* Too late, ksz_mib_read_work() may be called beforehand */
      |              |  \--port->slave = ...
      |             ...
      |              +--Called for CPU port */
      |              \--dsa_port_link_register_of()
      |                 \--ksz_mac_link_down()
      |                    +--/* mib_read must be initialized here */
      |                    +--/* work is already scheduled, so it will be executed after 2000 ms */
      |                    \--schedule_delayed_work(&dev->mib_read, 0);
      \-- /* here port->slave is setup properly, scheduling the delayed work should be safe */

Solution:
1. Do not queue (only initialize) delayed work in ksz_init_mib_timer().
2. Only queue delayed work in ksz_mac_link_down() if init is completed.
3. Queue work once in ksz_switch_register(), after dsa_register_switch()
has completed.

Fixes: 7c6ff470aa86 ("net: dsa: microchip: add MIB counter reading support")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
This is a back port for 5.4. The original version has been applied to 5.8/5.9
a few hours ago.

Please decide whether the Reviewed-By: and Singed-off-by: tags shall be kept
or removed when forwarding this to stable.

regards
Christian

 drivers/net/dsa/microchip/ksz_common.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7fabc0e3d807..b1a9d1012fc4 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -107,18 +107,11 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 {
 	int i;
 
-	/* Read MIB counters every 30 seconds to avoid overflow. */
-	dev->mib_read_interval = msecs_to_jiffies(30000);
-
 	INIT_WORK(&dev->mib_read, ksz_mib_read_work);
 	timer_setup(&dev->mib_read_timer, mib_monitor, 0);
 
 	for (i = 0; i < dev->mib_port_cnt; i++)
 		dev->dev_ops->port_init_cnt(dev, i);
-
-	/* Start the timer 2 seconds later. */
-	dev->mib_read_timer.expires = jiffies + msecs_to_jiffies(2000);
-	add_timer(&dev->mib_read_timer);
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
@@ -152,7 +145,9 @@ void ksz_adjust_link(struct dsa_switch *ds, int port,
 	/* Read all MIB counters when the link is going down. */
 	if (!phydev->link) {
 		p->read = true;
-		schedule_work(&dev->mib_read);
+		/* timer started */
+		if (dev->mib_read_interval)
+			schedule_work(&dev->mib_read);
 	}
 	mutex_lock(&dev->dev_mutex);
 	if (!phydev->link)
@@ -464,6 +459,13 @@ int ksz_switch_register(struct ksz_device *dev,
 		return ret;
 	}
 
+	/* Read MIB counters every 30 seconds to avoid overflow. */
+	dev->mib_read_interval = msecs_to_jiffies(30000);
+
+	/* Start the MIB timer. */
+	dev->mib_read_timer.expires = jiffies;
+	add_timer(&dev->mib_read_timer);
+
 	return 0;
 }
 EXPORT_SYMBOL(ksz_switch_register);
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

