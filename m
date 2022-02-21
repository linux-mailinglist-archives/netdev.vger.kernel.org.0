Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E884BE949
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378591AbiBUO50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:57:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378599AbiBUO5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:57:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5078FE69;
        Mon, 21 Feb 2022 06:56:57 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LEIUFQ031537;
        Mon, 21 Feb 2022 14:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Amd70rsjDNuFte38Pr3M9aZOzwNBbnCwtqxMSTymEYs=;
 b=UwD9ww4hTIK37urP9+StRyDRipY+20xCHB81/+jPLWotv2f1id5Rc7Y5Ik0Nu65X5qEd
 LJg6qtUms7AWUIEWd+QCMVnNvWTF+ZB0ZUQltkT/oEYYH8RqidYAEY7lCI23nsBf+fsK
 Bm11B+Lz44ViL//7sDHYcSLv3Y3tdjgq9eWQgukN3Zm4A0RUEo8XCWMDVaBl/lIaQGg7
 hpQFa2NyBOuzav0GAG/uA8Xl2SSHYIhbtfHWko4MB+U/KKtOU7k6Pkus5Jh/CE2imutu
 U7DVwRaPjxVypHFmThTFdsYls/PcVZGexE6o1I+WyCeOZrglg+z/Ij0hb36RvasRLZw5 lw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecccw0tys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 14:56:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LESt5K022037;
        Mon, 21 Feb 2022 14:56:52 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqthufnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 14:56:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LEundE42664314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 14:56:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A8D642042;
        Mon, 21 Feb 2022 14:56:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27B664204F;
        Mon, 21 Feb 2022 14:56:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Feb 2022 14:56:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id C9254E03B1; Mon, 21 Feb 2022 15:56:48 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, agordeev@linux.ibm.com,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 1/2] s390/iucv: sort out physical vs virtual pointers usage
Date:   Mon, 21 Feb 2022 15:56:32 +0100
Message-Id: <20220221145633.3869621-2-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220221145633.3869621-1-wintera@linux.ibm.com>
References: <20220221145633.3869621-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GmD4pdEShnDABbpMcwsZ_bbCHrZpqy6V
X-Proofpoint-GUID: GmD4pdEShnDABbpMcwsZ_bbCHrZpqy6V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

Fix virtual vs physical address confusion (which currently are the same).

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 net/iucv/iucv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 8f4d49a7d3e8..eb0295d90039 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -319,7 +319,7 @@ static inline int iucv_call_b2f0(int command, union iucv_param *parm)
  */
 static int __iucv_query_maxconn(void *param, unsigned long *max_pathid)
 {
-	unsigned long reg1 = (unsigned long)param;
+	unsigned long reg1 = virt_to_phys(param);
 	int cc;
 
 	asm volatile (
-- 
2.32.0

