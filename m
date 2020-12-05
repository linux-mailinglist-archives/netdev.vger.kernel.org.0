Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BE82CFFD2
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgLEXtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:49:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbgLEXtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 18:49:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607212105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=a1PudfXRCgPMhbqFZGLxWf1rDDLL53Jdzs7mpITq/dY=;
        b=f2m05gobShKyplQXap4m6ha/VOPEhQpdHy4CfLfQ22vSNCLsIb7WgCoombIYFvQFI5YVph
        TQ88bdikfgj06v6XXnYg2+Ld1dzH9wJ7L3mg0VuDBDdXgHD5IRHVPtr9x58U/2g/DCTJmU
        vpHiY1K5j5DPeLZcgkoMcRH8ajTjn+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-kyyuhHobNEG5Q9Wz7ZQPUA-1; Sat, 05 Dec 2020 18:48:21 -0500
X-MC-Unique: kyyuhHobNEG5Q9Wz7ZQPUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C95B45185;
        Sat,  5 Dec 2020 23:48:19 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FBAD5D6D5;
        Sat,  5 Dec 2020 23:48:15 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net] bonding: reduce rtnl lock contention in mii monitor thread
Date:   Sat,  5 Dec 2020 18:43:54 -0500
Message-Id: <20201205234354.1710-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm seeing a system get stuck unable to bring a downed interface back up
when it's got an updelay value set, behavior which ceased when logging
spew was removed from bond_miimon_inspect(). I'm monitoring logs on this
system over another network connection, and it seems that the act of
spewing logs at all there increases rtnl lock contention, because
instrumented code showed bond_mii_monitor() never able to succeed in it's
attempts to call rtnl_trylock() to actually commit link state changes,
leaving the downed link stuck in BOND_LINK_DOWN. The system in question
appears to be fine with the log spew being moved to
bond_commit_link_state(), which is called after the successful
rtnl_trylock(). I'm actually wondering if perhaps we ultimately need/want
some bond-specific lock here to prevent racing with bond_close() instead
of using rtnl, but this shift of the output appears to work. I believe
this started happening when de77ecd4ef02 ("bonding: improve link-status
update in mii-monitoring") went in, but I'm not 100% on that.

The addition of a case BOND_LINK_BACK in bond_miimon_inspect() is somewhat
separate from the fix for the actual hang, but it eliminates a constant
"invalid new link 3 on slave" message seen related to this issue, and it's
not actually an invalid state here, so we shouldn't be reporting it as an
error.

CC: Mahesh Bandewar <maheshb@google.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Thomas Davis <tadavis@lbl.gov>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 26 ++++++----------------
 include/net/bonding.h           | 38 +++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 47afc5938c26..cdb6c64f16b6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2292,23 +2292,13 @@ static int bond_miimon_inspect(struct bonding *bond)
 			bond_propose_link_state(slave, BOND_LINK_FAIL);
 			commit++;
 			slave->delay = bond->params.downdelay;
-			if (slave->delay) {
-				slave_info(bond->dev, slave->dev, "link status down for %sinterface, disabling it in %d ms\n",
-					   (BOND_MODE(bond) ==
-					    BOND_MODE_ACTIVEBACKUP) ?
-					    (bond_is_active_slave(slave) ?
-					     "active " : "backup ") : "",
-					   bond->params.downdelay * bond->params.miimon);
-			}
+
 			fallthrough;
 		case BOND_LINK_FAIL:
 			if (link_state) {
 				/* recovered before downdelay expired */
 				bond_propose_link_state(slave, BOND_LINK_UP);
 				slave->last_link_up = jiffies;
-				slave_info(bond->dev, slave->dev, "link status up again after %d ms\n",
-					   (bond->params.downdelay - slave->delay) *
-					   bond->params.miimon);
 				commit++;
 				continue;
 			}
@@ -2330,19 +2320,10 @@ static int bond_miimon_inspect(struct bonding *bond)
 			commit++;
 			slave->delay = bond->params.updelay;
 
-			if (slave->delay) {
-				slave_info(bond->dev, slave->dev, "link status up, enabling it in %d ms\n",
-					   ignore_updelay ? 0 :
-					   bond->params.updelay *
-					   bond->params.miimon);
-			}
 			fallthrough;
 		case BOND_LINK_BACK:
 			if (!link_state) {
 				bond_propose_link_state(slave, BOND_LINK_DOWN);
-				slave_info(bond->dev, slave->dev, "link status down again after %d ms\n",
-					   (bond->params.updelay - slave->delay) *
-					   bond->params.miimon);
 				commit++;
 				continue;
 			}
@@ -2456,6 +2437,11 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			continue;
 
+		case BOND_LINK_BACK:
+			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
+
+			continue;
+
 		default:
 			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
 				  slave->link_new_state);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index adc3da776970..6a09de9a3f03 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -558,10 +558,48 @@ static inline void bond_propose_link_state(struct slave *slave, int state)
 
 static inline void bond_commit_link_state(struct slave *slave, bool notify)
 {
+	struct bonding *bond = slave->bond;
+
 	if (slave->link_new_state == BOND_LINK_NOCHANGE)
 		return;
 
+	if (slave->link == slave->link_new_state)
+		return;
+
 	slave->link = slave->link_new_state;
+
+	switch(slave->link) {
+	case BOND_LINK_UP:
+		slave_info(bond->dev, slave->dev, "link status up again after %d ms\n",
+			   (bond->params.downdelay - slave->delay) *
+			   bond->params.miimon);
+		break;
+
+	case BOND_LINK_FAIL:
+		if (slave->delay) {
+			slave_info(bond->dev, slave->dev, "link status down for %sinterface, disabling it in %d ms\n",
+				   (BOND_MODE(bond) ==
+				    BOND_MODE_ACTIVEBACKUP) ?
+				    (bond_is_active_slave(slave) ?
+				     "active " : "backup ") : "",
+				   bond->params.downdelay * bond->params.miimon);
+		}
+		break;
+
+	case BOND_LINK_DOWN:
+		slave_info(bond->dev, slave->dev, "link status down again after %d ms\n",
+			   (bond->params.updelay - slave->delay) *
+			   bond->params.miimon);
+		break;
+
+	case BOND_LINK_BACK:
+		if (slave->delay) {
+			slave_info(bond->dev, slave->dev, "link status up, enabling it in %d ms\n",
+				   bond->params.updelay * bond->params.miimon);
+		}
+		break;
+	}
+
 	if (notify) {
 		bond_queue_slave_event(slave);
 		bond_lower_state_changed(slave);
-- 
2.28.0

