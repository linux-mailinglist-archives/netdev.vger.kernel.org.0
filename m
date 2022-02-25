Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE4C4C3E60
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237810AbiBYGY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237806AbiBYGYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:24:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5416F2692C2
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:24:22 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P2USMx009436
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pDtCehD/VDjEj+fl+faxx1P8PQ4uEQ7lz+KF57XkzkM=;
 b=Ml9EjLiwsC+8VC+VpN+XY8uoy8ymX5lRHJs84WDA1bSMJcJ3HJKjl650UquBS1BAPZH0
 KFohem9SLRcq2K9R7sOXCkBxt2lFogpq66E9mkhhlzJBMzKlqVjFohy6qH6Nj5AvJcx/
 JKUIUG+JhuymjHoJ5kk+XKoU7Olo7TX9aQpkSYO+h+SQelFlb9GxBwk0KPEQRZE34rYa
 ev9kMDI7J59SJf6JH0qyHPM67PBqq07lovfy8zVb0hF9rwFoIE7NmSQgKcfY4Kx0IPfa
 KbZ9HaeylTwl7Bl4TFZEnV+Y9HObuLuGxzIRYoqWFfOPHxAv6Lig7pCnZv21lFTyA8sP aw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edh6y631t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:21 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P6MeQ3019393
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:20 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3edr933xet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:20 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P6OJgS34079176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:24:19 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7871413605E;
        Fri, 25 Feb 2022 06:24:19 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D346136051;
        Fri, 25 Feb 2022 06:24:18 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 06:24:18 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 5/8] ibmvnic: register netdev after init of adapter
Date:   Thu, 24 Feb 2022 22:23:55 -0800
Message-Id: <20220225062358.1435652-6-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225062358.1435652-1-sukadev@linux.ibm.com>
References: <20220225062358.1435652-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ryxb9mnmTBXi2sZnWtcsScyZNg59o1jy
X-Proofpoint-ORIG-GUID: ryxb9mnmTBXi2sZnWtcsScyZNg59o1jy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_05,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202250030
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finish initializing the adapter before registering netdev so state
is consistent.

Fixes: c26eba03e407 ("ibmvnic: Update reset infrastructure to support tunable parameters")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d461d2bffef1..1d1fd4b41f80 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5822,12 +5822,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		goto ibmvnic_dev_file_err;
 
 	netif_carrier_off(netdev);
-	rc = register_netdev(netdev);
-	if (rc) {
-		dev_err(&dev->dev, "failed to register netdev rc=%d\n", rc);
-		goto ibmvnic_register_fail;
-	}
-	dev_info(&dev->dev, "ibmvnic registered\n");
 
 	if (init_success) {
 		adapter->state = VNIC_PROBED;
@@ -5840,6 +5834,14 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	adapter->wait_for_reset = false;
 	adapter->last_reset_time = jiffies;
+
+	rc = register_netdev(netdev);
+	if (rc) {
+		dev_err(&dev->dev, "failed to register netdev rc=%d\n", rc);
+		goto ibmvnic_register_fail;
+	}
+	dev_info(&dev->dev, "ibmvnic registered\n");
+
 	return 0;
 
 ibmvnic_register_fail:
-- 
2.27.0

