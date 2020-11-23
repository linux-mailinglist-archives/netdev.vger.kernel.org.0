Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3784C2C19AD
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgKWX6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728032AbgKWX6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:13 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNUxcY196078
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=/4OpCnCqvvpe996Ip9rbmfaP984dDESjB4MssPKLBjU=;
 b=tJIOcBagyOleXEiLqvTQkt0ENWqzIUrmCKmtUD6GbvIAsNntCO+A6qYtW7Yw6uZ0UW0A
 5+Selj/cx5n6bNw8MYpgRzgeizDUSkkwZyheY5QkuEsn5zcZ3xwBW7zJ+Jp8NbmqRiIL
 AamzL1KHf2+c4eKlc512IF/Pi6YmObOnNfL+8IyMANCRhzQ5Mzg9+Ng9sLR3TB0+t6QS
 sOKHivseIMmDBb+kn/RBIpZanHYiXICtZikTfQvRNGrgOSAfMDO1TSyS6HCBXiDyw38w
 8TJXCYGX8hIDN+hUhgRIS5YEV5D4kDOGhIx/R/Xct1arq2sRQ0az4pLCa9ZcJLIZeKab xw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 350pdph740-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:12 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNqd5O001411
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:11 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 34xth8ysqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:11 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwA3c13370068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:10 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EC562805C;
        Mon, 23 Nov 2020 23:58:10 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B77728059;
        Mon, 23 Nov 2020 23:58:10 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:10 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 1/9] ibmvnic: handle inconsistent login with reset
Date:   Mon, 23 Nov 2020 18:57:49 -0500
Message-Id: <20201123235757.6466-2-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20201123235757.6466-1-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 mlxlogscore=603 spamscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inconsistent login with the vnicserver is causing the device to be
removed. This does not give the device a chance to recover from error
state. This patch schedules a FATAL reset instead to bring the adapter
up.

Fixes: 032c5e82847a2 ("Driver for IBM System i/p VNIC protocol")

Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2aa40b2f225c..dcb23015b6b4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4412,7 +4412,7 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	     adapter->req_rx_add_queues !=
 	     be32_to_cpu(login_rsp->num_rxadd_subcrqs))) {
 		dev_err(dev, "FATAL: Inconsistent login and login rsp\n");
-		ibmvnic_remove(adapter->vdev);
+		ibmvnic_reset(adapter, VNIC_RESET_FATAL);
 		return -EIO;
 	}
 	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
-- 
2.26.2

