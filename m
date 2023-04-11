Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1646DD84D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDKKvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDKKvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:51:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3BE2D57;
        Tue, 11 Apr 2023 03:51:16 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33B91e07015923;
        Tue, 11 Apr 2023 10:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=1vDpu+wru2g4wIURf7mPGl6X74I9e7k9f4mx8Rddcg8=;
 b=EbGxvC+Y4jtoVHFKidG3C+ohNs9dj2TfNYWPPeFxRMzEuRq5BpBG/0pb+NcFGre4Ni5/
 pu3PlsmKsvZuwGxJBMwo409oV/CU1YmkKwSyOuTwlhLgo2JKRA1gu2MNCjgNNGFQjyy7
 c42fCfRdCyO1R+PttWYRO1LySEvEkZa8pCZZJSS2/IweORfEPL7Hdh88ryLSs+1ekqLr
 FiYOCSg+42HGFLwROveaATLjvtksro1HU6iBxXx6WhOfbvGyWF67ZDqzyIraKWkCzjHU
 yW/fQ1BF3CouGb5KehHO6YIn9ZU5LyhAEhfViRZ92Yz9YAsLwyztb9yRDKyQZYRjlT42 kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pw25xxm9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 10:51:10 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33BAB0OR024860;
        Tue, 11 Apr 2023 10:51:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pw25xxm8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 10:51:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33B1IViA017748;
        Tue, 11 Apr 2023 10:51:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pu0hdhncc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 10:51:07 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33BAp38C8258122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 10:51:03 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1F4420043;
        Tue, 11 Apr 2023 10:51:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4273D20040;
        Tue, 11 Apr 2023 10:51:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Apr 2023 10:51:03 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net/mlx5: stop waiting for PCI link if reset is required
Date:   Tue, 11 Apr 2023 12:51:02 +0200
Message-Id: <20230411105103.2835394-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zvaAoXJmYZ0EcDA_tjiNVGo7fLB4cdSy
X-Proofpoint-ORIG-GUID: 4Ld37dH-Ms6gvarzQdFtx5vARxAfiCBs
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_06,2023-04-11_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 clxscore=1011
 mlxscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304110094
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After an error on the PCI link, the driver does not need to wait
for the link to become functional again as a reset is required. Stop
the wait loop in this case to accelerate the recovery flow.

Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230403075657.168294-1-schnelle@linux.ibm.com
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

base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.37.2

