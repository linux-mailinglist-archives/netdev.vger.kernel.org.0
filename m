Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94BC5B32C9
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiIIJGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiIIJFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:05:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE8511B74E;
        Fri,  9 Sep 2022 02:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662714325; x=1694250325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I1wAmxOcPfTi3B2DbPxtZHesyzp0WOBwfWf6hCQ2Hy4=;
  b=jdSv++fP2wnxy30TUALmqT7aAi+EFD99g1MbgwqHoXrQE1QsAmWgqV75
   QQ3Jjr1lfEE6vS7s3jCPg8ZeKrrfkpzama/rn7MgKY3KYEVmft5qOPlHh
   X1KWNRL0o+xsCWH4+YfmpEakE/FiKTLPSz80G9+M6BSFrRLxlsL//t8ra
   q8js07p74kPnTlSuHbZjjbdPjYK2ZyjknM4671pcxNZq+kD72O/1IO9LX
   ipRTUV15wZSWWO7JI+/tbdw+6FtqGMr1gXaosh2lKgOq5iatEmo0TITiJ
   s0hqrzLzKCpD8Qlul7lvlFEsZubcf/mSs56hlOo5uVRPZvQS3VqwR1HvL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277165795"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="277165795"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:25 -0700
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="592540342"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:23 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/4] vDPA: allow userspace to query features of a vDPA device
Date:   Fri,  9 Sep 2022 16:57:09 +0800
Message-Id: <20220909085712.46006-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220909085712.46006-1-lingshan.zhu@intel.com>
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a new vDPA netlink attribution
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
features of vDPA devices through this new attr.

This commit invokes vdpa_config_ops.get_config() than
vdpa_get_config_unlocked() to read the device config
spcae, so no raeces in vdpa_set_features_unlocked()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c       | 19 ++++++++++++++-----
 include/uapi/linux/vdpa.h |  4 ++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index c06c02704461..798a02c7aa94 100644
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
@@ -815,10 +817,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
 	struct virtio_net_config config = {};
-	u64 features;
+	u64 features_device, features_driver;
 	u16 val_u16;
 
-	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
+	vdev->config->get_config(vdev, 0, &config, sizeof(config));
 
 	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
 		    config.mac))
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
index 25c55cab3d7c..97531b52dcbe 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -46,12 +46,16 @@ enum vdpa_attr {
 
 	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
 	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
+	/* features of a vDPA management device */
 	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
 
 	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
 	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
 	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
 
+	/* features of a vDPA device, e.g., /dev/vhost-vdpa0 */
+	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
+
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
 };
-- 
2.31.1

