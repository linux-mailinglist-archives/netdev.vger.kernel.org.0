Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B066F191903
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgCXSZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:25:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61590 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727781AbgCXSZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:25:03 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OI4Go5051512
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:02 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf3fd964-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:01 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 24 Mar 2020 18:24:58 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 18:24:56 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OIOufx58261594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 18:24:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0887A4066;
        Tue, 24 Mar 2020 18:24:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A42B4A406E;
        Tue, 24 Mar 2020 18:24:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 18:24:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 04/11] s390/qdio: extend polling support to multiple queues
Date:   Tue, 24 Mar 2020 19:24:41 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324182448.95362-1-jwi@linux.ibm.com>
References: <20200324182448.95362-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032418-0012-0000-0000-00000396FF90
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032418-0013-0000-0000-000021D3F4BE
Message-Id: <20200324182448.95362-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the support for polling drivers was initially added, it only
considered Input Queue 0. But as QDIO interrupts are actually for the
full device and not a single queue, this doesn't really fit for
configurations where multiple Input Queues are used.

Rework the qdio code so that interrupts for a polling driver are not
split up into actions for each queue. Instead deliver the interrupt as
a single event, and let the driver decide which queue needs what action.

When re-enabling the QDIO interrupt via qdio_start_irq(), this means
that the qdio code needs to
(1) put _all_ eligible queues back into a state where they raise IRQs,
(2) and afterwards check _all_ eligible queues for new work to bridge
    the race window.

On the qeth side of things (as the only qdio polling driver), we can now
add CQ polling support to the main NAPI poll routine. It doesn't consume
NAPI budget, and to avoid hogging the CPU we yield control after
completing one full queue worth of buffers.
The subsequent qdio_start_irq() will check for any additional work, and
have us re-schedule the NAPI instance accordingly.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/qdio.h      |  9 ++--
 drivers/s390/cio/qdio.h           | 11 +++--
 drivers/s390/cio/qdio_debug.c     |  4 +-
 drivers/s390/cio/qdio_main.c      | 50 +++++++++++------------
 drivers/s390/cio/qdio_setup.c     | 16 ++++----
 drivers/s390/cio/qdio_thinint.c   | 38 ++++++++---------
 drivers/s390/net/qeth_core_main.c | 68 +++++++++++++------------------
 7 files changed, 87 insertions(+), 109 deletions(-)

diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index 6ea3a1d5fe7f..8301a19a17db 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -340,7 +340,7 @@ typedef void qdio_handler_t(struct ccw_device *, unsigned int, int,
  * @no_output_qs: number of output queues
  * @input_handler: handler to be called for input queues
  * @output_handler: handler to be called for output queues
- * @queue_start_poll_array: polling handlers (one per input queue or NULL)
+ * @irq_poll: Data IRQ polling handler (NULL when not supported)
  * @scan_threshold: # of in-use buffers that triggers scan on output queue
  * @int_parm: interruption parameter
  * @input_sbal_addr_array:  address of no_input_qs * 128 pointers
@@ -361,8 +361,7 @@ struct qdio_initialize {
 	unsigned int no_output_qs;
 	qdio_handler_t *input_handler;
 	qdio_handler_t *output_handler;
-	void (**queue_start_poll_array) (struct ccw_device *, int,
-					  unsigned long);
+	void (*irq_poll)(struct ccw_device *cdev, unsigned long data);
 	unsigned int scan_threshold;
 	unsigned long int_parm;
 	struct qdio_buffer **input_sbal_addr_array;
@@ -417,8 +416,8 @@ extern int qdio_activate(struct ccw_device *);
 extern void qdio_release_aob(struct qaob *);
 extern int do_QDIO(struct ccw_device *, unsigned int, int, unsigned int,
 		   unsigned int);
-extern int qdio_start_irq(struct ccw_device *, int);
-extern int qdio_stop_irq(struct ccw_device *, int);
+extern int qdio_start_irq(struct ccw_device *cdev);
+extern int qdio_stop_irq(struct ccw_device *cdev);
 extern int qdio_get_next_buffers(struct ccw_device *, int, int *, int *);
 extern int qdio_inspect_queue(struct ccw_device *cdev, unsigned int nr,
 			      bool is_input, unsigned int *bufnr,
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index ff74eb5fce50..f72f961cc78f 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -177,8 +177,8 @@ struct qdio_queue_perf_stat {
 	unsigned int nr_sbal_total;
 };
 
-enum qdio_queue_irq_states {
-	QDIO_QUEUE_IRQS_DISABLED,
+enum qdio_irq_poll_states {
+	QDIO_IRQ_DISABLED,
 };
 
 struct qdio_input_q {
@@ -188,10 +188,6 @@ struct qdio_input_q {
 	int ack_count;
 	/* last time of noticing incoming data */
 	u64 timestamp;
-	/* upper-layer polling flag */
-	unsigned long queue_irq_state;
-	/* callback to start upper-layer polling */
-	void (*queue_start_poll) (struct ccw_device *, int, unsigned long);
 };
 
 struct qdio_output_q {
@@ -299,6 +295,9 @@ struct qdio_irq {
 	struct qdio_q *input_qs[QDIO_MAX_QUEUES_PER_IRQ];
 	struct qdio_q *output_qs[QDIO_MAX_QUEUES_PER_IRQ];
 
+	void (*irq_poll)(struct ccw_device *cdev, unsigned long data);
+	unsigned long poll_state;
+
 	debug_info_t *debug_area;
 	struct mutex setup_mutex;
 	struct qdio_dev_perf_stat perf_stat;
diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
index 9c0370b27426..00244607c8c0 100644
--- a/drivers/s390/cio/qdio_debug.c
+++ b/drivers/s390/cio/qdio_debug.c
@@ -128,8 +128,8 @@ static int qstat_show(struct seq_file *m, void *v)
 			   q->u.in.ack_start, q->u.in.ack_count);
 		seq_printf(m, "DSCI: %x   IRQs disabled: %u\n",
 			   *(u8 *)q->irq_ptr->dsci,
-			   test_bit(QDIO_QUEUE_IRQS_DISABLED,
-			   &q->u.in.queue_irq_state));
+			   test_bit(QDIO_IRQ_DISABLED,
+				    &q->irq_ptr->poll_state));
 	}
 	seq_printf(m, "SBAL states:\n");
 	seq_printf(m, "|0      |8      |16     |24     |32     |40     |48     |56  63|\n");
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 3475317c42e5..02ced5949287 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -950,19 +950,14 @@ static void qdio_int_handler_pci(struct qdio_irq *irq_ptr)
 	if (unlikely(irq_ptr->state != QDIO_IRQ_STATE_ACTIVE))
 		return;
 
-	for_each_input_queue(irq_ptr, q, i) {
-		if (q->u.in.queue_start_poll) {
-			/* skip if polling is enabled or already in work */
-			if (test_and_set_bit(QDIO_QUEUE_IRQS_DISABLED,
-				     &q->u.in.queue_irq_state)) {
-				QDIO_PERF_STAT_INC(irq_ptr, int_discarded);
-				continue;
-			}
-			q->u.in.queue_start_poll(q->irq_ptr->cdev, q->nr,
-						 q->irq_ptr->int_parm);
-		} else {
+	if (irq_ptr->irq_poll) {
+		if (!test_and_set_bit(QDIO_IRQ_DISABLED, &irq_ptr->poll_state))
+			irq_ptr->irq_poll(irq_ptr->cdev, irq_ptr->int_parm);
+		else
+			QDIO_PERF_STAT_INC(irq_ptr, int_discarded);
+	} else {
+		for_each_input_queue(irq_ptr, q, i)
 			tasklet_schedule(&q->tasklet);
-		}
 	}
 
 	if (!pci_out_supported(irq_ptr) || !irq_ptr->scan_threshold)
@@ -1610,24 +1605,26 @@ EXPORT_SYMBOL_GPL(do_QDIO);
 /**
  * qdio_start_irq - process input buffers
  * @cdev: associated ccw_device for the qdio subchannel
- * @nr: input queue number
  *
  * Return codes
  *   0 - success
  *   1 - irqs not started since new data is available
  */
-int qdio_start_irq(struct ccw_device *cdev, int nr)
+int qdio_start_irq(struct ccw_device *cdev)
 {
 	struct qdio_q *q;
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
+	unsigned int i;
 
 	if (!irq_ptr)
 		return -ENODEV;
-	q = irq_ptr->input_qs[nr];
 
 	clear_nonshared_ind(irq_ptr);
-	qdio_stop_polling(q);
-	clear_bit(QDIO_QUEUE_IRQS_DISABLED, &q->u.in.queue_irq_state);
+
+	for_each_input_queue(irq_ptr, q, i)
+		qdio_stop_polling(q);
+
+	clear_bit(QDIO_IRQ_DISABLED, &irq_ptr->poll_state);
 
 	/*
 	 * We need to check again to not lose initiative after
@@ -1635,13 +1632,16 @@ int qdio_start_irq(struct ccw_device *cdev, int nr)
 	 */
 	if (test_nonshared_ind(irq_ptr))
 		goto rescan;
-	if (!qdio_inbound_q_done(q, q->first_to_check))
-		goto rescan;
+
+	for_each_input_queue(irq_ptr, q, i) {
+		if (!qdio_inbound_q_done(q, q->first_to_check))
+			goto rescan;
+	}
+
 	return 0;
 
 rescan:
-	if (test_and_set_bit(QDIO_QUEUE_IRQS_DISABLED,
-			     &q->u.in.queue_irq_state))
+	if (test_and_set_bit(QDIO_IRQ_DISABLED, &irq_ptr->poll_state))
 		return 0;
 	else
 		return 1;
@@ -1729,23 +1729,19 @@ EXPORT_SYMBOL(qdio_get_next_buffers);
 /**
  * qdio_stop_irq - disable interrupt processing for the device
  * @cdev: associated ccw_device for the qdio subchannel
- * @nr: input queue number
  *
  * Return codes
  *   0 - interrupts were already disabled
  *   1 - interrupts successfully disabled
  */
-int qdio_stop_irq(struct ccw_device *cdev, int nr)
+int qdio_stop_irq(struct ccw_device *cdev)
 {
-	struct qdio_q *q;
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
 
 	if (!irq_ptr)
 		return -ENODEV;
-	q = irq_ptr->input_qs[nr];
 
-	if (test_and_set_bit(QDIO_QUEUE_IRQS_DISABLED,
-			     &q->u.in.queue_irq_state))
+	if (test_and_set_bit(QDIO_IRQ_DISABLED, &irq_ptr->poll_state))
 		return 0;
 	else
 		return 1;
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index 66e4bdca9d89..7b831bb4e229 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -224,15 +224,6 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 		setup_queues_misc(q, irq_ptr, qdio_init->input_handler, i);
 
 		q->is_input_q = 1;
-		if (qdio_init->queue_start_poll_array &&
-		    qdio_init->queue_start_poll_array[i]) {
-			q->u.in.queue_start_poll =
-				qdio_init->queue_start_poll_array[i];
-			set_bit(QDIO_QUEUE_IRQS_DISABLED,
-				&q->u.in.queue_irq_state);
-		} else {
-			q->u.in.queue_start_poll = NULL;
-		}
 
 		setup_storage_lists(q, irq_ptr, input_sbal_array, i);
 		input_sbal_array += QDIO_MAX_BUFFERS_PER_Q;
@@ -483,6 +474,13 @@ int qdio_setup_irq(struct qdio_initialize *init_data)
 	ccw_device_get_schid(irq_ptr->cdev, &irq_ptr->schid);
 	setup_queues(irq_ptr, init_data);
 
+	if (init_data->irq_poll) {
+		irq_ptr->irq_poll = init_data->irq_poll;
+		set_bit(QDIO_IRQ_DISABLED, &irq_ptr->poll_state);
+	} else {
+		irq_ptr->irq_poll = NULL;
+	}
+
 	setup_qib(irq_ptr, init_data);
 	qdio_setup_thinint(irq_ptr);
 	set_impl_params(irq_ptr, init_data->qib_param_field_format,
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index 7c4e4ec08a12..8f315c53de23 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -135,28 +135,24 @@ static inline void tiqdio_call_inq_handlers(struct qdio_irq *irq)
 	    has_multiple_inq_on_dsci(irq))
 		xchg(irq->dsci, 0);
 
+	if (irq->irq_poll) {
+		if (!test_and_set_bit(QDIO_IRQ_DISABLED, &irq->poll_state))
+			irq->irq_poll(irq->cdev, irq->int_parm);
+		else
+			QDIO_PERF_STAT_INC(irq, int_discarded);
+
+		return;
+	}
+
 	for_each_input_queue(irq, q, i) {
-		if (q->u.in.queue_start_poll) {
-			/* skip if polling is enabled or already in work */
-			if (test_and_set_bit(QDIO_QUEUE_IRQS_DISABLED,
-					     &q->u.in.queue_irq_state)) {
-				QDIO_PERF_STAT_INC(irq, int_discarded);
-				continue;
-			}
-
-			/* avoid dsci clear here, done after processing */
-			q->u.in.queue_start_poll(irq->cdev, q->nr,
-						 irq->int_parm);
-		} else {
-			if (!shared_ind(irq))
-				xchg(irq->dsci, 0);
-
-			/*
-			 * Call inbound processing but not directly
-			 * since that could starve other thinint queues.
-			 */
-			tasklet_schedule(&q->tasklet);
-		}
+		if (!shared_ind(irq))
+			xchg(irq->dsci, 0);
+
+		/*
+		 * Call inbound processing but not directly
+		 * since that could starve other thinint queues.
+		 */
+		tasklet_schedule(&q->tasklet);
 	}
 }
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index dd9bee620f46..07b2231f028f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -548,14 +548,6 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	qdio_release_aob(aob);
 }
 
-static inline int qeth_is_cq(struct qeth_card *card, unsigned int queue)
-{
-	return card->options.cq == QETH_CQ_ENABLED &&
-	    card->qdio.c_q != NULL &&
-	    queue != 0 &&
-	    queue == card->qdio.no_in_queues - 1;
-}
-
 static void qeth_setup_ccw(struct ccw1 *ccw, u8 cmd_code, u8 flags, u32 len,
 			   void *data)
 {
@@ -3469,8 +3461,7 @@ static void qeth_check_outbound_queue(struct qeth_qdio_out_q *queue)
 	}
 }
 
-static void qeth_qdio_start_poll(struct ccw_device *ccwdev, int queue,
-				 unsigned long card_ptr)
+static void qeth_qdio_poll(struct ccw_device *cdev, unsigned long card_ptr)
 {
 	struct qeth_card *card = (struct qeth_card *)card_ptr;
 
@@ -3508,9 +3499,6 @@ static void qeth_qdio_cq_handler(struct qeth_card *card, unsigned int qdio_err,
 	int i;
 	int rc;
 
-	if (!qeth_is_cq(card, queue))
-		return;
-
 	QETH_CARD_TEXT_(card, 5, "qcqhe%d", first_element);
 	QETH_CARD_TEXT_(card, 5, "qcqhc%d", count);
 	QETH_CARD_TEXT_(card, 5, "qcqherr%d", qdio_err);
@@ -3556,9 +3544,7 @@ static void qeth_qdio_input_handler(struct ccw_device *ccwdev,
 	QETH_CARD_TEXT_(card, 2, "qihq%d", queue);
 	QETH_CARD_TEXT_(card, 2, "qiec%d", qdio_err);
 
-	if (qeth_is_cq(card, queue))
-		qeth_qdio_cq_handler(card, qdio_err, queue, first_elem, count);
-	else if (qdio_err)
+	if (qdio_err)
 		qeth_schedule_recovery(card);
 }
 
@@ -4805,10 +4791,7 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 }
 
 static void qeth_qdio_establish_cq(struct qeth_card *card,
-				   struct qdio_buffer **in_sbal_ptrs,
-				   void (**queue_start_poll)
-					(struct ccw_device *, int,
-					 unsigned long))
+				   struct qdio_buffer **in_sbal_ptrs)
 {
 	int i;
 
@@ -4819,8 +4802,6 @@ static void qeth_qdio_establish_cq(struct qeth_card *card,
 		for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++)
 			in_sbal_ptrs[offset + i] =
 				card->qdio.c_q->bufs[i].buffer;
-
-		queue_start_poll[card->qdio.no_in_queues - 1] = NULL;
 	}
 }
 
@@ -4829,7 +4810,6 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	struct qdio_initialize init_data;
 	char *qib_param_field;
 	struct qdio_buffer **in_sbal_ptrs;
-	void (**queue_start_poll) (struct ccw_device *, int, unsigned long);
 	struct qdio_buffer **out_sbal_ptrs;
 	int i, j, k;
 	int rc = 0;
@@ -4856,16 +4836,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++)
 		in_sbal_ptrs[i] = card->qdio.in_q->bufs[i].buffer;
 
-	queue_start_poll = kcalloc(card->qdio.no_in_queues, sizeof(void *),
-				   GFP_KERNEL);
-	if (!queue_start_poll) {
-		rc = -ENOMEM;
-		goto out_free_in_sbals;
-	}
-	for (i = 0; i < card->qdio.no_in_queues; ++i)
-		queue_start_poll[i] = qeth_qdio_start_poll;
-
-	qeth_qdio_establish_cq(card, in_sbal_ptrs, queue_start_poll);
+	qeth_qdio_establish_cq(card, in_sbal_ptrs);
 
 	out_sbal_ptrs =
 		kcalloc(card->qdio.no_out_queues * QDIO_MAX_BUFFERS_PER_Q,
@@ -4873,7 +4844,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 			GFP_KERNEL);
 	if (!out_sbal_ptrs) {
 		rc = -ENOMEM;
-		goto out_free_queue_start_poll;
+		goto out_free_in_sbals;
 	}
 
 	for (i = 0, k = 0; i < card->qdio.no_out_queues; ++i)
@@ -4891,7 +4862,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	init_data.no_output_qs           = card->qdio.no_out_queues;
 	init_data.input_handler		 = qeth_qdio_input_handler;
 	init_data.output_handler	 = qeth_qdio_output_handler;
-	init_data.queue_start_poll_array = queue_start_poll;
+	init_data.irq_poll		 = qeth_qdio_poll;
 	init_data.int_parm               = (unsigned long) card;
 	init_data.input_sbal_addr_array  = in_sbal_ptrs;
 	init_data.output_sbal_addr_array = out_sbal_ptrs;
@@ -4924,8 +4895,6 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	}
 out:
 	kfree(out_sbal_ptrs);
-out_free_queue_start_poll:
-	kfree(queue_start_poll);
 out_free_in_sbals:
 	kfree(in_sbal_ptrs);
 out_free_qib_param:
@@ -5581,6 +5550,24 @@ static unsigned int qeth_rx_poll(struct qeth_card *card, int budget)
 	return work_done;
 }
 
