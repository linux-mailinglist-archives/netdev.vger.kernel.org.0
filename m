Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B5A54967B
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiFMKou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 06:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346494AbiFMKnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 06:43:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD97642C
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 03:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655115891; x=1686651891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=86jWivhk8meiZMigHF+qUhjT86a05RroUkEG49GRzh8=;
  b=Y0DmwJdFDGXukn9jZ+KKRj/OKG+bWze0/nbb3MBnqhKB3d28PR0/M1tf
   TT2hE7mDv7e9o3p6hgHT4B6CJUJ/eYwHVHXPsOjQKZc+VO7XSx4j07Ak8
   JTjNr0QKFG/uBRrL6OpfMrw0Wk9xBezOmRDJ5aF9zeTMCi8ehgWZJGIsC
   OZedWprALV+mHAAftqrTRpnAtS1IT8c79M6bBrcnk+hsZlHvtVf5PGIRs
   +p5TvakUs4A5mtOtQbA/d+R4qv4a0w2RW3Ts5sbyJmKOnQOrOnz+ugpCc
   KrKDCdOZzECo9jcwPjJX4g/oQrdK4BXGK5zfucB7Rj1Htwk4FwzyR2Wdo
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="266930324"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266930324"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="829730435"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:48 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 4/6] vDPA: !FEATURES_OK should not block querying device config space
Date:   Mon, 13 Jun 2022 18:16:50 +0800
Message-Id: <20220613101652.195216-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220613101652.195216-1-lingshan.zhu@intel.com>
References: <20220613101652.195216-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

