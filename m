Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D08424C76F
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 23:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgHTVyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 17:54:21 -0400
Received: from mail-bn7nam10on2096.outbound.protection.outlook.com ([40.107.92.96]:63369
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbgHTVyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 17:54:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKSpqAw6XM+doQ0kIrBiHRUFwmgHn6sZi30a0U2kSQr/Acz1HeHbyw2lsIRbBQ9/WbnjgYptte63cvp5ew51NcpRLGZNR75Nh4JMdprNIedDSryMo/dMry9+4u6yZ93LNr15qR8c7BNu8ZgJl03pQfrgEY/BRPYzlqWJ2HH0ehbD4aILBZ5Ya7VgHHLiqbvI2NwU1ndP58YNQVOL9SL8Iysl37KZMM+Lo/rIPKQFsI1XPYhh6P0B1Q6xqzvo5vuQmqMp6vrGq/w4RK7ZgwDk5GtFYbtGr5BTaUYU/FYINiTjWzz/HwbPZKCaNT1QHzeDEjOOXyh+TMDSqgbUa5WLvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqhWJsyjTle87l/PyRFpawrQfs3XvYauGOQaK3u8qns=;
 b=EC9L/5CBHbzNy9JAHkC9g0PACPHqiCoxGxPLJNTrWB1R1qZAOF3N+pEccy10rXKT5Gvve4tLlJCPjhzHNF5sFtcf6Bx/5ku9xNY+jy+a4yh+/m4C6Gn7mFQYN4dGDzrQItKrjyibCR+JDgzB8Dev7Yb0tf1Ho+788FVwqAccHYIZTLmF0wdZeZcP2sYsnH024JtbAgFjg+ZzB7ttZPuwhDVWbyFp9e9pxdjKbaIoj4GdCvxkpEaDL4+I+aa0+bmtAJKVsZ84dXMNVl2qpnNklqJ4zO5QAcvpKTs2Sb6uVM12g0C06GJdjuki5I00Wn4sEC+olDWtrLOayZICSpLvRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqhWJsyjTle87l/PyRFpawrQfs3XvYauGOQaK3u8qns=;
 b=YxrQULjmpuM+YdHwqyEdP6cEdmUIRWC3inVpMxPEwip3Tw5QBnRPJ8rSjd3GSaw/C/J38LYRvdC6L86ZkYfX5P44lqAy59qp4UVntqJnMO0PNdO7Lm48+vOqFghWgMJxUfCBDG5wS2Qu0OG99cIAjRQwocZNcyp7fQeaO2itYzs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
Received: from BYAPR21MB1333.namprd21.prod.outlook.com (2603:10b6:a03:115::15)
 by BYAPR21MB1223.namprd21.prod.outlook.com (2603:10b6:a03:107::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.7; Thu, 20 Aug
 2020 21:54:16 +0000
Received: from BYAPR21MB1333.namprd21.prod.outlook.com
 ([fe80::e1f7:9d59:6ae3:e84f]) by BYAPR21MB1333.namprd21.prod.outlook.com
 ([fe80::e1f7:9d59:6ae3:e84f%9]) with mapi id 15.20.3305.021; Thu, 20 Aug 2020
 21:54:16 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net, 1/2] hv_netvsc: Remove "unlikely" from netvsc_select_queue
Date:   Thu, 20 Aug 2020 14:53:14 -0700
Message-Id: <1597960395-1897-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1597960395-1897-1-git-send-email-haiyangz@microsoft.com>
References: <1597960395-1897-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:320:31::11) To BYAPR21MB1333.namprd21.prod.outlook.com
 (2603:10b6:a03:115::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from 255.255.255.255 (255.255.255.255) by MWHPR18CA0025.namprd18.prod.outlook.com (2603:10b6:320:31::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 21:54:15 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 176d39ad-aadc-4a89-366f-08d845539536
X-MS-TrafficTypeDiagnostic: BYAPR21MB1223:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BYAPR21MB1223202E83623CB3508C210DAC5A0@BYAPR21MB1223.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1333.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(2906002)(26005)(8676002)(16576012)(6486002)(10290500003)(186003)(83380400001)(4744005)(7846003)(5660300002)(8936002)(2616005)(110011004)(82950400001)(956004)(478600001)(316002)(66556008)(66946007)(82960400001)(66476007)(36756003)(4326008)(52116002);DIR:OUT;SFP:1102;
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176d39ad-aadc-4a89-366f-08d845539536
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1333.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 21:54:16.3583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: im5xCG4jItMignSjskNdiTVAfs5Xd6iLnvJa769Ug/frAqvvvIM9WJS4jDUdLnQPbeRpKpMUpu4pZQdRfA3n+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using vf_ops->ndo_select_queue, the number of queues of VF is
usually bigger than the synthetic NIC. This condition may happen
often.
Remove "unlikely" from the comparison of ndev->real_num_tx_queues.

Fixes: b3bf5666a510 ("hv_netvsc: defer queue selection to VF")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 787f17e2a971..0029292cdb9f 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -367,7 +367,7 @@ static u16 netvsc_select_queue(struct net_device *ndev, struct sk_buff *skb,
 	}
 	rcu_read_unlock();
 
-	while (unlikely(txq >= ndev->real_num_tx_queues))
+	while (txq >= ndev->real_num_tx_queues)
 		txq -= ndev->real_num_tx_queues;
 
 	return txq;
-- 
2.25.1

