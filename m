Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430CA296811
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 02:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373972AbgJWAgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 20:36:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:43009 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373861AbgJWAfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 20:35:30 -0400
IronPort-SDR: EQOVrewm/EdYCG7GEFQj6QkZvgZl7GE1c6/1Q6GntpjCUOE6lyTxxzyotWOihoG9RNeZSL7uDP
 MaNsXUeALieA==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="164118651"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="164118651"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 17:35:27 -0700
IronPort-SDR: 18qW83gLRKyW77TzyKGUMM+iMckw6+8PkfCBvA9H1uWBMqZ6cl4vtWcGGDzKgnZ4+lHtmCbdLo
 ekgwrk0PTh+Q==
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="302505825"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 17:35:27 -0700
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
Subject: [PATCH v3 08/10] ASoC: SOF: compress: move and export sof_probe_compr_ops
Date:   Thu, 22 Oct 2020 17:33:36 -0700
Message-Id: <20201023003338.1285642-9-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023003338.1285642-1-david.m.ertman@intel.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
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

