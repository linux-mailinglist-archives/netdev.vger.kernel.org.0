Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EB34865AD
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbiAFN7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:59:30 -0500
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:44357
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239519AbiAFN71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 08:59:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nb+c1CSnSxx+YD5dvopAbbgDIH8aMG64HaLmnVmN90T+Ay0KqAwduoATCoWHb02oXSxTDH34o+kMGKu2sa2vh0HKPF0iE8QWR34ViFaS3id272KXAkjMPMLYYRq8PAcX7edw8SAlX6B6ZxRP+2txsaxEJD1CFUX+WsoHQrrmBomtQssVeDJpKI0S/sc3kE51VihS92z/XKB52J+ehGJJy+MugQPalCjCPPv110CD9Yh0hkV0GdrDTt0baQrvqilEJ0a0UvvesL67ZR84EanQSn9w9dc704jCPEjElUvK28dcs8xhNPZdrhMl/W5f8VK15WAUEA001SoDLflusWigvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXbK9ZbsC6HAgBkbWrhUEHNp+xj+Gzx0pJBYnCm137M=;
 b=O1GjX3hJp6HOOpVGaPnZ9Qg0t0ThlJ0X5D6B51WdsDvH2A44cC85V2yruJRqQrSI1VIIwkCl/dmZtqp5UwN1Jp/R2iN9sMIf1Ok3mBAi0YnJEJ9XoS5QDdWpuM7P5moLFk4d2yEFyleAbkHXpuFhSfwKnNzq0fcTJWk7UxLG7BSTQgiTB7s9z16pgXtdvlEJJ3aPNDfLGSfSgxDZfYCQn+kf3mdF7jfJ7xY9oAOS9Qlt2JN5dFusTF0x56wOR/soJ8V8J4Tb4xtQSOiQgFq6l6OPqUbm4q7f3oclH/Ce2lDgQIxGpBsHY4nS6mEPFKAv3Q4Ukk1CKfkXo8Ko2xeygw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXbK9ZbsC6HAgBkbWrhUEHNp+xj+Gzx0pJBYnCm137M=;
 b=bYDLvE/jmw9Ibx3y6EMS+dkJEOjKr8MhYtnkP7EdskG+unzGDb/a7WyFck1kjEDp8AYKfiEHhbDnEgD3iPBfiQi7lo8IaNSFqmiUX32vEnacAndZhWidCwzPmTk8dNa0Uf1W7HyQuYhwbyg8m+rFizX2NP/7Pc5KH5IEe4ED3rU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AS4PR04MB9267.eurprd04.prod.outlook.com (2603:10a6:20b:4e2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 13:59:25 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9%3]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 13:59:25 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, robert-ionut.alexa@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/3] dpaa2-mac: return -EPROBE_DEFER from dpaa2_mac_open in case the fwnode is not set
