Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB895EEB46
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiI2ByV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI2ByU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:54:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B4848E80;
        Wed, 28 Sep 2022 18:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664416456; x=1695952456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y7l7xFJT97zU1BKhh36MFM4wiXm5W6x1xg/x3P6bd9Y=;
  b=ZcjqSfiU8ShCooHOxBbS/sIkdE2OA3DL9SZi3p7npgRjHb1p5vPqqQaP
   J1Js0DerEDYIKwWCKQHoW+4Qnziu0ka67KYgrnr29e9dWPifdNggx3Sb9
   HQ75SVBR7ZBxe6omgEZ9U74oR3+sOBsornyr9Fm+4Ww80X4h2EaBamtex
   7owIdVnoTINcYpo0NPC/pCPFulN4iYLRmmkht9LIOl7Z+4cSSMfeu6CC5
   1zh2U6p0PfzpuTwL4FiD49LmU2Y8MdNKX+tmqpuQldrFuscFJV3KwK74i
   cmtCzEvclV7YMs0kg32QvCYOqx29n6EIkPYM0hRw6G8Vj2Q99qTiEmZLz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="365813990"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="365813990"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:15 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="950931679"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="950931679"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:15 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 2/6] vDPA: only report driver features if FEATURES_OK is set
Date:   Thu, 29 Sep 2022 09:45:51 +0800
Message-Id: <20220929014555.112323-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220929014555.112323-1-lingshan.zhu@intel.com>
References: <20220929014555.112323-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit reports driver features to user space
only after FEATURES_OK is features negotiation is done.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 1363b42c9d28..52b7f5d23127 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
 	struct virtio_net_config config = {};
-	u64 features_device, features_driver;
+	u64 features_device;
 	u16 val_u16;
 
 	vdev->config->get_config(vdev, 0, &config, sizeof(config));
@@ -832,11 +832,6 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
-	features_driver = vdev->config->get_driver_features(vdev);
-	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
-			      VDPA_ATTR_PAD))
-		return -EMSGSIZE;
-
 	features_device = vdev->config->get_device_features(vdev);
 
 	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
@@ -850,6 +845,8 @@ static int
 vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid, u32 seq,
 		     int flags, struct netlink_ext_ack *extack)
 {
+	u64 features_driver;
+	u8 status = 0;
 	u32 device_id;
 	void *hdr;
 	int err;
@@ -873,6 +870,17 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
 		goto msg_err;
 	}
 
+	/* only read driver features after the feature negotiation is done */
+	status = vdev->config->get_status(vdev);
+	if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
+		features_driver = vdev->config->get_driver_features(vdev);
+		if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
+				      VDPA_ATTR_PAD)) {
+			err = -EMSGSIZE;
+			goto msg_err;
+		}
+	}
+
 	switch (device_id) {
 	case VIRTIO_ID_NET:
 		err = vdpa_dev_net_config_fill(vdev, msg);
-- 
2.31.1

