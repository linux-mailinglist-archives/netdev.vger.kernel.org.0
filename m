Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6699E56346F
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiGANgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiGANgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:36:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D200A17589
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 06:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656682580; x=1688218580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V6w/dAG4EE5bDzyLtgiiTv060y/2l8ouvlrLcz0KnS0=;
  b=SeE2x/kLRXmMJPZa3SkDbtIVcB6L9n0XZiSN/5exBIiVKfHags9EtZ2b
   hPvTNBRqG5INlIlZsniClEaODbpp/GlVZisRB8sQ92EOJB9BXZkUnEeM+
   yRpI9jABjLzT/UeulMLb1TAWpuYjfgj1giOUGfFMZstw/tAbf15E/PDLp
   u6keFmsacNN16QsK0VW3KiANWR40xnWifURLhP1BKNuVIcOS1PZ2bgOgR
   xCDSvJx8aiX6erA3j7kcTcmWZzKL5ydiqkkraNNlGtN3OFnwG7ZjpdIGu
   azkTjPabup7L6X182FflwZmXwQaHNA/uEJIfNh7Yf5/2idYRF6+aqwu/6
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282682917"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="282682917"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="648349643"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:18 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying device config space
Date:   Fri,  1 Jul 2022 21:28:24 +0800
Message-Id: <20220701132826.8132-5-lingshan.zhu@intel.com>
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

Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if FEATURES_OK)
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

