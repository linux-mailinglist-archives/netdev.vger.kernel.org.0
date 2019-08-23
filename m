Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7409ABDE
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404760AbfHWJtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:49:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389227AbfHWJtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 05:49:03 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N9kjlb052536
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:01 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ujcj5k12a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:01 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 23 Aug 2019 10:48:59 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 10:48:57 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7N9mt9u49021094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 09:48:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA32D4204D;
        Fri, 23 Aug 2019 09:48:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 951D04203F;
        Fri, 23 Aug 2019 09:48:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Aug 2019 09:48:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/7] s390/qdio: let drivers opt-out from Output Queue scanning
Date:   Fri, 23 Aug 2019 11:48:48 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190823094853.63814-1-jwi@linux.ibm.com>
References: <20190823094853.63814-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082309-0012-0000-0000-0000034217A0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082309-0013-0000-0000-0000217C45AC
Message-Id: <20190823094853.63814-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=853 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a driver wants to use the new Output Queue poll code, then the qdio
layer must disable its internal Queue scanning. Let the driver select
this mode by passing a special scan_threshold of 0.

As the scan_threshold is the same for all Output Queues, also move it
into the main qdio_irq struct. This allows for fast opt-out checking, a
driver is expected to operate either _all_ or none of its Output Queues
in polling mode.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
---
 arch/s390/include/asm/qdio.h  |  2 +-
 drivers/s390/cio/qdio.h       |  3 +--
 drivers/s390/cio/qdio_main.c  | 11 ++++++++---
 drivers/s390/cio/qdio_setup.c |  2 +-
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index 79b4a3e9dc5d..556d3e703fae 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -359,7 +359,7 @@ struct qdio_initialize {
 	qdio_handler_t *output_handler;
 	void (**queue_start_poll_array) (struct ccw_device *, int,
 					  unsigned long);
-	int scan_threshold;
+	unsigned int scan_threshold;
 	unsigned long int_parm;
 	struct qdio_buffer **input_sbal_addr_array;
 	struct qdio_buffer **output_sbal_addr_array;
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index a06944399865..a58b45df95d7 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -206,8 +206,6 @@ struct qdio_output_q {
 	struct qdio_outbuf_state *sbal_state;
 	/* timer to check for more outbound work */
 	struct timer_list timer;
-	/* used SBALs before tasklet schedule */
-	int scan_threshold;
 };
 
 /*
@@ -295,6 +293,7 @@ struct qdio_irq {
 	struct qdio_ssqd_desc ssqd_desc;
 	void (*orig_handler) (struct ccw_device *, unsigned long, struct irb *);
 
+	unsigned int scan_threshold;	/* used SBALs before tasklet schedule */
 	int perf_stat_enabled;
 
 	struct qdr *qdr;
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 5efba0d29190..5b63c505a2f7 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -880,7 +880,7 @@ static inline void qdio_check_outbound_pci_queues(struct qdio_irq *irq)
 	struct qdio_q *out;
 	int i;
 
-	if (!pci_out_supported(irq))
+	if (!pci_out_supported(irq) || !irq->scan_threshold)
 		return;
 
 	for_each_output_queue(irq, out, i)
@@ -973,7 +973,7 @@ static void qdio_int_handler_pci(struct qdio_irq *irq_ptr)
 		}
 	}
 
-	if (!pci_out_supported(irq_ptr))
+	if (!pci_out_supported(irq_ptr) || !irq_ptr->scan_threshold)
 		return;
 
 	for_each_output_queue(irq_ptr, q, i) {
@@ -1528,6 +1528,7 @@ static int handle_inbound(struct qdio_q *q, unsigned int callflags,
 static int handle_outbound(struct qdio_q *q, unsigned int callflags,
 			   int bufnr, int count)
 {
+	const unsigned int scan_threshold = q->irq_ptr->scan_threshold;
 	unsigned char state = 0;
 	int used, rc = 0;
 
@@ -1566,8 +1567,12 @@ static int handle_outbound(struct qdio_q *q, unsigned int callflags,
 		rc = qdio_kick_outbound_q(q, 0);
 	}
 
+	/* Let drivers implement their own completion scanning: */
+	if (!scan_threshold)
+		return rc;
+
 	/* in case of SIGA errors we must process the error immediately */
-	if (used >= q->u.out.scan_threshold || rc)
+	if (used >= scan_threshold || rc)
 		qdio_tasklet_schedule(q);
 	else
 		/* free the SBALs in case of no further traffic */
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index d4101cecdc8d..f4ca1d29d61b 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -248,7 +248,6 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 		output_sbal_state_array += QDIO_MAX_BUFFERS_PER_Q;
 
 		q->is_input_q = 0;
-		q->u.out.scan_threshold = qdio_init->scan_threshold;
 		setup_storage_lists(q, irq_ptr, output_sbal_array, i);
 		output_sbal_array += QDIO_MAX_BUFFERS_PER_Q;
 
@@ -474,6 +473,7 @@ int qdio_setup_irq(struct qdio_initialize *init_data)
 	irq_ptr->nr_input_qs = init_data->no_input_qs;
 	irq_ptr->nr_output_qs = init_data->no_output_qs;
 	irq_ptr->cdev = init_data->cdev;
+	irq_ptr->scan_threshold = init_data->scan_threshold;
 	ccw_device_get_schid(irq_ptr->cdev, &irq_ptr->schid);
 	setup_queues(irq_ptr, init_data);
 
-- 
2.17.1

