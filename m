Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623F52D3B5D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 07:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgLIGTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 01:19:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727200AbgLIGS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 01:18:57 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B95cHB0111632
        for <netdev@vger.kernel.org>; Wed, 9 Dec 2020 01:18:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6yYyhYLzqhz56bqnIP03UP61B6Y+3CXXkz5zIkRGkps=;
 b=el78Wk7fiaccgq6FWlYmq4PRs9UXH/vvmQjMYA5TUrCgVe8UthxN8CWuWBbN1cl9dYgI
 yQRlaxh0IpcqWb4GybkEmbR36XFs6xtysQGjvSqEDBt3MOAgZwYZf0J/MQczrPd59okK
 322J3FihOf6KGGY9rj2F4Uk83nxMa5uJrF3sSAjn7HyKtcKcE4lNFh1gpjPc+x+PKyL6
 cGOJN/Dd+56pScKgnG7SL2zpr8ZqeNbzMupQrHUMhiEYRUIE9Lk9VQ2OtwqUuLb2+rYL
 HUZ2EwJGlp4/TztbGeO7/UKsiSx+aOnNTqQdQOuO0Jehq6aZAmw9A6JS/DeAuHAnyy/W 2w== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ahbdty8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 01:18:16 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B96D15J004057
        for <netdev@vger.kernel.org>; Wed, 9 Dec 2020 06:18:15 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3581u9mpq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:18:15 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B96IE3I12321490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 06:18:14 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15AB96A04D;
        Wed,  9 Dec 2020 06:18:14 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BD816A047;
        Wed,  9 Dec 2020 06:18:13 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.139.133])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 06:18:13 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 2/3] use __netdev_notify_peers in ibmvnic
Date:   Wed,  9 Dec 2020 00:18:10 -0600
Message-Id: <20201209061811.48524-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201209061811.48524-1-ljp@linux.ibm.com>
References: <20201209061811.48524-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_03:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=1
 mlxlogscore=999 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 bulkscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start to use the lockless version of netdev_notify_peers.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cb701a6c0712..626e0f0399aa 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2169,10 +2169,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		napi_schedule(&adapter->napi[i]);
 
 	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
-	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
-		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
-		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
-	}
+	    adapter->reset_reason == VNIC_RESET_MOBILITY)
+		__netdev_notify_peers(netdev);
 
 	rc = 0;
 
@@ -2247,8 +2245,7 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 		goto out;
 	}
 
-	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
-	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+	__netdev_notify_peers(netdev);
 out:
 	/* restore adapter state if reset failed */
 	if (rc)
-- 
2.23.0

