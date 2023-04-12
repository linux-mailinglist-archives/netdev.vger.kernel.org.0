Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8236DED77
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjDLIVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjDLIU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:20:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39CA6180
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681287600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hG994YE67rZvr5ClF5c++Z0RWhwqiMTZjmfR4He2nHA=;
        b=Il+3D3D6Cj63LmCcgFOPkjer9K+xHlFUxmXt5kF+pkS2xGjB9oqceImrdlB//+6+kaa27/
        FU/F79B9sWNeTcOJs+Qe9AuxnESvd8g5p0iuAQcFGbF7suOpCWhLLoR/gEvtv/7r6FrbG6
        i/D2cWtbhUlltqoKdnx8Sx8zEyau3Mg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-FCJJb5cpPMyn64bMqMSkdQ-1; Wed, 12 Apr 2023 04:19:57 -0400
X-MC-Unique: FCJJb5cpPMyn64bMqMSkdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A5D929AB3E7;
        Wed, 12 Apr 2023 08:19:57 +0000 (UTC)
Received: from toolbox.infra.bos2.lab (ovpn-192-9.brq.redhat.com [10.40.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1514B1415117;
        Wed, 12 Apr 2023 08:19:54 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Brent Rowsell <browsell@redhat.com>
Subject: [PATCH net-next v2 4/6] ice: sleep, don't busy-wait, for ICE_CTL_Q_SQ_CMD_TIMEOUT
Date:   Wed, 12 Apr 2023 10:19:27 +0200
Message-Id: <20230412081929.173220-5-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-1-mschmidt@redhat.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
2.39.2

