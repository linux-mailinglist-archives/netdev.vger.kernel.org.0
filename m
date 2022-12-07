Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077B6646306
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLGVKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiLGVJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:09:46 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF63B73F56
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447385; x=1701983385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IsRCH6gsNzldJbaTnLQxE1m2NUIX2nbNXW3Jg46BWzE=;
  b=PdTW/iNnmdz5A/I5nldOedZ38jauq9D7P2u7B5XRQ3LKh4p/oul9VEv7
   VZ6oOECoa46ltcJUu5VXsdBV2a1mcmGjRSd3v/4x6JDmwiU0GW6JpiBEC
   xL5S9pUP3XaT/3J4eYh8OPdpCBqLQpj68zGz3+AJR4J/bniba69IJvrDr
   vJx9UFo+wKcszzcYxtXkw+ODaFvkbn2ucOJKdXQqXIi/s2TZKRWaNAH/6
   TU5YWH6PtBt8tLopBxHig0zlkClkMRXGbY+ch32PVhMxonvARvCx3VEuG
   Ss+6gl/aBreWS0Zc6rfbwLGb8+WX5cGPPEeKAXF2WwzU5ZO7wQ22F3GDr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296697071"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="296697071"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:09:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677508835"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677508835"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2022 13:09:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 08/15] ice: synchronize the misc IRQ when tearing down Tx tracker
Date:   Wed,  7 Dec 2022 13:09:30 -0800
Message-Id: <20221207210937.1099650-9-anthony.l.nguyen@intel.com>
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

Since commit 1229b33973c7 ("ice: Add low latency Tx timestamp read") the
ice driver has used a threaded IRQ for handling Tx timestamps. This change
did not add a call to synchronize_irq during ice_ptp_release_tx_tracker.
Thus it is possible that an interrupt could occur just as the tracker is
being removed. This could lead to a use-after-free of the Tx tracker
structure data.

Fix this by calling sychronize_irq in ice_ptp_release_tx_tracker after
we've cleared the init flag. In addition, make sure that we re-check the
init flag at the end of ice_ptp_tx_tstamp before we exit ensuring that we
will stop polling for new timestamps once the tracker de-initialization has
begun.

Refactor the ts_handled variable into "more_timestamps" so that we can
simply directly assign this boolean instead of relying on an initialized
value of true. This makes the new combined check easier to read.

With this change, the ice_ptp_release_tx_tracker function will now wait for
the threaded interrupt to complete if it was executing while the init flag
was cleared.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 30061598912b..0282ccc55819 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -656,7 +656,7 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
 static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 {
 	struct ice_ptp_port *ptp_port;
-	bool ts_handled = true;
+	bool more_timestamps;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	u64 tstamp_ready;
@@ -761,11 +761,10 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	 * poll for remaining timestamps.
 	 */
 	spin_lock(&tx->lock);
-	if (!bitmap_empty(tx->in_use, tx->len))
-		ts_handled = false;
+	more_timestamps = tx->init && !bitmap_empty(tx->in_use, tx->len);
 	spin_unlock(&tx->lock);
 
-	return ts_handled;
+	return !more_timestamps;
 }
 
 /**
@@ -836,6 +835,9 @@ ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
 	tx->init = 0;
 
+	/* wait for potentially outstanding interrupt to complete */
+	synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
+
 	ice_ptp_flush_tx_tracker(pf, tx);
 
 	kfree(tx->tstamps);
-- 
2.35.1

