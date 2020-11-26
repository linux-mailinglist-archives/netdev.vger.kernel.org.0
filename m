Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934112C59DD
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404141AbgKZRBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404063AbgKZRBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:01:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40BAC0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 09:01:34 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kiKcr-0001Kk-AC; Thu, 26 Nov 2020 18:00:09 +0100
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kiKch-0002s0-J8; Thu, 26 Nov 2020 17:59:59 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Geoff Levand <geoff@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 2/2] powerpc/ps3: make system bus's remove and shutdown callbacks return void
Date:   Thu, 26 Nov 2020 17:59:50 +0100
Message-Id: <20201126165950.2554997-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver core ignores the return value of struct device_driver::remove
because there is only little that can be done. For the shutdown callback
it's ps3_system_bus_shutdown() which ignores the return value.

To simplify the quest to make struct device_driver::remove return void,
let struct ps3_system_bus_driver::remove return void, too. All users
already unconditionally return 0, this commit makes it obvious that
returning an error code is a bad idea and ensures future users behave
accordingly.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/powerpc/include/asm/ps3.h               |  4 ++--
 arch/powerpc/platforms/ps3/system-bus.c      |  5 ++---
 drivers/block/ps3disk.c                      |  3 +--
 drivers/block/ps3vram.c                      |  3 +--
 drivers/char/ps3flash.c                      |  3 +--
 drivers/net/ethernet/toshiba/ps3_gelic_net.c |  3 +--
 drivers/ps3/ps3-lpm.c                        |  3 +--
 drivers/ps3/ps3-vuart.c                      | 10 ++++------
 drivers/scsi/ps3rom.c                        |  3 +--
 drivers/usb/host/ehci-ps3.c                  |  4 +---
 drivers/usb/host/ohci-ps3.c                  |  4 +---
 drivers/video/fbdev/ps3fb.c                  |  4 +---
 sound/ppc/snd_ps3.c                          |  3 +--
 13 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/ps3.h b/arch/powerpc/include/asm/ps3.h
index cb89e4bf55ce..e646c7f218bc 100644
--- a/arch/powerpc/include/asm/ps3.h
+++ b/arch/powerpc/include/asm/ps3.h
@@ -378,8 +378,8 @@ struct ps3_system_bus_driver {
 	enum ps3_match_sub_id match_sub_id;
 	struct device_driver core;
 	int (*probe)(struct ps3_system_bus_device *);
-	int (*remove)(struct ps3_system_bus_device *);
-	int (*shutdown)(struct ps3_system_bus_device *);
+	void (*remove)(struct ps3_system_bus_device *);
+	void (*shutdown)(struct ps3_system_bus_device *);
 /*	int (*suspend)(struct ps3_system_bus_device *, pm_message_t); */
 /*	int (*resume)(struct ps3_system_bus_device *); */
 };
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index c62aaa29a9d5..b431f41c6cb5 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -382,7 +382,6 @@ static int ps3_system_bus_probe(struct device *_dev)
 
 static int ps3_system_bus_remove(struct device *_dev)
 {
-	int result = 0;
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 	struct ps3_system_bus_driver *drv;
 
@@ -393,13 +392,13 @@ static int ps3_system_bus_remove(struct device *_dev)
 	BUG_ON(!drv);
 
 	if (drv->remove)
-		result = drv->remove(dev);
+		drv->remove(dev);
 	else
 		dev_dbg(&dev->core, "%s:%d %s: no remove method\n",
 			__func__, __LINE__, drv->core.name);
 
 	pr_debug(" <- %s:%d: %s\n", __func__, __LINE__, dev_name(&dev->core));
-	return result;
+	return 0;
 }
 
 static void ps3_system_bus_shutdown(struct device *_dev)
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 7b55811c2a81..ba3ece56cbb3 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -507,7 +507,7 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	return error;
 }
 
-static int ps3disk_remove(struct ps3_system_bus_device *_dev)
+static void ps3disk_remove(struct ps3_system_bus_device *_dev)
 {
 	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
 	struct ps3disk_private *priv = ps3_system_bus_get_drvdata(&dev->sbd);
@@ -526,7 +526,6 @@ static int ps3disk_remove(struct ps3_system_bus_device *_dev)
 	kfree(dev->bounce_buf);
 	kfree(priv);
 	ps3_system_bus_set_drvdata(_dev, NULL);
-	return 0;
 }
 
 static struct ps3_system_bus_driver ps3disk = {
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 1088798c8dd0..b71d28372ef3 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -797,7 +797,7 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	return error;
 }
 
-static int ps3vram_remove(struct ps3_system_bus_device *dev)
+static void ps3vram_remove(struct ps3_system_bus_device *dev)
 {
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
 
@@ -817,7 +817,6 @@ static int ps3vram_remove(struct ps3_system_bus_device *dev)
 	free_pages((unsigned long) priv->xdr_buf, get_order(XDR_BUF_SIZE));
 	kfree(priv);
 	ps3_system_bus_set_drvdata(dev, NULL);
-	return 0;
 }
 
 static struct ps3_system_bus_driver ps3vram = {
diff --git a/drivers/char/ps3flash.c b/drivers/char/ps3flash.c
index 1a07fee33f66..23871cde41fb 100644
--- a/drivers/char/ps3flash.c
+++ b/drivers/char/ps3flash.c
@@ -403,7 +403,7 @@ static int ps3flash_probe(struct ps3_system_bus_device *_dev)
 	return error;
 }
 
