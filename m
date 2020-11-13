Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71F42B2003
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgKMQVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:21:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:45999 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgKMQVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:21:47 -0500
IronPort-SDR: 8WcRVJSKgPwCeqIFjRupTkxp9/SPAi/PmwtEldJctt2CanVEY9JAQJyaot15OM31tNuzQs9Hyz
 tlyphuSLB86w==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="158272292"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="158272292"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:44 -0800
IronPort-SDR: 9o7tiRSWg8WbO6jOmQ+TnU4AhGvhsSpMN1czyp/ioiLQkDNdbXeenEvSsJMmzLAuNTdSQWGCh/
 IwwEI7u3eIDQ==
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="366767241"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:43 -0800
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
Subject: [PATCH v4 05/10] ASoC: SOF: Intel: Define ops for client registration
Date:   Fri, 13 Nov 2020 08:18:54 -0800
Message-Id: <20201113161859.1775473-6-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113161859.1775473-1-david.m.ertman@intel.com>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

Define client ops for Intel platforms. For now, we only add
2 IPC test clients that will be used for run tandem IPC flood
tests for.

For ACPI platforms, change the Kconfig to select
SND_SOC_SOF_PROBE_WORK_QUEUE to allow the ancillary driver
to probe when the client is registered.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 sound/soc/sof/intel/Kconfig        |  9 +++++++
 sound/soc/sof/intel/Makefile       |  3 +++
 sound/soc/sof/intel/apl.c          | 16 ++++++++++++
 sound/soc/sof/intel/bdw.c          | 16 ++++++++++++
 sound/soc/sof/intel/byt.c          | 20 +++++++++++++++
 sound/soc/sof/intel/cnl.c          | 16 ++++++++++++
 sound/soc/sof/intel/intel-client.c | 40 ++++++++++++++++++++++++++++++
 sound/soc/sof/intel/intel-client.h | 26 +++++++++++++++++++
 8 files changed, 146 insertions(+)
 create mode 100644 sound/soc/sof/intel/intel-client.c
 create mode 100644 sound/soc/sof/intel/intel-client.h

diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index a066e08860cb..b449fa2f8005 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -13,6 +13,8 @@ config SND_SOC_SOF_INTEL_ACPI
 	def_tristate SND_SOC_SOF_ACPI
 	select SND_SOC_SOF_BAYTRAIL  if SND_SOC_SOF_BAYTRAIL_SUPPORT
 	select SND_SOC_SOF_BROADWELL if SND_SOC_SOF_BROADWELL_SUPPORT
+	select SND_SOC_SOF_PROBE_WORK_QUEUE if SND_SOC_SOF_CLIENT
+	select SND_SOC_SOF_INTEL_CLIENT if SND_SOC_SOF_CLIENT
 	help
 	  This option is not user-selectable but automagically handled by
 	  'select' statements at a higher level
@@ -29,6 +31,7 @@ config SND_SOC_SOF_INTEL_PCI
 	select SND_SOC_SOF_TIGERLAKE   if SND_SOC_SOF_TIGERLAKE_SUPPORT
 	select SND_SOC_SOF_ELKHARTLAKE if SND_SOC_SOF_ELKHARTLAKE_SUPPORT
 	select SND_SOC_SOF_JASPERLAKE  if SND_SOC_SOF_JASPERLAKE_SUPPORT
+	select SND_SOC_SOF_INTEL_CLIENT if SND_SOC_SOF_CLIENT
 	help
 	  This option is not user-selectable but automagically handled by
 	  'select' statements at a higher level
@@ -57,6 +60,12 @@ config SND_SOC_SOF_INTEL_COMMON
 	  This option is not user-selectable but automagically handled by
 	  'select' statements at a higher level
 
+config SND_SOC_SOF_INTEL_CLIENT
+	tristate
+	help
+	  This option is not user-selectable but automagically handled by
+	  'select' statements at a higher level.
+
 if SND_SOC_SOF_INTEL_ACPI
 
 config SND_SOC_SOF_BAYTRAIL_SUPPORT
