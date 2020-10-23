Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736D3297743
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755088AbgJWSsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:48:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755068AbgJWSso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:48:44 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09NIW78D006557;
        Fri, 23 Oct 2020 14:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=EtOBXeHsVTWgjF3xlaS9V7J/jIGqh/Ulu/ZINruufCs=;
 b=n7Yt1+pRXJUNIgg9KBEiRVyrRZjK73h69OSIcfTiVvTlzhGeM9jgNZ79+wty3RXrF4om
 T95CtBP6jnzSv7msEjkN/y4Y5NiJcXXeIP0/JIfs7G7K5gw44gX/lbN55cYLGAlEMoox
 voYLedVQJkl5N9w91jCLBfJ/XVk01wknUKpQQBghKHN45L+dxZ/cjJHIcF8p/96Pn8Pm
 aonONFbzwsVtkoIpJGSng8IWpAsrBL6oMHfDl10zi3heCKUytGapbxKcTeiaEVED5bdl
 gscvojLC1HYXK8050stQtTp/gRY6oC8e1ILNb8623+NX75miJRpVKufSpuOoBaQQ91F7 GQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34bx0s5ap9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 14:48:43 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09NIc38b023463;
        Fri, 23 Oct 2020 18:48:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 347r88ewru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 18:48:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09NImcqK31916322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 18:48:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27F1342042;
        Fri, 23 Oct 2020 18:48:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3ADE42041;
        Fri, 23 Oct 2020 18:48:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Oct 2020 18:48:37 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 3/3] s390/ism: fix incorrect system EID
Date:   Fri, 23 Oct 2020 20:48:30 +0200
Message-Id: <20201023184830.59548-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023184830.59548-1-kgraul@linux.ibm.com>
References: <20201023184830.59548-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_12:2020-10-23,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 spamscore=0 phishscore=0 mlxlogscore=884 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The system EID that is defined by the ISM driver is not correct. Using
an incorrect system EID allows to communicate with remote Linux systems
that use the same incorrect system EID, but when it comes to
interoperability with other operating systems then the system EIDs do
never match which prevents SMC-Dv2 communication.
Using the correct system EID fixes this problem.

Fixes: 201091ebb2a1 ("net/smc: introduce System Enterprise ID (SEID)")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index fe96ca3c88a5..26cc943d2034 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -390,7 +390,7 @@ static int ism_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
 }
 
 static struct ism_systemeid SYSTEM_EID = {
-	.seid_string = "IBM-SYSZ-IBMSEID00000000",
+	.seid_string = "IBM-SYSZ-ISMSEID00000000",
 	.serial_number = "0000",
 	.type = "0000",
 };
-- 
2.17.1

