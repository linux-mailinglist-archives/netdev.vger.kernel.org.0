Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973681DAB48
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgETHCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:02:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:53335 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgETHCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:02:44 -0400
IronPort-SDR: n12DBYJMNqAMjC+HVbq+IKct6VgtsRvGybLzfUVdMubRVkkpvQmJBsytdIX5GE4ZsjSz610rbg
 Vm6L5Uc8vlrw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 00:02:32 -0700
IronPort-SDR: Sy2Njg4l2PVIcJPqF7VIqfBTphYX9MQvDO04TYdLIeAEURKLrCpxlsl/VydmCAif1HpVzLvnJ1
 iSCBqTyCHcgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="299841210"
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
Subject: [net-next v4 12/12] ASoC: SOF: ops: Add new op for client registration
Date:   Wed, 20 May 2020 00:02:27 -0700
Message-Id: <20200520070227.3392100-13-jeffrey.t.kirsher@intel.com>
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

Add a new op for registering clients. The clients to be
registered depend on the DSP capabilities and the ACPI/DT
information. For now, we only add 2 IPC test clients that
will be used for run tandem IPC flood tests for all Intel
platforms.

For ACPI platforms, change the Kconfig to select
SND_SOC_SOF_PROBE_WORK_QUEUE to allow the virtbus driver
to probe when the client is registered.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 sound/soc/sof/core.c        |  8 ++++++++
 sound/soc/sof/intel/Kconfig |  1 +
 sound/soc/sof/intel/apl.c   | 26 ++++++++++++++++++++++++++
 sound/soc/sof/intel/bdw.c   | 25 +++++++++++++++++++++++++
 sound/soc/sof/intel/byt.c   | 28 ++++++++++++++++++++++++++++
 sound/soc/sof/intel/cnl.c   | 26 ++++++++++++++++++++++++++
 sound/soc/sof/ops.h         | 34 ++++++++++++++++++++++++++++++++++
 sound/soc/sof/sof-priv.h    |  3 +++
 8 files changed, 151 insertions(+)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index fdfed157e6c0..a0382612b9e7 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -245,6 +245,12 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	if (plat_data->sof_probe_complete)
 		plat_data->sof_probe_complete(sdev->dev);
 
+	/*
+	 * Register client devices. This can fail but errors cannot be
+	 * propagated.
+	 */
+	snd_sof_register_clients(sdev);
+
 	return 0;
 
 fw_trace_err:
