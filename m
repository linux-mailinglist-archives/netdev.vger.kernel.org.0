Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A9857E617
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiGVR40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236273AbiGVR4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:56:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52795C9E5
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658512578; x=1690048578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8l72DZTzju6Uja/12qWllxBi06AhzmKDCLIxQoWVB7M=;
  b=MKoQ/GyjSJZUTnOtFT880GRSIBQbdc6Fei61a1FLRSxbtdYFfwFO7Joh
   560gHGlble+U5c81RYn82HVKw3mKUX4fJ6H4pRgV+Kuw1i0/L0LOmgpsS
   8B+6FAHZbDr0dXgeHV9eqfk8zSVT5i61tgJ5vhKmWUJZgPnvFrrv9tml6
   VVaDnHPE8UDCxQBENmUM2C0GoQvqd3cicjGUVzh9mnk5IUWt8SMbCV18v
   u3HevYJLcYRLwff7on284Om4fWGe0ZmvBYYsei6Oxoe9k3Hkn4HTQJlt/
   93RkcN63q7sWIt/ZjITqVS9KwGnghp4jOadmOTE4SNmfyr72/VMJRkYUs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="267769831"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="267769831"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 10:56:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="596042573"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2022 10:56:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Avinash Dayanand <avinash.dayanand@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jun Zhang <xuejun.zhang@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net-next 2/2] iavf: Check for duplicate TC flower filter before parsing
Date:   Fri, 22 Jul 2022 10:53:13 -0700
Message-Id: <20220722175313.112518-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220722175313.112518-1-anthony.l.nguyen@intel.com>
References: <20220722175313.112518-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avinash Dayanand <avinash.dayanand@intel.com>

Record of all the TC flower filters are kept for local book keeping, so
take advantage of that and check for duplicate filter even before sending
a request to the PF driver.

Signed-off-by: Avinash Dayanand <avinash.dayanand@intel.com>
Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 55 ++++++++++++---------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 7dddf9800e2f..e78c38d02432 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3831,6 +3831,29 @@ static int iavf_handle_tclass(struct iavf_adapter *adapter, u32 tc,
 	return 0;
 }
 
+/**
+ * iavf_find_cf - Find the cloud filter in the list
+ * @adapter: Board private structure
+ * @cookie: filter specific cookie
+ *
+ * Returns ptr to the filter object or NULL. Must be called while holding the
+ * cloud_filter_list_lock.
+ */
+static struct iavf_cloud_filter *iavf_find_cf(struct iavf_adapter *adapter,
+					      unsigned long *cookie)
+{
+	struct iavf_cloud_filter *filter = NULL;
+
+	if (!cookie)
+		return NULL;
+
+	list_for_each_entry(filter, &adapter->cloud_filter_list, list) {
+		if (!memcmp(cookie, &filter->cookie, sizeof(filter->cookie)))
+			return filter;
+	}
+	return NULL;
+}
+
 /**
  * iavf_configure_clsflower - Add tc flower filters
  * @adapter: board private structure
@@ -3862,6 +3885,15 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 
 	filter->cookie = cls_flower->cookie;
 
+	/* bail out here if filter already exists */
+	spin_lock_bh(&adapter->cloud_filter_list_lock);
+	if (iavf_find_cf(adapter, &cls_flower->cookie)) {
+		dev_err(&adapter->pdev->dev, "Failed to add TC Flower filter, it already exists\n");
+		err = -EEXIST;
+		goto spin_unlock;
+	}
+	spin_unlock_bh(&adapter->cloud_filter_list_lock);
+
 	/* set the mask to all zeroes to begin with */
 	memset(&filter->f.mask.tcp_spec, 0, sizeof(struct virtchnl_l4_spec));
 	/* start out with flow type and eth type IPv4 to begin with */
@@ -3880,6 +3912,7 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 	adapter->num_cloud_filters++;
 	filter->add = true;
 	adapter->aq_required |= IAVF_FLAG_AQ_ADD_CLOUD_FILTER;
+spin_unlock:
 	spin_unlock_bh(&adapter->cloud_filter_list_lock);
 err:
 	if (err)
@@ -3889,28 +3922,6 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 	return err;
 }
 
-/* iavf_find_cf - Find the cloud filter in the list
- * @adapter: Board private structure
- * @cookie: filter specific cookie
- *
- * Returns ptr to the filter object or NULL. Must be called while holding the
- * cloud_filter_list_lock.
- */
-static struct iavf_cloud_filter *iavf_find_cf(struct iavf_adapter *adapter,
-					      unsigned long *cookie)
-{
-	struct iavf_cloud_filter *filter = NULL;
-
-	if (!cookie)
-		return NULL;
-
-	list_for_each_entry(filter, &adapter->cloud_filter_list, list) {
-		if (!memcmp(cookie, &filter->cookie, sizeof(filter->cookie)))
-			return filter;
-	}
-	return NULL;
-}
-
 /**
  * iavf_delete_clsflower - Remove tc flower filters
  * @adapter: board private structure
-- 
2.35.1

