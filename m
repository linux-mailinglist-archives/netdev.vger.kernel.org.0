Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C371251DA7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgHYQ4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:56:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgHYQ42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 12:56:28 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PGVuuh189542;
        Tue, 25 Aug 2020 12:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=3Ne07GOyAjgDnHcJQfEJz3BzQx6O9FoD+G1pH+2ixPk=;
 b=VqQ480ewaTFJrjrvtuzsRCdCfkhD9Es7+efZCHnYZxfA6Vtsw2xpQUeG58PQc4zhEskW
 /oOaIsD6LbFjf73wil5hgYNIpkCR9dZq7DbIf1qvuyRf4WSqn9bnsQi+ANVt5XyPs0cC
 I9s0bVrNxN+3K5Ov2viYxr/Usiy4+J+mArqTVqzjjxLJAWI2bVGWvmTa9TgB+5bsEs63
 7Z3OPmyZlm5+50w1DaZklDdkF8GuF+AMBruZBisaxK9PHBAL4akKGbMuk1an0G46ukdS
 aFzLMlY1GTnxVivTnLLqyvQDs5ED+NQedhWUYL6vfon/v814P0OkoromY3oiLG8G8k2c 8g== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3356110yc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 12:56:21 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07PGrfSC010024;
        Tue, 25 Aug 2020 16:56:20 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 332utthrf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 16:56:20 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07PGuJI453870988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 16:56:19 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D6F124058;
        Tue, 25 Aug 2020 16:56:19 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CA59124053;
        Tue, 25 Aug 2020 16:56:19 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 25 Aug 2020 16:56:19 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Mingming Cao <mmc@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net v2] ibmvnic fix NULL tx_pools and rx_tools issue at do_reset
Date:   Tue, 25 Aug 2020 12:56:06 -0400
Message-Id: <20200825165606.806674-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_06:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=1 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mingming Cao <mmc@linux.vnet.ibm.com>

At the time of do_rest, ibmvnic tries to re-initalize the tx_pools
and rx_pools to avoid re-allocating the long term buffer. However
there is a window inside do_reset that the tx_pools and
rx_pools were freed before re-initialized making it possible to deference
null pointers.

This patch fix this issue by always check the tx_pool
and rx_pool are not NULL after ibmvnic_login. If so, re-allocating
the pools. This will avoid getting into calling reset_tx/rx_pools with
NULL adapter tx_pools/rx_pools pointer. Also add null pointer check in
reset_tx_pools and reset_rx_pools to safe handle NULL pointer case.

Signed-off-by: Mingming Cao <mmc@linux.vnet.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5afb3c9c52d2..52feee97821e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -479,6 +479,9 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 	int i, j, rc;
 	u64 *size_array;
 
+	if (!adapter->rx_pool)
+		return -1;
+
 	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
 		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
 
@@ -649,6 +652,9 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 	int tx_scrqs;
 	int i, rc;
 
+	if (!adapter->tx_pool)
+		return -1;
+
 	tx_scrqs = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
 	for (i = 0; i < tx_scrqs; i++) {
 		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
@@ -2011,7 +2017,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		    adapter->req_rx_add_entries_per_subcrq !=
 		    old_num_rx_slots ||
 		    adapter->req_tx_entries_per_subcrq !=
-		    old_num_tx_slots) {
+		    old_num_tx_slots ||
+			!adapter->rx_pool ||
+			!adapter->tso_pool ||
+			!adapter->tx_pool) {
 			release_rx_pools(adapter);
 			release_tx_pools(adapter);
 			release_napi(adapter);
@@ -2024,10 +2033,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		} else {
 			rc = reset_tx_pools(adapter);
 			if (rc)
+				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
+						rc);
 				goto out;
 
 			rc = reset_rx_pools(adapter);
 			if (rc)
+				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
+						rc);
 				goto out;
 		}
 		ibmvnic_disable_irqs(adapter);
-- 
2.18.2

