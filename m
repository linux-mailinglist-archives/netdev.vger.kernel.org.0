Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84A631D0B8
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhBPTJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:09:41 -0500
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:51168
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231236AbhBPTJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 14:09:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNN6xXsRpxSXzYU8y9sRr8v2gXbXu6EVNQ/NjTUdk6DrASc+gPIr3M/Ol10iKl1v5Pr9+Qe+0wJQ+O9h9WVMpTPj0Z8xEYHWg/+uJjPl8Ioeg683wW8FWL2y9+n7J62h2oz7Ad0ZX1x9NCJ17G7CnRBjhLuhCVtkZWEBAxoHru6HIuXUsgCXoscLffV6eU7WZCgT/107XxS4d2uPjoo04PEWjHC5u7XLyvAWtZ0BK2d9ISg1DMKIcCYTzA95bgGJ9m2aWne1Pcohk6jY8JbJrWk4ys1JXD1nBxiCpVgCjkg2T5KJ6xxIjeh6YFGfHK5c5qPyPf/cHRIl8JtAKezj9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0LNsyiMZVZ4TKwsOk1oNTqslbwWUaCQ7+gv+tx3T6Y=;
 b=h3anAlbO6A5+33SuLfcrympldpIP+i7GjM6OstkYEO3YC3FA+gsNFhERQ8BR23hYvEDUn3M8NIFIYjkkkvpzd7WE8Qlkx/e2yd5R6W38206HoFI6eie7ByMhLh4Eq0U7fcLzDvoBEEupvMoK+wSeY9y6KVVif0guxfvipfJ33EOzT5QA7o0dq3FJChc/JRhSV6Csmt/KeQjY2T4Sq0oFvNc/kPhIJ8rvxk3hHiT313rBWnXXmu6BWodkbut59jNcGCWVhFaESAteMg06tUsssdjVbuJczBQn6RRCG+2qFbO8mXRVKDZgcWVKpPe/JsvynoVplx1/NI4Ms1PpkAOC0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0LNsyiMZVZ4TKwsOk1oNTqslbwWUaCQ7+gv+tx3T6Y=;
 b=Rvg3L3/h4mkEmJ74W8/V8SD9jy6JKYJrXoqfhSn8K8ZNt0MfxWyRLQvUN1UKl785hqCzYLKlwXNMuZi2awN/QHhFzGaymDW7/fek+Wm/cxgrfIR/IvPCvcwQJzJ4BIXf5IjQ0SKMOi+pNbIizgieSsfGYv+1t4UwjDKtaJc4FdM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BL0PR12MB2484.namprd12.prod.outlook.com (2603:10b6:207:4e::19)
 by MN2PR12MB4112.namprd12.prod.outlook.com (2603:10b6:208:19a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Tue, 16 Feb
 2021 19:08:22 +0000
Received: from BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2]) by BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2%6]) with mapi id 15.20.3846.031; Tue, 16 Feb 2021
 19:08:22 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [net,v2, 4/4] net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP
