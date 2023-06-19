Return-Path: <netdev+bounces-11845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D31C3734D32
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 193851C20938
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB0F6ABD;
	Mon, 19 Jun 2023 08:09:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C39539C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:09:52 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383F11BDD
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687162166; x=1718698166;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yrhsCL2Psn2KRhnUKTJOC4dVgxcppWvghrzBZeDv5QA=;
  b=FDs5EMvyC97V6zywLg2gyMx5IHtzTYuJNYm2rKB/jdjNqvDNxkXtEnYp
   j2ZAyFd3+1efoELo59P4ITEz+kcP19hQc/qZKcZmwpYePqPX+yhAnommG
   /dhp/y/lW6TTc9ShTKWGAlKTskZFdbeP62tLsw20uzAFwtgWWrDjWcto8
   wrjZ5+VDCYkQ7Iko2M7++pxJxvDQ/bVKtipxrdC7WkMUxOtpC4ivCNE6j
   gfNkYlxmvaoi5nB5FOGPmK5WBSNU8CUaPb/aIczechW4T8GFMpB+rohF2
   5ZdQTkvDLTcnKKQUJVXF13GO4eel1Fj7YCl4bkBI3luZaKYJOaubc8cv5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="388586650"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="388586650"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 01:09:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="743354362"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="743354362"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga008.jf.intel.com with ESMTP; 19 Jun 2023 01:09:11 -0700
Received: from pelor.igk.intel.com (pelor.igk.intel.com [10.123.220.13])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 251E934938;
	Mon, 19 Jun 2023 09:09:10 +0100 (IST)
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Piotr Gardocki <piotrx.gardocki@intel.com>
Subject: [PATCH iwl-next v5] iavf: fix err handling for MAC replace
Date: Mon, 19 Jun 2023 04:06:35 -0400
Message-Id: <20230619080635.49412-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Defer removal of current primary MAC until a replacement is successfully
added. Previous implementation would left filter list with no primary MAC.
This was found while reading the code.

The patch takes advantage of the fact that there can only be a single primary
MAC filter at any time ([1] by Piotr)

Piotr has also applied some review suggestions during our internal patch
submittal process.

[1] https://lore.kernel.org/netdev/20230614145302.902301-2-piotrx.gardocki@intel.com/

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
v5: v4 re-sent after dependencies ([1] above) has been applied to net-next
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 42 ++++++++++-----------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f262487109f6..44304f16cdfa 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1040,40 +1040,36 @@ static int iavf_replace_primary_mac(struct iavf_adapter *adapter,
 				    const u8 *new_mac)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	struct iavf_mac_filter *f;
+	struct iavf_mac_filter *new_f;
+	struct iavf_mac_filter *old_f;
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 
-	list_for_each_entry(f, &adapter->mac_filter_list, list) {
-		f->is_primary = false;
+	new_f = iavf_add_filter(adapter, new_mac);
+	if (!new_f) {
+		spin_unlock_bh(&adapter->mac_vlan_list_lock);
+		return -ENOMEM;
 	}
 
-	f = iavf_find_filter(adapter, hw->mac.addr);
-	if (f) {
-		f->remove = true;
+	old_f = iavf_find_filter(adapter, hw->mac.addr);
+	if (old_f) {
+		old_f->is_primary = false;
+		old_f->remove = true;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
 	}
-
-	f = iavf_add_filter(adapter, new_mac);
-
-	if (f) {
-		/* Always send the request to add if changing primary MAC
-		 * even if filter is already present on the list
-		 */
-		f->is_primary = true;
-		f->add = true;
-		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
-		ether_addr_copy(hw->mac.addr, new_mac);
-	}
+	/* Always send the request to add if changing primary MAC,
+	 * even if filter is already present on the list
+	 */
+	new_f->is_primary = true;
+	new_f->add = true;
+	adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
+	ether_addr_copy(hw->mac.addr, new_mac);
 
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 
 	/* schedule the watchdog task to immediately process the request */
-	if (f) {
-		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
-		return 0;
-	}
-	return -ENOMEM;
+	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
+	return 0;
 }
 
 /**
-- 
2.40.1


