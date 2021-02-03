Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB7630D2C1
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 06:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBCFIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 00:08:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229611AbhBCFIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 00:08:45 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11354gCX096161
        for <netdev@vger.kernel.org>; Wed, 3 Feb 2021 00:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mwe3vGzavFwF7X6Z4IiSkxs2qxlBa+cP2R87bKpG8HE=;
 b=I5iGXvwqGJR2utrHiH9+xK7WpZHAXjn7nRK/XH761GqTglECP7I+J4IksUu2jVJEKIYi
 HJAvRSJWhl/Onfq5COKBeMp0huvmtXiu+rs3ECdvNAn7REgnKGf/wEEZmE9wQoAgQp95
 vOyxaNrBDbQGpghG6wNwCWzHPA/vJ7lwvDBV0vFqO/hPbGuuKOqNdnnkFS7W+wNq77Sj
 B9vfcnpNKL4skt9yoWBSy4jXgNByORYA95Ey/Re9Da7IixCai6ehwKFUNNV37OtDyHwO
 hASs8EWokTXyjVeZ7hikOywo8jdmLscJwhFrRByjwlO1s/oESnxTgc0J9TrThfmV19Y4 jw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fkvr9yw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:08:05 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11352uj1006998
        for <netdev@vger.kernel.org>; Wed, 3 Feb 2021 05:08:04 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 36f0yuqq0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 05:08:04 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 113583pM30605598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 05:08:03 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B4D6AC05B;
        Wed,  3 Feb 2021 05:08:03 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1DC9AC05E;
        Wed,  3 Feb 2021 05:08:02 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.202.29])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 05:08:02 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, cforno12@linux.ibm.com,
        sukadev@linux.ibm.com
Subject: [PATCH 1/1] ibmvnic: Clear failover_pending if unable to schedule
Date:   Tue,  2 Feb 2021 21:08:02 -0800
Message-Id: <20210203050802.680772-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_01:2021-02-02,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 bulkscore=0 impostorscore=0 suspectscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030024
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally we clear the failover_pending flag when processing the reset.
But if we are unable to schedule a failover reset we must clear the
flag ourselves. We could fail to schedule the reset if we are in PROBING
state (eg: when booting via kexec) or because we could not allocate memory.

Thanks to Cris Forno for helping isolate the problem and for testing.

Fixes: 1d8504937478 ("powerpc/vnic: Extend "failover pending" window")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Tested-by: Cristobal Forno <cforno12@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index df1b4884b4e8..58108e1a1d2e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4907,7 +4907,23 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;
 			}
-			ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
+			rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
+			if (rc && rc != -EBUSY) {
+				/**
+				 * We were unable to schedule the failover
+				 * reset either because the adapter was still
+				 * probing (eg: during kexec) or we could not
+				 * allocate memory. Clear the failover_pending
+				 * flag since no one else will. We ignore
+				 * EBUSY because it means either FAILOVER reset
+				 * is already scheduled or the adapter is
+				 * being removed.
+				 */
+				netdev_err(netdev,
+					   "Error %ld scheduling failover reset\n",
+					   rc);
+				adapter->failover_pending = false;
+			}
 			break;
 		case IBMVNIC_CRQ_INIT_COMPLETE:
 			dev_info(dev, "Partner initialization complete\n");
-- 
2.26.2

