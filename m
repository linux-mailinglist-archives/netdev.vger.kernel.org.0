Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619F847FD6F
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 14:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhL0Nfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 08:35:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232207AbhL0Nfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 08:35:45 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BRD6sUJ019550;
        Mon, 27 Dec 2021 13:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FD4u//1I5lWs+q+Jcfa39tLPOLeDbnFfV+OdD2vdu9o=;
 b=XckXdUgzxy+4U/y3ZzMwQChrfxu97v4pK3WidLc8V7CMkL8TWUuf/5ZMQYLYLCywfZJu
 vsVvc6GQxSvB15VfS822sZ/MW+RXtjv461Gp5mOq4IA2UwlpeGSUsEeG7KABpWCSpsnx
 6stu9rBs7R4OIQF1u1/N3GWDWW4qevAlOOicGPdLPvNWwwoxg8N1zk9C9cOSl0L/7EXu
 ZHSpZ3XHyJL81teV0o8xsddIbbIySedc7ty9NBPUMxsj3VoqGLPVrBtOpjI7pz2s2dE5
 MQ+uwmUf1fe90o5t/PhpBVpQGIRio9CjkgBe7dM5TI2U7yz3ZEASMlVnUTADey1vsAqy 6w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7cd8j1en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 13:35:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BRDXxsJ018861;
        Mon, 27 Dec 2021 13:35:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3d5txajg66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 13:35:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BRDZWZw30605716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Dec 2021 13:35:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEF8811C054;
        Mon, 27 Dec 2021 13:35:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DF5D11C04C;
        Mon, 27 Dec 2021 13:35:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Dec 2021 13:35:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH net] net/smc: fix using of uninitialized completions
Date:   Mon, 27 Dec 2021 14:35:30 +0100
Message-Id: <20211227133530.4106857-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vExuay-RAxP3lhok4-Yt2jl_x0cEWnmN
X-Proofpoint-ORIG-GUID: vExuay-RAxP3lhok4-Yt2jl_x0cEWnmN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-27_04,2021-12-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112270066
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In smc_wr_tx_send_wait() the completion on index specified by
pend->idx is initialized and after smc_wr_tx_send() was called the wait
for completion starts. pend->idx is used to get the correct index for
the wait, but the pend structure could already be cleared in
smc_wr_tx_process_cqe().
Introduce pnd_idx to hold and use a local copy of the correct index.

Fixes: 09c61d24f96d ("net/smc: wait for departure of an IB message")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_wr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 600ab5889227..79a7431f534e 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -358,18 +358,20 @@ int smc_wr_tx_send_wait(struct smc_link *link, struct smc_wr_tx_pend_priv *priv,
 			unsigned long timeout)
 {
 	struct smc_wr_tx_pend *pend;
+	u32 pnd_idx;
 	int rc;
 
 	pend = container_of(priv, struct smc_wr_tx_pend, priv);
 	pend->compl_requested = 1;
-	init_completion(&link->wr_tx_compl[pend->idx]);
+	pnd_idx = pend->idx;
+	init_completion(&link->wr_tx_compl[pnd_idx]);
 
 	rc = smc_wr_tx_send(link, priv);
 	if (rc)
 		return rc;
 	/* wait for completion by smc_wr_tx_process_cqe() */
 	rc = wait_for_completion_interruptible_timeout(
-					&link->wr_tx_compl[pend->idx], timeout);
+					&link->wr_tx_compl[pnd_idx], timeout);
 	if (rc <= 0)
 		rc = -ENODATA;
 	if (rc > 0)
-- 
2.32.0