Date:   Thu,  6 Jan 2022 15:59:04 +0200
Message-Id: <20220106135905.81923-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106135905.81923-1-ioana.ciornei@nxp.com>
References: <20220106135905.81923-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0114.eurprd04.prod.outlook.com
 (2603:10a6:208:55::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90ac6215-f699-4e15-1ac1-08d9d11cbf67
X-MS-TrafficTypeDiagnostic: AS4PR04MB9267:EE_
X-Microsoft-Antispam-PRVS: <AS4PR04MB92672819750528D750A78939E04C9@AS4PR04MB9267.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 683sY3A0QeIFT92DlvTGxPKwT1ugQ3r6uLSNNHyuoRuLzBE557lkvhc3afxPZBXIv1YY0Z73M8meV3t7psACxzi+9n7jsNVgqJlcFXhe1ERRnhGW4Wj6VWBNa8sq/aT3j+1qGe9bndhTpXvsVt81ey6z3xHOG2I7SYTEb7Wcm5+TLhsviH2SzocRTMtj9hRreFZIXrWZpwURrEgbORXUL/jR5fTqFGxv1lnR9aN3MSMZasZZVR4pyByT3LhP7ZKiuyd4gpmJ6E9H/42aiD7TFD/ITXc9WtNlxmvJg0hDyGOpyFpn0YrBfm/34GdZRyvoJZWcHHyi5mRF+LLxJyqc4Ua+i1yyf8/fGeH0B2ZveRNhNV6A7/wNmgXJC90p0whKc8w8zMDyZrhuvY3ZCCbPf/GqsPRASz8/U9va/F2X8gezwX9Vo8wSHFgOPIriaWYlo53lzEYQmkuhf5SKD8TAtD+XJwlKF4opYkHqkp8+m91Oesi/p8AphRnoyj7YyIkoFeRxZ7QlnU9SS1Q93NQts4UwhpRv2E4zVo4buI/ZdwYC4VCbQegg+JtJwkIXrgxZc9VNNiN9qsZ0aNmNy+51CaKKQv5s89IwDsmx/Egmbpq2gsU1i+EM4AAK3jUQt7MpgIwn2whsUC7HY0li5zYTOvcUp30sM/WnRnCm0UuDaxIrc5KL3fwCOQwoM6Ei5U4/ah5HQORl3syZfS1EsdNH0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6506007)(6512007)(66556008)(6486002)(66946007)(66476007)(6666004)(2616005)(4326008)(44832011)(186003)(508600001)(26005)(38350700002)(38100700002)(83380400001)(52116002)(316002)(36756003)(8676002)(2906002)(8936002)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gUKz1Pt0Ki5nsM0SydS9+oZerdRhunFLVaXw7v1BfxOhfk/DuRW6IA1Y7mbR?=
 =?us-ascii?Q?c5F/yjyUFZbkyo3kBc/bYp8ZVcA0ok5ibsCKOMZ7vpEg92nLuzNbNIqNxqeX?=
 =?us-ascii?Q?iRybueLPxEaoCLCIXeadUpNGnpR39Om6Y3+OW0N5+PGMv5MMy9dxALD8UvdV?=
 =?us-ascii?Q?WUxwUvA6FPfyjceu9kuWRN7uEbITYre9eWOGTDppOFkfOt/PjCUW/3aaTYfW?=
 =?us-ascii?Q?7lK+8CwoFfUBcOV3Jeiz86XkDPx82hjDiOaDFy9thm1Rg/mcjNVhnBNDMxHf?=
 =?us-ascii?Q?EpVBTZIAIsP0QUZNA9qQSAYJL/Hcktwmg4jVmRAspgC8uUZoKvNGhf3p+kbB?=
 =?us-ascii?Q?MXt755kNTG4QBOf9CfXQK6lh99VqOs6dVfekVJVxQhBlz3kUW1aSrsnzGL1p?=
 =?us-ascii?Q?Pt6K5SwFqL8Sks7LZ+cPODW1CZj2zjGyOIMiiHTes6aULoIZ4vqeW1O8qhum?=
 =?us-ascii?Q?zh5ROwsw4Cov/vIf0/zzuzqX7lac3HnuQPFVKQ5DXw2M90Y7Xi+9tZfsgp/J?=
 =?us-ascii?Q?zj4zRxm5wo0wH4Aoa8uix6e68Vc3X94Y+0hFXVeLJrlE1/yi8e9Tv0aEp/uq?=
 =?us-ascii?Q?JGALQVRn4vfqttIuGJBe76XEdWJGKQerB+3fkcCMOCOnAuqn41U+16A+ftOG?=
 =?us-ascii?Q?V7NSuVxpH+4dbSAJLMr455lFeWWIO2UfKrlzKjPQJ3MMWcr8JYgi1dHU0WQH?=
 =?us-ascii?Q?cJwTqNYspPvOdk1/lpY0tGpmKAZg5PVU/uF97rpUUxYghKw3+KZJJwcbUofR?=
 =?us-ascii?Q?9DUfCXBB72o6K2CvCpFhx6yrX6eEz8C9BBOhNvRAMPGzrRKkVqzaa4TYI5+0?=
 =?us-ascii?Q?lRiefN977Tvqc4VNAu1CqLSGrnTuEo5oA23h7o05+3igethXcc7G+cqZkdw1?=
 =?us-ascii?Q?0RbzMIcZoRIAbqT0EYs+WRpl2MMlYlpDffa5Ajpe1xW0tKOmGQLBk729JrAj?=
 =?us-ascii?Q?18yCRIgjIBlK4ZpVsYZvp6hj8d3++JAs2SSVnJjUwzzfSn1zFfamUIbSZrQY?=
 =?us-ascii?Q?N/bk8XSSKS3Hr9DU1rfnRdKXIOd50pj3GjQOEEWqQiU7yLkvMFcJpHgbm2ft?=
 =?us-ascii?Q?s/NxVdrcgdlS4yeyHELn8LIqDv8h4v1aS8y5oEsVtEoQllioUQJvGU3eKjb0?=
 =?us-ascii?Q?chhKu3iI6kfw+Ckjj6E909zTa0p5a/Eo0my4AtJYAQturGHCaTYiwv3IMaAV?=
 =?us-ascii?Q?q47jJ+IYBvxoxcW8JwHnBWkpQhXoRCUAUdEXNUPnCVI1ldyJrpgozGPmaJ7k?=
 =?us-ascii?Q?wkLKyPmZXnylc54Pk5C5jmbdXwjH+IuW1UdEf694Emk5AaAV4hBgkmlCPgI7?=
 =?us-ascii?Q?17lmuKt1PI1lUqa2VtcZYUGPXRSxx2QKr/SxmGDRO3zJC88ndX+BbHprfD7q?=
 =?us-ascii?Q?aThoAWvaB2GkqzcF5vScxj93j/7KhX9QgKwjjzWxNo8DfPWjUjSTyxE4ncuR?=
 =?us-ascii?Q?M7+iZWWUNOE6GdBktntvQmyUMKGwPiLt6ijxBssqdipEjdcB9p7PplI8o8MA?=
 =?us-ascii?Q?CjsT4POSsgTjZj5aJs4E3hf7ksdNK3T3M+h0Ey1itcA2sc0xvrm2qNsm/iYK?=
 =?us-ascii?Q?ROuFDYD23DN8j2zaGqqn8/DbL3Sp892SSFrRYoZzg36NL1xMkpFDASqsm0JL?=
 =?us-ascii?Q?bYfidGOBlHlsGfGTfd/2+kQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ac6215-f699-4e15-1ac1-08d9d11cbf67
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 13:59:25.1703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnKVqwV/zoW9H/ug87iFowZQyM/zTmgse3DPGbxLoXcKRGTe521G9kwy1xITz5Twm9qW5Frn0cG1S++ZkNluZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We could get into a situation when the fwnode of the parent device is
not yet set because its probe didn't yet finish. When this happens, any
caller of the dpaa2_mac_open() will not have the fwnode available, thus
cause problems at the PHY connect time.

