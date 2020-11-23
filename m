Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE722C19B3
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgKWX6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728126AbgKWX6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:15 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNVtoL002785
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=2ACK52SCq7jHTyryemaZih7wH/ZGxlArOg7rPPl7MTQ=;
 b=bFtSlYYfg1xNTQ2Cg/ckzQYcSw+QqOmyP0Eh4Ok1Jm+06a8BgSQMJya9MKXPBE2CheKL
 xIU53/EkbO3fU84BJl/t1+suF5K1Q5HjrNVF4jYnkgj4XfF/AfJKuH5DSbdndQ7xdhSW
 LgSscAFvr1qWL1sAScVRPBQ9UAYS0XctvUbvvNM5wHYUqpg/Stm6NKX6FR4GFrCpU5i4
 +tCB2oHK6w9jLBPuCBeM8BWb/4fo0aykJYcChrWyyl6BsFGHbL2YDZ3RfpHEOuGbR4MP
 u0T6MAm4YeRvzGj93F6vhCcTNSOnEKqw4HdajzxOkE8aXBIlgYXbLuTGunHnb5wTX2X9 jQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34yjmpmd51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:14 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNsUUA026115
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:14 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 34xth8u0wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:13 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwCN67209680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:12 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A7CE28064;
        Mon, 23 Nov 2020 23:58:12 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17BC12805C;
        Mon, 23 Nov 2020 23:58:12 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:11 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 5/9] ibmvnic: delay next reset if hard reset fails
Date:   Mon, 23 Nov 2020 18:57:53 -0500
Message-Id: <20201123235757.6466-6-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20201123235757.6466-1-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=1 clxscore=1015 mlxlogscore=981
 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

If auto-priority failover is enabled, the backing device needs time
to settle if hard resetting fails for any reason. Add a delay of 60
seconds before retrying the hard-reset.

Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 97e01f01c458..a11af9e0a0a1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2242,6 +2242,14 @@ static void __ibmvnic_reset(struct work_struct *work)
 				rc = do_hard_reset(adapter, rwi, reset_state);
 				rtnl_unlock();
 			}
+			if (rc) {
+				/* give backing device time to settle down */
+				netdev_dbg(adapter->netdev,
+					   "[S:%d] Hard reset failed, waiting 60 secs\n",
+					   adapter->state);
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				schedule_timeout(60 * HZ);
+			}
 		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
 				adapter->from_passive_init)) {
 			rc = do_reset(adapter, rwi, reset_state);
-- 
2.26.2