diff --git a/sound/soc/sof/intel/Makefile b/sound/soc/sof/intel/Makefile
index 72d85b25df7d..683e64c627c1 100644
--- a/sound/soc/sof/intel/Makefile
+++ b/sound/soc/sof/intel/Makefile
@@ -5,6 +5,8 @@ snd-sof-intel-bdw-objs := bdw.o
 
 snd-sof-intel-ipc-objs := intel-ipc.o
 
+snd-sof-intel-client-objs := intel-client.o
+
 snd-sof-intel-hda-common-objs := hda.o hda-loader.o hda-stream.o hda-trace.o \
 				 hda-dsp.o hda-ipc.o hda-ctrl.o hda-pcm.o \
 				 hda-dai.o hda-bus.o \
@@ -18,3 +20,4 @@ obj-$(CONFIG_SND_SOC_SOF_BROADWELL) += snd-sof-intel-bdw.o
 obj-$(CONFIG_SND_SOC_SOF_INTEL_HIFI_EP_IPC) += snd-sof-intel-ipc.o
 obj-$(CONFIG_SND_SOC_SOF_HDA_COMMON) += snd-sof-intel-hda-common.o
 obj-$(CONFIG_SND_SOC_SOF_HDA) += snd-sof-intel-hda.o
+obj-$(CONFIG_SND_SOC_SOF_INTEL_CLIENT) += snd-sof-intel-client.o
diff --git a/sound/soc/sof/intel/apl.c b/sound/soc/sof/intel/apl.c
index 4eeade2e77f7..ce2dcd6aa7de 100644
--- a/sound/soc/sof/intel/apl.c
+++ b/sound/soc/sof/intel/apl.c
@@ -18,6 +18,7 @@
 #include "../sof-priv.h"
 #include "hda.h"
 #include "../sof-audio.h"
