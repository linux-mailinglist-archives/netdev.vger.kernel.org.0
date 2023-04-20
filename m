Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72D16EA04D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjDTXxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjDTXxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:53:44 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F9C3C26
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034815; x=1713570815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+1dCCdI6aEVbmgVAy8Rceq1/FIrp1V8aVptf5Jz/uco=;
  b=hYF20kZ0qC7cpm5sG+RcxXYm20RsfHi1RfSvIru0+yXcYQI7FjcIjnje
   d9IuniibM269CEPwauWDlDupiZiCoX3n1DrW8oM7MjGIKWp3IdvGQuuUu
   uALsVIvCdbfuzOcRQZ5nLS7bMBEXdEjxWbgZfjqmSux99m47vOnL4xqHz
   KFC9ktFjhW2jFdzV41t3CuBiq5U0Q/UthNDWc25hyCCwnjWmRXXIuJclB
   wb7Mc3yF0zGxQo5sLxzZSnrhcHhp7anOvw4sP75mS4ouyMGWM6TSbg2pR
   DD6PAb9f+fMtqVy/tH2JevvUCCqt0QcUg5ZdtjAN+VjYs2rj3oY+BDlUH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343368447"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343368447"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:53:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756714248"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="756714248"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 20 Apr 2023 16:53:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Schmidt <mschmidt@redhat.com>, anthony.l.nguyen@intel.com,
        johan@kernel.org, Brent Rowsell <browsell@redhat.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 4/6] ice: sleep, don't busy-wait, for ICE_CTL_Q_SQ_CMD_TIMEOUT
Date:   Thu, 20 Apr 2023 16:50:31 -0700
Message-Id: <20230420235033.2971567-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
References: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

The driver polls for ice_sq_done() with a 100 µs period for up to 1 s
and it uses udelay to do that.

Let's use usleep_range instead. We know sleeping is allowed here,
because we're holding a mutex (cq->sq_lock). To preserve the total
max waiting time, measure the timeout in jiffies.

ICE_CTL_Q_SQ_CMD_TIMEOUT is used also in ice_release_res(), but there
the polling period is 1 ms (i.e. 10 times longer). Since the timeout was
expressed in terms of the number of loops, the total timeout in this
function is 10 s. I do not know if this is intentional. This patch keeps
it.

The patch lowers the CPU usage of the ice-gnss-<dev_name> kernel thread
on my system from ~8 % to less than 1 %.

I received a report of high CPU usage with ptp4l where the busy-waiting
in ice_sq_send_cmd dominated the profile. This patch has been tested in
that usecase too and it made a huge improvement there.

Tested-by: Brent Rowsell <browsell@redhat.com>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 14 +++++++-------
 drivers/net/ethernet/intel/ice/ice_controlq.c |  9 +++++----
 drivers/net/ethernet/intel/ice/ice_controlq.h |  2 +-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index f4c256563248..3638598d732b 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1992,19 +1992,19 @@ ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
  */
 void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res)
 {
-	u32 total_delay = 0;
+	unsigned long timeout;
 	int status;
 
-	status = ice_aq_release_res(hw, res, 0, NULL);
-
 	/* there are some rare cases when trying to release the resource
 	 * results in an admin queue timeout, so handle them correctly
 	 */
-	while ((status == -EIO) && (total_delay < ICE_CTL_Q_SQ_CMD_TIMEOUT)) {
-		mdelay(1);
+	timeout = jiffies + 10 * ICE_CTL_Q_SQ_CMD_TIMEOUT;
+	do {
 		status = ice_aq_release_res(hw, res, 0, NULL);
-		total_delay++;
-	}
+		if (status != -EIO)
+			break;
+		usleep_range(1000, 2000);
+	} while (time_before(jiffies, timeout));
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index c8fb10106ec3..d2faf1baad2f 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -964,7 +964,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	struct ice_aq_desc *desc_on_ring;
 	bool cmd_completed = false;
 	struct ice_sq_cd *details;
-	u32 total_delay = 0;
+	unsigned long timeout;
 	int status = 0;
 	u16 retval = 0;
 	u32 val = 0;
@@ -1057,13 +1057,14 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		cq->sq.next_to_use = 0;
 	wr32(hw, cq->sq.tail, cq->sq.next_to_use);
 
+	timeout = jiffies + ICE_CTL_Q_SQ_CMD_TIMEOUT;
 	do {
 		if (ice_sq_done(hw, cq))
 			break;
 
-		udelay(ICE_CTL_Q_SQ_CMD_USEC);
-		total_delay++;
-	} while (total_delay < ICE_CTL_Q_SQ_CMD_TIMEOUT);
+		usleep_range(ICE_CTL_Q_SQ_CMD_USEC,
+			     ICE_CTL_Q_SQ_CMD_USEC * 3 / 2);
+	} while (time_before(jiffies, timeout));
 
 	/* if ready, copy the desc back to temp */
 	if (ice_sq_done(hw, cq)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index e790b2f4e437..950b7f4a7a05 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -34,7 +34,7 @@ enum ice_ctl_q {
 };
 
 /* Control Queue timeout settings - max delay 1s */
-#define ICE_CTL_Q_SQ_CMD_TIMEOUT	10000 /* Count 10000 times */
+#define ICE_CTL_Q_SQ_CMD_TIMEOUT	HZ    /* Wait max 1s */
 #define ICE_CTL_Q_SQ_CMD_USEC		100   /* Check every 100usec */
 #define ICE_CTL_Q_ADMIN_INIT_TIMEOUT	10    /* Count 10 times */
 #define ICE_CTL_Q_ADMIN_INIT_MSEC	100   /* Check every 100msec */
-- 
2.38.1

