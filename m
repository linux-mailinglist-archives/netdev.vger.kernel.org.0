Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111FA27F8DF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 07:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgJAFJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 01:09:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:7039 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgJAFJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 01:09:40 -0400
IronPort-SDR: wfLuNr6vnmZzawe3L2F7hj59zxZn2F9kX3zKnzD9JgXWuKP2RHaoF1qGnY8JNs8bMF62UYcF7m
 yYl8DK9J85kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="224238486"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="224238486"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 22:09:38 -0700
IronPort-SDR: 1Nm9XJDH1faCtS8QK0i3qFIbajf2z5Od+io975UodSQosM87FpuJVU8R5Fqh4mw673xeSAQ+eM
 5sKpWxL/NVKg==
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="341443343"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 22:09:37 -0700
From:   Dave Ertman <david.m.ertman@intel.com>
To:     netdev@vger.kernel.org
Subject: [PATCH 2/6] ASoC: SOF: Introduce descriptors for SOF client
Date:   Wed, 30 Sep 2020 22:08:47 -0700
Message-Id: <20201001050851.890722-3-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001050851.890722-1-david.m.ertman@intel.com>
References: <20201001050851.890722-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

A client in the SOF (Sound Open Firmware) context is a
device that needs to communicate with the DSP via IPC
messages. The SOF core is responsible for serializing the
IPC messages to the DSP from the different clients. One
example of an SOF client would be an IPC test client that
floods the DSP with test IPC messages to validate if the
serialization works as expected. Multi-client support will
also add the ability to split the existing audio cards
into multiple ones, so as to e.g. to deal with HDMI with a
dedicated client instead of adding HDMI to all cards.

This patch introduces descriptors for SOF client driver
and SOF client device along with APIs for registering
and unregistering a SOF client driver, sending IPCs from
a client device and accessing the SOF core debugfs root entry.

Along with this, add a couple of new members to struct
snd_sof_dev that will be used for maintaining the list of
clients.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 sound/soc/sof/Kconfig      |  19 ++++++
 sound/soc/sof/Makefile     |   3 +
 sound/soc/sof/core.c       |   2 +
 sound/soc/sof/sof-client.c | 117 +++++++++++++++++++++++++++++++++++++
 sound/soc/sof/sof-client.h |  65 +++++++++++++++++++++
 sound/soc/sof/sof-priv.h   |   6 ++
 6 files changed, 212 insertions(+)
 create mode 100644 sound/soc/sof/sof-client.c
 create mode 100644 sound/soc/sof/sof-client.h

diff --git a/sound/soc/sof/Kconfig b/sound/soc/sof/Kconfig
index 4dda4b62509f..cea7efedafef 100644
--- a/sound/soc/sof/Kconfig
+++ b/sound/soc/sof/Kconfig
@@ -50,6 +50,24 @@ config SND_SOC_SOF_DEBUG_PROBES
 	  Say Y if you want to enable probes.
 	  If unsure, select "N".
 
+config SND_SOC_SOF_CLIENT
+	tristate
+	select ANCILLARY_BUS
+	help
+	  This option is not user-selectable but automagically handled by
+	  'select' statements at a higher level
+
+config SND_SOC_SOF_CLIENT_SUPPORT
+	bool "SOF enable clients"
+	depends on SND_SOC_SOF
+	help
+	  This adds support for ancillary client devices to separate out the debug
+	  functionality for IPC tests, probes etc. into separate devices. This
+	  option would also allow adding client devices based on DSP FW
+	  capabilities and ACPI/OF device information.
+	  Say Y if you want to enable clients with SOF.
+	  If unsure select "N".
+
 config SND_SOC_SOF_DEVELOPER_SUPPORT
 	bool "SOF developer options support"
 	depends on EXPERT
@@ -186,6 +204,7 @@ endif ## SND_SOC_SOF_DEVELOPER_SUPPORT
 
 config SND_SOC_SOF
 	tristate
+	select SND_SOC_SOF_CLIENT if SND_SOC_SOF_CLIENT_SUPPORT
 	select SND_SOC_TOPOLOGY
 	select SND_SOC_SOF_NOCODEC if SND_SOC_SOF_NOCODEC_SUPPORT
 	help
