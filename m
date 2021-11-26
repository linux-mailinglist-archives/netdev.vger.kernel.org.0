Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434E245F2FE
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbhKZReR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:34:17 -0500
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:29334
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230499AbhKZRcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:32:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMxZJ0ia7QlDbCTl8taS9dIhq/ULJyBL/TkDrr1UZ71z81uV5lNzRvBMlZcvKwIMw5qwN3uBxqfwpLvajFmDWKjg6HUYlp96PHPPuS50Z3nwAoe8b69TbMu52TYzCdCRaIp2WWR33dqBQWmcr6PcxTfVVNDPfliQnBbH4+30BDYZm9Gs/GsZb/hnyfMABaqyattwELu5u1ofiGoX+twDn0TYr7oMpONZA4sSEcgJPHoUrrPEMo6Vr8Y3o5GyMLqXqfYURGoc+9FJvjlyXTklJZ4TgQsRWag6spckKcggIclzstG3GLI9YhuX1RQFk8b9WBIUFAC4IO+NB4geR8SFDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbLrV1WmArcVY/Jib9cfUKXWJkNF9vIR9ZycljggJZg=;
 b=KRBQ2DjuSZfhtquGxMdYZ1jHwDn95RMuVVvqLV7OwgbdD7fLpQOalO4g3vDbza7jd8Ey0gr6XP+B+gcUv5BFxt4j4ww+GqGI70veLiAq6EZgVAHrqtc/MUbpm92h0+PhiiwtyuQlLBz508YKooKwEWVyke6cy9aWxfvl3XVjwRNds5F3gq2ybn9S2AhlnC3ucCgW4f9HDJNLliJYDVok06pOgcYksqV8dHfqYtbPF6+0W8My8cfWNSr2Z/aTyMt/umgYCdpXT6A5YOyXUaXGLtchztmwmYARY0qBm0jLuieeruiIaAmT6efgQItG3XwihaaBrX+GaFSStBF4iPI4GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbLrV1WmArcVY/Jib9cfUKXWJkNF9vIR9ZycljggJZg=;
 b=AMLQruonzwN+QbflJ0fSsD0VfEcYFFGpFksgheTYeAUJIOKUe+4A9Cq8E1I+8kttbCCDaiNbF0cHLs8UDe0IHwARMFXy8423DJlJHIpakfq5hTuMrLpozYmDHk2aiuEufgs2rd35G6I84aG2vN/c9AFvhE9ToJGDJ5ukT2YNEuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Fri, 26 Nov
 2021 17:29:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:29:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: [PATCH v2 net 0/5] Fix broken PTP over IP on Ocelot switches
