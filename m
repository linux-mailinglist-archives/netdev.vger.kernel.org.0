Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA42964630A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLGVKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLGVJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:09:48 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F6573F60
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447386; x=1701983386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ZVjjuCBjAxbflZss7VNeC4J1mTxT2tFtzfscp3cMFA=;
  b=OvwQ+7Xt4dgzjjUk+XMTKTIW91bCnP1s8v+WTZ0fXpx0uDYPV1WVyxqp
   uzY5NTu6zTQng8kQc39l5uRk23AM28k9YfJjLh1DMxz3CQbSxqkDUI0Sb
   wjfy30uGCBdNCWElPBQlSxHO9bk8j/QDlt1d6qEi170/fVh449RCLx5uz
   ly7ZWaFEPYqSet3zFQr7UehP4SPaWj2LdkiUuixF3s7P4We306ATTRBQe
   BvRTyT+ds4v2zuja9UlaiteBf35RlbLQDzfA7rRbtCP40QELXctZGYhjg
   j+oE7cDjW2ugZ16U1cbm/FJPmK+L/EndlH/DGeXpiju9mwGU8Kr44Mbju
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296697083"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="296697083"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:09:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677508846"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677508846"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2022 13:09:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 10/15] ice: disable Tx timestamps while link is down
Date:   Wed,  7 Dec 2022 13:09:32 -0800
Message-Id: <20221207210937.1099650-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Introduce a new link_down field for the Tx tracker which indicates whether
the link is down for a given port.

Use this bit to prevent any Tx timestamp requests from starting while link
is down. This ensures that we do not try to start new timestamp requests
until after link has been restored.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 11 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 481492d84e0e..dffcd50bac3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -613,7 +613,7 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
 {
 	lockdep_assert_held(&tx->lock);
 
-	return tx->init && !tx->calibrating;
+	return tx->init && !tx->calibrating && !tx->link_down;
 }
 
 /**
@@ -806,6 +806,8 @@ ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
 	}
 
 	tx->init = 1;
+	tx->link_down = 0;
+	tx->calibrating = 0;
 
 	spin_lock_init(&tx->lock);
 
@@ -1396,6 +1398,13 @@ void ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
 	/* Update cached link status for this port immediately */
 	ptp_port->link_up = linkup;
 
+	/* Set the link status of the Tx tracker. While link is down, all Tx
+	 * timestamp requests will be ignored.
+	 */
+	spin_lock(&ptp_port->tx.lock);
+	ptp_port->tx.link_down = !linkup;
+	spin_unlock(&ptp_port->tx.lock);
+
 	/* E810 devices do not need to reconfigure the PHY */
 	if (ice_is_e810(&pf->hw))
 		return;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 0bfafaaab6c7..75dcab8e1124 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -119,6 +119,7 @@ struct ice_tx_tstamp {
  * @init: if true, the tracker is initialized;
  * @calibrating: if true, the PHY is calibrating the Tx offset. During this
  *               window, timestamps are temporarily disabled.
+ * @link_down: if true, the link is down and timestamp requests are disabled
  * @verify_cached: if true, verify new timestamp differs from last read value
  */
 struct ice_ptp_tx {
@@ -130,6 +131,7 @@ struct ice_ptp_tx {
 	u8 len;
 	u8 init : 1;
 	u8 calibrating : 1;
+	u8 link_down : 1;
 	u8 verify_cached : 1;
 };
 
-- 
2.35.1

