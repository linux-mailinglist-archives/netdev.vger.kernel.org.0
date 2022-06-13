Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A513548726
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 17:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243723AbiFMKoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 06:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346782AbiFMKns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 06:43:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BADD122
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 03:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655115895; x=1686651895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PSHnAfe8LQ//2rWp6Lo496ExCrGTLYCKJo/7E2AZ/Kc=;
  b=WqB43rqjwysp6TRr8f78az+uCI8lYM0o9Z6VT3y0AR9ypZRBBBDG7Zz8
   1d9havd3KG2hsiAG4WnDU/akKbrFQzb5Xu5+tVoZ3X7CYzhCDoDmbQNz/
   VlH8od5VFXEgv8pbNRdilpcM1v4oSpTzhtpDHAXSA4RkAfGeOPa76RaPu
   etruiMTh2XdV1djv1qJVUgeW+uWo9ZHzRUbLyazbm43NlSxrJ9VnSR6QZ
   3uSjuO8/ktZeY595xM6k5rvvR35zLruIaUtfF5UVs5HWWXbLVWCrXXIiG
   i1BHKemJRrh+2/mUGTxHgEf7ltcIOChKnWw0AdaEpscR4WtUzS/y1crzr
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="266930339"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266930339"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="829730453"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:53 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 6/6] vDPA: fix 'cast to restricted le16' warnings in vdpa.c
Date:   Mon, 13 Jun 2022 18:16:52 +0800
Message-Id: <20220613101652.195216-7-lingshan.zhu@intel.com>
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

