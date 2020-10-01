Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7227F8DE
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 07:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgJAFJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 01:09:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:7039 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgJAFJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 01:09:39 -0400
IronPort-SDR: eEz0geb9KACCnYGaL3JFESN5eZ0ctpE5i945RcElcHG6+OWP72Jfti3cJ+vwNnz6J2WmZ5kQ8u
 LGSWdm3EdXXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="224238488"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="224238488"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 22:09:38 -0700
IronPort-SDR: jGrCiHF3fyr7Kwnk9UwZ7ej2nddWtU4mPX2PfypBThyvTKCEMUsWsaREheNnvY5RDVl4YfOzvp
 K5IcPs52lEfg==
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="341443346"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 22:09:38 -0700
From:   Dave Ertman <david.m.ertman@intel.com>
To:     netdev@vger.kernel.org
Subject: [PATCH 4/6] ASoC: SOF: ops: Add ops for client registration
Date:   Wed, 30 Sep 2020 22:08:49 -0700
Message-Id: <20201001050851.890722-5-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001050851.890722-1-david.m.ertman@intel.com>
References: <20201001050851.890722-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

Add new ops for registering/unregistering clients based
on DSP capabilities and/or DT information.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 sound/soc/sof/core.c     | 10 ++++++++++
 sound/soc/sof/ops.h      | 14 ++++++++++++++
 sound/soc/sof/sof-priv.h |  4 ++++
 3 files changed, 28 insertions(+)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 72a97219395f..ddb9a12d5aac 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -246,8 +246,17 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	if (plat_data->sof_probe_complete)
 		plat_data->sof_probe_complete(sdev->dev);
 
+	/* If registering certain clients fails, unregister the previously registered clients. */
+	ret = snd_sof_register_clients(sdev);
+	if (ret < 0) {
+		dev_err(sdev->dev, "error: failed to register clients %d\n", ret);
+		goto client_reg_err;
+	}
+
 	return 0;
 
+client_reg_err:
+	snd_sof_unregister_clients(sdev);
 fw_trace_err:
 	snd_sof_free_trace(sdev);
 fw_run_err:
@@ -356,6 +365,7 @@ int snd_sof_device_remove(struct device *dev)
 			dev_warn(dev, "error: %d failed to prepare DSP for device removal",
 				 ret);
 
+		snd_sof_unregister_clients(sdev);
 		snd_sof_fw_unload(sdev);
 		snd_sof_ipc_free(sdev);
 		snd_sof_free_debug(sdev);
diff --git a/sound/soc/sof/ops.h b/sound/soc/sof/ops.h
index b21632f5511a..0e5660d7a2fd 100644
--- a/sound/soc/sof/ops.h
+++ b/sound/soc/sof/ops.h
@@ -470,6 +470,20 @@ snd_sof_set_mach_params(const struct snd_soc_acpi_mach *mach,
 		sof_ops(sdev)->set_mach_params(mach, dev);
 }
 
+static inline int snd_sof_register_clients(struct snd_sof_dev *sdev)
+{
+	if (sof_ops(sdev) && sof_ops(sdev)->register_clients)
+		return sof_ops(sdev)->register_clients(sdev);
+
+	return 0;
+}
+
+static inline void snd_sof_unregister_clients(struct snd_sof_dev *sdev)
+{
+	if (sof_ops(sdev) && sof_ops(sdev)->unregister_clients)
+		return sof_ops(sdev)->unregister_clients(sdev);
+}
+
 static inline const struct snd_sof_dsp_ops
 *sof_get_ops(const struct sof_dev_desc *d,
 	     const struct sof_ops_table mach_ops[], int asize)
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index 043fcec5a288..151614224f47 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -249,6 +249,10 @@ struct snd_sof_dsp_ops {
 	void (*set_mach_params)(const struct snd_soc_acpi_mach *mach,
 				struct device *dev); /* optional */
 
+	/* client ops */
+	int (*register_clients)(struct snd_sof_dev *sdev); /* optional */
+	void (*unregister_clients)(struct snd_sof_dev *sdev); /* optional */
+
 	/* DAI ops */
 	struct snd_soc_dai_driver *drv;
 	int num_drv;
-- 
2.26.2

