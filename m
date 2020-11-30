Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316A22C81DC
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgK3KKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:10:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728577AbgK3KKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:10:48 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA1lAw168219;
        Mon, 30 Nov 2020 05:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=oPHlPeWN+kwwB80gdj1L1jKwnCWCpPsHhppZ74X1bHU=;
 b=ih882dcEOXDpvzZB005mENbspgA74R4w9jNw98owq5+PQETwEVP26ueWQqhKSCvEbxXN
 g8noOqbf9bYBfiPWJgrS5LqzjXrejXN5ESKtNhN8SXIrEmzMQX/xZQYa4Jc9w/u3aMf9
 VgMkgCTLqi96lcqe8JoU46eGViEypj8a6H6YfLys/n4RdaVJemBQs+l89iWNkaeVWg/n
 vudkAJcOyoSXhkVxqLqPGnTTAx59WNqt8PxJsX5ZMg88wJYVMOKyAKQCmerVVinuEqvZ
 80nb0tY/a0r2z/Z+qIwArfduaEs4OBdhNmtumWHpQPjQzOUtdlVkPEGie8abd1AT5Psa Qg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 354v98cccf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 05:09:58 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA7bfx009800;
        Mon, 30 Nov 2020 10:09:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 353e681w3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:09:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUA9stp57475350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 10:09:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5086911C054;
        Mon, 30 Nov 2020 10:09:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BA2D11C04C;
        Mon, 30 Nov 2020 10:09:54 +0000 (GMT)
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
Subject: [PATCH net-next 2/6] s390/ctcm: Avoid temporary allocation of struct qllc.
Date:   Mon, 30 Nov 2020 11:09:46 +0100
Message-Id: <20201130100950.42051-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130100950.42051-1-jwi@linux.ibm.com>
References: <20201130100950.42051-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_02:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 mlxscore=0 suspectscore=2 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The size of struct qllc is 2 byte. The memory for is allocated,
initialized, used and deallocated a few lines later.

It is more efficient to avoid the allocation/free dance and assign the
values directly to skb's data part instead of using memcpy() for it.

Avoid an allocation of struct qllc and use the resulting skb pointer
instead.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
[jwi: remove a newline, reflow the commit msg]
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/ctcm_mpc.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 293d8870968c..8ae49732d1d2 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -2048,7 +2048,6 @@ static void mpc_action_rcvd_xid7(fsm_instance *fsm, int event, void *arg)
  */
 static int mpc_send_qllc_discontact(struct net_device *dev)
 {
-	__u32	new_len	= 0;
 	struct sk_buff   *skb;
 	struct qllc      *qllcptr;
 	struct ctcm_priv *priv = dev->ml_priv;
@@ -2079,31 +2078,19 @@ static int mpc_send_qllc_discontact(struct net_device *dev)
 	case MPCG_STATE_FLOWC:
 	case MPCG_STATE_READY:
 		grp->send_qllc_disc = 2;
-		new_len = sizeof(struct qllc);
-		qllcptr = kzalloc(new_len, gfp_type() | GFP_DMA);
-		if (qllcptr == NULL) {
-			CTCM_DBF_TEXT_(MPC_ERROR, CTC_DBF_ERROR,
-				"%s(%s): qllcptr allocation error",
-						CTCM_FUNTAIL, dev->name);
-			return -ENOMEM;
-		}
-
-		qllcptr->qllc_address = 0xcc;
-		qllcptr->qllc_commands = 0x03;
-
-		skb = __dev_alloc_skb(new_len, GFP_ATOMIC);
 
+		skb = __dev_alloc_skb(sizeof(struct qllc), GFP_ATOMIC);
 		if (skb == NULL) {
 			CTCM_DBF_TEXT_(MPC_ERROR, CTC_DBF_ERROR,
 				"%s(%s): skb allocation error",
 						CTCM_FUNTAIL, dev->name);
 			priv->stats.rx_dropped++;
-			kfree(qllcptr);
 			return -ENOMEM;
 		}
 
-		skb_put_data(skb, qllcptr, new_len);
-		kfree(qllcptr);
+		qllcptr = skb_put(skb, sizeof(struct qllc));
+		qllcptr->qllc_address = 0xcc;
+		qllcptr->qllc_commands = 0x03;
 
 		if (skb_headroom(skb) < 4) {
 			CTCM_DBF_TEXT_(MPC_ERROR, CTC_DBF_ERROR,
-- 
2.17.1

