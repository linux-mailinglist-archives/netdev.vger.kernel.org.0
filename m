Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22508297740
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755083AbgJWSsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:48:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755062AbgJWSso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:48:44 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09NIW7Ic052230;
        Fri, 23 Oct 2020 14:48:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=/fR2pi5iOmtYVan3LweHlLGvsE1w4rDUJjymvZiokSU=;
 b=sA8pGYQIZo7ctWF2tNrEd+5pZqpOIGEw+FDs2hsSqT7vVT385Znf8jH0WSiWWABjE9mG
 Un7b7lS67DXuxMGSBhkMo6kbdE1rtvLGi9hEc/FRlsdJTuK6E4oaQZ5qCTxvEvNtHQt2
 CymH3/jox9Rr54wIEYw8SLGUlRF+EBWrQnjml1zmBCS3GTnUv1XjE2KpOuMPXrxXi8fG
 7vpu5dEbCMsw8vXxouARHwLJZDoo/Y6MQIryBprIA2rcm+hT4MaWZUnKSWeiQrsS2ISe
 bRMwB6xaF15FVVftPpeR8KfZTMG7dIa9ZodYoBD4BX8/1ZJQfzu9GUdS/M/Uf2C0PeFc Qw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34bvm304t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 14:48:42 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09NIZhm9024951;
        Fri, 23 Oct 2020 18:48:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 348d5qx2jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 18:48:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09NImbJo32702814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 18:48:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6B1242042;
        Fri, 23 Oct 2020 18:48:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E62B42041;
        Fri, 23 Oct 2020 18:48:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Oct 2020 18:48:37 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 2/3] net/smc: fix suppressed return code
Date:   Fri, 23 Oct 2020 20:48:29 +0200
Message-Id: <20201023184830.59548-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023184830.59548-1-kgraul@linux.ibm.com>
References: <20201023184830.59548-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_12:2020-10-23,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 impostorscore=0 suspectscore=1 lowpriorityscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch that repaired the invalid return code in smcd_new_buf_create()
missed to take care of errno ENOSPC which has a special meaning that no
more DMBEs can be registered on the device. Fix that by keeping this
errno value during the translation of the return code.

Fixes: 6b1bbf94ab36 ("net/smc: fix invalid return code in smcd_new_buf_create()")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d790c43c473f..2b19863f7171 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1615,8 +1615,11 @@ static struct smc_buf_desc *smcd_new_buf_create(struct smc_link_group *lgr,
 		rc = smc_ism_register_dmb(lgr, bufsize, buf_desc);
 		if (rc) {
 			kfree(buf_desc);
-			return (rc == -ENOMEM) ? ERR_PTR(-EAGAIN) :
-						 ERR_PTR(-EIO);
+			if (rc == -ENOMEM)
+				return ERR_PTR(-EAGAIN);
+			if (rc == -ENOSPC)
+				return ERR_PTR(-ENOSPC);
+			return ERR_PTR(-EIO);
 		}
 		buf_desc->pages = virt_to_page(buf_desc->cpu_addr);
 		/* CDC header stored in buf. So, pretend it was smaller */
-- 
2.17.1

