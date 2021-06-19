Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34883ADA32
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 15:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhFSNuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 09:50:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54886 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhFSNuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 09:50:10 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JDfCXC018641;
        Sat, 19 Jun 2021 13:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=JSRIC/0gtdDjKMCTyPLvq6kWa6OGIKcWY9IcpSmOcNg=;
 b=f/UOJwgY1tRfgQNky2z9A33aL8CuPiS1Wwcq38nnVZQ/inV529STAh5DrYKqA81p6ydE
 WLXeWvMXbFTcFhSYsGWBweUWJzBEWwDwf2f3wLpI7RixrO+UOroKsn1o/NDyAXLQ8bj1
 Y2htB5DnSGgEz959F3qtv85Evpls+rMTN5pgdWfmw/cjTIeBZ9v5mphvar6pYi7oWyQJ
 rlAzu3Qt7OO7p18erxMPIi2iasbYsVlOQYJuf5zDJGeKTFmkL75/iesOBPU2oG86dDfp
 iKjUbvV9GjGaB8BskyUv1q5uOjfrVzlXSxk2/HakhmK/BUHUiMcb0yuHNAQWL6RHxKHf 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3997600fu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:47:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15JDdrp2185039;
        Sat, 19 Jun 2021 13:47:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3997wkdhpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:47:50 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15JDlnih003808;
        Sat, 19 Jun 2021 13:47:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3997wkdhnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:47:49 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15JDllvl019694;
        Sat, 19 Jun 2021 13:47:48 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Jun 2021 06:47:46 -0700
Date:   Sat, 19 Jun 2021 16:47:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>
Cc:     Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next 1/2] net: hns3: fix different snprintf() limit
Message-ID: <YM31etbBvDRf+bgS@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: iuTRPcu7KJV0EAzXQ8yJFqSyCAC2JSpL
X-Proofpoint-GUID: iuTRPcu7KJV0EAzXQ8yJFqSyCAC2JSpL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch doesn't affect runtime at all, it's just a correctness issue.

The ptp->info.name[] buffer has 16 characters but the snprintf() limit
was capped at 32 characters.  Fortunately, HCLGE_DRIVER_NAME is "hclge"
which isn't close to 16 characters so we're fine.

Fixes: 0bf5eb788512 ("net: hns3: add support for PTP")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index b3eb8f109dbb..3b1f84502e36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -415,8 +415,6 @@ int hclge_ptp_get_ts_info(struct hnae3_handle *handle,
 
 static int hclge_ptp_create_clock(struct hclge_dev *hdev)
 {
-#define HCLGE_PTP_NAME_LEN	32
-
 	struct hclge_ptp *ptp;
 
 	ptp = devm_kzalloc(&hdev->pdev->dev, sizeof(*ptp), GFP_KERNEL);
@@ -424,7 +422,7 @@ static int hclge_ptp_create_clock(struct hclge_dev *hdev)
 		return -ENOMEM;
 
 	ptp->hdev = hdev;
-	snprintf(ptp->info.name, HCLGE_PTP_NAME_LEN, "%s",
+	snprintf(ptp->info.name, sizeof(ptp->info.name), "%s",
 		 HCLGE_DRIVER_NAME);
 	ptp->info.owner = THIS_MODULE;
 	ptp->info.max_adj = HCLGE_PTP_CYCLE_ADJ_MAX;
-- 
2.30.2

