Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B3C57E134
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiGVMBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiGVMBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:01:24 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0425BB214
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658491283; x=1690027283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MbjT3H7MWqaiAeIOcXecNHn8r/cvFswi54ees8nsPb8=;
  b=jyrdLvYCCdtUmuoIIQHg9q/3n5c++gCeRde/zynEoMHBMtatQRnyfnIw
   VULP9bO0xRA9KguTeqjHbH9BzTE3Tl6uF2nUYhJK71Bb6PcHTTgytjABK
   cR0yUO/0G8IF1L2aQKqI+QRdiI33zZSy+3C9NSjXbnyuyEE3o0xSgkueR
   t3z93WPUbUAXUadbqTPcnBJz1XNJBw9LL2+bRsE3+j9YMZIexrTMEwqwl
   EjtBxElLop05YCtQMChIulN4u9HiQEJDVyKbyzkEfAvctRhr7BjSV/iuk
   VKTqzJqyJba5pYcZc3gSzX2D+i/f8Q29KqQ7uJB9RliSWvnhW/B8j/tVs
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="284850212"
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="284850212"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:01:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="657189848"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:01:21 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 5/6] vDPA: answer num of queue pairs = 1 to userspace when VIRTIO_NET_F_MQ == 0
Date:   Fri, 22 Jul 2022 19:53:08 +0800
Message-Id: <20220722115309.82746-6-lingshan.zhu@intel.com>
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

If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair,
so when userspace querying queue pair numbers, it should return mq=1
than zero.

Function vdpa_dev_net_config_fill() fills the attributions of the
vDPA devices, so that it should call vdpa_dev_net_mq_config_fill()
so the parameter in vdpa_dev_net_mq_config_fill()
should be feature_device than feature_driver for the
vDPA devices themselves

Before this change, when MQ = 0, iproute2 output:
$vdpa dev config show vdpa0
vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false
max_vq_pairs 0 mtu 1500

After applying this commit, when MQ = 0, iproute2 output:
$vdpa dev config show vdpa0
vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false
max_vq_pairs 1 mtu 1500

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index d76b22b2f7ae..846dd37f3549 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -806,9 +806,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 	u16 val_u16;
 
 	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
-		return 0;
+		val_u16 = 1;
+	else
+		val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
 
-	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
 	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
 }
 
@@ -842,7 +843,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
-	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
+	return vdpa_dev_net_mq_config_fill(vdev, msg, features_device, &config);
 }
 
 static int
-- 
2.31.1

