Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C092C81D7
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgK3KKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:10:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23486 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728557AbgK3KKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:10:48 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA3ov3096274;
        Mon, 30 Nov 2020 05:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=f0cYuig5M/932Bj4DMnadvEMI3+9RUnKgwIk4L8H+LY=;
 b=Ln3Ydl5aMzUQa5e6HnEKsMeYMKNsCSBi8H96hPvGJ41KkXQHhAKcxcX3ochjPA9O4ZSZ
 cdsrZVfKqaBqJ1799Rtq7ixdouDKz0U68L31Sx8txXsvIBs7ttqytn3ELRLVLRz3mEij
 di0guNvw9GD1U2BwGHXoidFMjZcsHREuopTdP6VuKXqAiGhEGNu3ZIrgcZ6GT/6OrPXg
 cs5TxP6Rw8iSXMeUtmBycuGgAh+h5DomGFvcPAVqr+hHQusyGYn8abATYe5th3Jg+0aO
 dL9UDog8XZLVMkOy3CiDSmHX9QvW3bCbPQ8931uQ/EC7mxMNsYqUBDGTUAHpbeE//bT2 Cg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 354wp49x5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 05:10:00 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA7bg1009800;
        Mon, 30 Nov 2020 10:09:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 353e681w3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:09:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUA9tHl62259508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 10:09:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B424111C058;
        Mon, 30 Nov 2020 10:09:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FA1811C050;
        Mon, 30 Nov 2020 10:09:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 10:09:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 6/6] s390/ctcm: Use GFP_ATOMIC in ctcmpc_tx().
Date:   Mon, 30 Nov 2020 11:09:50 +0100
Message-Id: <20201130100950.42051-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130100950.42051-1-jwi@linux.ibm.com>
References: <20201130100950.42051-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_02:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

gfp_type() uses in_interrupt() to figure out the correct GFP mask.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

ctcmpc_tx() is used as net_device_ops::ndo_start_xmit. This callback is
invoked with disabled bottom halves.

Use GFP_ATOMIC for memory allocation in ctcmpc_tx().
Remove gfp_type() since the last user is gone.

Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/ctcm_main.c | 2 +-
 drivers/s390/net/ctcm_main.h | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index c446883de5c8..fd705429708e 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -903,7 +903,7 @@ static int ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 		CTCM_D3_DUMP((char *)skb->data, min_t(int, 32, skb->len));
 
 		len =  skb->len + TH_HEADER_LENGTH + PDU_HEADER_LENGTH;
-		newskb = __dev_alloc_skb(len, gfp_type() | GFP_DMA);
+		newskb = __dev_alloc_skb(len, GFP_ATOMIC | GFP_DMA);
 
 		if (!newskb) {
 			CTCM_DBF_TEXT_(MPC_TRACE, CTC_DBF_ERROR,
diff --git a/drivers/s390/net/ctcm_main.h b/drivers/s390/net/ctcm_main.h
index 16bdf23ee02b..90bd7b3f80c3 100644
--- a/drivers/s390/net/ctcm_main.h
+++ b/drivers/s390/net/ctcm_main.h
@@ -298,11 +298,6 @@ struct mpc_group *ctcmpc_init_mpc_group(struct ctcm_priv *priv);
 /* test if struct ctcm_priv of struct net_device has MPC protocol setting */
 #define IS_MPCDEV(dev) IS_MPC((struct ctcm_priv *)dev->ml_priv)
 
-static inline gfp_t gfp_type(void)
-{
-	return in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
-}
-
 /*
  * Definition of our link level header.
  */
-- 
2.17.1