diff --git a/sound/soc/sof/Makefile b/sound/soc/sof/Makefile
index 05718dfe6cd2..5e46f25a3851 100644
--- a/sound/soc/sof/Makefile
+++ b/sound/soc/sof/Makefile
@@ -2,6 +2,7 @@
 
 snd-sof-objs := core.o ops.o loader.o ipc.o pcm.o pm.o debug.o topology.o\
 		control.o trace.o utils.o sof-audio.o
+snd-sof-client-objs := sof-client.o
 snd-sof-$(CONFIG_SND_SOC_SOF_DEBUG_PROBES) += probe.o compress.o
 
 snd-sof-pci-objs := sof-pci-dev.o
@@ -18,6 +19,8 @@ obj-$(CONFIG_SND_SOC_SOF_ACPI) += snd-sof-acpi.o
 obj-$(CONFIG_SND_SOC_SOF_OF) += snd-sof-of.o
 obj-$(CONFIG_SND_SOC_SOF_PCI) += snd-sof-pci.o
 
+obj-$(CONFIG_SND_SOC_SOF_CLIENT) += snd-sof-client.o
+
 obj-$(CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL) += intel/
 obj-$(CONFIG_SND_SOC_SOF_IMX_TOPLEVEL) += imx/
 obj-$(CONFIG_SND_SOC_SOF_XTENSA) += xtensa/
diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index adc7c37145d6..72a97219395f 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -314,8 +314,10 @@ int snd_sof_device_probe(struct device *dev, struct snd_sof_pdata *plat_data)
 	INIT_LIST_HEAD(&sdev->widget_list);
 	INIT_LIST_HEAD(&sdev->dai_list);
 	INIT_LIST_HEAD(&sdev->route_list);
+	INIT_LIST_HEAD(&sdev->client_list);
 	spin_lock_init(&sdev->ipc_lock);
 	spin_lock_init(&sdev->hw_lock);
+	mutex_init(&sdev->client_mutex);
 
 	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
 		INIT_WORK(&sdev->probe_work, sof_probe_work);
