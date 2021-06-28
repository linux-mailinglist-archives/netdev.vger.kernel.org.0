Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516893B68AB
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 20:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhF1Ssn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Jun 2021 14:48:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51084 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232350AbhF1Ssn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 14:48:43 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15SIZiZB030447
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 11:46:17 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39ekwd8hcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 11:46:17 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 11:46:15 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id AAFA9CE63C65; Mon, 28 Jun 2021 11:46:11 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Date:   Mon, 28 Jun 2021 11:46:11 -0700
Message-ID: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: RVAVkrEEfrUmDXEW4PRxV6xkSNDzkuE9
X-Proofpoint-ORIG-GUID: RVAVkrEEfrUmDXEW4PRxV6xkSNDzkuE9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=915 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106280122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This event differs from CLOCK_EXTTS in two ways:

 1) The caller provides the sec/nsec fields directly, instead of
    needing to convert them from the timestamp field.

 2) A 32 bit data field is attached to the event, which is returned
    to userspace, which allows returning timestamped data information.
    This may be used for things like returning the phase difference
    between two time sources.

For discussion:

The data field is returned as rsv[0], which is part of the current UAPI.
Arguably, this should be renamed, and possibly a flag value set in the
'struct ptp_extts_event' indicating field validity.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_clock.c          | 27 +++++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 841d8900504d..c176fa82df85 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -63,6 +63,28 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
+static void enqueue_external_usr_timestamp(struct timestamp_event_queue *queue,
+					   struct ptp_clock_event *src)
+{
+	struct ptp_extts_event *dst;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->lock, flags);
+
+	dst = &queue->buf[queue->tail];
+	dst->index = src->index;
+	dst->t.sec = src->pps_times.ts_real.tv_sec;
+	dst->t.nsec = src->pps_times.ts_real.tv_nsec;
+	dst->rsv[0] = src->data;
+
+	if (!queue_free(queue))
+		queue->head = (queue->head + 1) % PTP_MAX_TIMESTAMPS;
+
+	queue->tail = (queue->tail + 1) % PTP_MAX_TIMESTAMPS;
+
+	spin_unlock_irqrestore(&queue->lock, flags);
+}
+
 /* posix clock implementation */
 
 static int ptp_clock_getres(struct posix_clock *pc, struct timespec64 *tp)
@@ -311,6 +333,11 @@ void ptp_clock_event(struct ptp_clock *ptp, struct ptp_clock_event *event)
 		wake_up_interruptible(&ptp->tsev_wq);
 		break;
 
+	case PTP_CLOCK_EXTTSUSR:
+		enqueue_external_usr_timestamp(&ptp->tsevq, event);
+		wake_up_interruptible(&ptp->tsev_wq);
+		break;
+
 	case PTP_CLOCK_PPS:
 		pps_get_ts(&evt);
 		pps_event(ptp->pps_source, &evt, PTP_PPS_EVENT, NULL);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index aba237c0b3a2..ef1aa788350e 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -166,6 +166,7 @@ enum ptp_clock_events {
 	PTP_CLOCK_EXTTS,
 	PTP_CLOCK_PPS,
 	PTP_CLOCK_PPSUSR,
+	PTP_CLOCK_EXTTSUSR,
 };
 
 /**
@@ -175,6 +176,7 @@ enum ptp_clock_events {
  * @index: Identifies the source of the event.
  * @timestamp: When the event occurred (%PTP_CLOCK_EXTTS only).
  * @pps_times: When the event occurred (%PTP_CLOCK_PPSUSR only).
+ * @data: Extra data for event (%PTP_CLOCK_EXTTSUSR only).
  */
 
 struct ptp_clock_event {
@@ -184,6 +186,7 @@ struct ptp_clock_event {
 		u64 timestamp;
 		struct pps_event_time pps_times;
 	};
+	unsigned int data;
 };
 
 /**
-- 
2.30.2

