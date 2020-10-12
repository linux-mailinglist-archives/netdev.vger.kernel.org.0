Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBB828C0FC
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391513AbgJLTIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390538AbgJLTD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A99121D81;
        Mon, 12 Oct 2020 19:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529399;
        bh=JQk9h3h9g5Z2q4+DRb0eVAnSni57HGAYJ/n3yo2fWJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SNF0MzWw6e+oGfunDJ0+vaK7RFeAeDXDJJIAf8e+I0dETbabVMm2sT7n22JximD8
         6U6samChtHoagD7J3UEo+LDjxq1utTJ/XA0jqOq4sM0zYgM9qC6HbTJps4/LOVGeNd
         oyfG9C0VBwMygVWRLp7s5jV1f3ztPcgwfWIiL4VE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/15] drivers/net/wan/x25_asy: Correct the ndo_open and ndo_stop functions
Date:   Mon, 12 Oct 2020 15:03:01 -0400
Message-Id: <20201012190313.3279397-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190313.3279397-1-sashal@kernel.org>
References: <20201012190313.3279397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit ed46cd1d4cc4b2cf05f31fe25fc68d1a9d3589ba ]

1.
Move the lapb_register/lapb_unregister calls into the ndo_open/ndo_stop
functions.
This makes the LAPB protocol start/stop when the network interface
starts/stops. When the network interface is down, the LAPB protocol
shouldn't be running and the LAPB module shoudn't be generating control
frames.

2.
Move netif_start_queue/netif_stop_queue into the ndo_open/ndo_stop
functions.
This makes the TX queue start/stop when the network interface
starts/stops.
(netif_stop_queue was originally in the ndo_stop function. But to make
the code look better, I created a new function to use as ndo_stop, and
made it call the original ndo_stop function. I moved netif_stop_queue
from the original ndo_stop function to the new ndo_stop function.)

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/x25_asy.c | 43 +++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index cdcc380b4c268..80090fdab98a0 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -456,7 +456,6 @@ static int x25_asy_open(struct net_device *dev)
 {
 	struct x25_asy *sl = netdev_priv(dev);
 	unsigned long len;
-	int err;
 
 	if (sl->tty == NULL)
 		return -ENODEV;
@@ -482,14 +481,7 @@ static int x25_asy_open(struct net_device *dev)
 	sl->xleft    = 0;
 	sl->flags   &= (1 << SLF_INUSE);      /* Clear ESCAPE & ERROR flags */
 
-	netif_start_queue(dev);
-
-	/*
-	 *	Now attach LAPB
-	 */
-	err = lapb_register(dev, &x25_asy_callbacks);
-	if (err == LAPB_OK)
-		return 0;
+	return 0;
 
 	/* Cleanup */
 	kfree(sl->xbuff);
@@ -511,7 +503,6 @@ static int x25_asy_close(struct net_device *dev)
 	if (sl->tty)
 		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 
-	netif_stop_queue(dev);
 	sl->rcount = 0;
 	sl->xleft  = 0;
 	spin_unlock(&sl->lock);
@@ -596,7 +587,6 @@ static int x25_asy_open_tty(struct tty_struct *tty)
 static void x25_asy_close_tty(struct tty_struct *tty)
 {
 	struct x25_asy *sl = tty->disc_data;
-	int err;
 
 	/* First make sure we're connected. */
 	if (!sl || sl->magic != X25_ASY_MAGIC)
@@ -607,11 +597,6 @@ static void x25_asy_close_tty(struct tty_struct *tty)
 		dev_close(sl->dev);
 	rtnl_unlock();
 
-	err = lapb_unregister(sl->dev);
-	if (err != LAPB_OK)
-		pr_err("%s: lapb_unregister error: %d\n",
-		       __func__, err);
-
 	tty->disc_data = NULL;
 	sl->tty = NULL;
 	x25_asy_free(sl);
@@ -714,15 +699,39 @@ static int x25_asy_ioctl(struct tty_struct *tty, struct file *file,
 
 static int x25_asy_open_dev(struct net_device *dev)
 {
+	int err;
 	struct x25_asy *sl = netdev_priv(dev);
 	if (sl->tty == NULL)
 		return -ENODEV;
+
+	err = lapb_register(dev, &x25_asy_callbacks);
+	if (err != LAPB_OK)
+		return -ENOMEM;
+
+	netif_start_queue(dev);
+
+	return 0;
+}
+
+static int x25_asy_close_dev(struct net_device *dev)
+{
+	int err;
+
+	netif_stop_queue(dev);
+
+	err = lapb_unregister(dev);
+	if (err != LAPB_OK)
+		pr_err("%s: lapb_unregister error: %d\n",
+		       __func__, err);
+
+	x25_asy_close(dev);
+
 	return 0;
 }
 
 static const struct net_device_ops x25_asy_netdev_ops = {
 	.ndo_open	= x25_asy_open_dev,
-	.ndo_stop	= x25_asy_close,
+	.ndo_stop	= x25_asy_close_dev,
 	.ndo_start_xmit	= x25_asy_xmit,
 	.ndo_tx_timeout	= x25_asy_timeout,
 	.ndo_change_mtu	= x25_asy_change_mtu,
-- 
2.25.1

