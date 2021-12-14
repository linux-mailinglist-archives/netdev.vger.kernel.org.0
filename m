Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B9474C4B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhLNTvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:51:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:56344 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhLNTvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 14:51:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639511478; x=1671047478;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wji8vLrQsEtpInUFGnbr/bBKHVbsTcA7JdGfUFTuWGo=;
  b=dS9oo86hmAH+kA+Lsn6rkY3HxTvNkz2dWleer84DBi3PxX7Ab7euMYo9
   PY1uV0UnGX9pfL++TVuGekpZDo2c+vSNKHkqNkpOsQU6meE91mjeODoVC
   kykZSkQQjTYlnWeVjsM/DmfPEwi5JEySnofTkCBPIKXlEASlKCk7pJicT
   s2qgEYCC9bpljCzSODzrDJI8gKcwOFEEPYLaYuGHXIh07FIeM/GIpQJpz
   z1t0axfX6d5tO/MluLIp1p9K0dL/SK24gGQODNBU7e8ZTazbIUi/8cko4
   cf2jn8AIkL0zgjRMg7r3vTaShnRaH+O+Cv8T+AuJksUH+Sc+F/cHmGnCi
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263216673"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263216673"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 11:51:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="753098715"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 14 Dec 2021 11:51:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] ice: Don't put stale timestamps in the skb
Date:   Tue, 14 Dec 2021 11:50:20 -0800
Message-Id: <20211214195020.1928635-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214195020.1928635-1-anthony.l.nguyen@intel.com>
References: <20211214195020.1928635-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

The driver has to check if it does not accidentally put the timestamp in
the SKB before previous timestamp gets overwritten.
Timestamp values in the PHY are read only and do not get cleared except
at hardware reset or when a new timestamp value is captured.
The cached_tstamp field is used to detect the case where a new timestamp
has not yet been captured, ensuring that we avoid sending stale
timestamp data to the stack.

Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 11 ++++-------
 drivers/net/ethernet/intel/ice/ice_ptp.h |  6 ++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ad7cabe7932f..442b031b0edc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1540,19 +1540,16 @@ static void ice_ptp_tx_tstamp_work(struct kthread_work *work)
 		if (err)
 			continue;
 
-		/* Check if the timestamp is valid */
-		if (!(raw_tstamp & ICE_PTP_TS_VALID))
+		/* Check if the timestamp is invalid or stale */
+		if (!(raw_tstamp & ICE_PTP_TS_VALID) ||
+		    raw_tstamp == tx->tstamps[idx].cached_tstamp)
 			continue;
 
-		/* clear the timestamp register, so that it won't show valid
-		 * again when re-used.
-		 */
-		ice_clear_phy_tstamp(hw, tx->quad, phy_idx);
-
 		/* The timestamp is valid, so we'll go ahead and clear this
 		 * index and then send the timestamp up to the stack.
 		 */
 		spin_lock(&tx->lock);
+		tx->tstamps[idx].cached_tstamp = raw_tstamp;
 		clear_bit(idx, tx->in_use);
 		skb = tx->tstamps[idx].skb;
 		tx->tstamps[idx].skb = NULL;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index f71ad317d6c8..53c15fc9d996 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -55,15 +55,21 @@ struct ice_perout_channel {
  * struct ice_tx_tstamp - Tracking for a single Tx timestamp
  * @skb: pointer to the SKB for this timestamp request
  * @start: jiffies when the timestamp was first requested
+ * @cached_tstamp: last read timestamp
  *
  * This structure tracks a single timestamp request. The SKB pointer is
  * provided when initiating a request. The start time is used to ensure that
  * we discard old requests that were not fulfilled within a 2 second time
  * window.
+ * Timestamp values in the PHY are read only and do not get cleared except at
+ * hardware reset or when a new timestamp value is captured. The cached_tstamp
+ * field is used to detect the case where a new timestamp has not yet been
+ * captured, ensuring that we avoid sending stale timestamp data to the stack.
  */
 struct ice_tx_tstamp {
 	struct sk_buff *skb;
 	unsigned long start;
+	u64 cached_tstamp;
 };
 
 /**
-- 
2.31.1

