Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40ED143E62
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgAUNnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:43:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:47976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729098AbgAUNnf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 08:43:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 415FEAE85;
        Tue, 21 Jan 2020 13:43:32 +0000 (UTC)
From:   Richard Palethorpe <rpalethorpe@suse.com>
To:     linux-can@vger.kernel.org
Cc:     Richard Palethorpe <rpalethorpe@suse.com>,
        syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Tyler Hall <tylerwhall@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Subject: [PATCH v3] can, slip: Protect tty->disc_data in write_wakeup and close with RCU
Date:   Tue, 21 Jan 2020 14:42:58 +0100
Message-Id: <20200121134258.18013-1-rpalethorpe@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

V2: Added proper RCU grace period
V3: Changed commit description

This patch creates a Sparse warning concerning the RCU address space. I'm not
sure what to do about that.

 drivers/net/can/slcan.c | 12 ++++++++++--
 drivers/net/slip/slip.c | 12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 2e57122f02fb..2f5c287eac95 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -344,9 +344,16 @@ static void slcan_transmit(struct work_struct *work)
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
@@ -644,10 +651,11 @@ static void slcan_close(struct tty_struct *tty)
 		return;
 
 	spin_lock_bh(&sl->lock);
-	tty->disc_data = NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);
 
+	synchronize_rcu();
 	flush_work(&sl->tx_work);
 
 	/* Flush network side */
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 2a91c192659f..61d7e0d1d77d 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -452,9 +452,16 @@ static void slip_transmit(struct work_struct *work)
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
@@ -882,10 +889,11 @@ static void slip_close(struct tty_struct *tty)
 		return;
 
 	spin_lock_bh(&sl->lock);
-	tty->disc_data = NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);
 
+	synchronize_rcu();
 	flush_work(&sl->tx_work);
 
 	/* VSV = very important to remove timers */
-- 
2.24.0

