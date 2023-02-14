Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC25696FBD
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbjBNVcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjBNVcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:32:12 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF67F3595
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676410306; x=1707946306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZlYV0m39+dLbCzXoNDdGhc+7a3+xBFX3C2vtwhPpIXc=;
  b=JX+OWa9rawyNoppTAG/ZcumfUJ3yL8ICYDDBy59xtHRn1+690CoWBYbg
   FlsY/CgqhNPeyxXdak9smArUbC42EMu7egfeoxifTXMYDULqdQhLe+ciZ
   l79UFyn4xt3J0ORnsSDqEvSbxBVJzAAhbUjijn4whiKJ3rFUFt41K/ulk
   tjW4oik+Lao4oNq9JgmTz2FdBzewg2S/qZVu1cYkCHJ11v4Bzc6m9nWzd
   Z6oij7t6W7DCdiRhyVxw77v6ExxioRyKe4z49RZGeiMX1ZKsQdDfwd19x
   IE3xuzJPCaiu1rHl8bBk2JE9nd+iLo4Xz1TgfRsaTXPBZWBT0GrTZdz8M
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331274573"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="331274573"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:30:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733025264"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="733025264"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 13:30:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Daniel Vacek <neelx@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/5] ice/ptp: fix the PTP worker retrying indefinitely if the link went down
Date:   Tue, 14 Feb 2023 13:30:00 -0800
Message-Id: <20230214213003.2117125-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
References: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
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

From: Daniel Vacek <neelx@redhat.com>

When the link goes down the ice_ptp_tx_tstamp() may loop re-trying to
process the packets till the 2 seconds timeout finally drops them.
In such a case it makes sense to just drop them right away.

Signed-off-by: Daniel Vacek <neelx@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 651dc385ff5d..ac6f06f9a2ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -680,6 +680,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	u64 tstamp_ready;
+	bool link_up;
 	int err;
 	u8 idx;
 
@@ -695,11 +696,14 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	if (err)
 		return false;
 
+	/* Drop packets if the link went down */
+	link_up = ptp_port->link_up;
+
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct skb_shared_hwtstamps shhwtstamps = {};
 		u8 phy_idx = idx + tx->offset;
 		u64 raw_tstamp = 0, tstamp;
-		bool drop_ts = false;
+		bool drop_ts = !link_up;
 		struct sk_buff *skb;
 
 		/* Drop packets which have waited for more than 2 seconds */
@@ -728,7 +732,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
 
 		err = ice_read_phy_tstamp(hw, tx->block, phy_idx, &raw_tstamp);
-		if (err)
+		if (err && !drop_ts)
 			continue;
 
 		ice_trace(tx_tstamp_fw_done, tx->tstamps[idx].skb, idx);
-- 
2.38.1

