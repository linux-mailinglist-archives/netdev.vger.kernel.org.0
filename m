Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707ED2C19B2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgKWX6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728148AbgKWX6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:16 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNX0Ya087165
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=xf4NfWq4Q0aS1TTxw3vdz8LduijegvmRijyFIVsrJkk=;
 b=g5ygDeI7NBgG6c7gLkO+klugXuEAX87lwAP+VtsobbMMj/cFMpd+5AlbKnZN9WmMbTa5
 NdiVoRbnPqb6Ga8AZnW4tMWDTwjvbCiWyp2J628nVuKZxSrZ0sm4wDFiXEEjydDuVGtk
 Gy8LjMdIJcixRj6GLduU54OO/Mjvyt92xuaWDYVP0/OOL0yN5XRHHDCTLJJco+xHLXvW
 Q08UVxZ5rnIi8IHxa26Q87cCU5xCOg/cKbK+tkdyEcPR23VYFwgMusOS/Se8gA+AHcLr
 eNXy2bGyZDDXoE17AdCXbx1MzdAsQp9aJLRg6MloE/dkk+EsFtYmd0RUBVYANkJAWvhS qw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350n0yudgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:15 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNrC5J022963
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:14 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 34xth8u13p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:14 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwEmV9044580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:14 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30B3A2805E;
        Mon, 23 Nov 2020 23:58:14 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB62528059;
        Mon, 23 Nov 2020 23:58:13 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:13 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 9/9] ibmvnic: reduce wait for completion time
Date:   Mon, 23 Nov 2020 18:57:57 -0500
Message-Id: <20201123235757.6466-10-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20201123235757.6466-1-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce the wait time for Command Response Queue response from 30 seconds
to 20 seconds, as recommended by VIOS and Power Hypervisor teams.

Fixes: bd0b672313941 ("ibmvnic: Move login and queue negotiation into
ibmvnic_open")
Fixes: 53da09e92910f ("ibmvnic: Add set_link_state routine for setting
adapter link state")

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3bfdf9f2edff..63b39744a07a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -834,7 +834,7 @@ static void release_napi(struct ibmvnic_adapter *adapter)
 static int ibmvnic_login(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	int retry_count = 0;
 	int retries = 10;
 	bool retry;
@@ -938,7 +938,7 @@ static void release_resources(struct ibmvnic_adapter *adapter)
 static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 {
 	struct net_device *netdev = adapter->netdev;
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	union ibmvnic_crq crq;
 	bool resend;
 	int rc;
@@ -5124,7 +5124,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 {
 	struct device *dev = &adapter->vdev->dev;
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	u64 old_num_rx_queues, old_num_tx_queues;
 	int rc;
 
-- 
2.26.2

