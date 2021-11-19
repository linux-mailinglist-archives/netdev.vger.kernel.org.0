Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8058457839
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbhKSVmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 16:42:42 -0500
Received: from mail-sn1anam02on2114.outbound.protection.outlook.com ([40.107.96.114]:1767
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235669AbhKSVmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 16:42:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOl+/+JQrSSdIaydTFQp0AANOY6Ia+2vHJrsK8aNWQeT4ANrd4t+RUKZ8EDCcdorGVDbiFgObmkNissK46XpQSrbCPW5XZ2CdX9MV+2KbqNG3jRq7iTneyk4Au8jeKVXhbuZFoktiQOx3yuICfDZPG+gHT9mD/KfzctNW5Wo1/MmTekorB47Pw/Yaaa0oP5dVNXTNtQNJyk/l2EVsuKt2tmQPJxPl733YgAVb/KV3MGzcoKEe4+pNua+ZHMYBAjFA00ZTnFqA8+vW8+DsWXSofhaVdU+6LIaSTcBXalKiSmAlnJ3pgvX3uczylzQcjop++qygxIiLYwNjvTg4V8x6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0u+wWrT3V4Ay60W1QM0XIrBrkY8EhY/HzkYbzr+oVc=;
 b=D66jN1aIvULCb9ZjL4sJsyA39BGObyyGUfad+CXze2Wi8KMkACrl/JxL1vFiabZb4ySLJpAXS3hhBQyU93TbCFKZpr4cQ+G3GXgRH2MDV3qSjnr8H9k328nOvUhLWnuKRoOi+cMtk9OOBuvSIkMj4cF/f27Wpc3uKhKHJNoJ7nko41MBW8UHaqIVRF6Nd2T8Sqq2T3CUHj7ey8YNmVB6GIA+tz4zgtrmBipBHJHALXWb4oT8mOREO0/KxrP04AbV1q6JguTr3orup9qWNmoxH5b89yN1kYlgCGC9sYkm+ENI2Vu5EY/2Lm6soWOA3eTsuqlf+XoLI2FeUi9SP2sqFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0u+wWrT3V4Ay60W1QM0XIrBrkY8EhY/HzkYbzr+oVc=;
 b=H1ZUZbkiPmzhfFfZqno6We9b9FPQEGxU1MHsYZEDuFIxOoseESEwZO0Uc5El452mFKPMYr5xnHdUj537uwHld1OPyjOPMd9eUiazr6CPD6VrSu9k0uYtouG3Nk6pIwIJYTfU88EUNijRNF5bjGUPq4ERmlFcYJZAd0D7habtXM8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2304.namprd10.prod.outlook.com
 (2603:10b6:301:2e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 19 Nov
 2021 21:39:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 21:39:28 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v1 net-next 0/3] update seville to use shared mdio driver
Date:   Fri, 19 Nov 2021 13:39:15 -0800
Message-Id: <20211119213918.2707530-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0376.namprd04.prod.outlook.com
 (2603:10b6:303:81::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0376.namprd04.prod.outlook.com (2603:10b6:303:81::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 21:39:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84f5975d-ef28-40ab-af1d-08d9aba5100e
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2304:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB23041D83181C6B24F0536F1BA49C9@MWHPR1001MB2304.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FdSdQ8D89LLTeinkhBbrv6aUKOd3ZYgodsrwzJzENGbdP8GwiBSRQDcz/JeU/tkCt2B5NyoykWW6Wx4L1pKV2a5zqLakBp6l7QC0nYZGtXGxZEJdvanPBChhFIrzQdVWIao2eQ8XCgTigboyTbh22AfwRtr/bz3nHSAsVS+XvFisRFmi6r4A6bIEW8iNryXMo1LllFm8BDCwxxOQTnHlbW2iJhTH9Ju6yrdLngs37okeemGZWBX49FTVplxJlWlZjNrbANmwZSyBtveHHUlYBS+g6s0GZWan1X5MMRnV/O6vQD72PBN1s1XEeemayKXwh3iGeYpQz/rAdKbvxsMIsOhPkIvwRpPzqwzPMzyanWtQqX4T+xH74ce6oct5mnPLkwfTjJh3ztlJdITYGSlqbeOwaWmnLOdRf0lXX60qcI8Q3wiUxCg0xZ3+KfKdnbANaiB07jNES4ZMlUYJxbQ9DcxMWw7TI8gJ5ng1XWEdDdVhO4VySmT2d/+Kwlaort7nOLmYFQvpwNr7/vJWtAlndGCHu7xGxzJmTvGF22bn9ufjvnZrEr5HpeWqKKf8JnEgzmYLgoIeDE94FFODM3Oh9KTnTP18MAg4szWAW32MBdEOoQ+Bf1IOru6qt5gep2LwDWFb3iYJvq6MWNYumeIkYlj5K7yOQzwtMQ2ZuvO/hURn2lURg3747ZcKp2rCaL6fxWI3nikvQuxYCz9ixwnJKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(366004)(346002)(136003)(376002)(6486002)(186003)(2616005)(956004)(26005)(38100700002)(7416002)(8676002)(6512007)(83380400001)(38350700002)(8936002)(54906003)(4326008)(6666004)(1076003)(6506007)(66946007)(66556008)(66476007)(5660300002)(2906002)(36756003)(316002)(508600001)(86362001)(52116002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fNe9COQ6AU9hN+JnKdgGo9/7rdDXfaoOabRHACm+vrrXo0rd2DLKZXn42hFf?=
 =?us-ascii?Q?SznZccFYVvMz15MyIf1dGyL+gWydSwSfCbQtBlF6EpCqf4iyPs4qLj5KZ9Od?=
 =?us-ascii?Q?PoKhqu5fP1Jra9kEV6fmKybXOEmLqq4tf4WcrMt9gbgNF/0QYo0AfStya9ae?=
 =?us-ascii?Q?jTNI/MUAEHEWXOGgwY7KnwAjpLUAhD1sJGIHh8UIgY8R7a6Il6xXnLmR2v7w?=
 =?us-ascii?Q?kLPzY21bV/vjGYtZZLTTkSH8GPg1GaEsplcz/OooSrDmfRU30jndK4TCr/Q0?=
 =?us-ascii?Q?LF2MmSAPekJl4tNnsL2aQrqcoyLJy4VJ6PCVj+FRt0XbRZldWwI471+fs0Da?=
 =?us-ascii?Q?WfB2Kvi0z54VO5kTHmYD6kRrqRR/QSqbjnjdcgiCmBChzell+Ia4dTuBPQET?=
 =?us-ascii?Q?FlmcbgXU0MRmXbZuBiNmT0yosim2Hz1DDfGoUc5XpjpEkXivGRctVkssBw6D?=
 =?us-ascii?Q?Ja9pFFNRDBe4lyXEWUSxIFpcpb0AaYR03OVnOMdfGwuO+ix22HJmBOJEvn1s?=
 =?us-ascii?Q?Tbx6axl2hYr5eA/Zz2Jk+GQWBH5Rh7hxvh/TVmkjlASPCz4DGJubA7VMquZG?=
 =?us-ascii?Q?SZqApU3oFOiz82z+q4dVX7/1gKP8k0B8UpjBGA16veHaAr5WJAIoyV9AlzZ/?=
 =?us-ascii?Q?/hwoQ4lSfX4o9CvePoMkI/RFqHGUlsr4uwt3hZqyD63I/ZNkiEpywUqpUfIZ?=
 =?us-ascii?Q?1v9RO4vihgqlcx6V41c5G6AAVpFoLmbiGfOjl2H7IoRHapJYfbW1P/5qvPEB?=
 =?us-ascii?Q?zSMW9ccYATTNwtcZRIj29yQnzHcHGpwTQH+5hZn+2rAW9FrG6wlaUUlQONcq?=
 =?us-ascii?Q?J9/K25YaFSqwHV8NzWJwUsjb13B/GbiLMkeZUCXghIm72T+Ge9jYZOC+YV14?=
 =?us-ascii?Q?QMgjiOw759X1V/IKq06aozkm8gm47HntZ3MXgUQzAjJ7+z/Oe69H6rHOqITI?=
 =?us-ascii?Q?/UbOrUCG0dCiVO6KnomtJlKie8CvqTYR2Zr3KzQd9GzLAKk+csvVzcp51TAu?=
 =?us-ascii?Q?SWtl8k8onPI1SUuhXOZdfdy84KrTl4vSOzYpY7CC8VO9ESCiMvVBJnkFD6Lb?=
 =?us-ascii?Q?soWUr5dTOzz8WhtpdW27M5AiYYXh7yUsFRU4A8W9pVFnWTLITPrcZV0vWQBJ?=
 =?us-ascii?Q?3gHdqSf/gVHjyeCup7rtrC2f2wGQoOI1wi8P++ODsjTqEDb6gbsBv2aQPE2c?=
 =?us-ascii?Q?coF2T4Xamf66LfofjuVQbvMrjTZkVJOAWd14KG/kX1BqEbJJZ5JNH/oj8lNq?=
 =?us-ascii?Q?uNzvZ4Sx8xTKjWaMvtRsJjN2F38dqj+/qXgG4dv8APAHptOBbJ6NiNFnmpiV?=
 =?us-ascii?Q?RvpC9vuTn2YdAJ5G5O2Fak2POKxMIdyAt63cKOnI6TS3RJik+kVFYQADazNt?=
 =?us-ascii?Q?YsnFngH5saz/cR/wBW4967OlS/8Y74tz0fm4cvBk7A5fCx9fcSTnUL7znVNg?=
 =?us-ascii?Q?5cePD5AkYhMcz6HPBELd8bi8lHC9h2gHQ67ox6vYcDEuD5+cfsJx4ZK6He35?=
 =?us-ascii?Q?O/8c6Viul9y6pgQ3V8Fh6xtEMfrE8z2OcNmWmQayFvjNeQeJkh3vaH9iHp/l?=
 =?us-ascii?Q?bYcayEWcd48khM65YfVubvkNxiI2Oe3eb5UcwGvLMzgQLNK37mkIk768Yzz1?=
 =?us-ascii?Q?giZjzaKQDo5ePyz89KvMdSecNQROEAUJAq6TMsRELT8Q/z3Du9Kwn/FVKdIK?=
 =?us-ascii?Q?bpLJX00TIG4L8x+9rEsFZ+opHeQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f5975d-ef28-40ab-af1d-08d9aba5100e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 21:39:27.9545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/czmV+/FRK5b8a9cq0jGUM4SRv+8BxLsZ4H3M3hIArs0TSOFP2YINseSKwJ1fC+i4QcOrRBT6D89NMi0Mj+Dpg2r3KaOU607SaiM4SzwuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Seville driver uses indirect MDIO access by way of
MSCC_MIIM_CMD_* macros. This is duplicate behavior of
drivers/net/mdio/mdio-mscc-miim.c, which achieves the same thing. The
main difference being that Seville uses regmap by way of the ocelot
driver, whereas mdio-mscc-miim uses __iomem. 

This patch set converts mdio-mscc-miim to regmap, exposes an API, and
hooks Seville into this common driver by way of mscc_miim_setup.

Colin Foster (3):
  net: mdio: mscc-miim: convert to a regmap implementation
  net: dsa: ocelot: seville: utilize of_mdiobus_register
  net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect
    mdio access

 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/Makefile          |   1 +
 drivers/net/dsa/ocelot/felix_mdio.c      |  54 ++++++++
 drivers/net/dsa/ocelot/felix_mdio.h      |  13 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 107 ++-------------
 drivers/net/mdio/mdio-mscc-miim.c        | 167 +++++++++++++++++------
 include/linux/mdio/mdio-mscc-miim.h      |  19 +++
 include/soc/mscc/ocelot.h                |   1 +
 8 files changed, 220 insertions(+), 143 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h

-- 
2.25.1

