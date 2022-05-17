Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEC652A995
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348533AbiEQRs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351606AbiEQRsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:48:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1868D50075
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 10:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652809732; x=1684345732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=92wl5AvL4PCPcuIR5u1Yfc2jZRnbnlOsqUt0fGYSUEU=;
  b=cteqtFCcwN3zvbUgxFXxIG+xco0pv66OTmrSdPlUacIxV7XQY5AWFtHR
   CdxeNqi7TfetGq8UNYWa1jOm3NLvodrFNOpv2RPZ6cnErYmAVOk1+90u7
   W1WCARQI0LJ1a6ITpotAy/OneigAMqg7Jqy+IgBUoVy81EBaPZrM7Pdwk
   O/+bGJsT2BR70Hz98k7zoyJe7c+7FtUlqpU/mtTEtf8+aH5zBvKI9DFI1
   rrXGxZLHHqOhekQ1ixh8e1ap8gwiCgKerfCg9P/ENCpveBJsT8fW9u2Cl
   iMs9R0Ym/lYG9qXEjSvvwWyEbsZn6B+iKX3sc8+CV2YGFmcU82Z505ECR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="253316423"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="253316423"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 10:48:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="545015275"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 May 2022 10:48:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Michal Schmidt <mschmidt@redhat.com>,
        Dave Cain <dcain@redhat.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 1/3] ice: fix crash when writing timestamp on RX rings
Date:   Tue, 17 May 2022 10:45:45 -0700
Message-Id: <20220517174547.1757401-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
References: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index da025c204577..662947c882e8 100644
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
+	/* Run twice a second or reschedule if phc update failed */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
-				   msecs_to_jiffies(500));
+				   msecs_to_jiffies(err ? 10 : 500));
 }
 
 /**
-- 
2.35.1

