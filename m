Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC95D303003
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732758AbhAYXVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:21:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3642 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732103AbhAYXVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:21:09 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10PN1VbC153233
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 18:20:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3WsESBR/aCHMcKLq5YFPFoi6SiBoWt6KhXiyV66ad0w=;
 b=BjYPicyheb/c9t6C1tmvvprq06w27+7SJnQNEJgjPCkLFBD8qADnD3MIGg0Hl/dwrcI4
 v4l8pBXjhVxbjPQbKAj0AqufTD6ccMcWIyvt36Uw47NXMa49AZhPeMInoUvtXe4I8e8Y
 7X6ylQDfN0xyBB9ZliI4s0cn+2JgXVv6gYxHIRYQPejEmWkZq29RthwxZstTqzhQJimS
 kSjA3a5gJX9U0pGHrFemi0RLjoMSuSGklO8jCKrcs3DGY32M6Gum5NQNe6Czi8Um5v56
 xPCF1wZxDa2+vT0Ty5MZrDAGJWwTjpZBHxkyhgJ0Be9vnAxvATF84+Nzqgs2LZfma/vE 3g== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36a6d29jra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 18:20:26 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10PNCdtW020469
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 23:20:26 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03dal.us.ibm.com with ESMTP id 368be8xjq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 23:20:26 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10PNKOpw8585688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 23:20:24 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 944816A04D;
        Mon, 25 Jan 2021 23:20:24 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B8FB6A066;
        Mon, 25 Jan 2021 23:20:24 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.236.90])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jan 2021 23:20:23 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v2] ibmvnic: Ensure that CRQ entry read are correctly ordered
Date:   Mon, 25 Jan 2021 17:20:23 -0600
Message-Id: <20210125232023.78649-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_10:2021-01-25,2021-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=932 phishscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101250112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that received Command-Response Queue (CRQ) entries are
properly read in order by the driver. dma_rmb barrier has
been added before accessing the CRQ descriptor to ensure
the entire descriptor is read before processing.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: drop dma_wmb according to Jakub's opinion

 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9778c83150f1..d84369bd5fc9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5084,6 +5084,14 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
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
 		}
-- 
2.23.0

