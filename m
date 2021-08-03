Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546593DF067
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhHCOgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:36:54 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:54849
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236421AbhHCOgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 10:36:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJbCHMab/vVJf7cA6qXveYmAoejlQhx2gMrMEKM4Ok2B872dxUDLpeScvDESSh/nbs6KOpIRKPZbwhDqukQ5d40bypOcpjgbdXGPm3O6NeNcickeOR+jfH2uS8T51Unwp25vieuhl7c+HSrbmn+2MK9Pbis1RBO8lmnReWBJCVbmUksGpLTJ6kODMcyRk6DbFPOmdUHwypABSH4pNlm7VfcgQPXKyheze+6UuTjBG/DOlAeCyK0poVBo540EX93bowdmzLj9f9p42xeHavRdOobfK0tfzYStkJPNnVubsLMT5F2sUfxcc1gFMkp6spNnLIBtmaZKyzgkL31RDL+Gaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDhe/ij4rTZ0Je5WU3iFaXb1JNRet7j6pWQ+pmHmBpU=;
 b=deP8r8xd3Nhu3S3q3yFio89zdo8tUunfuSXnDdUHsg70V6GhWsEfzWFcWiFm1NHr8VDWjXoVJpK34kXplqatADXitf5PD1sw8l1lpRgCmkmC1YfHLcFz/MVNZ5lz/IbF/xHCRQnqqnMvv2YvDxwJzyhHXmWknZjAyluCIS7vcNV62IOc6POSwdcwRLl5sv6Sioz5HXlf7jxhGm5d5aEGCP1iXMj5DaK/qr1XnR6CL4myA1ZpyI8kTaq4qaT9UqUMP5Vj8JGJhaYc6nlJuaUoE7XzhoFAEWXEs2vgZcszc4w9rTNNRSQdW3623yHCIjzvz3XQkNaz9puZB7dHiLyUFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDhe/ij4rTZ0Je5WU3iFaXb1JNRet7j6pWQ+pmHmBpU=;
 b=qQaVOvQABV0lcWbUwScoSRhlnfyiD4DUqB6q7UvwYKldljO1s1CL6mCoeyjWlHdwy9+sPBy4X41C6UUER78VEbxU2ik6N7O0qTPQDvwVOS6pCWda2XWYPUbD51rBotElgq6CeCI0wik1R3h2gZ7eDQBjp2Wm0c8HUairjrZ6Lz0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 14:36:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 14:36:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH net-next 2/2] Revert "net: build all switchdev drivers as modules when the bridge is a module"