-static int ps3flash_remove(struct ps3_system_bus_device *_dev)
+static void ps3flash_remove(struct ps3_system_bus_device *_dev)
 {
 	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
 
@@ -413,7 +413,6 @@ static int ps3flash_remove(struct ps3_system_bus_device *_dev)
 	kfree(ps3_system_bus_get_drvdata(&dev->sbd));
 	ps3_system_bus_set_drvdata(&dev->sbd, NULL);
 	ps3flash_dev = NULL;
-	return 0;
 }
 
 
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index d9a5722f561b..3d1fc8d2ca66 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1791,7 +1791,7 @@ static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
  * ps3_gelic_driver_remove - remove a device from the control of this driver
  */
 
-static int ps3_gelic_driver_remove(struct ps3_system_bus_device *dev)
+static void ps3_gelic_driver_remove(struct ps3_system_bus_device *dev)
 {
 	struct gelic_card *card = ps3_system_bus_get_drvdata(dev);
 	struct net_device *netdev0;
@@ -1840,7 +1840,6 @@ static int ps3_gelic_driver_remove(struct ps3_system_bus_device *dev)
 	ps3_close_hv_device(dev);
 
 	pr_debug("%s: done\n", __func__);
-	return 0;
 }
 
 static struct ps3_system_bus_driver ps3_gelic_driver = {
diff --git a/drivers/ps3/ps3-lpm.c b/drivers/ps3/ps3-lpm.c
index e54aa2d82f50..65512b6cc6fd 100644
--- a/drivers/ps3/ps3-lpm.c
+++ b/drivers/ps3/ps3-lpm.c
@@ -1196,7 +1196,7 @@ static int ps3_lpm_probe(struct ps3_system_bus_device *dev)
 	return 0;
 }
 
-static int ps3_lpm_remove(struct ps3_system_bus_device *dev)
+static void ps3_lpm_remove(struct ps3_system_bus_device *dev)
 {
 	dev_dbg(&dev->core, " -> %s:%u:\n", __func__, __LINE__);
 
@@ -1206,7 +1206,6 @@ static int ps3_lpm_remove(struct ps3_system_bus_device *dev)
 	lpm_priv = NULL;
 
 	dev_info(&dev->core, " <- %s:%u:\n", __func__, __LINE__);
-	return 0;
 }
 
 static struct ps3_system_bus_driver ps3_lpm_driver = {
diff --git a/drivers/ps3/ps3-vuart.c b/drivers/ps3/ps3-vuart.c
index 4ed131eaff51..e34ae6a442c7 100644
--- a/drivers/ps3/ps3-vuart.c
+++ b/drivers/ps3/ps3-vuart.c
@@ -1102,7 +1102,7 @@ static int ps3_vuart_cleanup(struct ps3_system_bus_device *dev)
  * device can no longer be used.
  */
 
-static int ps3_vuart_remove(struct ps3_system_bus_device *dev)
+static void ps3_vuart_remove(struct ps3_system_bus_device *dev)
 {
 	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
 	struct ps3_vuart_port_driver *drv;
@@ -1118,7 +1118,7 @@ static int ps3_vuart_remove(struct ps3_system_bus_device *dev)
 		dev_dbg(&dev->core, "%s:%d: no driver bound\n", __func__,
 			__LINE__);
 		mutex_unlock(&vuart_bus_priv.probe_mutex);
-		return 0;
+		return;
 	}
 
 	drv = ps3_system_bus_dev_to_vuart_drv(dev);
@@ -1141,7 +1141,6 @@ static int ps3_vuart_remove(struct ps3_system_bus_device *dev)
 
 	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
 	mutex_unlock(&vuart_bus_priv.probe_mutex);
-	return 0;
 }
 
 /**
@@ -1154,7 +1153,7 @@ static int ps3_vuart_remove(struct ps3_system_bus_device *dev)
  * sequence.
  */
 
-static int ps3_vuart_shutdown(struct ps3_system_bus_device *dev)
+static void ps3_vuart_shutdown(struct ps3_system_bus_device *dev)
 {
 	struct ps3_vuart_port_driver *drv;
 
@@ -1169,7 +1168,7 @@ static int ps3_vuart_shutdown(struct ps3_system_bus_device *dev)
 		dev_dbg(&dev->core, "%s:%d: no driver bound\n", __func__,
 			__LINE__);
 		mutex_unlock(&vuart_bus_priv.probe_mutex);
-		return 0;
+		return;
 	}
 
 	drv = ps3_system_bus_dev_to_vuart_drv(dev);
@@ -1193,7 +1192,6 @@ static int ps3_vuart_shutdown(struct ps3_system_bus_device *dev)
 	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
 
 	mutex_unlock(&vuart_bus_priv.probe_mutex);
