Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6F3308458
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhA2Dr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:47:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62378 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231608AbhA2Dr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:47:56 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10T3VmSg128838
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 22:47:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2FX03czCma/f4Vhbt++j1HugH9TgBFm92zgo0ZZHqc4=;
 b=Y64oTHY3DjJtrtWopQHNieF3VDEx+d6DM4n8wtyrCN6T30PTI3euIU+y4Z17aDtmzuMN
 FReWHxgqJt3B6mjWjWH93oi9uLsavmZ2fvNoqmkI2vNJt8A9Jty4rmtH73WZ5bYxi/JW
 qqk1JzsAWRaCXj+aIKxNcs56VVW8LvQMMPewNeUPE/UyRE8nryM5u6RrG0Jv2qvBE20p
 3ZbALUO+4rnx5d4W9EJ7InQVPvS/jFTiVbjRdRGLzh5+Dt0xiJYS0S0DblJAaWIwVyyk
 PApuyeZa56EHQxGWqodQXbUbBMSqWwqaue5EgFWozKJsNboiviBlE5uqtXw0VWEDH/Ir sA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36c6kbdc8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 22:47:15 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10T3WqER003972
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 03:47:15 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 36a3qc9dbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 03:47:15 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10T3lE9k30343434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 03:47:14 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB5BAAE05C;
        Fri, 29 Jan 2021 03:47:13 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F7FAAE063;
        Fri, 29 Jan 2021 03:47:13 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.183.51])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Jan 2021 03:47:13 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com,
        sukadev@linux.ibm.com
Subject: [PATCH net 2/2] ibmvnic: fix race with multiple open/close
Date:   Thu, 28 Jan 2021 19:47:11 -0800
Message-Id: <20210129034711.518250-2-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129034711.518250-1-sukadev@linux.ibm.com>
References: <20210129034711.518250-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_12:2021-01-28,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=926 adultscore=0 malwarescore=0 spamscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101290015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If two or more instances of 'ip link set' commands race and first one
already brings the interface up (or down), the subsequent instances
can simply return without redoing the up/down operation.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
Tested-by: Abdul Haleem <abdhalee@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cb7ddfefb03e..84b772921f35 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1219,6 +1219,13 @@ static int ibmvnic_open(struct net_device *netdev)
 		goto out;
 	}
 
+	/* If adapter is already open, we don't have to do anything. */
+	if (adapter->state == VNIC_OPEN) {
+		netdev_dbg(netdev, "[S:%d] adapter already open\n",
+			   adapter->state);
+		return 0;
+	}
+
 	if (adapter->state != VNIC_CLOSED) {
 		rc = ibmvnic_login(netdev);
 		if (rc)
@@ -1392,6 +1399,12 @@ static int ibmvnic_close(struct net_device *netdev)
 		return 0;
 	}
 
+	/* If adapter is already closed, we don't have to do anything. */
+	if (adapter->state == VNIC_CLOSED) {
+		netdev_dbg(netdev, "[S:%d] adapter already closed\n",
+			   adapter->state);
+		return 0;
+	}
 	rc = __ibmvnic_close(netdev);
 	ibmvnic_cleanup(netdev);
 
-- 
2.26.2

