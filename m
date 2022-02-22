Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069E24BF7AF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiBVMCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiBVMCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:02:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BA324BC1
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645531328; x=1677067328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eSzJj0N8l3dCBZZhWzfgVLnLLai3pgPIz51XNdjaPQc=;
  b=Jjuz5IJCAnuWNqXSf6KtTiQ+xylAHZfcdJvByIntob/dKupfJeSC52Bt
   cJ2hRQey7ogNlk30ficJs7F+CNWQSQUPcyMTmttJ01XwMk0PQMoGftrdr
   LKME6AHoQ0QwXlrVxh/hud9ApJiyU35urHQk/IwfF/3VliKbYJOX2rC0M
   EA/wFhKc3oSOZrz81vuJJIrl+j37AgUf2XyaVkZQF3DTjt0ay1yQ/0DWW
   XpjsWQoPiU3i5lbCkVbsOG6+mrORxTl+BHA+cWpGD2TdtpnbNs9Ss5b9+
   G+9/y5KrZQ6651N3msWTL2xxyHvIEgHAbsPttLUUSZJ99Rr27d725JRIj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="338117866"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="338117866"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:02:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="490772600"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:02:05 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V6 5/5] vDPA/ifcvf: cacheline alignment for ifcvf_hw
Date:   Tue, 22 Feb 2022 19:54:28 +0800
Message-Id: <20220222115428.998334-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220222115428.998334-1-lingshan.zhu@intel.com>
References: <20220222115428.998334-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces a new cacheline aligned layout for
ifcvf_hw.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |  4 ----
 drivers/vdpa/ifcvf/ifcvf_base.h | 10 +++++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 8aba3ab4a2f3..48c4dadb0c7c 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -340,10 +340,8 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 {
 	struct virtio_pci_common_cfg __iomem *cfg;
-	struct ifcvf_adapter *ifcvf;
 	u32 i;
 
-	ifcvf = vf_to_adapter(hw);
 	cfg = hw->common_cfg;
 	for (i = 0; i < hw->nr_vring; i++) {
 		if (!hw->vring[i].ready)
@@ -366,10 +364,8 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 
 static void ifcvf_hw_disable(struct ifcvf_hw *hw)
 {
-	struct virtio_pci_common_cfg __iomem *cfg;
 	u32 i;
 
-	cfg = hw->common_cfg;
 	ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
 	for (i = 0; i < hw->nr_vring; i++) {
 		ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
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

