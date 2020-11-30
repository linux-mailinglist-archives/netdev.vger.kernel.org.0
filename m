Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC372C81E2
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgK3KK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:10:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729024AbgK3KKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:10:55 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA2ZLH059654;
        Mon, 30 Nov 2020 05:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=3ZuFda0CcINQ/OvRog8OXaklKCPaxgdL2PGqrMylxOo=;
 b=ij/ofBcpSzqRPivyac8i8aD5WFyvYqq+/dpWezYFlvu3Hkh7awdfn2teFCcgvNX2Fxt4
 8zj9fx+l+l6BKEqcT4AjlVGHfpyYM0ZfvOQ5z5nfhYFQMYtIZa4g/abWNo8ePHI8WIH+
 Kf0zGKymDaV7/j5fm8ZIRqn1aLtkseOMfNO6MN5vUwzc+b0XXdHysFMD7TwAg0Z1QAv9
 H+/KWh/0jX2DCwTAMNQSW6idQiL62I785NoucY1cgHYk2CAPI+Pjd/PEIHEi/ifTANCo
 v+QPoAHss1dKJc5WMqmr7HaJsGzRY1bB8dyRCEzA3J1vuGTjDhmde50Q+v6xVNuNApce IA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 354xe2ghn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 05:10:00 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA7bg0009800;
        Mon, 30 Nov 2020 10:09:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 353e681w3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:09:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUA9tPR3736144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 10:09:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0883111C04C;
        Mon, 30 Nov 2020 10:09:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE33B11C05C;
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
Subject: [PATCH net-next 4/6] s390/ctcm: Use explicit allocation mask in ctcmpc_unpack_skb().
Date:   Mon, 30 Nov 2020 11:09:48 +0100
Message-Id: <20201130100950.42051-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130100950.42051-1-jwi@linux.ibm.com>
References: <20201130100950.42051-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_02:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

The call chain of ctcmpc_unpack_skb():
ctcmpc_bh()
 -> ctcmpc_unpack_skb()

ctcmpc_bh() is a tasklet handler so GFP_ATOMIC is needed.

Use GFP_ATOMIC as allocation type in ctcmpc_unpack_skb().

Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/ctcm_mpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 8ae49732d1d2..19ee91acb89d 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -1163,7 +1163,7 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 			skb_pull(pskb, new_len); /* point to next PDU */
 		}
 	} else {
-		mpcginfo = kmalloc(sizeof(struct mpcg_info), gfp_type());
+		mpcginfo = kmalloc(sizeof(struct mpcg_info), GFP_ATOMIC);
 		if (mpcginfo == NULL)
 					goto done;
 
-- 
2.17.1

