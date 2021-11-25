Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB99445E17B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 21:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357145AbhKYUT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 15:19:59 -0500
Received: from mail-dm6nam11on2129.outbound.protection.outlook.com ([40.107.223.129]:28576
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350954AbhKYUR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 15:17:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epR7KiUT/Tx5qhaPfDQGmg4D5xf6GtfiBfB589mFGwy/ZyCHmZ7aWOaq0QChFS6qfnUcyEwxqwkswuWs7RwnY/BqWKQD3usKduN+Ocz6nZYHhknjwSR1J6YVrM0vGeIRPicJqCuLO9hXIqnRzqF226MTk3Ge0mOQ1IsBZ/j3/tLGPM6sbDaQyU6lr0kpaGQAjVH0yU0bRme3V5wLJCrXqzNEcBVdxmq40CMAKJxIf77i1CQ81YMvTCM2EZ3Oxe+y6B9WANu7oYS4uuqtjYzQqRDX6EqU2j7h8p3S6oRzqj3NDfUftMxv8iMrULFevbY9W8nlyq2wO9MF+xmEoOv2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9nvTJV3VVzfrDH/PL7kogm0YmEtcOk7KwsG8f3x8vo=;
 b=LS6IoeZJQzzUMEQqXqjzqbEtH7M59/EMDHUVa7B6iyICdpB4w54/B1KSiZFic3lliJAR05AwNcyYQ6DO/+qjP/WrbTQ77lf04WjO53wkokBCZX2MZ5n5xBUsp4qQhNELWouRZ1G3RwONdILBplDwVHRMWDiGNhYA55LawjqqtatSqcdloKN4KXrJnE4S0Kc7MNuquDHeki2xgIEsWDx7dHXCpAQqgSMMtv0Ae7ax55XGenzFCezmuJ03qWspOKMmMN0AR8Hk3J4hggQJnMmzLt4qJT7Tvj2bR45rpKE1yhVEF1wrqueoX47jYm5Y81/XpxXhFayPAj1qMie7DxuP4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9nvTJV3VVzfrDH/PL7kogm0YmEtcOk7KwsG8f3x8vo=;
 b=lApo662HtZb06yxTZG6V6+IoHyoWdwImd4RqB9TrOXpBJDUE2bGIxzvLV5GaK4+g9su7oMNX4D/6GVpMyvMykD/kYX4DgrKj2U/fEMzeA4Wv2vbZ82fdDMqaPa6qxmANk45nLaC+lPHIh8LPCzDdR+9dFyo3NlfXyCZu2Mehbr8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 25 Nov
 2021 20:13:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 20:13:12 +0000
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
Subject: [PATCH v2 net-next 0/3] update seville to use shared MDIO driver
Date:   Thu, 25 Nov 2021 12:12:58 -0800
Message-Id: <20211125201301.3748513-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR18CA0071.namprd18.prod.outlook.com
 (2603:10b6:300:39::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR18CA0071.namprd18.prod.outlook.com (2603:10b6:300:39::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:13:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 691eae2e-aa40-4f76-6f77-08d9b0500164
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:
X-Microsoft-Antispam-PRVS: <CO1PR10MB55215E55AD61E272475F45B0A4629@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: abJI2vg6jrVD0/asHekradRZ9m01Tok0IJsRWsisvwWaBtrlxZ6MG85O05TfEGwqkeXJyx6dMNhakVGvz5ngt0tWa8I/CpGS2lSASrsVhDQ7l8gceQzHEnFSCOt4QT0cJUSB0SQOfQ7xoIRV/qv8dNisAaWWCm4Gd6+OsqIGGxZpVVdCHnZRxaNqVX6uXs2bx71zvcNaC0Wfomtxwer0s3IRjtPt07YY8QuPTdhRMbiAgvtvcf4iOP3Jpz9DxKJQyfM/oGaayiqxTAPDfESDkAg1Ncdw7N5Yo08E7WtTwkuurreSkv3uPkVvj0ZchwuoYZ6BnFZISfzC0K2f4iULwqS+iFensXVBWZRf+HLulRb7zlDA9GdZxrHtB1VoqGw7zZu1idXHycuo16fqKAmhSen0BdvEeAbVo9tZIwSHpd7dhpNkfOa/kOuKrINhRw8qMgoVzmh2I9LVraVFzUDCAWWsgUUKvIuDelQe9YT6mBW5EaSWwcTEpcmhVinGJjKZE2LidfelyEw774tb5+W/S7l5PugnJLRctzbWmhSl/mraZ9K/58IHFhC0FUDPQFhKPYT7uzlBJzS/bCgXFHg67LB1AF9MMT9n4E4dHzmleELnIZ2msyBebPZ0CQWGC9xZ/I0LR4J50+GmwyaSMkHDd+2Mqj7VqRAL3JkCDqiTar+z558LmqnLYUe/q3QKr7Oa+AIC9ZAJN9EyWALzF41pUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(376002)(346002)(8936002)(44832011)(5660300002)(6512007)(38100700002)(8676002)(508600001)(86362001)(6666004)(6486002)(7416002)(186003)(26005)(38350700002)(2906002)(36756003)(316002)(4744005)(66946007)(6506007)(54906003)(4326008)(2616005)(1076003)(956004)(52116002)(83380400001)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gkXfsxSQS8IU+mrAvfJV0fMyKFmKY0VR1d4bRe7jg8oESssS/rpaNPvLfj/J?=
 =?us-ascii?Q?YheuAEZir4gOGg9fq9vqe3S7LE5PBHa11e+2CyWJwLN27GLnXHQaQav6qd/G?=
 =?us-ascii?Q?S/KiTC5fw9y/xPksV/rFrfGZed/cdV1SnHVsG7SjPr4FZ9GIDPJPnSbm06sK?=
 =?us-ascii?Q?CychuKFVph3qHDpC111yEE/0IeE41mTNtOHuXnobei3bRXvUvaEsY05ejbM8?=
 =?us-ascii?Q?EeedVYsgaTp5bUetoiditciApoX/NZHasfVJpYcfhLxUkTsUBHYVRpa8HSWM?=
 =?us-ascii?Q?tSo/RRv/SOE1fo9zR57ew8jL8gDGay5hf0OHx6iMPymojxLIC7T7Ef9KM91o?=
 =?us-ascii?Q?CfzPzZFLY9myoSQgP1ZmEBSWf5s4U27y5iLETzY/kqTvEbqckp2ROXM7ftYf?=
 =?us-ascii?Q?fETamVGQ9hTt2eVQOO0dsquDphaI79LQOWltFPFNJ8lslYSPcSD5R5yd4Li2?=
 =?us-ascii?Q?ITP+ZVn7RZgYDpmbulrupp5JZpONePaaCU6phGrvmGxRJnmgQzgy2roEL3Lb?=
 =?us-ascii?Q?QIPE2584hLw2E8uuzw8OuqheIWCWY4T2kjh7PiCV/gEs9g6eHw6dEcF7ab/m?=
 =?us-ascii?Q?BMZDlKkOfSEp1bw2Scua+6LrmI+HLm2ZsNRAJ7y1p3DaapcRJPzdiUJBSclg?=
 =?us-ascii?Q?qw49X6dFzXVC5b/6RAKuGKi3AG2E2lG/bGPM3BxjcRVMd/6YHipClpygRYZP?=
 =?us-ascii?Q?rdyySnL906low3if+KSMAnO4FtiGErQhng5336xd13xIj2WkBJDj/nG1k4uG?=
 =?us-ascii?Q?OZlMBCEBv//IhWgry+4Np4N0dNU8fGmGcx59mJ5miKRJfF9kUn0Bi/ljyOPP?=
 =?us-ascii?Q?t9e6Hxe6T2BEbGy1gxSEFXpDsr7sYD47ja3jw/oZW6ua7XAj0Id65QIndV6Q?=
 =?us-ascii?Q?xJCUMx1jDTfPjqhYnQkDz3A+XAuRChiNfbXyQMx/PXHyPciL7Z00dPsZjvaS?=
 =?us-ascii?Q?+65nZ9Lbd+yryefXS7qQufxqRFiiCquadqp2JBd+cxWQs2khNgVyW+Ao62Ci?=
 =?us-ascii?Q?aA5w95eXFDMvY1E5FcpOi6fcZA7TKn9tisb0QQDEQk9YraOLcpUD8ze+tqVJ?=
 =?us-ascii?Q?/6lPe32QlodpSG1fneHXnX6lQeOAoaNc520ny5fSRwGOaobnxG3eG1WA9jbs?=
 =?us-ascii?Q?uoPMFXiUPrgsJEv/4hxm4LZW3Rl01bwwWxC1pp8dqWfr0fCfV6Jc4eqvrFI4?=
 =?us-ascii?Q?CtIYRtqZX44rK2prD1D58TN0yuadCYJES6vaU6nDquVPnq2xDoftlguIv1og?=
 =?us-ascii?Q?5QXNqtCmXFXyhcjuF+xmRbdKswug1Zsp4ixGEdhqlK8IYVXYNBtvTXeWUz3R?=
 =?us-ascii?Q?dsMsEGur829k/a/OJjngdwgWG+4p/o0fVme4JylkeOC/gPssje4mH+p0uar7?=
 =?us-ascii?Q?mT7zOhqJN2YZEOuvmzDJBg7V8EmCvLZIC1Egj9vpAMe+AEatsq2HO93VFp7V?=
 =?us-ascii?Q?/p/lahwbis1PZ4oHCdYl8SxTd8XLlYCoJB/ds2w4FB4FHivcIO7EL+mhoHvp?=
 =?us-ascii?Q?V+2DkJhRRnYcYiYNQjhloO6ebfKJ6Q+Wfyni7teP6UM8qYU+o3gNSUHbdPln?=
 =?us-ascii?Q?VDy2ILffSj3OaGchC4BQReOoEDI8tv/ubdB9HooFbwGvkSYdsBlk3SYARFoR?=
 =?us-ascii?Q?/LvokXTpVo2Y6Qo6EJMvmjNBNC9eV0T1+7AVwhHrLRnXlEzRSFBz2qEA5r2b?=
 =?us-ascii?Q?x3HupA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691eae2e-aa40-4f76-6f77-08d9b0500164
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:13:12.1065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7BtOju+ErFj8fkQmmEdGx2Z/2Uhu/eBPIRA3E853I5XoTNZnvsy3CyRphhAVw9ibTdFgpsDq4kUJyLUOp4l61tJh56SU0+xuXj1oelUcHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set exposes and utilizes the shared MDIO bus in
drivers/net/mdio/msio-mscc-miim.c

v2:
    * Error handling (thanks Andrew Lunn)
    * Fix logic errors calling mscc_miim_setup during patch 1/3 (thanks
    Jakub Kicinski)
    * Remove unnecessary felix_mdio file (thanks Vladimir Oltean)
    * Pass NULL to mscc_miim_setup instead of GCB_PHY_PHY_CFG, since the
    phy reset isn't handled at that point of the Seville driver (patch
    3/3)

Colin Foster (3):
  net: mdio: mscc-miim: convert to a regmap implementation
  net: dsa: ocelot: seville: utilize of_mdiobus_register
  net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect
    MDIO access

 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 104 ++-----------
 drivers/net/mdio/mdio-mscc-miim.c        | 181 +++++++++++++++++------
 include/linux/mdio/mdio-mscc-miim.h      |  20 +++
 include/soc/mscc/ocelot.h                |   1 +
 5 files changed, 171 insertions(+), 136 deletions(-)
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h

-- 
2.25.1

