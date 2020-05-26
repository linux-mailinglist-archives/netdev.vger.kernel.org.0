Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15F81DAB46
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgETHCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:02:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:53335 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgETHCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:02:41 -0400
IronPort-SDR: SETilFvCRSeeKInGLG9Cr4RJF2uqbc2pNeiyR00mz9dnLWv6e6jpekSECD6HLn7R89vBhWIV1d
 b22unPyuXBCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 00:02:32 -0700
IronPort-SDR: ahfyLev2Y0QAkC28oEqgc1qvWDndLMA8pHYeAHFct5Pu39hYVXZCl7D/kxL7ZlUoPX6pqSFW//
 GGh4fsZqvSzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="299841204"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 20 May 2020 00:02:32 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF client
Date:   Wed, 20 May 2020 00:02:25 -0700
Message-Id: <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 sound/soc/sof/Kconfig      | 20 +++++++++
 sound/soc/sof/Makefile     |  1 +
 sound/soc/sof/core.c       |  2 +
 sound/soc/sof/sof-client.c | 91 ++++++++++++++++++++++++++++++++++++++
 sound/soc/sof/sof-client.h | 84 +++++++++++++++++++++++++++++++++++
 sound/soc/sof/sof-priv.h   |  6 +++
 6 files changed, 204 insertions(+)
 create mode 100644 sound/soc/sof/sof-client.c
 create mode 100644 sound/soc/sof/sof-client.h

diff --git a/sound/soc/sof/Kconfig b/sound/soc/sof/Kconfig
index 4dda4b62509f..609989daf85b 100644
--- a/sound/soc/sof/Kconfig
+++ b/sound/soc/sof/Kconfig
@@ -50,6 +50,25 @@ config SND_SOC_SOF_DEBUG_PROBES
 	  Say Y if you want to enable probes.
 	  If unsure, select "N".
 
+config SND_SOC_SOF_CLIENT
+	tristate
+	select VIRTUAL_BUS
+	help
+	  This option is not user-selectable but automagically handled by
+	  'select' statements at a higher level
+
+config SND_SOC_SOF_CLIENT_SUPPORT
+	bool "SOF enable clients"
+	depends on SND_SOC_SOF
+	help
+	  This adds support for client support with Sound Open Firmware.
+	  The SOF driver adds the capability to separate out the debug
+	  functionality for IPC tests, probes etc. into separate client
+	  devices. This option would also allow adding client devices
+	  based on DSP FW capabilities and ACPI/OF device information.
+	  Say Y if you want to enable clients with SOF.
+	  If unsure select "N".
+
 config SND_SOC_SOF_DEVELOPER_SUPPORT
 	bool "SOF developer options support"
 	depends on EXPERT
@@ -186,6 +205,7 @@ endif ## SND_SOC_SOF_DEVELOPER_SUPPORT
 
 config SND_SOC_SOF
 	tristate
+	select SND_SOC_SOF_CLIENT if SND_SOC_SOF_CLIENT_SUPPORT
 	select SND_SOC_TOPOLOGY
 	select SND_SOC_SOF_NOCODEC if SND_SOC_SOF_NOCODEC_SUPPORT
 	help
diff --git a/sound/soc/sof/Makefile b/sound/soc/sof/Makefile
index 8eca2f85c90e..c819124c05bb 100644
--- a/sound/soc/sof/Makefile
+++ b/sound/soc/sof/Makefile
@@ -2,6 +2,7 @@
 
 snd-sof-objs := core.o ops.o loader.o ipc.o pcm.o pm.o debug.o topology.o\
 		control.o trace.o utils.o sof-audio.o
+snd-sof-$(CONFIG_SND_SOC_SOF_CLIENT) += sof-client.o
 snd-sof-$(CONFIG_SND_SOC_SOF_DEBUG_PROBES) += probe.o compress.o
 
 snd-sof-pci-objs := sof-pci-dev.o
diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 91acfae7935c..fdfed157e6c0 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -313,8 +313,10 @@ int snd_sof_device_probe(struct device *dev, struct snd_sof_pdata *plat_data)
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
index 000000000000..b46080aa062e
--- /dev/null
+++ b/sound/soc/sof/sof-client.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Copyright(c) 2020 Intel Corporation. All rights reserved.
+//
+// Author: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
+//
+
+#include <linux/completion.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/jiffies.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/virtual_bus.h>
+#include "sof-client.h"
+#include "sof-priv.h"
+
+static void sof_client_virtdev_release(struct virtbus_device *vdev)
+{
+	struct sof_client_dev *cdev = virtbus_dev_to_sof_client_dev(vdev);
+
+	kfree(cdev);
+}
+
+int sof_client_dev_register(struct snd_sof_dev *sdev,
+			    const char *name)
+{
+	struct sof_client_dev *cdev;
+	struct virtbus_device *vdev;
+	unsigned long time, timeout;
+	int ret;
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return -ENOMEM;
+
+	cdev->sdev = sdev;
+	init_completion(&cdev->probe_complete);
+	vdev = &cdev->vdev;
+	vdev->match_name = name;
+	vdev->dev.parent = sdev->dev;
+	vdev->release = sof_client_virtdev_release;
+
+	/*
+	 * Register virtbus device for the client.
+	 * The error path in virtbus_register_device() calls put_device(),
+	 * which will free cdev in the release callback.
+	 */
+	ret = virtbus_register_device(vdev);
+	if (ret < 0)
+		return ret;
+
+	/* make sure the probe is complete before updating client list */
+	timeout = msecs_to_jiffies(SOF_CLIENT_PROBE_TIMEOUT_MS);
+	time = wait_for_completion_timeout(&cdev->probe_complete, timeout);
+	if (!time) {
+		dev_err(sdev->dev, "error: probe of virtbus dev %s timed out\n",
+			name);
+		virtbus_unregister_device(vdev);
+		return -ETIMEDOUT;
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
+int sof_client_ipc_tx_message(struct sof_client_dev *cdev, u32 header,
+			      void *msg_data, size_t msg_bytes,
+			      void *reply_data, size_t reply_bytes)
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
+MODULE_AUTHOR("Ranjani Sridharan <ranjani.sridharan@linux.intel.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/sound/soc/sof/sof-client.h b/sound/soc/sof/sof-client.h
new file mode 100644
index 000000000000..fdc4b1511ffc
--- /dev/null
+++ b/sound/soc/sof/sof-client.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: (GPL-2.0-only) */
+
+#ifndef __SOUND_SOC_SOF_CLIENT_H
+#define __SOUND_SOC_SOF_CLIENT_H
+
+#include <linux/completion.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/device/driver.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/virtual_bus.h>
+
+#define SOF_CLIENT_PROBE_TIMEOUT_MS 2000
+
+struct snd_sof_dev;
+
+enum sof_client_type {
+	SOF_CLIENT_AUDIO,
+	SOF_CLIENT_IPC,
+};
+
+/* SOF client device */
+struct sof_client_dev {
+	struct virtbus_device vdev;
+	struct snd_sof_dev *sdev;
+	struct list_head list;	/* item in SOF core client drv list */
+	struct completion probe_complete;
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
+	enum sof_client_type type;
+	const struct sof_client_ops ops;
+	struct virtbus_driver virtbus_drv;
+};
+
+#define virtbus_dev_to_sof_client_dev(virtbus_dev) \
+	container_of(virtbus_dev, struct sof_client_dev, vdev)
+
+static inline int sof_client_drv_register(struct sof_client_drv *drv)
+{
+	return virtbus_register_driver(&drv->virtbus_drv);
+}
+
+static inline void sof_client_drv_unregister(struct sof_client_drv *drv)
+{
+	virtbus_unregister_driver(&drv->virtbus_drv);
+}
+
+int sof_client_dev_register(struct snd_sof_dev *sdev,
+			    const char *name);
+
+static inline void sof_client_dev_unregister(struct sof_client_dev *cdev)
+{
+	virtbus_unregister_device(&cdev->vdev);
+}
+
+int sof_client_ipc_tx_message(struct sof_client_dev *cdev, u32 header,
+			      void *msg_data, size_t msg_bytes,
+			      void *reply_data, size_t reply_bytes);
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
+	module_driver(__sof_client_driver, sof_client_drv_register, \
+			sof_client_drv_unregister)
+
+#endif
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index a4b297c842df..9da7f6f45362 100644
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

