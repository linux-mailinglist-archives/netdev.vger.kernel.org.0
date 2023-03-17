Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483926BF122
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCQSyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQSyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:54:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2135.outbound.protection.outlook.com [40.107.92.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2821B1CAF9;
        Fri, 17 Mar 2023 11:54:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZpI+PZ+kGLZA5cPnpdufhRc86xEfe/NayCVg/X6QUiPHH8fd0R+uctxSix7TQD6yS/yr5TcHzwRLZ+Ti36m4rR5/pFkMinH9Nke6y3RXLY/abWDb0xVS1WmyFBTIrMDeN7x9pwKa1w7GZFL8w7zwkqDEP30gT+wfZJFKvhoYNCk6wFIzOqeMLgS6m8FXld7LvxNAK1uUVwAS3h07HZgvrLglkTnEYnpi2vWYzqCy0HbQUt3odd2brTEMG7oFHlriM6SAOY8ltmQvCW2O5Q6ozwjrKN3NepI350H9wyEihX/OAwoEY7ZHw5MUArAsMMgbEPeeOM5144cKdL0DV7SKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8zeH/y4ttbTMEXpDeS5xb035LqDhtV0Zh2f5BHOuyk=;
 b=c81x9Zalusb524JVab60CJ2cp7GsuM5rKAeK9w1fe5LrJ+fC5Hnd0GXb80AqbS1uT48H742KOObaMY7pVMoSji6DqRE7L6n879h/BFr3hrU4fOL+OPLZz0jQx379XOXvJ3jJRnA93P/xfsdERhWQisDcyeHLsZePkA/nhPIgYueTPFRMkB5Nd2f7sb6ESbWNpSniVYG7KWut9Stz54E3B4XA6St0zeWga0np1uAykKaHBXkjnXBZXKROt4Line/ti2dOC9C5BvKe3JBrdHWZcf4+OC1waE+h1O/MEmwRt5SxlCu6RYjZOuK68JxkuFa8o0WE/8CtNKWIfcndyXzwyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8zeH/y4ttbTMEXpDeS5xb035LqDhtV0Zh2f5BHOuyk=;
 b=G8F7DrAnU0gm3iYwaCu/LE5gSjFajHXMc7oFoYoYQpfBLI637Fr6X0OwOJKyiDDJAvIa2T73mKUXofHdD0DagdSiMGfbJIEDcwujxDeJ6s4x4jkqsrIq/kFBU8+CpBJzo/z33eENXrdzij/9oe6hIiVYImWIM0K9nYqoHRCsxjY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB7336.namprd10.prod.outlook.com
 (2603:10b6:208:3ff::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 18:54:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:28 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH v2 net-next 0/9] add support for ocelot external ports
Date:   Fri, 17 Mar 2023 11:54:06 -0700
Message-Id: <20230317185415.2000564-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA1PR10MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: 44660ca9-850d-4096-f075-08db2719090c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e7FVGngxAxzpRQWWhiPf9NEASGUOgdyU4SLuQ0U6brJXE/P7FXhYn2DQlK6+koh0Xx+65CxwsqUqWzsXsx2EWSq5sfgjjTPFQ7l9jbhQLY88V8NMPU+dcdhLu7+Gc7jWjuvraxx6IpCR/IfXTwdT2gJTATfbuXdlP/hjyFEj+2cqW/EonXxRrd00HDHXg5YKqL2CrNz4uOwQoB2JYSlBEPj51JilYjf4e90v8UKOdJB6N8q7HS9tA3oLr+Z9TJaSq6mw3ggdTT5qa3HQ4JlsUFNbbNYin2LtqgQ9J1pN5QB1mmWKWj2PE7ooNNenYBbbGPqy6tYTd7KRQFLkiTVlGMzgSskuNKSyLnd2JvDiACp9m+tkkgqUmSaqrjcxYwJLBLFpvwW6ZCMvPEVxvm2yZ8o3jWmi5c8VNos3eLO/zC/jqfBQexQxwiz3laQEp/tEpvMsJdfp4QlUE4HlMGvxzuNFwWTjb1KBXQvYNOD3QjVvOGbEXeoTTSNyWFDMSDuDPHE8VFNwCL3M2HO0Bk/sLqyvHlO/XDbMtho2PrysasYwkLIVd2/nfvtRtoBiL/NGJMReXHqASUn5Zf0f1NaWpl4oMTr8WkEjqxZHC4lh/po4lnL6CZSKytShfpNlaKFHtOLBhRrLUJvDJS5I6oEw0vndoIQp8zwIWQuxSFhAqagI07yfdS/x7YvpXSiJBAYi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39840400004)(136003)(396003)(376002)(366004)(346002)(451199018)(36756003)(38350700002)(86362001)(38100700002)(44832011)(5660300002)(6486002)(7416002)(8676002)(66476007)(54906003)(8936002)(4326008)(316002)(478600001)(66556008)(83380400001)(66946007)(2616005)(6512007)(966005)(6506007)(1076003)(41300700001)(186003)(66899018)(6666004)(26005)(2906002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pJ9QPsMFZ3zTSYG+bGM1NLwaiF1XeRPhPI6R2XpH1npB3/KXhLvC+aWBct8N?=
 =?us-ascii?Q?a8BmQ7Vp8JaQG/ll0voWcbnlpF+M4s7LaBnRPmLAEKNlZMlsf1OmL3mvgu4t?=
 =?us-ascii?Q?HVFjZNgbDc/aN7b26SucibovX+F1xo7B5MambKwqFJmaUA95AZbOBwObPmBY?=
 =?us-ascii?Q?UifdN9/CSA0dS+pDGR9Fwxdd3iS1nLcZ9nYr7P4cY5zu0bo/PDShJwH5usge?=
 =?us-ascii?Q?+xwZSL3LJ5ymJy1GTFeFDfjqLpvRF4lNs2XrISgTv//ZhkcjgWsIOyC32LF0?=
 =?us-ascii?Q?EgWxlE8j2PmTGGYszGUMdWVPBx2g6Tm3M66fKeLCWhkxmeUOaRhg44QL/pDm?=
 =?us-ascii?Q?Zsm5oVmVLSa1Ox3QiJZtCEOlzop10SSP71UqgFX4uptEgBKQHWYpis3IMmEz?=
 =?us-ascii?Q?I3Vikx31PzO+VQSWye4zfEkYrQ6JHR/Q7ops6CgfBfdNItaEOoGkwJ6zEuSr?=
 =?us-ascii?Q?DYf6rDKFQwlOVMwt0lAfV1Veqg+ly3Y5AEWrSvrsaimLxywYTghQ+dwRfspi?=
 =?us-ascii?Q?lbd4fACKXWb2p9NnMIlJc9ryn5nAdCIt8Qm0HLUb/Hr94gXirrPMaYUmBfzO?=
 =?us-ascii?Q?910Yo52nxNDNEzFivps37OEsVLfqLkE5JcIGISjKRpDC409DoC8zYLNe10gD?=
 =?us-ascii?Q?CK/tcHsmn2LbAWri4EH9/Q2RKPwipqFHamH62LsV7u1c8utn8Qykz4kF+Txx?=
 =?us-ascii?Q?Hdirg3JQE8KDyYBPaCqzUjRYKZOLHhe+dyQqshjGrzPJI5GcAvLSoRYRzeHU?=
 =?us-ascii?Q?xyUf4NlHbjC3pJfZQMcXoipR79qlMzNhfXTdCF59CxKfQHB62KITfjPCD7cU?=
 =?us-ascii?Q?jZHsHPylQk4jiuY8cUfYnx2rR07v81lydt83CcmkScc5CjN15aafdV9RaIC+?=
 =?us-ascii?Q?WCsTYnSb7G00qSWyH66KafcuVnVHOCErI9ztHbVqmgr50KqC1InHjRMvGIBO?=
 =?us-ascii?Q?g6k7hM9DwFsqGz0YCURmKQwNBZUzT+yR01RPYXAimB+Q92L5h48otdPtisfa?=
 =?us-ascii?Q?avZD0zMdBo7uuAMdoU9McEKVvCemPXNYhjfaV/0ftdU1W3kfDqFRjEAtjfN/?=
 =?us-ascii?Q?+PrYU0Q7EV1o6BoPdNW36y+K9OnV4RcvDMos1J49qm7rDJ4z3uBdqbzTareB?=
 =?us-ascii?Q?JG3S+7JWm7iOxa7mKFqIpAegs1oUbBTZ1Ija9OW7mOhNUkUgLzlu4xlA26ps?=
 =?us-ascii?Q?8PUlmhXI0tIox4Lr67w4+JLSd8tYlzxKxWQNyELSDm/DyxgYLwWoYuUEY5Lx?=
 =?us-ascii?Q?v8SdYGKZEkNSvugQTxahFBb4n9uX/nWlYsBSDksNKaLq2AAqPkRK1osa8Vds?=
 =?us-ascii?Q?KZ5nhohI6t3eTh43XR/rUpWD4uuuoae6owdZMeERdlVEIoCLBi7K2g5W2aOD?=
 =?us-ascii?Q?V8EdZU/hS1tRAQ7RmGIIrwxasiNcyfzqZCZaunqkR++bDzU19jitxQ5k+3uk?=
 =?us-ascii?Q?M+CXiHi5nWAuKEp78mYkqnfwro0ZwolddVyRURT5/2z2e/1h414YGOq325TA?=
 =?us-ascii?Q?vffYBBnVi/8+G8gs1DdHjaN6+SrdrlnbBTOIzU2pXzK8B8rm2JNEj77ctoK1?=
 =?us-ascii?Q?tvIog6C7p2YhTaKS+2oIrH2yybuifbVVZOZ59/ig/+P3qczE0l3whZvVd73X?=
 =?us-ascii?Q?bNRuZubQA0UG1ay8CwibDyQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44660ca9-850d-4096-f075-08db2719090c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:28.5534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Ky1YGVixASFZ1nFCZVwCdQ1XdLqOyugYWJNfU0DET56PvmRM0Ud3y+qpWfQhU2PO/fZ6rbdHEzvEwUMJSmLDUpvEjw1Ziqnu7V1X83wIOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7336
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the start of part 3 of what is hopefully a 3-part series to add
Ethernet switching support to Ocelot chips.

Part 1 of the series (A New Chip) added general support for Ocelot chips
that were controlled externally via SPI.
https://lore.kernel.org/all/20220815005553.1450359-1-colin.foster@in-advantage.com/

Part 2 of the series (The Ethernet Strikes Back) added DSA Ethernet
support for ports 0-3, which are the four copper ports that are internal
to the chip.
https://lore.kernel.org/all/20230127193559.1001051-1-colin.foster@in-advantage.com/

Part 3 will, at a minimum, add support for ports 4-7, which are
configured to use QSGMII to an external phy (Return Of The QSGMII). With
any luck, and some guidance, support for SGMII, SFPs, etc. will also be
part of this series.


V1 was submitted as an RFC - and that was rightly so. I suspected I
wasn't doing something right, and that was certainly the case. V2 is
much cleaner, so hopefully upgrading it to PATCH status is welcomed.

Thanks to Russell and Vladimir for correcting my course from V1.


In V1 I included a device tree snippet. I won't repeat that here, but
I will include a boot log snippet, in case it is of use:

[    3.212660] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
[    3.222153] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
[    3.232112] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
[    3.251195] mscc-miim ocelot-miim0.2.auto: DMA mask not set
[    3.778295] mscc-miim ocelot-miim1.3.auto: DMA mask not set
[    3.816668] mscc,ocelot-serdes ocelot-serdes.4.auto: DMA mask not set
[    3.831564] ocelot-ext-switch ocelot-ext-switch.5.auto: DMA mask not set
[    5.058979] ocelot-ext-switch ocelot-ext-switch.5.auto: PHY [ocelot-miim0.2.auto-mii:00] driver [Generic PHY] (irq=POLL)
[    5.070626] ocelot-ext-switch ocelot-ext-switch.5.auto: configuring for phy/internal link mode
[    5.088558] ocelot-ext-switch ocelot-ext-switch.5.auto swp1 (uninitialized): PHY [ocelot-miim0.2.auto-mii:01] driver [Generic PHY] (irq=POLL)
[    5.108095] ocelot-ext-switch ocelot-ext-switch.5.auto swp2 (uninitialized): PHY [ocelot-miim0.2.auto-mii:02] driver [Generic PHY] (irq=POLL)
[    5.127379] ocelot-ext-switch ocelot-ext-switch.5.auto swp3 (uninitialized): PHY [ocelot-miim0.2.auto-mii:03] driver [Generic PHY] (irq=POLL)
[    5.938382] ocelot-ext-switch ocelot-ext-switch.5.auto swp4 (uninitialized): PHY [ocelot-miim1.3.auto-mii:04] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.118399] ocelot-ext-switch ocelot-ext-switch.5.auto swp5 (uninitialized): PHY [ocelot-miim1.3.auto-mii:05] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.268432] ocelot-ext-switch ocelot-ext-switch.5.auto swp6 (uninitialized): PHY [ocelot-miim1.3.auto-mii:06] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.448413] ocelot-ext-switch ocelot-ext-switch.5.auto swp7 (uninitialized): PHY [ocelot-miim1.3.auto-mii:07] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.467007] cpsw-switch 4a100000.switch eth0: entered promiscuous mode
[    6.473676] DSA: tree 0 setup



