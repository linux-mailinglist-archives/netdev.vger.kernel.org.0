Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B15B2FE292
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbhAUGSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:18:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726830AbhAUGR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 01:17:58 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L680AC010800
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:17:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xQ3EQhBpelm+Aa63tsTKEqeV6cLXov1kO8psDEd4NTk=;
 b=r1jUO88yv69XzpNiBciDr/EsRz9d5/prubrEwsAmpWogX0+UpcY08IDLvZAvfNca7c9e
 Ocj8sUnu6kBWfqRYz/Gg5Yzm4RS0lFtP5YPiclEi8Q6+/dJmSnxfy2ajVmKjqShIGtfI
 J4AnnWZQngtSN9TKP9JVXLa/zWwVgVgPlPeot/Lj5GSDRl1xWHJTg/y8Pr/dS5N8f5qO
 Zhq2+vlfZXYRxlEP3xnfKV1twkG2dTFwL0M3tKeIKPUnNcEK2vZtOtU66LrChc87d8rb
 AzJMQk3b2s7ARraGGxdwvBi6mpkr6cWJSSsYv4W+Kuybq3r0bm85PDJJJ5yAq9GHVMUA 9Q== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3673aw12y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:17:16 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L6CNkK028268
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:17:15 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3668pscbwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:17:15 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L6HDOP28508642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 06:17:13 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EF3378060;
        Thu, 21 Jan 2021 06:17:13 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EF9178066;
        Thu, 21 Jan 2021 06:17:13 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.137.249])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 06:17:13 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 3/3] ibmvnic: Ensure that CRQ entry read/write are correctly ordered
Date:   Thu, 21 Jan 2021 00:17:10 -0600
Message-Id: <20210121061710.53217-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210121061710.53217-1-ljp@linux.ibm.com>
References: <20210121061710.53217-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_02:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 impostorscore=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that received Command-Response Queue (CRQ) entries are
properly read/written in order by the driver. dma_rmb barrier
has been added before accessing the CRQ descriptor to ensure
the entire descriptor is read before processing. dma_wmb barrier
is also added to ensure the entire descriptor is written before
future processing.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 933e8fb71a8b..e947eb068163 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5090,8 +5090,20 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
 	while (!done) {
 		/* Pull all the valid messages off the CRQ */
 		while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
+			/* Ensure that the entire CRQ descriptor queue->msgs
+			 * has been loaded before reading its contents.
+			 * This barrier makes sure ibmvnic_next_crq()'s
+			 * crq->generic.first & IBMVNIC_CRQ_CMD_RSP is loaded
+			 * before ibmvnic_handle_crq()'s
+			 * switch(gen_crq->first) and switch(gen_crq->cmd).
+			 */
+			dma_rmb();
 			ibmvnic_handle_crq(crq, adapter);
 			crq->generic.first = 0;
+			/* Ensure the entire CRQ descriptor is written before
+			 * future writing.
+			 */
+			dma_wmb();
 		}
 
 		/* remain in tasklet until all
-- 
2.23.0

