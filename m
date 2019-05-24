Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B3B2993F
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403875AbfEXNt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:49:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403809AbfEXNt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:49:56 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B8E230BB546;
        Fri, 24 May 2019 13:49:50 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32B3A7D67C;
        Fri, 24 May 2019 13:49:44 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Heesoon Kim <Heesoon.Kim@stratus.com>
Subject: [PATCH net] bonding/802.3ad: fix slave link initialization transition states
Date:   Fri, 24 May 2019 09:49:28 -0400
Message-Id: <20190524134928.16834-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 24 May 2019 13:49:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once in a while, with just the right timing, 802.3ad slaves will fail to
properly initialize, winding up in a weird state, with a partner system
mac address of 00:00:00:00:00:00. This started happening after a fix to
properly track link_failure_count tracking, where an 802.3ad slave that
reported itself as link up in the miimon code, but wasn't able to get a
valid speed/duplex, started getting set to BOND_LINK_FAIL instead of
BOND_LINK_DOWN. That was the proper thing to do for the general "my link
went down" case, but has created a link initialization race that can put
the interface in this odd state.

The simple fix is to instead set the slave link to BOND_LINK_DOWN again,
if the link has never been up (last_link_up == 0), so the link state
doesn't bounce from BOND_LINK_DOWN to BOND_LINK_FAIL -- it hasn't failed
in this case, it simply hasn't been up yet, and this prevents the
unnecessary state change from DOWN to FAIL and getting stuck in an init
failure w/o a partner mac.

Fixes: ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Tested-by: Heesoon Kim <Heesoon.Kim@stratus.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 062fa7e3af4c..407f4095a37a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3122,13 +3122,18 @@ static int bond_slave_netdev_event(unsigned long event,
 	case NETDEV_CHANGE:
 		/* For 802.3ad mode only:
 		 * Getting invalid Speed/Duplex values here will put slave
-		 * in weird state. So mark it as link-fail for the time
-		 * being and let link-monitoring (miimon) set it right when
-		 * correct speeds/duplex are available.
+		 * in weird state. Mark it as link-fail if the link was
+		 * previously up or link-down if it hasn't yet come up, and
+		 * let link-monitoring (miimon) set it right when correct
+		 * speeds/duplex are available.
 		 */
 		if (bond_update_speed_duplex(slave) &&
-		    BOND_MODE(bond) == BOND_MODE_8023AD)
-			slave->link = BOND_LINK_FAIL;
+		    BOND_MODE(bond) == BOND_MODE_8023AD) {
+			if (slave->last_link_up)
+				slave->link = BOND_LINK_FAIL;
+			else
+				slave->link = BOND_LINK_DOWN;
+		}
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD)
 			bond_3ad_adapter_speed_duplex_changed(slave);
-- 
2.20.1

