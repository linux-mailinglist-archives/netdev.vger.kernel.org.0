Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D542B2013
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgKMQWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:22:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:10822 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgKMQVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:21:48 -0500
IronPort-SDR: 4q9/fmWsSmkeiD2ccYR88Sl4UubNnRRifOUT0RyTg6ADLkE87jjiYNAAOtc2Qt2Nipi8A8wN/e
 mVSgndpQk9+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="170664316"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="170664316"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:47 -0800
IronPort-SDR: VoJIdrVOahzLn09Hlos2+YZXTi9c7IJbWuSU7SpysP/0TkLwyi3q9ylxnhhdSa2vm+dnX+gLal
 7896ip1n9FTQ==
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="366767263"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:47 -0800
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
Subject: [PATCH v4 10/10] ASoC: SOF: Intel: CNL: register probes client
Date:   Fri, 13 Nov 2020 08:18:59 -0800
Message-Id: <20201113161859.1775473-11-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113161859.1775473-1-david.m.ertman@intel.com>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
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

