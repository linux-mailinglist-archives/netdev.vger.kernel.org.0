Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00694403292
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 04:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347187AbhIHCWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 22:22:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57420 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235450AbhIHCWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 22:22:09 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 188242Ss133490
        for <netdev@vger.kernel.org>; Tue, 7 Sep 2021 22:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dvb+WS+x8LJerF80Gp1bxBXOqyttDpgbDh4MJ79Xoi4=;
 b=Yf75sg9sYc1JTMTonxiUdILN+/+toY4RkAsncLLbNNIx70gU1Ou+I4kvCeudKX4HEeq8
 fsGge+gXCEqcKCfBqgE5YsJg40tQ450RPHiXz6H1Ts408bximwbSGgcjKgnIqqsmb5Qo
 y4eo5DQzYLrJQcIcQii+Qqu+xUt2bG9piIMCVNeUY6ixUmBtU4pCKgRY+DNqbd7cz7OK
 u0Iwfziv1ZdWSJyKKK5MNdDIvku3WO8NgBlIvogId/X16+q1XPD4JGast0ubUoe2kOqs
 kEcVn+PMeNABjJ78C0ZFpqzoQgP9sPGLEysTfegJwx7tn9NJiUP8vngTpvyJmpvDmVCX 2w== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axd250meq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 22:21:02 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1882HHF4007544
        for <netdev@vger.kernel.org>; Wed, 8 Sep 2021 02:21:01 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 3axcnn863r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 02:21:01 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1882L0Ah12452278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Sep 2021 02:21:00 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9793AE0D1;
        Wed,  8 Sep 2021 02:20:59 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91CF2AE4CE;
        Wed,  8 Sep 2021 02:20:44 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.208.93])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 Sep 2021 02:20:44 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net internal 1/1] ibmvnic: check failover_pending in login response
Date:   Tue,  7 Sep 2021 19:20:43 -0700
Message-Id: <20210908022043.138931-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kxhNLr6BzmIyNLU3sovYXLcfPoyfCVfo
X-Proofpoint-ORIG-GUID: kxhNLr6BzmIyNLU3sovYXLcfPoyfCVfo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_08:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080011
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a failover occurs before a login response is received, the login
response buffer maybe undefined. Check that there was no failover
before accessing the login response buffer.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
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

