Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B26D0C94
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbfJIKSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 06:18:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:32784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730496AbfJIKRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:17:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DCC40AF77;
        Wed,  9 Oct 2019 10:17:27 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH v8 1/5] nvmem: core: add nvmem_device_find
Date:   Wed,  9 Oct 2019 12:17:08 +0200
Message-Id: <20191009101713.12238-2-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191009101713.12238-1-tbogendoerfer@suse.de>
References: <20191009101713.12238-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nvmem_device_find provides a way to search for nvmem devices with
the help of a match function simlair to bus_find_device.

Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 Documentation/driver-api/nvmem.rst |  2 ++
 drivers/nvmem/core.c               | 61 +++++++++++++++++---------------------
 include/linux/nvmem-consumer.h     |  9 ++++++
 3 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/Documentation/driver-api/nvmem.rst b/Documentation/driver-api/nvmem.rst
index d9d958d5c824..287e86819640 100644
--- a/Documentation/driver-api/nvmem.rst
+++ b/Documentation/driver-api/nvmem.rst
@@ -129,6 +129,8 @@ To facilitate such consumers NVMEM framework provides below apis::
   struct nvmem_device *nvmem_device_get(struct device *dev, const char *name);
   struct nvmem_device *devm_nvmem_device_get(struct device *dev,
 					   const char *name);
+  struct nvmem_device *nvmem_device_find(void *data,
+			int (*match)(struct device *dev, const void *data));
   void nvmem_device_put(struct nvmem_device *nvmem);
   int nvmem_device_read(struct nvmem_device *nvmem, unsigned int offset,
 		      size_t bytes, void *buf);
diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 057d1ff87d5d..9f1ee9c766ec 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -76,33 +76,6 @@ static struct bus_type nvmem_bus_type = {
 	.name		= "nvmem",
 };
 
-static struct nvmem_device *of_nvmem_find(struct device_node *nvmem_np)
-{
-	struct device *d;
-
-	if (!nvmem_np)
-		return NULL;
-
-	d = bus_find_device_by_of_node(&nvmem_bus_type, nvmem_np);
-
-	if (!d)
-		return NULL;
-
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
-}
-
 static void nvmem_cell_drop(struct nvmem_cell *cell)
 {
 	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_CELL_REMOVE, cell);
@@ -532,13 +505,16 @@ int devm_nvmem_unregister(struct device *dev, struct nvmem_device *nvmem)
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
@@ -587,7 +563,7 @@ struct nvmem_device *of_nvmem_device_get(struct device_node *np, const char *id)
 	if (!nvmem_np)
 		return ERR_PTR(-ENOENT);
 
-	return __nvmem_device_get(nvmem_np, NULL);
+	return __nvmem_device_get(nvmem_np, device_match_of_node);
 }
 EXPORT_SYMBOL_GPL(of_nvmem_device_get);
 #endif
@@ -613,10 +589,26 @@ struct nvmem_device *nvmem_device_get(struct device *dev, const char *dev_name)
 
 	}
 
-	return __nvmem_device_get(NULL, dev_name);
+	return __nvmem_device_get((void *)dev_name, device_match_name);
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
@@ -710,7 +702,8 @@ nvmem_cell_get_from_lookup(struct device *dev, const char *con_id)
 		if ((strcmp(lookup->dev_id, dev_id) == 0) &&
 		    (strcmp(lookup->con_id, con_id) == 0)) {
 			/* This is the right entry. */
-			nvmem = __nvmem_device_get(NULL, lookup->nvmem_name);
+			nvmem = __nvmem_device_get((void *)lookup->nvmem_name,
+						   device_match_name);
 			if (IS_ERR(nvmem)) {
 				/* Provider may not be registered yet. */
 				cell = ERR_CAST(nvmem);
@@ -780,7 +773,7 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np, const char *id)
 	if (!nvmem_np)
 		return ERR_PTR(-EINVAL);
 
-	nvmem = __nvmem_device_get(nvmem_np, NULL);
+	nvmem = __nvmem_device_get(nvmem_np, device_match_of_node);
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
2.16.4