Date:   Wed, 17 Feb 2021 00:37:10 +0530
Message-Id: <20210216190710.2911856-5-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
References: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::16) To BL0PR12MB2484.namprd12.prod.outlook.com
 (2603:10b6:207:4e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 16 Feb 2021 19:08:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45ff2d9e-0107-4d30-6471-08d8d2ae3a63
X-MS-TrafficTypeDiagnostic: MN2PR12MB4112:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4112E6FD80329D5AE055F8E39A879@MN2PR12MB4112.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7RRB9f6k7JCnlvNlW6NMTaKPO5fIN6QDOGixKOloHZq4c5/6El8dkmHXIky58Wj8ujqdUVrcDlwvAjNGqr2uENtmNYt6W9rdLXD22WTrf8i2dU74+EXVxHuNlignWIqamTICE2GI+UFi1rAsSc0aKnX4opmoikCKm2jAUQ0ve/8f/Dw6W48iQN3PgtLIhBmnh1ZUUKhsOxJ6NW0u/bEqB++jpPxCZZcbPtf0/8IsZaL1u92gonDHlmkblEhjif9SwRFGuwnDaRejtyyJzi7+jU/yC4k/cT8gLTYv4ldohq8WDNA8epjnEt97v+5ZBDxjh5njrlFHZoZ/vkZI7Ir79MubGWDO6wk30OxARYFbZ1r33Df3UwSYu4vwHNrwiFZdhclAYBK49IwGP+YNn/lHGJjkkhhC8GAEdw04M35bjwPwp121uvQ14GQyMvMUE5DWRn01xxxbTQJOcsOYI4ZjhzWYGAkM42ewiBOAW+LApbJHqoS+7frP5XTtWafPC6ICoJgtrkMSp3uPeEBuwwxu8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2484.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(7696005)(54906003)(1076003)(83380400001)(8936002)(86362001)(6666004)(66476007)(2906002)(4326008)(8676002)(52116002)(5660300002)(478600001)(110136005)(186003)(26005)(956004)(66946007)(2616005)(316002)(16526019)(66556008)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AO3WNrxRlgzkwACeaVarCokd1vkejUToKyNlt5MkxBY/hHtimoik9g8EEdgM?=
 =?us-ascii?Q?EDWgXm4R4fTDVq7KQZ/GeaNDb1gqb+gpaRmP/EyQFqHbILQftgbK/NfDskKJ?=
 =?us-ascii?Q?6faAVX5qJmyihz9LxRAQ4s3n0R/wABEv1jW9lSDH4baa/7AKJGSQCPrxENgL?=
 =?us-ascii?Q?smscQQlrljPKDdIY5yKVFyrHy816L465X1f5zrbjKBEbJP0ZxwIHvipE1l0L?=
 =?us-ascii?Q?3mRCako1+G0az3Te8xRj+DDNP91GKRjiaWvnr8v492G7OpfwZz5R8cVd8fIF?=
 =?us-ascii?Q?Oidm1y7f0qQ5QiUfYIC+PFr/0s5L/xAqYWyMP1NAI2jF98Fa80I6wNwlEErS?=
 =?us-ascii?Q?5VxvrZ8fbhl4Np+idGSzgF+Fr2t4MNLe/D9lDX7gOlNz2WAjzJQm2Gsgsu2d?=
 =?us-ascii?Q?+iy/GzKLg0GnZ8z1ajXH5EOEErjXR+aKDsIOEDOnoJuICCTOJFEOCcC4n4jm?=
 =?us-ascii?Q?jhhiVoGuQGmWZK7gusiY7Q/stfOMsYcZPOFnH8e0r9DJwbVw0HAN4jzwhEzv?=
 =?us-ascii?Q?nxPUtF1dcHt58AwryQQo5MJeNLmM5zeL6hjwR/kV7ZR1SaXxM7Ha8JDiGXCP?=
 =?us-ascii?Q?Rq1Uj6pRLJ1ATE9LRmSHZSPoqNLnSEDUKRQrVjrEHPlNoLr6SY6rawwpiBLM?=
 =?us-ascii?Q?pvTsQD6vrkSBynSPdzRViUwsPvOPaQO+JfkCOWFchCcIsxAJAb8hAXeg2a26?=
 =?us-ascii?Q?L753pUbYh+QaAKCXyCPvHJ3uRy7tVrdB3NDB9rTHNioSHSfVMDCK955+PY6x?=
 =?us-ascii?Q?TNV97CCKIHXJYgqmFSxr7ic2F7jpyJ2QQwaxO51r5GIS2ZPZK9KTOYy1UkDZ?=
 =?us-ascii?Q?2LUORNOgZXYiT8i9PsRqoykKYRUL8BxLGsF9+WPwKE6CpE4WMDloLKY6rpT/?=
 =?us-ascii?Q?S9E7MT51Kt1yyoqzIobVgXxhWaBzwMdASV2pO5j/y9w0KlFS25En2COAoZ0K?=
 =?us-ascii?Q?6vOhOoZfQyOBzcAUO4EUN+xMZobTQyBpOPzooXUF0G/1beYznyTTdk3E2omE?=
 =?us-ascii?Q?nXJCUIE8rMUbPPARoXGi2948e6vn0i8Q4H//sYpEW1CPs78zIMuWEAIUgXkP?=
 =?us-ascii?Q?HXLYNEj6dLXC4s7i2A8gtHT1Z8ehdhtxVAsCv5PoXdBBbaOmNT8XFxZ+Bq7t?=
 =?us-ascii?Q?7xeo4uSCzt8upu9miypTfFcbNvCzjGuvbeSRTJr4DFim/eV1vhUdWWZPmlXE?=
 =?us-ascii?Q?uXwhfsnRQa46C1FIpHwbbQ//VeEK5xxWYQq68XWoJz0xkvGG1WilZHTcCGV2?=
 =?us-ascii?Q?YWISxoIaRziU7bdLs8UJlBhRlA4xZATqxrNrwvIJ+5rxsm9foUIEHeLJX6AB?=
 =?us-ascii?Q?wrnpR+givUxDydc8LzFCzNu8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ff2d9e-0107-4d30-6471-08d8d2ae3a63
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2484.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 19:08:22.3157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZltXnej/4LCDYnO0yeAaSmHq8zplwqs0LyJL/5h/QlAIHGfWE9r49ieaP0I9H/FlHvcqpgRjBRWQy5cDhPB1MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frequent link up/down events can happen when a Bel Fuse SFP part is
connected to the amd-xgbe device. Try to avoid the frequent link
issues by resetting the PHY as documented in Bel Fuse SFP datasheets.

Fixes: e722ec82374b ("amd-xgbe: Update the BelFuse quirk to support SGMII")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
---
v1->v2:
- Add Co-Developed-by: and Fixes: tag
- Use genphy_soft_reset() as suggested by Florian.

 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index d3f72faecd1d..18e48b3bc402 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -922,6 +922,9 @@ static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
 	if ((phy_id & 0xfffffff0) != 0x03625d10)
 		return false;
 
+	/* Reset PHY - wait for self-clearing reset bit to clear */
+	genphy_soft_reset(phy_data->phydev);
+
 	/* Disable RGMII mode */
 	phy_write(phy_data->phydev, 0x18, 0x7007);
 	reg = phy_read(phy_data->phydev, 0x18);
-- 
2.25.1

