Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA8736291A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244931AbhDPUNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:13:51 -0400
Received: from mail-bn8nam11on2108.outbound.protection.outlook.com ([40.107.236.108]:9892
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244851AbhDPUNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:13:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1G//njUmdI0w5kWImos+cBmrN8LD2tFKlBokMWk3YXWmFApzzMRzZS2ADt9gTuP8Lgqpa6VPuZV9qlzueNPObQaoxliKfWbO3e9Jvm7Q37NLumQuSN8f6YbbPaG5MtWaQqTHSoxIkRc0LAU5bfK7vr5DVhX8a1OraP0F9m9ncHqzFgHWVOtQMuL80q+UnwlH6toFC8Rx7P++4gVSKXhEEzNPVf3Lr+fe+xyItbYuLYFNCN4rhAYI8r/u3njerowsdVTCO4C/iWwDHlC9xbv/J5ncXdK1v4oNYduss6ms5VarKJn8gjduxzyKJikzcegNel2vIuQFwfTIzFONPgYtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCqi0XaLHJIGCHEMquktyim1foBpm7E+VV37sjkAH4U=;
 b=cI2HPeZF932XGhDizMJZGPKy5hd01Ud1LFjhS6GTq041Jq5esuSu8ES+oJBaYIbTTIr7oH0KYhvmXeSKatKxRs7HsgCRLMMnUvnCl3SMMMBcuK2auLWWaupfLI9k75ciAb6uvVGMY2DO+pZAl4Ks1XuzQdXnDjJVPT52HVNOhW2RlziOnmMGlwcm9/1P9iehHpX2GBtnZdwoMPhIqYlMgR4wLYw8AYhm7LYVQYzzSr5LF4DXK907p9lcF35xeqlQ7FsuX3gOd/QlunGrPFjATtF7Zm8nj2NM7mtkGHLDatjJ1fmph+fOXjS7DV4QKJ2u+KXh3dNV2S3OOd7VMZ2Ryg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCqi0XaLHJIGCHEMquktyim1foBpm7E+VV37sjkAH4U=;
 b=UPm/6Hn2GmUcfYcNWlZPlEQJi6vSzMwxPRbNQbdMFh6zG8RgOYweQjBdGBUl2FoiIK/S8oMXAFp7oOcYCV88z31Sm3Y4VNK37apDJlZlqf57g/ltwrJu5TPu3VwhFtUiUMoqRWf/D6lbXv0KYGZUujGhiRyNLxoyrqqT6uv3+SY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by BL0PR2101MB1076.namprd21.prod.outlook.com
 (2603:10b6:207:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.4; Fri, 16 Apr
 2021 20:13:21 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962%3]) with mapi id 15.20.4065.009; Fri, 16 Apr 2021
 20:13:21 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v8 net-next 1/2] hv_netvsc: Make netvsc/VF binding check both MAC and serial number
