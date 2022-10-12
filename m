Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF205FCF0B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 01:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiJLXuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 19:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLXun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 19:50:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E119E6BA;
        Wed, 12 Oct 2022 16:50:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CMxCiD018337;
        Wed, 12 Oct 2022 23:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=TO2rT4QW5sSLO3uUF5zSXceKqy+NzNsukctRQKypwjM=;
 b=EagXag9MqBZB8N6GlCoPS3XTPu/vAtnNSX7uhbtDP3UL1B7v8ncl53JEAMJRjKLoq0Dk
 bHm6/XHKFXhxEvtuYob3+1f33YCIB7nECWtor/eDKeI2rFSJ9i1/r2khoLVkK8NoNP/s
 rWy0B5jJyxvIHXlpN6UATGM/sNpK0GGZp0sBn+2ZkM9a9l75UeB5dTDlgkcfWtR6HHlf
 B+/rufwWoYCdTqIy7KLZJ102N0dV2Pw/bIianA7jtJ1ZmRJva0sdXFRenPNFuEyHqyxk
 PmkWy3AIbD17V5Fs5SvOWUGOM+N4lJlRDq9LWeIoINgae/OZv4BFi2epn/kZAi7kiZoi 0A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k30ttbjm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 23:50:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29CNZp0N025010;
        Wed, 12 Oct 2022 23:50:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn53dun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 23:50:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CNoY51024951;
        Wed, 12 Oct 2022 23:50:34 GMT
Received: from akolappa-linux.us.oracle.com (dhcp-10-159-236-166.vpn.oracle.com [10.159.236.166])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3k2yn53duh-1;
        Wed, 12 Oct 2022 23:50:34 +0000
From:   Aru Kolappan <aru.kolappan@oracle.com>
To:     leon@kernel.org, jgg@ziepe.ca, saeedm@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     manjunath.b.patil@oracle.com, rama.nichanamatlu@oracle.com,
        aru.kolappan@oracle.com
Subject: [PATCH  1/1] net/mlx5: add dynamic logging for mlx5_dump_err_cqe
Date:   Wed, 12 Oct 2022 16:52:52 -0700
Message-Id: <1665618772-11048-1-git-send-email-aru.kolappan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_12,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=898 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120148
X-Proofpoint-GUID: xatjI9Naqecl5-zrpOnhFnKcg89AsXmq
X-Proofpoint-ORIG-GUID: xatjI9Naqecl5-zrpOnhFnKcg89AsXmq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arumugam Kolappan <aru.kolappan@oracle.com>

Presently, mlx5 driver dumps error CQE by default for few syndromes. Some
syndromes are expected due to application behavior[Ex: REMOTE_ACCESS_ERR
for revoking rkey before RDMA operation is completed]. There is no option
to disable the log if the application decided to do so. This patch
converts the log into dynamic print and by default, this debug print is
disabled. Users can enable/disable this logging at runtime if needed.

Suggested-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Signed-off-by: Arumugam Kolappan <aru.kolappan@oracle.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 2 +-
 include/linux/mlx5/cq.h         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index be189e0..890cdc3 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -269,7 +269,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 
 static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
 {
-	mlx5_ib_warn(dev, "dump error cqe\n");
+	mlx5_ib_dbg(dev, "dump error cqe\n");
 	mlx5_dump_err_cqe(dev->mdev, cqe);
 }
 
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index cb15308..2eae88a 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -198,8 +198,8 @@ int mlx5_core_modify_cq_moderation(struct mlx5_core_dev *dev,
 static inline void mlx5_dump_err_cqe(struct mlx5_core_dev *dev,
 				     struct mlx5_err_cqe *err_cqe)
 {
-	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, err_cqe,
-		       sizeof(*err_cqe), false);
+	print_hex_dump_debug("", DUMP_PREFIX_OFFSET, 16, 1, err_cqe,
+			     sizeof(*err_cqe), false);
 }
 int mlx5_debug_cq_add(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq);
 void mlx5_debug_cq_remove(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq);
-- 
1.8.3.1

