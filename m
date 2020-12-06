Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A27D2D00A5
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 06:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgLFFX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 00:23:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30518 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbgLFFXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 00:23:25 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B652DpB177962
        for <netdev@vger.kernel.org>; Sun, 6 Dec 2020 00:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/MehJK+lzqf0ZgtnhNkKl2lby1gfcKDVR3t/lu7aTfs=;
 b=fqArFYX2h3r7m7kZbjgqXK6A/XL4jQmpeqQ2Q/2hWL6MBXFCTTDC7PEeeJkLZhu1UAqx
 S3Rz/i9XObdSaQ4fY24mY/XdnN5zVXLak61XTseOPzQKJwNQ7oRB95nI3V95pZcWZ213
 3qJMkTmBUTLgVS2wiQtvVAaAiJuYsTDY6DZMsrHm+rQsngRbeCGh9U0SnyLxCTaX7tjf
 AU8iNbJ8UP8kCuepMKNiswuM4fMEfghdnIvuv4vlcta9ZDXvQTGFgOiAQtRVNrdA4C0o
 DtmEDz3aQSJo4b43HeXRuaxNSYGe6nYPMpgD+6ytxb6BmI+AM3yCNu/1taV4Y6R17uik 2g== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 358r4u0xn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 00:22:44 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B6585Um010797
        for <netdev@vger.kernel.org>; Sun, 6 Dec 2020 05:22:44 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u8ftyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 05:22:43 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B65LSAc6291988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Dec 2020 05:21:28 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF232124053;
        Sun,  6 Dec 2020 05:21:28 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6595A124052;
        Sun,  6 Dec 2020 05:21:28 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.129.222])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun,  6 Dec 2020 05:21:28 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [RFC PATCH net-next 2/3] use netdev_notify_peers_locked in ibmvnic
Date:   Sat,  5 Dec 2020 23:21:26 -0600
Message-Id: <20201206052127.21450-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201206052127.21450-1-ljp@linux.ibm.com>
References: <20201206052127.21450-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-06_02:2020-12-04,2020-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060029
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start to use the lockless version of netdev_notify_peers.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index df589ad6f271..25d610ab93bc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2075,10 +2075,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		napi_schedule(&adapter->napi[i]);
 
 	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
-	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
-		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
-		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
-	}
+	    adapter->reset_reason == VNIC_RESET_MOBILITY)
+		netdev_notify_peers_locked(netdev);
 
 	rc = 0;
 
@@ -2148,8 +2146,7 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	if (rc)
 		return IBMVNIC_OPEN_FAILED;
 
-	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
-	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+	netdev_notify_peers_locked(netdev);
 
 	return 0;
 }
-- 
2.23.0

