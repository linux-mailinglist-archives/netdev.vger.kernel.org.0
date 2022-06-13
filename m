Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C670954891A
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245040AbiFMKo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 06:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346200AbiFMKnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 06:43:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC66DEE4
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 03:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655115883; x=1686651883;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h9JuejVy5sfA85HHvW6hE2dzeY7YiQJl4dEbEkp7nKM=;
  b=N9NbwwoFOR7dquX2zfZyexRFH/qAQE2klU9Nbm2uhGJLRjYrVx3qMFs3
   C6RIQR9GRUmpvdQHFVUmqEPzaTMqCCGOxtJAIKcODZglYwWqrDDIBPp7v
   Q63gtN/ybdQCM4wnci5HVyQWbary5IOal3sw+Q5bh3vgu1gdIpqf9VK9x
   /NUAfjQ9X86+jNbRPXk3BQ1bxKXQWiXm4Lfy2hLqTr8R1BuPhdVgGHOp7
   s5VDOIYB9Op16nW+qWF8HjtVABA9JjhOrBGRPMpcpyI9mJnaqGT/RVU2F
   MSKwLCLsdZAPxx3YxQSFj1PFqLdJqWnFUkyPt9vmozgjTLfh7lW7YyLjP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="266930305"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266930305"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="829730388"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:41 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 1/6] vDPA/ifcvf: get_config_size should return a value no greater than dev implementation
Date:   Mon, 13 Jun 2022 18:16:47 +0800
Message-Id: <20220613101652.195216-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220613101652.195216-1-lingshan.zhu@intel.com>
References: <20220613101652.195216-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ifcvf_get_config_size() should return a virtio device type specific value,
however the ret_value should not be greater than the onboard size of
the device implementation. E.g., for virtio_net, config_size should be
the minimum value of sizeof(struct virtio_net_config) and the onboard
cap size.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 13 +++++++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 48c4dadb0c7c..fb957b57941e 100644
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
+		config_size = cap_size >= net_config_size ? net_config_size : cap_size;
 		break;
 	case VIRTIO_ID_BLOCK:
-		config_size = sizeof(struct virtio_blk_config);
+		config_size = cap_size >= blk_config_size ? blk_config_size : cap_size;
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

