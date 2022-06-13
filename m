Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC27548799
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 17:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244047AbiFMKoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 06:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346698AbiFMKnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 06:43:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778DFB1E3
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 03:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655115893; x=1686651893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MbjT3H7MWqaiAeIOcXecNHn8r/cvFswi54ees8nsPb8=;
  b=SJBzNfCSRrFRpz94yYZZgKvz+IbWZAeqbjyXf6t9LFiUJhWyOqT/Is2D
   hIz5Kn2HESdczQhFLxIYDyyYzXEAFqKcHYElgjzHpftPsX8T+cyPAPiTp
   UogDeFwQgZjU/2C4aJl4Se7QzUYUXADNO7H9xZ1p9mrpaKAchf8Xat2xi
   FowjSURiScwQOtCF9g6O73My+yikj5Zx0dYyXD1mHZ2tCXSRjZUMXiUx/
   rRksD5P1XFJj60r6tOs6Z+7lL+e1fHFDv85+HJcd0H4sWGToWJNvXBHUE
   1KgobOlTcWPKJAhfmuQJuIqrGrI3MZgV+CkEEScYVjUz8Iw0CyNT3k8sk
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="266930333"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266930333"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="829730445"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:51 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to userspace when VIRTIO_NET_F_MQ == 0
Date:   Mon, 13 Jun 2022 18:16:51 +0800
Message-Id: <20220613101652.195216-6-lingshan.zhu@intel.com>
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

