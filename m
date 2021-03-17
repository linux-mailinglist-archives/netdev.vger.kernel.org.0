Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5BA33ED92
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhCQJz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:55:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:59767 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhCQJy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 05:54:57 -0400
IronPort-SDR: dNYUU1o9Bz9aTc9Eqo++T8FxZYgWothrpo7PUntzuL3WZJf/BUkySG+lcloa03uDIIn3cx/Jvd
 5YCpllcXQMCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="187058684"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="187058684"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:57 -0700
IronPort-SDR: Sd3o6NX7gxdc5qeldh2nOQT5EKz+Wss8pdWj7cBQ5R2wpwCy0XQ1o6tXeRBRD9dBRX6zkKaAf1
 p33z7XLRrM2w==
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="405873242"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:55 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 6/7] vDPA/ifcvf: verify mandatory feature bits for vDPA
Date:   Wed, 17 Mar 2021 17:49:32 +0800
Message-Id: <20210317094933.16417-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317094933.16417-1-lingshan.zhu@intel.com>
References: <20210317094933.16417-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA requres VIRTIO_F_ACCESS_PLATFORM as a must, this commit
examines this when set features.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c |  5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index ea6a78791c9b..1a661ab45af5 100644
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
+		IFCVF_ERR(ifcvf->pdev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
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

