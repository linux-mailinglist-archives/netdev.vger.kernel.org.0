Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA88938276D
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbhEQIsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:48:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232924AbhEQIsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:48:39 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14H8XRvK098409;
        Mon, 17 May 2021 04:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3LGj5znCbrPn7CpI4SB4k3ul7Bsu0XXOYPTsudaEzHo=;
 b=ZVipDKlefd21tgYww4DJ2TpMOm8Ba5tNVoVfUUpm0KQm60NTanfD7MygCL6Lx1GEWo8L
 ztDpcErAn05FEBZfxXJaUpvBAn15ibVgqhaXWs7QpTJERO1FVZKsnhHIqIk2jOqKPtQT
 MjPSSGh6QdhhfJAN1Lw/JCv4afd8d9qql4YWVzvGFD2kZ5a8CghBGi6e64TYiEG6ti+u
 XrOnru4Ihis6p2gSUUbJuOwMGAV4qiAEfNqwY0skJPrTkfitJNuwvldp0QPS2AjeAfks
 1+HdJshTIEQkyJzVIjsXr8xr6zmsUFW7pez6qwbttiLP24pUat1LcfjcUKDUSB88DQQJ hA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kmbw9ge7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 04:47:20 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14H8iNfs014548;
        Mon, 17 May 2021 08:47:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 38j5jh0cgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 08:47:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14H8kl2c33882516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 08:46:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BEABA4059;
        Mon, 17 May 2021 08:47:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12065A404D;
        Mon, 17 May 2021 08:47:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 May 2021 08:47:15 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net] net/smc: remove device from smcd_dev_list after failed device_add()
Date:   Mon, 17 May 2021 10:47:06 +0200
Message-Id: <20210517084706.1620399-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WGpD02X9b3W4BW2Z2XkzhGEnm5FDMVxo
X-Proofpoint-ORIG-GUID: WGpD02X9b3W4BW2Z2XkzhGEnm5FDMVxo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_03:2021-05-12,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105170061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

If the device_add() for a smcd_dev fails, there's no cleanup step that
rolls back the earlier list_add(). The device subsequently gets freed,
and we end up with a corrupted list.

Add some error handling that removes the device from the list.

Fixes: c6ba7c9ba43d ("net/smc: add base infrastructure for SMC-D and ISM")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_ism.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 9c6e95882553..d24b96ea0eb5 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -428,6 +428,8 @@ EXPORT_SYMBOL_GPL(smcd_alloc_dev);
 
 int smcd_register_dev(struct smcd_dev *smcd)
 {
+	int rc;
+
 	mutex_lock(&smcd_dev_list.mutex);
 	if (list_empty(&smcd_dev_list.list)) {
 		u8 *system_eid = NULL;
@@ -447,7 +449,14 @@ int smcd_register_dev(struct smcd_dev *smcd)
 			    dev_name(&smcd->dev), smcd->pnetid,
 			    smcd->pnetid_by_user ? " (user defined)" : "");
 
-	return device_add(&smcd->dev);
+	rc = device_add(&smcd->dev);
+	if (rc) {
+		mutex_lock(&smcd_dev_list.mutex);
+		list_del(&smcd->list);
+		mutex_unlock(&smcd_dev_list.mutex);
+	}
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(smcd_register_dev);
 
-- 
2.25.1

