Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB692C81DA
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgK3KKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:10:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728574AbgK3KKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:10:48 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA1qQJ174279;
        Mon, 30 Nov 2020 05:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=E5KHcOciko7HYUDJ96CY+aopFOeqsvndAgmejfFzM08=;
 b=Bf8/Ut1TMgVnGmpYYVCuMjGL/A0s2lfnuXHR+ZymutPlghFblR4njfpvR9oJIc5lqigK
 w8RYutOb2NfsOOEVEVU01yWN4yVuGJZ8pcU3zy37syAx1CuMVrHn1KNM9a3DFtPAL1rq
 FeyNHF/WjhaVHa/PoJRlrr+kIyJFumXsUwKpVEeU9pp8u/IeokUcDfz58KjxUvjCiaTr
 joZMjl7T4VVBMQcSryqpyBNaaaImnsiVdRIuG9+bV99PbjKBa1YIgK3Y5RUU0E5CF6U2
 /ZTa92t5go2lNPumbFqL1+mNE3e/D4G8P1pUVtspuBO/vyurS+9EEv1bevG/tA5KNYgL vA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 354jntevnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 05:10:00 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA7UQT018197;
        Mon, 30 Nov 2020 10:09:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 353dth8yk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:09:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUA9tid62259502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 10:09:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 635B311C04C;
        Mon, 30 Nov 2020 10:09:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14E2F11C054;
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
Subject: [PATCH net-next 5/6] s390/ctcm: Use GFP_KERNEL in add_channel().
Date:   Mon, 30 Nov 2020 11:09:49 +0100
Message-Id: <20201130100950.42051-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130100950.42051-1-jwi@linux.ibm.com>
References: <20201130100950.42051-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_02:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

gfp_type() uses in_interrupt() to figure out the correct GFP mask.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

The memory allocation of `ch' a few lines above is using GFP_KERNEL,
also an allocation a few lines later is using GFP_KERNEL.

Use GFP_KERNEL for the memory allocation.

Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/ctcm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 92dd3c803d23..c446883de5c8 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1321,7 +1321,7 @@ static int add_channel(struct ccw_device *cdev, enum ctcm_channel_types type,
 
 	ch->protocol = priv->protocol;
 	if (IS_MPC(priv)) {
-		ch->discontact_th = kzalloc(TH_HEADER_LENGTH, gfp_type());
+		ch->discontact_th = kzalloc(TH_HEADER_LENGTH, GFP_KERNEL);
 		if (ch->discontact_th == NULL)
 					goto nomem_return;
 
-- 
2.17.1

