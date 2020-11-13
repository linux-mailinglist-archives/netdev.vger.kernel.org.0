Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B392B2021
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgKMQWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:22:48 -0500
Received: from mga04.intel.com ([192.55.52.120]:1307 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgKMQVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:21:47 -0500
IronPort-SDR: Vsw21y3CQBQxXwUep8r0ZS63eNnUxg+tLJGceYONKENhAm/n3cZbjc4182yCMMMt0z2UMGuQl/
 f6kxXLbgLh6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="167916724"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="167916724"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:46 -0800
IronPort-SDR: 2MmFdMtT6yYVz5FGgQEOiMIJxYV3KwnInv6dptNlGOcfEbOKoPk17rAu4QxF4iFLNi5Pm4sCMq
 fQVOEHgT3gSA==
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="366767254"
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
Subject: [PATCH v4 08/10] ASoC: SOF: compress: move and export sof_probe_compr_ops
Date:   Fri, 13 Nov 2020 08:18:57 -0800
Message-Id: <20201113161859.1775473-9-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113161859.1775473-1-david.m.ertman@intel.com>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

sof_probe_compr_ops are not platform-specific. So move
it to common compress code and export the symbol. The
compilation of the common compress code is already dependent
on the selection of CONFIG_SND_SOC_SOF_DEBUG_PROBES, so no
need to check the Kconfig section for defining sof_probe_compr_ops
again.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 sound/soc/sof/compress.c      |  9 +++++++++
 sound/soc/sof/compress.h      |  1 +
 sound/soc/sof/intel/hda-dai.c | 12 ------------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/sound/soc/sof/compress.c b/sound/soc/sof/compress.c
index 2d4969c705a4..0443f171b4e7 100644
--- a/sound/soc/sof/compress.c
+++ b/sound/soc/sof/compress.c
@@ -13,6 +13,15 @@
 #include "ops.h"
 #include "probe.h"
 
+struct snd_soc_cdai_ops sof_probe_compr_ops = {
+	.startup	= sof_probe_compr_open,
+	.shutdown	= sof_probe_compr_free,
+	.set_params	= sof_probe_compr_set_params,
+	.trigger	= sof_probe_compr_trigger,
+	.pointer	= sof_probe_compr_pointer,
+};
+EXPORT_SYMBOL(sof_probe_compr_ops);
+
 struct snd_compress_ops sof_probe_compressed_ops = {
 	.copy		= sof_probe_compr_copy,
 };
diff --git a/sound/soc/sof/compress.h b/sound/soc/sof/compress.h
index ca8790bd4b13..689c83ac8ffc 100644
--- a/sound/soc/sof/compress.h
+++ b/sound/soc/sof/compress.h
@@ -13,6 +13,7 @@
 
 #include <sound/compress_driver.h>
 
+extern struct snd_soc_cdai_ops sof_probe_compr_ops;
 extern struct snd_compress_ops sof_probe_compressed_ops;
 
 int sof_probe_compr_open(struct snd_compr_stream *cstream,
diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index c6cb8c212eca..1acec1176986 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -400,18 +400,6 @@ static const struct snd_soc_dai_ops hda_link_dai_ops = {
 	.prepare = hda_link_pcm_prepare,
 };
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_PROBES)
-#include "../compress.h"
-
-static struct snd_soc_cdai_ops sof_probe_compr_ops = {
-	.startup	= sof_probe_compr_open,
-	.shutdown	= sof_probe_compr_free,
-	.set_params	= sof_probe_compr_set_params,
-	.trigger	= sof_probe_compr_trigger,
-	.pointer	= sof_probe_compr_pointer,
-};
-
-#endif
 #endif
 
 /*
-- 
2.26.2

