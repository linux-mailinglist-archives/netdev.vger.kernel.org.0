Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEADC51AF01
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbiEDU3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbiEDU3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:29:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69A74E3AA
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651695955; x=1683231955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XeY4B+OsF8Otw6N+LNtc4MYGMzkpcvlXNvnXu1Dym/4=;
  b=YuM4yr7pF/wXz7tN+i3X5QCNYzo4rjDkSo1aRV5SBXHiAzte2PCkxVS2
   XwGSRq3Of7XdMmhYHiBuNZFVRo29WAvR/xNvvb75VaWbSey9zEgPknMrU
   zVlxUOLHy7rMBdt3FrdF6rMbHG8ETGqkT59Ec0yu0p/aXDfvuOYGTMY4e
   yAz4FUFmVyc00HsUxlIqIk7sTP7aQ2CioarcGchUKnLzAGZd2zVtrBVki
   0/yIYWJDbQlvCS4RrMS7LSDwRo7ptidCAUMb9ok5/UBd/T6rTNch+0TF3
   JsOa83k23jODEpILMwxrB/BMkFldPro7ayNTNY1wyZ9no7SgQ241hVF/b
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="267774826"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="267774826"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 13:25:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="620968712"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 May 2022 13:25:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Michal Schmidt <mschmidt@redhat.com>,
        Dave Cain <dcain@redhat.com>
Subject: [PATCH net 4/4] ice: fix crash when writing timestamp on RX rings
Date:   Wed,  4 May 2022 13:22:52 -0700
Message-Id: <20220504202252.2001471-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504202252.2001471-1-anthony.l.nguyen@intel.com>
References: <20220504202252.2001471-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Do not allow to write timestamps on RX rings if PF is being configured.
When PF is being configured RX rings can be freed or rebuilt. If at the
same time timestamps are updated, the kernel will crash by dereferencing
null RX ring pointer.

PID: 1449   TASK: ff187d28ed658040  CPU: 34  COMMAND: "ice-ptp-0000:51"
 #0 [ff1966a94a713bb0] machine_kexec at ffffffff9d05a0be
 #1 [ff1966a94a713c08] __crash_kexec at ffffffff9d192e9d
 #2 [ff1966a94a713cd0] crash_kexec at ffffffff9d1941bd
 #3 [ff1966a94a713ce8] oops_end at ffffffff9d01bd54
 #4 [ff1966a94a713d08] no_context at ffffffff9d06bda4
 #5 [ff1966a94a713d60] __bad_area_nosemaphore at ffffffff9d06c10c
 #6 [ff1966a94a713da8] do_page_fault at ffffffff9d06cae4
 #7 [ff1966a94a713de0] page_fault at ffffffff9da0107e
    [exception RIP: ice_ptp_update_cached_phctime+91]
    RIP: ffffffffc076db8b  RSP: ff1966a94a713e98  RFLAGS: 00010246
    RAX: 16e3db9c6b7ccae4  RBX: ff187d269dd3c180  RCX: ff187d269cd4d018
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ff187d269cfcc644   R8: ff187d339b9641b0   R9: 0000000000000000
    R10: 0000000000000002  R11: 0000000000000000  R12: ff187d269cfcc648
    R13: ffffffff9f128784  R14: ffffffff9d101b70  R15: ff187d269cfcc640
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ff1966a94a713ea0] ice_ptp_periodic_work at ffffffffc076dbef [ice]
 #9 [ff1966a94a713ee0] kthread_worker_fn at ffffffff9d101c1b
 #10 [ff1966a94a713f10] kthread at ffffffff9d101b4d
 #11 [ff1966a94a713f50] ret_from_fork at ffffffff9da0023f

Fixes: 77a781155a65 ("ice: enable receive hardware timestamping")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Dave Cain <dcain@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index da025c204577..cccefa88d8d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -500,12 +500,19 @@ ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
  * This function must be called periodically to ensure that the cached value
  * is never more than 2 seconds old. It must also be called whenever the PHC
  * time has been changed.
+ *
+ * Return:
+ * * 0 - OK, successfully updated
+ * * -EAGAIN - PF was busy, need to reschedule the update
  */
-static void ice_ptp_update_cached_phctime(struct ice_pf *pf)
+static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
 {
 	u64 systime;
 	int i;
 
+	if (test_and_set_bit(ICE_CFG_BUSY, pf->state))
+		return -EAGAIN;
+
 	/* Read the current PHC time */
 	systime = ice_ptp_read_src_clk_reg(pf, NULL);
 
@@ -528,6 +535,9 @@ static void ice_ptp_update_cached_phctime(struct ice_pf *pf)
 			WRITE_ONCE(vsi->rx_rings[j]->cached_phctime, systime);
 		}
 	}
+	clear_bit(ICE_CFG_BUSY, pf->state);
+
+	return 0;
 }
 
 /**
@@ -2330,17 +2340,18 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 {
 	struct ice_ptp *ptp = container_of(work, struct ice_ptp, work.work);
 	struct ice_pf *pf = container_of(ptp, struct ice_pf, ptp);
+	int err;
 
 	if (!test_bit(ICE_FLAG_PTP, pf->flags))
 		return;
 
-	ice_ptp_update_cached_phctime(pf);
+	err = ice_ptp_update_cached_phctime(pf);
 
 	ice_ptp_tx_tstamp_cleanup(&pf->hw, &pf->ptp.port.tx);
 
-	/* Run twice a second */
+	/* Run twice a second or reschedule if PHC update failed */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
-				   msecs_to_jiffies(500));
+				   msecs_to_jiffies(err ? 10 : 500));
 }
 
 /**
-- 
2.35.1

