Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C2F52FFA0
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346576AbiEUViD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346487AbiEUViC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:38:02 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA68527F0
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 14:38:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQOkrwPbs9rY11bWlehVGSQx5+KEOM6f8PKTvxXAd303Z0OCx0iA1cPcHuzs4/WqIA1Pzi2hvmk4cQvKIH7u2e8BAevZMpVlk6FtcsJfCwN7N3M40AdZ70vuGfzxBaEMukMWrti8l5jxOBXSmiz9CIaWxlABXJ+AJkStIdW0vbONJjWzL3M42QYPlzj/LSgxguGGXgWRH3149Ix/KmFtxjDjdvH+iAuDmFv4r5J8CjgAPn3SLGeTRndb8yXTua+zGuFHP+nI3uzlCT6R5j2ZAINwHkhq3mM+hD9jybvAnW5BboQi4CxAkaYR8BF+qiGc7eOW87rEB4ye70cNwbsrrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxRWD2eeMAK8ZK/SNuaQO+UIlHIx/PmI1nFm68kljG4=;
 b=ewDghQWFHdzfVBZUu8elsfkOBTV9Kp3KqZllxbVjlqjVzXU5ihpEixtITlAloDhxXhhUGlgVCcncI31GKlDmc6phz0IbLab50tXalWu2nD0Z3KroQ+0Rd3OYRRTdF+IvTLOSIR8iSPm7ntI5ut0H5F2QrqM02JVia/ijhrNgmNhReQiVi+9tTg+X2w0hbDQgVGHcwckK8AUwke5+VMG5tFXe3dXR4t+0e0V4TKM38LmFnSY9gHUOKDn17Py9q9iHurI158hKv9UV0pNmIvz5s7oVMnRgGTH7qUqecE+rrARF/6Hx1WAwC4hxooeHm63Cd9NM4LotIZ9ule3f1DU79g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxRWD2eeMAK8ZK/SNuaQO+UIlHIx/PmI1nFm68kljG4=;
 b=HgW3XjyQj10T/vIANpdsh1A8IEUqRLSsxnrJnABAZuoqVkNEo9rOdUkcfAUOfTYOeCpze1JQIwI6ia30Jwn8rDjlFb/Q6KCUrDVI9CDh7spJQl9D3CMQzkqkp2WR2C4WlZjdUDtX51GxZUMMXUgDJCP8LuhP4bS1BBWnnsWk9wU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6275.eurprd04.prod.outlook.com (2603:10a6:208:147::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 21:37:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 21 May 2022
 21:37:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 0/6] DSA changes for multiple CPU ports (part 2)
