Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718AC2C81E1
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgK3KK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:10:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729065AbgK3KKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:10:55 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA4Drq185690;
        Mon, 30 Nov 2020 05:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Cvo6N9HgZXq8P8WB8cCNgaGAGjQzUeJSiLL6K3eLgu4=;
 b=hJbFBvbhS1GCEI+6XSZyVWtaqAYkAJlVebMSRsaB1njX6LUbnXKjZpz1gRLmRcBbPNsY
 4i1i0ptnAhFfzlA8utDcZRLp5Tu3v3fV2J3q9RINw/XFpyHIbZ5g8DzVIgz2q5kaV49v
 cqSoJ0eCWHrGGFRb2d9Z6GmkYOLn6Cwu1nicD/NoP17WRhOf2n7eBsQIZgzhsLCOYcOx
 mpjZ3UhCDcVWKMweqO2OVOlBxgI58rQu9lGD1GN54UazaBG5P3u3XWilygiPtX4rKetX
 p/vPpHy/PEKJMDkR40XnfW6Weto084vRzieJLpSAkGCJXOgef86CFvnXPFVeYgn1dW2S 1Q== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 354x1as31a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 05:10:00 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA8lLE018399;
        Mon, 30 Nov 2020 10:09:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 353e682tt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:09:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUA9sZx9372160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 10:09:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F33FD11C04A;
        Mon, 30 Nov 2020 10:09:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADE0011C050;
        Mon, 30 Nov 2020 10:09:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 10:09:53 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 1/6] s390/ctcm: Avoid temporary allocation of struct th_header and th_sweep.
Date:   Mon, 30 Nov 2020 11:09:45 +0100
Message-Id: <20201130100950.42051-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130100950.42051-1-jwi@linux.ibm.com>
References: <20201130100950.42051-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_02:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 suspectscore=2 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The size of struct th_header is 8 byte and the size of struct th_sweep
is 16 byte. The memory for is allocated, initialized, used and
deallocated a few lines later.

It is more efficient to avoid the allocation/free dance and assign the
values directly to skb's data part instead of using memcpy() for it.

Avoid an allocation of struct th_sweep/th_header and use the resulting
skb pointer instead.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
[jwi: use skb_put_zero(), instead of skb_put() + memset to 0]
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/ctcm_fsms.c | 15 ++++-----------
 drivers/s390/net/ctcm_main.c | 31 ++++---------------------------
 drivers/s390/net/ctcm_mpc.c  | 16 +---------------
 3 files changed, 9 insertions(+), 53 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index 661d2a49bce9..b341075397d9 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -1303,12 +1303,10 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 	/* p_header points to the last one we handled */
 	if (p_header)
 		p_header->pdu_flag |= PDU_LAST;	/*Say it's the last one*/
-	header = kzalloc(TH_HEADER_LENGTH, gfp_type());
-	if (!header) {
-		spin_unlock(&ch->collect_lock);
-		fsm_event(priv->mpcg->fsm, MPCG_EVENT_INOP, dev);
-				goto done;
-	}
+
+	header = skb_push(ch->trans_skb, TH_HEADER_LENGTH);
+	memset(header, 0, TH_HEADER_LENGTH);
+
 	header->th_ch_flag = TH_HAS_PDU;  /* Normal data */
 	ch->th_seq_num++;
 	header->th_seq_num = ch->th_seq_num;
@@ -1316,11 +1314,6 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 	CTCM_PR_DBGDATA("%s: ToVTAM_th_seq= %08x\n" ,
 					__func__, ch->th_seq_num);
 
-	memcpy(skb_push(ch->trans_skb, TH_HEADER_LENGTH), header,
-		TH_HEADER_LENGTH);	/* put the TH on the packet */
-
-	kfree(header);
-
 	CTCM_PR_DBGDATA("%s: trans_skb len:%04x \n",
 		       __func__, ch->trans_skb->len);
 	CTCM_PR_DBGDATA("%s: up-to-50 bytes of trans_skb "
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index d06809eac16d..9e28c63415ed 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -623,25 +623,10 @@ static void ctcmpc_send_sweep_req(struct channel *rch)
 				goto nomem;
 	}
 
-	header = kmalloc(TH_SWEEP_LENGTH, gfp_type());
-
-	if (!header) {
-		dev_kfree_skb_any(sweep_skb);
-		/* rc = -ENOMEM; */
-				goto nomem;
-	}
-
-	header->th.th_seg	= 0x00 ;
+	header = skb_put_zero(sweep_skb, TH_SWEEP_LENGTH);
 	header->th.th_ch_flag	= TH_SWEEP_REQ;  /* 0x0f */
-	header->th.th_blk_flag	= 0x00;
-	header->th.th_is_xid	= 0x00;
-	header->th.th_seq_num	= 0x00;
 	header->sw.th_last_seq	= ch->th_seq_num;
 
-	skb_put_data(sweep_skb, header, TH_SWEEP_LENGTH);
-
-	kfree(header);
-
 	netif_trans_update(dev);
 	skb_queue_tail(&ch->sweep_queue, sweep_skb);
 
@@ -768,25 +753,17 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 
 	ch->prof.txlen += skb->len - PDU_HEADER_LENGTH;
 
-	header = kmalloc(TH_HEADER_LENGTH, gfp_type());
-	if (!header)
-		goto nomem_exit;
+	/* put the TH on the packet */
+	header = skb_push(skb, TH_HEADER_LENGTH);
+	memset(header, 0, TH_HEADER_LENGTH);
 
-	header->th_seg = 0x00;
 	header->th_ch_flag = TH_HAS_PDU;  /* Normal data */
-	header->th_blk_flag = 0x00;
-	header->th_is_xid = 0x00;          /* Just data here */
 	ch->th_seq_num++;
 	header->th_seq_num = ch->th_seq_num;
 
 	CTCM_PR_DBGDATA("%s(%s) ToVTAM_th_seq= %08x\n" ,
 		       __func__, dev->name, ch->th_seq_num);
 
-	/* put the TH on the packet */
-	memcpy(skb_push(skb, TH_HEADER_LENGTH), header, TH_HEADER_LENGTH);
-
-	kfree(header);
-
 	CTCM_PR_DBGDATA("%s(%s): skb len: %04x\n - pdu header and data for "
 			"up to 32 bytes sent to vtam:\n",
 				__func__, dev->name, skb->len);
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 85a1a4533cbe..293d8870968c 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -655,24 +655,10 @@ static void ctcmpc_send_sweep_resp(struct channel *rch)
 		goto done;
 	}
 
-	header = kmalloc(sizeof(struct th_sweep), gfp_type());
-
-	if (!header) {
-		dev_kfree_skb_any(sweep_skb);
-		goto done;
-	}
-
-	header->th.th_seg	= 0x00 ;
+	header = skb_put_zero(sweep_skb, TH_SWEEP_LENGTH);
 	header->th.th_ch_flag	= TH_SWEEP_RESP;
-	header->th.th_blk_flag	= 0x00;
-	header->th.th_is_xid	= 0x00;
-	header->th.th_seq_num	= 0x00;
 	header->sw.th_last_seq	= ch->th_seq_num;
 
-	skb_put_data(sweep_skb, header, TH_SWEEP_LENGTH);
-
-	kfree(header);
-
 	netif_trans_update(dev);
 	skb_queue_tail(&ch->sweep_queue, sweep_skb);
 
-- 
2.17.1

