Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44947C9FB
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbhLUX64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:58:56 -0500
Received: from mga12.intel.com ([192.55.52.136]:13562 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238387AbhLUX6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640131135; x=1671667135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uCa5cZIlL8taJeMROqQYvFIGIwU4M7AqBFLrdzGAITk=;
  b=Jql15cj37nHoXifjn7eb0bUVVLwpf2UmJuu4ObrayMIGTLpjqTsDv/mn
   OMnoZC/o3DlmgLkviXPF7NuyvJp5R+VOeL/fre0tn1TOrwj8ykV1vEUKR
   MKJbC7lSohKx4Q/87Lp1QzZ2VTLaEFGNLYrSR5HgETnlwl0IfYs9TekKa
   hTADHiGWXFxcOQR38Fparh5ae+Qf7thPuPRGid0yOrwGCzJBUG2J5mbHu
   317ihAfCR54fDXMggAaCSCxtYSudpbQwhahxjk7RN3sNmiaR1AqvHli1j
   FbCPHIVVleDuViN2tbGp/0wR6J1hzNn//bYPOQoLQR31wkov+dy62ihby
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="220524630"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="220524630"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:58:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="467976751"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 21 Dec 2021 15:58:53 -0800
Received: from debox1-desk4.intel.com (unknown [10.209.90.33])
        by linux.intel.com (Postfix) with ESMTP id 6FBA7580AA4;
        Tue, 21 Dec 2021 15:58:53 -0800 (PST)
From:   "David E. Box" <david.e.box@linux.intel.com>
To:     gregkh@linuxfoundation.org, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, saeedm@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, vkoul@kernel.org, yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, mst@redhat.com,
        jasowang@redhat.com
Cc:     "David E. Box" <david.e.box@linux.intel.com>,
        andriy.shevchenko@linux.intel.com, hdegoede@redhat.com,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 2/4] soundwire: intel: Use auxiliary_device driver data helpers
Date:   Tue, 21 Dec 2021 15:58:50 -0800
Message-Id: <20211221235852.323752-3-david.e.box@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211221235852.323752-1-david.e.box@linux.intel.com>
References: <20211221235852.323752-1-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use auxiliary_get_drvdata and auxiliary_set_drvdata helpers.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 drivers/soundwire/intel.c      | 8 ++++----
 drivers/soundwire/intel_init.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 78037ffdb09b..d082d18e41a9 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1293,7 +1293,7 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
 	bus->ops = &sdw_intel_ops;
 
 	/* set driver data, accessed by snd_soc_dai_get_drvdata() */
-	dev_set_drvdata(dev, cdns);
+	auxiliary_set_drvdata(auxdev, cdns);
 
 	/* use generic bandwidth allocation algorithm */
 	sdw->cdns.bus.compute_params = sdw_compute_params;
@@ -1321,7 +1321,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
 {
 	struct sdw_cdns_stream_config config;
 	struct device *dev = &auxdev->dev;
-	struct sdw_cdns *cdns = dev_get_drvdata(dev);
+	struct sdw_cdns *cdns = auxiliary_get_drvdata(auxdev);
 	struct sdw_intel *sdw = cdns_to_intel(cdns);
 	struct sdw_bus *bus = &cdns->bus;
 	int link_flags;
@@ -1463,7 +1463,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
 static void intel_link_remove(struct auxiliary_device *auxdev)
 {
 	struct device *dev = &auxdev->dev;
-	struct sdw_cdns *cdns = dev_get_drvdata(dev);
+	struct sdw_cdns *cdns = auxiliary_get_drvdata(auxdev);
 	struct sdw_intel *sdw = cdns_to_intel(cdns);
 	struct sdw_bus *bus = &cdns->bus;
 
@@ -1488,7 +1488,7 @@ int intel_link_process_wakeen_event(struct auxiliary_device *auxdev)
 	void __iomem *shim;
 	u16 wake_sts;
 
-	sdw = dev_get_drvdata(dev);
+	sdw = auxiliary_get_drvdata(auxdev);
 	bus = &sdw->cdns.bus;
 
 	if (bus->prop.hw_disabled || !sdw->startup_done) {
diff --git a/drivers/soundwire/intel_init.c b/drivers/soundwire/intel_init.c
index e329022e1669..d99807765dfe 100644
--- a/drivers/soundwire/intel_init.c
+++ b/drivers/soundwire/intel_init.c
@@ -244,7 +244,7 @@ static struct sdw_intel_ctx
 			goto err;
 
 		link = &ldev->link_res;
-		link->cdns = dev_get_drvdata(&ldev->auxdev.dev);
+		link->cdns = auxiliary_get_drvdata(&ldev->auxdev);
 
 		if (!link->cdns) {
 			dev_err(&adev->dev, "failed to get link->cdns\n");
-- 
2.25.1

