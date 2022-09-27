Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0FC5EB85E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiI0DMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiI0DLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:11:31 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ACD2AEB;
        Mon, 26 Sep 2022 20:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664248174; x=1695784174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s2lA+Ycgcd4GvWEVH0oc8utZsq2+n/HosRqNW2xvB5E=;
  b=lWgfq2SRvRTgGmGp8Y6yrB2DQWBtDZyuqqkxZsYmMD4H4E+3/i6fgtfK
   /dmYCLUdRmEKyZQydmWZIlAuxfD6WVQXliUqmwo4/UrNqQ6WisoLXPU5b
   KvSvls8PyI2nXHAizprFsGCH20yjxbY+pM+er1NC92NztXCqhxbhYvGSF
   Tqe3PKR2iDLoocHuNUzyEbCo8jfjhAeKIcePsHlzOXiKxuLf4PrdyN1MW
   DoaOKJNWCAX4SLyy73wVsbfrRJLpJ8ArDmbAm3rnOX3K3A78QBuBXQ3ZY
   bhWSFh53ZjjX56M0cP37mmoRbteQrAZ0u0ZCPYZV7DEPJDyFSET0RZ/7U
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="327558441"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="327558441"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:33 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="710387758"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="710387758"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:31 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 RESEND 2/6] vDPA: only report driver features if FEATURES_OK is set
Date:   Tue, 27 Sep 2022 11:01:13 +0800
Message-Id: <20220927030117.5635-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927030117.5635-1-lingshan.zhu@intel.com>
References: <20220927030117.5635-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit reports driver features to user space
only after FEATURES_OK is features negotiation is done.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 2035700d6fc8..e7765953307f 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -816,7 +816,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
 	struct virtio_net_config config = {};
-	u64 features_device, features_driver;
+	u64 features_device;
 	u16 val_u16;
 
 	vdev->config->get_config(vdev, 0, &config, sizeof(config));
@@ -833,11 +833,6 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
-	features_driver = vdev->config->get_driver_features(vdev);
-	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
-			      VDPA_ATTR_PAD))
-		return -EMSGSIZE;
-
 	features_device = vdev->config->get_device_features(vdev);
 
 	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
@@ -851,6 +846,8 @@ static int
 vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid, u32 seq,
 		     int flags, struct netlink_ext_ack *extack)
 {
+	u64 features_driver;
+	u8 status = 0;
 	u32 device_id;
 	void *hdr;
 	int err;
@@ -874,6 +871,19 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
 		goto msg_err;
 	}
 
+	/* only read driver features after the feature negotiation is done */
+	if (vdev->config->get_status)
+		status = vdev->config->get_status(vdev);
+
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