-	return 0;
 }
 
 static int __init ps3_vuart_bus_init(void)
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index f75c0b5cd587..ccb5771f1cb7 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -402,7 +402,7 @@ static int ps3rom_probe(struct ps3_system_bus_device *_dev)
 	return error;
 }
 
-static int ps3rom_remove(struct ps3_system_bus_device *_dev)
+static void ps3rom_remove(struct ps3_system_bus_device *_dev)
 {
 	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
 	struct Scsi_Host *host = ps3_system_bus_get_drvdata(&dev->sbd);
@@ -412,7 +412,6 @@ static int ps3rom_remove(struct ps3_system_bus_device *_dev)
 	scsi_host_put(host);
 	ps3_system_bus_set_drvdata(&dev->sbd, NULL);
 	kfree(dev->bounce_buf);
-	return 0;
 }
 
 static struct ps3_system_bus_driver ps3rom = {
diff --git a/drivers/usb/host/ehci-ps3.c b/drivers/usb/host/ehci-ps3.c
index fb52133c3557..98568b046a1a 100644
--- a/drivers/usb/host/ehci-ps3.c
+++ b/drivers/usb/host/ehci-ps3.c
@@ -200,7 +200,7 @@ static int ps3_ehci_probe(struct ps3_system_bus_device *dev)
 	return result;
 }
 
-static int ps3_ehci_remove(struct ps3_system_bus_device *dev)
+static void ps3_ehci_remove(struct ps3_system_bus_device *dev)
 {
 	unsigned int tmp;
 	struct usb_hcd *hcd = ps3_system_bus_get_drvdata(dev);
@@ -227,8 +227,6 @@ static int ps3_ehci_remove(struct ps3_system_bus_device *dev)
 
 	ps3_dma_region_free(dev->d_region);
 	ps3_close_hv_device(dev);
-
-	return 0;
 }
 
 static int __init ps3_ehci_driver_register(struct ps3_system_bus_driver *drv)
diff --git a/drivers/usb/host/ohci-ps3.c b/drivers/usb/host/ohci-ps3.c
index f77cd6af0ccf..4f5af929c3e4 100644
--- a/drivers/usb/host/ohci-ps3.c
+++ b/drivers/usb/host/ohci-ps3.c
@@ -184,7 +184,7 @@ static int ps3_ohci_probe(struct ps3_system_bus_device *dev)
 	return result;
 }
 
-static int ps3_ohci_remove(struct ps3_system_bus_device *dev)
+static void ps3_ohci_remove(struct ps3_system_bus_device *dev)
 {
 	unsigned int tmp;
 	struct usb_hcd *hcd = ps3_system_bus_get_drvdata(dev);
@@ -212,8 +212,6 @@ static int ps3_ohci_remove(struct ps3_system_bus_device *dev)
 
 	ps3_dma_region_free(dev->d_region);
 	ps3_close_hv_device(dev);
-
-	return 0;
 }
 
 static int __init ps3_ohci_driver_register(struct ps3_system_bus_driver *drv)
diff --git a/drivers/video/fbdev/ps3fb.c b/drivers/video/fbdev/ps3fb.c
index 203c254f8f6c..2fe08b67eda7 100644
--- a/drivers/video/fbdev/ps3fb.c
+++ b/drivers/video/fbdev/ps3fb.c
@@ -1208,7 +1208,7 @@ static int ps3fb_probe(struct ps3_system_bus_device *dev)
 	return retval;
 }
 
-static int ps3fb_shutdown(struct ps3_system_bus_device *dev)
+static void ps3fb_shutdown(struct ps3_system_bus_device *dev)
 {
 	struct fb_info *info = ps3_system_bus_get_drvdata(dev);
 	u64 xdr_lpar = ps3_mm_phys_to_lpar(__pa(ps3fb_videomemory.address));
@@ -1241,8 +1241,6 @@ static int ps3fb_shutdown(struct ps3_system_bus_device *dev)
 	lv1_gpu_memory_free(ps3fb.memory_handle);
 	ps3_close_hv_device(dev);
 	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
-
-	return 0;
 }
 
 static struct ps3_system_bus_driver ps3fb_driver = {
diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 6ab796a5d936..8e44fa5d4dc7 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -1049,7 +1049,7 @@ static int snd_ps3_driver_probe(struct ps3_system_bus_device *dev)
 }; /* snd_ps3_probe */
 
 /* called when module removal */
-static int snd_ps3_driver_remove(struct ps3_system_bus_device *dev)
+static void snd_ps3_driver_remove(struct ps3_system_bus_device *dev)
 {
 	int ret;
 	pr_info("%s:start id=%d\n", __func__,  dev->match_id);
@@ -1075,7 +1075,6 @@ static int snd_ps3_driver_remove(struct ps3_system_bus_device *dev)
 	lv1_gpu_device_unmap(2);
 	ps3_close_hv_device(dev);
 	pr_info("%s:end id=%d\n", __func__, dev->match_id);
-	return 0;
 } /* snd_ps3_remove */
 
 static struct ps3_system_bus_driver snd_ps3_bus_driver_info = {
-- 
2.29.2

