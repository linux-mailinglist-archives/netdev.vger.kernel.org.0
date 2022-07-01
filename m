Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963D9563473
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiGANgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiGANgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:36:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBD217040
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 06:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656682578; x=1688218578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Reo8CxYRewxfHBU6WtEXtmO9UgPYY/KQX9B0Ypt+ZUg=;
  b=WGpzEXuDm2QTOB5ZmBDRRyfmxKotvBc27rsGooxdKjT1jDLT/0kMRp+c
   8HOj9BvZLbu+S2Z5D5wmgilT13PXFJxWdHipUglbdaVeIEelKSteS+c2r
   U8RydvHijg0TTTW48ip5yVAALSK2qVTnFU7Xfz8IZaF/AaoqQeUxKXNjD
   PuSbnaCDFCXMFO75YKl1Cm0BtMIVYvyN0+F8O6LpyjE+Efr8zlofv/g07
   /S+y56JBGp/GElvvmba878MPxMZbR2PXY/psbz5rZWbyvGWXcPSFnnxG0
   c30SLm9BJpytZI2BGZP4rSspQRBnE0qAI2d/SyvZse6XwkOZ7jXuP9Wxc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282682911"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="282682911"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="648349635"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:16 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA device
Date:   Fri,  1 Jul 2022 21:28:23 +0800
Message-Id: <20220701132826.8132-4-lingshan.zhu@intel.com>
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

This commit adds a new vDPA netlink attribution
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
features of vDPA devices through this new attr.

Fixes: a64917bc2e9b vdpa: (Provide interface to read driver feature)
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c       | 13 +++++++++----
 include/uapi/linux/vdpa.h |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index ebf2f363fbe7..9b0e39b2f022 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
 	struct virtio_net_config config = {};
-	u64 features;
+	u64 features_device, features_driver;
 	u16 val_u16;
 
 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
@@ -832,12 +832,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
-	features = vdev->config->get_driver_features(vdev);
-	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
+	features_driver = vdev->config->get_driver_features(vdev);
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
+			      VDPA_ATTR_PAD))
+		return -EMSGSIZE;
+
+	features_device = vdev->config->get_device_features(vdev);
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
-	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
+	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
 }
 
 static int
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
index 25c55cab3d7c..39f1c3d7c112 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -47,6 +47,7 @@ enum vdpa_attr {
 	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
 	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
 	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
+	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
 
 	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
 	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
-- 
2.31.1

