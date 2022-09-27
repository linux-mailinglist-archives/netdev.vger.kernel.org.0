Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9865EB864
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiI0DMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiI0DL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:11:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D5D13D51;
        Mon, 26 Sep 2022 20:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664248188; x=1695784188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MHeKxmQI7dzVqsMFENR/yfS8078fH4WgIzsF3Ed1w8E=;
  b=NY7l4oIui/MkEmG80W/t9eHWL2QYzfXSWlr68fgnwcnCn9fqYu5999ip
   kqef+t7KE6vJNwhmbeR3y0G5ZfI3V25jnviuRquY+Bc/pHMTMvjF9988Y
   zZmQSR8OLqEyrAFlDZ/5c7Vy1DGTUIskXPOAt/WhdgqIlxwQkPCk8txLb
   WhUUzDL6GKRbWGuT0fbta0BxypQl23TnNCDB7FH8AZrZcsUB62u25oZHS
   R3lwduZ4QJVhYQx0Yb9NOmMEOoztejdfnFcN2/JQxeYDkqffYoj401qt1
   EiIgP04C3o0EBgI7gHwzFPPmWOwpJ/FhHYdGknjiomBrrUobR8ksbK9ln
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="299922322"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="299922322"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="710387782"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="710387782"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:37 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 RESEND 5/6] vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
Date:   Tue, 27 Sep 2022 11:01:16 +0800
Message-Id: <20220927030117.5635-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927030117.5635-1-lingshan.zhu@intel.com>
References: <20220927030117.5635-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes spars warnings: cast to restricted __le16
in function vdpa_dev_net_mq_config_fill()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 84a0c3877d7c..fa7f65279f79 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -809,7 +809,8 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
 	    (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
 		return 0;
 
-	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
+	val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
+
 	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
 }
 
-- 
2.31.1

