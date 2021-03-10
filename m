Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F8D33382F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhCJJGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:06:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:64352 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232543AbhCJJGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:06:17 -0500
IronPort-SDR: 2WBpFZu3OSID21g4un4pdGjC8K1GMCBm3rPJ6pT6xLwccPjXkNpfYOI7H8qHVuux+GaMJFy2jr
 9i/5oVF8BDZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188461287"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="188461287"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:16 -0800
IronPort-SDR: UMcHxfR5j1/WESWpiQIfAqBkak8tKIs3NFHxTms4wBzfyUkrE/1nmCm819e05X3EdB8fBU9qRZ
 ksfqEmaSepUw==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="410110495"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:14 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 6/6] vDPA/ifcvf: verify mandatory feature bits for vDPA
Date:   Wed, 10 Mar 2021 17:00:52 +0800
Message-Id: <20210310090052.4762-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210310090052.4762-1-lingshan.zhu@intel.com>
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA requres VIRTIO_F_ACCESS_PLATFORM as a must, this commit
examines this when set features.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 8 ++++++++
 drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index ea6a78791c9b..58f47fdce385 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -224,6 +224,14 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
 	return hw->hw_features;
 }
 
+int ifcvf_verify_min_features(struct ifcvf_hw *hw)
+{
+	if (!(hw->hw_features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
+		return -EINVAL;
+
+	return 0;
+}
+
 void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
 			   void *dst, int length)
 {
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index dbb8c10aa3b1..91c5735d4dc9 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -123,6 +123,7 @@ void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
 void ifcvf_reset(struct ifcvf_hw *hw);
 u64 ifcvf_get_features(struct ifcvf_hw *hw);
 u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
+int ifcvf_verify_min_features(struct ifcvf_hw *hw);
 u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
 int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 25fb9dfe23f0..f624f202447d 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -179,6 +179,11 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
 static int ifcvf_vdpa_set_features(struct vdpa_device *vdpa_dev, u64 features)
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	int ret;
+
+	ret = ifcvf_verify_min_features(vf);
+	if (ret)
+		return ret;
 
 	vf->req_features = features;
 
-- 
2.27.0

