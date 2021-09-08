Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43337403E0B
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352346AbhIHQ7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:59:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235666AbhIHQ7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 12:59:32 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 188GXSg6002054
        for <netdev@vger.kernel.org>; Wed, 8 Sep 2021 12:58:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ZeLt8snfRtCYtWL86pNXRwowHGxuRdozgc/ETnC/mxc=;
 b=bFgya4C+xbSbHNk8mBo82yoGjVqNcchOkxA9Fn04rXXFWuqyyWkTyIyyI9ESXMKKUkXK
 EEzp07jENaZ2qmtmbGYX1thoBDBaW5g2b9dM9UDjoYrHr5WnwGAzaQ9z0CTh1x8Hv20i
 CO8lIKI8fODp2lc9NAbRe9OQ1mYmsgDJ5oXAlhXLigVhYm9F24Y50Cu6cSVwQMtNIRuq
 HJQA04JCwf9f7M7TDc36s2pYSeSn4iQq6vx1u+JEC7KBpaHZeODk/Js1SwniMy+ZvPIY
 LlJ9T14V3/9+AcNlgLJanbldwpIy5ljstHUR5leJ2bcOSbUHsPrHuOkZVNLnS/EXU+TM Gg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ay0rj0rky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 12:58:24 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 188Gw3id001948
        for <netdev@vger.kernel.org>; Wed, 8 Sep 2021 16:58:23 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3axcnj6mac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 16:58:23 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 188GwMVA37749114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Sep 2021 16:58:22 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40F22136061;
        Wed,  8 Sep 2021 16:58:22 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C150136055;
        Wed,  8 Sep 2021 16:58:21 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.27])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  8 Sep 2021 16:58:21 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH v3 net] ibmvnic: check failover_pending in login response
Date:   Wed,  8 Sep 2021 09:58:20 -0700
Message-Id: <20210908165820.145225-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ujvsVJnYeAVumBg0wRdtDHpOz5pTM-iD
X-Proofpoint-GUID: ujvsVJnYeAVumBg0wRdtDHpOz5pTM-iD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_06:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 clxscore=1015 suspectscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a failover occurs before a login response is received, the login
response buffer maybe undefined. Check that there was no failover
before accessing the login response buffer.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---

Changelog[v3]: Added Fixes tag
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

