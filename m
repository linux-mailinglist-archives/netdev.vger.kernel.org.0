Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1844E53B1CE
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiFBCse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 22:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiFBCs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 22:48:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E191EE6EA
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 19:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654138108; x=1685674108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kLUq46zVK743yTschuwvLfc05xi0p506NfSw+A8rRIQ=;
  b=Vh4PtrGGM2kFeJTKxYjysoPsg85mrgeAZq2Yi6+GgRzDORRji3wO8iCe
   ZUGxGkFK9grcUmJkhQTbMgftSpq2z48EMbfMGvL/MVevxgaGSYKNQahII
   lAbptY/jXcowCYLr3vawZBDLiK7kFkKxu/qUjMLEv/QA4rz2ivRlLpvEx
   i4dw816S+1DF7ccnr57iK9uOn6RmUDGGnD6acZS4+J1AtK+6DynmjHJ2g
   9BmPM/zmsS/cRRWki7o10aX8QQ4+mK154VA7OTFNSUZCuLZmsoMqHSM5B
   GEAxSjLRMCiAtov4okXG+NNH2ntef1fQADkcXdblttfZqAv2P2VuUpstJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="275874636"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="275874636"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="612608908"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:26 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 6/6] vDPA: fix 'cast to restricted le16' warnings in vdpa_dev_net_config_fill()
Date:   Thu,  2 Jun 2022 10:38:45 +0800
Message-Id: <20220602023845.2596397-7-lingshan.zhu@intel.com>
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

This commit fixes spars warnings: cast to restricted __le16
in function vdpa_dev_net_config_fill()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 50a11ece603e..2719ce9962fc 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -837,11 +837,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 		    config.mac))
 		return -EMSGSIZE;
 
-	val_u16 = le16_to_cpu(config.status);
+	val_u16 = le16_to_cpu((__force __le16)config.status);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
 		return -EMSGSIZE;
 
-	val_u16 = le16_to_cpu(config.mtu);
+	val_u16 = le16_to_cpu((__force __le16)config.mtu);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
-- 
2.31.1

