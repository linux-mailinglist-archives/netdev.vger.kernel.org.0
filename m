Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828C62DF1D7
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 22:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgLSVlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 16:41:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33862 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727468AbgLSVlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 16:41:19 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BJLV7fw055739
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 16:40:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=6d3ceiduZNjwsA+/owBPOk7nDWKG7v0C/O50i02vYKI=;
 b=GRH3gcKrv3d9I+PY7rXwMeF8jMpE0QGawcJ7FaxmS2ooAIsh+Jnilq7DUnuk9MJcnlkp
 9Bo3bDt5OGkQrl0BtO12QBQQVDGxDHvLniIpOaPq6ON0/s0bk8c4vCP9q8zTvmiAmlgc
 aQbM5g3ZlMSFnh8mebUQccTsyQKks3HfcI6asRV0nKtH4cMBIueCvJuilnbxhhxpmJBA
 FDCZrAO2jaEKX33WDg1RUnhJjBLJ/9NYRzq1eA6bLdbtFHX2spVEXefuz9tGiDNkIVRt
 7clAM7Qvr+iL4dC2B/JpquOYanDryEILnZ/M3zKMEmpax/+83LRY6cDeHt6NO3qKcQid bw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35hnpwupcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 16:40:37 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BJLX7Ag003689
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 21:40:37 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 35h958nuxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 21:40:37 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BJLeZjM24838426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Dec 2020 21:40:35 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C06A7136055;
        Sat, 19 Dec 2020 21:40:35 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40F2C136051;
        Sat, 19 Dec 2020 21:40:35 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.144.201])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 19 Dec 2020 21:40:35 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net] ibmvnic: continue fatal error reset after passive init
Date:   Sat, 19 Dec 2020 15:40:34 -0600
Message-Id: <20201219214034.21123-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-19_11:2020-12-19,2020-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012190157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
says "If the passive
CRQ initialization occurs before the FATAL reset task is processed,
the FATAL error reset task would try to access a CRQ message queue
that was freed, causing an oops. The problem may be most likely to
occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
process will automatically issue a change MTU request.
Fix this by not processing fatal error reset if CRQ is passively
initialized after client-driven CRQ initialization fails."

Even with this commit, we still see similar kernel crashes. In order
to completely solve this problem, we'd better continue the fatal error
reset, capture the kernel crash, and try to fix it from that end.

Fixes: f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b370c88a43f1..237a36040689 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2342,8 +2342,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(60 * HZ);
 			}
-		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
-				adapter->from_passive_init)) {
+		} else {
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);
-- 
2.23.0

