Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386A44F9575
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiDHMTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiDHMTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:19:38 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487FC2FF6D0
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 05:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649420255; x=1680956255;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fB6/tFZ5llEwzGQqahG1w9Bb48jM3BBwOYCDKBnyj0o=;
  b=W7Lq+7eykFvNpXhBJZ5rMuRz6rP1RdmnT43L8JXdMVgC8G3gwFRs7I3H
   mz41JKHOSJfEJ02S/qJiDFFfaBl7nj3Y3KPH8Yvmi/umvpXTnldhDdqPR
   hCpeHHovcCgl2vGpMdcCbDdKxlZCWUJwlYIf5dkc10tU5eUFF4FKJah2F
   G3iwOiIC7XrvH2L0SYva9UnABZ7PIkk5xJWnfx0wK51mKP/edHC8pQ3y8
   Zt4kKzAlM1N77HBoFNICiFSJzeEvbU8TTMzmbZqJvf1a3PYhlXgfkNwJU
   WCjzuqFazzQTwJhcp7JRnG3cFLjbgrydwqEH20YIAJbDFWQzHbq3SodWh
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="249109653"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="249109653"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 05:17:34 -0700
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="550483731"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 05:17:32 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] vDPA/ifcvf: assign nr_vring to the MSI vector of config_intr by default
Date:   Fri,  8 Apr 2022 20:10:13 +0800
Message-Id: <20220408121013.54709-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit assign struct ifcvf_hw.nr_vring to the MSIX vector of the
config interrupt by default in ifcvf_request_config_irq().
ifcvf_hw.nr_vring is the most likely and the ideal case for
the device config interrupt handling, means every virtqueue has
an individual MSIX vector(0 ~ nr_vring - 1), and the config interrupt has
its own MSIX vector(number nr_vring).

This change can also make GCC W = 2 happy, silence the
"uninitialized" warning.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 4366320fb68d..b500fb941dab 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -290,13 +290,13 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
 	struct ifcvf_hw *vf = &adapter->vf;
 	int config_vector, ret;
 
+	/* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt */
+	config_vector = vf->nr_vring;
+
+	/* re-use the vqs vector */
 	if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
 		return 0;
 
-	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		/* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt */
-		config_vector = vf->nr_vring;
-
 	if (vf->msix_vector_status ==  MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
 		/* vector 0 for vqs and 1 for config interrupt */
 		config_vector = 1;
-- 
2.31.1

