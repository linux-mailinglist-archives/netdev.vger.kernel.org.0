Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BFA2B2004
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgKMQVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:21:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:10822 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKMQVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:21:49 -0500
IronPort-SDR: YiFnMhggJKtxfLMUPeqs6m+zhFziFG5injoGZSd6uqyjuWdkf51Qzvt9kpih6rENymktR25yLK
 wm9DtJ2ysX+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="170664314"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="170664314"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:47 -0800
IronPort-SDR: SoRSMv29Z2vcHHCjRWHc+mKD1MCzIeERDyo9nLJGWz3jQSFs0CpsUsR2PtAgpTIeG2TngB9x1c
 THBlCZsAi59g==
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="366767259"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:46 -0800
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
Subject: [PATCH v4 09/10] ASoC: SOF: Add new client driver for probes support
Date:   Fri, 13 Nov 2020 08:18:58 -0800
Message-Id: <20201113161859.1775473-10-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113161859.1775473-1-david.m.ertman@intel.com>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

Add a new client driver for probes support and move
all the probes-related code from the core to the
client driver.

The probes client driver registers a component driver
with one CPU DAI driver for extraction and creates a
new sound card with one DUMMY DAI link with a dummy codec
that will be used for extracting audio data from specific
points in the audio pipeline.

The probes debugfs ops are based on the initial
implementation by Cezary Rojewski and have been moved
out of the SOF core into the client driver making it
easier to maintain. This change will make it easier
for the probes functionality to be added for all platforms
without having the need to modify the existing(15+) machine
drivers.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 sound/soc/sof/Kconfig             |  18 +-
 sound/soc/sof/Makefile            |   3 +-
 sound/soc/sof/compress.c          |  51 ++--
 sound/soc/sof/core.c              |   6 -
 sound/soc/sof/debug.c             | 227 ----------------
 sound/soc/sof/intel/hda-dai.c     |  15 --
 sound/soc/sof/intel/hda.h         |   6 -
 sound/soc/sof/pcm.c               |  11 -
 sound/soc/sof/probe.c             | 124 ++++-----
 sound/soc/sof/probe.h             |  41 +--
 sound/soc/sof/sof-priv.h          |   4 -
 sound/soc/sof/sof-probes-client.c | 414 ++++++++++++++++++++++++++++++
 12 files changed, 545 insertions(+), 375 deletions(-)
 create mode 100644 sound/soc/sof/sof-probes-client.c

diff --git a/sound/soc/sof/Kconfig b/sound/soc/sof/Kconfig
index a0f9474b8143..9fa00780c842 100644
--- a/sound/soc/sof/Kconfig
+++ b/sound/soc/sof/Kconfig
@@ -42,13 +42,11 @@ config SND_SOC_SOF_OF
 	  Say Y if you need this option. If unsure select "N".
 
 config SND_SOC_SOF_DEBUG_PROBES
-	bool "SOF enable data probing"
+	bool
 	select SND_SOC_COMPRESS
 	help
-	  This option enables the data probing feature that can be used to
-	  gather data directly from specific points of the audio pipeline.
-	  Say Y if you want to enable probes.
-	  If unsure, select "N".
+	  This option is not user-selectable but automagically handled by
+	  'select' statements at a higher level.
 
 config SND_SOC_SOF_CLIENT
 	tristate
@@ -192,6 +190,15 @@ config SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT
 	  Say Y if you want to enable IPC flood test.
 	  If unsure, select "N".
 
+config SND_SOC_SOF_DEBUG_PROBES_CLIENT
+	tristate "SOF enable data probing"
+	depends on SND_SOC_SOF_CLIENT
+	help
+	  This option enables the data probing feature that can be used to
+	  gather data directly from specific points of the audio pipeline.
+	  Say Y if you want to enable probes.
+	  If unsure, select "N".
+
 config SND_SOC_SOF_DEBUG_RETAIN_DSP_CONTEXT
 	bool "SOF retain DSP context on any FW exceptions"
 	help
@@ -207,6 +214,7 @@ endif ## SND_SOC_SOF_DEVELOPER_SUPPORT
 config SND_SOC_SOF
 	tristate
 	select SND_SOC_SOF_CLIENT if SND_SOC_SOF_CLIENT_SUPPORT
+	select SND_SOC_SOF_DEBUG_PROBES if SND_SOC_SOF_DEBUG_PROBES_CLIENT
 	select SND_SOC_TOPOLOGY
 	select SND_SOC_SOF_NOCODEC if SND_SOC_SOF_NOCODEC_SUPPORT
 	help
diff --git a/sound/soc/sof/Makefile b/sound/soc/sof/Makefile
index baa93fe2cc9a..cf49466f7910 100644
--- a/sound/soc/sof/Makefile
+++ b/sound/soc/sof/Makefile
@@ -3,7 +3,7 @@
 snd-sof-objs := core.o ops.o loader.o ipc.o pcm.o pm.o debug.o topology.o\
 		control.o trace.o utils.o sof-audio.o
 snd-sof-client-objs := sof-client.o
-snd-sof-$(CONFIG_SND_SOC_SOF_DEBUG_PROBES) += probe.o compress.o
+snd-sof-probes-objs := probe.o compress.o sof-probes-client.o
 
 snd-sof-pci-objs := sof-pci-dev.o
 snd-sof-acpi-objs := sof-acpi-dev.o
@@ -24,6 +24,7 @@ obj-$(CONFIG_SND_SOC_SOF_PCI) += snd-sof-pci.o
 obj-$(CONFIG_SND_SOC_SOF_CLIENT) += snd-sof-client.o
 
 obj-$(CONFIG_SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST_CLIENT) += snd-sof-ipc-test.o
+obj-$(CONFIG_SND_SOC_SOF_DEBUG_PROBES_CLIENT) += snd-sof-probes.o
 
 obj-$(CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL) += intel/
 obj-$(CONFIG_SND_SOC_SOF_IMX_TOPLEVEL) += imx/
diff --git a/sound/soc/sof/compress.c b/sound/soc/sof/compress.c
index 0443f171b4e7..bbb77f028e74 100644
--- a/sound/soc/sof/compress.c
+++ b/sound/soc/sof/compress.c
@@ -10,8 +10,8 @@
 
 #include <sound/soc.h>
 #include "compress.h"
-#include "ops.h"
 #include "probe.h"
