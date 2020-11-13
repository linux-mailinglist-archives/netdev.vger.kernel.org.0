Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B22B2001
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgKMQVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:21:48 -0500
Received: from mga18.intel.com ([134.134.136.126]:45999 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMQVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:21:45 -0500
IronPort-SDR: Qgd87l1V+ljohzq/7PxvU1O8W639ju8PbiMTrPedR/bikgfl9Cvo4jbATjmw+DM4MXr02z8xvA
 4Gv8SMPnpAKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="158272287"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="158272287"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:42 -0800
IronPort-SDR: 4YohpS2jwIGygbLHtc4777j4s/neDLKZv/OwZZyz0aPsdsqamxUjI5jKGFtmLP3KjVSoeLRWKo
 8yFAf9METsCw==
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="366767227"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:41 -0800
From:   Dave Ertman <david.m.ertman@intel.com>
To:     alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org, linux-rdma@vger.kernel.org,
        jgg@nvidia.com, dledford@redhat.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org, leonro@nvidia.com
Subject: [PATCH v4 02/10] ASoC: SOF: Introduce descriptors for SOF client
Date:   Fri, 13 Nov 2020 08:18:51 -0800
Message-Id: <20201113161859.1775473-3-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113161859.1775473-1-david.m.ertman@intel.com>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
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
 sound/soc/sof/sof-client.c | 115 +++++++++++++++++++++++++++++++++++++
 sound/soc/sof/sof-client.h |  66 +++++++++++++++++++++
 sound/soc/sof/sof-priv.h   |   9 +++
 6 files changed, 214 insertions(+)
 create mode 100644 sound/soc/sof/sof-client.c
 create mode 100644 sound/soc/sof/sof-client.h

diff --git a/sound/soc/sof/Kconfig b/sound/soc/sof/Kconfig
index 8c1f0829de40..31e9911098fc 100644
--- a/sound/soc/sof/Kconfig
+++ b/sound/soc/sof/Kconfig
@@ -50,6 +50,24 @@ config SND_SOC_SOF_DEBUG_PROBES
 	  Say Y if you want to enable probes.
 	  If unsure, select "N".
 
+config SND_SOC_SOF_CLIENT
+	tristate
+	select AUXILIARY_BUS
+	help
+	  This option is not user-selectable but automagically handled by
+	  'select' statements at a higher level.
+
+config SND_SOC_SOF_CLIENT_SUPPORT
+	bool "SOF enable clients"
+	depends on SND_SOC_SOF
+	help
+	  This adds support for auxiliary client devices to separate out the debug
+	  functionality for IPC tests, probes etc. into separate devices. This
+	  option would also allow adding client devices based on DSP firmware
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
index 000000000000..dd75a0ba4c28
--- /dev/null
+++ b/sound/soc/sof/sof-client.c
@@ -0,0 +1,115 @@
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
+static void sof_client_auxdev_release(struct device *dev)
+{
+	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
+	struct sof_client_dev *cdev = auxiliary_dev_to_sof_client_dev(auxdev);
+
+	kfree(cdev);
+}
+
+static struct sof_client_dev *sof_client_dev_alloc(struct snd_sof_dev *sdev, const char *name,
+						   u32 id)
+{
+	struct sof_client_dev *cdev;
+	struct auxiliary_device *auxdev;
+	int ret;
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return ERR_PTR(-ENOMEM);
+
+	cdev->sdev = sdev;
+	auxdev = &cdev->auxdev;
+	auxdev->name = name;
+	auxdev->dev.parent = sdev->dev;
+	auxdev->dev.release = sof_client_auxdev_release;
+	auxdev->id = id;
+
+	ret = auxiliary_device_init(auxdev);
+	if (ret < 0) {
+		dev_err(sdev->dev, "error: failed to initialize client dev %s\n", name);
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
+int sof_client_dev_register(struct snd_sof_dev *sdev, const char *name, u32 id)
+{
+	struct sof_client_dev *cdev;
+	int ret;
+
+	cdev = sof_client_dev_alloc(sdev, name, id);
+	if (IS_ERR_OR_NULL(cdev))
+		return PTR_ERR(cdev);
+
+	ret = auxiliary_device_add(&cdev->auxdev);
+	if (ret < 0) {
+		dev_err(sdev->dev, "error: failed to add client dev %s\n", name);
+		/* cdev will be freed when the release callback is invoked through put_device() */
+		auxiliary_device_uninit(&cdev->auxdev);
+		return ret;
+	}
+
+	/* add to list of SOF client devices */
+	mutex_lock(&sdev->client_mutex);
+	list_add(&cdev->list, &sdev->client_list);
+	mutex_unlock(&sdev->client_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_dev_register, SND_SOC_SOF_CLIENT);
+
+void sof_client_dev_unregister(struct snd_sof_dev *sdev, const char *name, u32 id)
+{
+	struct sof_client_dev *cdev, *_cdev;
+
+	mutex_lock(&sdev->client_mutex);
+
+	/* cdev will be freed when the release callback for the auxiliary device is invoked */
+	list_for_each_entry_safe(cdev, _cdev, &sdev->client_list, list) {
+		if (!strcmp(cdev->auxdev.name, name) && cdev->auxdev.id == id) {
+			auxiliary_device_delete(&cdev->auxdev);
+			auxiliary_device_uninit(&cdev->auxdev);
+			break;
+		}
+	}
+
+	mutex_unlock(&sdev->client_mutex);
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
index 000000000000..429282df9f65
--- /dev/null
+++ b/sound/soc/sof/sof-client.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __SOUND_SOC_SOF_CLIENT_H
+#define __SOUND_SOC_SOF_CLIENT_H
+
+#include <linux/auxiliary_bus.h>
+#include <linux/device.h>
+#include <linux/idr.h>
+#include <linux/list.h>
+
+#define SOF_CLIENT_PROBE_TIMEOUT_MS 2000
+
+struct snd_sof_dev;
+
+/* SOF client device */
+struct sof_client_dev {
+	struct auxiliary_device auxdev;
+	struct snd_sof_dev *sdev;
+	struct list_head list;	/* item in SOF core client dev list */
+	void *data;
+};
+
+/* client-specific ops, all optional */
+struct sof_client_ops {
+	int (*client_ipc_rx)(struct sof_client_dev *cdev, u32 msg_cmd);
+};
+
+struct sof_client_drv {
+	const struct sof_client_ops ops;
+	struct auxiliary_driver auxiliary_drv;
+};
+
+#define auxiliary_dev_to_sof_client_dev(auxiliary_dev) \
+	container_of(auxiliary_dev, struct sof_client_dev, auxdev)
+
+static inline int sof_client_drv_register(struct sof_client_drv *drv)
+{
+	return auxiliary_driver_register(&drv->auxiliary_drv);
+}
+
+static inline void sof_client_drv_unregister(struct sof_client_drv *drv)
+{
+	auxiliary_driver_unregister(&drv->auxiliary_drv);
+}
+
+int sof_client_dev_register(struct snd_sof_dev *sdev, const char *name, u32 id);
+void sof_client_dev_unregister(struct snd_sof_dev *sdev, const char *name, u32 id);
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
index 0aed2a7ab858..dceac73b858f 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -442,6 +442,15 @@ struct snd_sof_dev {
 
 	bool msi_enabled;
 
+	/*
+	 * Used to keep track of registered client devices so that they can be removed when the
+	 * parent SOF module is removed.
+	 */
+	struct list_head client_list;
+
+	/* mutex to protect client list */
+	struct mutex client_mutex;
+
 	void *private;			/* core does not touch this */
 };
 
-- 
2.26.2

