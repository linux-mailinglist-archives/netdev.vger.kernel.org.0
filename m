Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C3546C134
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 18:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbhLGREP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 12:04:15 -0500
Received: from mail-bn8nam08on2122.outbound.protection.outlook.com ([40.107.100.122]:58464
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236725AbhLGREN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 12:04:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YR9pDt/L2PTrYCJwRsUW0oruNa3FRR52VwV6jvCjuLFIiv92vONPqgnlZl+2qkOJCljvEfqedG96S0piuqRIcgAAJeZHy0fhuU6ZmaTx/MHzdPIZGqdefq5ds33d3HRxstnHvSi/QmNLU+qj0xGT0IsNQjSBmwDXkPCs1fb1zGeL+yzJYh+pR40bciWDQqFCFUVSRpGV/bKQXcvkhj2dhk/kGKLIte1LPuKLLiJu2c1Zsw55C570dscrpJO9Hk+1BAQLtq9vvSJa77J6yszgY5UU3xji7EegoncLbhVOSjSiznuftJEpm8hFRnZZ8DH1R+4Yn3AvukpVI4ejFSsZQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/2rFUvYrzTXnMTydISMsoe7F0Y6+/8n1Iy+lDzRWUY=;
 b=ivx7WhpJqkY9avWg6hx/6wx+PuGV9sb9s6QpC8erwp4GGpiA80/73heah0EA34ieh4kNYNbQ7GwuCf95JedG4SVKvaGP/HbtmXPoh/ItSBXygOfo9YJc2iKA2XdAbQQfDKTXDCLUlAwVkj/Fnwmb20d6mRfLoaPObEzLHB2erH/mHlXlDpmyJhe5gwXcVqjap3NFoIe3I4bFzkFFPq7brizGhG34tUfzrsL3aLPEKXPCzbq0DoCxDSENVPNgPTzKaRldfulUBUalHws5eBx++hsvNigjq2/vK/LZCleb6lIjBl4fmDlyoDy/SZ+lXddqC3bvKIVZt41Ln3abWTif5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/2rFUvYrzTXnMTydISMsoe7F0Y6+/8n1Iy+lDzRWUY=;
 b=tvjqh0u1KZjJziN03/7p8ToQFqKr4FPnMq+7sj+V64dtgQGp6QOhorc3S65baV0Vxu2t0YwaDlj+udoVXJBvrA2zzOijMa7hqqA1ZD83pmh+RuKHVkCiO7dZwjyUq3gag0i94GYt09gMVRhQ5GE01iIin3kkyI/EhEsspDzREv4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5441.namprd10.prod.outlook.com
 (2603:10b6:5:35a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Tue, 7 Dec
 2021 17:00:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 17:00:41 +0000
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
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v5 net-next 0/4] prepare ocelot for external interface control 
Date:   Tue,  7 Dec 2021 09:00:26 -0800
Message-Id: <20211207170030.1406601-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:907:1::36) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW2PR16CA0059.namprd16.prod.outlook.com (2603:10b6:907:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 17:00:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3a272e4-82fd-4409-716b-08d9b9a31972
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB544103D39FFA2A3E186F79F9A46E9@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkViRPXjxtZzJnI9SANFrj5ScGMg1UAPjMHTOjcG6FHxaSHfz4Gvwt33dmCeOT7r3IoUBmlAwT9gqiGznwS5eedezwVYx4Slds9bHHTpEQIXCPudNGSFmi7nQscZ4XKWi/9SkibchZtnsb24tuLLkQMwXqhcisH0khQBlBMJxkas5W/x/PpfXHpdwrF5BtmgVPx5xY9p9L2Ag8UAgmFQRejJoHj8KEmFvhARsvG4dUZwrUkDeW/juDxvH8YyjBu8sijKYD6qC9FHxTmunLz9iaj0j+1fYtSmJqdICfys1ITINbHXVjIPMwPlJ0WzAxgG2VPmn0jxbKwuqPKIhxc1CcHF1Yv7lEuEynwM/c9l1TT2Yb4AhfiDP88IUfSmrc7eSdSWn2LBEWPD1O9z9YXo1in1kWqzton7a5wBc1i2OVLuuM3ZGpHQouC30TLZzwcpUAo1ha3DaV6QDw48ovKlThA/fixOItXVqoSQtK2bfT+GkO/hs6VyhHJSaaSzppEJyM2jC775H445GgRRuuos/5Fpe2iFe3AecPeXJ3PkZFEq2BUfrOtrMfbDsKzQn8m+iZvJmTrqI2dWEWnVfxIFrCINMNr5PXO1lBYBDPgFqmQvYts3wfOVipHVjEGcFuYvFazLlotDyhgUkfNpwITJx/nkN9rlBj+vsos94lyx2mdXRjYShFDdXCRBPCGA62uX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(39830400003)(376002)(508600001)(316002)(7416002)(5660300002)(8936002)(8676002)(83380400001)(1076003)(54906003)(186003)(4326008)(66556008)(6512007)(66476007)(66946007)(6666004)(86362001)(36756003)(6486002)(4743002)(26005)(2906002)(52116002)(44832011)(6506007)(2616005)(38350700002)(38100700002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ol32gvKXm2Di4RwLzyriAIGLkS0aJ/wb5lox4wHirLNvWL80QmYmupYIsQrp?=
 =?us-ascii?Q?xZ3wBS6wxdUCDRPBxmQkeBim9ZHEFRRmb62zAyv5cZr/LOGLNDf6GZ4arpyN?=
 =?us-ascii?Q?lRk0MfUm2/OWbiVtX2Ak2NenoH+pAO8yvTndSDQXAP+/dqZvDmOQ+nooY/71?=
 =?us-ascii?Q?/rv3jZN+F/dy7TU0U8hiGPgrWTTNzf5MUEBP05tDA+r0140gwoMaJbZ2V1gl?=
 =?us-ascii?Q?o6qeZcBMX2u1NJ9vQm+ZPJ7NM5Rb6wegkApTDzzgao7NR3XXN0QPx9fiV2Vq?=
 =?us-ascii?Q?KB6H5uD/QUvp0QCV0rMCUoVJwCEPjrrLjXTpM96UE0P+OlmgYX4SD7iiaiTI?=
 =?us-ascii?Q?YQy+sAmH2BAYrkg4aoV03O/xrCQ7Rs+E4hv2ANhlSUdsHh+3LyewhTOdd5FC?=
 =?us-ascii?Q?XFhDt5y7kiJrdzhnGsD3otnCiUQRrUhu6+jaXzeQ1vK8N4qvs4KWNmecGALK?=
 =?us-ascii?Q?qu/hpxjFf1EA80QHqAl1XrjToHZFUKOHPr3sfVaYtkFFqTREen9gkZKzugWQ?=
 =?us-ascii?Q?jJemrJJ9HTHNz3JSskau5proEKlFqctt2NV5tX4Z4UFCsfbkOndYlymMA3DI?=
 =?us-ascii?Q?E/6OfQO5mIDiG8jU7VrxjRE7+z4SRPHRQejrCrLcH3AfOX/aRfkT+0fg86zY?=
 =?us-ascii?Q?SwLTNMMQDdM/2A9dylXHV5drXffYkRNXccYl1k++sSmQl1ps6xQ+HcCzXMrU?=
 =?us-ascii?Q?D7WiUlwmNSi06fzmWuTXOE4IW5mZ/o9Rjw8JxL/sRolPZgn4pIxds4CmRrBX?=
 =?us-ascii?Q?a7auFynkgd3LB2VJpA/8HWAjca7wnjXs086nLI3VZUkAv4wKwfM/RNeP+ihM?=
 =?us-ascii?Q?VCftEJm21b2hVvAhe3Vu5eiFqywMJuwEShFVd9yaBguTWGia8Q9SnKGqE1BQ?=
 =?us-ascii?Q?9KWJ2+LzFMPRwTQma2hOwaVfsyJTarujqkos+LnXljVeSE5guQ7x4i19wKgA?=
 =?us-ascii?Q?DuJAGZhDKjmWYBWr3dF7E/XC6wf+egsjajBrLokHBwnV6gt/fWJynyljx5D8?=
 =?us-ascii?Q?FCNUnkcEnVb8qwMhnbo9zH8zN1yy6y4fjx/t3xGtvxryhim/kE92PHKBr4bg?=
 =?us-ascii?Q?IVCZW9hjM9mbVfPkulHAhjRUhLgPMAf2Hmak7jsW9AenG3iRAqLipyLUku8r?=
 =?us-ascii?Q?sK/qyntN9HBvm3qolObHzgMmPSag+h7iENShQw9REDF6mGq8X1QR/1wiNY6r?=
 =?us-ascii?Q?IIL6CjC5wcegp4SckNgWz1XAvGLruxtJLlhm92hsGgukMueuUu5g+QBxqpoi?=
 =?us-ascii?Q?x12U7s/glFDj2D5ZHou61YPt79N9R4CfXI7OcuIJXrMchgC9KTxkOofmskUZ?=
 =?us-ascii?Q?005PHGWvMhUAhBeBZy6GkJ5HTKD4RFSycF8lS10NukFNgl/REWRi3/U4PWvM?=
 =?us-ascii?Q?1TpisP5HLVVvSLMsUV6VJd7eTRijpmtDumMH0DlAQTsLlK0Emuva1U3Ta9FL?=
 =?us-ascii?Q?JFkAuh9d+5gnJx+rrPzhwktT6H1o2pQuqu+dZ+tRzZ4tq7elCWrSFXHk21ti?=
 =?us-ascii?Q?jh7RfqL8S6X3/cNqiSGwHPcmx0OAdSVEeN10RmWHXDXp4EE4hhd7lqax5mqa?=
 =?us-ascii?Q?cnc1iQCwAGvNC7bkIfc7O2v8E0vvi0I1oq655o9qLg9i1uQRmuE8+SqBcO9d?=
 =?us-ascii?Q?74U9ncIbjD6JlTTA24Uao5Fgn0MOo62Esnkqzj/7i+pQmjLk46blFbu73ZYZ?=
 =?us-ascii?Q?lan7Jw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a272e4-82fd-4409-716b-08d9b9a31972
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 17:00:40.9233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKE9eNPBfF9xFJ+hiXro+ftR8GYAvc+A3g6+Z5XBT/+jvgeATX+OwePnsgRg4arSb1lnLJF0BYbhuj+WdeOZOjI033WQ/1yhJ+pLyfffryo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is derived from an attempt to include external control
for a VSC751[1234] chip via SPI. That patch set has grown large and is
getting unwieldy for reviewers and the developers... me.

I'm breaking out the changes from that patch set. Some are trivial 
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices

some are required for SPI
  net: dsa: ocelot: felix: add interface for custom regmaps

and some are just to expose code to be shared
  net: mscc: ocelot: split register definitions to a separate file


The entirety of this patch set should have essentially no impact on the
system performance.

v1 -> v2
    * Removed the per-device-per-port quirks for Felix. Might be
    completely unnecessary.
    * Fixed the renaming issue for vec7514_regs. It includes the
    Reported-by kernel test robot by way of git b4... If that isn't the
    right thing to do in this instance, let me know :-)

v2 -> v3
    * Fix an include. Thanks Jakub Kicinski!

v3 -> v4
    * Add reviewed by tags

v4 -> v5
    * Remove patch 5/5, which added unused symbols

Colin Foster (4):
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
  net: dsa: ocelot: felix: add interface for custom regmaps
  net: mscc: ocelot: split register definitions to a separate file

 drivers/net/dsa/ocelot/felix.c             |   6 +-
 drivers/net/dsa/ocelot/felix.h             |   4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  11 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 520 +-------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 523 +++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  27 ++
 8 files changed, 574 insertions(+), 521 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
 create mode 100644 include/soc/mscc/vsc7514_regs.h

-- 
2.25.1

