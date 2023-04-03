Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED576D3E7C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 09:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjDCH5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 03:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjDCH5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 03:57:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9797FE6;
        Mon,  3 Apr 2023 00:57:11 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3336QW3w024232;
        Mon, 3 Apr 2023 07:57:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YdnMwkUzrc1nb3ZjPZ9/4LYT9dsKuEGu0ZW1tbsxwrM=;
 b=FC1ifGw/j8tZDR1rlCspjnCxym/ZUD1DtrscT/GzN37qj04nTaXXUN3ss/nVJiq3uwKj
 hTdwqO0rlbQlyGQgIF6E5n8c+ZBIsDvsPjuxRzpy4OYv087UNAYj4mDhmLgCi6YiW89T
 LkjsJ8fCmQcBouXYnjXt6Gtpg15hfPUPpWyn6MjS00/tLWQEBcOjfEmbsLk99Ys5+Bbw
 SxGRiGb5roagY2FuATfki8hilTDwZLY0bMgxIxZWuyVCRhHZCfE6brbN53zQEO2t7M7a
 Yn/4OwB7t3tkTmzYXn57/NwMZyQfFJq4nKHnkkJdz6GOYQAx/iGr4yVg1wx9dDkzYEfu xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ppxf78pwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 07:57:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3337IYYj028032;
        Mon, 3 Apr 2023 07:57:03 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ppxf78pvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 07:57:03 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3332OCEL015082;
        Mon, 3 Apr 2023 07:57:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3ppc8712ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 07:57:01 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3337uvs718154174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 07:56:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78AA820043;
        Mon,  3 Apr 2023 07:56:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 337F020040;
        Mon,  3 Apr 2023 07:56:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 07:56:57 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: stop waiting for PCI link if reset is required
Date:   Mon,  3 Apr 2023 09:56:56 +0200
Message-Id: <20230403075657.168294-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CLIiDkG56GBiyFPv8unp_FXTbc_CM9Gh
X-Proofpoint-ORIG-GUID: zpYQrEWcmu7FPuGX05_3WOtrFlCfYVzO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_04,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030057
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

after an error on the PCI link, the driver does not need to wait
for the link to become functional again as a reset is required. Stop
the wait loop in this case to accelerate the recovery flow.

Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index f9438d4e43ca..81ca44e0705a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -325,6 +325,8 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
 	while (sensor_pci_not_working(dev)) {
 		if (time_after(jiffies, end))
 			return -ETIMEDOUT;
+		if (pci_channel_offline(dev->pdev))
+			return -EIO;
 		msleep(100);
 	}
 	return 0;
@@ -332,10 +334,16 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
 
 static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
 {
+	int rc;
+
 	mlx5_core_warn(dev, "handling bad device here\n");
 	mlx5_handle_bad_state(dev);
-	if (mlx5_health_wait_pci_up(dev)) {
-		mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
+	rc = mlx5_health_wait_pci_up(dev);
+	if (rc) {
+		if (rc == -ETIMEDOUT)
+			mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
+		else
+			mlx5_core_err(dev, "health recovery flow aborted, PCI channel offline\n");
 		return -EIO;
 	}
 	mlx5_core_err(dev, "starting health recovery flow\n");

base-commit: 7e364e56293bb98cae1b55fd835f5991c4e96e7d
-- 
2.37.2

