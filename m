Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAAA56346C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiGANgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiGANgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:36:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932CD167C9
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 06:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656682576; x=1688218576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TeySH30IitlNkryD+dU4O+wR5NVGcicABDK0hQigNu4=;
  b=CbvuIhqcKEeJ08xozOV+gVIu6qSNt5qx6//gtpLRkrJ5Te54DOdcXa6k
   HBQJeUjWe1AOGJ5Pdrv1vdytMIwsafC+dU2QCYJyqitf+V7z/3iT8lkhE
   GqqoMtlkTbvVt28OwyMSOfQWquQOW3CcqS0Kq7glQRWNTVlq6A1yySO6B
   m7+r0av6nRWgtMzNAeBzY31czfI5vNdafpuq3lRu5Hg70QBoaOTP20Fen
   vjLktadoYEaSocVESQpgPdvAbIisGhMWB7DKGGZxhV+MJgEec4vSrsO2o
   KhcEH+USXQ/9pJ20igVnD3pSgNaEBwS4wuz+KyCTHBmOBEHm00F/PqzZs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282682904"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="282682904"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:16 -0700
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="648349627"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:14 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 2/6] vDPA/ifcvf: support userspace to query features and MQ of a management device
Date:   Fri,  1 Jul 2022 21:28:22 +0800
Message-Id: <20220701132826.8132-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220701132826.8132-1-lingshan.zhu@intel.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adapting to current netlink interfaces, this commit allows userspace
to query feature bits and MQ capability of a management device.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
 3 files changed, 16 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index fb957b57941e..7c5f1cc93ad9 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -346,6 +346,18 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 	return 0;
 }
 
+u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw)
+{
+	struct virtio_net_config __iomem *config;
+	u16 val, mq;
+
+	config = hw->dev_cfg;
+	val = vp_ioread16((__le16 __iomem *)&config->max_virtqueue_pairs);
+	mq = le16_to_cpu((__force __le16)val);
+
+	return mq;
+}
+
 static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 {
 	struct virtio_pci_common_cfg __iomem *cfg;
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index f5563f665cc6..d54a1bed212e 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -130,6 +130,7 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
 int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
 u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
 int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
+u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
 int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 0a5670729412..3ff7096d30f1 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -791,6 +791,9 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	vf->hw_features = ifcvf_get_hw_features(vf);
 	vf->config_size = ifcvf_get_config_size(vf);
 
+	ifcvf_mgmt_dev->mdev.max_supported_vqs = ifcvf_get_max_vq_pairs(vf);
+	ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
+
 	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
 	ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
 	if (ret) {
-- 
2.31.1

