Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8248937492E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhEEUQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbhEEUP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 16:15:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715ABC061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 13:15:01 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1leNv4-0007fA-5f; Wed, 05 May 2021 22:14:54 +0200
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1leNv2-0006m5-Sc; Wed, 05 May 2021 22:14:52 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH] sparc/vio: make remove callback return void
Date:   Wed,  5 May 2021 22:14:49 +0200
Message-Id: <20210505201449.195627-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver core ignores the return value of struct bus_type::remove()
because there is only little that can be done. To simplify the quest to
make this function return void, let struct vio_driver::remove() return
void, too. All users already unconditionally return 0, this commit makes
it obvious that returning an error code is a bad idea and should prevent
that future driver authors consider returning an error code.

Note there are two nominally different implementations for a vio bus:
one in arch/sparc/kernel/vio.c and the other in
arch/powerpc/platforms/pseries/vio.c. This patch only addresses the
former.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/sparc/include/asm/vio.h       | 2 +-
 arch/sparc/kernel/ds.c             | 6 ------
 arch/sparc/kernel/vio.c            | 4 ++--
 drivers/block/sunvdc.c             | 3 +--
 drivers/net/ethernet/sun/ldmvsw.c  | 4 +---
 drivers/net/ethernet/sun/sunvnet.c | 3 +--
 drivers/tty/vcc.c                  | 4 +---
 7 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/sparc/include/asm/vio.h b/arch/sparc/include/asm/vio.h
index 059f0eb678e0..8a1a83bbb6d5 100644
--- a/arch/sparc/include/asm/vio.h
+++ b/arch/sparc/include/asm/vio.h
@@ -362,7 +362,7 @@ struct vio_driver {
 	struct list_head		node;
 	const struct vio_device_id	*id_table;
 	int (*probe)(struct vio_dev *dev, const struct vio_device_id *id);
-	int (*remove)(struct vio_dev *dev);
+	void (*remove)(struct vio_dev *dev);
 	void (*shutdown)(struct vio_dev *dev);
 	unsigned long			driver_data;
 	struct device_driver		driver;
diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 522e5b51050c..4a5bdb0df779 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -1236,11 +1236,6 @@ static int ds_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	return err;
 }
 
-static int ds_remove(struct vio_dev *vdev)
-{
-	return 0;
-}
-
 static const struct vio_device_id ds_match[] = {
 	{
 		.type = "domain-services-port",
@@ -1251,7 +1246,6 @@ static const struct vio_device_id ds_match[] = {
 static struct vio_driver ds_driver = {
 	.id_table	= ds_match,
 	.probe		= ds_probe,
-	.remove		= ds_remove,
 	.name		= "ds",
 };
 
diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
index 4f57056ed463..348a88691219 100644
--- a/arch/sparc/kernel/vio.c
+++ b/arch/sparc/kernel/vio.c
@@ -105,10 +105,10 @@ static int vio_device_remove(struct device *dev)
 		 * routines to do so at the moment. TBD
 		 */
 
-		return drv->remove(vdev);
+		drv->remove(vdev);
 	}
 
-	return 1;
+	return 0;
 }
 
 static ssize_t devspec_show(struct device *dev,
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 39aeebc6837d..1547d4345ad8 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -1071,7 +1071,7 @@ static int vdc_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	return err;
 }
 
-static int vdc_port_remove(struct vio_dev *vdev)
+static void vdc_port_remove(struct vio_dev *vdev)
 {
 	struct vdc_port *port = dev_get_drvdata(&vdev->dev);
 
@@ -1094,7 +1094,6 @@ static int vdc_port_remove(struct vio_dev *vdev)
 
 		kfree(port);
 	}
-	return 0;
 }
 
 static void vdc_requeue_inflight(struct vdc_port *port)
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 01ea0d6f8819..50bd4e3b0af9 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -404,7 +404,7 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	return err;
 }
 
-static int vsw_port_remove(struct vio_dev *vdev)
+static void vsw_port_remove(struct vio_dev *vdev)
 {
 	struct vnet_port *port = dev_get_drvdata(&vdev->dev);
 	unsigned long flags;
@@ -430,8 +430,6 @@ static int vsw_port_remove(struct vio_dev *vdev)
 
 		free_netdev(port->dev);
 	}
-
-	return 0;
 }
 
 static void vsw_cleanup(void)
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 96b883f965f6..58ee89223951 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -510,7 +510,7 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	return err;
 }
 
-static int vnet_port_remove(struct vio_dev *vdev)
+static void vnet_port_remove(struct vio_dev *vdev)
 {
 	struct vnet_port *port = dev_get_drvdata(&vdev->dev);
 
@@ -533,7 +533,6 @@ static int vnet_port_remove(struct vio_dev *vdev)
 
 		kfree(port);
 	}
-	return 0;
 }
 
 static const struct vio_device_id vnet_port_match[] = {
diff --git a/drivers/tty/vcc.c b/drivers/tty/vcc.c
index 0a3a71e14df4..0c9b291ef307 100644
--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -668,7 +668,7 @@ static int vcc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
  *
  * Return: status of removal
  */
-static int vcc_remove(struct vio_dev *vdev)
+static void vcc_remove(struct vio_dev *vdev)
 {
 	struct vcc_port *port = dev_get_drvdata(&vdev->dev);
 
@@ -703,8 +703,6 @@ static int vcc_remove(struct vio_dev *vdev)
 		kfree(port->domain);
 		kfree(port);
 	}
-
-	return 0;
 }
 
 static const struct vio_device_id vcc_match[] = {
-- 
2.30.2