Avoid this by just returning -EPROBE_DEFER from the dpaa2_mac_open when
this happens.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index e80376c6e55e..623d113b6581 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -54,6 +54,12 @@ static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
 		parent = of_fwnode_handle(dpmacs);
 	} else if (is_acpi_node(fwnode)) {
 		parent = fwnode;
+	} else {
+		/* The root dprc device didn't yet get to finalize it's probe,
+		 * thus the fwnode field is not yet set. Defer probe if we are
+		 * facing this situation.
+		 */
+		return ERR_PTR(-EPROBE_DEFER);
 	}
 
 	if (!parent)
@@ -330,6 +336,7 @@ int dpaa2_mac_open(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
+	struct fwnode_handle *fw_node;
 	int err;
 
 	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
@@ -349,7 +356,13 @@ int dpaa2_mac_open(struct dpaa2_mac *mac)
 	/* Find the device node representing the MAC device and link the device
 	 * behind the associated netdev to it.
 	 */
-	mac->fw_node = dpaa2_mac_get_node(&mac->mc_dev->dev, mac->attr.id);
+	fw_node = dpaa2_mac_get_node(&mac->mc_dev->dev, mac->attr.id);
+	if (IS_ERR(fw_node)) {
+		err = PTR_ERR(fw_node);
+		goto err_close_dpmac;
+	}
+
+	mac->fw_node = fw_node;
 	net_dev->dev.of_node = to_of_node(mac->fw_node);
 
 	return 0;
-- 
2.33.1

