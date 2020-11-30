Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D61F2C81DF
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgK3KKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:10:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728577AbgK3KKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:10:55 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA2foA091955;
        Mon, 30 Nov 2020 05:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=W3Yqk+pfBXrgKNlDkxtI4UiuvSp6l5Hl+gLwHUFcV5M=;
 b=oukcirtcVcJyuV8u+ueK+Sh3QFr1Uqug0Qf0CVO1ywREfrMP7R4VNwEDzacvy/G62Nu6
 i1A6OwCRwQa7KNxAVj14kl3vT30Te4C1odZNswdHG0m8sGLmPUvyt7w6GciAlsqgKtRp
 tfyurqmzxImgt4aq6CYIPLn3OFL2IMmuDEA9iJy76p0xcNvyfK/8zvRtMPBuhwL2WYXz
 9+DeznIkFNxV2CN2jgL9qxBvGmobbUHvb6E9fYTa7fFbNxPKctYmbZwzdQy1HSOhA0US
 qoIdVrgaLwidIr2z2sPKiUyJuBe4U2tGTqDyOWKtPxCCrm1HiWz+815a0/qPpSFtYqSP rg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 354xkv89rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 05:09:59 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA7tXL013757;
        Mon, 30 Nov 2020 10:09:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpd8mvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:09:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUA9sAO41484660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 10:09:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A206A11C054;
        Mon, 30 Nov 2020 10:09:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D05911C058;
        Mon, 30 Nov 2020 10:09:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 10:09:54 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 3/6] s390/ctcm: Avoid temporary allocation of struct pdu.
Date:   Mon, 30 Nov 2020 11:09:47 +0100
Message-Id: <20201130100950.42051-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130100950.42051-1-jwi@linux.ibm.com>
References: <20201130100950.42051-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_02:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=999
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The size of struct pdu is 8 byte. The memory is allocated, initialized,
used and deallocated a few lines later.

It is more efficient to avoid the allocation/free dance and assign the
values directly to skb's data part instead of using memcpy() for it.

Avoid an allocation of struct pdu and use the resulting skb pointer
instead.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
[jwi: Fix-up the pdu_offset, adjust skb->len for the pushed length.
      Reflow the commit msg.]
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/ctcm_main.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 9e28c63415ed..92dd3c803d23 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -665,24 +665,16 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 	if ((fsm_getstate(ch->fsm) != CTC_STATE_TXIDLE) || grp->in_sweep) {
 		spin_lock_irqsave(&ch->collect_lock, saveflags);
 		refcount_inc(&skb->users);
-		p_header = kmalloc(PDU_HEADER_LENGTH, gfp_type());
 
-		if (!p_header) {
-			spin_unlock_irqrestore(&ch->collect_lock, saveflags);
-				goto nomem_exit;
-		}
-
-		p_header->pdu_offset = skb->len;
+		p_header = skb_push(skb, PDU_HEADER_LENGTH);
+		p_header->pdu_offset = skb->len - PDU_HEADER_LENGTH;
 		p_header->pdu_proto = 0x01;
-		p_header->pdu_flag = 0x00;
 		if (be16_to_cpu(skb->protocol) == ETH_P_SNAP) {
-			p_header->pdu_flag |= PDU_FIRST | PDU_CNTL;
+			p_header->pdu_flag = PDU_FIRST | PDU_CNTL;
 		} else {
-			p_header->pdu_flag |= PDU_FIRST;
+			p_header->pdu_flag = PDU_FIRST;
 		}
 		p_header->pdu_seq = 0;
-		memcpy(skb_push(skb, PDU_HEADER_LENGTH), p_header,
-		       PDU_HEADER_LENGTH);
 
 		CTCM_PR_DEBUG("%s(%s): Put on collect_q - skb len: %04x \n"
 				"pdu header and data for up to 32 bytes:\n",
@@ -691,7 +683,6 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 
 		skb_queue_tail(&ch->collect_queue, skb);
 		ch->collect_len += skb->len;
-		kfree(p_header);
 
 		spin_unlock_irqrestore(&ch->collect_lock, saveflags);
 			goto done;
@@ -721,23 +712,15 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 		}
 	}
 
-	p_header = kmalloc(PDU_HEADER_LENGTH, gfp_type());
-
-	if (!p_header)
-		goto nomem_exit;
-
-	p_header->pdu_offset = skb->len;
+	p_header = skb_push(skb, PDU_HEADER_LENGTH);
+	p_header->pdu_offset = skb->len - PDU_HEADER_LENGTH;
 	p_header->pdu_proto = 0x01;
-	p_header->pdu_flag = 0x00;
 	p_header->pdu_seq = 0;
 	if (be16_to_cpu(skb->protocol) == ETH_P_SNAP) {
-		p_header->pdu_flag |= PDU_FIRST | PDU_CNTL;
+		p_header->pdu_flag = PDU_FIRST | PDU_CNTL;
 	} else {
-		p_header->pdu_flag |= PDU_FIRST;
+		p_header->pdu_flag = PDU_FIRST;
 	}
-	memcpy(skb_push(skb, PDU_HEADER_LENGTH), p_header, PDU_HEADER_LENGTH);
-
-	kfree(p_header);
 
 	if (ch->collect_len > 0) {
 		spin_lock_irqsave(&ch->collect_lock, saveflags);
-- 
2.17.1

