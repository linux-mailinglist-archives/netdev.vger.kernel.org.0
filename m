Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A621532E324
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCEHpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:45:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhCEHpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 02:45:01 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1257YOQR030182;
        Fri, 5 Mar 2021 02:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=AvvM0EJBjkxu97PuHpeRgUdbwOFmWBOvoWyAuT/Hsnc=;
 b=aYMtn2djx6JQYurza5GAtuniwW8QBeK/q7dPAbFS5Q/rOdxuI7BaZcrn+Ay1omvrOpAs
 olnSW+5ABk3WGQoPR2Q8zchypzxnaD/C4UpXUSyiDY4qM7Sl4EGaXfb9+dpW4kcu0tKY
 hFLkm55o9fUhoBWli3vcQ4w01+np6oAwVR4pDna1jl/yG3EOj+/yKF1vDgP0iFSMOvQb
 ZCGOPV7/JCYtArwCnKsyxF38l11MewPEFdy1cBw3Ez2KhWvDFU8oPhlOJtCtXFnDEiv7
 xtqETduJTnkJQB+btHIy8ts4kW8WLBxvvergd3JwrleUnCCx5VbLZIvrieOyJmaCmnVW VA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373fn99nf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 02:44:59 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1257XDwZ004857;
        Fri, 5 Mar 2021 07:44:58 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 371qmv3dyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 07:44:58 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1257ivg623331310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Mar 2021 07:44:58 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE7E2AC05F;
        Fri,  5 Mar 2021 07:44:57 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DFD0AC05B;
        Fri,  5 Mar 2021 07:44:57 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.134.181])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Mar 2021 07:44:57 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, sukadev@linux.ibm.com,
        drt@linux.ibm.com, tlfalcon@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [RFC PATCH net] ibmvnic: complete dev->poll nicely during adapter reset
Date:   Fri,  5 Mar 2021 01:44:56 -0600
Message-Id: <20210305074456.88015-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_04:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=986
 bulkscore=0 impostorscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 clxscore=1011 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103050035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset path will call ibmvnic_cleanup->ibmvnic_napi_disable
->napi_disable(). This is supposed to stop the polling.
Commit 21ecba6c48f9 ("ibmvnic: Exit polling routine correctly
during adapter reset") reported that the during device reset,
polling routine never completed and napi_disable slept indefinitely.
In order to solve that problem, resetting bit was checked and
napi_complete_done was called before dev->poll::ibmvnic_poll exited.

Checking for resetting bit in dev->poll is racy because resetting
bit may be false while being checked, but turns true immediately
afterwards.

Hence we call napi_complete in ibmvnic_napi_disable, which avoids
the racing with resetting, and makes sure dev->poll and napi_disalbe
completes before reset routine actually releases resources.

Fixes: 21ecba6c48f9 ("ibmvnic: Exit polling routine correctly during adapter reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b6102ccf9b90..338d3d071cec 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -785,6 +785,7 @@ static void ibmvnic_napi_disable(struct ibmvnic_adapter *adapter)
 
 	for (i = 0; i < adapter->req_rx_queues; i++) {
 		netdev_dbg(adapter->netdev, "Disabling napi[%d]\n", i);
+		napi_complete(&adapter->napi[i]);
 		napi_disable(&adapter->napi[i]);
 	}
 
@@ -2455,13 +2456,6 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 		u16 offset;
 		u8 flags = 0;
 
-		if (unlikely(test_bit(0, &adapter->resetting) &&
-			     adapter->reset_reason != VNIC_RESET_NON_FATAL)) {
-			enable_scrq_irq(adapter, rx_scrq);
-			napi_complete_done(napi, frames_processed);
-			return frames_processed;
-		}
-
 		if (!pending_scrq(adapter, rx_scrq))
 			break;
 		next = ibmvnic_next_scrq(adapter, rx_scrq);
-- 
2.23.0

