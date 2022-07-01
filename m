Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A554556346D
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiGANgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiGANg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:36:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B7617E28
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 06:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656682585; x=1688218585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PSHnAfe8LQ//2rWp6Lo496ExCrGTLYCKJo/7E2AZ/Kc=;
  b=oGiihEIHJDFMKJ08470GASzdN1qsLtHE40pqUjx2lOF2321cxzlpEmwl
   dXg+iQAkioLf/lto43qBUrswQYFcjh94n1yE+ojM9cRZrEID3QQx/FHDs
   9xv7NQMJfpOxkVGRL6SLYp5dkyBcu9Hw9vEO2vaijcM1ULI//y2LXxah7
   VAPQFqDh4M3/uaGPMDcG23feWnUXhb/Fpt0EvYHDd7tn3nlzlWymArs1k
   adc2U7D+OVOISmj5fYD3UVC5I0bS/kwjnqf0ViSL8EXzYf+Lyqa6+fZQ9
   lkcsU5N6YCEGoBnZyEu3OBTC5S37yZRa4YNM0VkY9MKixyQDMbLqi+k9R
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282682931"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="282682931"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:25 -0700
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="648349652"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:23 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in vdpa.c
Date:   Fri,  1 Jul 2022 21:28:26 +0800
Message-Id: <20220701132826.8132-7-lingshan.zhu@intel.com>
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

This commit fixes spars warnings: cast to restricted __le16
in function vdpa_dev_net_config_fill() and
vdpa_fill_stats_rec()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 846dd37f3549..ed49fe46a79e 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 		    config.mac))
 		return -EMSGSIZE;
 
-	val_u16 = le16_to_cpu(config.status);
+	val_u16 = __virtio16_to_cpu(true, config.status);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
 		return -EMSGSIZE;
 
-	val_u16 = le16_to_cpu(config.mtu);
+	val_u16 = __virtio16_to_cpu(true, config.mtu);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
@@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
 	}
 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
 
-	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
+	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
 		return -EMSGSIZE;
 
-- 
2.31.1

