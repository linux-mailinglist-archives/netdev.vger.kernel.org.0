Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0AC29D69F
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgJ1WQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:16:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728000AbgJ1WQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:16:53 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09S5ZciM163255
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 01:57:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oCv7XWk1Mos6+/xQvRuXGN9eMGAiLMf0C7vB8tEmrDA=;
 b=k41ZWsbt1PKZMiptb7+MZHK0BlAK+CQD/Pzv39gKLvcfBhZRbsJvT0PqfZgUafYi6yYL
 a9WETMMTk3zHmkdabyF+NOk1xWOtoBFDH+8OT4UbN2ui/5NU/8fVZyUSDTXtYMXa1kyO
 lUXVGyYxC5UnABquHhmnZcdqn29gBu52IrEgUQ88vro8NXkw71+tvUXVpyjFEAf3hh4E
 aIxD1dsaGfvji+gxBRrgiNmqWs05WIvfBikxVHTaFnKEVhLy76akZqje0HsMeU/+JG4N
 h+IsojRZy+wt5ttHy/a2Mvn09CJCWNbWMW+USxKRTmGsbqx2dc6UMzUgkJvBT8svJGrb kg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ejc2adbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 01:57:46 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09S5qIjW032033
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 05:57:45 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 34cbw9cxeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 05:57:45 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09S5vdfr32768700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 05:57:39 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41CD4136055;
        Wed, 28 Oct 2020 05:57:44 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76CA4136051;
        Wed, 28 Oct 2020 05:57:43 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.105])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 28 Oct 2020 05:57:43 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net 1/2] ibmvnic: notify peers when failover and migration happen
Date:   Wed, 28 Oct 2020 00:57:41 -0500
Message-Id: <20201028055742.74941-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201028055742.74941-1-ljp@linux.ibm.com>
References: <20201028055742.74941-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_01:2020-10-26,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=1 bulkscore=0 phishscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to notify peers only when failover and migration happen.
It is unnecessary to call that in other events like
FATAL, NON_FATAL, CHANGE_PARAM, and TIMEOUT resets
since in those scenarios the MAC address and ip address mapping
does not change. Originally all the resets except CHANGE_PARAM
are processed by do_reset such that we need to find out
failover and migration cases in do_reset and call notifier functions.
We only need to notify peers in do_reset and do_hard_reset.
We don't need notify peers in do_change_param_reset since it is
a CHANGE_PARAM reset. In a nested reset case, it will finally
call into do_hard_reset with reasons other than failvoer and
migration. So, we don't need to check the reset reason in
do_hard_reset and just call notifier functions anyway.

netdev_notify_peers calls below two functions with rtnl lock().
	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
When netdev_notify_peers was substituted in
commit 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device reset"),
call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev) was missed.

Fixes: 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover resets")
Fixes: 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device
reset")
Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Suggested-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1b702a43a5d0..718da39f5ae4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2067,8 +2067,11 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
 
-	if (adapter->reset_reason != VNIC_RESET_FAILOVER)
+	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
+	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
+		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+	}
 
 	rc = 0;
 
@@ -2138,6 +2141,9 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	if (rc)
 		return IBMVNIC_OPEN_FAILED;
 
+	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
+	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+
 	return 0;
 }
 
-- 
2.23.0

