Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5412233ACAF
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhCOHuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:50:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:17801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229939AbhCOHua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 03:50:30 -0400
IronPort-SDR: Y0TZ06LkISW0/7WbhZKEgj9Kqf/Fijf1ddYiyTC+dkUj/5r0jRgt22Usflg/Vyu6UuhmUMZmfE
 MSb505WGP3/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="189140919"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="189140919"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:29 -0700
IronPort-SDR: lx+bvN3J+NSNCL1jN5PVBX5/F6EJlDohUcy2PNu+vJRYt2Z9pKC9Ip33fXIgu3hwsWM2JLhfY+
 hcPMyl6XIqKQ==
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="411752299"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:27 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 6/7] vDPA/ifcvf: verify mandatory feature bits for vDPA
Date:   Mon, 15 Mar 2021 15:45:00 +0800
Message-Id: <20210315074501.15868-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315074501.15868-1-lingshan.zhu@intel.com>
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA requres VIRTIO_F_ACCESS_PLATFORM as a must, this commit
examines this when set features.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c |  5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index ea6a78791c9b..4f257c4b2f76 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -224,6 +224,18 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
 	return hw->hw_features;
 }
 
+int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
+{
+	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
+
+	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)) && features) {
+		IFCVF_ERR(ifcvf->pdev, "VIRTIO_F_ACCESS_PLATFORM not negotiated\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
 			   void *dst, int length)
 {
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index dbb8c10aa3b1..f77239fc1644 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -123,6 +123,7 @@ void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
 void ifcvf_reset(struct ifcvf_hw *hw);
 u64 ifcvf_get_features(struct ifcvf_hw *hw);
 u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
+int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
 u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
 int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 25fb9dfe23f0..ea93ea7fd5df 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -179,6 +179,11 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
 static int ifcvf_vdpa_set_features(struct vdpa_device *vdpa_dev, u64 features)
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	int ret;
+
+	ret = ifcvf_verify_min_features(vf, features);
+	if (ret)
+		return ret;
 
 	vf->req_features = features;
 
-- 
2.27.0

