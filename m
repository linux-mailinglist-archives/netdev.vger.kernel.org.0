Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7610F5EEB49
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiI2Byc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiI2By3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:54:29 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F81CB2DA2;
        Wed, 28 Sep 2022 18:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664416461; x=1695952461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D7pnvgGbf6rMBGEOr+3yoyC4/Q3xM67IRtf+uHK0JCk=;
  b=GBsVZ1C6qw6kkNsANTkf4qgdtNAp1MMmTHIZfOUrh34hyX53KrNBF6Qp
   4CUEhRUXyC8xBk8P+uktxIClLsqPTlwZ/9R3bWuS/9ISraK64q2/NZOWf
   jP7VUp268ZvFPt44E/8zjDUZCto7cxCtGLhv35JaOOQuuQeBWbJHifx55
   491f3bUfYSXkjvFwCmTd/NCzD7aE3H1WDmFVyNQpyyFTvIGNxCS8WU/4d
   BwRaOkTHINqS6EG6OCgcjeDzTQQklHeFh/ZFXgyNCHfjQMpRSsiX8Y8eD
   zhTpYbKIrxXDz1HjGVMQQRPuOToJXaA+eRFBZ3mEUlezU7enZPgx/f2MI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="365813997"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="365813997"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:19 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="950931697"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="950931697"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:19 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 4/6] vDPA: check virtio device features to detect MQ
Date:   Thu, 29 Sep 2022 09:45:53 +0800
Message-Id: <20220929014555.112323-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220929014555.112323-1-lingshan.zhu@intel.com>
References: <20220929014555.112323-1-lingshan.zhu@intel.com>
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
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 70448deb9cd9..4b13bb7f355d 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -838,7 +838,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
-	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
+	return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
 }
 
 static int
-- 
2.31.1

