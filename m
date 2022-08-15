Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78368592BAD
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241647AbiHOJez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 05:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242022AbiHOJey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 05:34:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BFA1CB15;
        Mon, 15 Aug 2022 02:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660556093; x=1692092093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gi3LX/e7jzGTZBIEskF9nXx3khzysDoH1ztTscnG5Zw=;
  b=mHGxXW5fZC+z4KRKxd7IG8JZ12okjvoRB7IekiKhWcQNgBBBRDhOM4gM
   Fj3s16Fod/3FfpUNmjcveeDxfOjGgjSmsLzfNtjwLmwRzU8mmuia49A8s
   +vNuKouN9Y/rz4oNukC2YFjuwlKJfQl8Opl5mj9aR/xYsmM1QeFwaSpUr
   IIQF0Q0lLSuVhgwQQFJ3dIMj6xsMhm900bFlAJzCxMF+adJVkWuvYzQeH
   6QPXJOjZc2VNwTxZuhqtFTWJp3qto8piD0LPeT1rhQUu7HEzCC7+7TPby
   9weLTXBKhZHwNr1Ql/IA3cQqhfga1ax2lW6VKXbWVWc/zAXOij0NBuWGg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10439"; a="353668400"
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="353668400"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 02:34:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="666604160"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 02:34:50 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/2] vDPA: allow userspace to query features of a vDPA device
Date:   Mon, 15 Aug 2022 17:26:37 +0800
Message-Id: <20220815092638.504528-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220815092638.504528-1-lingshan.zhu@intel.com>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
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

This commit adds a new vDPA netlink attribution
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
features of vDPA devices through this new attr.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c       | 17 +++++++++++++----
 include/uapi/linux/vdpa.h |  3 +++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index c06c02704461..efb55a06e961 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -491,6 +491,8 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
 		err = -EMSGSIZE;
 		goto msg_err;
 	}
+
+	/* report features of a vDPA management device through VDPA_ATTR_DEV_SUPPORTED_FEATURES */
 	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
 			      mdev->supported_features, VDPA_ATTR_PAD)) {
 		err = -EMSGSIZE;
@@ -815,7 +817,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
 	struct virtio_net_config config = {};
-	u64 features;
+	u64 features_device, features_driver;
 	u16 val_u16;
 
 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
@@ -832,12 +834,19 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
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
+
+	/* report features of a vDPA device through VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES */
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
-	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
+	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
 }
 
 static int
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
index 25c55cab3d7c..d171b92ef522 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -46,7 +46,10 @@ enum vdpa_attr {
 
 	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
 	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
+	/* features of a vDPA management device */
 	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
+	/* features of a vDPA device, e.g., /dev/vhost-vdpa0 */
+	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
 
 	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
 	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
-- 
2.31.1

