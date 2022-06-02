Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1788C53B1CC
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiFBCsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 22:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiFBCs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 22:48:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA361E2243
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 19:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654138104; x=1685674104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5XiD0TDFUhUOH+XaPpecKMkFXnKyE6TM6h/zfwHWyJ4=;
  b=Kb+aHLSD+efE+OkwkuaDDvsQqkjxYc76I2OCZcJMtAhmEErHjCatd7y0
   1+KeHYBOvK7FraJSWSAPL+IABWM+X8xd9rS/oJ2WYoCU8MsCz2cS8BpIe
   1SwnoZ6+qvmqwWpsqUTcOAtikK66l1yT3MSTgu24yXgO+W2FNMUP14uNK
   znVFOkRntVuPiKGWtnw5uJwgCTVPZoOC8dIP4qd9op+WVJvd3SJK0J4/d
   tr7LoddFQ94YrHM4jCuYAUxucBTNWvvk/D6K5Jf/L/6hm4yjwUFfzyYPe
   MPij7ah+lFHgrJkWiZ/FwOQVAYMGzM+ou/H2cBuZJTdWYhtDXq7z0IwBG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="275874628"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="275874628"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:24 -0700
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="612608886"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:22 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 4/6] vDPA: !FEATURES_OK should not block querying device config space
Date:   Thu,  2 Jun 2022 10:38:43 +0800
Message-Id: <20220602023845.2596397-5-lingshan.zhu@intel.com>
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

Users may want to query the config space of a vDPA device,
to choose a appropriate one for a certain guest. This means the
users need to read the config space before FEATURES_OK, and
the existence of config space contents does not depend on
FEATURES_OK.

This commit removes FEATURES_OK blocker in vdpa_dev_config_fill()
which calls vdpa_dev_net_config_fill() for virtio-net

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index c820dd2b0307..030d96bdeed2 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -863,17 +863,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
 {
 	u32 device_id;
 	void *hdr;
-	u8 status;
 	int err;
 
 	mutex_lock(&vdev->cf_mutex);
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

