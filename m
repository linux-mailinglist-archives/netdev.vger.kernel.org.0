Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1EA28B078
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgJLIkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:40:47 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:45275 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgJLIkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 04:40:47 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4C8sZf6d8Kz9w5W;
        Mon, 12 Oct 2020 10:40:42 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C8sYr09HTz2TSDs;
        Mon, 12 Oct 2020 10:40:00 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.150) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 12 Oct
 2020 10:39:59 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        George McCollister <george.mccollister@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: [net v4] net: dsa: microchip: fix race condition
Date:   Mon, 12 Oct 2020 10:39:42 +0200
Message-ID: <20201012083942.12722-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.150]
X-RMX-ID: 20201012-104000-4C8sYr09HTz2TSDs-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
On Friday, 9 October 2020, 22:04:42 CEST, Jakub Kicinski wrote:
> Your patch seems fine, but I wonder what was the original author trying
> to achieve with this schedule_delayed_work(..., 0) call?
> 
> The work is supposed to be scheduled at this point, right?
> In that case another call to schedule_delayed_work() is
> simply ignored.
I came to the same conclusion...

> Judging by the comment it seems like someone was under the impression
> this will reschedule the work to be run immediately, which is not the
> case.
> 
> In fact looks like a separate bug introduced in:
> 
> 469b390e1ba3 ("net: dsa: microchip: use delayed_work instead of timer + work")
Seems so. Before that change, the "work" was only queued after timer expiry, so
it could be scheduled for "soon" execution when the link is going down. After
that change, the work is always queued as "delayed work", so scheduling when the
the link goes down has no effect.

@George: Can you write a fix for this?


v4:
---------
- Added Reviewed-by: tags from Florian, Vladimir and Jakub

v3:
---------
- Use 12 digts for commit id in "Fixes:" tag

v2:
---------
- no changes in the patch itself
- use correct subject-prefix
- changed wording of commit description
- added call tree to commit description
- added "Fixes:" tag

 drivers/net/dsa/microchip/ksz_common.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 01f5784f69cb..0ef854911f21 100644
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
 
@@ -451,6 +447,12 @@ int ksz_switch_register(struct ksz_device *dev,
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

