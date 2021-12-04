Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540634686F3
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385417AbhLDSZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:25:08 -0500
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:6433
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229534AbhLDSZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:25:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWLcM9si/BLIX6ZXfFNc+De0EAJG2qhxB6LW8/hk1i8N312BtZz/kJ2049IJssFGDosnZsG3Drnj/JgflrgSPadm84pt/mOXckSUDQ8K6iNQRmpUCeTLwyCOsRyvaFC8oSVaO4cbAsZ6vN3XugqXYDNbcYRBY0MStUzkAIbjbNyCd9nBfjbIM1wUTlW08cneFunWD72OfKNp9s43KZTN3Z2CwnZbsHCaamsEZiNFqhJX2cLhRMux8G9YSe9vDeodXCB5P4zqx0A8Ox7iI/4LxhUCefugOoTmEh6uJclF9+llm8czY38cQd/ym54eq4Xigg4Tf7EMnoDRcDFavn2D6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGJl+5zjcN8RbxvhXC0irIWr0CpF0cAtrTIuypcANLU=;
 b=b7C758dg7kTgNVTVysOny74oIzXzIxJpRVBzrJgISn476+83FwCbkHzGXAcT7ts5B1QBsCS9dmD8uYDYpBbMbaUsQzl7U/dQmh2SPGylnlTRy0HJK664oMIOphenH+akQlstZs2aolL5ssNKN/BVWLI2Is5ehJigZ5wm/QBC58t9zzqfRuFOd1Ss4R30mEhMzdre7m2ioepcWzD38mCx5vUQ7tm9Ktf5QTYxicCNIPJuFi8JXRxVUT2rpNXaEOY0UCIYPdr9bRmOj9O70jNKrRvEZvUSPXU4XehTlmbaJnGx4RSwcr/p5JisefOaqT+S5uiKw3giWLe6MEsEMoAW2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGJl+5zjcN8RbxvhXC0irIWr0CpF0cAtrTIuypcANLU=;
 b=bRaS7HTaW+IaNd5sm6o013GHFMS3xlfZXisp+Zed7sAqDAVj05v6NkfQnLwT/C474yqvlDHAiUwLEPoFSlDz7470gJ5M1/j/sy5qMKODyLpxrBVuIoMx+vMw8+i/VUHZH17oiSm4B53nTO4SvKFpPmCTG0ztrpQn2XEuoXSTi34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2061.namprd10.prod.outlook.com
 (2603:10b6:301:36::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 18:21:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:21:40 +0000
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
Subject: [PATCH v3 net-next 0/5] prepare ocelot for external interface control 
Date:   Sat,  4 Dec 2021 10:21:24 -0800
Message-Id: <20211204182129.1044899-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 18:21:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04a5b719-bb7d-47e8-0bcb-08d9b752eaeb
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2061:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20616CFB583D142F98DCAA43A46B9@MWHPR1001MB2061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itsyHk+CQ4HDlQNARx7cRlUkVhNUV7XWFp6i3ddKt0JiWrcxc4znoCVjoy/iAgE5SVTJfbPfgX8stoAKcBsh5PtoSJPT8q/zcDN0yjZ+4+8vUCpQSEwnV+k+d8Ku6204+dJG//dlurE4LJj8qySBmOt9q5DgCfPNMLmVT6QSv3gzE63Pi8fOn/KSY3KkAKeV/gV9D3Hd7XF6w1D/gRDJuWr2hkOT67VB7Hl5mHgq1LFBbtdgb5OWB+U5bTGae7TcBpK+ZtsC6Fa55UQ/6eUioF6RIZZcemFIkII0GvaoxevViOcpkYS05uMxhyR437H67ngQaM0AzYjVGTxrh70w/iCqN3/tnaIVJa3ZPpWVO2wchgO2MBDixhXzGfvMlJArkJWMlc91M+y5LO0Nze45i8OE+PRb/GDeaOM7ZdwNGtfkcPbBjyw4BBNMRSGhQNrnFjhiSXcm3FIp4GGXLrE4wTIVIo9f68dTdd56eIyPKugyWWAXy3cyfRIcSe+o5YsusNKpjCfLlZM9Uv5s+2fS1qywsWinWqwo4iZB6aDCWQRrpzU9o/pucojw0lZ+/jglXB8sGb2aQ3UNtK9b+/aP7QijmIcf51I73DFHpbPR8D7XQRzn0Z/tK3AWmTZX5JiViPdTGK9SbvtAJR2+7smz17U0EbbF+0UPnevwS3wak9+EDFTN6OlSzltKc2Tpxnuk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39830400003)(346002)(54906003)(52116002)(7416002)(6486002)(2906002)(6506007)(36756003)(66556008)(8676002)(26005)(186003)(66476007)(316002)(8936002)(83380400001)(2616005)(86362001)(6666004)(5660300002)(66946007)(956004)(38100700002)(4326008)(4743002)(38350700002)(44832011)(508600001)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4N7Dd1aAtywUj1xXAIrBzNbpmq3ne0l/TLoiVGKl1tAJK4C/zroOpZFn3DgJ?=
 =?us-ascii?Q?X2SFubMTcph6Opb64ixY1QrcngxV0jST/E+TrbIV7QUUf2hRjaTvd7fXPT10?=
 =?us-ascii?Q?vt2aNLO+BU5bHoI1ZggeOJkGcUPwAxki8HRByVsosfccGs4tA7aGlgEsrDU+?=
 =?us-ascii?Q?G6nyKmJkqlkTghBxmy+QYSzrk7DgqhPvisF3pjCjU2dpnKoOrKruU/R9HhSy?=
 =?us-ascii?Q?4EaGV0AEHOOxZ91PuSigIxPL0G7dyL7YcEzEz/eEu4HyjHLvWcMvhoq8yQuh?=
 =?us-ascii?Q?Wbw+pXtbyM61q2hzR7L5FkpsO3Fop3f5sUCA7bCaqV5tsTZpJzf5wHnPXrEE?=
 =?us-ascii?Q?3mP2pmGMDUY2u1nbxWFbHdXr5ftptp+/ObbdcKOtB0VLIae0Y4g7MM6gOyk3?=
 =?us-ascii?Q?xOKrddTugM7PBmA5cRH1OBCK+dE2VyJ6Qo/mCkUq/Q8rqrevVI5ipsS3lUUu?=
 =?us-ascii?Q?+8SVvwJYRevHawVZHdpB6RMprKspgHdoYHe+cYoTadBCBu4QsvcnWUYKXVSp?=
 =?us-ascii?Q?kne/c/tOLjJaMb1N+wmgm2chfbLs99A2UYLoPEki2oo50gkbE6Tmm3Ly3qQ4?=
 =?us-ascii?Q?Sm1NHMDSDfxOKyinFS5Ll+Xj+aeGgStjMkfhCGRLAgT2rvI4KOhL6LoSbFHT?=
 =?us-ascii?Q?Jqge2TLjViP7UB5E8Pwpe0X1K9+M61pwygQnEUCnhukLcByHvX/FrcuTAKcG?=
 =?us-ascii?Q?3qJOYjszpZbDIxnHJy9OTEMlE1ld6qvxLoYiU1Td+RTbhN/QFueARiYpvRQs?=
 =?us-ascii?Q?/QAaIZ+NvQch2k9nsZqCzMd8CLR4eB3/EC0LVi9Zbfb7ppfp+JoiNBUy6ZA6?=
 =?us-ascii?Q?nj/sxGPc9cZycVrU4ubXvTSbzwO2VwMlYA+EpOdrL1lTNdAY02MyZSwjq+ZU?=
 =?us-ascii?Q?iMupjIsm44kxfC80jsp58+2VDu2rYCEZnnDz+f2d+oWMfpDzC+eWaivQCbgR?=
 =?us-ascii?Q?v87ByltIyt8vazQkVrqXoJuHLwdiiP0i6RwG2xK5+HP2BWgl4jNTY3dzTMip?=
 =?us-ascii?Q?dwOM4g5GJhvUBHbVSYvhAdCo8fQXpFypWTmo9V//mO9GnHLui4oAlo/hBy01?=
 =?us-ascii?Q?3f/Pbi6dv9ZXRz4TmV9G0xid3xKWO9D6O+gNYLTXl7ZQwXqzQY99OPQ2tuy5?=
 =?us-ascii?Q?FC0gpxhxUlDi0nH32kbBmCojeRYg1nDmNy6UI3HKdhVvh869vVXeQsnhwq0o?=
 =?us-ascii?Q?L6LgEtYT5jtFjsTWsa8mBfVkjgVctNCBupRiqhM4vg6kdkLhQ8jKEfsOj4ub?=
 =?us-ascii?Q?TGbjNbcIBidSbhaK8HoEMCXrsAUS1Ez2SIEdFaELXF8i0O+9BjLPGZtof+pa?=
 =?us-ascii?Q?6RmIC48rYosRLLe1ssbNrYOxinN4pvk06QLAkHN0DvuCI0sJdM4dgmWb6rbd?=
 =?us-ascii?Q?THAfUFAbeCTsuCvOOS00eKi4+vKszSYtRUmFKWZAAamcQZr8zI5EGugHyWRM?=
 =?us-ascii?Q?ZWkyaQ6JsB2WhKUKmlUNW8rDxGDrzhDFBvCtX0dxq089Riy8mhJwJvbqS0gl?=
 =?us-ascii?Q?bGwNA3uA4ISHFOr35GfnGhG5wx+PXikGPEQeeEu9e9p7MjLg7ftpaSIv891U?=
 =?us-ascii?Q?Pv5fRe8WikvS1AMpgn0DyWZcofoGgqK76+juSowqMnuYKv72NiIGtSa9dFBZ?=
 =?us-ascii?Q?u0uBLCKb2wtwIHbnS5otTiaMLxfB79CYhBoLBkZIzQEWYfipf9rjrtOZy+I/?=
 =?us-ascii?Q?oc0T49/Govsf7A90eLhfyDNRIlQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a5b719-bb7d-47e8-0bcb-08d9b752eaeb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:21:40.7738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZXEelqz3r1cUso+mMNE/TXxUnWyXEodmFAtlIYsAZovufJyjlwwvnpLrex7abUxN0zLIMLOD1lKnBA2cHUzFdihsCYK1R4GWfOpE4NYl0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2061
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
  net: mscc: ocelot: expose ocelot wm functions


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

Colin Foster (5):
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
  net: dsa: ocelot: felix: add interface for custom regmaps
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions

 drivers/net/dsa/ocelot/felix.c             |   6 +-
 drivers/net/dsa/ocelot/felix.h             |   4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  11 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 548 +--------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 523 ++++++++++++++++++++
 include/soc/mscc/ocelot.h                  |   5 +
 include/soc/mscc/vsc7514_regs.h            |  27 +
 10 files changed, 610 insertions(+), 549 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
 create mode 100644 include/soc/mscc/vsc7514_regs.h

-- 
2.25.1

