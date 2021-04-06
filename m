Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1C4354B6B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbhDFD41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:56:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232757AbhDFD40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 23:56:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1363YRxZ060096;
        Mon, 5 Apr 2021 23:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QcLfeBJWp8LN7gQrPGsgrDkrUFm8BBwCnLaMr9GDx+Q=;
 b=irw+yEI9g3BnDo+h2hkZfjN4paKB5sLrvuLL0jl4gULL50+s8/y4HcGw59J3wTwFOVdi
 uBOe3o32T5nOVH0LgnlMWf5PKUi4fgJmPu1Zg9hrI8Iu3Z221eeIA9+Z1njD9cY+ihuB
 2oKbqZQfP5NSJwVBal1SWECwwZY7xv69DFSs15zV6iyXpKRrpBu0A72oyDdlOqHTSJRI
 RU9wgf/2gwPckdsRSBmnxfe0gXpsmGhTVW2jThblqD0WqMUFXy79rgvWlX/QIP4eGFiJ
 KYPFFupxfmHNM2tTldA9oCJdomP4T4qAb75BhHJ4UK1OCtNuCAPlEref7Dp365Z0zCc4 Mw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5wac36g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Apr 2021 23:56:15 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1363r5h1026041;
        Tue, 6 Apr 2021 03:56:15 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 37q2q8w5fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:56:15 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1363uEiY25231800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 03:56:14 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40ECEC605A;
        Tue,  6 Apr 2021 03:56:14 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC34DC6057;
        Tue,  6 Apr 2021 03:56:13 +0000 (GMT)
Received: from linux-i8xm.aus.stglabs.ibm.com (unknown [9.40.195.200])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 03:56:13 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, ljp@linux.ibm.com,
        ricklind@linux.ibm.com, Dany Madden <drt@linux.ibm.com>
Subject: [PATCH] ibmvnic: Continue with reset if set link down failed
Date:   Mon,  5 Apr 2021 22:47:52 -0500
Message-Id: <20210406034752.12840-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wHY0QH_Ohj_KrpBRBo5xXK7WxAVTz4XI
X-Proofpoint-ORIG-GUID: wHY0QH_Ohj_KrpBRBo5xXK7WxAVTz4XI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_21:2021-04-01,2021-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1011 impostorscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an adapter is going thru a reset, it maybe in an unstable state that
makes a request to set link down fail. In such a case, the adapter needs
to continue on with reset to bring itself back to a stable state.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9c6438d3b3a5..e4f01a7099a0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1976,8 +1976,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 			rtnl_unlock();
 			rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
 			rtnl_lock();
-			if (rc)
-				goto out;
+			if (rc) {
+				netdev_dbg(netdev,
+					   "Setting link down failed rc=%d. Continue anyway\n", rc);
+			}
 
 			if (adapter->state == VNIC_OPEN) {
 				/* When we dropped rtnl, ibmvnic_open() got
-- 
2.26.2

