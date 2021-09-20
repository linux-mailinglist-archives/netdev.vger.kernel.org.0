Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605424126C7
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 21:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350731AbhITTWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 15:22:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23740 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347540AbhITTUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 15:20:06 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KJG2te012445;
        Mon, 20 Sep 2021 15:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yOnLBq41cj7F8mUNvbaJm2ktoSs5pq27wwhTBQByLiE=;
 b=Ww66TMSvPh1FsS1UeGm5RCIybWpodMHRAP6hqQu/SzaEZBej3wHIYSKed1nAboHHeONb
 +KKtZkt9scoj+tjH4RGBbdsMm+qMfcI4ro2rTO/HYred05UCIvPQY5ac+7DaXuLOZkIU
 8Q9Bo6Wc/9UgorURTGFNRbrk1qK3lX9aQNm668AK+7SyX1IpT1vnmKapSDtM5qFxbwEt
 V/Hv9NzSvMH2VREvDfR79j2wuYuIY4WB4e4SSu3yq6jtjp/ZVRUBuTdA/Zcv2saan14f
 xaLfinfWNg5MRPpjC3R5wq2Y65gVoGE8p6kWuDQxGrAYSJDN4PgfG0DCJot5fUDlsRAl dQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w94k7fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 15:18:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KJ3Grt016373;
        Mon, 20 Sep 2021 19:18:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3b57r8mess-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 19:18:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KJDj6R49152296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 19:13:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B161111C052;
        Mon, 20 Sep 2021 19:18:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 590A511C05B;
        Mon, 20 Sep 2021 19:18:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 19:18:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/2] net/smc: add missing error check in smc_clc_prfx_set()
Date:   Mon, 20 Sep 2021 21:18:14 +0200
Message-Id: <20210920191815.2919121-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920191815.2919121-1-kgraul@linux.ibm.com>
References: <20210920191815.2919121-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zl4FV8NSBfzP4Ig4fIn6wV9W7mPVswXs
X-Proofpoint-ORIG-GUID: Zl4FV8NSBfzP4Ig4fIn6wV9W7mPVswXs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=970 impostorscore=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity stumbled over a missing error check in smc_clc_prfx_set():

*** CID 1475954:  Error handling issues  (CHECKED_RETURN)
/net/smc/smc_clc.c: 233 in smc_clc_prfx_set()
>>>     CID 1475954:  Error handling issues  (CHECKED_RETURN)
>>>     Calling "kernel_getsockname" without checking return value (as is done elsewhere 8 out of 10 times).
233     	kernel_getsockname(clcsock, (struct sockaddr *)&addrs);

Add the return code check in smc_clc_prfx_set().

Fixes: c246d942eabc ("net/smc: restructure netinfo for CLC proposal msgs")
Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_clc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index e286dafd6e88..6ec1ebe878ae 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -230,7 +230,8 @@ static int smc_clc_prfx_set(struct socket *clcsock,
 		goto out_rel;
 	}
 	/* get address to which the internal TCP socket is bound */
-	kernel_getsockname(clcsock, (struct sockaddr *)&addrs);
+	if (kernel_getsockname(clcsock, (struct sockaddr *)&addrs) < 0)
+		goto out_rel;
 	/* analyze IP specific data of net_device belonging to TCP socket */
 	addr6 = (struct sockaddr_in6 *)&addrs;
 	rcu_read_lock();
-- 
2.25.1

