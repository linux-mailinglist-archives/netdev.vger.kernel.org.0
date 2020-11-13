Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4098D2B2018
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgKMQW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:22:29 -0500
Received: from mga18.intel.com ([134.134.136.126]:45997 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgKMQVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:21:47 -0500
IronPort-SDR: QeE7HLNtQ731zhPkOMH/fHwvSQ7Pp/TlW1TX2sSCCxKkuC60AhVYSqXDmWGZvr65bOGNyru9p9
 Ilta4vIqJmiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="158272294"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="158272294"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:46 -0800
IronPort-SDR: 4RHrIKzeTtC9smTY4rikHb9IM8vl9ZrJ0o9dnyfOq1CvKGq9tglypgPw8MaA7MiWq0SKoketWU
 ZgONovKtoS2Q==
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="366767251"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:45 -0800
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
Subject: [PATCH v4 07/10] ASoC: SOF: sof-client: Add client APIs to access probes ops
Date:   Fri, 13 Nov 2020 08:18:56 -0800
Message-Id: <20201113161859.1775473-8-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113161859.1775473-1-david.m.ertman@intel.com>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

Add client APIs to invoke the platform-specific DSP probes
ops. Also, add a new API to get the SOF core device pointer
which will be used for DMA buffer allocation.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 sound/soc/sof/sof-client.c | 55 ++++++++++++++++++++++++++++++++++++++
 sound/soc/sof/sof-client.h | 25 +++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/sound/soc/sof/sof-client.c b/sound/soc/sof/sof-client.c
index dd75a0ba4c28..838aaa5ea179 100644
--- a/sound/soc/sof/sof-client.c
+++ b/sound/soc/sof/sof-client.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include "ops.h"
 #include "sof-client.h"
 #include "sof-priv.h"
 
@@ -112,4 +113,58 @@ struct dentry *sof_client_get_debugfs_root(struct sof_client_dev *cdev)
 }
 EXPORT_SYMBOL_NS_GPL(sof_client_get_debugfs_root, SND_SOC_SOF_CLIENT);
 
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES_CLIENT)
+int sof_client_probe_compr_assign(struct sof_client_dev *cdev,
+				  struct snd_compr_stream *cstream,
+				  struct snd_soc_dai *dai)
+{
+	return snd_sof_probe_compr_assign(cdev->sdev, cstream, dai);
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_probe_compr_assign, SND_SOC_SOF_CLIENT);
+
+int sof_client_probe_compr_free(struct sof_client_dev *cdev,
+				struct snd_compr_stream *cstream,
+				struct snd_soc_dai *dai)
+{
+	return snd_sof_probe_compr_free(cdev->sdev, cstream, dai);
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_probe_compr_free, SND_SOC_SOF_CLIENT);
+
+int sof_client_probe_compr_set_params(struct sof_client_dev *cdev,
+				      struct snd_compr_stream *cstream,
+				      struct snd_compr_params *params,
+				      struct snd_soc_dai *dai)
+{
+	return snd_sof_probe_compr_set_params(cdev->sdev, cstream, params, dai);
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_probe_compr_set_params, SND_SOC_SOF_CLIENT);
+
+int sof_client_probe_compr_trigger(struct sof_client_dev *cdev,
+				   struct snd_compr_stream *cstream, int cmd,
+				   struct snd_soc_dai *dai)
+{
+	return snd_sof_probe_compr_trigger(cdev->sdev, cstream, cmd, dai);
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_probe_compr_trigger, SND_SOC_SOF_CLIENT);
+
+int sof_client_probe_compr_pointer(struct sof_client_dev *cdev,
+				   struct snd_compr_stream *cstream,
+				   struct snd_compr_tstamp *tstamp,
+				   struct snd_soc_dai *dai)
+{
+	return snd_sof_probe_compr_pointer(cdev->sdev, cstream, tstamp, dai);
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_probe_compr_pointer, SND_SOC_SOF_CLIENT);
+#endif
+
+/*
+ * DMA buffer alloc fails when using the client device. Use the SOF core device instead.
+ * This will be needed for clients other than the probes client device as well.
+ */
+struct device *sof_client_get_dma_dev(struct sof_client_dev *cdev)
+{
+	return cdev->sdev->dev;
+}
+EXPORT_SYMBOL_NS_GPL(sof_client_get_dma_dev, SND_SOC_SOF_CLIENT);
+
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/sof/sof-client.h b/sound/soc/sof/sof-client.h
index 429282df9f65..be80053068c9 100644
--- a/sound/soc/sof/sof-client.h
+++ b/sound/soc/sof/sof-client.h
@@ -7,6 +7,10 @@
 #include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/list.h>
+#include <sound/compress_offload.h>
+#include <sound/compress_driver.h>
+#include <sound/soc.h>
+#include <sound/soc-dai.h>
 
 #define SOF_CLIENT_PROBE_TIMEOUT_MS 2000
 
@@ -50,6 +54,27 @@ int sof_client_ipc_tx_message(struct sof_client_dev *cdev, u32 header, void *msg
 			      size_t msg_bytes, void *reply_data, size_t reply_bytes);
 
 struct dentry *sof_client_get_debugfs_root(struct sof_client_dev *cdev);
+struct device *sof_client_get_dma_dev(struct sof_client_dev *cdev);
+
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES_CLIENT)
+int sof_client_probe_compr_assign(struct sof_client_dev *cdev,
+				  struct snd_compr_stream *cstream,
+				  struct snd_soc_dai *dai);
+int sof_client_probe_compr_free(struct sof_client_dev *cdev,
+				struct snd_compr_stream *cstream,
+				struct snd_soc_dai *dai);
+int sof_client_probe_compr_set_params(struct sof_client_dev *cdev,
+				      struct snd_compr_stream *cstream,
+				      struct snd_compr_params *params,
+				      struct snd_soc_dai *dai);
+int sof_client_probe_compr_trigger(struct sof_client_dev *cdev,
+				   struct snd_compr_stream *cstream, int cmd,
+				   struct snd_soc_dai *dai);
+int sof_client_probe_compr_pointer(struct sof_client_dev *cdev,
+				   struct snd_compr_stream *cstream,
+				   struct snd_compr_tstamp *tstamp,
+				   struct snd_soc_dai *dai);
+#endif
 
 /**
  * module_sof_client_driver() - Helper macro for registering an SOF Client
-- 
2.26.2