Date:   Tue,  3 Aug 2021 17:36:24 +0300
Message-Id: <20210803143624.1135002-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
References: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:36:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6691b366-ae32-49eb-1649-08d9568c1b1c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797C90666314DC471F17436E0F09@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mW74xRoSf8rYW5VAbQfuupnn9t9rZeAdbMlsltuoyuxZw/jS9UxY6cRGpre9xeOVEXhmo+GLmd7q/2RI/JeMh734t6PQecjqyV34QqaavdcVMXeHm0ZnX4vV0RtNg1pIeND7q1Vgz4gGzlUQrV6SNSXuBx3qV2pgiEeEDJSmdrQnsenA3MC4fbfr4KSvyELZGI1rqxkqcucld/zrRbrn4BQAxZ6mq3baWZ3Qj7RAmw2y9nNppJqMTwRXR07ypwzo+jACiEHJBkz9j8oDCxtpDgaEP/6UIf509TAal6QOuIKcBr5iafhNj6ixtLMN7mCg7dXZWJTNSG69zZP4Pk86KHNT3dJVSMXiEMr4HKxHoe7IsXiiVELev8h1EI5PDulv8R/YlLzPvC9UpjB7T5XYrGWfDcrIh280fpjQUVlbF4+COVwtKhkfxyAeh1AjrIDzOi7x4nd48qwwjJ8yz/a5uhaTSfVEf0U50CZXIdQTJxsE53hiIE4ZEfp5KabEx3cvjAID/A9RIPDJJie6CoBnHU2mXWaIC1b1/gXNaR8yiNZ7DCg7z/SvUIFodj7fsVSuRHRHKhobNxpLAKrm0CDy+T9nkwrl/x6ffaSc8EBzSeiA9/8ONp/TUR2D3UN9Qq5fWg0lOXjgyBeZhmSgE5+Cs+1QKVHKK9vO3vPyjHRT+W7/Bi143BUFF/JTTbfQ+Zrr6fvEsSce7r/nQ7L6TWBoPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(52116002)(38350700002)(38100700002)(956004)(54906003)(6512007)(2906002)(44832011)(2616005)(110136005)(26005)(6486002)(7416002)(6506007)(1076003)(8936002)(316002)(186003)(86362001)(66556008)(66476007)(36756003)(478600001)(66946007)(5660300002)(8676002)(4326008)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f2+XTB+OxmuHr4qM8qZgtUK1SxsasUnDvglUSw5sUTPbclRqpE/1m2Wc85pP?=
 =?us-ascii?Q?km5LWbYENfezLxrUSrMV3uXJoPOoXy/t4qb/x8tmJgDPoNs0KdjvKmtc85Ms?=
 =?us-ascii?Q?fQjmWqmhFN2u6LanZPdU1wfmT3tLroWqyK0I88z6OSOW8rgjHSiMTEnMRr+Q?=
 =?us-ascii?Q?ThWZlWga2qm2FfMObnH6WKJnm8/KhASv0ZAV2oFk3fk4xYWIUobOH4+QAyKT?=
 =?us-ascii?Q?o8Mgi2FlC3MPKuhQqNRDAd8TvcDhucqeeloPqV+HDxv3JH5258fhWqO+gqoD?=
 =?us-ascii?Q?NEBsgs5sr/XqYwCFysgnWf0rG7vKC/uuRsfypiODMAum7JirlYz4nkFzqyT5?=
 =?us-ascii?Q?wQVVC8z+o8fmH8nJkfg2R1eVsFUgx/d0PTESngBDQtcSKfdl/Rh8/NxBCpTB?=
 =?us-ascii?Q?kr7Y4mbiiPewzNCBB7kWUrzsm4WHg60E/CewpH67ERAnB2PieqiGS+MmsqcU?=
 =?us-ascii?Q?+Su58v24Y8D2sUP0ERdoDtctarqLWRF6Jfda3BSxu9Mr/PClUZF5+/XFMb+J?=
 =?us-ascii?Q?dV/J5kIt53bz5/Oy1SAf7zTKF7WObkkzMe4xd5xQdTNwbIKAsQFhW1Mcc56a?=
 =?us-ascii?Q?hYmfTiM72JssOYKNyuAMdD8g49bzwkHIZGkNFmr2zoAIdryEwuJKw0aVjwem?=
 =?us-ascii?Q?rpQDHsvlp9aq4SOX65guu1KwZZC6ce8t+E6lhmiS08g7LwAY7bK6a1JV7Z5U?=
 =?us-ascii?Q?WYvItoTxjfjv4bt9UJiUCZs1b5L9mEO0XxAO0Hk8vXhm+JQn4sl5wro9zr/E?=
 =?us-ascii?Q?tiCPHP3i+tijYfjox2yzyeNz/v2j8S9DGztcNA6EzCwYDZcKgjnLSS9ff4dz?=
 =?us-ascii?Q?KAqhQQ0ap1fHdI78AFAv5auCuH+L4/4tlQbBiW36f6rr6ryQXQISH97MI1S3?=
 =?us-ascii?Q?zja4fi2Mg9aVR6isKL0Y5XFmBacyfEg9vQI7IL6GtASXz40S0OiF0xSlPQXd?=
 =?us-ascii?Q?hY53x52UrNtbkhBPvo1uqWA2sP9t4Da+rWCuMheyxpYphFGlIX2HYaVcLWXJ?=
 =?us-ascii?Q?tA9USywA2F9vSDozj08nNLZpubL3jpHNXRL49RFeT28golSrtOUSl6PawtEL?=
 =?us-ascii?Q?wKLkg0q7/3LLlFzeYi/14YY+42KFmkZ0zhShW0yVaR8KlZ7r5q9c9VlZrpYo?=
 =?us-ascii?Q?H5vPpYutsNmhSskmtLHLhZnqrxjUnsz0r+mgLGGOmRGNmXrbw2CcCnen7Jun?=
 =?us-ascii?Q?BvYEh/2s/MDC29kBFmwDVuiR/FYNVsX09ANEIbUz8qJBKQ5BV6azqeNJUuBR?=
 =?us-ascii?Q?+orOukj6tdfLSGBZ8fU4g4W8N2QWQU5dSzdHoj9Hvd75tWA/uzitAdYJBPrQ?=
 =?us-ascii?Q?cimTjbIrRprIINEUhNgBQV66?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6691b366-ae32-49eb-1649-08d9568c1b1c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:36:40.1500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlpq53QxWT2dL8irX9ijKik5Pyvdl94pV5dsjKMcK4G6LTDUjXGkXbnugDbZiasKkJFyNwV/IZf34+vJzA4tEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b0e81817629a496854ff1799f6cbd89597db65fd. Explicit
driver dependency on the bridge is no longer needed since
switchdev_bridge_port_{,un}offload() is no longer implemented by the
bridge driver but by switchdev.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig | 1 -
 drivers/net/ethernet/ti/Kconfig               | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
index d39ae2a6fb49..7bdbb2d09a14 100644
--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -1,6 +1,5 @@
 config SPARX5_SWITCH
 	tristate "Sparx5 switch driver"
-	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
 	depends on OF
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 7ac8e5ecbe97..affcf92cd3aa 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -64,7 +64,6 @@ config TI_CPSW
 config TI_CPSW_SWITCHDEV
 	tristate "TI CPSW Switch Support with switchdev"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
-	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on TI_CPTS || !TI_CPTS
 	select PAGE_POOL
@@ -110,7 +109,6 @@ config TI_K3_AM65_CPSW_NUSS
 config TI_K3_AM65_CPSW_SWITCHDEV
 	bool "TI K3 AM654x/J721E CPSW Switch mode support"
 	depends on TI_K3_AM65_CPSW_NUSS
-	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	help
 	 This enables switchdev support for TI K3 CPSWxG Ethernet
-- 
2.25.1

