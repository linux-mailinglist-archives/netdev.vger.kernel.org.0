Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B631A9A8
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhBMChc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:37:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229648AbhBMChb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:37:31 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11D2VnAm032054
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 21:36:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=32LpBEKTVplhW6MU4s4qn4nmsCSljynKrtaUcuLRRB8=;
 b=cwJ7GfQcfUXvGLhXRQhHK8hOTl0Tl+WlVqBJgzfVkeRK+BTihuoHFlMG0rva48ujBYh0
 YxZ7/Ake5qkU7p9pYA8qqcL9EJqIOjw8Mm/fV9ir+wKRL5oan47klqRH8af8CTZRyW1S
 b1uuJJ+Zac6vMlqc2BH7B3G3YMSQCtCp7Xs4gxv32shBZvtn5WpsR3G/aA38TKFgtBW0
 f1HMmJ6o/uTvwdbGEqk+NOju/vmbOuj9bFBjog1sgHx6H7KVxPG0kJXMI0Yxrpw0WBhU
 yP1H2FmGGzIoIBU71A9cnITAJKSE7PH0kR4lKh2541A5mUU8Q3x9TlXiMvSjfQeJn3Le OA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36p5tcgc2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 21:36:50 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11D2XAkp025760
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:36:49 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 36hjra5ug9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:36:49 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11D2amb928967304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Feb 2021 02:36:48 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38B6DC6059;
        Sat, 13 Feb 2021 02:36:48 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A151C6055;
        Sat, 13 Feb 2021 02:36:47 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.198.213])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 13 Feb 2021 02:36:47 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: substitute mb() with dma_wmb() for send_*crq* functions
Date:   Fri, 12 Feb 2021 20:36:46 -0600
Message-Id: <20210213023646.55955-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=822
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102130017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CRQ and subCRQ descriptors are DMA mapped, so dma_wmb(),
though weaker, is good enough to protect the data structures.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Acked-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 7a5e589e7223..927d5f36d308 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3599,7 +3599,7 @@ static int send_subcrq_indirect(struct ibmvnic_adapter *adapter,
 	int rc;
 
 	/* Make sure the hypervisor sees the complete request */
-	mb();
+	dma_wmb();
 	rc = plpar_hcall_norets(H_SEND_SUB_CRQ_INDIRECT, ua,
 				cpu_to_be64(remote_handle),
 				ioba, num_entries);
@@ -3629,7 +3629,7 @@ static int ibmvnic_send_crq(struct ibmvnic_adapter *adapter,
 	}
 
 	/* Make sure the hypervisor sees the complete request */
-	mb();
+	dma_wmb();
 
 	rc = plpar_hcall_norets(H_SEND_CRQ, ua,
 				cpu_to_be64(u64_crq[0]),
-- 
2.23.0

