Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902DF283CDF
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgJEQxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:53:37 -0400
Received: from mailout05.rmx.de ([94.199.90.90]:55339 "EHLO mailout05.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgJEQxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 12:53:36 -0400
X-Greylist: delayed 2031 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2020 12:53:36 EDT
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout05.rmx.de (Postfix) with ESMTPS id 4C4m5Q41h0z9tlD;
        Mon,  5 Oct 2020 18:19:38 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4C4m455p7Dz2xG2;
        Mon,  5 Oct 2020 18:18:29 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.143) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 5 Oct
 2020 18:08:50 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        <stable@vger.kernel.org>
Subject: [PATCH] net: dsa: microchip: fix race condition
Date:   Mon, 5 Oct 2020 18:08:29 +0200
Message-ID: <20201005160829.5607-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.143]
X-RMX-ID: 20201005-181837-4C4m455p7Dz2xG2-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Between queuing the delayed work and finishing the setup of the dsa
ports, the process may sleep in request_module() and the queued work may
be executed prior the initialization of the DSA ports is finished. In
ksz_mib_read_work(), a NULL dereference will happen within
netof_carrier_ok(dp->slave).

Not queuing the delayed work in ksz_init_mib_timer() make things even
worse because the work will now be queued for immediate execution
(instead of 2000 ms) in ksz_mac_link_down() via
dsa_port_link_register_of().

Solution:
1. Do not queue (only initialize) delayed work in ksz_init_mib_timer().
2. Only queue delayed work in ksz_mac_link_down() if init is completed.
3. Queue work once in ksz_switch_register(), after dsa_register_switch()
has completed.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
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

static void ksz_mib_read_work()
\--netif_carrier_ok(dp->slave);  dp->slave has not been initialized yet


 drivers/net/dsa/microchip/ksz_common.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8e755b50c9c1..a94d2278b95c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -103,14 +103,8 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 
 	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
 
-	/* Read MIB counters every 30 seconds to avoid overflow. */
-	dev->mib_read_interval = msecs_to_jiffies(30000);
-
 	for (i = 0; i < dev->mib_port_cnt; i++)
 		dev->dev_ops->port_init_cnt(dev, i);
-
-	/* Start the timer 2 seconds later. */
-	schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
@@ -143,7 +137,9 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 
 	/* Read all MIB counters when the link is going down. */
 	p->read = true;
-	schedule_delayed_work(&dev->mib_read, 0);
+	/* timer started */
+	if (dev->mib_read_interval)
+		schedule_delayed_work(&dev->mib_read, 0);
 }
 EXPORT_SYMBOL_GPL(ksz_mac_link_down);
 
@@ -446,6 +442,12 @@ int ksz_switch_register(struct ksz_device *dev,
 		return ret;
 	}
 
+	/* Read MIB counters every 30 seconds to avoid overflow. */
+	dev->mib_read_interval = msecs_to_jiffies(30000);
+
+	/* Start the MIB timer. */
+	schedule_delayed_work(&dev->mib_read, 0);
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

