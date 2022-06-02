Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF7A53B1BF
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiFBCsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 22:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiFBCsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 22:48:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE251CC625
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 19:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654138099; x=1685674099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SJaPkf8Mk7kpG7XQCleu+n6NzoT1H5nVd6tbpV/3If8=;
  b=Qc0E4vFifoTLDeduXdAPUAMx6ezkg3/6xBB2FBfoZMe+aRtxtPQMwvys
   /w+4qKVnz6Ctw3ey9dRT4Z8efm9CnL9SFlmjPKh8h/TVYGHXpUg0cnX+b
   g5DIz4wxO0Mvpz5lPkTFprwA55Epf80mA6G2LunDG1MaYse6Cjs5tlNOz
   ZmPRagJUEQ4kjgIbauxyk+vNEdU2tWqrFm10tLeS1Uq9GzeCqsO9MtaQK
   SMbcY8CO0TfBAW+Zfn4vFEYejvp0Jb/lZY5sfpafNihPpKDhR38BFYOlu
   9tEOxC63Lbg7kW79NyM2bzvh6jynjWyVd/Rtuo4FXv5PkctImnSODz5NF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="275874618"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="275874618"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="612608868"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:17 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/6] vDPA/ifcvf: get_config_size should return a value no greater than dev implementation
Date:   Thu,  2 Jun 2022 10:38:40 +0800
Message-Id: <20220602023845.2596397-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220602023845.2596397-1-lingshan.zhu@intel.com>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/vdpa/ifcvf/ifcvf_base.c | 8 ++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 48c4dadb0c7c..6bccc8291c26 100644
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
@@ -233,15 +234,18 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
 {
 	struct ifcvf_adapter *adapter;
+	u32 net_config_size = sizeof(struct virtio_net_config);
+	u32 blk_config_size = sizeof(struct virtio_blk_config);
+	u32 cap_size = hw->cap_dev_config_size;
 	u32 config_size;
 
 	adapter = vf_to_adapter(hw);
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

