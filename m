Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF83E57E133
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiGVMBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiGVMBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:01:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8106FBB21E
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658491281; x=1690027281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=86jWivhk8meiZMigHF+qUhjT86a05RroUkEG49GRzh8=;
  b=VIbbL05K4B6qpuKWQsj/Os0YoMvQriZ7/4MqVlHG7IHGmX/ci0t2P/6u
   lszejsqSYTzkq/36/4zzzH4ZgNh7w8YPr5KF2Da2yLQ/osUX6eNQK1bZn
   8Cz25E1fDNS/HmesscRJB3elzoqQQ+3d0GPBEGNU19lFZuzgN/T5CBa7E
   7+Y9Ta3ziLV8KX/UX3VP+4u9nFCgzTwe21cInIQGTPdMgyfiPek3KGmKR
   awaPoceJjVE/5GWvq4UdK5wU8Mzu0lRAxJdzx8RSmPm9NkruLH2oHUPd6
   VHN7fL6Gvpmk1CHU4jqceAlqxgHfBK7gSYuVlwxaVxyxNO8+6EtNrEUhY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="284850205"
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="284850205"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:01:21 -0700
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="657189838"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:01:19 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 4/6] vDPA: !FEATURES_OK should not block querying device config space
Date:   Fri, 22 Jul 2022 19:53:07 +0800
Message-Id: <20220722115309.82746-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220722115309.82746-1-lingshan.zhu@intel.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users may want to query the config space of a vDPA device,
to choose a appropriate one for a certain guest. This means the
users need to read the config space before FEATURES_OK, and
the existence of config space contents does not depend on
FEATURES_OK.

The spec says:
The device MUST allow reading of any device-specific configuration
field before FEATURES_OK is set by the driver. This includes
fields which are conditional on feature bits, as long as those
feature bits are offered by the device.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 9b0e39b2f022..d76b22b2f7ae 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
 {
 	u32 device_id;
 	void *hdr;
-	u8 status;
 	int err;
 
 	down_read(&vdev->cf_lock);
-	status = vdev->config->get_status(vdev);
-	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
-		NL_SET_ERR_MSG_MOD(extack, "Features negotiation not completed");
-		err = -EAGAIN;
-		goto out;
-	}
-
 	hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
 			  VDPA_CMD_DEV_CONFIG_GET);
 	if (!hdr) {
-- 
2.31.1

