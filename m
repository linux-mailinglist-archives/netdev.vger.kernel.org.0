Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD0B1BFAFF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgD3N5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:57:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbgD3N4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:11 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDactG060540;
        Thu, 30 Apr 2020 09:56:10 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhr9d135-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:09 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmR2D031741;
        Thu, 30 Apr 2020 13:56:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu72qdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu4lY58327546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D2084C050;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45DBB4C044;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 02/14] net/smc: enqueue all received LLC messages
Date:   Thu, 30 Apr 2020 15:55:39 +0200
Message-Id: <20200430135551.26267-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=1 clxscore=1015
 priorityscore=1501 adultscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce smc_llc_enqueue() to enqueue LLC messages, and adapt
smc_llc_rx_handler() to enqueue all received LLC messages.
smc_llc_enqueue() also makes it possible to enqueue LLC messages from
local code.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 647cf1a2dfa5..a146b3b43580 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -719,11 +719,14 @@ static void smc_llc_event_work(struct work_struct *work)
 }
 
 /* process llc responses in tasklet context */
-static void smc_llc_rx_response(struct smc_link *link, union smc_llc_msg *llc)
+static void smc_llc_rx_response(struct smc_link *link,
+				struct smc_llc_qentry *qentry)
 {
+	u8 llc_type = qentry->msg.raw.hdr.common.type;
+	union smc_llc_msg *llc = &qentry->msg;
 	int rc = 0;
 
-	switch (llc->raw.hdr.common.type) {
+	switch (llc_type) {
 	case SMC_LLC_TEST_LINK:
 		if (link->state == SMC_LNK_ACTIVE)
 			complete(&link->llc_testlink_resp);
@@ -759,40 +762,49 @@ static void smc_llc_rx_response(struct smc_link *link, union smc_llc_msg *llc)
 		complete(&link->llc_delete_rkey_resp);
 		break;
 	}
+	kfree(qentry);
 }
 
-/* copy received msg and add it to the event queue */
-static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
+static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc)
 {
-	struct smc_link *link = (struct smc_link *)wc->qp->qp_context;
 	struct smc_link_group *lgr = link->lgr;
 	struct smc_llc_qentry *qentry;
-	union smc_llc_msg *llc = buf;
 	unsigned long flags;
 
-	if (wc->byte_len < sizeof(*llc))
-		return; /* short message */
-	if (llc->raw.hdr.length != sizeof(*llc))
-		return; /* invalid message */
-
-	/* process responses immediately */
-	if (llc->raw.hdr.flags & SMC_LLC_FLAG_RESP) {
-		smc_llc_rx_response(link, llc);
-		return;
-	}
-
 	qentry = kmalloc(sizeof(*qentry), GFP_ATOMIC);
 	if (!qentry)
 		return;
 	qentry->link = link;
 	INIT_LIST_HEAD(&qentry->list);
 	memcpy(&qentry->msg, llc, sizeof(union smc_llc_msg));
+
+	/* process responses immediately */
+	if (llc->raw.hdr.flags & SMC_LLC_FLAG_RESP) {
+		smc_llc_rx_response(link, qentry);
+		return;
+	}
+
+	/* add requests to event queue */
 	spin_lock_irqsave(&lgr->llc_event_q_lock, flags);
 	list_add_tail(&qentry->list, &lgr->llc_event_q);
 	spin_unlock_irqrestore(&lgr->llc_event_q_lock, flags);
 	schedule_work(&link->lgr->llc_event_work);
 }
 
+/* copy received msg and add it to the event queue */
+static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
+{
+	struct smc_link *link = (struct smc_link *)wc->qp->qp_context;
+	union smc_llc_msg *llc = buf;
+
+	if (wc->byte_len < sizeof(*llc))
+		return; /* short message */
+	if (llc->raw.hdr.length != sizeof(*llc))
+		return; /* invalid message */
+
+	smc_llc_enqueue(link, llc);
+}
+
 /***************************** worker, utils *********************************/
 
 static void smc_llc_testlink_work(struct work_struct *work)
-- 
2.17.1

