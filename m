Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F4428E59E
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgJNRnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:43:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726903AbgJNRny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 13:43:54 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09EHacm9044171;
        Wed, 14 Oct 2020 13:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jjyulqcpxlMPbqXd6zWSDFg6RCOZJO1mm6tP1lvXPdE=;
 b=ftOheAfOptlfJlia3WKyfYB4hVdTNpKl47E9CTnuaG0m1h9l0mjuj5BdIlragqptCQ9k
 RBWoqJLV/LcrbpOLOknpbUELfTkUzNrRC8SUftfE27XXGVgwZwzpcF3P4f8Vb6x3yDoV
 lNyIICdhOIgtvlTGsPrr71goAMhCSyGlxczPaBFGIH1Wkb2WFWrPwDYhMt+U0GZ+0IU4
 DGs554JSBF4cqyvBO9S5NT3hJlJRBlt18DRqBEYlfOAMGVnaT67k7WdoZ+dOzdnnEdir
 iGsJTL3TcmX4LzfD19y6kQOrAspWhQ5GJYb9RsVhn69GyijzUH0aMS+IwoNXOUrj8EEf rg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3465nq0n00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 13:43:52 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09EHg16G013475;
        Wed, 14 Oct 2020 17:43:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 344558sn4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 17:43:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09EHhll033423830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 17:43:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81C0652050;
        Wed, 14 Oct 2020 17:43:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 394525204F;
        Wed, 14 Oct 2020 17:43:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 3/3] net/smc: fix invalid return code in smcd_new_buf_create()
Date:   Wed, 14 Oct 2020 19:43:29 +0200
Message-Id: <20201014174329.35791-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201014174329.35791-1-kgraul@linux.ibm.com>
References: <20201014174329.35791-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_09:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=1 bulkscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smc_ism_register_dmb() returns error codes set by the ISM driver which
are not guaranteed to be negative or in the errno range. Such values
would not be handled by ERR_PTR() and finally the return code will be
used as a memory address.
Fix that by using a valid negative errno value with ERR_PTR().

Fixes: 72b7f6c48708 ("net/smc: unique reason code for exceeded max dmb count")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 5de637472a11..d790c43c473f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1615,7 +1615,8 @@ static struct smc_buf_desc *smcd_new_buf_create(struct smc_link_group *lgr,
 		rc = smc_ism_register_dmb(lgr, bufsize, buf_desc);
 		if (rc) {
 			kfree(buf_desc);
-			return (rc == -ENOMEM) ? ERR_PTR(-EAGAIN) : ERR_PTR(rc);
+			return (rc == -ENOMEM) ? ERR_PTR(-EAGAIN) :
+						 ERR_PTR(-EIO);
 		}
 		buf_desc->pages = virt_to_page(buf_desc->cpu_addr);
 		/* CDC header stored in buf. So, pretend it was smaller */
-- 
2.17.1

