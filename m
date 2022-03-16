Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D896C4DB997
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357995AbiCPUlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351194AbiCPUlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:41:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E4164BEB
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647463203; x=1678999203;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=giCCFYDIF+LX6FIKhwOB9/5qD/vIWZGl8tcCwZh35Y8=;
  b=ZgtI3oCv8XJOUBNLXnCyCCbH0tybDMJGdmHYDVaRfKWjoBS1B5fcNCZD
   Is6Mi1ptq7mIG1HUM+i1R/lLLvpZi4JpDyRpvbEAg8GOjoWR0hPkaPplA
   1dCFr1hjMr8/fmx2QS3sfda22v9QKAAdO8WcviJudfbpu/jrtGXkBkdJA
   UGhY9jLwpr8ekItwQIG5CjG5BxEZhUI3T/2nkai5sLZ+DnyCjLFKFpCjk
   wxSBLtzqQFSD07be2UlSGxTNB1B6CuEnbI5Av3jVBi/8HtFZLpV3jngEU
   /LQJsT6OFXAt5EUUcIJJR58YNOxxWAMvg4ZEZkKAZeBuYE/+BQyRzDuUd
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="236653298"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="236653298"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 13:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="646799212"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 16 Mar 2022 13:39:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, wojciech.drewek@intel.com,
        pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/4] ice: add trace events for tx timestamps
Date:   Wed, 16 Mar 2022 13:40:24 -0700
Message-Id: <20220316204024.3201500-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
References: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

We've previously run into many issues related to the latency of a Tx
timestamp completion with the ice hardware. It can be difficult to
determine the root cause of a slow Tx timestamp. To aid in this,
introduce new trace events which capture timing data about when the
driver reaches certain points while processing a transmit timestamp

 * ice_tx_tstamp_request: Trace when the stack initiates a new timestamp
   request.

 * ice_tx_tstamp_fw_req: Trace when the driver begins a read of the
   timestamp register in the work thread.

 * ice_tx_tstamp_fw_done: Trace when the driver finishes reading a
   timestamp register in the work thread.

 * ice_tx_tstamp_complete: Trace when the driver submits the skb back to
   the stack with a completed Tx timestamp.

These trace events can be enabled using the standard trace event
subsystem exposed by the ice driver. If they are disabled, they become
no-ops with no run time cost.

The following is a simple GNU AWK script which can highlight one
potential way to use the trace events to capture latency data from the
trace buffer about how long the driver takes to process a timestamp:

-----
  BEGIN {
      PREC=256
  }

  # Detect requests
  /tx_tstamp_request/ {
      time=strtonum($4)
      skb=$7

      # Store the time of request for this skb
      requests[skb] = time
      printf("skb %s: idx %d at %.6f\n", skb, idx, time)
  }

  # Detect completions
  /tx_tstamp_complete/ {
      time=strtonum($4)
      skb=$7
      idx=$9

      if (skb in requests) {
          latency = (time - requests[skb]) * 1000
          printf("skb %s: %.3f to complete\n", skb, latency)
          if (latency > 4) {
              printf(">>> HIGH LATENCY <<<\n")
          }
          printf("\n")
      } else {
          printf("!!! skb %s (idx %d) at %.6f\n", skb, idx, time)
      }
  }
-----

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c   |  8 ++++++++
 drivers/net/ethernet/intel/ice/ice_trace.h | 24 ++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 000c39d163a2..a1cd33273ca4 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -3,6 +3,7 @@
 
 #include "ice.h"
 #include "ice_lib.h"
+#include "ice_trace.h"
 
 #define E810_OUT_PROP_DELAY_NS 1
 
@@ -2063,11 +2064,15 @@ static void ice_ptp_tx_tstamp_work(struct kthread_work *work)
 		struct sk_buff *skb;
 		int err;
 
+		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
+
 		err = ice_read_phy_tstamp(hw, tx->quad, phy_idx,
 					  &raw_tstamp);
 		if (err)
 			continue;
 
+		ice_trace(tx_tstamp_fw_done, tx->tstamps[idx].skb, idx);
+
 		/* Check if the timestamp is invalid or stale */
 		if (!(raw_tstamp & ICE_PTP_TS_VALID) ||
 		    raw_tstamp == tx->tstamps[idx].cached_tstamp)
@@ -2093,6 +2098,8 @@ static void ice_ptp_tx_tstamp_work(struct kthread_work *work)
 		tstamp = ice_ptp_extend_40b_ts(pf, raw_tstamp);
 		shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
 
+		ice_trace(tx_tstamp_complete, skb, idx);
+
 		skb_tstamp_tx(skb, &shhwtstamps);
 		dev_kfree_skb_any(skb);
 	}
@@ -2131,6 +2138,7 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 		tx->tstamps[idx].start = jiffies;
 		tx->tstamps[idx].skb = skb_get(skb);
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		ice_trace(tx_tstamp_request, skb, idx);
 	}
 
 	spin_unlock(&tx->lock);
diff --git a/drivers/net/ethernet/intel/ice/ice_trace.h b/drivers/net/ethernet/intel/ice/ice_trace.h
index cf685247c07a..ae98d5a8ff60 100644
--- a/drivers/net/ethernet/intel/ice/ice_trace.h
+++ b/drivers/net/ethernet/intel/ice/ice_trace.h
@@ -216,6 +216,30 @@ DEFINE_EVENT(ice_xmit_template, name, \
 DEFINE_XMIT_TEMPLATE_OP_EVENT(ice_xmit_frame_ring);
 DEFINE_XMIT_TEMPLATE_OP_EVENT(ice_xmit_frame_ring_drop);
 
+DECLARE_EVENT_CLASS(ice_tx_tstamp_template,
+		    TP_PROTO(struct sk_buff *skb, int idx),
+
+		    TP_ARGS(skb, idx),
+
+		    TP_STRUCT__entry(__field(void *, skb)
+				     __field(int, idx)),
+
+		    TP_fast_assign(__entry->skb = skb;
+				   __entry->idx = idx;),
+
+		    TP_printk("skb %pK idx %d",
+			      __entry->skb, __entry->idx)
+);
+#define DEFINE_TX_TSTAMP_OP_EVENT(name) \
+DEFINE_EVENT(ice_tx_tstamp_template, name, \
+	     TP_PROTO(struct sk_buff *skb, int idx), \
+	     TP_ARGS(skb, idx))
+
+DEFINE_TX_TSTAMP_OP_EVENT(ice_tx_tstamp_request);
+DEFINE_TX_TSTAMP_OP_EVENT(ice_tx_tstamp_fw_req);
+DEFINE_TX_TSTAMP_OP_EVENT(ice_tx_tstamp_fw_done);
+DEFINE_TX_TSTAMP_OP_EVENT(ice_tx_tstamp_complete);
+
 /* End tracepoints */
 
 #endif /* _ICE_TRACE_H_ */
-- 
2.31.1

