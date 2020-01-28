Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EFE14B8A3
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 15:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733096AbgA1OZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 09:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbgA1OZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BC3224686;
        Tue, 28 Jan 2020 14:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221552;
        bh=N53L2593G9AItP5Hfi5f6AE/8lIDgtBvs63EpGa8FJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQT6KO8YfrkCE3fqpJLz480OFcjDxuk8e5gt99WfhlLXrmnUpRNoNhymUTVrbKhUs
         C/b6O3Ll3SCixCG2EHLG6CXvwkA47KnPhkRWp/uq2i7XTBhwugmIbI0KoB/byEAoKa
         QgBRCbwUEJBsa0AMRtQtyHCBBLl/r0N09FfidYiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Tyler Hall <tylerwhall@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller@googlegroups.com
Subject: [PATCH 4.9 234/271] can, slip: Protect tty->disc_data in write_wakeup and close with RCU
Date:   Tue, 28 Jan 2020 15:06:23 +0100
Message-Id: <20200128135909.978871848@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Palethorpe <rpalethorpe@suse.com>

[ Upstream commit 0ace17d56824165c7f4c68785d6b58971db954dd ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/slcan.c |   12 ++++++++++--
 drivers/net/slip/slip.c |   12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -344,9 +344,16 @@ static void slcan_transmit(struct work_s
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
@@ -887,10 +894,11 @@ static void slip_close(struct tty_struct
 		return;
 
 	spin_lock_bh(&sl->lock);
-	tty->disc_data = NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);
 
+	synchronize_rcu();
 	flush_work(&sl->tx_work);
 
 	/* VSV = very important to remove timers */


