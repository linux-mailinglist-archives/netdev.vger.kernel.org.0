Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F6A3ADA36
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 15:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhFSNv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 09:51:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49518 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhFSNv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 09:51:57 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JDfDDW004052;
        Sat, 19 Jun 2021 13:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=ntL+n6BZrznpoEt6sWjW1bFODyvAvXbvI8WeZoIgYHw=;
 b=dP7SonCoG/5XI0hmNTNxNyA7W3D2720fu7m5jd0DV3SQZF7pY0L92gTZDyMHAD4Fx4AM
 +Mq8yA95rkuvWD9agxchYMkIuGzXrWGlmC5SyA9fh29gfPHR8cU7U04Ecvgnridh8xtO
 5/SE7j0y1HFwoae1RJxHkggkhQLujFmhQO4Wc122B+iRdhXtZ4xoD00K0+hrcoJqCozS
 mebOxsT4wFiK91bDvTn7JHmUkkzfR49P8kyf2qU52a8ozUlrbysVJ8Trdl82iG3vW9QF
 ukFcVrdgAKHNMA0UwcPpJ1TMyp6D4FfIgeiYsmN5izN9En/uGdaVM9EvThhYbmbLJ0Y4 Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bgge1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:49:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15JDf1oU108790;
        Sat, 19 Jun 2021 13:49:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3995psqky8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:49:29 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15JDnS1R122763;
        Sat, 19 Jun 2021 13:49:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3995psqkxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:49:28 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15JDnRgU020572;
        Sat, 19 Jun 2021 13:49:27 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Jun 2021 06:49:27 -0700
Date:   Sat, 19 Jun 2021 16:49:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>
Cc:     Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next 2/2] net: hns3: fix a double shift bug
Message-ID: <YM313rlzzvXqrSVQ@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YM31etbBvDRf+bgS@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: L4mMCF0rsWLTYg3_DMyAlrDooLRklaHI
X-Proofpoint-ORIG-GUID: L4mMCF0rsWLTYg3_DMyAlrDooLRklaHI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These flags are used to set and test bits like this:

	if (!test_bit(HCLGE_PTP_FLAG_TX_EN, &ptp->flags) ||

The issue is that test_bit() takes a bit number like 1, but we are
passing BIT(1) instead and it's testing BIT(BIT(1)).  This does not
cause a problem because it is always done consistently and the bit
values are very small.

Fixes: 0bf5eb788512 ("net: hns3: add support for PTP")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
index b3ca7afdaaa6..5a202b775471 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
@@ -43,9 +43,9 @@
 #define HCLGE_PTP_SEC_H_OFFSET		32u
 #define HCLGE_PTP_SEC_L_MASK		GENMASK(31, 0)
 
-#define HCLGE_PTP_FLAG_EN		BIT(0)
-#define HCLGE_PTP_FLAG_TX_EN		BIT(1)
-#define HCLGE_PTP_FLAG_RX_EN		BIT(2)
+#define HCLGE_PTP_FLAG_EN		0
+#define HCLGE_PTP_FLAG_TX_EN		1
+#define HCLGE_PTP_FLAG_RX_EN		2
 
 struct hclge_ptp {
 	struct hclge_dev *hdev;
-- 
2.30.2

