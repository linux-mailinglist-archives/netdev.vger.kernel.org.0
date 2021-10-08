Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BABA426B82
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242290AbhJHNNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:13:45 -0400
Received: from mail-oln040093003014.outbound.protection.outlook.com ([40.93.3.14]:10547
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230243AbhJHNNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 09:13:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nskpuos6bYLrVgy5jUfXfMFMEVmIicvdujoJut7ZQ3rhgXGTUxPPS9ZcvfIGcK6h4pfmj703ls233At4NBXAKkEwLpqGuR6BE9Ik4JLLpJs47N7Fu954z15I1j1fDKzU53F1SmPexGuYow9QbzIZav5FmFvIobz5OUw2g6wnGzOJ7FS5ZtzIBVJRMhVnaOlYtvUNpfqs02DNnzrd93e5RP5L8YNQkH23AX5IdirshFTfWZNGE7DTx5uTKnsHPc4t+wCWFpZClRM+wKtzBYssV3Aa4POd7YdHNzA8h+U6/5K6kDXqPuxjzWMaQ8x3QGb3Yb9O/TEgo+xNFQvextB3wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vbb3hbNGjRPvsGWxh81TtgjV9T8CD0DmVeSoy6UVbM=;
 b=isQMHAgEYvr2t/lGsbN92gqZMH176QWuRWMIXz3UB77LHoYNtPMkGA3ar68QI8Qaa469iGmhJlGE18IQdccDiVhTJ7Fb2XEyVPlLaOr+AY29oogiEYtEP7YFXeFRmp1fi55aAl11Fl63otuev8fEjzzNgFLXlGJ/CSGCNc9ij7hO/iSb2msJRht9uBdw0gP+o1cV7WBAIdEQciCJg23Yfs7hXstZtEZuyyrrA3/Yz27bgo0Gk3Unu2UuMwySZXkdR5nHn6JOxWgJxNBh0MNpXCOGDLXlY9BpKqoBcV2E6tITVK9c4P+kBrR5h9zeKDZRn6N2zw7K0T7j+T9tEbqCaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vbb3hbNGjRPvsGWxh81TtgjV9T8CD0DmVeSoy6UVbM=;
 b=Fzz4CxN9DEK3Yx4AWV7Cukn7jD1jd2ogRrb965V+GyeKJd/L18jj9sP7Mcf0oO+TkAfArI3nMpWNOrXz+wDJyiJ+K59QZC5BNX2gaco5SodzgDVCpNQEbUP57ZVDh5l02yK4W31DSV0mIb6hQW3G+KSq0udKkVKMQhobPK6SNeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM6PR21MB1529.namprd21.prod.outlook.com (2603:10b6:5:22f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.1; Fri, 8 Oct
 2021 13:11:46 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::10b6:1733:cf27:f6aa]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::10b6:1733:cf27:f6aa%6]) with mapi id 15.20.4608.010; Fri, 8 Oct 2021
 13:11:46 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2,net] net: mana: Fix error handling in mana_create_rxq()
