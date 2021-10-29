Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E8444053D
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJ2WFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:05:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhJ2WFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:05:51 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TLkcsm020463
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=TSD3xEcttqMrih7i59FWKu7ia8zBe2whaT3+Rtf7l4Q=;
 b=kPHEsSOB7NEPfRXbZMxDXSxng/kvEZZ3L/nuFu88m/aABY8CFImhE6uPl9Xh1qOfdNS/
 cKYZ9k/GUxE4HXTQL1/psPSWax8OaPJTN8pEk5J6j4dVJTzl+SHG9TkflNYsW3z/ENHp
 BcwdNvHofBmL/V5dNJKsgxbJNHkuLm1LByErNRCXaKmVB5xs0JMRB/gmVjjxPKDT3TGv
 ue8RyxgsE25hlENYc7GRT2V4IwMKpF8Yu237MHhaLVs/fTmY5SEDW/DozGGn+CGuxLqi
 n7V0uIaLwwpYosLXVCSVwWqO3ziI4s5huhEtA2HqQlCv326I/u5qylFtBmCaNjNdK8+A 0g== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c0s5x0ab4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:22 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19TLvYtM006799
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:21 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3bx4fpekts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:21 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19TM3JDA35455426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 22:03:19 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12221B206A;
        Fri, 29 Oct 2021 22:03:19 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C708AB2064;
        Fri, 29 Oct 2021 22:03:17 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.240.170])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Oct 2021 22:03:17 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        abdhalee@in.ibm.com, vaish123@in.ibm.com
Subject: [PATCH net 1/3] ibmvnic: don't stop queue in xmit
Date:   Fri, 29 Oct 2021 15:03:14 -0700
Message-Id: <20211029220316.2003519-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: s5Ogq_vg2HJKVLOpilXs0JAMBymEX6Iw
X-Proofpoint-ORIG-GUID: s5Ogq_vg2HJKVLOpilXs0JAMBymEX6Iw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_06,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=772 phishscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110290123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If adapter's resetting bit is on, discard the packet but don't stop the
transmit queue - instead leave that to the reset code. With this change,
it is possible that we may get several calls to ibmvnic_xmit() that simply
discard packets and return.

But if we stop the queue here, we might end up doing so just after
__ibmvnic_open() started the queues (during a hard/soft reset) and before
the ->resetting bit was cleared. If that happens, there will be no one to
restart queue and transmissions will be blocked indefinitely.

This can cause a TIMEOUT reset and with auto priority failover enabled,
an unnecessary FAILOVER reset to less favored backing device and then a
FAILOVER back to the most favored backing device. If we hit the window
repeatedly, we can get stuck in a loop of TIMEOUT, FAILOVER, FAILOVER
resets leaving the adapter unusable for extended periods of time.

Fixes: 7f5b030830fe ("ibmvnic: Free skb's in cases of failure in transmit")
Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 8f17096e614d..a1533979c670 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1914,8 +1914,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	ind_bufp = &tx_scrq->ind_buf;
 
 	if (test_bit(0, &adapter->resetting)) {
-		if (!netif_subqueue_stopped(netdev, skb))
-			netif_stop_subqueue(netdev, queue_num);
 		dev_kfree_skb_any(skb);
 
 		tx_send_failed++;
-- 
2.26.2

