Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDA7281624
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbgJBPJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:09:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgJBPJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:09:41 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092F270a071367;
        Fri, 2 Oct 2020 11:09:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=b47HYfuItCRUvyZf80CeW1s+BIFw1G+R3rroDyeJoMo=;
 b=CC+Av+gqRipOsLfxv2+atlknsvQYjllhWoQ1cLofCwTEbQSwJBS7HlVp6YKXsghRBupE
 lmvdBE+Yr8xbV0pgGYOj3lgh8u3fj4dk/VxV6SODseuWIjV5SqLhVYRoXJ+IWXooBmek
 QeR/SYxKRofTizhyUGclTkTeY+hnG46ustm0TZNAuYaK7YTXavj48LTYyBOg97aHBJ46
 8FHAvtyjx0Ssv8NUwusvMdfKJKLP7ycGBsnEqxZlxnKKNP3qAsAKMHSZJYuKbjX8quO6
 GNcQ5qqYNEWpmji/VGxlhuCvwXPkePbvhlxdGZ+f7bHDiSiwYQ6pnh2UH357Z75EXB6L zg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33x4k24e6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:09:38 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092F2Hcl001600;
        Fri, 2 Oct 2020 15:09:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 33v6mgu8a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:09:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092F9Yhs31064394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:09:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13649A4040;
        Fri,  2 Oct 2020 15:09:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEA8EA404D;
        Fri,  2 Oct 2020 15:09:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:09:33 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 2/2] net/smc: use an array to check fields in system EID
Date:   Fri,  2 Oct 2020 17:09:27 +0200
Message-Id: <20201002150927.72261-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002150927.72261-1-kgraul@linux.ibm.com>
References: <20201002150927.72261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=709 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxscore=0 spamscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for old hardware versions that did not have SMCDv2 support was
using suspicious pointer magic. Address the fields using an array.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_ism.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index e9a6487a42cb..6abbdd09a580 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -335,7 +335,7 @@ int smcd_register_dev(struct smcd_dev *smcd)
 		u8 *system_eid = NULL;
 
 		smc_ism_get_system_eid(smcd, &system_eid);
-		if ((*system_eid) + 24 != '0' || (*system_eid) + 28 != '0')
+		if (system_eid[24] != '0' || system_eid[28] != '0')
 			smc_ism_v2_capable = true;
 	}
 	/* sort list: devices without pnetid before devices with pnetid */
-- 
2.17.1

