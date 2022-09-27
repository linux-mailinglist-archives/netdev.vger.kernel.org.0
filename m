Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC025EB861
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiI0DMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiI0DLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:11:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6099A17A91;
        Mon, 26 Sep 2022 20:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664248180; x=1695784180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q9QLny4+YlxEhFriZ4xrznw5yE/fEeF6yuJd395Sp48=;
  b=Q+086vxP9nG3AtkVt3aqOp/pQwSe6wCjOdWVnAvZTfjJ9yx3Zr132NAI
   Ll8RbO/Eb+TWH1N8aCVnTcMImZmkec5/OT1PYXl+XcIe2EC/5rjyS9xaV
   kw3ztm1+ecAAC4I8ycGkrEJ6b2ciDCuRzigmLOQjEe0EJEXmmDyOyDhqh
   LlfCYWNvDS66tWqDOX8IZ1odVNDU04pExfXo9Kp6z5zkjXrvuuoBL8T9h
   lb9XUYpNTA9B+0x2SUsmgVOzWAl1xNhLc3rXWxmauACtkf9/0YGbUvV4I
   bRxbsz6lRf2muwRsI4mQNDBrKjo39Nv2D+hGUj1+MbvJ5VPPAKQO55Vmr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="299922317"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="299922317"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:37 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="710387774"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="710387774"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:35 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 RESEND 4/6] vDPA: check virtio device features to detect MQ
Date:   Tue, 27 Sep 2022 11:01:15 +0800
Message-Id: <20220927030117.5635-5-lingshan.zhu@intel.com>
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

vdpa_dev_net_mq_config_fill() should checks device features
for MQ than driver features.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 829fd4cfc038..84a0c3877d7c 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -839,7 +839,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
-	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
+	return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
 }
 
 static int
-- 
2.31.1

