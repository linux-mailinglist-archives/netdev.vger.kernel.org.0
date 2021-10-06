Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671544243A4
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239508AbhJFRC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:02:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:5212 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239500AbhJFRCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:02:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="224820448"
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="224820448"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2021 09:59:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="439189024"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Oct 2021 09:58:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 1/3] i40e: fix endless loop under rtnl
Date:   Wed,  6 Oct 2021 09:56:57 -0700
Message-Id: <20211006165659.2298400-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
References: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

The loop in i40e_get_capabilities can never end. The problem is that
although i40e_aq_discover_capabilities returns with an error if there's
a firmware problem, the returned error is not checked. There is a check for
pf->hw.aq.asq_last_status but that value is set to I40E_AQ_RC_OK on most
firmware problems.

When i40e_aq_discover_capabilities encounters a firmware problem, it will
encounter the same problem on its next invocation. As the result, the loop
becomes endless. We hit this with I40E_ERR_ADMIN_QUEUE_TIMEOUT but looking
at the code, it can happen with a range of other firmware errors.

I don't know what the correct behavior should be: whether the firmware
should be retried a few times, or whether pf->hw.aq.asq_last_status should
be always set to the encountered firmware error (but then it would be
pointless and can be just replaced by the i40e_aq_discover_capabilities
return value). However, the current behavior with an endless loop under the
rtnl mutex(!) is unacceptable and Intel has not submitted a fix, although we
explained the bug to them 7 months ago.

This may not be the best possible fix but it's better than hanging the whole
system on a firmware bug.

Fixes: 56a62fc86895 ("i40e: init code and hardware support")
Tested-by: Stefan Assmann <sassmann@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2f20980dd9a5..b5b984754ec9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10113,7 +10113,7 @@ static int i40e_get_capabilities(struct i40e_pf *pf,
 		if (pf->hw.aq.asq_last_status == I40E_AQ_RC_ENOMEM) {
 			/* retry with a larger buffer */
 			buf_len = data_size;
-		} else if (pf->hw.aq.asq_last_status != I40E_AQ_RC_OK) {
+		} else if (pf->hw.aq.asq_last_status != I40E_AQ_RC_OK || err) {
 			dev_info(&pf->pdev->dev,
 				 "capability discovery failed, err %s aq_err %s\n",
 				 i40e_stat_str(&pf->hw, err),
-- 
2.31.1

