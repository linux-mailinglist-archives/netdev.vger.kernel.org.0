Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0705F525E62
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378544AbiEMIsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378374AbiEMIsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:48:17 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7786A044
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652431696; x=1683967696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zjM2lpnVEzgr9EqxgfBHSEFdupKbJYQ6DivWQeNJjbk=;
  b=kKfW8OjlD1WV3bQpAN6VsNWtg+SitPb0RZPFHSwWX5cWwXYs8W1DBv+l
   nwtuQV84AZKKPyuB+JuRosRtSHJn4XDr22/mScTtHydEnRhkIEK/Vl1/f
   QDpHKI+gz4KaRKuB1tjK8q7nvLyWcCXhHcEE1Qj9GfwtfS/UE/STWgu19
   9fzGTEJZx+4dPkOpOVOoLN/DR0uBp5bUmaoH+ccpSVD5bxAEYof+SzuxK
   NPjDn2Da4OPxaJSmTKnkD99uOMbq+/F6wHALI8aOB2YP8nMoGQLhVYVP5
   H4fWrDdxA9iNfCDHsL1bdBrEWMfwxTqkLQf7nBJuA8rkWp2cxNIB4iAZ4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="356682848"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="356682848"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 01:48:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="595122619"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 01:48:05 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 2/6] vDPA/ifcvf: support userspace to query features and MQ of a management device
Date:   Fri, 13 May 2022 16:39:31 +0800
Message-Id: <20220513083935.1253031-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220513083935.1253031-1-lingshan.zhu@intel.com>
References: <20220513083935.1253031-1-lingshan.zhu@intel.com>
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

Adapting to current netlink interfaces, this commit allows userspace
to query feature bits and MQ capability of a management device.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
 3 files changed, 16 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 6bccc8291c26..7be703b5d1f4 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -341,6 +341,18 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 	return 0;
 }
 
+u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw)
+{
+	struct virtio_net_config __iomem *config;
+	u16 val, mq;
+
+	config  = (struct virtio_net_config __iomem *)hw->dev_cfg;
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
index 4366320fb68d..0c3af30b297e 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -786,6 +786,9 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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

