Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422B96D32D2
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 19:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjDAR2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 13:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjDAR2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 13:28:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606541B368
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 10:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680370050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6x9JHpIA3PUU98RhwvPPH7uduxmtkgeeOAzyRa/9hgc=;
        b=HvY7o6C8InVlXCcoVdzC5h9yS0IMmM2UjepHYuf7Pxre949xT6WOykCCPuCJvn2cgfN6VW
        I/yOqtceIvjTRagnJXN9+L5P1fb1lh4yIBwlUa2cPMXYNmI6PW8+WehJ5XdkQ9MoY903wa
        Z2K3vcjUVAT2XL/VUWW7zyMfK7djy28=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-1Zk0PcwAOyC9okto5OV-gg-1; Sat, 01 Apr 2023 13:27:25 -0400
X-MC-Unique: 1Zk0PcwAOyC9okto5OV-gg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7790A811E7C;
        Sat,  1 Apr 2023 17:27:24 +0000 (UTC)
Received: from toolbox.redhat.com (ovpn-192-6.brq.redhat.com [10.40.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 679FB40C83A9;
        Sat,  1 Apr 2023 17:27:22 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Petr Oros <poros@redhat.com>
Subject: [PATCH net-next 2/4] ice: sleep, don't busy-wait, for sq_cmd_timeout
Date:   Sat,  1 Apr 2023 19:26:57 +0200
Message-Id: <20230401172659.38508-3-mschmidt@redhat.com>
In-Reply-To: <20230401172659.38508-1-mschmidt@redhat.com>
References: <20230401172659.38508-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver polls for ice_sq_done() with a 100 µs period for up to 1 s
and it uses udelay to do that.

Let's use usleep_range instead. We know sleeping is allowed here,
because we're holding a mutex (cq->sq_lock). To preserve the total
max waiting time, measure cq->sq_cmd_timeout in jiffies.

The sq_cmd_timeout is referenced also in ice_release_res(), but there
the polling period is 1 ms (i.e. 10 times longer). Since the timeout
was expressed in terms of the number of loops, the total timeout in this
function is 10 s. I do not know if this is intentional. This patch keeps
it.

The patch lowers the CPU usage of the ice-gnss-<dev_name> kernel thread
on my system from ~8 % to less than 1 %.
I saw a report of high CPU usage with ptp4l where the busy-waiting in
ice_sq_send_cmd dominated the profile. The patch should help with that.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 14 +++++++-------
 drivers/net/ethernet/intel/ice/ice_controlq.c |  9 +++++----
 drivers/net/ethernet/intel/ice/ice_controlq.h |  2 +-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c2fda4fa4188..14cffe49fa8c 100644
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
-	while ((status == -EIO) && (total_delay < hw->adminq.sq_cmd_timeout)) {
-		mdelay(1);
+	timeout = jiffies + 10 * hw->adminq.sq_cmd_timeout;
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
index 6bcfee295991..10125e8aa555 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -967,7 +967,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	struct ice_aq_desc *desc_on_ring;
 	bool cmd_completed = false;
 	struct ice_sq_cd *details;
-	u32 total_delay = 0;
+	unsigned long timeout;
 	int status = 0;
 	u16 retval = 0;
 	u32 val = 0;
@@ -1060,13 +1060,14 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		cq->sq.next_to_use = 0;
 	wr32(hw, cq->sq.tail, cq->sq.next_to_use);
 
+	timeout = jiffies + cq->sq_cmd_timeout;
 	do {
 		if (ice_sq_done(hw, cq))
 			break;
 
-		udelay(ICE_CTL_Q_SQ_CMD_USEC);
-		total_delay++;
-	} while (total_delay < cq->sq_cmd_timeout);
+		usleep_range(ICE_CTL_Q_SQ_CMD_USEC,
+			     ICE_CTL_Q_SQ_CMD_USEC * 3 / 2);
+	} while (time_before(jiffies, timeout));
 
 	/* if ready, copy the desc back to temp */
 	if (ice_sq_done(hw, cq)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index c07e9cc9fc6e..f2d3b115ae0b 100644
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
2.39.2

