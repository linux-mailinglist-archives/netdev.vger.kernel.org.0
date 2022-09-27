Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA645EB839
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiI0DCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiI0DAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:00:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B515D55B0;
        Mon, 26 Sep 2022 19:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664247532; x=1695783532;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s2lA+Ycgcd4GvWEVH0oc8utZsq2+n/HosRqNW2xvB5E=;
  b=NHi4l7gNrkKfW8L7yQxYa2ret2o20FWtKY80+m/0KfBCHoublESjKW2j
   iLtCaHmvqA/hHc/0XISRdICFD5/mjCaRAYKZmdvyX41QcDqy4iSI6fBnO
   q+kfpRjSEqohHrZ8eXfOX3FtndL9aichzirE1AFPTMvdHGsxJQpZUFLo1
   2QsXv96J4dlhKTSMFkl/Qy0IycFIIy9NtpgpLYP2HMgaXny26TnhazP5L
   /VRU4lokbeTJpEnKevGbTIF6pHxdzeIvHRQ73Jydsi5fbBIGhIZmNcdIx
   a7/nyCpclG/FbfDD4y4JOynz5q6ZTdHeKvyDr3cH7sYp40g6FHxDRLrbO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="387490747"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="387490747"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:52 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652105651"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652105651"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:50 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 2/6] vDPA: only report driver features if FEATURES_OK is set
Date:   Tue, 27 Sep 2022 10:50:31 +0800
Message-Id: <20220927025035.4972-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927025035.4972-1-lingshan.zhu@intel.com>
References: <20220927025035.4972-1-lingshan.zhu@intel.com>
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

