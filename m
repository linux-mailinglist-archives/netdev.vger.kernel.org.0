Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F894BF27D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiBVHJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:09:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiBVHJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:09:12 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A42B1A89
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 23:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645513728; x=1677049728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=376WXI7gvq6wf+BEg0xDspI/XMWauY6hFaCPlRIcM3M=;
  b=R+etgpurZbEC13KwpC+r4/d9OH5/TZzLaQL1MBpzLHSVjphACRQRX5oc
   4Xqy+OVryOFacylVm0stUTIYQP8sOEh+iRw2ONSqQ/7eo9YVRi6nTKE4h
   m+LftmnZAePiK4g74znP1rZRpPgCxpE/4HzFbXof0GnoLtPM83CTdFTcC
   gBfHGwhgRgvKhaYxppmiaeM1utAXIAAcvl+qXKuUZjqP9LHYx9bsf4tfu
   PzuzSbScd27cQQCd5r1DEmcsT27tVQoYkzH+pzmCbiih6ZsrgIFpdhvcL
   zCVFtGSsEw+Qia9QMgtmgo4/aNQ3ptMesWCUZmFyxb6h/D3qpHw0xPnoG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="249207316"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="249207316"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 23:08:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="776207148"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 23:08:46 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 5/5] vDPA/ifcvf: cacheline alignment for ifcvf_hw
Date:   Tue, 22 Feb 2022 15:01:09 +0800
Message-Id: <20220222070109.931260-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220222070109.931260-1-lingshan.zhu@intel.com>
References: <20220222070109.931260-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces a new cacheline aligned layout for
ifcvf_hw.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index dcd31accfce5..115b61f4924b 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -66,16 +66,18 @@ struct ifcvf_hw {
 	u8 __iomem *isr;
 	/* Live migration */
 	u8 __iomem *lm_cfg;
-	u16 nr_vring;
 	/* Notification bar number */
 	u8 notify_bar;
+	u8 msix_vector_status;
+	/* virtio-net or virtio-blk device config size */
+	u32 config_size;
 	/* Notificaiton bar address */
 	void __iomem *notify_base;
 	phys_addr_t notify_base_pa;
 	u32 notify_off_multiplier;
+	u32 dev_type;
 	u64 req_features;
 	u64 hw_features;
-	u32 dev_type;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
 	void __iomem *dev_cfg;
 	struct vring_info vring[IFCVF_MAX_QUEUES];
@@ -84,9 +86,7 @@ struct ifcvf_hw {
 	struct vdpa_callback config_cb;
 	int config_irq;
 	int vqs_reused_irq;
-	/* virtio-net or virtio-blk device config size */
-	u32 config_size;
-	u8 msix_vector_status;
+	u16 nr_vring;
 };
 
 struct ifcvf_adapter {
-- 
2.27.0