Date:   Fri,  8 Oct 2021 06:11:31 -0700
Message-Id: <1633698691-31721-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:300:4b::20) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR02CA0010.namprd02.prod.outlook.com (2603:10b6:300:4b::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 13:11:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b800a1ba-fd87-4b60-1371-08d98a5d2e24
X-MS-TrafficTypeDiagnostic: DM6PR21MB1529:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR21MB1529FA4AB8886CB68D483B28ACB29@DM6PR21MB1529.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xp2kafR02fLyRuuqjB6xHWkyCi3KsDxazGQk0QPQoS02yoaFr1J6eXlja2VHe7IJWfOa2FZ8TU27ioi2A+7+QRiff9JCsFL+J1gdx2R6lk3nF0W+ihuap7a5aGO5NgwjiNBRzZv1nn2sFwnS4IQFgH8hvV0yZYfxm6HRSFd8fb/2Ih4qv5T15ZIj4uQqQHyDE/SDepapL7iJX0p7L+xwqo7Tf+ixEdJO5zt7X4VzaA7iWB0suvWCIWhBMBMpwcIrYvnEjPR/uc9OOLwp3DfU7XMwlScB0oaQwANzU0LDTzK5PvHbTgGVnrgL7iLKXNJx3YxsxdP8kZVNRXtDayoOyuKRkPTsaVMOlYigqOe1OsFHrDWuYZP5j0BgLqYzkxf9d+ZVbSoKPLgWKdE+ovWjbLe605O4NlFVAml2o9t+IbH8rHixPgtBQPqP/sba6rqG6E5GIozJmGEXQhxnBM22q7GjmnyYHaysneX6OT/lEi566ImSJFF9LPE8VJ29PiMmTl2YY63bOaVeVXFjkQTDpRJwV3EEK37eFl3KDQ+ZA2hqfFo6t5m23yq4PJW5KteTDxHXiRnnub75C+/dDxJsLjaXjxl+7sOWejPPQB+krPg2tuxwxK1/21LbPi0Su+FWGQcdIE0I+o/f/NN103eF8GiXsU4sXcltxl5THOOcsJCxXX+MzJF2WClAQ0Kf5KIRDJa+8ig3E1TfyOdloXkwmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(2906002)(7846003)(6666004)(36756003)(316002)(38350700002)(38100700002)(4744005)(83380400001)(6512007)(10290500003)(6506007)(66476007)(66556008)(66946007)(508600001)(52116002)(4326008)(82950400001)(8676002)(956004)(26005)(8936002)(5660300002)(82960400001)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HUvwTUht0pBIteXjRwjjhLx/TnQKXo1aQTcF1vC8lPB2FmiRUyFp7GVQwSjA?=
 =?us-ascii?Q?tuI2J0e6nbJRaCiH7dVqr9E+lZWRT2SOVtFV/z4IpN/3zwI/K3wkiENliGBA?=
 =?us-ascii?Q?yfKr6maG2+TFeDUdoRWZAMQtF7fD5kgrUCS7Oxm139d23lEOLZGxcn2AKHnE?=
 =?us-ascii?Q?e1jx0FyQoyh7+YctZh6A48iPimaZPg9M+LySQICZcD489PpQsVgkJDV4GE1T?=
 =?us-ascii?Q?nZ9k2bY4rtTd4NPyb1dsgeCs86vXtChOkuJF0hSqYunNXG9OX6rte72OtYvf?=
 =?us-ascii?Q?arwP+yCDvoalVAzjllW4QKP8QLhNtHueYuK8Q7eHQ2WpKB26V00NF2Tb4rVS?=
 =?us-ascii?Q?mKbriy8E1m7yMNjmTa6E6F4Zn6DeQG6apTlxR1Y55kFQY3yyft72bBHhgb9G?=
 =?us-ascii?Q?8Mgp5Kk+isK1T4VLXkJTgCC5yhH/GCfV9jKteDLJpT/ixDGjXbyctcQmj3NT?=
 =?us-ascii?Q?pNt/z18p48V6e+Jpnbqjaz9CRcB7rlYvzlqlHpuojgQ2QVOCDFmPeerUpBmN?=
 =?us-ascii?Q?vksESqzKbsgEThczwl8s9Re79XTvkskekT70XGllVZogYXv93YYBVulJJfgf?=
 =?us-ascii?Q?JleMLb/3E3iaMn6yN4Vw1Rl7y/8tgqMakhcEpmlMLnYjTzDTHveS6zZLxyNB?=
 =?us-ascii?Q?yNCh/gfFXk1hJQKmIrTe08UV6CNAXw/CAqpTMvCpsdCHoPugdwxbySp976to?=
 =?us-ascii?Q?UffLZa1qPr8V4WArgWMliUa+tBIcON4GyMTaKPkWy9FJsB0bP5FVRTj/Itc5?=
 =?us-ascii?Q?DUGTha1O0qaW63T5kEJKcL1M8dqMCRLiOPSSHLbZvh+xkzzQunEEqrdz6RQG?=
 =?us-ascii?Q?YOcNTrePy1+0ww71Cl6EmvffyihuHzA8gL3CSB7KPdlGlY/tmpcaCrocgybO?=
 =?us-ascii?Q?dK7SP9Q9H2I0m0uPBiosRi1GaMk2SG+lYwvmE2kPGfU2R5SQ2BeVLbGDiRgl?=
 =?us-ascii?Q?JKeJ1rPHIh4o6giE9S//4K2i42axePaweMWSchL9IRW0aDhMUVFWesY18cwy?=
 =?us-ascii?Q?LlyHXb5SlVEex7fuL/LJnAruNSDX21Agw9spVQ2fZzNyB9ecvrzu6LC2762v?=
 =?us-ascii?Q?FNk6IW4b7hMPHqAl7WiYXmBJqiWnCzYgjfWNdm4ntTv8YpWXMZ9YFsVhXDNB?=
 =?us-ascii?Q?1eeGObcnQ0gmBQmo1HbIDuFgfewGb0u2Wlc8Q+oNGKUaSbC+E9uTONbucFyv?=
 =?us-ascii?Q?mXaJD/TPTR+1mTeZpJLKFyr+C7wgcUAbPImiYwKmXMcf5BTKxYxNXbt1PmPh?=
 =?us-ascii?Q?XtMtcafMn7DEX6WSs0kE+6heJb2B9lrb3zaCGKf+EHqqFOVJzL5V/Lq/ODOQ?=
 =?us-ascii?Q?BRIXeRZgmzknVR+jX3W5vhnn?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b800a1ba-fd87-4b60-1371-08d98a5d2e24
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 13:11:46.3967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cW5XRM0NkUcg5C2HRME4q1YUxBJ/ExM/fm2MN7Pil/uBpnbGi9MJelBma2WRJJ6CchUFw8cfWItdoD+HcGqSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1529
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix error handling in mana_create_rxq() when
cq->gdma_id >= gc->max_num_cqs.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9a871192ca96..d65697c239c8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1477,8 +1477,10 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	if (err)
 		goto out;
 
-	if (cq->gdma_id >= gc->max_num_cqs)
+	if (WARN_ON(cq->gdma_id >= gc->max_num_cqs)) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-- 
2.25.1

