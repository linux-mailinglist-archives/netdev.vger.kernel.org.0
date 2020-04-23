Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAEB1B679E
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 01:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgDWXIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 19:08:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50980 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728666AbgDWXG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 19:06:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvc-0004n0-LE; Fri, 24 Apr 2020 00:06:44 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvY-00E6y9-63; Fri, 24 Apr 2020 00:06:40 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Richard Palethorpe" <rpalethorpe@suse.com>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        syzkaller@googlegroups.com, linux-can@vger.kernel.org,
        syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com,
        "Tyler Hall" <tylerwhall@gmail.com>
Date:   Fri, 24 Apr 2020 00:07:08 +0100
Message-ID: <lsq.1587683028.166259533@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 201/245] can, slip: Protect tty->disc_data in
 write_wakeup and close with RCU
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Palethorpe <rpalethorpe@suse.com>

commit 0ace17d56824165c7f4c68785d6b58971db954dd upstream.

write_wakeup can happen in parallel with close/hangup where tty->disc_data
is set to NULL and the netdevice is freed thus also freeing
disc_data. write_wakeup accesses disc_data so we must prevent close from
freeing the netdev while write_wakeup has a non-NULL view of
tty->disc_data.

We also need to make sure that accesses to disc_data are atomic. Which can
all be done with RCU.

This problem was found by Syzkaller on SLCAN, but the same issue is
reproducible with the SLIP line discipline using an LTP test based on the
Syzkaller reproducer.

A fix which didn't use RCU was posted by Hillf Danton.

Fixes: 661f7fda21b1 ("slip: Fix deadlock in write_wakeup")
Fixes: a8e83b17536a ("slcan: Port write_wakeup deadlock fix from slip")
Reported-by: syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com
Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tyler Hall <tylerwhall@gmail.com>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/slcan.c | 12 ++++++++++--
 drivers/net/slip/slip.c | 12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -346,9 +346,16 @@ static void slcan_transmit(struct work_s
  */
 static void slcan_write_wakeup(struct tty_struct *tty)
 {
-	struct slcan *sl = tty->disc_data;
+	struct slcan *sl;
+
+	rcu_read_lock();
+	sl = rcu_dereference(tty->disc_data);
+	if (!sl)
+		goto out;
 
 	schedule_work(&sl->tx_work);
+out:
+	rcu_read_unlock();
 }
 
 /* Send a can_frame to a TTY queue. */
@@ -640,10 +647,11 @@ static void slcan_close(struct tty_struc
 		return;
 
 	spin_lock_bh(&sl->lock);
-	tty->disc_data = NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);
 
+	synchronize_rcu();
 	flush_work(&sl->tx_work);
 
 	/* Flush network side */
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -452,9 +452,16 @@ static void slip_transmit(struct work_st
  */
 static void slip_write_wakeup(struct tty_struct *tty)
 {
-	struct slip *sl = tty->disc_data;
+	struct slip *sl;
+
+	rcu_read_lock();
+	sl = rcu_dereference(tty->disc_data);
+	if (!sl)
+		goto out;
 
 	schedule_work(&sl->tx_work);
+out:
+	rcu_read_unlock();
 }
 
 static void sl_tx_timeout(struct net_device *dev)
@@ -885,10 +892,11 @@ static void slip_close(struct tty_struct
 		return;
 
 	spin_lock_bh(&sl->lock);
-	tty->disc_data = NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);
 
+	synchronize_rcu();
 	flush_work(&sl->tx_work);
 
 	/* VSV = very important to remove timers */

