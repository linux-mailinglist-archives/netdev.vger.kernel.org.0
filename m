Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F6695022
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 20:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjBMTAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 14:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjBMS7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:59:47 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D2F10249
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676314771; x=1707850771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sgIQ5jcS4MOhykWwmC4BXHY9Ya0NOW+iqh23bRAeEgk=;
  b=UXmsj6JxL6usamvd+4xo60G9SlQd97Ak2NwM62ZAmkPj6qK++HoM+74Q
   YrpAmO5LAong8rT5edwP2V+RmovyFxHzJrhZrYbQ0NRAM53dtzQa8vp9l
   v213S0ixrb+IxXDtwBwfxdFH5RL47yzi1cBbwyXWzc5bNmqkkIgp7d2GZ
   nMgZSOri6oLxPaduimMFgzN7ghJr46Z50ruE1DsEM+X3IVVzIXGCbogR5
   anKTOZnd5K/lvJVgNkgf1WQrTrCqCaUi9+/O1lCHtcrlkKpqdS8hjx18H
   fiWL1pIw3jMOWWwXp7nYvKf4U8iNn/B2lm9yioH6kqd9yNaiNtC9L1Kvb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="328677770"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="328677770"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 10:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="737619906"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="737619906"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 13 Feb 2023 10:53:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/2] ice: Fix check for weight and priority of a scheduling node
Date:   Mon, 13 Feb 2023 10:52:58 -0800
Message-Id: <20230213185259.3959224-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230213185259.3959224-1-anthony.l.nguyen@intel.com>
References: <20230213185259.3959224-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Wilczynski <michal.wilczynski@intel.com>

Currently checks for weight and priority ranges don't check incoming value
from the devlink. Instead it checks node current weight or priority. This
makes those checks useless.

Change range checks in ice_set_object_tx_priority() and
ice_set_object_tx_weight() to check against incoming priority an weight.

Fixes: 42c2eb6b1f43 ("ice: Implement devlink-rate API")
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 8286e47b4bae..0fae0186bd85 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -899,7 +899,7 @@ static int ice_set_object_tx_priority(struct ice_port_info *pi, struct ice_sched
 {
 	int status;
 
-	if (node->tx_priority >= 8) {
+	if (priority >= 8) {
 		NL_SET_ERR_MSG_MOD(extack, "Priority should be less than 8");
 		return -EINVAL;
 	}
@@ -929,7 +929,7 @@ static int ice_set_object_tx_weight(struct ice_port_info *pi, struct ice_sched_n
 {
 	int status;
 
-	if (node->tx_weight > 200 || node->tx_weight < 1) {
+	if (weight > 200 || weight < 1) {
 		NL_SET_ERR_MSG_MOD(extack, "Weight must be between 1 and 200");
 		return -EINVAL;
 	}
-- 
2.38.1

