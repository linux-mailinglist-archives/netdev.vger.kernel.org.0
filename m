Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F405EB83C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiI0DCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiI0DAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:00:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB1E64D8;
        Mon, 26 Sep 2022 19:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664247536; x=1695783536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q9QLny4+YlxEhFriZ4xrznw5yE/fEeF6yuJd395Sp48=;
  b=mcYiLAgyjgAkpoFaSLdv8mGvkv+1wa1Fk4tdQxvx/kLu2e+PNTGa859C
   RxxeZm5Jui0O7vR/T3NtbRUOpbMHGMVJsNpYMxva5erh3ePAkcIx/6Amz
   2JpRQ3ygliFnFuicVwr7Sx6ot9yGIe/n2f/hL5qyCurJpQ8IeT1kSW/9H
   h6YkLNjutR/lMeF0OtgQI+/WIYoyd1tl2qK+NODAs1aEqjdemK8NENgpH
   EzH5byMSwcvXOf9KDwRHQoz6o2bTDCa8ZKMOvpMx/iy3M6mU8es3kLOQn
   MkFE4hq1YD2GqNLN4cqv6eS7yf9wK/xr4DuaV8Yz0I3QYVJr9LAOQ9+jP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="387490760"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="387490760"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652105664"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652105664"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:54 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 4/6] vDPA: check virtio device features to detect MQ
Date:   Tue, 27 Sep 2022 10:50:33 +0800
Message-Id: <20220927025035.4972-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927025035.4972-1-lingshan.zhu@intel.com>
References: <20220927025035.4972-1-lingshan.zhu@intel.com>
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

