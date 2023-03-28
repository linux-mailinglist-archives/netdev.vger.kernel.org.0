Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA6C6CC92F
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 19:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjC1RXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 13:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjC1RW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 13:22:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B92DBBA1
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 10:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680024178; x=1711560178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4FEmkdG7+Mh8utMnnrwucItdH3lGfseQQ5MDaCVr/1E=;
  b=EoZdFnkI8xdftueh/sndvIUW7qGCSzshKEi/0xe9NQhIrDFAQWbCV+l8
   G6Nl+YWsuKVFAIDfTIDojcVl/fQCG9rKa0f0AKLoRU5Q+DW4U4vFEMV2L
   9iQgeyEn0YOB5KBIrMdpkdao4g5L28ABPK6Uc+UTLNQT9Rnz3J24COaKP
   Y0y8GyZOeU2WNd/ZdA3Q1EUPWq9XencWqvq0W0joiJiHcgDfWm2o8rk5K
   3LNG0WhsUMJCQHMuh24Lvk0mE+GYT+RBaxzxVkB5KOa7Zx3lkW5/dmlmY
   xX9/U99lbWUKQK3NewUbYTItYp7XxxhLGqIb2mew3aRUfLOZEQ2Y5T83g
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="340658933"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="340658933"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 10:22:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="807906260"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="807906260"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 28 Mar 2023 10:22:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jakob Koschel <jkl820.git@gmail.com>, anthony.l.nguyen@intel.com,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net 4/4] ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()
Date:   Tue, 28 Mar 2023 10:20:35 -0700
Message-Id: <20230328172035.3904953-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
References: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakob Koschel <jkl820.git@gmail.com>

The code implicitly assumes that the list iterator finds a correct
handle. If 'vsi_handle' is not found the 'old_agg_vsi_info' was
pointing to an bogus memory location. For safety a separate list
iterator variable should be used to make the != NULL check on
'old_agg_vsi_info' correct under any circumstances.

Additionally Linus proposed to avoid any use of the list iterator
variable after the loop, in the attempt to move the list iterator
variable declaration into the macro to avoid any potential misuse after
the loop. Using it in a pointer comparison after the loop is undefined
behavior and should be omitted if possible [1].

Fixes: 37c592062b16 ("ice: remove the VSI info from previous agg")
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 4eca8d195ef0..b7682de0ae05 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2788,7 +2788,7 @@ static int
 ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 			   u16 vsi_handle, unsigned long *tc_bitmap)
 {
-	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info = NULL;
+	struct ice_sched_agg_vsi_info *agg_vsi_info, *iter, *old_agg_vsi_info = NULL;
 	struct ice_sched_agg_info *agg_info, *old_agg_info;
 	struct ice_hw *hw = pi->hw;
 	int status = 0;
@@ -2806,11 +2806,13 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 	if (old_agg_info && old_agg_info != agg_info) {
 		struct ice_sched_agg_vsi_info *vtmp;
 
-		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
+		list_for_each_entry_safe(iter, vtmp,
 					 &old_agg_info->agg_vsi_list,
 					 list_entry)
-			if (old_agg_vsi_info->vsi_handle == vsi_handle)
+			if (iter->vsi_handle == vsi_handle) {
+				old_agg_vsi_info = iter;
 				break;
+			}
 	}
 
 	/* check if entry already exist */
-- 
2.38.1