Date:   Sun, 22 May 2022 00:37:37 +0300
Message-Id: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0079.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c3a38ca-2e18-473b-b3bb-08da3b722ba3
X-MS-TrafficTypeDiagnostic: AM0PR04MB6275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB62755BC6D19AD1A1F7B59A00E0D29@AM0PR04MB6275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4KcNvQtkD9GkB/qE8/MsJJ7FLImKoVLcTA7VkE401rNcpnUgunzhl8Axrl4fhpL+/JXIqkA6NxyRXRrsHOAVKQ8QXYavsQpllzaGMDfLZlRtRJq6FUtALFPwr9ABfXOq6gzyhDL8NGExgU0mFFT+uCP/gfOXUmU5z0rS0UNyq8+bCeBh5p4Kn48hHq0TJ5DjHse87v+YrzRGnfx6/yRVhNRePOgFd8qt9Zb5pXjzRT27tZlxBa4LZ/39ncCi/HLFmBtO4tWZqoRInLynKpWozCD9RdAoQgw1VjV8xQbT+t2TW/IGDTfB1YjobIrx9bFt7Zzuc8coRcCbPKMizmpbpcT10toR0v53B3HKr3k0ecSSVnVtHuOlcGq566U0jWkUYB6x3YOfS7yV/Eiv4E5Q4KtS2IZqHyU7awLgmH3WT+I/pNB/bk3vV0dq9P4da9zOBvq+FktrrOsCS1ohzbmymekWKbU52vOPVkTNLQ6xgagtFMqUfD4uO50KDgOojvi/VYx7Z2cJczxuW7ZGrtMFLHMhcRGcgH1l22u8DBoLMQgykO+F2AlzwtI8ynOGlCrelJ72Nn5XlciI4DLDs1Q9HjG+I4xsbtWhEKLIizlVDw3V0t7CMZinWzshZIMQnexLgTnkPkJaHpo6kpu/+dsUKlhE0sLyNOeEZT08PWeZazVDeg7IyywL08gTwZ1L5/3Vb0/acLxEjg+D2IirIifx2sozmtCTiZ814EXYGgl0aSq3LWd7jphFs1vbygZMgKQ1Peh7s76QD/9Cgq9OS8BoTtwO57DOs3ZQI9f5DHiFm0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(86362001)(26005)(6512007)(6506007)(966005)(52116002)(36756003)(2906002)(6486002)(8676002)(66946007)(4326008)(66476007)(66556008)(54906003)(44832011)(83380400001)(7416002)(2616005)(186003)(508600001)(38350700002)(8936002)(38100700002)(5660300002)(316002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kUNL78HPcmNwS1ePMI77XNLKJ9MUOc2BbDuITP65hJcjAfWlwcE2EncVSzfx?=
 =?us-ascii?Q?F16gx91ifEunvN7hvLCC1Trv/lt+YkXClVI+oS5g9/A9YX8aJ8CdEqJC6+pa?=
 =?us-ascii?Q?OUSiLTWFxP9jaw6u9lRrT6o5m58p5Rn0P/Qcd2859Iiz0F7fFo9TalkfyO4q?=
 =?us-ascii?Q?91qVaceMtRCJ9IkvZy3qbo4l4nIXkfvbOQomuHW2IKtGtSepvPtqbasR1wy1?=
 =?us-ascii?Q?Vcuq+XPJ8MIYX5uhkthsN9GfmtkM+iO/4IGL1LRdax15HQZUQbkP2BCBVOOB?=
 =?us-ascii?Q?yzbKp8NLicRretOd0buQuGNfSZPfn0rInpeU7H0Dxx6QL/qKu2bW6W0vrARE?=
 =?us-ascii?Q?zmyTXRPWWGuyYWEq5/9sGHPNPkgiXqcCFVWUjxLdANm3GRSixyfh/EtHJIZC?=
 =?us-ascii?Q?VmjMKVwVUJxGfd2W2UDXXYUEdYC+S8o3L8eIYUPTbPqzsifLgNgMTYBdGY0f?=
 =?us-ascii?Q?aQVtmgJnC635R/Vpuu/4lq8woF0F2hfra9Syn/sC3Sb/6J9C70mMVWQ3G0gO?=
 =?us-ascii?Q?+oQ7dQ4hszoYYs9i2kQ16l2iF8Hd6J0cJHsX+mavnuA77WcZ8zfAfyTitlbl?=
 =?us-ascii?Q?8C5VCvRZtqRf7sphwyysFFJ3IETHvvY+9gDRoPRBpUVCdgFNOJlz7xcJvI0j?=
 =?us-ascii?Q?pGcjRPJGEKLrhEJZj31eoJLKQ0+Q+DJf2qFsiz11DkO8vuGG+/MUtPPA17MF?=
 =?us-ascii?Q?Mjhx3kQpJCa1AKkn0NEt/kLRG4iOi+DWbK/dPU79VGLOmMoZtZlmyJoSytlV?=
 =?us-ascii?Q?g0sMZRKo+gcXlbwGTZ6zNTrBrP+WczpTB8ysCF2jV5pVemEiLeotTxgxho/k?=
 =?us-ascii?Q?qsqNRZQg/sN22ND+7fmY6hMdIhBZ1ZA+g47kur9OFWaN7x7OoO5nHTbFvPCA?=
 =?us-ascii?Q?0sPug8F5Bbzz44PS+ndpYP5dlqKmnXw+Su1ylje11E1/Hc6DRTQ1lctGUmXK?=
 =?us-ascii?Q?ujpFFCKVRsh4HDDncDE+Xc2vF52e6IZ+kxcLXDHdSgfx3aZJs96HReblCxVE?=
 =?us-ascii?Q?xvZGi9cwAc4WzbnRxHaLUt0a7u2OultYy5U2itckSgDOBbcP1bTbKOjR5EV9?=
 =?us-ascii?Q?r/Wrg0wjA5JV0/yNfFcxTlbf2yL3wBkGfEAFGWFu4DaOTmclTNWH/JVZCMqr?=
 =?us-ascii?Q?9IKIjL6h6cPikFekvuXTN+P1Mg7m8Vsyyk2CcAsUkl6dEVysmzDnK3zb3H7U?=
 =?us-ascii?Q?ebwHsdcxKSwQ60sDFYnfdPe4R4DlRK64Cdiiv8G0b8Heho7c9IXRtmXi1v01?=
 =?us-ascii?Q?KLy0fesiOO9LKNJJrilTk730rnp4J3ZjXc4EF+JajFUIfFH+rjR1uV+o6TNw?=
 =?us-ascii?Q?wFzk0DMmBFb0kiX1t7DHPuQ0uhyhkG8SE1NQPU/kpyBWzLGLGV2YLHSNZZoA?=
 =?us-ascii?Q?DTbEeSydcxR8W7Ssz2OC6h1LXTUQHv+I3l7ZnJoeKI0jTV4tW6S0AiJP4vji?=
 =?us-ascii?Q?7XeGQWT+mMKP29eSBJsfL/NuZtlvtBo6uaWa/I0BlaICbLoftbeljr6xNrlc?=
 =?us-ascii?Q?gmTg6N0+LKgivI0SfVk6lxBAifuJkwDzGCELGRuqbunbU8RP+p2IadpQVspA?=
 =?us-ascii?Q?Qj/O7ecVmH1PGH4eBkVHMgsiwu7Xptsng5OZYwudTaJL75JBmz6orzsNAj5s?=
 =?us-ascii?Q?PsgkQygbekYq16uE/y326ejpnkC0oFIbOlByo4B5bXDnZ4J9jExCd5y+hPBP?=
 =?us-ascii?Q?eMZ7HqipeDWXeLKjRdNq1O0G4tMGFTt3PAudcgLFdATHWiPuzsXpSDCccphT?=
 =?us-ascii?Q?7kkRgoyP8uSYUUBvU2/Glb8ukuNhBTk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3a38ca-2e18-473b-b3bb-08da3b722ba3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 21:37:57.3461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRZmpPnG5iXgolzWJOYE46G6VvYJvVgTFA4bGS6vbZnH5yYPe4wIaCu+xP9A+lTE8spqmXjzBjoNiFe97pmNtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in part 1:
https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
I am trying to enable the second internal port pair from the NXP LS1028A
Felix switch for DSA-tagged traffic via "ocelot-8021q". This series
represents part 2 (of an unknown number) of that effort.

This series deals only with a minor bug fix (first patch) and with code
reorganization in the Felix DSA driver and in the Ocelot switch library.
Hopefully this will lay the ground for a clean introduction of new UAPI
for changing the DSA master of a user port in part 3.

Vladimir Oltean (6):
  net: dsa: fix missing adjustment of host broadcast flooding
  net: dsa: felix: move the updating of PGID_CPU to the ocelot lib
  net: dsa: felix: update bridge fwd mask from ocelot lib when changing
    tag_8021q CPU
  net: dsa: felix: directly call ocelot_port_{set,unset}_dsa_8021q_cpu
  net: mscc: ocelot: switch from {,un}set to {,un}assign for tag_8021q
    CPU ports
  net: dsa: felix: tag_8021q preparation for multiple CPU ports

 drivers/net/dsa/ocelot/felix.c         | 173 ++++++++++++-------------
 drivers/net/dsa/ocelot/felix_vsc9959.c |   3 +-
 drivers/net/ethernet/mscc/ocelot.c     | 162 ++++++++++++++++-------
 include/soc/mscc/ocelot.h              |  11 +-
 include/soc/mscc/ocelot_vcap.h         |   2 +-
 5 files changed, 207 insertions(+), 144 deletions(-)

-- 
2.25.1

