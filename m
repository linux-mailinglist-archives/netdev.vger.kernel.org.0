Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC46F60232
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfGEId2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:33:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:42994 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726800AbfGEId2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:33:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2BA7BAE3F;
        Fri,  5 Jul 2019 08:33:26 +0000 (UTC)
Date:   Fri, 5 Jul 2019 17:33:19 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 01/16] qlge: Remove irq_cnt
Message-ID: <20190705083319.GA24613@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <DM6PR18MB2697814343012B4363482290ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
 <20190626113619.GA27420@f1>
 <DM6PR18MB2697291D4195683CC42EA194ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB2697291D4195683CC42EA194ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/26 13:21, Manish Chopra wrote:
> > In msix mode there's no need to explicitly disable completion interrupts, they
> > are reliably auto-masked, according to my observations.
> > I tested this on two QLE8142 adapters.
> > 
> > Do you have reason to believe this might not always be the case?
> 
> How did you check auto-masking of MSI-X interrupts ?
> I was just wondering about the below comment in ql_disable_completion_interrupt(), where for MSI-X it does disable completion intr for zeroth intr.
> Seems special case for zeroth intr in MSI-X particular to this device.
> 
>         /* HW disables for us if we're MSIX multi interrupts and
>          * it's not the default (zeroeth) interrupt.
>          */
>         if (likely(test_bit(QL_MSIX_ENABLED, &qdev->flags) && intr))
>                 return 0;
> 

I checked again and arrived at the same conclusion: in msix mode,
completion interrupts are masked automatically and the adapter does not
raise interrupts until they are enabled at the end of napi polling. That
includes queue 0.

I checked by adding some tracepoints and sending traffic using pktgen.
All udp traffic goes to queue 0 with qlge. Over a 100s interval I got
2970339 q0 interrupts. In all cases, INTR_EN_EN was unset for q0.
Moreover, there were no interrupts that were raised while we were sure
that interrupts were expected to be disabled. I also tested with icmp
and multiple streams of tcp traffic and got similar results.

The driver patch for tracing as well as the analysis script are at the
bottom of this mail. I use them like so:
root@dtest:~# trace-cmd record -C global -b 1000000 -s 1000000 -e qlge:compirq_* -f "intr == 0" -e qlge:q0_intr sleep 100
[...]
root@dtest:~# trace-cmd report -l | ./report.awk | awk '{print $1}' | sort | uniq -c

It took me a few days to reply because while doing that testing I
actually found another problem. It is present before this patch set. In
INTx mode, ql_disable_completion_interrupt() does not immediately
prevent the adapter from raising interrupts. Redoing a similar test as
the previous one while forcing INTx mode via qlge_irq_type=2, I get
something like this:
4966280 0x00004300
   6565 0x0000c300
 137749 def_bad
   7094 ISR1_0

First, we can see what I already wrote in this patch:
+	/* Experience shows that when using INTx interrupts, the device does
+	 * not always auto-mask the interrupt.
(The 0x0000c300 values include INTR_EN_EN)
Second, we can see 137749 instances of interrupts while we were
expecting interrupt generation to be disabled.

If I disable interrupts using INTR_EN_EI instead, I get something like
this:
4672919 0x00004300
     75 0x0000c300
      2 ISR1_0

I'll be including a patch for this in the next iteration of this
patchset.

==== report.awk ====
#!/usr/bin/awk -f

BEGIN {
	enabled = -1;
}

/compirq_enable_b/ {
	enabled = 1;
	next;
}

/compirq_enable_a/ {
	enabled = 2;
	next;
}

/q0_intr/ {
	# INTR_EN
	print $10;

	if ($14 == "0x00000000") {
		print "ISR1_0";
	}

	if (enabled == 0) {
		printf "def_bad "
		print $3;
	} else if (enabled == 1) {
		printf "maybe_bad "
		print $3;
	}
	# at this point we expect the irq to be masked, either automatically
	# or explicitely
	enabled = 0;
	next;
}

==== driver patch ====

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 9a99e0938f08..ab306963eef1 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -43,6 +43,9 @@
 
 #include "qlge.h"
 
+#define CREATE_TRACE_POINTS
+#include "qlge_trace.h"
+
 char qlge_driver_name[] = DRV_NAME;
 const char qlge_driver_version[] = DRV_VERSION;
 
@@ -641,16 +644,20 @@ u32 ql_enable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
 		/* Always enable if we're MSIX multi interrupts and
 		 * it's not the default (zeroeth) interrupt.
 		 */
+		trace_compirq_enable_b(qdev, intr);
 		ql_write32(qdev, INTR_EN,
 			   ctx->intr_en_mask);
+		trace_compirq_enable_a(qdev, intr);
 		var = ql_read32(qdev, STS);
 		return var;
 	}
 
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 	if (atomic_dec_and_test(&ctx->irq_cnt)) {
+		trace_compirq_enable_b(qdev, intr);
 		ql_write32(qdev, INTR_EN,
 			   ctx->intr_en_mask);
+		trace_compirq_enable_a(qdev, intr);
 		var = ql_read32(qdev, STS);
 	}
 	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
