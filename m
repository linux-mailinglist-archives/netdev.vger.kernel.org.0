Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E410964DCBE
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 15:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLOONS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 09:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLOONN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 09:13:13 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2058.outbound.protection.outlook.com [40.107.249.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A072611C;
        Thu, 15 Dec 2022 06:13:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW4GsoS51FowFuG8SeZlgeOcvXySgHluUppw42v5xzSDg7y8yCjq5tEY/LmkNKtcxcPC2phSTJWb983b3fLiLBwZgg0LIEdHHYBikeDm/rPn+fL1qRymXSpy5mdVPH4EpDGGg0ZX3zKH8HgkaDiw5ZubvzMiC//Y39S6JPYsDFxBOVaUI5QW3FjmgDkOxtjVqqDh753HAMi62ZLIqqhn0WBM1uKmEHJduiIIQwU/EgW/LgLLA6zagPxBvJ61iA1/VA082HZHMFcyrW7K9Giew+4+2rBksQPy2UAnayuq3MX7UhQ0fyQQBEftwthu7lkqv6YsnQWo/fyFQn1KW+dA8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRbBwBGSJ3q9o4ZoHHUFbsYUFPBRdiTqrTMTYF5YUZ0=;
 b=nRj1+w2x9O5GcQrho3LCT6tMuXNLE0JxmxirhlMtnaeNo9XgRY1h4XRquAfoy/7LVlMFhxakaNEQNdCRNHR7QGWY0arHtRkzs53GObCd1IF28nNgfbkUon/JCVekh3YsZ1YWtSGjZygwOooF78v2J6Y83yiGAv3fNjGYKqVm5nJjHBmuW/3Piu+aZfFAIXl0exs+5h/UWqfvS08/RrTFHZukKdM6ozr1NfM3QgqvHRZa1ypxjIAh7scwC0KSDV9tdSMy7AM4xUXFZWDvHgKxczuDtsfQycvbd2qAIjIxLmYI7/9+YDefVTajAyk8jneQ577fofJiVH+gN3uDq0xVSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRbBwBGSJ3q9o4ZoHHUFbsYUFPBRdiTqrTMTYF5YUZ0=;
 b=TZpWCu1+rCfC+lFc8NzExGKmtB5da9padlD7bL87DkKJfDqix2PbcaViIPEcQUpNT3UmmquJCaaCWfEd2vf3lIg/0s8KbLG71o3QdzEbjPkUibWiS2WRrzgtaKDdU9SwImtCNthU4H0Vhn8NIT3dSxJBjW+HizGmvd66L/6Ayv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS8PR04MB7590.eurprd04.prod.outlook.com (2603:10a6:20b:23d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 14:13:10 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c%7]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 14:13:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     iommu@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] iommu/arm-smmu-v3: don't unregister on shutdown