Date:   Fri, 16 Apr 2021 13:11:58 -0700
Message-Id: <20210416201159.25807-2-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416201159.25807-1-decui@microsoft.com>
References: <20210416201159.25807-1-decui@microsoft.com>
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:f:1c9c:ebc0:6a19:ff8e]
X-ClientProxiedBy: MW4PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:303:8f::29) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:f:1c9c:ebc0:6a19:ff8e) by MW4PR03CA0024.namprd03.prod.outlook.com (2603:10b6:303:8f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 20:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0330203-ba96-48be-4df9-08d90114148f
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1076:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR2101MB1076B44644BD92D832091EBCBF4C9@BL0PR2101MB1076.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3GYKK7xj2Kj3fKkX8yiRme4wpqBe+sCUBXNe9Z9lwARZ0bwQarDASh1SETpJ3AbLCHvr1pFFpR50rM3dVwxb75y6oI3V5YhNMrhjpqMFtPfP6H1zok2oqjfulkplgInQ+mka54WFWGHyfsSJlTJkWKVMbOKVx9KXk8ygDQ7ajo6Wb4eWO9NDl5kldVxE4WBXsI6NIFC7YODf58LwJKG/Xg9znGOZ4zRUS2ahrFXKKlYcDqeNy/VujJJMOBg7MO9Y87V8UkYjOL0JWufVw79lrP8a6JcCA0aTrYztiaiBU73afoT8OxVdHglrhf/Op2uZtzgaGg3B5xttxwvcTLtDsg9dxBP/GAipeilm+UTlgTT9cRcz6SyCbAhCGtQnVLX24YE1nOOOXlvZy7cjf8mAvEJY5JrTDMeacpH1loupa/sevv/K2w3mf1WHZrJYZNdL9W33WXV+mXfa6CjcqH4MXt4r/EA33MozUTEhMjNZ3IO3276NfqjsYWNkGHCY1VT8SqAFFMIQhfo22ajfWtWFaUeMzfzd5NL4944DuPV/o3aIaOZZXzrkt5d/9jDSnCkzXmPwXEUW0HBTaVx27y4ZAO2tfhro2cliuvGDQtrq/svtNVpNxQy1vR6DeCv4vo9v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(6486002)(82960400001)(107886003)(66476007)(186003)(5660300002)(8676002)(82950400001)(36756003)(478600001)(16526019)(7416002)(316002)(66946007)(38100700002)(8936002)(6666004)(6636002)(66556008)(86362001)(52116002)(1076003)(10290500003)(2906002)(7696005)(4326008)(83380400001)(2616005)(3450700001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?X4xDz+CHeSAbkbxWN7G+dDYxsaUySpP/JwzVns0Fhl6YCqyBxEcHgjFYDbdu?=
 =?us-ascii?Q?ZqClb5HX5jxCGbY38Slk2Aj+QTudMFXFHeTKEH83LVoxULrS/Q83CwUHxKns?=
 =?us-ascii?Q?2cJ29aQGbOvA1gEr/GFuCKkzvcIZRhH72gpdSlwBYKrPwfAgCjkczTJ4j6wf?=
 =?us-ascii?Q?dkIo9Kwa6TMlvxtLwnXtNdgjUy9uv9PS+6Q+Bu2Ywwa8pTAFCSOaqbUGZxGZ?=
 =?us-ascii?Q?drn0qL5WEnv00UXtimgS3fzYFe7rv1c9d2y9pmC+eRbcE8aJxeGYnOJEtLix?=
 =?us-ascii?Q?N38aJpbuL54A4Ff2ZT/AuK4EuU10aC8+bgRooaWUkxi4wCcsLtVjCtAS4YVe?=
 =?us-ascii?Q?4m9w7JKrmv6A5xdR5/GI39pU/l6CI5RpGyH1TxS6hwwvHB77hA272labPZ7m?=
 =?us-ascii?Q?bIsCXwX9lpFSrcz/P2dhK957lGAI5YrbVXyUq/nqc8DoG+nPTTn3XVIChntP?=
 =?us-ascii?Q?AxT5261nW1widavFHresplfFTVIXKgkvezB+buzUBCaQSorRKtkne2HmnYxq?=
 =?us-ascii?Q?UJMhmxRaERQh1A2zwEJxuxN0EFGZy0JfD1UVZ5zdMNTeTbDiUHeyBCQkgG1V?=
 =?us-ascii?Q?sodIavHd8ofPuFMSzEwtccjbjoSP8DgsddOz2eTnJEh2nker5s4CQrdUx4I2?=
 =?us-ascii?Q?w4ppuDR+tFsNiANFEisxU3KDEIZgFtFgjPfIxQ0uyxAdDtH+VZ6TmT/RabPJ?=
 =?us-ascii?Q?2iUPNN8Y5VU4vDcolvCClha0kspQjNISKFG8Ht/dCcHPpUiLn+ArrF215CXP?=
 =?us-ascii?Q?bHdNRhk7dXJIWGR+S3jmn5dbMB5ihj9RNFw1oV4T/FjqIX9ft3HCyMiiwpxe?=
 =?us-ascii?Q?+vY17ZNVyP29z3b17wJQBWDyNF1tzTsiFMD9z0QbW/M0/ynrPl+92L01YtHz?=
 =?us-ascii?Q?DblUfmSlf6e5PnalbhJNdq4RikkAgaQV43U3I+uDqL5Ju635OVaTwT1J+uAT?=
 =?us-ascii?Q?WwN15VWQuDOT3ePWYx9SrHKejMhYjUgVyfESXafyadwzJjYmmgCjFTz/USzu?=
 =?us-ascii?Q?vqFt+vblrPu5eWFnhA9tdpmgkqWA8N+7GSCR/BcxIawRHV4ZQByiGrMxqvcP?=
 =?us-ascii?Q?LaH2+ODDxikotLYLnUFU+GBlvJIrNAyss4Ro6vgrWgPkTHAi7x7eEOIPRk7v?=
 =?us-ascii?Q?u5Z74kaD2CETWstJ7Wzd2FCuklbhiPp8L+fAMmnwWGygVnAgsm3lo7TPHJw2?=
 =?us-ascii?Q?c2xeo6Y0hjU++qSzrt6l6UXgPSpDOxvcyfX0hrco/XdJOt1zw+gpinGnZzWr?=
 =?us-ascii?Q?ORbS+rkWt79qYQ6sIgdMqjbsNj+9Hzf8/BI0c274eSFxLxYb2sVz1cLoJcxq?=
 =?us-ascii?Q?S2W9zmHGvFQCk8lcdvw1NRW4mOA9Yc+HOpm1mb23NRvBm24/ijeW08/NxlHx?=
 =?us-ascii?Q?/VhfX5RcZt/z4S6itYmYXCW+B+LY?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0330203-ba96-48be-4df9-08d90114148f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 20:13:20.9103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AcsAIcbu6O1Xw90DqngWpkc1Z5A2hrtqepaTrqJp5tdrDwamQ2ymwhm4PC2wHgHc8KsOpf6TiUmKNbsw3NHrVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the netvsc/VF binding logic only checks the PCI serial number.

The upcoming Microsoft Azure Network Adapter (MANA) supports multiple
net_device interfaces (each such interface is called a "vPort", and has
its unique MAC address) which are backed by the same VF PCI device, so
the binding logic should check both the MAC address and the PCI serial
number.

The change should not break any other existing VF drivers, because
Hyper-V NIC SR-IOV implementation requires the netvsc network
interface and the VF network interface have the same MAC address.

Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Co-developed-by: Shachar Raindel <shacharr@microsoft.com>
Signed-off-by: Shachar Raindel <shacharr@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 7349a70af083..f682a5572d84 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2297,6 +2297,7 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 {
 	struct device *parent = vf_netdev->dev.parent;
 	struct net_device_context *ndev_ctx;
+	struct net_device *ndev;
 	struct pci_dev *pdev;
 	u32 serial;
 
@@ -2319,8 +2320,17 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 		if (!ndev_ctx->vf_alloc)
 			continue;
 
-		if (ndev_ctx->vf_serial == serial)
-			return hv_get_drvdata(ndev_ctx->device_ctx);
+		if (ndev_ctx->vf_serial != serial)
+			continue;
+
+		ndev = hv_get_drvdata(ndev_ctx->device_ctx);
+		if (ndev->addr_len != vf_netdev->addr_len ||
+		    memcmp(ndev->perm_addr, vf_netdev->perm_addr,
+			   ndev->addr_len) != 0)
+			continue;
+
+		return ndev;
+
 	}
 
 	netdev_notice(vf_netdev,
-- 
2.25.1

