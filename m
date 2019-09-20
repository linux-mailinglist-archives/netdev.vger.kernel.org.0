Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9E4B926E
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 16:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390896AbfITOcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 10:32:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36498 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388283AbfITOZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 10:25:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqN-000514-G2; Fri, 20 Sep 2019 15:25:07 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0007wH-CX; Fri, 20 Sep 2019 15:25:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Veaceslav Falico" <vfalico@gmail.com>,
        "Jarod Wilson" <jarod@redhat.com>,
        "Jay Vosburgh" <j.vosburgh@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        "Jay Vosburgh" <jay.vosburgh@canonical.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.519584410@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 095/132] bonding: fix arp_validate toggling in
 active-backup mode
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit a9b8a2b39ce65df45687cf9ef648885c2a99fe75 upstream.

There's currently a problem with toggling arp_validate on and off with an
active-backup bond. At the moment, you can start up a bond, like so:

modprobe bonding mode=1 arp_interval=100 arp_validate=0 arp_ip_targets=192.168.1.1
ip link set bond0 down
echo "ens4f0" > /sys/class/net/bond0/bonding/slaves
echo "ens4f1" > /sys/class/net/bond0/bonding/slaves
ip link set bond0 up
ip addr add 192.168.1.2/24 dev bond0

Pings to 192.168.1.1 work just fine. Now turn on arp_validate:

echo 1 > /sys/class/net/bond0/bonding/arp_validate

Pings to 192.168.1.1 continue to work just fine. Now when you go to turn
arp_validate off again, the link falls flat on it's face:

echo 0 > /sys/class/net/bond0/bonding/arp_validate
dmesg
...
[133191.911987] bond0: Setting arp_validate to none (0)
[133194.257793] bond0: bond_should_notify_peers: slave ens4f0
[133194.258031] bond0: link status definitely down for interface ens4f0, disabling it
[133194.259000] bond0: making interface ens4f1 the new active one
[133197.330130] bond0: link status definitely down for interface ens4f1, disabling it
[133197.331191] bond0: now running without any active interface!

The problem lies in bond_options.c, where passing in arp_validate=0
results in bond->recv_probe getting set to NULL. This flies directly in
the face of commit 3fe68df97c7f, which says we need to set recv_probe =
bond_arp_recv, even if we're not using arp_validate. Said commit fixed
this in bond_option_arp_interval_set, but missed that we can get to that
same state in bond_option_arp_validate_set as well.

One solution would be to universally set recv_probe = bond_arp_recv here
as well, but I don't think bond_option_arp_validate_set has any business
touching recv_probe at all, and that should be left to the arp_interval
code, so we can just make things much tidier here.

Fixes: 3fe68df97c7f ("bonding: always set recv_probe to bond_arp_rcv in arp monitor")
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_options.c | 7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1068,13 +1068,6 @@ static int bond_option_arp_validate_set(
 {
 	pr_info("%s: Setting arp_validate to %s (%llu)\n",
 		bond->dev->name, newval->string, newval->value);
-
-	if (bond->dev->flags & IFF_UP) {
-		if (!newval->value)
-			bond->recv_probe = NULL;
-		else if (bond->params.arp_interval)
-			bond->recv_probe = bond_arp_rcv;
-	}
 	bond->params.arp_validate = newval->value;
 
 	return 0;