Date:   Thu, 15 Dec 2022 16:12:51 +0200
Message-Id: <20221215141251.3688780-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221215141251.3688780-1-vladimir.oltean@nxp.com>
References: <20221215141251.3688780-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0019.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS8PR04MB7590:EE_
X-MS-Office365-Filtering-Correlation-Id: 94fef983-8354-4f00-1c90-08dadea67ee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ah+Gc8lsLEQn2bm+W6zJwRSNV84mtzu+mhQnIBfF+5taLGo8WKWo7aALk1JGChgIB3NT7qGFFtH2QHfwer8HWcVB7uP5lIaSvZOgfq+tCyPhzND5eaqNEwV5AWDtpYn/l8PbtK4N9pxhEVCj7nq3ffwoz4G8pqZOhBM+mpBsDZIZc5MwYBianZ3f4Dmj0SN0PBEjBvVKok6LK16rgmWs3pamADJrLzlVgt6xYDxMH7dykC9JVHmtTqyVfPeUMH0lZ5MpWW3VKgepOmhEb7IwCjb15hFB1J9OEB8hZe/OpYIUQ91FNKtj63gKFJ1+XIMWdGUuVNkG8gGkk4mXY7VuzT+YywvM5K/0u/+ioB3Tm7tx1gL8kIqjCzS18YDlYaRscxLhDx6htz1ea30xeeJC9HDAigERIosAhHrbgB3t9bc692jQk9UeZupnglxonImJsRr8SXefIOUxbqE+Xb/GcUb6Rk+7t/EwlQ7NtBtxu/KOItueh0ZTdE3x78NDWkfUG+mh/iPyd+TkNQakcL7kgvXJzkPruFoHamaidW6k5gQEbJlfqEMlLOX8qB72A0u8J8TlBysHT7G8nSWAdBYMlIhIolJ+ZXCmz7gBUs84/Dk9bq2cOMm4sztgHEPwiXISEemwjrZKTbn9pitPRTHul8D7TMma/7xgt9GUHP9OC0ABubR+cRuWpeA1klCi6iqULnwT7XztRtlm9kfl/gWfKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199015)(41300700001)(66946007)(8676002)(66476007)(4326008)(5660300002)(66556008)(2906002)(316002)(8936002)(6512007)(26005)(6506007)(54906003)(6486002)(186003)(52116002)(478600001)(6666004)(6916009)(38350700002)(83380400001)(2616005)(1076003)(36756003)(38100700002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0jKs7ggxJwGDfgu0NISdXbHtS3NZkVSdXNpatgtuWwMXfvvNubM+EwLhASU5?=
 =?us-ascii?Q?ZppOmHxpSc2a+9cs5uhmxWNIew6xvctXAegvkfX+21TVYy0Op5KWu+sUjNnC?=
 =?us-ascii?Q?NUtr2FuPqTjZlI8gtJcr/P3Ds0n3ErAokn+30ENJleR4ZSJBDtHY5lb+VXJI?=
 =?us-ascii?Q?wmQYFpa6YsGxy5SRFCxAqmG0qQQ6emqhdId0bHXIDf0q/JtGZM/xJXxMvbyT?=
 =?us-ascii?Q?l0kt5Xjznzcecae+MCCdUEIsj7gCQal9/3QUNrvtJzLqou9TWhaVxRHUso/b?=
 =?us-ascii?Q?Sd28VqMAQApD4vuaXdJ/dnziY7uomMlSeYE4XiiL31+01B5PVUiC/44XOfxr?=
 =?us-ascii?Q?NaWzik38pv31x2bk5nZC0y/ojUbR8QaNSfUF9Vk37hEsleCWm3WMLKTq/Oh+?=
 =?us-ascii?Q?Jp6NMLwa/FA8zbvQ6X9LpNJKWJ72hHg9+LB1uTTaERBTJSVrLjAfBQlqPbUK?=
 =?us-ascii?Q?sM3yYcQLEsxFu/t7zOpRepf6oDlG/6xv9gyM94XTzzrd8bQ9GCAREwmSwNOD?=
 =?us-ascii?Q?y+SrWC/2lkSYGQH62BJr01jwgN7bT8o6z42SL10fCo7MZf1oBbVGs3z8qdgR?=
 =?us-ascii?Q?YeVdfmS1SsMh/HyzOULCH9USCQp5b9sfCMdmgO358eF209KmnoxbwxWLSrpe?=
 =?us-ascii?Q?WaBbMc0Dg0EGZ8cW3Kv8B6Ykvbgs5ztBdSnRVgTGUkQfvuBw6/ZO48DKqLZX?=
 =?us-ascii?Q?YhKCg6+0/pjJQE4ocnJ0gMrFoboroR1Gfgy11l9Bvbgkebb45bw5JMZ7WDnF?=
 =?us-ascii?Q?pxIKvf3gvktlMYyZ1gQxwta2jwTcJMAGdna3oJVtJvbGy1iCLl2iSwBfM8oh?=
 =?us-ascii?Q?UdntCeaFshNYIsdwXv3TBXmltmgTHLxHm3WHMWo/HvCWqcJrQJKRfZzKjSjO?=
 =?us-ascii?Q?uve43n82pI/+C/lse/Y0qOlRpd/3pZ5q6zRO+UcwxHz+NCfspQwv69IPY5Nj?=
 =?us-ascii?Q?XWLpIuGfszDPqg79YmoJ/ZdrV7m7plBZgxvLsqyVFgZ/P4W3y4XIpWRfQlpo?=
 =?us-ascii?Q?z3/ixCBEQEMDcy5ZwuDX4Q+duhymw/K/l4nON5n7b3ly255TzCW9ZfqAr7Y8?=
 =?us-ascii?Q?/XzruDsUuYXvgBIHlSYyGL5HShxiVeHRtaf7ursgtmVGm0Wyq+peD7xMVgN5?=
 =?us-ascii?Q?UuwVuOsoXYHtVknx4cXMzzuD9owIeZoggZkBaTZ6zFE2sUvyYLI04tmEsVm5?=
 =?us-ascii?Q?GyZ81PnMVKSFe6JPVhY78m5YmmdcB5RutO8ZTnBEKY2RdqacJ6ZI6Ibsj3GG?=
 =?us-ascii?Q?NsYpf3N90K+EOKeQKjcOFdpovGjX/PEvxUpReV1kX3tLLVcptfw6ZfsqXFjM?=
 =?us-ascii?Q?bWc//2OBG5pvY7Vc4QrKbpKsDTzEUHRkgiZhqVZtsL8baTw9nPf5yQ5oCq/6?=
 =?us-ascii?Q?xjP7ijdmDt+xPmRxzo/Ye+2E/NP5CKlcfMajcRsFe4LihbO5lpmWeqZ8eluq?=
 =?us-ascii?Q?/xCQ+dgKer5bYUu25SYIggf16w1iBn0ahRjc49i2NOA6UCalRKOOgbyr+76b?=
 =?us-ascii?Q?XsKHmaCbZbQzzzy8aRT66qsDiHltIsW701Y3bB0nW2HenDVMEMsWEZ+tFnSG?=
 =?us-ascii?Q?U56/eqz06YlHq0MEpYGWUIhEn7pNSFX9wYm3VMODdK6k7JHtvv67sIJYFECI?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fef983-8354-4f00-1c90-08dadea67ee1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 14:13:10.3465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YsTbCZji+F6xPwn0d40h28sZp+3aT3qtnAsp5wMSuLI6ChPKRDlw8skBUzNtlZ+NwN3umdTdTHMZ2XZhtfT2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7590
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to SMMUv2, this driver calls iommu_device_unregister() from the
shutdown path, which removes the IOMMU groups with no coordination
whatsoever with their users - shutdown methods are optional in device
drivers. This can lead to NULL pointer dereferences in those drivers'
DMA API calls, or worse.

Instead of calling the full arm_smmu_device_remove() from
arm_smmu_device_shutdown(), let's pick only the relevant function call -
arm_smmu_device_disable() - more or less the reverse of
arm_smmu_device_reset() - and call just that from the shutdown path.

Fixes: 57365a04c921 ("iommu: Move bus setup to IOMMU device registration")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6d5df91c5c46..d4d8bfee9feb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3854,7 +3854,9 @@ static int arm_smmu_device_remove(struct platform_device *pdev)
 
 static void arm_smmu_device_shutdown(struct platform_device *pdev)
 {
-	arm_smmu_device_remove(pdev);
+	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
+
+	arm_smmu_device_disable(smmu);
 }
 
 static const struct of_device_id arm_smmu_of_match[] = {
-- 
2.34.1

