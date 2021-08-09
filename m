Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616F13E496F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 18:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhHIQHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 12:07:13 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34772 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhHIQHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 12:07:12 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 179G6fVI022669;
        Mon, 9 Aug 2021 18:06:41 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net] net: linkwatch: fix failure to restore device state across suspend/resume
Date:   Mon,  9 Aug 2021 18:06:28 +0200
Message-Id: <20210809160628.22623-1-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After migrating my laptop from 4.19-LTS to 5.4-LTS a while ago I noticed
that my Ethernet port to which a bond and a VLAN interface are attached
appeared to remain up after resuming from suspend with the cable unplugged
(and that problem still persists with 5.10-LTS).

It happens that the following happens:

  - the network driver (e1000e here) prepares to suspend, calls e1000e_down()
    which calls netif_carrier_off() to signal that the link is going down.
  - netif_carrier_off() adds a link_watch event to the list of events for
    this device
  - the device is completely stopped.
  - the machine suspends
  - the cable is unplugged and the machine brought to another location
  - the machine is resumed
  - the queued linkwatch events are processed for the device
  - the device doesn't yet have the __LINK_STATE_PRESENT bit and its events
    are silently dropped
  - the device is resumed with its link down
  - the upper VLAN and bond interfaces are never notified that the link had
    been turned down and remain up
  - the only way to provoke a change is to physically connect the machine
    to a port and possibly unplug it.

The state after resume looks like this:
  $ ip -br li | egrep 'bond|eth'
  bond0            UP             e8:6a:64:64:64:64 <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
  eth0             DOWN           e8:6a:64:64:64:64 <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP>
  eth0.2@eth0      UP             e8:6a:64:64:64:64 <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>

Placing an explicit call to netdev_state_change() either in the suspend
or the resume code in the NIC driver worked around this but the solution
is not satisfying.

The issue in fact really is in link_watch that loses events while it
ought not to. It happens that the test for the device being present was
added by commit 124eee3f6955 ("net: linkwatch: add check for netdevice
being present to linkwatch_do_dev") in 4.20 to avoid an access to
devices that are not present.

Instead of dropping events, this patch proceeds slightly differently by
postponing their handling so that they happen after the device is fully
resumed.

Fixes: 124eee3f6955 ("net: linkwatch: add check for netdevice being present to linkwatch_do_dev") 
Link: https://lists.openwall.net/netdev/2018/03/15/62
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---

Note: I've been wondering if instead we shouldn't simply teach
      netdev_state_change() not to call rtmsg_ifinfo() when the
      device is not present, since this is exactly the problem that
      Geert met in the discussion above and that was attempted to be
      addressed by Heiner's initial patch. At least this patch deals
      with the issue where it was introduced but I'm fine with
      modifying netdev_state_change() instead if that's preferred.


 net/core/link_watch.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 75431ca9300f..1a455847da54 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -158,7 +158,7 @@ static void linkwatch_do_dev(struct net_device *dev)
 	clear_bit(__LINK_STATE_LINKWATCH_PENDING, &dev->state);
 
 	rfc2863_policy(dev);
-	if (dev->flags & IFF_UP && netif_device_present(dev)) {
+	if (dev->flags & IFF_UP) {
 		if (netif_carrier_ok(dev))
 			dev_activate(dev);
 		else
@@ -204,7 +204,8 @@ static void __linkwatch_run_queue(int urgent_only)
 		dev = list_first_entry(&wrk, struct net_device, link_watch_list);
 		list_del_init(&dev->link_watch_list);
 
-		if (urgent_only && !linkwatch_urgent_event(dev)) {
+		if (!netif_device_present(dev) ||
+		    (urgent_only && !linkwatch_urgent_event(dev))) {
 			list_add_tail(&dev->link_watch_list, &lweventlist);
 			continue;
 		}
-- 
2.28.0