@@ -671,8 +678,10 @@ static u32 ql_disable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
 	ctx = qdev->intr_context + intr;
 	spin_lock(&qdev->hw_lock);
 	if (!atomic_read(&ctx->irq_cnt)) {
+		trace_compirq_disable_b(qdev, intr);
 		ql_write32(qdev, INTR_EN,
 		ctx->intr_dis_mask);
+		trace_compirq_disable_a(qdev, intr);
 		var = ql_read32(qdev, STS);
 	}
 	atomic_inc(&ctx->irq_cnt);
@@ -2484,6 +2493,7 @@ static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
 {
 	struct rx_ring *rx_ring = dev_id;
 	napi_schedule(&rx_ring->napi);
+	trace_napi_schedule(&rx_ring->napi);
 	return IRQ_HANDLED;
 }
 
@@ -2500,6 +2510,8 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 	u32 var;
 	int work_done = 0;
 
+	trace_q0_intr(qdev, ql_read32(qdev, STS), ql_read32(qdev, ISR1));
+
 	spin_lock(&qdev->hw_lock);
 	if (atomic_read(&qdev->intr_context[0].irq_cnt)) {
 		netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
@@ -2552,6 +2564,7 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 			   "Waking handler for rx_ring[0].\n");
 		ql_disable_completion_interrupt(qdev, intr_context->intr);
 		napi_schedule(&rx_ring->napi);
+		trace_napi_schedule(&rx_ring->napi);
 		work_done++;
 	}
 	ql_enable_completion_interrupt(qdev, intr_context->intr);
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_trace.h b/drivers/net/ethernet/qlogic/qlge/qlge_trace.h
new file mode 100644
index 000000000000..f199c6eb785c
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_trace.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_QLGE_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _QLGE_TRACE_H_
+
+#include <linux/tracepoint.h>
+
+#include "qlge.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM qlge
+#define TRACE_INCLUDE_FILE qlge_trace
+
+#define NO_DEV "(no_device)"
+
+TRACE_EVENT(napi_schedule,
+	    TP_PROTO(struct napi_struct *napi),
+	    TP_ARGS(napi),
+
+	    TP_STRUCT__entry(
+			     __field(struct napi_struct *, napi)
+			     __string(dev_name,
+				      napi->dev ? napi->dev->name : NO_DEV)
+			     __field(unsigned long, napi_state)
+			     ),
+
+	    TP_fast_assign(
+			   __entry->napi = napi;
+			   __assign_str(dev_name,
+					napi->dev ? napi->dev->name : NO_DEV);
+			   __entry->napi_state = READ_ONCE(napi->state);
+			   ),
+
+	    TP_printk("napi schedule on napi struct %p for device %s napi 0x%02lx\n",
+		      __entry->napi, __get_str(dev_name), __entry->napi_state)
+);
+
+DECLARE_EVENT_CLASS(compirq_template,
+		    TP_PROTO(struct ql_adapter *qdev, u32 intr),
+		    TP_ARGS(qdev, intr),
+
+		    TP_STRUCT__entry(
+				     __string(dev_name, qdev->ndev->name)
+				     __field(unsigned int, intr)
+				     ),
+
+		    TP_fast_assign(
+				   __assign_str(dev_name, qdev->ndev->name);
+				   __entry->intr = intr;
+				   ),
+
+		    TP_printk("completion irq toggle device %s intr %d\n",
+			      __get_str(dev_name), __entry->intr)
+);
+
+DEFINE_EVENT(compirq_template, compirq_enable_b,
+	     TP_PROTO(struct ql_adapter *qdev, u32 intr),
+	     TP_ARGS(qdev, intr));
+DEFINE_EVENT(compirq_template, compirq_enable_a,
+	     TP_PROTO(struct ql_adapter *qdev, u32 intr),
+	     TP_ARGS(qdev, intr));
+
+DEFINE_EVENT(compirq_template, compirq_disable_b,
+	     TP_PROTO(struct ql_adapter *qdev, u32 intr),
+	     TP_ARGS(qdev, intr));
+DEFINE_EVENT(compirq_template, compirq_disable_a,
+	     TP_PROTO(struct ql_adapter *qdev, u32 intr),
+	     TP_ARGS(qdev, intr));
+
+TRACE_EVENT(q0_intr,
+	    TP_PROTO(struct ql_adapter *qdev, u32 sts, u32 isr1),
+	    TP_ARGS(qdev, sts, isr1),
+
+	    TP_STRUCT__entry(
+		    __string(dev_name, qdev->ndev->name)
+		    __field(unsigned int, intr_en)
+		    __field(unsigned int, sts)
+		    __field(unsigned int, isr1)
+		    ),
+
+	    TP_fast_assign(
+		    __assign_str(dev_name, qdev->ndev->name);
+		    ql_write32(qdev, INTR_EN, qdev->intr_context[0].intr_read_mask);
+		    __entry->intr_en = ql_read32(qdev, INTR_EN);
+		    __entry->sts = sts;
+		    __entry->isr1 = isr1;
+		    ),
+
+	    TP_printk("interrupt for dev %s INTR_EN 0x%08x STS 0x%08x ISR1 0x%08x\n",
+		      __get_str(dev_name), __entry->intr_en, __entry->sts,
+		      __entry->isr1)
+);
+
+#endif /* _QLGE_TRACE_H_ */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../drivers/net/ethernet/qlogic/qlge
+#include <trace/define_trace.h>
