Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E662BB93D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgKTWkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729024AbgKTWky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:54 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMY9ux140862
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ULdYZyGLGafqZm6/FnKT7i+1XTNb5WYlldW+EWkoJjI=;
 b=J5kCB4JVDRlhImWbOosXUlQMwRXUWoBHPks8Sse9W8ciNhBJltn9EXrJqGcg+ruNUqjx
 0xlxpdQVsk4a9pvor338QKFA/xeLbgM6Cv4wzSXYPU4+8rFmN69I97MvDlAYawJB71qb
 +QJnm5lWM82sfVz5OohqzSUxd+OUglf5CZNxN86VocHjR5y9bnbqA3b7XMkYJakNAZZA
 Ew6ifYoXFRVgAbwiHl9C8A4KJepyNSpCzNtDO+rpipoY8gRXZgH6CzyIoOqE1wJ9xPi0
 dD28nr5xJMpEAXCCJ3LnvTO7bhqUifs3J7o/BG5/iQGoCTUfdF5SuEoMQ4M2cvcFZKxB cw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xj7v78qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:54 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMc2GN015124
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:53 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 34t6v9ss8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:53 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMeg30524882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:42 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C590C6E050;
        Fri, 20 Nov 2020 22:40:51 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F5626E054;
        Fri, 20 Nov 2020 22:40:51 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:50 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 01/15] ibmvnic: handle inconsistent login with reset
Date:   Fri, 20 Nov 2020 16:40:35 -0600
Message-Id: <20201120224049.46933-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=724 suspectscore=1 lowpriorityscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

Inconsistent login with the vnicserver is causing the device to be
removed. This does not give the device a chance to recover from error
state. This patch schedules a FATAL reset instead to bring the adapter
up.

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
2.23.0