+#include "sof-client.h"
 
 struct snd_soc_cdai_ops sof_probe_compr_ops = {
 	.startup	= sof_probe_compr_open,
@@ -30,17 +30,18 @@ EXPORT_SYMBOL(sof_probe_compressed_ops);
 int sof_probe_compr_open(struct snd_compr_stream *cstream,
 		struct snd_soc_dai *dai)
 {
-	struct snd_sof_dev *sdev =
-				snd_soc_component_get_drvdata(dai->component);
+	struct snd_soc_card *card = snd_soc_component_get_drvdata(dai->component);
+	struct sof_client_dev *cdev = snd_soc_card_get_drvdata(card);
+	struct sof_probes_data *probes_data = cdev->data;
 	int ret;
 
-	ret = snd_sof_probe_compr_assign(sdev, cstream, dai);
+	ret = sof_client_probe_compr_assign(cdev, cstream, dai);
 	if (ret < 0) {
 		dev_err(dai->dev, "Failed to assign probe stream: %d\n", ret);
 		return ret;
 	}
 
-	sdev->extractor_stream_tag = ret;
+	probes_data->extractor_stream_tag = ret;
 	return 0;
 }
 EXPORT_SYMBOL(sof_probe_compr_open);
@@ -48,55 +49,57 @@ EXPORT_SYMBOL(sof_probe_compr_open);
 int sof_probe_compr_free(struct snd_compr_stream *cstream,
 		struct snd_soc_dai *dai)
 {
-	struct snd_sof_dev *sdev =
-				snd_soc_component_get_drvdata(dai->component);
+	struct snd_soc_card *card = snd_soc_component_get_drvdata(dai->component);
+	struct sof_client_dev *cdev = snd_soc_card_get_drvdata(card);
+	struct sof_probes_data *probes_data = cdev->data;
 	struct sof_probe_point_desc *desc;
 	size_t num_desc;
 	int i, ret;
 
 	/* disconnect all probe points */
-	ret = sof_ipc_probe_points_info(sdev, &desc, &num_desc);
+	ret = sof_probe_points_info(cdev, &desc, &num_desc);
 	if (ret < 0) {
 		dev_err(dai->dev, "Failed to get probe points: %d\n", ret);
 		goto exit;
 	}
 
 	for (i = 0; i < num_desc; i++)
-		sof_ipc_probe_points_remove(sdev, &desc[i].buffer_id, 1);
+		sof_probe_points_remove(cdev, &desc[i].buffer_id, 1);
 	kfree(desc);
 
 exit:
-	ret = sof_ipc_probe_deinit(sdev);
+	ret = sof_probe_deinit(cdev);
 	if (ret < 0)
 		dev_err(dai->dev, "Failed to deinit probe: %d\n", ret);
 
-	sdev->extractor_stream_tag = SOF_PROBE_INVALID_NODE_ID;
+	probes_data->extractor_stream_tag = SOF_PROBE_INVALID_NODE_ID;
 	snd_compr_free_pages(cstream);
 
-	return snd_sof_probe_compr_free(sdev, cstream, dai);
+	return sof_client_probe_compr_free(cdev, cstream, dai);
 }
 EXPORT_SYMBOL(sof_probe_compr_free);
 
 int sof_probe_compr_set_params(struct snd_compr_stream *cstream,
 		struct snd_compr_params *params, struct snd_soc_dai *dai)
 {
+	struct snd_soc_card *card = snd_soc_component_get_drvdata(dai->component);
+	struct sof_client_dev *cdev = snd_soc_card_get_drvdata(card);
+	struct sof_probes_data *probes_data = cdev->data;
 	struct snd_compr_runtime *rtd = cstream->runtime;
-	struct snd_sof_dev *sdev =
-				snd_soc_component_get_drvdata(dai->component);
 	int ret;
 
 	cstream->dma_buffer.dev.type = SNDRV_DMA_TYPE_DEV_SG;
-	cstream->dma_buffer.dev.dev = sdev->dev;
+	cstream->dma_buffer.dev.dev = sof_client_get_dma_dev(cdev);
 	ret = snd_compr_malloc_pages(cstream, rtd->buffer_size);
 	if (ret < 0)
 		return ret;
 
-	ret = snd_sof_probe_compr_set_params(sdev, cstream, params, dai);
+	ret = sof_client_probe_compr_set_params(cdev, cstream, params, dai);
 	if (ret < 0)
 		return ret;
 
-	ret = sof_ipc_probe_init(sdev, sdev->extractor_stream_tag,
-				 rtd->dma_bytes);
+	ret = sof_probe_init(cdev, probes_data->extractor_stream_tag,
+			     rtd->dma_bytes);
 	if (ret < 0) {
 		dev_err(dai->dev, "Failed to init probe: %d\n", ret);
 		return ret;
@@ -109,20 +112,20 @@ EXPORT_SYMBOL(sof_probe_compr_set_params);
 int sof_probe_compr_trigger(struct snd_compr_stream *cstream, int cmd,
 		struct snd_soc_dai *dai)
 {
-	struct snd_sof_dev *sdev =
-				snd_soc_component_get_drvdata(dai->component);
+	struct snd_soc_card *card = snd_soc_component_get_drvdata(dai->component);
+	struct sof_client_dev *cdev = snd_soc_card_get_drvdata(card);
 
-	return snd_sof_probe_compr_trigger(sdev, cstream, cmd, dai);
+	return sof_client_probe_compr_trigger(cdev, cstream, cmd, dai);
 }
 EXPORT_SYMBOL(sof_probe_compr_trigger);
 
 int sof_probe_compr_pointer(struct snd_compr_stream *cstream,
 		struct snd_compr_tstamp *tstamp, struct snd_soc_dai *dai)
 {
-	struct snd_sof_dev *sdev =
-				snd_soc_component_get_drvdata(dai->component);
+	struct snd_soc_card *card = snd_soc_component_get_drvdata(dai->component);
+	struct sof_client_dev *cdev = snd_soc_card_get_drvdata(card);
 
-	return snd_sof_probe_compr_pointer(sdev, cstream, tstamp, dai);
+	return sof_client_probe_compr_pointer(cdev, cstream, tstamp, dai);
 }
 EXPORT_SYMBOL(sof_probe_compr_pointer);
 
diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index ddb9a12d5aac..9b72317d6525 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -14,9 +14,6 @@
 #include <sound/sof.h>
 #include "sof-priv.h"
 #include "ops.h"
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
-#include "probe.h"
-#endif
 
 /* see SOF_DBG_ flags */
 int sof_core_debug;
@@ -305,9 +302,6 @@ int snd_sof_device_probe(struct device *dev, struct snd_sof_pdata *plat_data)
 	sdev->pdata = plat_data;
 	sdev->first_boot = true;
 	sdev->fw_state = SOF_FW_BOOT_NOT_STARTED;
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
-	sdev->extractor_stream_tag = SOF_PROBE_INVALID_NODE_ID;
-#endif
 	dev_set_drvdata(dev, sdev);
 
 	/* check all mandatory ops */
diff --git a/sound/soc/sof/debug.c b/sound/soc/sof/debug.c
index d224641768da..234ae704c001 100644
--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -17,222 +17,6 @@
 #include "sof-priv.h"
 #include "ops.h"
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
-#include "probe.h"
-
-/**
- * strsplit_u32 - Split string into sequence of u32 tokens
- * @buf:	String to split into tokens.
- * @delim:	String containing delimiter characters.
- * @tkns:	Returned u32 sequence pointer.
- * @num_tkns:	Returned number of tokens obtained.
- */
-static int
-strsplit_u32(char **buf, const char *delim, u32 **tkns, size_t *num_tkns)
-{
-	char *s;
-	u32 *data, *tmp;
-	size_t count = 0;
-	size_t cap = 32;
-	int ret = 0;
-
-	*tkns = NULL;
-	*num_tkns = 0;
-	data = kcalloc(cap, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	while ((s = strsep(buf, delim)) != NULL) {
-		ret = kstrtouint(s, 0, data + count);
-		if (ret)
-			goto exit;
-		if (++count >= cap) {
-			cap *= 2;
-			tmp = krealloc(data, cap * sizeof(*data), GFP_KERNEL);
-			if (!tmp) {
-				ret = -ENOMEM;
-				goto exit;
-			}
-			data = tmp;
-		}
-	}
-
-	if (!count)
-		goto exit;
-	*tkns = kmemdup(data, count * sizeof(*data), GFP_KERNEL);
-	if (*tkns == NULL) {
-		ret = -ENOMEM;
-		goto exit;
-	}
-	*num_tkns = count;
-
-exit:
-	kfree(data);
-	return ret;
-}
-
-static int tokenize_input(const char __user *from, size_t count,
-		loff_t *ppos, u32 **tkns, size_t *num_tkns)
-{
-	char *buf;
-	int ret;
-
-	buf = kmalloc(count + 1, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	ret = simple_write_to_buffer(buf, count, ppos, from, count);
-	if (ret != count) {
-		ret = ret >= 0 ? -EIO : ret;
-		goto exit;
-	}
-
-	buf[count] = '\0';
-	ret = strsplit_u32((char **)&buf, ",", tkns, num_tkns);
-exit:
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t probe_points_read(struct file *file,
-		char __user *to, size_t count, loff_t *ppos)
-{
-	struct snd_sof_dfsentry *dfse = file->private_data;
-	struct snd_sof_dev *sdev = dfse->sdev;
-	struct sof_probe_point_desc *desc;
-	size_t num_desc, len = 0;
-	char *buf;
-	int i, ret;
-
-	if (sdev->extractor_stream_tag == SOF_PROBE_INVALID_NODE_ID) {
-		dev_warn(sdev->dev, "no extractor stream running\n");
-		return -ENOENT;
-	}
-
-	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	ret = sof_ipc_probe_points_info(sdev, &desc, &num_desc);
-	if (ret < 0)
-		goto exit;
-
-	for (i = 0; i < num_desc; i++) {
-		ret = snprintf(buf + len, PAGE_SIZE - len,
-			"Id: %#010x  Purpose: %d  Node id: %#x\n",
-			desc[i].buffer_id, desc[i].purpose, desc[i].stream_tag);
-		if (ret < 0)
-			goto free_desc;
-		len += ret;
-	}
-
-	ret = simple_read_from_buffer(to, count, ppos, buf, len);
-free_desc:
-	kfree(desc);
-exit:
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t probe_points_write(struct file *file,
-		const char __user *from, size_t count, loff_t *ppos)
-{
-	struct snd_sof_dfsentry *dfse = file->private_data;
-	struct snd_sof_dev *sdev = dfse->sdev;
-	struct sof_probe_point_desc *desc;
-	size_t num_tkns, bytes;
-	u32 *tkns;
-	int ret;
-
-	if (sdev->extractor_stream_tag == SOF_PROBE_INVALID_NODE_ID) {
-		dev_warn(sdev->dev, "no extractor stream running\n");
-		return -ENOENT;
-	}
-
-	ret = tokenize_input(from, count, ppos, &tkns, &num_tkns);
-	if (ret < 0)
-		return ret;
-	bytes = sizeof(*tkns) * num_tkns;
-	if (!num_tkns || (bytes % sizeof(*desc))) {
-		ret = -EINVAL;
-		goto exit;
-	}
-
-	desc = (struct sof_probe_point_desc *)tkns;
-	ret = sof_ipc_probe_points_add(sdev,
-			desc, bytes / sizeof(*desc));
-	if (!ret)
-		ret = count;
-exit:
-	kfree(tkns);
-	return ret;
-}
-
-static const struct file_operations probe_points_fops = {
-	.open = simple_open,
-	.read = probe_points_read,
-	.write = probe_points_write,
-	.llseek = default_llseek,
-};
-
-static ssize_t probe_points_remove_write(struct file *file,
-		const char __user *from, size_t count, loff_t *ppos)
-{
-	struct snd_sof_dfsentry *dfse = file->private_data;
-	struct snd_sof_dev *sdev = dfse->sdev;
-	size_t num_tkns;
-	u32 *tkns;
-	int ret;
-
-	if (sdev->extractor_stream_tag == SOF_PROBE_INVALID_NODE_ID) {
-		dev_warn(sdev->dev, "no extractor stream running\n");
-		return -ENOENT;
-	}
-
-	ret = tokenize_input(from, count, ppos, &tkns, &num_tkns);
-	if (ret < 0)
-		return ret;
-	if (!num_tkns) {
-		ret = -EINVAL;
-		goto exit;
-	}
-
-	ret = sof_ipc_probe_points_remove(sdev, tkns, num_tkns);
-	if (!ret)
-		ret = count;
-exit:
-	kfree(tkns);
-	return ret;
-}
-
-static const struct file_operations probe_points_remove_fops = {
-	.open = simple_open,
-	.write = probe_points_remove_write,
-	.llseek = default_llseek,
-};
-
-static int snd_sof_debugfs_probe_item(struct snd_sof_dev *sdev,
-				 const char *name, mode_t mode,
-				 const struct file_operations *fops)
-{
-	struct snd_sof_dfsentry *dfse;
-
-	dfse = devm_kzalloc(sdev->dev, sizeof(*dfse), GFP_KERNEL);
-	if (!dfse)
-		return -ENOMEM;
-
-	dfse->type = SOF_DFSENTRY_TYPE_BUF;
-	dfse->sdev = sdev;
-
-	debugfs_create_file(name, mode, sdev->debugfs_root, dfse, fops);
-	/* add to dfsentry list */
-	list_add(&dfse->list, &sdev->dfsentry_list);
-
-	return 0;
-}
-#endif
-
-
 static ssize_t sof_dfsentry_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *ppos)
 {
@@ -439,17 +223,6 @@ int snd_sof_dbg_init(struct snd_sof_dev *sdev)
 			return err;
 	}
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
-	err = snd_sof_debugfs_probe_item(sdev, "probe_points",
-			0644, &probe_points_fops);
-	if (err < 0)
-		return err;
-	err = snd_sof_debugfs_probe_item(sdev, "probe_points_remove",
-			0200, &probe_points_remove_fops);
-	if (err < 0)
-		return err;
-#endif
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_sof_dbg_init);
diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 1acec1176986..35965e2e72de 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -557,20 +557,5 @@ struct snd_soc_dai_driver skl_dai[] = {
 		.channels_max = 16,
 	},
 },
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_PROBES)
-{
-	.name = "Probe Extraction CPU DAI",
-	.compress_new = snd_soc_new_compress,
-	.cops = &sof_probe_compr_ops,
-	.capture = {
-		.stream_name = "Probe Extraction",
-		.channels_min = 1,
-		.channels_max = 8,
-		.rates = SNDRV_PCM_RATE_48000,
-		.rate_min = 48000,
-		.rate_max = 48000,
-	},
-},
-#endif
 #endif
 };
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 1bc4dabdd394..f0ac57e8b243 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -352,13 +352,7 @@
 
 /* Number of DAIs */
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
-
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_PROBES)
-#define SOF_SKL_NUM_DAIS		16
-#else
 #define SOF_SKL_NUM_DAIS		15
-#endif
-
 #else
 #define SOF_SKL_NUM_DAIS		8
 #endif
diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index cbac6f17c52f..609583f79aa8 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -16,9 +16,6 @@
 #include "sof-priv.h"
 #include "sof-audio.h"
 #include "ops.h"
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
-#include "compress.h"
-#endif
 
 /* Create DMA buffer page table for DSP */
 static int create_page_table(struct snd_soc_component *component,
@@ -801,14 +798,6 @@ void snd_sof_new_platform_drv(struct snd_sof_dev *sdev)
 	pd->hw_free = sof_pcm_hw_free;
 	pd->trigger = sof_pcm_trigger;
 	pd->pointer = sof_pcm_pointer;
-
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_COMPRESS)
-	pd->compress_ops = &sof_compressed_ops;
-#endif
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
-	/* override cops when probe support is enabled */
-	pd->compress_ops = &sof_probe_compressed_ops;
-#endif
 	pd->pcm_construct = sof_pcm_new;
 	pd->ignore_machine = drv_name;
 	pd->be_hw_params_fixup = sof_pcm_dai_link_fixup;
diff --git a/sound/soc/sof/probe.c b/sound/soc/sof/probe.c
index 14509f4d3f86..a926619b484a 100644
--- a/sound/soc/sof/probe.c
+++ b/sound/soc/sof/probe.c
@@ -8,12 +8,15 @@
 // Author: Cezary Rojewski <cezary.rojewski@intel.com>
 //
 
-#include "sof-priv.h"
+#include <linux/slab.h>
+#include <sound/sof/header.h>
 #include "probe.h"
+#include "sof-client.h"
+
 
 /**
- * sof_ipc_probe_init - initialize data probing
- * @sdev:		SOF sound device
+ * sof_probe_init - initialize data probing
+ * @cdev:		SOF client device
  * @stream_tag:		Extractor stream tag
  * @buffer_size:	DMA buffer size to set for extractor
  *
@@ -25,8 +28,8 @@
  * Probing is initialized only once and each INIT request must be
  * matched by DEINIT call.
  */
-int sof_ipc_probe_init(struct snd_sof_dev *sdev,
-		u32 stream_tag, size_t buffer_size)
+int sof_probe_init(struct sof_client_dev *cdev, u32 stream_tag,
+		   size_t buffer_size)
 {
 	struct sof_ipc_probe_dma_add_params *msg;
 	struct sof_ipc_reply reply;
@@ -42,22 +45,22 @@ int sof_ipc_probe_init(struct snd_sof_dev *sdev,
 	msg->dma[0].stream_tag = stream_tag;
 	msg->dma[0].dma_buffer_size = buffer_size;
 
-	ret = sof_ipc_tx_message(sdev->ipc, msg->hdr.cmd, msg, msg->hdr.size,
-			&reply, sizeof(reply));
+	ret = sof_client_ipc_tx_message(cdev, msg->hdr.cmd, msg, msg->hdr.size,
+					&reply, sizeof(reply));
 	kfree(msg);
 	return ret;
 }
-EXPORT_SYMBOL(sof_ipc_probe_init);
+EXPORT_SYMBOL(sof_probe_init);
 
 /**
- * sof_ipc_probe_deinit - cleanup after data probing
- * @sdev:	SOF sound device
+ * sof_probe_deinit - cleanup after data probing
+ * @cdev:		SOF client device
  *
  * Host sends DEINIT request to free previously initialized probe
  * on DSP side once it is no longer needed. DEINIT only when there
  * are no probes connected and with all injectors detached.
  */
-int sof_ipc_probe_deinit(struct snd_sof_dev *sdev)
+int sof_probe_deinit(struct sof_client_dev *cdev)
 {
 	struct sof_ipc_cmd_hdr msg;
 	struct sof_ipc_reply reply;
@@ -65,13 +68,13 @@ int sof_ipc_probe_deinit(struct snd_sof_dev *sdev)
 	msg.size = sizeof(msg);
 	msg.cmd = SOF_IPC_GLB_PROBE | SOF_IPC_PROBE_DEINIT;
 
-	return sof_ipc_tx_message(sdev->ipc, msg.cmd, &msg, msg.size,
-			&reply, sizeof(reply));
+	return sof_client_ipc_tx_message(cdev, msg.cmd, &msg, msg.size,
+					 &reply, sizeof(reply));
 }
-EXPORT_SYMBOL(sof_ipc_probe_deinit);
+EXPORT_SYMBOL(sof_probe_deinit);
 
-static int sof_ipc_probe_info(struct snd_sof_dev *sdev, unsigned int cmd,
-		void **params, size_t *num_params)
+static int sof_probe_info(struct sof_client_dev *cdev, unsigned int cmd,
+			  void **params, size_t *num_params)
 {
 	struct sof_ipc_probe_info_params msg = {{{0}}};
 	struct sof_ipc_probe_info_params *reply;
@@ -87,8 +90,9 @@ static int sof_ipc_probe_info(struct snd_sof_dev *sdev, unsigned int cmd,
 	msg.rhdr.hdr.size = sizeof(msg);
 	msg.rhdr.hdr.cmd = SOF_IPC_GLB_PROBE | cmd;
 
-	ret = sof_ipc_tx_message(sdev->ipc, msg.rhdr.hdr.cmd, &msg,
-			msg.rhdr.hdr.size, reply, SOF_IPC_MSG_MAX_SIZE);
+	ret = sof_client_ipc_tx_message(cdev, msg.rhdr.hdr.cmd, &msg,
+					msg.rhdr.hdr.size, reply,
+					SOF_IPC_MSG_MAX_SIZE);
 	if (ret < 0 || reply->rhdr.error < 0)
 		goto exit;
 
@@ -113,8 +117,8 @@ static int sof_ipc_probe_info(struct snd_sof_dev *sdev, unsigned int cmd,
 }
 
 /**
- * sof_ipc_probe_dma_info - retrieve list of active injection dmas
- * @sdev:	SOF sound device
+ * sof_probe_dma_info - retrieve list of active injection dmas
+ * @cdev:		SOF client device
  * @dma:	Returned list of active dmas
  * @num_dma:	Returned count of active dmas
  *
@@ -127,17 +131,17 @@ static int sof_ipc_probe_info(struct snd_sof_dev *sdev, unsigned int cmd,
  * which is not the case for injection where multiple streams
  * could be engaged.
  */
-int sof_ipc_probe_dma_info(struct snd_sof_dev *sdev,
-		struct sof_probe_dma **dma, size_t *num_dma)
+int sof_probe_dma_info(struct sof_client_dev *cdev,
+		       struct sof_probe_dma **dma, size_t *num_dma)
 {
-	return sof_ipc_probe_info(sdev, SOF_IPC_PROBE_DMA_INFO,
-			(void **)dma, num_dma);
+	return sof_probe_info(cdev, SOF_IPC_PROBE_DMA_INFO,
+				  (void **)dma, num_dma);
 }
-EXPORT_SYMBOL(sof_ipc_probe_dma_info);
+EXPORT_SYMBOL(sof_probe_dma_info);
 
 /**
- * sof_ipc_probe_dma_add - attach to specified dmas
- * @sdev:	SOF sound device
+ * sof_probe_dma_add - attach to specified dmas
+ * @cdev:		SOF client device
  * @dma:	List of streams (dmas) to attach to
  * @num_dma:	Number of elements in @dma
  *
@@ -146,8 +150,8 @@ EXPORT_SYMBOL(sof_ipc_probe_dma_info);
  * for specifying streams which will be later used to transfer data
  * to connected probe points.
  */
-int sof_ipc_probe_dma_add(struct snd_sof_dev *sdev,
-		struct sof_probe_dma *dma, size_t num_dma)
+int sof_probe_dma_add(struct sof_client_dev *cdev,
+		      struct sof_probe_dma *dma, size_t num_dma)
 {
 	struct sof_ipc_probe_dma_add_params *msg;
 	struct sof_ipc_reply reply;
@@ -162,16 +166,16 @@ int sof_ipc_probe_dma_add(struct snd_sof_dev *sdev,
 	msg->hdr.cmd = SOF_IPC_GLB_PROBE | SOF_IPC_PROBE_DMA_ADD;
 	memcpy(&msg->dma[0], dma, size - sizeof(*msg));
 
-	ret = sof_ipc_tx_message(sdev->ipc, msg->hdr.cmd, msg, msg->hdr.size,
-			&reply, sizeof(reply));
+	ret = sof_client_ipc_tx_message(cdev, msg->hdr.cmd, msg, msg->hdr.size,
+					&reply, sizeof(reply));
 	kfree(msg);
 	return ret;
 }
-EXPORT_SYMBOL(sof_ipc_probe_dma_add);
+EXPORT_SYMBOL(sof_probe_dma_add);
 
 /**
- * sof_ipc_probe_dma_remove - detach from specified dmas
- * @sdev:		SOF sound device
+ * sof_probe_dma_remove - detach from specified dmas
+ * @cdev:		SOF client device
  * @stream_tag:		List of stream tags to detach from
  * @num_stream_tag:	Number of elements in @stream_tag
  *
@@ -180,8 +184,8 @@ EXPORT_SYMBOL(sof_ipc_probe_dma_add);
  * match equivalent DMA_ADD. Detach only when all probes tied to
  * given stream have been disconnected.
  */
-int sof_ipc_probe_dma_remove(struct snd_sof_dev *sdev,
-		unsigned int *stream_tag, size_t num_stream_tag)
+int sof_probe_dma_remove(struct sof_client_dev *cdev,
+			 unsigned int *stream_tag, size_t num_stream_tag)
 {
 	struct sof_ipc_probe_dma_remove_params *msg;
 	struct sof_ipc_reply reply;
@@ -196,16 +200,16 @@ int sof_ipc_probe_dma_remove(struct snd_sof_dev *sdev,
 	msg->hdr.cmd = SOF_IPC_GLB_PROBE | SOF_IPC_PROBE_DMA_REMOVE;
 	memcpy(&msg->stream_tag[0], stream_tag, size - sizeof(*msg));
 
-	ret = sof_ipc_tx_message(sdev->ipc, msg->hdr.cmd, msg, msg->hdr.size,
-			&reply, sizeof(reply));
+	ret = sof_client_ipc_tx_message(cdev, msg->hdr.cmd, msg, msg->hdr.size,
+					&reply, sizeof(reply));
 	kfree(msg);
 	return ret;
 }
-EXPORT_SYMBOL(sof_ipc_probe_dma_remove);
+EXPORT_SYMBOL(sof_probe_dma_remove);
 
 /**
- * sof_ipc_probe_points_info - retrieve list of active probe points
- * @sdev:	SOF sound device
+ * sof_probe_points_info - retrieve list of active probe points
+ * @cdev:		SOF client device
  * @desc:	Returned list of active probes
  * @num_desc:	Returned count of active probes
  *
@@ -213,17 +217,18 @@ EXPORT_SYMBOL(sof_ipc_probe_dma_remove);
  * points, valid for disconnection when given probe is no longer
  * required.
  */
-int sof_ipc_probe_points_info(struct snd_sof_dev *sdev,
-		struct sof_probe_point_desc **desc, size_t *num_desc)
+int sof_probe_points_info(struct sof_client_dev *cdev,
+			  struct sof_probe_point_desc **desc,
+			  size_t *num_desc)
 {
-	return sof_ipc_probe_info(sdev, SOF_IPC_PROBE_POINT_INFO,
+	return sof_probe_info(cdev, SOF_IPC_PROBE_POINT_INFO,
 				 (void **)desc, num_desc);
 }
-EXPORT_SYMBOL(sof_ipc_probe_points_info);
+EXPORT_SYMBOL(sof_probe_points_info);
 
 /**
- * sof_ipc_probe_points_add - connect specified probes
- * @sdev:	SOF sound device
+ * sof_probe_points_add - connect specified probes
+ * @cdev:		SOF client device
  * @desc:	List of probe points to connect
  * @num_desc:	Number of elements in @desc
  *
@@ -234,8 +239,9 @@ EXPORT_SYMBOL(sof_ipc_probe_points_info);
  * Each probe point should be removed using PROBE_POINT_REMOVE
  * request when no longer needed.
  */
-int sof_ipc_probe_points_add(struct snd_sof_dev *sdev,
-		struct sof_probe_point_desc *desc, size_t num_desc)
+int sof_probe_points_add(struct sof_client_dev *cdev,
+			 struct sof_probe_point_desc *desc,
+			 size_t num_desc)
 {
 	struct sof_ipc_probe_point_add_params *msg;
 	struct sof_ipc_reply reply;
@@ -250,24 +256,24 @@ int sof_ipc_probe_points_add(struct snd_sof_dev *sdev,
 	msg->hdr.cmd = SOF_IPC_GLB_PROBE | SOF_IPC_PROBE_POINT_ADD;
 	memcpy(&msg->desc[0], desc, size - sizeof(*msg));
 
-	ret = sof_ipc_tx_message(sdev->ipc, msg->hdr.cmd, msg, msg->hdr.size,
-			&reply, sizeof(reply));
+	ret = sof_client_ipc_tx_message(cdev, msg->hdr.cmd, msg, msg->hdr.size,
+					&reply, sizeof(reply));
 	kfree(msg);
 	return ret;
 }
-EXPORT_SYMBOL(sof_ipc_probe_points_add);
+EXPORT_SYMBOL(sof_probe_points_add);
 
 /**
- * sof_ipc_probe_points_remove - disconnect specified probes
- * @sdev:		SOF sound device
+ * sof_probe_points_remove - disconnect specified probes
+ * @cdev:		SOF client device
  * @buffer_id:		List of probe points to disconnect
  * @num_buffer_id:	Number of elements in @desc
  *
  * Removes previously connected probes from list of active probe
  * points and frees all resources on DSP side.
  */
-int sof_ipc_probe_points_remove(struct snd_sof_dev *sdev,
-		unsigned int *buffer_id, size_t num_buffer_id)
+int sof_probe_points_remove(struct sof_client_dev *cdev,
+			    unsigned int *buffer_id, size_t num_buffer_id)
 {
 	struct sof_ipc_probe_point_remove_params *msg;
 	struct sof_ipc_reply reply;
@@ -282,9 +288,9 @@ int sof_ipc_probe_points_remove(struct snd_sof_dev *sdev,
 	msg->hdr.cmd = SOF_IPC_GLB_PROBE | SOF_IPC_PROBE_POINT_REMOVE;
 	memcpy(&msg->buffer_id[0], buffer_id, size - sizeof(*msg));
 
-	ret = sof_ipc_tx_message(sdev->ipc, msg->hdr.cmd, msg, msg->hdr.size,
-			&reply, sizeof(reply));
+	ret = sof_client_ipc_tx_message(cdev, msg->hdr.cmd, msg, msg->hdr.size,
+					&reply, sizeof(reply));
 	kfree(msg);
 	return ret;
 }
-EXPORT_SYMBOL(sof_ipc_probe_points_remove);
+EXPORT_SYMBOL(sof_probe_points_remove);
diff --git a/sound/soc/sof/probe.h b/sound/soc/sof/probe.h
index 5e159ab239fa..42e802b7e7fc 100644
--- a/sound/soc/sof/probe.h
+++ b/sound/soc/sof/probe.h
@@ -12,8 +12,8 @@
 #define __SOF_PROBE_H
 
 #include <sound/sof/header.h>
-
-struct snd_sof_dev;
+#include <linux/debugfs.h>
+#include "sof-client.h"
 
 #define SOF_PROBE_INVALID_NODE_ID UINT_MAX
 
@@ -66,20 +66,27 @@ struct sof_ipc_probe_point_remove_params {
 	unsigned int buffer_id[];
 } __packed;
 
-int sof_ipc_probe_init(struct snd_sof_dev *sdev,
-		u32 stream_tag, size_t buffer_size);
-int sof_ipc_probe_deinit(struct snd_sof_dev *sdev);
-int sof_ipc_probe_dma_info(struct snd_sof_dev *sdev,
-		struct sof_probe_dma **dma, size_t *num_dma);
-int sof_ipc_probe_dma_add(struct snd_sof_dev *sdev,
-		struct sof_probe_dma *dma, size_t num_dma);
-int sof_ipc_probe_dma_remove(struct snd_sof_dev *sdev,
-		unsigned int *stream_tag, size_t num_stream_tag);
-int sof_ipc_probe_points_info(struct snd_sof_dev *sdev,
-		struct sof_probe_point_desc **desc, size_t *num_desc);
-int sof_ipc_probe_points_add(struct snd_sof_dev *sdev,
-		struct sof_probe_point_desc *desc, size_t num_desc);
-int sof_ipc_probe_points_remove(struct snd_sof_dev *sdev,
-		unsigned int *buffer_id, size_t num_buffer_id);
+int sof_probe_init(struct sof_client_dev *cdev, u32 stream_tag,
+		   size_t buffer_size);
+int sof_probe_deinit(struct sof_client_dev *cdev);
+int sof_probe_dma_info(struct sof_client_dev *cdev,
+		       struct sof_probe_dma **dma, size_t *num_dma);
+int sof_probe_dma_add(struct sof_client_dev *cdev,
+		      struct sof_probe_dma *dma, size_t num_dma);
+int sof_probe_dma_remove(struct sof_client_dev *cdev,
+			 unsigned int *stream_tag, size_t num_stream_tag);
+int sof_probe_points_info(struct sof_client_dev *cdev,
+			  struct sof_probe_point_desc **desc,
+			  size_t *num_desc);
+int sof_probe_points_add(struct sof_client_dev *cdev,
+			 struct sof_probe_point_desc *desc,
+			 size_t num_desc);
+int sof_probe_points_remove(struct sof_client_dev *cdev,
+			    unsigned int *buffer_id, size_t num_buffer_id);
+
+struct sof_probes_data {
+	struct dentry *dfs_root;
+	unsigned int extractor_stream_tag;
+};
 
 #endif
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index e44158410b24..121c374297fc 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -425,10 +425,6 @@ struct snd_sof_dev {
 	int ipc_timeout;
 	int boot_timeout;
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
-	unsigned int extractor_stream_tag;
-#endif
-
 	/* DMA for Trace */
 	struct snd_dma_buffer dmatb;
 	struct snd_dma_buffer dmatp;
diff --git a/sound/soc/sof/sof-probes-client.c b/sound/soc/sof/sof-probes-client.c
new file mode 100644
index 000000000000..73227af3d339
--- /dev/null
+++ b/sound/soc/sof/sof-probes-client.c
@@ -0,0 +1,414 @@
+// SPDX-License-Identifier: (GPL-2.0-only)
+//
+// Copyright(c) 2020 Intel Corporation. All rights reserved.
+//
+// Author: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
+//
+
+#include <linux/auxiliary_bus.h>
+#include <linux/completion.h>
+#include <linux/debugfs.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <sound/soc.h>
+#include "compress.h"
+#include "probe.h"
+#include "sof-client.h"
+
+#define SOF_PROBES_SUSPEND_DELAY_MS 3000
+/* only extraction supported for now */
+#define SOF_PROBES_NUM_DAI_LINKS 1
+
+/**
+ * strsplit_u32 - Split string into sequence of u32 tokens
+ * @buf:	String to split into tokens.
+ * @delim:	String containing delimiter characters.
+ * @tkns:	Returned u32 sequence pointer.
+ * @num_tkns:	Returned number of tokens obtained.
+ */
+static int
+strsplit_u32(char *buf, const char *delim, u32 **tkns, size_t *num_tkns)
+{
+	char *s;
+	u32 *data, *tmp;
+	size_t count = 0;
+	size_t cap = 32;
+	int ret = 0;
+
+	*tkns = NULL;
+	*num_tkns = 0;
+	data = kcalloc(cap, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	while ((s = strsep(&buf, delim)) != NULL) {
+		ret = kstrtouint(s, 0, data + count);
+		if (ret)
+			goto exit;
+		if (++count >= cap) {
+			cap *= 2;
+			tmp = krealloc(data, cap * sizeof(*data), GFP_KERNEL);
+			if (!tmp) {
+				ret = -ENOMEM;
+				goto exit;
+			}
+			data = tmp;
+		}
+	}
+
+	if (!count)
+		goto exit;
+	*tkns = kmemdup(data, count * sizeof(*data), GFP_KERNEL);
+	if (!(*tkns)) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+	*num_tkns = count;
+
+exit:
+	kfree(data);
+	return ret;
+}
+
+static int tokenize_input(const char __user *from, size_t count,
+			  loff_t *ppos, u32 **tkns, size_t *num_tkns)
+{
+	char *buf;
+	int ret;
+
+	buf = kmalloc(count + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = simple_write_to_buffer(buf, count, ppos, from, count);
+	if (ret != count) {
+		ret = ret >= 0 ? -EIO : ret;
+		goto exit;
+	}
+
+	buf[count] = '\0';
+	ret = strsplit_u32(buf, ",", tkns, num_tkns);
+exit:
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t probe_points_read(struct file *file, char __user *to,
+				 size_t count, loff_t *ppos)
+{
+	struct sof_client_dev *cdev = file->private_data;
+	struct sof_probes_data *probes_data = cdev->data;
+	struct device *dev = &cdev->auxdev.dev;
+	struct sof_probe_point_desc *desc;
+	size_t num_desc;
+	int remaining;
+	char *buf;
+	int i, ret, err;
+
+	if (probes_data->extractor_stream_tag == SOF_PROBE_INVALID_NODE_ID) {
+		dev_warn(dev, "no extractor stream running\n");
+		return -ENOENT;
+	}
+
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0 && ret != -EACCES) {
+		dev_err_ratelimited(dev, "error: debugfs read failed to resume %d\n", ret);
+		pm_runtime_put_noidle(dev);
+		goto exit;
+	}
+
+	ret = sof_probe_points_info(cdev, &desc, &num_desc);
+	if (ret < 0)
+		goto exit;
+
+	pm_runtime_mark_last_busy(dev);
+	err = pm_runtime_put_autosuspend(dev);
+	if (err < 0)
+		dev_err_ratelimited(dev, "error: debugfs read failed to idle %d\n", err);
+
+	for (i = 0; i < num_desc; i++) {
+		remaining = PAGE_SIZE - strlen(buf);
+		if (remaining > 0) {
+			ret = snprintf(buf + strlen(buf), remaining,
+				       "Id: %#010x  Purpose: %u  Node id: %#x\n",
+				       desc[i].buffer_id, desc[i].purpose, desc[i].stream_tag);
+			if (ret < 0)
+				goto free_desc;
+		} else {
+			break;
+		}
+	}
+
+	ret = simple_read_from_buffer(to, count, ppos, buf, strlen(buf));
+free_desc:
+	kfree(desc);
+exit:
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t probe_points_write(struct file *file, const char __user *from,
+				  size_t count, loff_t *ppos)
+{
+	struct sof_client_dev *cdev = file->private_data;
+	struct sof_probes_data *probes_data = cdev->data;
+	struct device *dev = &cdev->auxdev.dev;
+	struct sof_probe_point_desc *desc;
+	size_t num_tkns, bytes;
+	u32 *tkns;
+	int ret, err;
+
+	if (probes_data->extractor_stream_tag == SOF_PROBE_INVALID_NODE_ID) {
+		dev_warn(dev, "no extractor stream running\n");
+		return -ENOENT;
+	}
+
+	ret = tokenize_input(from, count, ppos, &tkns, &num_tkns);
+	if (ret < 0)
+		return ret;
+	bytes = sizeof(*tkns) * num_tkns;
+	if (!num_tkns || (bytes % sizeof(*desc))) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	desc = (struct sof_probe_point_desc *)tkns;
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0 && ret != -EACCES) {
+		dev_err_ratelimited(dev, "error: debugfs write failed to resume %d\n", ret);
+		pm_runtime_put_noidle(dev);
+		goto exit;
+	}
+
+	ret = sof_probe_points_add(cdev, desc, bytes / sizeof(*desc));
+	if (!ret)
+		ret = count;
+
+	pm_runtime_mark_last_busy(dev);
+	err = pm_runtime_put_autosuspend(dev);
+	if (err < 0)
+		dev_err_ratelimited(dev, "error: debugfs write failed to idle %d\n", err);
+exit:
+	kfree(tkns);
+	return ret;
+}
+
+static const struct file_operations probe_points_fops = {
+	.open = simple_open,
+	.read = probe_points_read,
+	.write = probe_points_write,
+	.llseek = default_llseek,
+};
+
+static ssize_t
+probe_points_remove_write(struct file *file, const char __user *from,
+			  size_t count, loff_t *ppos)
+{
+	struct sof_client_dev *cdev = file->private_data;
+	struct sof_probes_data *probes_data = cdev->data;
+	struct device *dev = &cdev->auxdev.dev;
+	size_t num_tkns;
+	u32 *tkns;
+	int ret, err;
+
+	if (probes_data->extractor_stream_tag == SOF_PROBE_INVALID_NODE_ID) {
+		dev_warn(dev, "no extractor stream running\n");
+		return -ENOENT;
+	}
+
+	ret = tokenize_input(from, count, ppos, &tkns, &num_tkns);
+	if (ret < 0)
+		return ret;
+	if (!num_tkns) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err_ratelimited(dev, "error: debugfs write failed to resume %d\n", ret);
+		pm_runtime_put_noidle(dev);
+		goto exit;
+	}
+
+	ret = sof_probe_points_remove(cdev, tkns, num_tkns);
+	if (!ret)
+		ret = count;
+
+	pm_runtime_mark_last_busy(dev);
+	err = pm_runtime_put_autosuspend(dev);
+	if (err < 0)
+		dev_err_ratelimited(dev, "error: debugfs write failed to idle %d\n", err);
+exit:
+	kfree(tkns);
+	return ret;
+}
+
+static const struct file_operations probe_points_remove_fops = {
+	.open = simple_open,
+	.write = probe_points_remove_write,
+	.llseek = default_llseek,
+};
+
+struct snd_soc_dai_driver sof_probes_dai_drv[] = {
+{
+	.name = "Probe Extraction CPU DAI",
+	.compress_new = snd_soc_new_compress,
+	.cops = &sof_probe_compr_ops,
+	.capture = {
+		.stream_name = "Probe Extraction",
+		.channels_min = 1,
+		.channels_max = 8,
+		.rates = SNDRV_PCM_RATE_48000,
+		.rate_min = 48000,
+		.rate_max = 48000,
+	},
+},
+};
+
+static const struct snd_soc_component_driver sof_probes_component = {
+	.name = "sof-probes-component",
+	.compress_ops = &sof_probe_compressed_ops,
+	.module_get_upon_open = 1,
+};
+
+SND_SOC_DAILINK_DEF(dummy, DAILINK_COMP_ARRAY(COMP_DUMMY()));
+
+static struct snd_soc_card sof_probes_card = {
+	.name = "sof-probes",
+	.owner = THIS_MODULE
+};
+
+static int sof_probes_client_probe(struct auxiliary_device *auxdev,
+				   const struct auxiliary_device_id *id)
+{
+	struct sof_client_dev *cdev = auxiliary_dev_to_sof_client_dev(auxdev);
+	struct snd_soc_dai_link_component platform_component[] = {
+		{
+			.name = dev_name(&auxdev->dev),
+		}
+	};
+	struct snd_soc_card *card = &sof_probes_card;
+	struct sof_probes_data *probes_client_data;
+	struct snd_soc_dai_link_component *cpus;
+	struct snd_soc_dai_link *links;
+	int ret;
+
+	/* register probes component driver and dai */
+	ret = devm_snd_soc_register_component(&auxdev->dev, &sof_probes_component,
+					      sof_probes_dai_drv, ARRAY_SIZE(sof_probes_dai_drv));
+	if (ret < 0) {
+		dev_err(&auxdev->dev, "error: failed to register SOF probes DAI driver %d\n", ret);
+		return ret;
+	}
+
+	/* set client data */
+	probes_client_data = devm_kzalloc(&auxdev->dev, sizeof(*probes_client_data), GFP_KERNEL);
+	if (!probes_client_data)
+		return -ENOMEM;
+
+	probes_client_data->extractor_stream_tag = SOF_PROBE_INVALID_NODE_ID;
+	cdev->data = probes_client_data;
+
+	/* create probes debugfs dir under SOF debugfs root dir */
+	probes_client_data->dfs_root = debugfs_create_dir("probes",
+							  sof_client_get_debugfs_root(cdev));
+
+	/* create read-write probes_points debugfs entry */
+	debugfs_create_file("probe_points", 0644, probes_client_data->dfs_root,
+			    cdev, &probe_points_fops);
+
+	/* create read-write probe_points_remove debugfs entry */
+	debugfs_create_file("probe_points_remove", 0644, probes_client_data->dfs_root,
+			    cdev, &probe_points_remove_fops);
+
+	links = devm_kzalloc(&auxdev->dev, sizeof(*links) * SOF_PROBES_NUM_DAI_LINKS, GFP_KERNEL);
+	cpus = devm_kzalloc(&auxdev->dev, sizeof(*cpus) * SOF_PROBES_NUM_DAI_LINKS, GFP_KERNEL);
+	if (!links || !cpus)
+		return -ENOMEM;
+
+	/* extraction DAI link */
+	links[0].name = "Compress Probe Capture";
+	links[0].id = 0;
+	links[0].cpus = &cpus[0];
+	links[0].num_cpus = 1;
+	links[0].cpus->dai_name = "Probe Extraction CPU DAI";
+	links[0].codecs = dummy;
+	links[0].num_codecs = 1;
+	links[0].platforms = platform_component;
+	links[0].num_platforms = ARRAY_SIZE(platform_component);
+	links[0].nonatomic = 1;
+
+	card->num_links = SOF_PROBES_NUM_DAI_LINKS;
+	card->dai_link = links;
+	card->dev = &auxdev->dev;
+
+	/* set idle_bias_off to prevent the core from resuming the card->dev */
+	card->dapm.idle_bias_off = true;
+
+	snd_soc_card_set_drvdata(&sof_probes_card, cdev);
+
+	ret = devm_snd_soc_register_card(&auxdev->dev, card);
+	if (ret < 0) {
+		dev_err(&auxdev->dev, "error: Probes card register failed %d\n", ret);
+		return ret;
+	}
+
+	/* enable runtime PM */
+	pm_runtime_set_autosuspend_delay(&auxdev->dev, SOF_PROBES_SUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(&auxdev->dev);
+	pm_runtime_enable(&auxdev->dev);
+	pm_runtime_mark_last_busy(&auxdev->dev);
+	pm_runtime_idle(&auxdev->dev);
+
+	return 0;
+}
+
+static int sof_probes_client_cleanup(struct auxiliary_device *auxdev)
+{
+	struct sof_client_dev *cdev = auxiliary_dev_to_sof_client_dev(auxdev);
+	struct sof_probes_data *probes_client_data = cdev->data;
+
+	pm_runtime_disable(&auxdev->dev);
+	debugfs_remove_recursive(probes_client_data->dfs_root);
+
+	return 0;
+}
+
+static int sof_probes_client_remove(struct auxiliary_device *auxdev)
+{
+	return sof_probes_client_cleanup(auxdev);
+}
+
+static void sof_probes_client_shutdown(struct auxiliary_device *auxdev)
+{
+	sof_probes_client_cleanup(auxdev);
+}
+
+static const struct auxiliary_device_id sof_probes_auxbus_id_table[] = {
+	{ .name = "snd_sof_client.probes" },
+	{},
+};
+MODULE_DEVICE_TABLE(auxiliary, sof_probes_auxbus_id_table);
+
+/* driver name will be set based on KBUILD_MODNAME */
+static struct sof_client_drv sof_probes_test_client_drv = {
+	.auxiliary_drv = {
+		.id_table = sof_probes_auxbus_id_table,
+		.probe = sof_probes_client_probe,
+		.remove = sof_probes_client_remove,
+		.shutdown = sof_probes_client_shutdown,
+	},
+};
+
+module_sof_client_driver(sof_probes_test_client_drv);
+
+MODULE_DESCRIPTION("SOF Probes Client Driver");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
-- 
2.26.2

