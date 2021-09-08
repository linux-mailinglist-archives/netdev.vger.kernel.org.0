Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B81D4033A0
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 07:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhIHFIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 01:08:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232645AbhIHFIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 01:08:17 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18854R5B103003
        for <netdev@vger.kernel.org>; Wed, 8 Sep 2021 01:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=KXg1A9yTlWFk1gI8Ynw/bmmuG4sjcvVvDDz3u1BpmXs=;
 b=VYwLUPIUFSwd8aYnCbbk7eKTfbLrgD7/trNainmZeg/IGKHC1d62lZ6YEUj2BWK+CWKB
 58UdvKlkZfCJyG+uUhCzXMsAWef52X4yeaNvw6zGqrNKXHYi0jaGP4MAoDfeNdx8urb/
 EccUkJvpWG2ECkfqjBcSPjquNJccHsSgLa+lcA5JTXrEiwYeFJxDkIzeEDbRydJ5tMFt
 Rc7/+7D9/UOYlVWIAJva6uSt6dDa+duu/pEMKBadJ8w2QZQjipmiH1ZCleNCJUrbVoHN
 n6rwUsqLHRqrrK77y032kzGutijlZsBeS83wrg6IsxjqsZEj4aY0zVtn+b3xUYkvK6Dy VA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axkj5uhcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 01:07:08 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18853HAF027959
        for <netdev@vger.kernel.org>; Wed, 8 Sep 2021 05:07:07 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3axcnnabd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 05:07:07 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 188575PR33751544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Sep 2021 05:07:06 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBA0B78067;
        Wed,  8 Sep 2021 05:07:05 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5BD478068;
        Wed,  8 Sep 2021 05:07:04 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.55.150])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  8 Sep 2021 05:07:04 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH v2 net] ibmvnic: check failover_pending in login response
Date:   Tue,  7 Sep 2021 22:07:03 -0700
Message-Id: <20210908050703.141363-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LlfJCvOfR0F2Q6rBgzqBt7qyr8JwKd8g
X-Proofpoint-GUID: LlfJCvOfR0F2Q6rBgzqBt7qyr8JwKd8g
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_01:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a failover occurs before a login response is received, the login
response buffer maybe undefined. Check that there was no failover
before accessing the login response buffer.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---

Changelog[v2]: Fixed a trivial error in subject line

---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a775c69e4fd7..6aa6ff89a765 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4700,6 +4700,14 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 		return 0;
 	}
 
+	if (adapter->failover_pending) {
+		adapter->init_done_rc = -EAGAIN;
+		netdev_dbg(netdev, "Failover pending, ignoring login response\n");
+		complete(&adapter->init_done);
+		/* login response buffer will be released on reset */
+		return 0;
+	}
+
 	netdev->mtu = adapter->req_mtu - ETH_HLEN;
 
 	netdev_dbg(adapter->netdev, "Login Response Buffer:\n");
-- 
2.26.2

