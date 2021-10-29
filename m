Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C861744053F
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhJ2WF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:05:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38652 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231404AbhJ2WFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:05:55 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TLbwII033027
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jWh4v72TuNmSX7yEp+BG+ZfXpgoMikGFfxE+gBB2DPs=;
 b=qDAGnhhDzqzcuxWxxpTIUcVpqCVaew0QRNm6mYLeIFsl87elRbFekeNMHeB2apqaXwIu
 Td7qGCRu9TncS9uLzg9iqoMVcj79B1aiy3ZbzxYKgqNvaQ7hIuLqv/KWvMO5FWOB8qud
 LF0ZNhspwJ7zhsMitHJ5PqzFBmYMsU/aBLXUROBaqdPk311YDI/WyVLQir2/RAdfpWj1
 4n3ewBZblgzH0RLg50ZqEp1lX/jWfHZS/0Zu6BD48h3ohc9klYZ9oAT4mpfrAK68d2pr
 bbs24fyGFLd6POsJBXaHt2jBuCycNl34r3yXzA84gPP3cUTzc4SuVbgJ3MohZ0dbYJ/Y PA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c0q04jq4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:25 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19TLvW3u006772
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:25 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 3bx4fpekux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:25 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19TM3MHE16122272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 22:03:22 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8993B2072;
        Fri, 29 Oct 2021 22:03:21 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEA57B2065;
        Fri, 29 Oct 2021 22:03:20 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.240.170])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Oct 2021 22:03:20 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        abdhalee@in.ibm.com, vaish123@in.ibm.com
Subject: [PATCH net 3/3] ibmvnic: delay complete()
Date:   Fri, 29 Oct 2021 15:03:16 -0700
Message-Id: <20211029220316.2003519-3-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029220316.2003519-1-sukadev@linux.ibm.com>
References: <20211029220316.2003519-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jV5Y22Luye89ifIhyCQ_4U63HBtflyq8
X-Proofpoint-GUID: jV5Y22Luye89ifIhyCQ_4U63HBtflyq8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_06,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1015 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=901 spamscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110290123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we get CRQ_INIT, we set errno to -EIO and first call complete() to
notify the waiter. Then we try to schedule a FAILOVER reset. If this
occurs while adapter is in PROBING state, ibmvnic_reset() changes the
error code to EAGAIN and returns without scheduling the FAILOVER. The
purpose of setting error code to EAGAIN is to ask the waiter to retry.

But due to the earlier complete() call, the waiter may already have seen
the -EIO response and decided not to retry. This can cause intermittent
failures when bringing up ibmvnic adapters during boot, specially in
in kexec/kdump kernels.

Defer the complete() call until after scheduling the reset.

Also streamline the error code to EAGAIN. Don't see why we need EIO
sometimes. All 3 callers of ibmvnic_reset_init() can handle EAGAIN.

Fixes: 17c8705838a5 ("ibmvnic: Return error code if init interrupted by transport event")
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 50956f622b11..29cbf60dfd79 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2755,7 +2755,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	if (adapter->state == VNIC_PROBING) {
 		netdev_warn(netdev, "Adapter reset during probe\n");
-		adapter->init_done_rc = EAGAIN;
+		adapter->init_done_rc = -EAGAIN;
 		ret = EAGAIN;
 		goto err;
 	}
@@ -5266,11 +5266,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			 */
 			adapter->login_pending = false;
 
-			if (!completion_done(&adapter->init_done)) {
-				complete(&adapter->init_done);
-				adapter->init_done_rc = -EIO;
-			}
-
 			if (adapter->state == VNIC_DOWN)
 				rc = ibmvnic_reset(adapter, VNIC_RESET_PASSIVE_INIT);
 			else
@@ -5291,6 +5286,13 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 					   rc);
 				adapter->failover_pending = false;
 			}
+
+			if (!completion_done(&adapter->init_done)) {
+				complete(&adapter->init_done);
+				if (!adapter->init_done_rc)
+					adapter->init_done_rc = -EAGAIN;
+			}
+
 			break;
 		case IBMVNIC_CRQ_INIT_COMPLETE:
 			dev_info(dev, "Partner initialization complete\n");
@@ -5763,7 +5765,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		}
 
 		rc = ibmvnic_reset_init(adapter, false);
-	} while (rc == EAGAIN);
+	} while (rc == -EAGAIN);
 
 	/* We are ignoring the error from ibmvnic_reset_init() assuming that the
 	 * partner is not ready. CRQ is not active. When the partner becomes
-- 
2.26.2

