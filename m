Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01574C4F15
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbiBYTqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiBYTqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:46:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF77210465
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818375; x=1677354375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YQ3gTZHWbPjhf4JN5/rC56aOsU3W/AG+3BqgUWKRilk=;
  b=kPRSZ44m6X0Kc0lXMTFJvQa05RQ5CCA97vabeRpUDHY+X9hRwYvhf3dn
   Tsbl0mShelVlVBQOOJvxfT9O22iqaXEPqH0s7JM17Pf4yXvkbHVqNMIws
   1kAnCw9S1sK+H8rudE5T+xuXAOhjGyvureqNjtOtmrxKcYDzR3hjh4ZFI
   8yWkEV3Wv/PY4vCX/InX7ZAmQoXyHPYXQkD9R56xDfpA+/wv3Zq1IQg7B
   6IIONtpEbss1sZGFyemsuaQsBi6edq4JZk9XrS8yVRzqRm9EJgZou+Ac0
   eLMVOBqvKMk5yjZToHVW7BvyG6i8+In1JFYliGh9ZqyNkr2jZlcjgLEwB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="339004866"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="339004866"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:46:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="707972185"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 25 Feb 2022 11:46:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 6/8] iavf: Fix deadlock in iavf_reset_task
Date:   Fri, 25 Feb 2022 11:46:12 -0800
Message-Id: <20220225194614.136571-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
References: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

There exists a missing mutex_unlock call on crit_lock in
iavf_reset_task call path.

Unlock the crit_lock before returning from reset task.

Fixes: 5ac49f3c2702 ("iavf: use mutexes for locking of critical sections")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 36433d6504b7..da50ea3e44c2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2688,6 +2688,7 @@ static void iavf_reset_task(struct work_struct *work)
 			reg_val);
 		iavf_disable_vf(adapter);
 		mutex_unlock(&adapter->client_lock);
+		mutex_unlock(&adapter->crit_lock);
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 
-- 
2.31.1

