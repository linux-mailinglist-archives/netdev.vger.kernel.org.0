Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F982BB94E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgKTWlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40846 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729077AbgKTWk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:59 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMX7On006341
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xNiJQjSHadW7NHFkkJNgNv0r+qD3YZrzNloHNJftZZ4=;
 b=dvBquGC24ZVSQ5QOyU1n/zlww7CVqp/su9LOl4HYdO6mkRK/fuNKaQuJ5+6mhBCTwSfU
 rG6f/XS0rgBJXx9OROq4/e1wZmxCW27OjOu8TTfB4/aOsyweeoohOxR5OxIRTuxjlX6J
 PdsyxzDNe4VEOtN0+ZwuIIcQ/J4VaInuKWEl3Yyug/+6DyJrJO6eCQiokfZiwadXsYoI
 TPHQB7x6wuQMIK5Stin2UC8P+l9uBj7ufVOiw8sqbJuBVLlkY4odypLsms5t4NPbj/vE
 PPAbGmGWEG1gu581uUkuOWK8PupKJwaxB0MwIcv73v2sY4qR5UFrGGfuDHWi5dxcfHqK mA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34xhk88wgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:58 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMc21H015141
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:58 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 34t6v9ss9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:58 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMeuwP7471706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:56 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C708C6E053;
        Fri, 20 Nov 2020 22:40:56 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26E7E6E050;
        Fri, 20 Nov 2020 22:40:56 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:56 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 07/15] ibmvnic: delay next reset if hard reset failed
Date:   Fri, 20 Nov 2020 16:40:41 -0600
Message-Id: <20201120224049.46933-8-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0
 adultscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

If auto-priority failover is enabled, the backing device needs time
to settle if hard resetting fails for any reason. So add a delay of
60 seconds before retrying the hard-reset.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6f775ca4bea1..b0a93556a51b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2280,6 +2280,14 @@ static void __ibmvnic_reset(struct work_struct *work)
 				rc = do_hard_reset(adapter, rwi, reset_state);
 				rtnl_unlock();
 			}
+			if (rc) {
+				/* give backing device time to settle down */
+				netdev_dbg(adapter->netdev,
+					   "[S:%d] Hard reset failed, waiting 60 secs\n",
+					   adapter->state);
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				schedule_timeout(60 * HZ);
+			}
 		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
 				adapter->from_passive_init)) {
 			rc = do_reset(adapter, rwi, reset_state);
-- 
2.23.0

