Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427D1284FE5
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgJFQc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:32:28 -0400
Received: from mailout11.rmx.de ([94.199.88.76]:46310 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgJFQc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 12:32:28 -0400
X-Greylist: delayed 2081 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2020 12:32:26 EDT
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4C5MYf2Zy0z3yRh;
        Tue,  6 Oct 2020 17:57:42 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4C5MXs40cLz2xcJ;
        Tue,  6 Oct 2020 17:57:01 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.45) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Oct
 2020 17:57:01 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [net v2] net: dsa: microchip: fix race condition
Date:   Tue, 6 Oct 2020 17:56:51 +0200
Message-ID: <20201006155651.21473-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.45]
X-RMX-ID: 20201006-175701-4C5MXs40cLz2xcJ-0@kdin01
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

Fixes: 7c6ff470aa ("net: dsa: microchip: add MIB counter reading support")
Signed-off-by: Christian Eggers <ceggers@arri.de>
---
v2:
---------
- no changes in the patch itself
- use correct subject-prefix
- changed wording of commit description
- added call tree to commit description
- added "Fixes:" tag


On Monday, 5 October 2020, 22:55:44 CEST, Vladimir Oltean wrote:
> On Mon, Oct 05, 2020 at 06:08:29PM +0200, Christian Eggers wrote:
> [...]
> Read this for more details
> https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
Thank for pointing this out.

> FYI, you haven't even addressed the root cause of the problem, which is
> ksz_mib_read_work sticking its nose where it's not supposed to:
> 
> 		/* Only read MIB counters when the port is told to do.
> 		 * If not, read only dropped counters when link is not up.
> 		 */
> 		if (!p->read) {
> 			const struct dsa_port *dp = dsa_to_port(dev->ds, i);
> 
> 			if (!netif_carrier_ok(dp->slave))
> 				mib->cnt_ptr = dev->reg_mib_cnt;
> 		}
> 
> This is simply Not Ok.
> Not only the dp->slave is on purpose registered outside of the driver's
> control (as you came to find out yourself), but not even all ports are
> user ports. For example, the CPU port doesn't have a valid struct
> net_device *slave pointer. You are just lucky that it's defined like
> this:
> 
> struct dsa_port {
> 	/* A CPU port is physically connected to a master device.
> 	 * A user port exposed to userspace has a slave device.
> 	 */
> 	union {
> 		struct net_device *master;
> 		struct net_device *slave;
> 	};
> 
> so the code is in fact checking the status of the master interface's link.
> But DSA doesn't assume that the *master and *slave pointers are under a
> union. That can change any day, and when it changes, the KSZ driver will
> break.
Calling dsa_is_user_port() before calling netif_carrier_ok() could improve the
situation a little bit...

		/* Only read MIB counters when the port is told to do.
		 * If not, read only dropped counters when link is not up.
		 */
port_r_cnt() is called independently of p->read and netif_carrier_ok()... What
is correct here (comment or code)?

> My personal feeling is that this driver hides a landmine beneath every
> line of code, and it isn't getting better.
https://github.com/Microchip-Ethernet/EVB-KSZ9477 ...

> Sure, you should absolutely add the call stack to the commit message,
> but how many people are going to git blame so they can see it. The code
> needs to be obviously correct.
> 
> Things like needing to check dev->mib_read_interval as an indication
> whether the race between ksz_mac_link_down and ksz_switch_register is
> over are exactly the type of things that make it not fun to follow.
I needed some amount of time to understand the segfault and to draw the
call stack...

> If reading MIB counters for ports that are down is such a "waste of time"
> as per commit 7c6ff470aa867f53b8522a3a5c84c36ac7a20090, then how about
> scheduling the delayed work from .phylink_mac_link_up, and canceling it
> from .phylink_mac_link_down? Either that, or set a boolean variable to
> struct ksz_port p->link_up, to true or false respectively from the
> phylink callbacks, and using that as an indication whether to read the
> MIB counters or not, instead of accessing the potentially invalid
> dp->slave pointer? Would that work?
I am definitely not an expert for this driver. For starting/stopping the
delayed work on demand, a separate work struct for each port could be useful.
In this case, struct ksz_port would need a pointer to the ksz_device struct,
as the ports are allocated seperately and container_of() cannot be used.

Using a bool variable has the property, that reading the MIB will not be
performed "immediately" after phylink_mac_down(). But if I am correct, this
is also not the case today as the work is typically already queued when
ksz_mac_link_down() is executed.

- First call of ksz_mac_link_down:
Work is already queued (prior this patch) or will not be queued (after this
patch).

- Further calls:
Work is already queued (it requeues itself).

Result (please verify):
- Not scheduling the work in ksz_mac_link_down() won't change anything.
- Checking for mib_read_interval in ksz_switch_remove() can be obmitted,
  as the condition is always true when ksz_switch_remove() is called.

> Sorry for rambling. I realize that there aren't probably a lot of things
> you can do better to fix this problem for stable, but maybe you could
> take some time and clean it up a little bit?
My original intention is to upstream the PTP functionality I have developed. I
hope that I can get this into without cleaning up the whole driver...

If you can confirm that checking mib_read_interval is not necessary in
ksz_switch_remove() and that scheduling the work in ksz_mac_link_down() makes
no sense, I can either extend this patch or create a follup up patch.

Best regards
Christian

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

