Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0635103FFC
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfKTPug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:50:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728118AbfKTPuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 10:50:35 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKFl8q6017823;
        Wed, 20 Nov 2019 10:50:33 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf5ag599-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 10:50:32 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAKFniec009586;
        Wed, 20 Nov 2019 15:50:32 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 2wa8r6qj5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 15:50:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAKFoVfu49873276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 15:50:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB819C606C;
        Wed, 20 Nov 2019 15:50:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FDDAC6063;
        Wed, 20 Nov 2019 15:50:30 +0000 (GMT)
Received: from ltcalpine2-lp21.aus.stglabs.ibm.com (unknown [9.40.195.230])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 20 Nov 2019 15:50:30 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, julietk@linux.vnet.ibm.com,
        tlfalcon@linux.vnet.ibm.com
Subject: [PATCH net/ibmvnic 2/2] net/ibmvnic: Ignore H_FUNCTION return from H_EOI to tolerate XIVE mode
Date:   Wed, 20 Nov 2019 10:50:04 -0500
Message-Id: <1574265004-8388-3-git-send-email-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574265004-8388-1-git-send-email-julietk@linux.vnet.ibm.com>
References: <1574265004-8388-1-git-send-email-julietk@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_04:2019-11-15,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911200140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reversion of commit 11d49ce9f7946dfed4dcf5dbde865c78058b50ab
(“net/ibmvnic: Fix EOI when running in XIVE mode.”) leaves us
calling H_EOI even in XIVE mode. That will fail with H_FUNCTION
because H_EOI is not supported in that mode. That failure is
harmless. Ignore it so we can use common code for both XICS and
XIVE.

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2b073a3..0686ded 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2881,7 +2881,10 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
 		u64 val = (0xff000000) | scrq->hw_irq;
 
 		rc = plpar_hcall_norets(H_EOI, val);
-		if (rc)
+		/* H_EOI would fail with rc = H_FUNCTION when running
+		 * in XIVE mode which is expected, but not an error.
+		 */
+		if (rc && (rc != H_FUNCTION))
 			dev_err(dev, "H_EOI FAILED irq 0x%llx. rc=%ld\n",
 				val, rc);
 	}
-- 
1.8.3.1

