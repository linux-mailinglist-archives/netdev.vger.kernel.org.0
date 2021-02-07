Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6E63127D9
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 23:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBGWYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 17:24:38 -0500
Received: from antares.kleine-koenig.org ([94.130.110.236]:48884 "EHLO
        antares.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhBGWYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 17:24:34 -0500
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
        id C6E5EAF2EE6; Sun,  7 Feb 2021 23:23:51 +0100 (CET)
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: [PATCH v1 2/2] mei: bus: change remove callback to return void
Date:   Sun,  7 Feb 2021 23:22:24 +0100
Message-Id: <20210207222224.97547-2-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207222224.97547-1-uwe@kleine-koenig.org>
References: <20210207222224.97547-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver core ignores the return value of mei_cl_device_remove() so
passing an error value doesn't solve any problem. As most mei drivers'
remove callbacks return 0 unconditionally and returning a different value
doesn't have any effect, change this prototype to return void and return 0
unconditionally in mei_cl_device_remove(). The only driver that could
return an error value is modified to emit an explicit warning in the error
case.

Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
---
 drivers/misc/mei/bus.c           | 5 ++---
 drivers/misc/mei/hdcp/mei_hdcp.c | 7 +++++--
 drivers/nfc/microread/mei.c      | 4 +---
 drivers/nfc/pn544/mei.c          | 4 +---
 drivers/watchdog/mei_wdt.c       | 4 +---
 include/linux/mei_cl_bus.h       | 2 +-
 6 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 50d617e7467e..54dddae46705 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -879,17 +879,16 @@ static int mei_cl_device_remove(struct device *dev)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
 	struct mei_cl_driver *cldrv = to_mei_cl_driver(dev->driver);
-	int ret = 0;
 
 	if (cldrv->remove)
-		ret = cldrv->remove(cldev);
+		cldrv->remove(cldev);
 
 	mei_cldev_unregister_callbacks(cldev);
 
 	mei_cl_bus_module_put(cldev);
 	module_put(THIS_MODULE);
 
-	return ret;
+	return 0;
 }
 
 static ssize_t name_show(struct device *dev, struct device_attribute *a,
diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
index 9ae9669e46ea..6a455ebe4891 100644
--- a/drivers/misc/mei/hdcp/mei_hdcp.c
+++ b/drivers/misc/mei/hdcp/mei_hdcp.c
@@ -845,16 +845,19 @@ static int mei_hdcp_probe(struct mei_cl_device *cldev,
 	return ret;
 }
 
-static int mei_hdcp_remove(struct mei_cl_device *cldev)
+static void mei_hdcp_remove(struct mei_cl_device *cldev)
 {
 	struct i915_hdcp_comp_master *comp_master =
 						mei_cldev_get_drvdata(cldev);
+	int ret;
 
 	component_master_del(&cldev->dev, &mei_component_master_ops);
 	kfree(comp_master);
 	mei_cldev_set_drvdata(cldev, NULL);
 
-	return mei_cldev_disable(cldev);
+	ret = mei_cldev_disable(cldev);
+	if (ret)
+		dev_warn(&cldev->dev, "mei_cldev_disable() failed\n")
 }
 
 #define MEI_UUID_HDCP GUID_INIT(0xB638AB7E, 0x94E2, 0x4EA2, 0xA5, \
diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index 5dad8847a9b3..8fa7771085eb 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -44,15 +44,13 @@ static int microread_mei_probe(struct mei_cl_device *cldev,
 	return 0;
 }
 
-static int microread_mei_remove(struct mei_cl_device *cldev)
+static void microread_mei_remove(struct mei_cl_device *cldev)
 {
 	struct nfc_mei_phy *phy = mei_cldev_get_drvdata(cldev);
 
 	microread_remove(phy->hdev);
 
 	nfc_mei_phy_free(phy);
-
-	return 0;
 }
 
 static struct mei_cl_device_id microread_mei_tbl[] = {
diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c
index 579bc599f545..5c10aac085a4 100644
--- a/drivers/nfc/pn544/mei.c
+++ b/drivers/nfc/pn544/mei.c
@@ -42,7 +42,7 @@ static int pn544_mei_probe(struct mei_cl_device *cldev,
 	return 0;
 }
 
-static int pn544_mei_remove(struct mei_cl_device *cldev)
+static void pn544_mei_remove(struct mei_cl_device *cldev)
 {
 	struct nfc_mei_phy *phy = mei_cldev_get_drvdata(cldev);
 
@@ -51,8 +51,6 @@ static int pn544_mei_remove(struct mei_cl_device *cldev)
 	pn544_hci_remove(phy->hdev);
 
 	nfc_mei_phy_free(phy);
-
-	return 0;
 }
 
 static struct mei_cl_device_id pn544_mei_tbl[] = {
diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
index 5391bf3e6b11..53165e49c298 100644
--- a/drivers/watchdog/mei_wdt.c
+++ b/drivers/watchdog/mei_wdt.c
@@ -619,7 +619,7 @@ static int mei_wdt_probe(struct mei_cl_device *cldev,
 	return ret;
 }
 
-static int mei_wdt_remove(struct mei_cl_device *cldev)
+static void mei_wdt_remove(struct mei_cl_device *cldev)
 {
 	struct mei_wdt *wdt = mei_cldev_get_drvdata(cldev);
 
@@ -636,8 +636,6 @@ static int mei_wdt_remove(struct mei_cl_device *cldev)
 	dbgfs_unregister(wdt);
 
 	kfree(wdt);
-
-	return 0;
 }
 
 #define MEI_UUID_WD UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, \
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index 959ad7d850b4..07f5ef8fc456 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -68,7 +68,7 @@ struct mei_cl_driver {
 
 	int (*probe)(struct mei_cl_device *cldev,
 		     const struct mei_cl_device_id *id);
-	int (*remove)(struct mei_cl_device *cldev);
+	void (*remove)(struct mei_cl_device *cldev);
 };
 
 int __mei_cldev_driver_register(struct mei_cl_driver *cldrv,
-- 
2.29.2

