Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFDD563472
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiGANga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiGANgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:36:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BF21706B
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 06:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656682583; x=1688218583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nA6aAOQL4jOKPW3ch4cEZ/9/EOxMkwzBotlCyalcNDE=;
  b=QluRVHLF9U2Zk20os52ZI0mxLXks51sqmBQ8TPHBM+tQEH29bVtLK/9A
   9+FeXYel5LcOlZdWfcdqnZy/yXK1a0ZopC0n4I5pEb4euRR0NgT9kK8zo
   2LCK2qxB2KErK2j3t6cErFw64jmd7xed0RbD0FRBzjZOvS5tW76So21B9
   E00dQ1cIpzyMMdPxhaMw1/20Pn1T4oDB+ylfrRSFFU2h7tROlSijrOf4f
   5lvqqXVQ9w05foO6yzwCZpWdN31mPMlKGp+zCGuW562Oam5WLREHRxV3u
   yCmZjbOjHEogpgTsNwcHVFm75r0OzLMAqlOTnMugMwqBaWVY+/w1DmbtU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282682924"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="282682924"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="648349647"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:20 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace when VIRTIO_NET_F_MQ == 0
Date:   Fri,  1 Jul 2022 21:28:25 +0800
Message-Id: <20220701132826.8132-6-lingshan.zhu@intel.com>
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

Fixes: a64917bc2e9b (vdpa: Provide interface to read driver features)
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

