Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBBF2804BF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbgJARLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:11:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24450 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732609AbgJARLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:11:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H4QTh164103;
        Thu, 1 Oct 2020 13:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=I2HwpNbU0h4cP2rBJCFmlN3QBFLkzOeD1/X6xuUPmXk=;
 b=G2aPRTMzTA6dwrwi2ppbjzdsaVaNyrZ7lfxTBFUGOJz5NAvq5FyJGGDcPYcxqUnBsU//
 V0cEs0NvCQ9bMUFveum/vxKyAksDhMqfMx469zCrcsslqAT9lcoj+Tjr7+tTaqZb/uLW
 65iqa0NJ8vKdCp6Pf5bWA78oS56+umMdQBaAij5E3vZrqpyKtApAumSDywQmLRt9NUoV
 W6gpZXytYJhpusd29vfzqQuwQg7WmI/iK5KDiEpmZbyY7T8xdCgb07NRVJDXWgPDUk4C
 fu15itT+9y2JO4flq0rMTcTvKw32qkuS6o7qO/oaHx8A/MqSDoFIIUICpskwCN4saj3w hw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33wh4andfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:11:47 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H2jGe015175;
        Thu, 1 Oct 2020 17:11:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 33wgcu02wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:11:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HBg6f22282542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:11:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A60B8A4040;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66044A4051;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/7] s390/qeth: de-magic the QIB parm area
Date:   Thu,  1 Oct 2020 19:11:31 +0200
Message-Id: <20201001171136.46830-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001171136.46830-1-jwi@linux.ibm.com>
References: <20201001171136.46830-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_06:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 suspectscore=2 bulkscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a proper struct, and only program the QIB extensions for devices
where they are supported.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 11 ++++++
 drivers/s390/net/qeth_core_main.c | 65 ++++++++++++++-----------------
 2 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f1c9a694873e..1e1e7104dade 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -278,6 +278,17 @@ struct qeth_hdr {
 	} hdr;
 } __attribute__ ((packed));
 
+struct qeth_qib_parms {
+	char pcit_magic[4];
+	u32 pcit_a;
+	u32 pcit_b;
+	u32 pcit_c;
+	char blkt_magic[4];
+	u32 blkt_total;
+	u32 blkt_inter_packet;
+	u32 blkt_inter_packet_jumbo;
+};
+
 /*TCP Segmentation Offload header*/
 struct qeth_hdr_ext_tso {
 	__u16 hdr_tot_len;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b61078b27562..81f02a70680e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2743,30 +2743,26 @@ static void qeth_free_qdio_queues(struct qeth_card *card)
 	}
 }
 
-static void qeth_create_qib_param_field(struct qeth_card *card,
-		char *param_field)
-{
-
-	param_field[0] = _ascebc['P'];
-	param_field[1] = _ascebc['C'];
-	param_field[2] = _ascebc['I'];
-	param_field[3] = _ascebc['T'];
-	*((unsigned int *) (&param_field[4])) = QETH_PCI_THRESHOLD_A(card);
-	*((unsigned int *) (&param_field[8])) = QETH_PCI_THRESHOLD_B(card);
-	*((unsigned int *) (&param_field[12])) = QETH_PCI_TIMER_VALUE(card);
-}
-
-static void qeth_create_qib_param_field_blkt(struct qeth_card *card,
-		char *param_field)
-{
-	param_field[16] = _ascebc['B'];
-	param_field[17] = _ascebc['L'];
-	param_field[18] = _ascebc['K'];
-	param_field[19] = _ascebc['T'];
-	*((unsigned int *) (&param_field[20])) = card->info.blkt.time_total;
-	*((unsigned int *) (&param_field[24])) = card->info.blkt.inter_packet;
-	*((unsigned int *) (&param_field[28])) =
-		card->info.blkt.inter_packet_jumbo;
+static void qeth_fill_qib_parms(struct qeth_card *card,
+				struct qeth_qib_parms *parms)
+{
+	parms->pcit_magic[0] = 'P';
+	parms->pcit_magic[1] = 'C';
+	parms->pcit_magic[2] = 'I';
+	parms->pcit_magic[3] = 'T';
+	ASCEBC(parms->pcit_magic, sizeof(parms->pcit_magic));
+	parms->pcit_a = QETH_PCI_THRESHOLD_A(card);
+	parms->pcit_b = QETH_PCI_THRESHOLD_B(card);
+	parms->pcit_c = QETH_PCI_TIMER_VALUE(card);
+
+	parms->blkt_magic[0] = 'B';
+	parms->blkt_magic[1] = 'L';
+	parms->blkt_magic[2] = 'K';
+	parms->blkt_magic[3] = 'T';
+	ASCEBC(parms->blkt_magic, sizeof(parms->blkt_magic));
+	parms->blkt_total = card->info.blkt.time_total;
+	parms->blkt_inter_packet = card->info.blkt.inter_packet;
+	parms->blkt_inter_packet_jumbo = card->info.blkt.inter_packet_jumbo;
 }
 
 static int qeth_qdio_activate(struct qeth_card *card)
@@ -5022,21 +5018,20 @@ static int qeth_qdio_establish(struct qeth_card *card)
 {
 	struct qdio_buffer **out_sbal_ptrs[QETH_MAX_OUT_QUEUES];
 	struct qdio_buffer **in_sbal_ptrs[QETH_MAX_IN_QUEUES];
+	struct qeth_qib_parms *qib_parms = NULL;
 	struct qdio_initialize init_data;
-	char *qib_param_field;
 	unsigned int i;
 	int rc = 0;
 
 	QETH_CARD_TEXT(card, 2, "qdioest");
 
-	qib_param_field = kzalloc(sizeof_field(struct qib, parm), GFP_KERNEL);
-	if (!qib_param_field) {
-		rc =  -ENOMEM;
-		goto out_free_nothing;
-	}
+	if (!IS_IQD(card) && !IS_VM_NIC(card)) {
+		qib_parms = kzalloc(sizeof_field(struct qib, parm), GFP_KERNEL);
+		if (!qib_parms)
+			return -ENOMEM;
 
-	qeth_create_qib_param_field(card, qib_param_field);
-	qeth_create_qib_param_field_blkt(card, qib_param_field);
+		qeth_fill_qib_parms(card, qib_parms);
+	}
 
 	in_sbal_ptrs[0] = card->qdio.in_q->qdio_bufs;
 	if (card->options.cq == QETH_CQ_ENABLED)
@@ -5049,7 +5044,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	init_data.q_format		 = IS_IQD(card) ? QDIO_IQDIO_QFMT :
 							  QDIO_QETH_QFMT;
 	init_data.qib_param_field_format = 0;
-	init_data.qib_param_field        = qib_param_field;
+	init_data.qib_param_field	 = (void *)qib_parms;
 	init_data.no_input_qs            = card->qdio.no_in_queues;
 	init_data.no_output_qs           = card->qdio.no_out_queues;
 	init_data.input_handler		 = qeth_qdio_input_handler;
@@ -5086,9 +5081,9 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	default:
 		break;
 	}
+
 out:
-	kfree(qib_param_field);
-out_free_nothing:
+	kfree(qib_parms);
 	return rc;
 }
 
-- 
2.17.1

