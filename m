Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2688484AD9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbiADWjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:39:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:28280 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235687AbiADWjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 17:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641335963; x=1672871963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WBvELqUnpuM4kCN1CCV0/Lyq4Qkno910uPUNHJVeZCg=;
  b=QyoIcAGQ7EfDNrb+u+LL8jiT1CFbBw8XMfVZRuAkL6okC9FYZENRRV+J
   DTBGB2NdA/2SiX2QgowrDw86025c/dEb0JjPXgPdAWdItQrvR6pHkZygw
   9234H9eCfJKzd5Mm4p41XpiY2HkoBuIFDorb2LOz4U8Z2nUFQLR0meFY7
   aKcmzyEFQXyKl0Zu9natJPPKRKVgqzy2qGC1dJz/s2ohRjgqIgnpz8Pc5
   1xd79M76W/ZlZsuqzx648Acc4bLQphQvyH7wj7F/6UOE0T4ImKM7YWE2d
   /MJ73CKMlc9sCLEkhWdGqRfrE7qCVfMo/e27+y6SEzWOI1I/wYA36vF2n
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222305239"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="222305239"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 14:39:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="470312808"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2022 14:39:21 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Ashwin Vijayavel <ashwin.vijayavel@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 5/5] iavf: Fix limit of total number of queues to active queues of VF
Date:   Tue,  4 Jan 2022 14:38:42 -0800
Message-Id: <20220104223842.2325297-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
References: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

In the absence of this validation, if the user requests to
configure queues more than the enabled queues, it results in
sending the requested number of queues to the kernel stack
(due to the asynchronous nature of VF response), in which
case the stack might pick a queue to transmit that is not
enabled and result in Tx hang. Fix this bug by
limiting the total number of queues allocated for VF to
active queues of VF.

Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
Signed-off-by: Ashwin Vijayavel <ashwin.vijayavel@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 4e7c04047f91..e4439b095533 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2708,8 +2708,11 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 		total_max_rate += tx_rate;
 		num_qps += mqprio_qopt->qopt.count[i];
 	}
-	if (num_qps > IAVF_MAX_REQ_QUEUES)
+	if (num_qps > adapter->num_active_queues) {
+		dev_err(&adapter->pdev->dev,
+			"Cannot support requested number of queues\n");
 		return -EINVAL;
+	}
 
 	ret = iavf_validate_tx_bandwidth(adapter, total_max_rate);
 	return ret;
-- 
2.31.1