v1 -> v2
    * Remove complex and incorrect device tree parsing logic
    * Add and utilize felix->info->phylink_mac_config() and
      felix->info->configure_serdes().


Colin Foster (9):
  phy: phy-ocelot-serdes: add ability to be used in a non-syscon
    configuration
  mfd: ocelot: add ocelot-serdes capability
  net: mscc: ocelot: expose ocelot_pll5_init routine
  net: mscc: ocelot: expose generic phylink_mac_config routine
  net: mscc: ocelot: expose serdes configuration function
  net: dsa: felix: attempt to initialize internal hsio plls
  net: dsa: felix: allow configurable phylink_mac_config
  net: dsa: felix: allow serdes configuration for dsa ports
  net: dsa: ocelot: add support for external phys

 drivers/mfd/ocelot-core.c                  | 13 +++
 drivers/net/dsa/ocelot/felix.c             | 19 +++++
 drivers/net/dsa/ocelot/felix.h             |  7 ++
 drivers/net/dsa/ocelot/ocelot_ext.c        | 16 ++--
 drivers/net/ethernet/mscc/ocelot.c         | 97 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c     | 50 ++---------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 30 -------
 drivers/phy/mscc/phy-ocelot-serdes.c       |  9 ++
 include/soc/mscc/ocelot.h                  |  9 ++
 9 files changed, 169 insertions(+), 81 deletions(-)

-- 
2.25.1