+static void qeth_cq_poll(struct qeth_card *card)
+{
+	unsigned int work_done = 0;
+
+	while (work_done < QDIO_MAX_BUFFERS_PER_Q) {
+		unsigned int start, error;
+		int completed;
+
+		completed = qdio_inspect_queue(CARD_DDEV(card), 1, true, &start,
+					       &error);
+		if (completed <= 0)
+			return;
+
+		qeth_qdio_cq_handler(card, error, 1, start, completed);
+		work_done += completed;
+	}
+}
+
 int qeth_poll(struct napi_struct *napi, int budget)
 {
 	struct qeth_card *card = container_of(napi, struct qeth_card, napi);
@@ -5588,12 +5575,15 @@ int qeth_poll(struct napi_struct *napi, int budget)
 
 	work_done = qeth_rx_poll(card, budget);
 
+	if (card->options.cq == QETH_CQ_ENABLED)
+		qeth_cq_poll(card);
+
 	/* Exhausted the RX budget. Keep IRQ disabled, we get called again. */
 	if (budget && work_done >= budget)
 		return work_done;
 
 	if (napi_complete_done(napi, work_done) &&
-	    qdio_start_irq(CARD_DDEV(card), 0))
+	    qdio_start_irq(CARD_DDEV(card)))
 		napi_schedule(napi);
 
 	return work_done;
@@ -6756,7 +6746,7 @@ int qeth_stop(struct net_device *dev)
 	}
 
 	napi_disable(&card->napi);
-	qdio_stop_irq(CARD_DDEV(card), 0);
+	qdio_stop_irq(CARD_DDEV(card));
 
 	return 0;
 }
-- 
2.17.1

