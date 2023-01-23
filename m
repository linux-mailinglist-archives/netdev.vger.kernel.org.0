Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EE9678454
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjAWSSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjAWSSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:18:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB12CC645;
        Mon, 23 Jan 2023 10:18:40 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NI1iKW032337;
        Mon, 23 Jan 2023 18:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rOduHI9j75NcY66Gt/8WiNTHeUT21xyF119FCQ6qhA8=;
 b=CtlzphYgylWd15V6ehtZ7uK0793Y/6i7fL1ZPt5wLaEQtIa1cClpVKvv/aRv1Lz8zXI1
 cMXvWRrddxWqV8BVhrnJyPgJM3WohzATR5M3QCqHBulIvDXnrSPHari+xISRtCg0pTxl
 e1dvUlG0pS9I8u7MSVemcUyF6EVc8jWmgLoTiuZ2Y4uq2ysdukCZdw/Vk+gr9+TowaJb
 GHlLIztSOjpk2EONFNq9hUqD5gYpMKsyfdXw5M7+Ja+Cj26acZb4LpaFeI/dPnCNifeo
 h7ezw4Bwjtfmb+AgOAiyK+uotneB42lryA6WX2ag0+DPNSz67nnso8P6XG+R7tIEfbIq Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9y5frdbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:31 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30NI2FvO001372;
        Mon, 23 Jan 2023 18:18:31 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9y5frdaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:31 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30N43C1K007960;
        Mon, 23 Jan 2023 18:18:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n87p69y5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NIIPZb22020808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 18:18:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 435AB2004B;
        Mon, 23 Jan 2023 18:18:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B53A20040;
        Mon, 23 Jan 2023 18:18:24 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.149])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 18:18:24 +0000 (GMT)
From:   Jan Karcher <jaka@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
Subject: [net-next v2 1/8] net/smc: Terminate connections prior to device removal
Date:   Mon, 23 Jan 2023 19:17:45 +0100
Message-Id: <20230123181752.1068-2-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ne-OpfEby41b-QsLFUKKwofqpvlgDshy
X-Proofpoint-ORIG-GUID: vO7NrBHkMc7Ows4MFDNbLmbQsiXuUGJT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Removing an ISM device prior to terminating its associated connections
doesn't end well.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 net/smc/smc_ism.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 911fe08bc54b..28e1641f990c 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -462,11 +462,11 @@ void smcd_unregister_dev(struct smcd_dev *smcd)
 {
 	pr_warn_ratelimited("smc: removing smcd device %s\n",
 			    dev_name(&smcd->dev));
+	smcd->going_away = 1;
+	smc_smcd_terminate_all(smcd);
 	mutex_lock(&smcd_dev_list.mutex);
 	list_del_init(&smcd->list);
 	mutex_unlock(&smcd_dev_list.mutex);
-	smcd->going_away = 1;
-	smc_smcd_terminate_all(smcd);
 	destroy_workqueue(smcd->event_wq);
 
 	device_del(&smcd->dev);
-- 
2.25.1