Date:   Fri, 26 Nov 2021 19:28:40 +0200
Message-Id: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM0PR02CA0125.eurprd02.prod.outlook.com (2603:10a6:20b:28c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 17:28:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f0e07fc-3e09-4b52-0aa8-08d9b1023bb3
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB663948D6DE42B8259534D490E0639@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8MI0WrViiBhn04l4lpj1d+Z2wWklNn+Kl+SIq5g0S1CGsB5WVhoXiuh8tThsTg8i+KrySRAOfB2IZ4eKfmpx3Fo+QjJ2s0Hf84LqL7FttNQ9VnxHLrnJV6zB1zaL6vLcI1MWy547ckJr6DRlxHi/q3PNguTALoNkXuPVKaRleU/Kvpe+BWOJnq5/i5mldCSDxpA4jrlvzYm67+L2rkDRMzxGiBt//YbrFziZ8oso6xLwKjTgPVLPRS1bX4Nx17R+FjZzbELeGmEMKR37cS6ycAuNccEJ9nojPpOAtHLRMRJ6jpYOfrZf9LHD8Hc/IhqTHIPJJPuv4yCZLsb9AYkGvjJvxtjNrZGyhz1voJ+YLbluH56jNVA+e/nrYReLIvmeZE9+GPlUWhH4gBjaA0Mwd9vnQUjsuB+JVC+vx3M/5qFxJkH6rlb6sAd67ErEeA/mdOQlGxQXmdYkF2KpVAkaC6nXQ7CdnKmGrTocmYYNkCqUpTSrNlWDLkaMqDHFoeg13aHDoi0zd2QvxTDcWuHwyooZop/doq102/2zuTRL14ASU+XqM6YYkaemEIHmyV4a3IHkyWVGw+gl5iXHeJll5JHf3/QvbYyQbkOwnamAEBLmnssprzMglKhh9b412tzXpPu1deitkmSZhcPj6Xh53H2Vq6WZljK6XQX1SauEyOzf8gQHuPq2FA20b9Fm+7ssqJ2ir+Fd82M1LxUfMYb/+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6512007)(7416002)(86362001)(508600001)(956004)(26005)(8936002)(44832011)(6506007)(6486002)(8676002)(52116002)(66476007)(66556008)(83380400001)(2616005)(5660300002)(54906003)(36756003)(38100700002)(37006003)(186003)(6862004)(38350700002)(6666004)(316002)(2906002)(4326008)(6636002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fSNhOsIOxC21jDXCTb1L5BO3KF4TWgwnGGNjkLazR7s8jtXEZ+6AuVTXESUX?=
 =?us-ascii?Q?smSC9I4DuBWsFitmAWyTK/aMcC+2XF/riJmXqZPTRix2DzxdJdgfJk4CRC+Y?=
 =?us-ascii?Q?68oUG7hxXyq3S6XuNUFrOLGAjrfrUJVxomBijaq4winrAmKORKRKG1YAgOFo?=
 =?us-ascii?Q?mbhr+hzfMeZhyLcQdURljvKLoRSXjKC7WJ1LGbbayaJQa/t76bR0Q/5sUcBV?=
 =?us-ascii?Q?YD6mdp8KuiePrsRRvFgTXlRdRXZP2gfQWAXCsCBpN8Ul+FjT0pAwGDEK4SSM?=
 =?us-ascii?Q?6bg3E2/t8y92WTO+JwD94wa2HUvVMbqdpZs/dYx2/LAJdVjR4LNinKqCk8c7?=
 =?us-ascii?Q?K7Q9KfBK0ZD8zkoXKkqgOVsAmpoUi90bnKVJ/jXE3/7rVfT1rG4jN3HwXNgM?=
 =?us-ascii?Q?4ooUy8Wb2voNID5nXYoq8aRx2oCFiKQB9GjK59yCq389mHRhCgtQ9hyVPp6/?=
 =?us-ascii?Q?ZnGwfmta/36KyvkmDVAwqjlMXu+5/9i0L5FNjueonepfWQaaW4rMGZCaxYQ6?=
 =?us-ascii?Q?EfKszIgCx2vGy+84oslgRj6/tLvqgyWLYTdgeWOCVup7qphLQ8Gtu6sOgnZn?=
 =?us-ascii?Q?6gI1lFBoMg8InllZNQiKYM4ik2DqmXK8szwKeNJMFL4rqCybJcGwVkcrNKev?=
 =?us-ascii?Q?LCurM+SICa4lLPvxyM594BhUU/RMH/oZ3/vB2wKwYgZMm+bWSQJmyQxiGjCU?=
 =?us-ascii?Q?zBaM2GUncNLW7JELHU+zJUqfxB01mb8f5ICH+dUW0z8rWujbD3q7Jc/kRmGN?=
 =?us-ascii?Q?vU3du21X7VPm34B1k39jYKnmQlmt+lPqCOzaGG7D+quo6yG7eas//SNKEe8a?=
 =?us-ascii?Q?yTZ+q2TCaK4A0zTWcPbCxkVdsrvOhK7lIhVR0XMGAJGQ052SqKYwFfhXmQPN?=
 =?us-ascii?Q?1MeXUH4vbE27UG7AN9dvAKdBre3mMi/24IaqE92yG7om2VSu8fBBFoet4Tnk?=
 =?us-ascii?Q?m5Plq2eTfU+tEPPFK5nqs3a8000PxGdsxifdYgi5jy0TTrjrOKKfmJqNCMOz?=
 =?us-ascii?Q?qJ9pdiLTnGV1gyB7xp39FshJqVGc7C2xJfh1Hl9fx3qsa9blh/ffemVOc6z1?=
 =?us-ascii?Q?mQEyseEfsVCzBQ4MdheSkYnZJXMZHvNhCtdUnXlSSKrvo8kWRDXmWHxezBUT?=
 =?us-ascii?Q?C+2hVvc/leV7AK9SMBGFHSLZQVTzZbC6gm8RCMdJ4jOH8Oi35YcmCJCOPwUO?=
 =?us-ascii?Q?LCC7qVO/jjbEknBVcqPfmuePFtLVCX5RtYjDmvCQL0QbD6dED7ioOn7C/Llx?=
 =?us-ascii?Q?blQXxopHku0wDZ7Py2lOOdLYDRX32r7SDmf7PES7Vv94FTPlZke3OnAz9Twk?=
 =?us-ascii?Q?i6Nt/1vnSnjEYcORIWa5esVKzZG3OTAhlpBwymVV9TlZMlT/bhBtJGzpu8Uf?=
 =?us-ascii?Q?ko08ZNXnICTsdqXtEc1HgTHRuM8Ye/rVTVnP3IHO8Z8sCgEpKFurg1w8UiB9?=
 =?us-ascii?Q?S6sz+cJXgB4Qf2aFF35WeiJue43M2j5E5xUKqxZ82+uhFybe3oTBTSZQCSNh?=
 =?us-ascii?Q?PtV1E0DgWhcPoQOLDfxgFFgRUZhRXDHfa3dA4J9zvDEbkLbUxU7YyenROD6g?=
 =?us-ascii?Q?ZP1/HH5P/ekx0nG+/if+Wb3wcoW8jhpqnQAhkxB4sgU7Pbg244AuolWHTcmA?=
 =?us-ascii?Q?h/40vaL1WJI9VinuYAS3Pkg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0e07fc-3e09-4b52-0aa8-08d9b1023bb3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 17:29:00.1594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UDvITdrCw4MlTLHbbf/1hJyJwTy6BKR6CAjRmNkkKO0eu3lTGoO0oas8oipIAnAeQeRAQ/NHK6Bv4iduAQjtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2: added patch 5, added Richard's ack for the whole series
sans patch 5 which is new.

Po Liu reported recently that timestamping PTP over IPv4 is broken using
the felix driver on NXP LS1028A. This has been known for a while, of
course, since it has always been broken. The reason is because IP PTP
packets are currently treated as unknown IP multicast, which is not
flooded to the CPU port in the ocelot driver design, so packets don't
reach the ptp4l program.

The series solves the problem by installing packet traps per port when
the timestamping ioctl is called, depending on the RX filter selected
(L2, L4 or both).

Vladimir Oltean (5):
  net: mscc: ocelot: don't downgrade timestamping RX filters in
    SIOCSHWTSTAMP
  net: mscc: ocelot: create a function that replaces an existing VCAP
    filter
  net: ptp: add a definition for the UDP port for IEEE 1588 general
    messages
  net: mscc: ocelot: set up traps for PTP packets
  net: mscc: ocelot: correctly report the timestamping RX filters in
    ethtool

 drivers/net/ethernet/mscc/ocelot.c      | 252 +++++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.c |  16 ++
 include/linux/ptp_classify.h            |   1 +
 include/soc/mscc/ocelot_vcap.h          |   2 +
 4 files changed, 263 insertions(+), 8 deletions(-)

-- 
2.25.1

