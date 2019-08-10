Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A07C88AD8
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 12:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfHJKmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 06:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbfHJKmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 06:42:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 440982166E;
        Sat, 10 Aug 2019 10:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565433765;
        bh=uVkBqKJQzXqmnsobUTXiEZnWYPiKud6N7HJ2Y67j6m8=;
        h=Date:From:To:Cc:Subject:From;
        b=jswkkRgunYrqQWcLzyyQsbtvQuSjTjF/3zRQhHDsspWM+YuSM95HgOg+20uKhPRI8
         iQcSexkj/kCL+qXHxQalaeSCS3dK1GkfQmhGuiGMJo0FSUUkDHwOhbvzQOyyPd5hm3
         VnfirEYQetwhD4s6+W7vC2rBr1E7BbP4FUbxERbI=
Date:   Sat, 10 Aug 2019 12:42:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Richard Fontana <rfontana@redhat.com>,
        Steve Winslow <swinslow@gmail.com>
Subject: [PATCH] caif: no need to check return value of debugfs_create
 functions
Message-ID: <20190810104243.GA24741@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Richard Fontana <rfontana@redhat.com>
Cc: Steve Winslow <swinslow@gmail.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/caif/caif_serial.c | 26 ++++++++++----------------
 drivers/net/caif/caif_virtio.c |  6 +-----
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index ed3c437063dc..40b079162804 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -94,26 +94,20 @@ static inline void update_tty_status(struct ser_device *ser)
 }
 static inline void debugfs_init(struct ser_device *ser, struct tty_struct *tty)
 {
-	ser->debugfs_tty_dir =
-			debugfs_create_dir(tty->name, debugfsdir);
-	if (!IS_ERR(ser->debugfs_tty_dir)) {
-		debugfs_create_blob("last_tx_msg", 0400,
-				    ser->debugfs_tty_dir,
-				    &ser->tx_blob);
+	ser->debugfs_tty_dir = debugfs_create_dir(tty->name, debugfsdir);
 
-		debugfs_create_blob("last_rx_msg", 0400,
-				    ser->debugfs_tty_dir,
-				    &ser->rx_blob);
+	debugfs_create_blob("last_tx_msg", 0400, ser->debugfs_tty_dir,
+			    &ser->tx_blob);
 
-		debugfs_create_x32("ser_state", 0400,
-				   ser->debugfs_tty_dir,
-				   (u32 *)&ser->state);
+	debugfs_create_blob("last_rx_msg", 0400, ser->debugfs_tty_dir,
+			    &ser->rx_blob);
 
-		debugfs_create_x8("tty_status", 0400,
-				  ser->debugfs_tty_dir,
-				  &ser->tty_status);
+	debugfs_create_x32("ser_state", 0400, ser->debugfs_tty_dir,
+			   (u32 *)&ser->state);
+
+	debugfs_create_x8("tty_status", 0400, ser->debugfs_tty_dir,
+			  &ser->tty_status);
 
-	}
 	ser->tx_blob.data = ser->tx_data;
 	ser->tx_blob.size = 0;
 	ser->rx_blob.data = ser->rx_data;
diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 27e93a438dd9..eb426822ad06 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -623,11 +623,7 @@ static void cfv_netdev_setup(struct net_device *netdev)
 /* Create debugfs counters for the device */
 static inline void debugfs_init(struct cfv_info *cfv)
 {
-	cfv->debugfs =
-		debugfs_create_dir(netdev_name(cfv->ndev), NULL);
-
-	if (IS_ERR(cfv->debugfs))
-		return;
+	cfv->debugfs = debugfs_create_dir(netdev_name(cfv->ndev), NULL);
 
 	debugfs_create_u32("rx-napi-complete", 0400, cfv->debugfs,
 			   &cfv->stats.rx_napi_complete);
-- 
2.22.0

