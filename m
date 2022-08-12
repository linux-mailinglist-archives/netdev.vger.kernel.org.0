Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778F0590FB7
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237452AbiHLKxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbiHLKxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:53:05 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A781FA3D5E;
        Fri, 12 Aug 2022 03:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660301584; x=1691837584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kEWLumMQSQliyx8zm3H/DRyVtVESwt+9Ud2q9KqZT7A=;
  b=B+CXuwl4nxceMT+EyOzLgLYm18M6hYTkNCgdrJDsIXxV0Bc6DoNe3azF
   ybjkoPSp/vp8SaNwpfex5fD0SjuHEqtYJzkzF2V4x+jeT06APsH15879e
   LcefCH59EbVIQX6K9zKvHjecvy55EivA5jEqIVwsXyfL0eYkmyB9yyz0J
   tlzWF5Dg8NwEzpCQeaLhK5efX/LbE1vR+gRrHvXMWfrjpQNfEcWZkWKm8
   UtarF+zc7KYxEwgpEEd4TGzIgkIQBXyoM+sL3mNh23LKLLW5hr3X5LLFD
   vof4SnCwwjimsB/epA+htJQATVijSSjpwFcz0AjTM4GcDL+cN4BDifAj+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271956269"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="271956269"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665780581"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:02 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 1/6] vDPA/ifcvf: get_config_size should return a value no greater than dev implementation
Date:   Fri, 12 Aug 2022 18:44:55 +0800
Message-Id: <20220812104500.163625-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220812104500.163625-1-lingshan.zhu@intel.com>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers must not access a BAR outside the capability length,
and for a virtio device, ifcvf driver should not report any non-standard
capability contents to the upper layers.

Function ifcvf_get_config_size() is introduced here to return a safe value
of the device config capability size.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 13 +++++++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 48c4dadb0c7c..85611be5ccb4 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -128,6 +128,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 			break;
 		case VIRTIO_PCI_CAP_DEVICE_CFG:
 			hw->dev_cfg = get_cap_addr(hw, &cap);
+			hw->cap_dev_config_size = le32_to_cpu(cap.length);
 			IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
 			break;
 		}
@@ -233,15 +234,23 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
 {
 	struct ifcvf_adapter *adapter;
+	u32 net_config_size = sizeof(struct virtio_net_config);
+	u32 blk_config_size = sizeof(struct virtio_blk_config);
+	u32 cap_size = hw->cap_dev_config_size;
 	u32 config_size;
 
 	adapter = vf_to_adapter(hw);
+	/* If the onboard device config space size is greater than
+	 * the size of struct virtio_net/blk_config, only the spec
+	 * implementing contents size is returned, this is very
+	 * unlikely, defensive programming.
+	 */
 	switch (hw->dev_type) {
 	case VIRTIO_ID_NET:
-		config_size = sizeof(struct virtio_net_config);
+		config_size = min(cap_size, net_config_size);
 		break;
 	case VIRTIO_ID_BLOCK:
-		config_size = sizeof(struct virtio_blk_config);
+		config_size = min(cap_size, blk_config_size);
 		break;
 	default:
 		config_size = 0;
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 115b61f4924b..f5563f665cc6 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -87,6 +87,8 @@ struct ifcvf_hw {
 	int config_irq;
 	int vqs_reused_irq;
 	u16 nr_vring;
+	/* VIRTIO_PCI_CAP_DEVICE_CFG size */
+	u32 cap_dev_config_size;
 };
 
 struct ifcvf_adapter {
-- 
2.31.1

