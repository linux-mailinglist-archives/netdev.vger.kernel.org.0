Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A7287773
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 12:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406436AbfHIKcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 06:32:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:41664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405786AbfHIKcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 06:32:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5CBD4AFF9;
        Fri,  9 Aug 2019 10:32:44 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH v4 3/9] nvmem: core: add nvmem_device_find
Date:   Fri,  9 Aug 2019 12:32:25 +0200
Message-Id: <20190809103235.16338-4-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190809103235.16338-1-tbogendoerfer@suse.de>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nvmem_device_find provides a way to search for nvmem devices with
the help of a match function simlair to bus_find_device.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/nvmem/core.c           | 62 ++++++++++++++++++++++--------------------
 include/linux/nvmem-consumer.h |  9 ++++++
 2 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index ac5d945be88a..e591ba54758f 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -76,36 +76,18 @@ static struct bus_type nvmem_bus_type = {
 	.name		= "nvmem",
 };
 
+#if IS_ENABLED(CONFIG_OF)
 static int of_nvmem_match(struct device *dev, const void *nvmem_np)
 {
 	return dev->of_node == nvmem_np;
 }
+#endif
 
-static struct nvmem_device *of_nvmem_find(struct device_node *nvmem_np)
+static int nvmem_match_name(struct device *dev, const void *data)
 {
-	struct device *d;
-
-	if (!nvmem_np)
-		return NULL;
-
-	d = bus_find_device(&nvmem_bus_type, NULL, nvmem_np, of_nvmem_match);
-
-	if (!d)
-		return NULL;
+	const char *name = data;
 
-	return to_nvmem_device(d);
-}
-
-static struct nvmem_device *nvmem_find(const char *name)
-{
-	struct device *d;
-
-	d = bus_find_device_by_name(&nvmem_bus_type, NULL, name);
-
-	if (!d)
-		return NULL;
-
-	return to_nvmem_device(d);
+	return sysfs_streq(name, dev_name(dev));
 }
 
 static void nvmem_cell_drop(struct nvmem_cell *cell)
@@ -537,13 +519,16 @@ int devm_nvmem_unregister(struct device *dev, struct nvmem_device *nvmem)
 }
 EXPORT_SYMBOL(devm_nvmem_unregister);
 
-static struct nvmem_device *__nvmem_device_get(struct device_node *np,
-					       const char *nvmem_name)
+static struct nvmem_device *__nvmem_device_get(void *data,
+			int (*match)(struct device *dev, const void *data))
 {
 	struct nvmem_device *nvmem = NULL;
+	struct device *dev;
 
 	mutex_lock(&nvmem_mutex);
-	nvmem = np ? of_nvmem_find(np) : nvmem_find(nvmem_name);
+	dev = bus_find_device(&nvmem_bus_type, NULL, data, match);
+	if (dev)
+		nvmem = to_nvmem_device(dev);
 	mutex_unlock(&nvmem_mutex);
 	if (!nvmem)
 		return ERR_PTR(-EPROBE_DEFER);
@@ -592,7 +577,7 @@ struct nvmem_device *of_nvmem_device_get(struct device_node *np, const char *id)
 	if (!nvmem_np)
 		return ERR_PTR(-ENOENT);
 
-	return __nvmem_device_get(nvmem_np, NULL);
+	return __nvmem_device_get(nvmem_np, of_nvmem_match);
 }
 EXPORT_SYMBOL_GPL(of_nvmem_device_get);
 #endif
@@ -618,10 +603,26 @@ struct nvmem_device *nvmem_device_get(struct device *dev, const char *dev_name)
 
 	}
 
-	return __nvmem_device_get(NULL, dev_name);
+	return __nvmem_device_get((void *)dev_name, nvmem_match_name);
 }
 EXPORT_SYMBOL_GPL(nvmem_device_get);
 
+/**
+ * nvmem_device_find() - Find nvmem device with matching function
+ *
+ * @data: Data to pass to match function
+ * @match: Callback function to check device
+ *
+ * Return: ERR_PTR() on error or a valid pointer to a struct nvmem_device
+ * on success.
+ */
+struct nvmem_device *nvmem_device_find(void *data,
+			int (*match)(struct device *dev, const void *data))
+{
+	return __nvmem_device_get(data, match);
+}
+EXPORT_SYMBOL_GPL(nvmem_device_find);
+
 static int devm_nvmem_device_match(struct device *dev, void *res, void *data)
 {
 	struct nvmem_device **nvmem = res;
@@ -715,7 +716,8 @@ nvmem_cell_get_from_lookup(struct device *dev, const char *con_id)
 		if ((strcmp(lookup->dev_id, dev_id) == 0) &&
 		    (strcmp(lookup->con_id, con_id) == 0)) {
 			/* This is the right entry. */
-			nvmem = __nvmem_device_get(NULL, lookup->nvmem_name);
+			nvmem = __nvmem_device_get((void *)lookup->nvmem_name,
+						   nvmem_match_name);
 			if (IS_ERR(nvmem)) {
 				/* Provider may not be registered yet. */
 				cell = ERR_CAST(nvmem);
@@ -785,7 +787,7 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np, const char *id)
 	if (!nvmem_np)
 		return ERR_PTR(-EINVAL);
 
-	nvmem = __nvmem_device_get(nvmem_np, NULL);
+	nvmem = __nvmem_device_get(nvmem_np, of_nvmem_match);
 	of_node_put(nvmem_np);
 	if (IS_ERR(nvmem))
 		return ERR_CAST(nvmem);
diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index 8f8be5b00060..02dc4aa992b2 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -89,6 +89,9 @@ void nvmem_del_cell_lookups(struct nvmem_cell_lookup *entries,
 int nvmem_register_notifier(struct notifier_block *nb);
 int nvmem_unregister_notifier(struct notifier_block *nb);
 
+struct nvmem_device *nvmem_device_find(void *data,
+			int (*match)(struct device *dev, const void *data));
+
 #else
 
 static inline struct nvmem_cell *nvmem_cell_get(struct device *dev,
@@ -204,6 +207,12 @@ static inline int nvmem_unregister_notifier(struct notifier_block *nb)
 	return -EOPNOTSUPP;
 }
 
+static inline struct nvmem_device *nvmem_device_find(void *data,
+			int (*match)(struct device *dev, const void *data))
+{
+	return NULL;
+}
+
 #endif /* CONFIG_NVMEM */
 
 #if IS_ENABLED(CONFIG_NVMEM) && IS_ENABLED(CONFIG_OF)
-- 
2.13.7

