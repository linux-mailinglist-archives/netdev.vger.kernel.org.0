Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7098646315
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiLGVLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLGVL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:11:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A0B73F56
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447459; x=1701983459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gMpRKKIz4DxbCw/m2cJNWsHYufB9UKsPZr7xw5b9gpg=;
  b=XJtQprNIwbn2Hjd0a9c/HHiyrkxPHEL1tQiL6OfgizuUQBTgUacwHUoH
   2MSbxeaGadqL9CbL5J3pQvl0C+J670W64L/Yxkf4ac6j/Dxyz7lxswnaG
   /lDGpilMC1cDC8P/Hx4owHamFhZHP+c27yxJA7H0bQ+jZQaN/uHhnL2AT
   tPl67/4N4nwngxPzek3iac/KNrB1LeTo99Oe+64REdttkMo9DB8h/0wZe
   NSyTClt4WwzBs86P6bq9sgIy+Lgv/Lk7Id7Qgc8L0yP1cBfKYSGawP+lB
   2I+Ie1THyUoo1DCu9/tZ/Sczxw6C4WKmOUp90l7wN98sBrpX7YZs1+1Ll
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="344047295"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="344047295"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:10:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679280192"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="679280192"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 13:10:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/4] ice: Create a separate kthread to handle ptp extts work
Date:   Wed,  7 Dec 2022 13:10:37 -0800
Message-Id: <20221207211040.1099708-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

ice_ptp_extts_work() and ice_ptp_periodic_work() are both scheduled on
the same kthread_worker pf.ptp.kworker. But, ice_ptp_periodic_work()
sends messages to AQ and waits for responses. This causes
ice_ptp_extts_work() to be blocked while waiting to be scheduled. This
causes problems with the reading of the incoming signal timestamps,
which disrupts a 100 Hz signal.

Create an additional kthread_worker pf.ptp.kworker_extts to service only
ice_ptp_extts_work() as soon as possible.

Fixes: 77a781155a65 ("ice: enable receive hardware timestamping")
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c |  5 ++++-
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 15 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp.h  |  2 ++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ca2898467dcb..d0f14e73e8da 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3106,7 +3106,10 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 						     GLTSYN_STAT_EVENT1_M |
 						     GLTSYN_STAT_EVENT2_M);
 		ena_mask &= ~PFINT_OICR_TSYN_EVNT_M;
-		kthread_queue_work(pf->ptp.kworker, &pf->ptp.extts_work);
+
+		if (pf->ptp.kworker_extts)
+			kthread_queue_work(pf->ptp.kworker_extts,
+					   &pf->ptp.extts_work);
 	}
 
 #define ICE_AUX_CRIT_ERR (PFINT_OICR_PE_CRITERR_M | PFINT_OICR_HMC_ERR_M | PFINT_OICR_PE_PUSH_M)
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 0f668468d141..f9e20622ad9f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2604,7 +2604,7 @@ static int ice_ptp_init_owner(struct ice_pf *pf)
  */
 static int ice_ptp_init_work(struct ice_pf *pf, struct ice_ptp *ptp)
 {
-	struct kthread_worker *kworker;
+	struct kthread_worker *kworker, *kworker_extts;
 
 	/* Initialize work functions */
 	kthread_init_delayed_work(&ptp->work, ice_ptp_periodic_work);
@@ -2620,6 +2620,13 @@ static int ice_ptp_init_work(struct ice_pf *pf, struct ice_ptp *ptp)
 
 	ptp->kworker = kworker;
 
+	kworker_extts = kthread_create_worker(0, "ice-ptp-extts-%s",
+					      dev_name(ice_pf_to_dev(pf)));
+	if (IS_ERR(kworker_extts))
+		return PTR_ERR(kworker_extts);
+
+	ptp->kworker_extts = kworker_extts;
+
 	/* Start periodic work going */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work, 0);
 
@@ -2719,11 +2726,17 @@ void ice_ptp_release(struct ice_pf *pf)
 
 	ice_ptp_port_phy_stop(&pf->ptp.port);
 	mutex_destroy(&pf->ptp.port.ps_lock);
+
 	if (pf->ptp.kworker) {
 		kthread_destroy_worker(pf->ptp.kworker);
 		pf->ptp.kworker = NULL;
 	}
 
+	if (pf->ptp.kworker_extts) {
+		kthread_destroy_worker(pf->ptp.kworker_extts);
+		pf->ptp.kworker_extts = NULL;
+	}
+
 	if (!pf->ptp.clock)
 		return;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 028349295b71..c63ad2c9af4c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -165,6 +165,7 @@ struct ice_ptp_port {
  * @ext_ts_chan: the external timestamp channel in use
  * @ext_ts_irq: the external timestamp IRQ in use
  * @kworker: kwork thread for handling periodic work
+ * @kworker_extts: kworker thread for handling extts work
  * @perout_channels: periodic output data
  * @info: structure defining PTP hardware capabilities
  * @clock: pointer to registered PTP clock device
@@ -186,6 +187,7 @@ struct ice_ptp {
 	u8 ext_ts_chan;
 	u8 ext_ts_irq;
 	struct kthread_worker *kworker;
+	struct kthread_worker *kworker_extts;
 	struct ice_perout_channel perout_channels[GLTSYN_TGT_H_IDX_MAX];
 	struct ptp_clock_info info;
 	struct ptp_clock *clock;
-- 
2.35.1

