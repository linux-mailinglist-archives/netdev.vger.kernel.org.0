Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A682BB935
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgKTWkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728952AbgKTWkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:20 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMXtfm105690
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=d9ffRlrzdu9xe+dokZZeL16wY+969TOho088ykuuWas=;
 b=fqd+5361RHAvD2lMuqgQg/dWts5IT3ZxuLTM0I3fSLovJqdikJi7GRKF7xBWMjnZkuyY
 VhsEEdUiQ3pCfdHV+7nbDYevNV0+kAlqWFQZU7zqWq/s/bGvukd3ofDXKuaw14uzuLbH
 vH7O5V4xyhY0NV44qTj9DSs3dMezqgTAn55S6oG04RCae1owvYa1HByPUTmm7wJ9QVUA
 4lQe/71tEAHRlwn0XBaIhQK1686uD+BleUHEGIcvOBR/H6pU0vPyLodybTgh/uE8+Qs4
 pHaMeppA/R7QYXGadcLMjlHpw2oddOm/MWIpAZb6KTiW3g2a1TYDGlKuHc0/6Kww3XbY Kw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xd1m35r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:19 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMbf2a019527
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:18 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 34w263h7vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:18 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMeHOn64749870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:17 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BE056E052;
        Fri, 20 Nov 2020 22:40:17 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 621B96E050;
        Fri, 20 Nov 2020 22:40:16 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:16 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
Subject: [PATCH net v2 2/3] ibmvnic: notify peers when failover and migration happen
Date:   Fri, 20 Nov 2020 16:40:12 -0600
Message-Id: <20201120224013.46891-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224013.46891-1-ljp@linux.ibm.com>
References: <20201120224013.46891-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 clxscore=1015 suspectscore=1 bulkscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover resets")
excluded the failover case for notify call because it said
netdev_notify_peers() can cause network traffic to stall or halt.
Current testing does not show network traffic stall
or halt because of the notify call for failover event.
netdev_notify_peers may be used when a device wants to inform the
rest of the network about some sort of a reconfiguration
such as failover or migration.

It is unnecessary to call that in other events like
FATAL, NON_FATAL, CHANGE_PARAM, and TIMEOUT resets
since in those scenarios the hardware does not change.
If the driver must do a hard reset, it is necessary to notify peers.

Fixes: 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover resets")
Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Suggested-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: split from v1's 1/2
    explain why "notify peers" is needed for failover

 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index eface3543b2c..9665532a9ed2 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2074,7 +2074,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
 
-	if (adapter->reset_reason != VNIC_RESET_FAILOVER) {
+	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
+	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
 		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
 	}
@@ -2147,6 +2148,9 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	if (rc)
 		return IBMVNIC_OPEN_FAILED;
 
+	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
+	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+
 	return 0;
 }
 
-- 
2.23.0