@@ -349,6 +355,7 @@ int snd_sof_device_remove(struct device *dev)
 		cancel_work_sync(&sdev->probe_work);
 
 	if (sdev->fw_state > SOF_FW_BOOT_NOT_STARTED) {
+		snd_sof_unregister_clients(sdev);
 		snd_sof_fw_unload(sdev);
 		snd_sof_ipc_free(sdev);
 		snd_sof_free_debug(sdev);
@@ -382,4 +389,5 @@ EXPORT_SYMBOL(snd_sof_device_remove);
 MODULE_AUTHOR("Liam Girdwood");
 MODULE_DESCRIPTION("Sound Open Firmware (SOF) Core");
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
 MODULE_ALIAS("platform:sof-audio");
diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index c9a2bee4b55c..002fd426ee53 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -13,6 +13,7 @@ config SND_SOC_SOF_INTEL_ACPI
 	def_tristate SND_SOC_SOF_ACPI
 	select SND_SOC_SOF_BAYTRAIL  if SND_SOC_SOF_BAYTRAIL_SUPPORT
 	select SND_SOC_SOF_BROADWELL if SND_SOC_SOF_BROADWELL_SUPPORT
+	select SND_SOC_SOF_PROBE_WORK_QUEUE if SND_SOC_SOF_CLIENT
 	help
 	  This option is not user-selectable but automagically handled by
 	  'select' statements at a higher level
diff --git a/sound/soc/sof/intel/apl.c b/sound/soc/sof/intel/apl.c
index 02218d22e51f..547b2b0ccb9a 100644
--- a/sound/soc/sof/intel/apl.c
+++ b/sound/soc/sof/intel/apl.c
@@ -15,9 +15,13 @@
  * Hardware interface for audio DSP on Apollolake and GeminiLake
  */
 
+#include <linux/module.h>
 #include "../sof-priv.h"
 #include "hda.h"
 #include "../sof-audio.h"
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+#include "../sof-client.h"
+#endif
 
 static const struct snd_sof_debugfs_map apl_dsp_debugfs[] = {
 	{"hda", HDA_DSP_HDA_BAR, 0, 0x4000, SOF_DEBUGFS_ACCESS_ALWAYS},
@@ -25,6 +29,24 @@ static const struct snd_sof_debugfs_map apl_dsp_debugfs[] = {
 	{"dsp", HDA_DSP_BAR,  0, 0x10000, SOF_DEBUGFS_ACCESS_ALWAYS},
 };
 
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+static void apl_register_clients(struct snd_sof_dev *sdev)
+{
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT)
+	/*
+	 * Register 2 IPC clients to facilitate tandem flood test.
+	 * The device name below is appended with the device ID assigned
+	 * automatically when the virtbus device is registered making
+	 * them unique.
+	 */
+	sof_client_dev_register(sdev, "sof-ipc-test");
+	sof_client_dev_register(sdev, "sof-ipc-test");
+#endif
+}
+#else
+static void apl_register_clients(struct snd_sof_dev *sdev) {}
+#endif
+
 /* apollolake ops */
 const struct snd_sof_dsp_ops sof_apl_ops = {
 	/* probe and remove */
@@ -101,6 +123,9 @@ const struct snd_sof_dsp_ops sof_apl_ops = {
 	.trace_release = hda_dsp_trace_release,
 	.trace_trigger = hda_dsp_trace_trigger,
 
+	/* client register */
+	.register_clients = apl_register_clients,
+
 	/* DAI drivers */
 	.drv		= skl_dai,
 	.num_drv	= SOF_SKL_NUM_DAIS,
@@ -140,3 +165,4 @@ const struct sof_intel_dsp_desc apl_chip_info = {
 	.ssp_base_offset = APL_SSP_BASE_OFFSET,
 };
 EXPORT_SYMBOL_NS(apl_chip_info, SND_SOC_SOF_INTEL_HDA_COMMON);
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
diff --git a/sound/soc/sof/intel/bdw.c b/sound/soc/sof/intel/bdw.c
index a32a3ef78ec5..62617f3c40f8 100644
--- a/sound/soc/sof/intel/bdw.c
+++ b/sound/soc/sof/intel/bdw.c
@@ -18,6 +18,9 @@
 #include "../ops.h"
 #include "shim.h"
 #include "../sof-audio.h"
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+#include "../sof-client.h"
+#endif
 
 /* BARs */
 #define BDW_DSP_BAR 0
@@ -563,6 +566,24 @@ static void bdw_set_mach_params(const struct snd_soc_acpi_mach *mach,
 	mach_params->platform = dev_name(dev);
 }
 
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+static void bdw_register_clients(struct snd_sof_dev *sdev)
+{
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT)
+	/*
+	 * Register 2 IPC clients to facilitate tandem flood test.
+	 * The device name below is appended with the device ID assigned
+	 * automatically when the virtbus device is registered making
+	 * them unique.
+	 */
+	sof_client_dev_register(sdev, "sof-ipc-test");
+	sof_client_dev_register(sdev, "sof-ipc-test");
+#endif
+}
+#else
+static void bdw_register_clients(struct snd_sof_dev *sdev) {}
+#endif
+
 /* Broadwell DAIs */
 static struct snd_soc_dai_driver bdw_dai[] = {
 {
@@ -638,6 +659,9 @@ const struct snd_sof_dsp_ops sof_bdw_ops = {
 	/*Firmware loading */
 	.load_firmware	= snd_sof_load_firmware_memcpy,
 
+	/* client register */
+	.register_clients = bdw_register_clients,
+
 	/* DAI drivers */
 	.drv = bdw_dai,
 	.num_drv = ARRAY_SIZE(bdw_dai),
@@ -662,3 +686,4 @@ EXPORT_SYMBOL_NS(bdw_chip_info, SND_SOC_SOF_BROADWELL);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_HIFI_EP_IPC);
 MODULE_IMPORT_NS(SND_SOC_SOF_XTENSA);
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
diff --git a/sound/soc/sof/intel/byt.c b/sound/soc/sof/intel/byt.c
index 29fd1d86156c..76263596917f 100644
--- a/sound/soc/sof/intel/byt.c
+++ b/sound/soc/sof/intel/byt.c
@@ -19,6 +19,9 @@
 #include "shim.h"
 #include "../sof-audio.h"
 #include "../../intel/common/soc-intel-quirks.h"
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+#include "../sof-client.h"
+#endif
 
 /* DSP memories */
 #define IRAM_OFFSET		0x0C0000
@@ -779,6 +782,24 @@ static int byt_acpi_probe(struct snd_sof_dev *sdev)
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+static void byt_register_clients(struct snd_sof_dev *sdev)
+{
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT)
+	/*
+	 * Register 2 IPC clients to facilitate tandem flood test.
+	 * The device name below is appended with the device ID assigned
+	 * automatically when the virtbus device is registered making
+	 * them unique.
+	 */
+	sof_client_dev_register(sdev, "sof-ipc-test");
+	sof_client_dev_register(sdev, "sof-ipc-test");
+#endif
+}
+#else
+static void byt_register_clients(struct snd_sof_dev *sdev) {}
+#endif
+
 /* baytrail ops */
 const struct snd_sof_dsp_ops sof_byt_ops = {
 	/* device init */
@@ -832,6 +853,9 @@ const struct snd_sof_dsp_ops sof_byt_ops = {
 	/*Firmware loading */
 	.load_firmware	= snd_sof_load_firmware_memcpy,
 
+	/* client register */
+	.register_clients = byt_register_clients,
+
 	/* DAI drivers */
 	.drv = byt_dai,
 	.num_drv = 3, /* we have only 3 SSPs on byt*/
@@ -906,6 +930,9 @@ const struct snd_sof_dsp_ops sof_cht_ops = {
 	/*Firmware loading */
 	.load_firmware	= snd_sof_load_firmware_memcpy,
 
+	/* client register */
+	.register_clients = byt_register_clients,
+
 	/* DAI drivers */
 	.drv = byt_dai,
 	/* all 6 SSPs may be available for cherrytrail */
@@ -933,3 +960,4 @@ EXPORT_SYMBOL_NS(cht_chip_info, SND_SOC_SOF_BAYTRAIL);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_HIFI_EP_IPC);
 MODULE_IMPORT_NS(SND_SOC_SOF_XTENSA);
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
diff --git a/sound/soc/sof/intel/cnl.c b/sound/soc/sof/intel/cnl.c
index e427d00eca71..0eedb39e1c89 100644
--- a/sound/soc/sof/intel/cnl.c
+++ b/sound/soc/sof/intel/cnl.c
@@ -15,10 +15,14 @@
  * Hardware interface for audio DSP on Cannonlake.
  */
 
+#include <linux/module.h>
 #include "../ops.h"
 #include "hda.h"
 #include "hda-ipc.h"
 #include "../sof-audio.h"
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+#include "../sof-client.h"
+#endif
 
 static const struct snd_sof_debugfs_map cnl_dsp_debugfs[] = {
 	{"hda", HDA_DSP_HDA_BAR, 0, 0x4000, SOF_DEBUGFS_ACCESS_ALWAYS},
@@ -231,6 +235,24 @@ static void cnl_ipc_dump(struct snd_sof_dev *sdev)
 		hipcida, hipctdr, hipcctl);
 }
 
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+static void cnl_register_clients(struct snd_sof_dev *sdev)
+{
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT)
+	/*
+	 * Register 2 IPC clients to facilitate tandem flood test.
+	 * The device name below is appended with the device ID assigned
+	 * automatically when the virtbus device is registered making
+	 * them unique.
+	 */
+	sof_client_dev_register(sdev, "sof-ipc-test");
+	sof_client_dev_register(sdev, "sof-ipc-test");
+#endif
+}
+#else
+static void cnl_register_clients(struct snd_sof_dev *sdev) {}
+#endif
+
 /* cannonlake ops */
 const struct snd_sof_dsp_ops sof_cnl_ops = {
 	/* probe and remove */
@@ -307,6 +329,9 @@ const struct snd_sof_dsp_ops sof_cnl_ops = {
 	.trace_release = hda_dsp_trace_release,
 	.trace_trigger = hda_dsp_trace_trigger,
 
+	/* client register */
+	.register_clients = cnl_register_clients,
+
 	/* DAI drivers */
 	.drv		= skl_dai,
 	.num_drv	= SOF_SKL_NUM_DAIS,
@@ -417,3 +442,4 @@ const struct sof_intel_dsp_desc jsl_chip_info = {
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
 };
 EXPORT_SYMBOL_NS(jsl_chip_info, SND_SOC_SOF_INTEL_HDA_COMMON);
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
diff --git a/sound/soc/sof/ops.h b/sound/soc/sof/ops.h
index a771500ac442..36b379078b03 100644
--- a/sound/soc/sof/ops.h
+++ b/sound/soc/sof/ops.h
@@ -14,9 +14,14 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 #include <sound/pcm.h>
 #include "sof-priv.h"
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+#include "sof-client.h"
+#endif
 
 #define sof_ops(sdev) \
 	((sdev)->pdata->desc->ops)
@@ -470,6 +475,35 @@ snd_sof_set_mach_params(const struct snd_soc_acpi_mach *mach,
 		sof_ops(sdev)->set_mach_params(mach, dev);
 }
 
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_CLIENT)
+static inline void
+snd_sof_register_clients(struct snd_sof_dev *sdev)
+{
+	if (sof_ops(sdev) && sof_ops(sdev)->register_clients)
+		sof_ops(sdev)->register_clients(sdev);
+}
+
+static inline void
+snd_sof_unregister_clients(struct snd_sof_dev *sdev)
+{
+	struct sof_client_dev *cdev, *_cdev;
+
+	/* unregister client devices */
+	mutex_lock(&sdev->client_mutex);
+	list_for_each_entry_safe(cdev, _cdev, &sdev->client_list, list) {
+		sof_client_dev_unregister(cdev);
+		list_del(&cdev->list);
+	}
+	mutex_unlock(&sdev->client_mutex);
+}
+#else
+static inline void
+snd_sof_register_clients(struct snd_sof_dev *sdev) {}
+
+static inline void
+snd_sof_unregister_clients(struct snd_sof_dev *sdev) {}
+#endif
+
 static inline const struct snd_sof_dsp_ops
 *sof_get_ops(const struct sof_dev_desc *d,
 	     const struct sof_ops_table mach_ops[], int asize)
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index 9da7f6f45362..0fdd9c5d872c 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -249,6 +249,9 @@ struct snd_sof_dsp_ops {
 	void (*set_mach_params)(const struct snd_soc_acpi_mach *mach,
 				struct device *dev); /* optional */
 
+	/* client ops */
+	void (*register_clients)(struct snd_sof_dev *sdev); /* optional */
+
 	/* DAI ops */
 	struct snd_soc_dai_driver *drv;
 	int num_drv;
-- 
2.26.2

