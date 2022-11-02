Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D25D616F62
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiKBVKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiKBVKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:10:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C23DFDD
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667423422; x=1698959422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CgiydcFvXnmu0+R2XKuU+mPGt6aENPqzqlAclAjq0U8=;
  b=eQAzjpcN3Z3S7MhwtoO2gXoV6mMRQ3SzfHLp6LGboI2xp1oe8Qlshuo3
   r2iWcp7j9ntXwaZRlYoacE3s17muzXo4TxfyPDnCzHLL80erIM9o6NnPc
   PvYYSDHUEPzOys0L/mkwwigGjXqbiGaOob2mGaPTeJmqpdzzmNVtYvTVT
   Veks8vxXP5sue5nFdV73YXXvqmVUt7N5G+rP+/EYZrbTydgqwPO+8DgzC
   qwt1XM+7BqBbssluvH+Tfc6JXlNUfxsJTt79dMavri28d7ITFMt1P4+lq
   ken8klicu1ecW27EF5sTmLXV7h/GBb8UbD/TEkI7T8QyNzlJh4jT/23g4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="311245989"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="311245989"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 14:10:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="629102999"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="629102999"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 02 Nov 2022 14:10:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/7] i40e: Add i40e_napi_poll tracepoint
Date:   Wed,  2 Nov 2022 14:10:08 -0700
Message-Id: <20221102211011.2944983-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
References: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

Add a tracepoint for i40e_napi_poll that allows users to get detailed
information about the amount of work done. This information can help users
better tune the correct NAPI parameters (like weight and budget), as well
as debug NIC settings like rx-usecs and tx-usecs, etc.

When perf is attached, this tracepoint only fires when not in XDP mode.

An example of the output from this tracepoint:

$ sudo perf trace -e i40e:i40e_napi_poll -a --call-graph=fp --libtraceevent_print

[..snip..]

388.258 :0/0 i40e:i40e_napi_poll(i40e_napi_poll on dev eth2 q i40e-eth2-TxRx-9 irq 346 irq_mask 00000000,00000000,00000000,00000000,00000000,00800000 curr_cpu 23 budget 64 bpr 64 rx_cleaned 28 tx_cleaned 0 rx_clean_complete 1 tx_clean_complete 1)
	i40e_napi_poll ([i40e])
	i40e_napi_poll ([i40e])
	__napi_poll ([kernel.kallsyms])
	net_rx_action ([kernel.kallsyms])
	__do_softirq ([kernel.kallsyms])
	common_interrupt ([kernel.kallsyms])
	asm_common_interrupt ([kernel.kallsyms])
	intel_idle_irq ([kernel.kallsyms])
	cpuidle_enter_state ([kernel.kallsyms])
	cpuidle_enter ([kernel.kallsyms])
	do_idle ([kernel.kallsyms])
	cpu_startup_entry ([kernel.kallsyms])
	[0x243fd8] ([kernel.kallsyms])
	secondary_startup_64_no_verify ([kernel.kallsyms])

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_trace.h | 49 ++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c  |  4 ++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
index b5b12299931f..79d587ad5409 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
@@ -55,6 +55,55 @@
  * being built from shared code.
  */
 
+#define NO_DEV "(i40e no_device)"
+
+TRACE_EVENT(i40e_napi_poll,
+
+	TP_PROTO(struct napi_struct *napi, struct i40e_q_vector *q, int budget,
+		 int budget_per_ring, unsigned int rx_cleaned, unsigned int tx_cleaned,
+		 bool rx_clean_complete, bool tx_clean_complete),
+
+	TP_ARGS(napi, q, budget, budget_per_ring, rx_cleaned, tx_cleaned,
+		rx_clean_complete, tx_clean_complete),
+
+	TP_STRUCT__entry(
+		__field(int, budget)
+		__field(int, budget_per_ring)
+		__field(unsigned int, rx_cleaned)
+		__field(unsigned int, tx_cleaned)
+		__field(int, rx_clean_complete)
+		__field(int, tx_clean_complete)
+		__field(int, irq_num)
+		__field(int, curr_cpu)
+		__string(qname, q->name)
+		__string(dev_name, napi->dev ? napi->dev->name : NO_DEV)
+		__bitmask(irq_affinity,	nr_cpumask_bits)
+	),
+
+	TP_fast_assign(
+		__entry->budget = budget;
+		__entry->budget_per_ring = budget_per_ring;
+		__entry->rx_cleaned = rx_cleaned;
+		__entry->tx_cleaned = tx_cleaned;
+		__entry->rx_clean_complete = rx_clean_complete;
+		__entry->tx_clean_complete = tx_clean_complete;
+		__entry->irq_num = q->irq_num;
+		__entry->curr_cpu = get_cpu();
+		__assign_str(qname, q->name);
+		__assign_str(dev_name, napi->dev ? napi->dev->name : NO_DEV);
+		__assign_bitmask(irq_affinity, cpumask_bits(&q->affinity_mask),
+				 nr_cpumask_bits);
+	),
+
+	TP_printk("i40e_napi_poll on dev %s q %s irq %d irq_mask %s curr_cpu %d "
+		  "budget %d bpr %d rx_cleaned %u tx_cleaned %u "
+		  "rx_clean_complete %d tx_clean_complete %d",
+		__get_str(dev_name), __get_str(qname), __entry->irq_num,
+		__get_bitmask(irq_affinity), __entry->curr_cpu, __entry->budget,
+		__entry->budget_per_ring, __entry->rx_cleaned, __entry->tx_cleaned,
+		__entry->rx_clean_complete, __entry->tx_clean_complete)
+);
+
 /* Events related to a vsi & ring */
 DECLARE_EVENT_CLASS(
 	i40e_tx_template,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 6313395d2d3c..924f972b91fa 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2752,6 +2752,10 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 			clean_complete = rx_clean_complete = false;
 	}
 
+	if (!i40e_enabled_xdp_vsi(vsi))
+		trace_i40e_napi_poll(napi, q_vector, budget, budget_per_ring, rx_cleaned,
+				     tx_cleaned, rx_clean_complete, tx_clean_complete);
+
 	/* If work not completed, return budget and polling will return */
 	if (!clean_complete) {
 		int cpu_id = smp_processor_id();
-- 
2.35.1

