Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDE950D043
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 09:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbiDXHjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 03:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiDXHjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 03:39:05 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58C28A32E
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 00:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650785765; x=1682321765;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=T0PTcZBz5O4AVfemKolZYaFTJ9SOLr3obmjoKx4NMAA=;
  b=imiUsV5M7OzBRTpaOMZKkSjr5VogMvD5hKoRfoYg6Mj5L9AFZTtncR9M
   N7BOGzAp1KQUUuFniYErc+BDnrfEG+hOJDBYr8xxN1PYOmQCniaXZr45H
   PZZrXE51vufMh3L0g40sHSZqQLQNtbZ3MBI1Pr6UNnItg1m7tB7Ws6Lnu
   ahMhJdbpjcTlEhkpKXqapwiTLXkpJNeqoOQKBPH7PS7LGqDryb9sqs7+8
   vj98ivVh5hOe8yp67lcZqlMi7zed4kOC7I9VqMSPL2p2WZpNOxZwosb3L
   FSSAEToVrh7OwVSv2icJqc1SUqLCcUfxrCNtSFnvYI95gajfBy8dXXN3D
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="327937347"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="327937347"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 00:36:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="557168502"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 00:36:03 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] vDPA/ifcvf: fix uninitialized config_vector warning
Date:   Sun, 24 Apr 2022 15:28:06 +0800
Message-Id: <20220424072806.1083189-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static checkers are not informed that config_vector is controlled
by vf->msix_vector_status, which can only be
MSIX_VECTOR_SHARED_VQ_AND_CONFIG, MSIX_VECTOR_SHARED_VQ_AND_CONFIG
and MSIX_VECTOR_DEV_SHARED.

This commit uses an "if...elseif...else" code block to tell the
checkers that it is a complete set, and config_vector can be
initialized anyway

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 4366320fb68d..9172905fc7ae 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -290,16 +290,16 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
 	struct ifcvf_hw *vf = &adapter->vf;
 	int config_vector, ret;
 
-	if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
-		return 0;
-
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		/* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt */
 		config_vector = vf->nr_vring;
-
-	if (vf->msix_vector_status ==  MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
+	else if (vf->msix_vector_status ==  MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
 		/* vector 0 for vqs and 1 for config interrupt */
 		config_vector = 1;
+	else if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
+		/* re-use the vqs vector */
+		return 0;
+	else
+		return -EINVAL;
 
 	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
 		 pci_name(pdev));
-- 
2.31.1

