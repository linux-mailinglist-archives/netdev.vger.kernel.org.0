Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B4921161D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgGAWee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:25463 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbgGAWe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:27 -0400
IronPort-SDR: fy8oPuOg3uvR0nq5J9hnSvsdV0rT4DG0HVPcTkHy0SBuLIUDh6C91Lk0iW7AUe3Eshh0WI+fQx
 B3Q7NP0wNxYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178604"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178604"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: RdTYO7qQbs0PnVseDhBqWbFAOJKjCPM/rrP7jL3StwggR24v3yQMhIPypBcUwcLwmCfULYILjx
 4F+7jirG+lWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276126"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        stable@vger.kernel.org, Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 10/12] iavf: Fix updating statistics
Date:   Wed,  1 Jul 2020 15:34:10 -0700
Message-Id: <20200701223412.2675606-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bac8486116b0 ("iavf: Refactor the watchdog state machine") inverted
the logic for when to update statistics. Statistics should be updated when
no other commands are pending, instead they were only requested when a
command was processed. iavf_request_stats() would see a pending request
and not request statistics to be updated. This caused statistics to never
be updated; fix the logic.

CC: stable@vger.kernel.org
Fixes: bac8486116b0 ("iavf: Refactor the watchdog state machine")
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index b90ad1abbabb..48c956d90b90 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1937,7 +1937,10 @@ static void iavf_watchdog_task(struct work_struct *work)
 				iavf_send_api_ver(adapter);
 			}
 		} else {
-			if (!iavf_process_aq_command(adapter) &&
+			/* An error will be returned if no commands were
+			 * processed; use this opportunity to update stats
+			 */
+			if (iavf_process_aq_command(adapter) &&
 			    adapter->state == __IAVF_RUNNING)
 				iavf_request_stats(adapter);
 		}
-- 
2.26.2

