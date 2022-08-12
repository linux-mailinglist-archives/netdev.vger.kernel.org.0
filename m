Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7797590FBD
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbiHLKxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237969AbiHLKxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:53:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7A9AB428;
        Fri, 12 Aug 2022 03:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660301592; x=1691837592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KWgTPPBSI8MZm6kALBx+R/F3bnsIXVq3PluRs5MVlcA=;
  b=GzHCNbG7kKQKWyRItlV9TXOXHT0KKA60AJjm89znnaedTC+5YPGo1tEH
   mQUYc+ceXp1WERcckA4xhB2KEIXRQl68HMFJZZ0eRI+His1F6pla8b8rV
   RywAkrYLlxD9EdErdyUkV4N3Kx0ARPzLvip3ZQDke8TIBz2djS5zf3ZuL
   i2oA1dEndVuDeqwiC4mSRQ84OGa9oTLNSLmBqoDQOgQ5NkOeXPzvbEpRn
   kcFZ+fWM2+qow2+24o/f7Ouy+RVpv/BMWEuZxWXtAoS52AVh88Q4BKt5p
   QkhFQ+g5MUeuiapOmL4t1jwLGtC8siGKqnyyTOIhf2q5alcRI17lc0alJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271956309"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="271956309"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665780611"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:09 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 4/6] vDPA: !FEATURES_OK should not block querying device config space
Date:   Fri, 12 Aug 2022 18:44:58 +0800
Message-Id: <20220812104500.163625-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220812104500.163625-1-lingshan.zhu@intel.com>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 6eb3d972d802..bf312d9c59ab 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -855,17 +855,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
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

