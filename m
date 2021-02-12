Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3EB31A423
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhBLSBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:01:52 -0500
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:11840
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231131AbhBLSBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:01:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWQZi3QUa2xeKKVAnd+LFwv6d8Rhv5rZ7q1sdhMkioIMpO9O3TuItxFgpvGRk39Z9EeG9OlkK/wp8iy+3VJexDT/7Rc9yWqnc9WmEaGDUyAvUDax4gcFV6tCuShjOSUzftG7ZNkEB2qKgiqW+aRocyzsE5NfSv4vEiVONSzIOPQ1YsLliu1XkxE/zkxQLFY+7Uo6Zcz2uYILtISwT5VRKOKv+DJUyWVmSpCvFrmXBCK8+4lNlUa6svK442dGj4cHfDR9B8rquyvGarUIKilwYEEKeI2W/Hks2Kq0iapGIuHFtFNx5UyxajBhopIbImttUxSQiw6oPhkXcWAOv9WWIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqwXqrKLzKGS9LSaWbxj3tjzZqGxcvqKh2pjXHS9cJ0=;
 b=HwjnkQojSDitSw4Ix9pOdFPyiuMOx++IdSaFa4CBwYTAifoBH+FeCi268WxbNFy0aEOp63O9jmulVKByvcZOr3QeRb08J0ASPw2rEHvIY4ROqdptaM2Ns/nV9khw3XOSfAgiJc9MSolIkk6dufh4UMakQExe5ASGpyReuKjOFnQg3cWyitgLdYFgRAW9jcQZwyMhdztaXPpRwdfx/D9TSwfRjHYVutBAmxdJ/r9iIrETON1e1j1Vg4kv7lKCrkEppZ6IJPtGRlZFEJ7a9jTZR6jo7A+OuphVRgyhNI/4W6Lgj+W8uwz+QurwBdUj/wDepIbmut1eebHIHoBrIyiOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqwXqrKLzKGS9LSaWbxj3tjzZqGxcvqKh2pjXHS9cJ0=;
 b=v+hZ6tvg1d8U7qDDx+R4jU4t6mD+5aMhTMCoiRZDrTeFavpNkSeieHss3NMSOyri2ins5GM+vQxHkcHdEviqtfTvdZBBux9tX80yJpx1zKSjBA3wZV4iX63gUjq0ypEky3WZsnRp3/jlyiY5mnp8X/rd6jOwA0H5fjHU00ZUQN8=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2495.namprd12.prod.outlook.com (2603:10b6:802:32::17)
 by SA0PR12MB4397.namprd12.prod.outlook.com (2603:10b6:806:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Fri, 12 Feb
 2021 18:01:00 +0000
Received: from SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451]) by SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451%3]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 18:01:00 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH 4/4] amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP
Date:   Fri, 12 Feb 2021 23:30:10 +0530
Message-Id: <20210212180010.221129-5-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::31) To SN1PR12MB2495.namprd12.prod.outlook.com
 (2603:10b6:802:32::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 18:00:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d378727-f3c1-4b58-7ea2-08d8cf802784
X-MS-TrafficTypeDiagnostic: SA0PR12MB4397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4397D10C7A8E02B516452A379A8B9@SA0PR12MB4397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3J6JpR81Qxy5rkGEZ7DvMBqQDz2MakSsAZ3a3vndiTWtyNr7Uc69jEO16/hBCRhkS6isvkKGXf0EmWfpDALxHaTTL04RP0gpGsdUNmoT67HmnlQ7B3ExpXEH3FEo9PFRjB6GzISMErv/YOHdeJXYEbxQ4RSOJw1CLOhybwFtRsApXI3+d0wvk0SQ5zlTxariM/Dybqkd8NHNu8TIf4uq5+Qi0T8igEfl2ytNlplxVg1WPMaEwnt6sAaBO77j8Bi6IFD3VyYE8k5jowxVqoujjfLS8oNAvuzq0EHyGbCSupjL/hLVQh9R162GKQxZyVfg6+pi82MnF715uM1glKIyKAF37co5SqJTGBnoX3fgyadArG/YH2Wy+8KvWBo/pSFE++stqsicY3F2rTOCKNZQCqseqTomGQamHDgFQHT1aYKuRQreiqRP571akqM3XVdDuhJZ+GIhoVluEizYduKqz3tE7vT2cNM+/evRldBmCobA2EVpzNOLJ9bfAo3r6s5YPC03SfMvOmXdOEHnIFjlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2495.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(8936002)(8676002)(52116002)(956004)(26005)(2616005)(7696005)(110136005)(6666004)(16526019)(478600001)(2906002)(66476007)(86362001)(6486002)(1076003)(186003)(316002)(66556008)(54906003)(36756003)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2QlhjpoXb7n/b7UpvwX7psGVDG6zL35XB3VVpuDsT/L4auzxKS9pQbWzMzno?=
 =?us-ascii?Q?ySQ+rrwALr9pJIzxKLTnx1n5CELnjQSKTBq2DAM9pZGW9EsJ7MNGGHTaYjn8?=
 =?us-ascii?Q?N5LuzOXuco35Qj3PvO3Htrul1ArsFujKo0WJBekdDMkYNtmnhJSUs7N/iiwz?=
 =?us-ascii?Q?8sr0V7q9YV56KU4MrqiNDuAUkzdpitePyNzgGj0pn24n1YqtbO7Wy0oMiXoF?=
 =?us-ascii?Q?hQLJrD9k6FJI7NWYz1wnS0lV4ZB8zqfk8GP5GoMfll+bJ0HsW+KNmovWTlck?=
 =?us-ascii?Q?ywP3DgUK+heluQfa70F76o3dw5VhC8G8cIGHAg1xz2wDr+EHH4L5E+VRAq/F?=
 =?us-ascii?Q?POwKtY5uz0RlG5dRZsvIHh/lG5OI0MuUgsv0GIwlXZVyrndbkAJoE7xP6mtR?=
 =?us-ascii?Q?crTXtb8DAhMfDkqdn3V3FbXK/8kyAdKh7n2usmCe2/Mq/zrKwFYiMFQHeYO8?=
 =?us-ascii?Q?Q4Sz8F/Ue27wMFXgcl+FjpVUZmZBHN1LHWQ1Uq2lP8uxO4yKtARQZZt8eYJC?=
 =?us-ascii?Q?43z/Fo4MXz9k4evVRuLkvivbkWBmL3lqYvqvwEIbvKmta6flk+r+UCRlaIvh?=
 =?us-ascii?Q?+z4E17I/EPb2qlHC8AWd99S4XDkPvuayTkvw8T8YyxRGZe8ne7NWDyTERMSI?=
 =?us-ascii?Q?VPrMFbNj+xE9yr1e41EgWeoGtZjaL7UZ9Chn4+s1w0fjWRM/ZGLzvXOQ/yyS?=
 =?us-ascii?Q?Xp+3EPfOe8M3efr1oViJx+sD8Z3Ib7S1qMXkE+miWkxDTIqQMIc4BWN6siCC?=
 =?us-ascii?Q?jAQPhXuED374Mq3LazWX5oUGj3GOwz2VOrPJNIfdC6DWG3ZL1K2lgdT7OcFG?=
 =?us-ascii?Q?zYZotHMA2A+HIDKP8NB4T9SGdEKnmxAgsUqB9m8I7UOpT57muG+Cxwm8ADdL?=
 =?us-ascii?Q?mVORNmmH8Adx5BK3FAqQiuO3usEKGX4npqoWJMpLyt4W92lBP1tRr0p9L9wQ?=
 =?us-ascii?Q?J1XyQVogs2Nz1uZs3KiLGa0MvryNgJk8HXNIkimdd3euZG2zl/tahvvYP+z4?=
 =?us-ascii?Q?ps2pzXNUUaS4RjirN+pL4siVEqoSi6CGIo2r8t0aKNlyW4u3Z/a4pyM0fqwM?=
 =?us-ascii?Q?O0vZCjVa14d1t3DFFl1DkAsFoOd6dVfmk3+KWUpQ9ycKK48b44I1akt0tsi/?=
 =?us-ascii?Q?+dPBhoqa3yMWyBjBE5NE60WGrRFf9Eiz3b5aa2NolwB7DaGbatYKXK/KlkDn?=
 =?us-ascii?Q?TZMzQ2iUDbo83O09w3Cx4i2TDziLoFA0X6G/neoS6FPSVXsEAGlIYgDDL1pc?=
 =?us-ascii?Q?zf6Rm1fChePzqW5eSDN37hP9VBuRV5mu/etzTb7cSn7fpj+tOpuiAeovTy9N?=
 =?us-ascii?Q?Qp2HrFKIod5tk8ha9z3i6oew?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d378727-f3c1-4b58-7ea2-08d8cf802784
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2495.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 18:01:00.2651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5bipoY0TQTi+M55XVQhaXg6KBo6vtUJaBbpeJmh7nVAgrQ0in6NtRrX/J5I2TP8JU14IIemPWJeBUR8dgFMzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4397
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frequent link up/down events can happen when a Bel Fuse SFP part is
connected to the amd-xgbe device. Try to avoid the frequent link
issues by resetting the PHY as documented in Bel Fuse SFP datasheets.

Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 1bb468ac9635..e328fd9bd294 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -922,6 +922,12 @@ static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
 	if ((phy_id & 0xfffffff0) != 0x03625d10)
 		return false;
 
+	/* Reset PHY - wait for self-clearing reset bit to clear */
+	reg = phy_read(phy_data->phydev, 0x00);
+	phy_write(phy_data->phydev, 0x00, reg | 0x8000);
+	read_poll_timeout(phy_read, reg, !(reg & 0x8000) || reg < 0,
+			  10000, 50000, true, phy_data->phydev, 0x0);
+
 	/* Disable RGMII mode */
 	phy_write(phy_data->phydev, 0x18, 0x7007);
 	reg = phy_read(phy_data->phydev, 0x18);
-- 
2.25.1

