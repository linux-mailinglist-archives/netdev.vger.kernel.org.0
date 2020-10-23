Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABDA2967FA
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 02:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373879AbgJWAfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 20:35:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:43016 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373846AbgJWAfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 20:35:25 -0400
IronPort-SDR: UT11oQCBQgfyjvpyICtZd7k7JozPREtqM3JDx3BRZf7dK/XqWgCTmc9XLH27LBEFTd+HKtZ9tZ
 rT4wblbP612w==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="164118641"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="164118641"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 17:35:24 -0700
IronPort-SDR: uEJ6hxlo7ljJWh1ViCqKJsOSsOfdaTyANaVg50VL+GJJJp/sYXzONyFrsrlaKXRztEi+lkswCy
 f3gT5ilxfS5Q==
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="302505795"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 17:35:24 -0700
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
Subject: [PATCH v3 03/10] ASoC: SOF: Create client driver for IPC test
Date:   Thu, 22 Oct 2020 17:33:31 -0700
Message-Id: <20201023003338.1285642-4-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023003338.1285642-1-david.m.ertman@intel.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

Create an SOF client driver for IPC flood test. This
driver is used to set up the debugfs entries and the
read/write ops for initiating the IPC flood test that
would be used to measure the min/max/avg response times
for sending IPCs to the DSP. The debugfs ops definitions
in the driver is existing code that has been copied
from the core. These will be removed from the SOF core
making is less monolithic and easier to maintain.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 sound/soc/sof/Kconfig               |  10 +
 sound/soc/sof/Makefile              |   4 +
 sound/soc/sof/sof-ipc-test-client.c | 321 ++++++++++++++++++++++++++++
 3 files changed, 335 insertions(+)
 create mode 100644 sound/soc/sof/sof-ipc-test-client.c

diff --git a/sound/soc/sof/Kconfig b/sound/soc/sof/Kconfig
index 31e9911098fc..13bde36cc5d7 100644
--- a/sound/soc/sof/Kconfig
+++ b/sound/soc/sof/Kconfig
@@ -190,6 +190,16 @@ config SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST
 	  Say Y if you want to enable IPC flood test.
 	  If unsure, select "N".
 
+config SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT
+	tristate "SOF enable IPC flood test client"
+	depends on SND_SOC_SOF_CLIENT
+	help
+	  This option enables a separate client device for IPC flood test
+	  which can be used to flood the DSP with test IPCs and gather stats
+	  about response times.
+	  Say Y if you want to enable IPC flood test.
+	  If unsure, select "N".
+
 config SND_SOC_SOF_DEBUG_RETAIN_DSP_CONTEXT
 	bool "SOF retain DSP context on any FW exceptions"
 	help
diff --git a/sound/soc/sof/Makefile b/sound/soc/sof/Makefile
index 5e46f25a3851..baa93fe2cc9a 100644
--- a/sound/soc/sof/Makefile
+++ b/sound/soc/sof/Makefile
@@ -9,6 +9,8 @@ snd-sof-pci-objs := sof-pci-dev.o
 snd-sof-acpi-objs := sof-acpi-dev.o
 snd-sof-of-objs := sof-of-dev.o
 
+snd-sof-ipc-test-objs := sof-ipc-test-client.o
+
 snd-sof-nocodec-objs := nocodec.o
 
 obj-$(CONFIG_SND_SOC_SOF) += snd-sof.o
@@ -21,6 +23,8 @@ obj-$(CONFIG_SND_SOC_SOF_PCI) += snd-sof-pci.o
 
 obj-$(CONFIG_SND_SOC_SOF_CLIENT) += snd-sof-client.o
 
+obj-$(CONFIG_SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT) += snd-sof-ipc-test.o
+
 obj-$(CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL) += intel/
 obj-$(CONFIG_SND_SOC_SOF_IMX_TOPLEVEL) += imx/
 obj-$(CONFIG_SND_SOC_SOF_XTENSA) += xtensa/
