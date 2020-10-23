Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D27296800
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 02:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373919AbgJWAfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 20:35:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:43009 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373864AbgJWAfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 20:35:30 -0400
IronPort-SDR: igoJ/56H5YAygkgJOWJaBHtXaEFukSA2G3jDMGvLkkfa9qeypL8ICdKMxmc8HO6U/QFQYF8Exb
 0g0PXeSsa/Zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="164118655"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="164118655"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 17:35:29 -0700
IronPort-SDR: AmNrptTHi/qxndARhN2/6LgX9EtDqEMC7c+p3z+rBNqomsEsGFcmp6cWKzFipvTpj3fv7+DjD3
 tghWbrJuAywg==
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="302505834"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 17:35:28 -0700
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
Subject: [PATCH v3 10/10] ASoC: SOF: Intel: CNL: register probes client
Date:   Thu, 22 Oct 2020 17:33:38 -0700
Message-Id: <20201023003338.1285642-11-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023003338.1285642-1-david.m.ertman@intel.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

Register the client device for probes support on the
CNL platform. Creating this client device alleviates the
need for modifying the sound card definitions in the existing
machine drivers to add support for the new probes feature in
the FW. This will result in the creation of a separate sound
card that can be used for audio data extraction from user
specified points in the audio pipeline.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 sound/soc/sof/intel/cnl.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/cnl.c b/sound/soc/sof/intel/cnl.c
index 20afb622c315..6d15b871dc17 100644
--- a/sound/soc/sof/intel/cnl.c
+++ b/sound/soc/sof/intel/cnl.c
@@ -19,6 +19,7 @@
 #include "hda.h"
 #include "hda-ipc.h"
 #include "../sof-audio.h"
+#include "../sof-client.h"
 #include "intel-client.h"
 
 static const struct snd_sof_debugfs_map cnl_dsp_debugfs[] = {
@@ -233,12 +234,26 @@ void cnl_ipc_dump(struct snd_sof_dev *sdev)
 
 static int cnl_register_clients(struct snd_sof_dev *sdev)
 {
-	return intel_register_ipc_test_clients(sdev);
+	int ret;
+
+	ret = intel_register_ipc_test_clients(sdev);
+	if (ret < 0)
+		return ret;
+
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_PROBES)
+	return sof_client_dev_register(sdev, "probes", 0);
+#endif
+
+	return 0;
 }
 
 static void cnl_unregister_clients(struct snd_sof_dev *sdev)
 {
 	intel_unregister_ipc_test_clients(sdev);
+
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_PROBES)
+	sof_client_dev_unregister(sdev, "probes", 0);
+#endif
 }
 
 /* cannonlake ops */
@@ -409,3 +424,4 @@ const struct sof_intel_dsp_desc jsl_chip_info = {
 };
 EXPORT_SYMBOL_NS(jsl_chip_info, SND_SOC_SOF_INTEL_HDA_COMMON);
 MODULE_IMPORT_NS(SND_SOC_SOF_INTEL_CLIENT);
+MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
-- 
2.26.2