diff --git a/sound/soc/sof/sof-client.c b/sound/soc/sof/sof-client.c
new file mode 100644
index 000000000000..f7e476d99ff6
--- /dev/null
+++ b/sound/soc/sof/sof-client.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Copyright(c) 2020 Intel Corporation. All rights reserved.
+//
+// Author: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
+//
+
+#include <linux/debugfs.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include "sof-client.h"
+#include "sof-priv.h"
+
+static void sof_client_ancildev_release(struct device *dev)
+{
+	struct ancillary_device *ancildev = to_ancillary_dev(dev);
+	struct sof_client_dev *cdev = ancillary_dev_to_sof_client_dev(ancildev);
+
+	ida_simple_remove(cdev->client_ida, ancildev->id);
+	kfree(cdev);
+}
+
+static struct sof_client_dev *sof_client_dev_alloc(struct snd_sof_dev *sdev, const char *name,
+						   struct ida *client_ida)
+{
+	struct sof_client_dev *cdev;
+	struct ancillary_device *ancildev;
+	int ret;
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return NULL;
+
+	cdev->sdev = sdev;
+	cdev->client_ida = client_ida;
+	ancildev = &cdev->ancildev;
+	ancildev->name = name;
+	ancildev->dev.parent = sdev->dev;
+	ancildev->dev.release = sof_client_ancildev_release;
+
+	ancildev->id = ida_alloc(client_ida, GFP_KERNEL);
+	if (ancildev->id < 0) {
+		dev_err(sdev->dev, "error: get IDA idx for ancillary device %s failed\n", name);
+		ret = ancildev->id;
+		goto err_free;
+	}
+
+	ret = ancillary_device_initialize(ancildev);
+	if (ret < 0) {
+		dev_err(sdev->dev, "error: failed to initialize client dev %s\n", name);
+		ida_simple_remove(client_ida, ancildev->id);
+		goto err_free;
+	}
+
+	return cdev;
+
+err_free:
+	kfree(cdev);
+	return NULL;
+}
+
+int sof_client_dev_register(struct snd_sof_dev *sdev, const char *name, struct ida *client_ida)
+{
+	struct sof_client_dev *cdev;
+	int ret;
+
+	cdev = sof_client_dev_alloc(sdev, name, client_ida);
+	if (!cdev)
+		return -ENODEV;
+
+	ret = ancillary_device_add(&cdev->ancildev);
+	if (ret < 0) {
+		dev_err(sdev->dev, "error: failed to add client dev %s\n", name);
+		put_device(&cdev->ancildev.dev);
+		return ret;
+	}
+
+	/* add to list of SOF client devices */
+	mutex_lock(&sdev->client_mutex);
+	list_add(&cdev->list, &sdev->client_list);
+	mutex_unlock(&sdev->client_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_dev_register, SND_SOC_SOF_CLIENT);
+
+void sof_client_dev_unregister(struct sof_client_dev *cdev)
+{
+	struct snd_sof_dev *sdev = cdev->sdev;
+
+	/* remove from list of SOF client devices */
+	mutex_lock(&sdev->client_mutex);
+	list_del(&cdev->list);
+	mutex_unlock(&sdev->client_mutex);
+
+	ancillary_device_unregister(&cdev->ancildev);
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_dev_unregister, SND_SOC_SOF_CLIENT);
+
+int sof_client_ipc_tx_message(struct sof_client_dev *cdev, u32 header, void *msg_data,
+			      size_t msg_bytes, void *reply_data, size_t reply_bytes)
+{
+	return sof_ipc_tx_message(cdev->sdev->ipc, header, msg_data, msg_bytes,
+				  reply_data, reply_bytes);
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_ipc_tx_message, SND_SOC_SOF_CLIENT);
+
+struct dentry *sof_client_get_debugfs_root(struct sof_client_dev *cdev)
+{
+	return cdev->sdev->debugfs_root;
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_get_debugfs_root, SND_SOC_SOF_CLIENT);
+
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/sof/sof-client.h b/sound/soc/sof/sof-client.h
new file mode 100644
index 000000000000..62212f69c236
--- /dev/null
+++ b/sound/soc/sof/sof-client.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: (GPL-2.0-only) */
+
+#ifndef __SOUND_SOC_SOF_CLIENT_H
+#define __SOUND_SOC_SOF_CLIENT_H
+
+#include <linux/ancillary_bus.h>
+
+#define SOF_CLIENT_PROBE_TIMEOUT_MS 2000
+
+struct snd_sof_dev;
+
+/* SOF client device */
+struct sof_client_dev {
+	struct ancillary_device ancildev;
+	struct snd_sof_dev *sdev;
+	struct list_head list;	/* item in SOF core client dev list */
+	struct ida *client_ida;
+	void *data;
+};
+
+/* client-specific ops, all optional */
+struct sof_client_ops {
+	int (*client_ipc_rx)(struct sof_client_dev *cdev, u32 msg_cmd);
+};
+
+struct sof_client_drv {
+	const char *name;
+	const struct sof_client_ops ops;
+	struct ancillary_driver ancillary_drv;
+};
+
+#define ancillary_dev_to_sof_client_dev(ancillary_dev) \
+	container_of(ancillary_dev, struct sof_client_dev, ancildev)
+
+static inline int sof_client_drv_register(struct sof_client_drv *drv)
+{
+	return ancillary_driver_register(&drv->ancillary_drv);
+}
+
+static inline void sof_client_drv_unregister(struct sof_client_drv *drv)
+{
+	ancillary_driver_unregister(&drv->ancillary_drv);
+}
+
+int sof_client_dev_register(struct snd_sof_dev *sdev, const char *name, struct ida *client_ida);
+void sof_client_dev_unregister(struct sof_client_dev *cdev);
+
+int sof_client_ipc_tx_message(struct sof_client_dev *cdev, u32 header, void *msg_data,
+			      size_t msg_bytes, void *reply_data, size_t reply_bytes);
+
+struct dentry *sof_client_get_debugfs_root(struct sof_client_dev *cdev);
+
+/**
+ * module_sof_client_driver() - Helper macro for registering an SOF Client
+ * driver
+ * @__sof_client_driver: SOF client driver struct
+ *
+ * Helper macro for SOF client drivers which do not do anything special in
+ * module init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_sof_client_driver(__sof_client_driver) \
+	module_driver(__sof_client_driver, sof_client_drv_register, sof_client_drv_unregister)
+
+#endif
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index 64f28e082049..043fcec5a288 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -438,6 +438,12 @@ struct snd_sof_dev {
 
 	bool msi_enabled;
 
+	/* list of client devices */
+	struct list_head client_list;
+
+	/* mutex to protect client list */
+	struct mutex client_mutex;
+
 	void *private;			/* core does not touch this */
 };
 
-- 
2.26.2