+#include "intel-client.h"
 
 static const struct snd_sof_debugfs_map apl_dsp_debugfs[] = {
 	{"hda", HDA_DSP_HDA_BAR, 0, 0x4000, SOF_DEBUGFS_ACCESS_ALWAYS},
@@ -25,6 +26,16 @@ static const struct snd_sof_debugfs_map apl_dsp_debugfs[] = {
 	{"dsp", HDA_DSP_BAR,  0, 0x10000, SOF_DEBUGFS_ACCESS_ALWAYS},
 };
 
+static int apl_register_clients(struct snd_sof_dev *sdev)
+{
+	return intel_register_ipc_test_clients(sdev);
+}
+
+static void apl_unregister_clients(struct snd_sof_dev *sdev)
+{
+	intel_unregister_ipc_test_clients(sdev);
+}
+
 /* apollolake ops */
 const struct snd_sof_dsp_ops sof_apl_ops = {
 	/* probe and remove */
@@ -101,6 +112,10 @@ const struct snd_sof_dsp_ops sof_apl_ops = {
 	.trace_release = hda_dsp_trace_release,
 	.trace_trigger = hda_dsp_trace_trigger,
 
+	/* client ops */
+	.register_clients = apl_register_clients,
+	.unregister_clients = apl_unregister_clients,
+
 	/* DAI drivers */
 	.drv		= skl_dai,
 	.num_drv	= SOF_SKL_NUM_DAIS,
@@ -140,3 +155,4 @@ const struct sof_intel_dsp_desc apl_chip_info = {
 	.ssp_base_offset = APL_SSP_BASE_OFFSET,
 };
 EXPORT_SYMBOL_NS(apl_chip_info, SND_SOC_SOF_INTEL_HDA_COMMON);
+MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_CLIENT);
diff --git a/sound/soc/sof/intel/bdw.c b/sound/soc/sof/intel/bdw.c
index 50a4a73e6b9f..d6fb5e228e93 100644
--- a/sound/soc/sof/intel/bdw.c
+++ b/sound/soc/sof/intel/bdw.c
@@ -18,6 +18,7 @@
 #include "../ops.h"
 #include "shim.h"
 #include "../sof-audio.h"
+#include "intel-client.h"
 
 /* BARs */
 #define BDW_DSP_BAR 0
@@ -563,6 +564,16 @@ static void bdw_set_mach_params(const struct snd_soc_acpi_mach *mach,
 	mach_params->platform = dev_name(dev);
 }
 
+static int bdw_register_clients(struct snd_sof_dev *sdev)
+{
+	return intel_register_ipc_test_clients(sdev);
+}
+
+static void bdw_unregister_clients(struct snd_sof_dev *sdev)
+{
+	intel_unregister_ipc_test_clients(sdev);
+}
+
 /* Broadwell DAIs */
 static struct snd_soc_dai_driver bdw_dai[] = {
 {
@@ -638,6 +649,10 @@ const struct snd_sof_dsp_ops sof_bdw_ops = {
 	/*Firmware loading */
 	.load_firmware	= snd_sof_load_firmware_memcpy,
 
+	/* client ops */
+	.register_clients = bdw_register_clients,
+	.unregister_clients = bdw_unregister_clients,
+
 	/* DAI drivers */
 	.drv = bdw_dai,
 	.num_drv = ARRAY_SIZE(bdw_dai),
@@ -662,3 +677,4 @@ EXPORT_SYMBOL_NS(bdw_chip_info, SND_SOC_SOF_BROADWELL);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_HIFI_EP_IPC);
 MODULE_IMPORT_NS(SND_SOC_SOF_XTENSA);
+MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_CLIENT);
diff --git a/sound/soc/sof/intel/byt.c b/sound/soc/sof/intel/byt.c
index 186736ee5fc2..a42820606ace 100644
--- a/sound/soc/sof/intel/byt.c
+++ b/sound/soc/sof/intel/byt.c
@@ -19,6 +19,7 @@
 #include "shim.h"
 #include "../sof-audio.h"
 #include "../../intel/common/soc-intel-quirks.h"
+#include "intel-client.h"
 
 /* DSP memories */
 #define IRAM_OFFSET		0x0C0000
@@ -821,6 +822,16 @@ static int byt_acpi_probe(struct snd_sof_dev *sdev)
 	return ret;
 }
 
+static int byt_register_clients(struct snd_sof_dev *sdev)
+{
+	return intel_register_ipc_test_clients(sdev);
+}
+
+static void byt_unregister_clients(struct snd_sof_dev *sdev)
+{
+	intel_unregister_ipc_test_clients(sdev);
+}
+
 /* baytrail ops */
 const struct snd_sof_dsp_ops sof_byt_ops = {
 	/* device init */
@@ -879,6 +890,10 @@ const struct snd_sof_dsp_ops sof_byt_ops = {
 	.suspend = byt_suspend,
 	.resume = byt_resume,
 
+	/* client ops */
+	.register_clients = byt_register_clients,
+	.unregister_clients = byt_unregister_clients,
+
 	/* DAI drivers */
 	.drv = byt_dai,
 	.num_drv = 3, /* we have only 3 SSPs on byt*/
@@ -958,6 +973,10 @@ const struct snd_sof_dsp_ops sof_cht_ops = {
 	.suspend = byt_suspend,
 	.resume = byt_resume,
 
+	/* client ops */
+	.register_clients = byt_register_clients,
+	.unregister_clients = byt_unregister_clients,
+
 	/* DAI drivers */
 	.drv = byt_dai,
 	/* all 6 SSPs may be available for cherrytrail */
@@ -985,3 +1004,4 @@ EXPORT_SYMBOL_NS(cht_chip_info, SND_SOC_SOF_BAYTRAIL);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_HIFI_EP_IPC);
 MODULE_IMPORT_NS(SND_SOC_SOF_XTENSA);
+MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_CLIENT);
diff --git a/sound/soc/sof/intel/cnl.c b/sound/soc/sof/intel/cnl.c
index a5d3258104c0..20afb622c315 100644
--- a/sound/soc/sof/intel/cnl.c
+++ b/sound/soc/sof/intel/cnl.c
@@ -19,6 +19,7 @@
 #include "hda.h"
 #include "hda-ipc.h"
 #include "../sof-audio.h"
+#include "intel-client.h"
 
 static const struct snd_sof_debugfs_map cnl_dsp_debugfs[] = {
 	{"hda", HDA_DSP_HDA_BAR, 0, 0x4000, SOF_DEBUGFS_ACCESS_ALWAYS},
@@ -230,6 +231,16 @@ void cnl_ipc_dump(struct snd_sof_dev *sdev)
 		hipcida, hipctdr, hipcctl);
 }
 
+static int cnl_register_clients(struct snd_sof_dev *sdev)
+{
+	return intel_register_ipc_test_clients(sdev);
+}
+
+static void cnl_unregister_clients(struct snd_sof_dev *sdev)
+{
+	intel_unregister_ipc_test_clients(sdev);
+}
+
 /* cannonlake ops */
 const struct snd_sof_dsp_ops sof_cnl_ops = {
 	/* probe and remove */
@@ -306,6 +317,10 @@ const struct snd_sof_dsp_ops sof_cnl_ops = {
 	.trace_release = hda_dsp_trace_release,
 	.trace_trigger = hda_dsp_trace_trigger,
 
+	/* client ops */
+	.register_clients = cnl_register_clients,
+	.unregister_clients = cnl_unregister_clients,
+
 	/* DAI drivers */
 	.drv		= skl_dai,
 	.num_drv	= SOF_SKL_NUM_DAIS,
@@ -393,3 +408,4 @@ const struct sof_intel_dsp_desc jsl_chip_info = {
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
 };
 EXPORT_SYMBOL_NS(jsl_chip_info, SND_SOC_SOF_INTEL_HDA_COMMON);
+MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_CLIENT);
diff --git a/sound/soc/sof/intel/intel-client.c b/sound/soc/sof/intel/intel-client.c
new file mode 100644
index 000000000000..a612de365fc5
--- /dev/null
+++ b/sound/soc/sof/intel/intel-client.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Copyright(c) 2020 Intel Corporation. All rights reserved.
+//
+// Author: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
+//
+
+#include <linux/module.h>
+#include "../sof-priv.h"
+#include "../sof-client.h"
+#include "intel-client.h"
+
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT)
+int intel_register_ipc_test_clients(struct snd_sof_dev *sdev)
+{
+	int ret;
+
+	/*
+	 * Register 2 IPC clients to facilitate tandem flood test. The device name below is
+	 * appended with the device ID assigned automatically when the auxiliary device is
+	 * registered making them unique.
+	 */
+	ret = sof_client_dev_register(sdev, "ipc_test", 0);
+	if (ret < 0)
+		return ret;
+
+	return sof_client_dev_register(sdev, "ipc_test", 1);
+}
+EXPORT_SYMBOL_NS_GPL(intel_register_ipc_test_clients, SND_SOC_SOF_INTEL_CLIENT);
+
+void intel_unregister_ipc_test_clients(struct snd_sof_dev *sdev)
+{
+	sof_client_dev_unregister(sdev, "ipc_test", 0);
+	sof_client_dev_unregister(sdev, "ipc_test", 1);
+}
+EXPORT_SYMBOL_NS_GPL(intel_unregister_ipc_test_clients, SND_SOC_SOF_INTEL_CLIENT);
+#endif
+
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
diff --git a/sound/soc/sof/intel/intel-client.h b/sound/soc/sof/intel/intel-client.h
new file mode 100644
index 000000000000..49b2c6c0dcc4
--- /dev/null
+++ b/sound/soc/sof/intel/intel-client.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * Copyright(c) 2020 Intel Corporation. All rights reserved.
+ *
+ * Author: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
+ */
+
+#ifndef __INTEL_CLIENT_H
+#define __INTEL_CLIENT_H
+
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT)
+int intel_register_ipc_test_clients(struct snd_sof_dev *sdev);
+void intel_unregister_ipc_test_clients(struct snd_sof_dev *sdev);
+#else
+static inline int intel_register_ipc_test_clients(struct snd_sof_dev *sdev)
+{
+	return 0;
+}
+
+static void intel_unregister_ipc_test_clients(struct snd_sof_dev *sdev) {}
+#endif
+
+#endif
-- 
2.26.2

