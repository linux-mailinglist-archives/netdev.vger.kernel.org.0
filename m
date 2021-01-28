Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF8B306A78
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhA1Bfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:35:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41006 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229828AbhA1Bf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:35:27 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10S1VwPw183360
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 20:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=OtaVf1OqrpogDlg8/5+RRhcYJIszx3RTNBqUeyGzA0I=;
 b=BAsk+xYboET4qnmP/6vk9mU+8t+NVjnbFEYg1mcogEwCuKNLh0gFDa5wCQv/npavPfMO
 8wjH0xbwKRB9BpvL37yPv2AKgyHwlnlrSc6tPLw+KShzu0qd7t+DJna+zpd/OpNoKmV1
 VtVG4GoGq/cP0uVldkFgq8sElE3FuNhm1EL8p8b378l1Yrh2ZqaVYtENkN3MxS1B9fFj
 llBsnt/GK4vr6ZtqhLi2gb724Pd/jfVlNwBwl4QMs+ee7esAsnfujRdJQohxl1AASzP3
 8V/17rSYDsB3Ig6l6OmETHAS+2lObp5I0yEHwqqNzkemuTx7fmvLH2tiGWD9MbVJeRF5 aQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bdh8h7as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 20:34:45 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10S1WIcw029282
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:34:45 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 36acj9e2d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:34:45 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10S1Yhnn26345848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 01:34:44 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE5B86E04E;
        Thu, 28 Jan 2021 01:34:43 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56AA86E052;
        Thu, 28 Jan 2021 01:34:43 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.194.72])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 01:34:43 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v3] ibmvnic: Ensure that CRQ entry read are correctly ordered
Date:   Wed, 27 Jan 2021 19:34:42 -0600
Message-Id: <20210128013442.88319-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_10:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=839 adultscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280003
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
v3: reword the comments in the code to make it less confusing.
v2: drop dma_wmb according to Jakub's opinion

 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9778c83150f1..8820c98ea891 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5084,6 +5084,12 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
 	while (!done) {
 		/* Pull all the valid messages off the CRQ */
 		while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
+			/* This barrier makes sure ibmvnic_next_crq()'s
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