diff --git a/sound/soc/sof/sof-ipc-test-client.c b/sound/soc/sof/sof-ipc-test-client.c
new file mode 100644
index 000000000000..b4d803b9139b
--- /dev/null
+++ b/sound/soc/sof/sof-ipc-test-client.c
@@ -0,0 +1,321 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Copyright(c) 2020 Intel Corporation. All rights reserved.
+//
+// Author: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
+//
+
+#include <linux/auxiliary_bus.h>
+#include <linux/completion.h>
+#include <linux/debugfs.h>
+#include <linux/ktime.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <sound/sof/header.h>
+#include "sof-client.h"
+
+#define MAX_IPC_FLOOD_DURATION_MS 1000
+#define MAX_IPC_FLOOD_COUNT 10000
+#define IPC_FLOOD_TEST_RESULT_LEN 512
+#define SOF_IPC_CLIENT_SUSPEND_DELAY_MS 3000
+
+struct sof_ipc_client_data {
+	struct dentry *dfs_root;
+	char *buf;
+};
+
+/*
+ * helper function to perform the flood test. Only one of the two params, ipc_duration_ms
+ * or ipc_count, will be non-zero and will determine the type of test
+ */
+static int sof_debug_ipc_flood_test(struct sof_client_dev *cdev, unsigned long ipc_duration_ms,
+				    unsigned long ipc_count)
+{
+	struct sof_ipc_client_data *ipc_client_data = cdev->data;
+	struct device *dev = &cdev->auxdev.dev;
+	struct sof_ipc_cmd_hdr hdr;
+	struct sof_ipc_reply reply;
+	u64 min_response_time = U64_MAX;
+	u64 avg_response_time = 0;
+	u64 max_response_time = 0;
+	ktime_t cur;
+	ktime_t test_end;
+	int i = 0;
+	int ret = 0;
+	bool end_test = false;
+
+	/* configure test IPC */
+	hdr.cmd = SOF_IPC_GLB_TEST_MSG | SOF_IPC_TEST_IPC_FLOOD;
+	hdr.size = sizeof(hdr);
+
+	/* set test end time for duration flood test */
+	test_end = ktime_get_ns() + ipc_duration_ms * NSEC_PER_MSEC;
+
+	/* send test IPC's */
+	do {
+		ktime_t start;
+		u64 ipc_response_time;
+
+		start = ktime_get();
+		ret = sof_client_ipc_tx_message(cdev, hdr.cmd, &hdr, hdr.size, &reply,
+						sizeof(reply));
+		if (ret < 0)
+			break;
+		cur = ktime_get();
+
+		i++;
+
+		/* compute min and max response times */
+		ipc_response_time = ktime_to_ns(ktime_sub(cur, start));
+		min_response_time = min(min_response_time, ipc_response_time);
+		max_response_time = max(max_response_time, ipc_response_time);
+
+		/* sum up response times */
+		avg_response_time += ipc_response_time;
+
+		/* end test? */
+		if (ipc_count && i == ipc_count)
+			end_test = true;
+		else if (ipc_duration_ms && (ktime_to_ns(cur) >= test_end))
+			end_test = true;
+
+	} while (!end_test);
+
+	if (ret < 0)
+		return ret;
+
+	/* return if the first IPC fails */
+	if (!i)
+		return ret;
+
+	/* compute average response time */
+	DIV_ROUND_CLOSEST(avg_response_time, i);
+
+	/* clear previous test output */
+	memset(ipc_client_data->buf, 0, IPC_FLOOD_TEST_RESULT_LEN);
+
+	if (!ipc_count) {
+		dev_dbg(dev, "IPC Flood test duration: %lums\n", ipc_duration_ms);
+		snprintf(ipc_client_data->buf, IPC_FLOOD_TEST_RESULT_LEN,
+			 "IPC Flood test duration: %lums\n", ipc_duration_ms);
+	}
+
+	dev_dbg(dev,
+		"IPC Flood count: %d, Avg response time: %lluns\n", i, avg_response_time);
+	dev_dbg(dev, "Max response time: %lluns\n", max_response_time);
+	dev_dbg(dev, "Min response time: %lluns\n", min_response_time);
+
+	/* format output string and save test results */
+	snprintf(ipc_client_data->buf + strlen(ipc_client_data->buf),
+		 IPC_FLOOD_TEST_RESULT_LEN - strlen(ipc_client_data->buf),
+		 "IPC Flood count: %d\nAvg response time: %lluns\n", i, avg_response_time);
+
+	snprintf(ipc_client_data->buf + strlen(ipc_client_data->buf),
+		 IPC_FLOOD_TEST_RESULT_LEN - strlen(ipc_client_data->buf),
+		 "Max response time: %lluns\nMin response time: %lluns\n",
+		 max_response_time, min_response_time);
+
+	return ret;
+}
+
+/*
+ * Writing to the debugfs entry initiates the IPC flood test based on
+ * the IPC count or the duration specified by the user.
+ */
+static ssize_t sof_ipc_dfsentry_write(struct file *file, const char __user *buffer,
+				      size_t count, loff_t *ppos)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct sof_client_dev *cdev = file->private_data;
+	struct device *dev = &cdev->auxdev.dev;
+	unsigned long ipc_duration_ms = 0;
+	bool flood_duration_test;
+	unsigned long ipc_count = 0;
+	char *string;
+	size_t size;
+	int err;
+	int ret;
+
+	string = kzalloc(count, GFP_KERNEL);
+	if (!string)
+		return -ENOMEM;
+
+	size = simple_write_to_buffer(string, count, ppos, buffer, count);
+
+	flood_duration_test = !strcmp(dentry->d_name.name, "ipc_flood_duration_ms");
+
+	/* limit max duration/ipc count for flood test */
+	if (flood_duration_test) {
+		ret = kstrtoul(string, 0, &ipc_duration_ms);
+		if (ret < 0)
+			goto out;
+
+		if (!ipc_duration_ms) {
+			ret = size;
+			goto out;
+		}
+
+		ipc_duration_ms = min_t(unsigned long, ipc_duration_ms, MAX_IPC_FLOOD_DURATION_MS);
+	} else {
+		ret = kstrtoul(string, 0, &ipc_count);
+		if (ret < 0)
+			goto out;
+
+		if (!ipc_count) {
+			ret = size;
+			goto out;
+		}
+
+		ipc_count = min_t(unsigned long, ipc_count, MAX_IPC_FLOOD_COUNT);
+	}
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0 && ret != -EACCES) {
+		dev_err_ratelimited(dev, "error: debugfs write failed to resume %d\n", ret);
+		pm_runtime_put_noidle(dev);
+		goto out;
+	}
+
+	ret = sof_debug_ipc_flood_test(cdev, ipc_duration_ms, ipc_count);
+
+	pm_runtime_mark_last_busy(dev);
+	err = pm_runtime_put_autosuspend(dev);
+	if (err < 0) {
+		ret = err;
+		goto out;
+	}
+
+	/* return size if test is successful */
+	if (ret >= 0)
+		ret = size;
+out:
+	kfree(string);
+	return ret;
+}
+
+/* return the result of the last IPC flood test */
+static ssize_t sof_ipc_dfsentry_read(struct file *file, char __user *buffer,
+				     size_t count, loff_t *ppos)
+{
+	struct sof_client_dev *cdev = file->private_data;
+	struct sof_ipc_client_data *ipc_client_data = cdev->data;
+	size_t size_ret;
+
+	if (*ppos)
+		return 0;
+
+	/* return results of the last IPC test */
+	count = min_t(size_t, count, strlen(ipc_client_data->buf));
+	size_ret = copy_to_user(buffer, ipc_client_data->buf, count);
+	if (size_ret)
+		return -EFAULT;
+
+	*ppos += count;
+	return count;
+}
+
+static const struct file_operations sof_ipc_dfs_fops = {
+	.open = simple_open,
+	.read = sof_ipc_dfsentry_read,
+	.llseek = default_llseek,
+	.write = sof_ipc_dfsentry_write,
+};
+
+/*
+ * The IPC test client creates a couple of debugfs entries that will be used
+ * flood tests. Users can write to these entries to execute the IPC flood test
+ * by specifying either the number of IPCs to flood the DSP with or the duration
+ * (in ms) for which the DSP should be flooded with test IPCs. At the
+ * end of each test, the average, min and max response times are reported back.
+ * The results of the last flood test can be accessed by reading the debugfs
+ * entries.
+ */
+static int sof_ipc_test_probe(struct auxiliary_device *auxdev,
+			      const struct auxiliary_device_id *id)
+{
+	struct sof_client_dev *cdev = auxiliary_dev_to_sof_client_dev(auxdev);
+	struct sof_ipc_client_data *ipc_client_data;
+
+	/* allocate memory for client data */
+	ipc_client_data = devm_kzalloc(&auxdev->dev, sizeof(*ipc_client_data), GFP_KERNEL);
+	if (!ipc_client_data)
+		return -ENOMEM;
+
+	ipc_client_data->buf = devm_kzalloc(&auxdev->dev, IPC_FLOOD_TEST_RESULT_LEN, GFP_KERNEL);
+	if (!ipc_client_data->buf)
+		return -ENOMEM;
+
+	cdev->data = ipc_client_data;
+
+	/* create debugfs root folder with device name under parent SOF dir */
+	ipc_client_data->dfs_root = debugfs_create_dir(dev_name(&auxdev->dev),
+						       sof_client_get_debugfs_root(cdev));
+
+	/* create read-write ipc_flood_count debugfs entry */
+	debugfs_create_file("ipc_flood_count", 0644, ipc_client_data->dfs_root,
+			    cdev, &sof_ipc_dfs_fops);
+
+	/* create read-write ipc_flood_duration_ms debugfs entry */
+	debugfs_create_file("ipc_flood_duration_ms", 0644, ipc_client_data->dfs_root,
+			    cdev, &sof_ipc_dfs_fops);
+
+	/* enable runtime PM */
+	pm_runtime_set_autosuspend_delay(&auxdev->dev, SOF_IPC_CLIENT_SUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(&auxdev->dev);
+	pm_runtime_enable(&auxdev->dev);
+	pm_runtime_mark_last_busy(&auxdev->dev);
+	pm_runtime_idle(&auxdev->dev);
+
+	return 0;
+}
+
+static int sof_ipc_test_cleanup(struct auxiliary_device *auxdev)
+{
+	struct sof_client_dev *cdev = auxiliary_dev_to_sof_client_dev(auxdev);
+	struct sof_ipc_client_data *ipc_client_data = cdev->data;
+
+	pm_runtime_disable(&auxdev->dev);
+
+	debugfs_remove_recursive(ipc_client_data->dfs_root);
+
+	return 0;
+}
+
+static int sof_ipc_test_remove(struct auxiliary_device *auxdev)
+{
+	return sof_ipc_test_cleanup(auxdev);
+}
+
+static void sof_ipc_test_shutdown(struct auxiliary_device *auxdev)
+{
+	sof_ipc_test_cleanup(auxdev);
+}
+
+static const struct auxiliary_device_id sof_ipc_auxbus_id_table[] = {
+	{ .name = "snd_sof_client.ipc_test" },
+	{},
+};
+MODULE_DEVICE_TABLE(auxiliary, sof_ipc_auxbus_id_table);
+
+/*
+ * No need for driver pm_ops as the generic pm callbacks in the auxiliary bus type are enough to
+ * ensure that the parent SOF device resumes to bring the DSP back to D0.
+ * driver name will be set based on KBUILD_MODNAME.
+ */
+static struct sof_client_drv sof_ipc_test_client_drv = {
+	.auxiliary_drv = {
+		.id_table = sof_ipc_auxbus_id_table,
+		.probe = sof_ipc_test_probe,
+		.remove = sof_ipc_test_remove,
+		.shutdown = sof_ipc_test_shutdown,
+	},
+};
+
+module_sof_client_driver(sof_ipc_test_client_drv);
+
+MODULE_DESCRIPTION("SOF IPC Test Client Driver");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
-- 
2.26.2

