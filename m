Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE4B424397
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239484AbhJFRBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:01:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:34614 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230077AbhJFRBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:01:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="206167855"
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="206167855"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2021 09:59:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="439189034"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Oct 2021 09:58:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net 3/3] iavf: fix double unlock of crit_lock
Date:   Wed,  6 Oct 2021 09:56:59 -0700
Message-Id: <20211006165659.2298400-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
References: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

The crit_lock mutex could be unlocked twice as reported here
https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210823/025525.html

Remove the superfluous unlock. Technically the problem was already
present before 5ac49f3c2702 as that commit only replaced the locking
primitive, but no functional change.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 5ac49f3c2702 ("iavf: use mutexes for locking of critical sections")
Fixes: bac8486116b0 ("iavf: Refactor the watchdog state machine")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 23762a7ef740..cada4e0e40b4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1965,7 +1965,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
-- 
2.31.1

