Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486E82DF1D5
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 22:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgLSVkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 16:40:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39018 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgLSVkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 16:40:04 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BJLWTjL182612
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 16:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uZMC2lEzJ1hnFFJUioTeWI1p/nceH2X5f45wYdJKXoc=;
 b=H79jRRmdFkzfeq/JXQkAt65j15RPM0dq4Ft731ypfI8etAPssjrYIkGvMe3H+g6o8Kf5
 O7C/APJZofEYOlU9z44VK1/SrMBf2N0u3T0UBV2ti6Q0bMrOMweaXugfxxutUIFKG+jl
 usK726WRrnyQRj5ubZkKeAVq+6wZXqU3rMyOwpFG3wUNxN+b3cOydPJwuicWEPnxwy36
 6OMbRRkcszDdJJbCsRBpsXgDUKyNGjYliMe1rJpkyFZxGwJw8nyHzVq7KzIFteIOGdTQ
 ymomFKrY7ioPMW0b9jhQvIeSWWITek64VxqLCuoboG7118va+88hnXtQzV3oJ3RFmeYq zQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35hndc415w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 16:39:22 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BJLVdu3024210
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 21:39:22 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 35h958nveb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 21:39:22 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BJLdK4i27001178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Dec 2020 21:39:20 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56855136055;
        Sat, 19 Dec 2020 21:39:20 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA45D136051;
        Sat, 19 Dec 2020 21:39:19 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.144.201])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 19 Dec 2020 21:39:19 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net] ibmvnic: fix login buffer memory leak
Date:   Sat, 19 Dec 2020 15:39:19 -0600
Message-Id: <20201219213919.21045-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-19_14:2020-12-19,2020-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 impostorscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012190157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 34f0f4e3f488 ("ibmvnic: Fix login buffer memory leaks") frees
login_rsp_buffer in release_resources() and send_login()
because handle_login_rsp() does not free it.
Commit f3ae59c0c015 ("ibmvnic: store RX and TX subCRQ handle array in
ibmvnic_adapter struct") frees login_rsp_buffer in handle_login_rsp().
It seems unnecessary to free it in release_resources() and send_login().
There are chances that handle_login_rsp returns earlier without freeing
buffers. Double-checking the buffer is harmless since
release_login_buffer and release_login_rsp_buffer will
do nothing if buffer is already freed.

Fixes: f3ae59c0c015 ("ibmvnic: store RX and TX subCRQ handle array in ibmvnic_adapter struct")
Fixes: 34f0f4e3f488 ("ibmvnic: Fix login buffer memory leaks")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index aa9b6ad14472..2cee6fea7540 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -934,6 +934,7 @@ static void release_resources(struct ibmvnic_adapter *adapter)
 	release_rx_pools(adapter);
 
 	release_napi(adapter);
+	release_login_buffer(adapter);
 	release_login_rsp_buffer(adapter);
 }
 
@@ -3730,7 +3731,9 @@ static int send_login(struct ibmvnic_adapter *adapter)
 		return -1;
 	}
 
+	release_login_buffer(adapter);
 	release_login_rsp_buffer(adapter);
+
 	client_data_len = vnic_client_data_len(adapter);
 
 	buffer_size =
-- 
2.23.0

