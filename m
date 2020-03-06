Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8462617B825
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 09:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCFINZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 03:13:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725853AbgCFINY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 03:13:24 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02689Iup008395
        for <netdev@vger.kernel.org>; Fri, 6 Mar 2020 03:13:23 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ykd49hhd6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 03:13:23 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 6 Mar 2020 08:13:21 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 08:13:18 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0268DHiA39322104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 08:13:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23051A405F;
        Fri,  6 Mar 2020 08:13:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7EA0A4066;
        Fri,  6 Mar 2020 08:13:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 08:13:16 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>, Qian Cai <cai@lca.pw>
Subject: [PATCH net-next 1/2] s390/qdio: add tighter controls for IRQ polling
Date:   Fri,  6 Mar 2020 09:13:10 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306081311.50635-1-jwi@linux.ibm.com>
References: <20200306081311.50635-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030608-0016-0000-0000-000002EDB2BD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030608-0017-0000-0000-0000335109C0
Message-Id: <20200306081311.50635-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_02:2020-03-05,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=27 phishscore=0
 mlxscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=971 adultscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once the call to qdio_establish() has completed, qdio is free to deliver
data IRQs to the device driver's IRQ poll handler.

For qeth (the only qdio driver that currently uses IRQ polling) this is
problematic, since the IRQs can arrive before its NAPI instance is
even registered. Calling napi_schedule() from qeth_qdio_start_poll()
then crashes in various nasty ways.

Until recently qeth checked for IFF_UP to drop such early interrupts,
but that's fragile as well since it doesn't enforce any ordering.

Fix this properly by bringing up the qdio device in IRQS_DISABLED mode,
and have the driver explicitly opt-in to receive data IRQs.
qeth does so from qeth_open(), which kick-starts a NAPI poll and then
calls qdio_start_irq() from qeth_poll().

Also add a matching qdio_stop_irq() in qeth_stop() to switch the qdio
dataplane back into a disabled state.

Fixes: 3d35dbe6224e ("s390/qeth: don't check for IFF_UP when scheduling napi")
CC: Qian Cai <cai@lca.pw>
Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
---
 drivers/s390/cio/qdio_setup.c     | 11 +++++++++--
 drivers/s390/net/qeth_core_main.c |  5 ++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index e115623b86b2..66e4bdca9d89 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -224,8 +224,15 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 		setup_queues_misc(q, irq_ptr, qdio_init->input_handler, i);
 
 		q->is_input_q = 1;
-		q->u.in.queue_start_poll = qdio_init->queue_start_poll_array ?
-				qdio_init->queue_start_poll_array[i] : NULL;
+		if (qdio_init->queue_start_poll_array &&
+		    qdio_init->queue_start_poll_array[i]) {
+			q->u.in.queue_start_poll =
+				qdio_init->queue_start_poll_array[i];
+			set_bit(QDIO_QUEUE_IRQS_DISABLED,
+				&q->u.in.queue_irq_state);
+		} else {
+			q->u.in.queue_start_poll = NULL;
+		}
 
 		setup_storage_lists(q, irq_ptr, input_sbal_array, i);
 		input_sbal_array += QDIO_MAX_BUFFERS_PER_Q;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index fdc50543ce9a..37c17ad8ee25 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6582,9 +6582,6 @@ int qeth_open(struct net_device *dev)
 
 	QETH_CARD_TEXT(card, 4, "qethopen");
 
-	if (qdio_stop_irq(CARD_DDEV(card), 0) < 0)
-		return -EIO;
-
 	card->data.state = CH_STATE_UP;
 	netif_tx_start_all_queues(dev);
 
@@ -6634,6 +6631,8 @@ int qeth_stop(struct net_device *dev)
 	}
 
 	napi_disable(&card->napi);
+	qdio_stop_irq(CARD_DDEV(card), 0);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_stop);
-- 
2.17.1

