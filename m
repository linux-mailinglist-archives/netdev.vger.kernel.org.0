Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2489153B1B8
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiFBCsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 22:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiFBCsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 22:48:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79F41CC61B
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 19:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654138102; x=1685674102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yeBPPguXS1ls/KOV59s8KPqSu7LlsXtGMOSdmZuYr68=;
  b=cZSmEoAIJJY41fXOlzC2B2OAYbE1VWYTru7mJpUmR5kMCyxCJPBZZjKz
   A1L8OCww6sKFTZ2HGndIXaQwap2QG25yjGIhS9Rg5MDP3ElKYWfQN3DjU
   H6uDuKCdKWT537J4cJtou0NMMsJg3owXmZWXWXYBDZ8cWvoX382Ez9kzn
   t9RfOE6h6fygnOCJm7YI66imPaCJ42de0ag1edkXn4ZWdddhxaQl120j3
   t7lLWv/GJp84WtUqirOCFcc1RI/QSEwjuoxQdFwhHzpoTRSLZEPVY6Lnd
   Z0rNcZwrzblQsW8GKYDrmHoYv2zqqiimVt2GjdresUW9Xey+O10kb5X6z
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="275874625"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="275874625"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="612608882"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:20 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 3/6] vDPA/ifcvf: support userspace to query device feature bits
Date:   Thu,  2 Jun 2022 10:38:42 +0800
Message-Id: <20220602023845.2596397-4-lingshan.zhu@intel.com>
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

This commit supports userspace to query device feature bits
by filling the relevant netlink attribute.

There are two types of netlink attributes:
VDPA_ATTR_DEV_XXXX work for virtio devices config space, and
VDPA_ATTR_MGMTDEV_XXXX work for the management devices.

This commit fixes a misuse of VDPA_ATTR_DEV_SUPPORTED_FEATURES,
this attr is for a virtio device, not management devices.

Thus VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES is introduced for
reporting management device features, and VDPA_ATTR_DEV_SUPPORTED_FEATURES
for virtio devices feature bits.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c       | 15 ++++++++++-----
 include/uapi/linux/vdpa.h |  1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 2b75c00b1005..c820dd2b0307 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -508,7 +508,7 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
 		err = -EMSGSIZE;
 		goto msg_err;
 	}
-	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES,
 			      mdev->supported_features, VDPA_ATTR_PAD)) {
 		err = -EMSGSIZE;
 		goto msg_err;
@@ -827,7 +827,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
 	struct virtio_net_config config = {};
-	u64 features;
+	u64 features_device, features_driver;
 	u16 val_u16;
 
 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
@@ -844,12 +844,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
-	features = vdev->config->get_driver_features(vdev);
-	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
+	features_driver = vdev->config->get_driver_features(vdev);
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
-	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
+	features_device = vdev->config->get_device_features(vdev);
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES, features_device,
+			      VDPA_ATTR_PAD))
+		return -EMSGSIZE;
+
+	return vdpa_dev_net_mq_config_fill(vdev, msg, features_device, &config);
 }
 
 static int
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
index 1061d8d2d09d..70a3672c288f 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -30,6 +30,7 @@ enum vdpa_attr {
 	VDPA_ATTR_MGMTDEV_BUS_NAME,		/* string */
 	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
 	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
+	VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES,	/* u64 */
 
 	VDPA_ATTR_DEV_NAME,			/* string */
 	VDPA_ATTR_DEV_ID,			/* u32 */
-- 
2.31.1

