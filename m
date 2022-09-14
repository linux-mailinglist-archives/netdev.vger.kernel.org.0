Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D5F5B8BE2
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiINPdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiINPd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:26 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2081.outbound.protection.outlook.com [40.107.22.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A0948CAB;
        Wed, 14 Sep 2022 08:33:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnYGJvzYvjQAjQEEoOQ/Doo0gzollFaahaChpCZrXCy+eSNf65HAlouP7oTkeBw9dJp/bC4hiObN6vcidNoCwJ7jvmc2YCZ+Gq5crl9zPkMIaD1Efqjk2lsVspUI7oE7ezDpGPrfNyw61eXh6wtIFe2N+KB8qAxYQzdqOjlm7yAKLVhRNwzQfgB67g7ekxfxg7xDuUzgUD+aDa7HldUKKuFi2xLyzetCwBjrpXc395hd6mhPNJplyeNJjf0kKDwpianxGAUTpz/mlx2fBG7gx1psTw1pS4UXOiKNhGs6iBU/3wW3FGFcdA7G1TLHQEJ9e78jGTDhsplorYcAF14Dpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMTASKZ06hMuifUmUjeHutjNyYdDt06RQmTbtM6+Q5A=;
 b=MhI0kT2gPb5GfYXbn61GD/MKgpjZ05qiyiSU+7IWOkY9bwmHg2FoWtv1XPH3zZNjtc2fS5gjLh8SnQ585LqbGd4IYfZDrYsOFNxv4esfV2A4KQr2R1Hh6nZAqqQ4J5L2ZM8Mw5D+CgujxJnuSy/xuSRLZxmzKQ4NEbp6qTCMpbbIYdXNyiaJq//AyPgHLEcdSjR+2PuRfhvPsTTwHEDC1SHQ6gE+lLgWVSNvQWsZljI+zz5vaCMUsjfiz3dOn1RBIVt++fUWyLFkFumCs5loCwjxqfZodJNXgBRW9r4b9P1LQlvUQRMD7UtH6MTKBeVU996Xl1qMruOje4nAL0ImwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMTASKZ06hMuifUmUjeHutjNyYdDt06RQmTbtM6+Q5A=;
 b=E/GEcayJqxirsN4S/hiTZ0/wOsHsaQppTFmO10Cz89nhs+zL57T4lBgwh3+UWklhk5iVE160A+R0GQUUuLR9ulNQj4pcX2/4hZWKmZy5Hw6KMxhKvkrAZmsLaT7CGCPzHyrO3MKrhl0NxrU9wCjgwvtPN1YXKm9hY2sOqYbonpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/13] Add tc-taprio support for queueMaxSDU
Date:   Wed, 14 Sep 2022 18:32:50 +0300
Message-Id: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fc9c83f-9f0d-4e0c-e3f1-08da9666752f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FhxvCsNFHNxJQSyG+yPt9QUWS7Gi94Un731oJ97M3oWL5Qv741ocM41LLcg5DnNwPI3MRelA6VTdSxeh5GeFtocQGzZemwv6ZIecbh8GuzYBfdU8qxV2NrybNA4tDi43ozppDv8tKyeGVAt/ZfoyOWCCB3Fa9LVjbBsJAhqxAZOUtwnoA4xUsGE++7YAmhCEK++cSHpAECpOUO8DSIZYMsm+4B2zW0gfe3UhbqqG+BArJ43jwYJ4tpahu+DupgFiUksdZP+nQCtu8O0h1fwuwT165vIrHsKUf4tYz0k3s3XXpdZbPn0HbDzDNgqY0tD4rPJcIEOYh8LwM3bTDVbd+bpeyLyFdW51uijdKWGROvvlFjdDL0MVB+rhaLoh5yQCmNeMbKhHxyB/M5NJ/Cebq3L2q8p+oAR3KynwzP03K87JiHxQUH6a9J+s4QjcgfRxDw/0PkUZJe6qzAb4Q/lg1yXnb6qIEFSHkyobv4U6Z/Onra7N1IQTiTYHhX1lNGKinMQ1ha+PVDGHHRIwBERwa+vEKOkESHhsRl0wz8nM47weqEiftW3+6cFTOQOiqHwF9YX+TlOdwMEJ5fUZiogZFy0K8tITPkq+tr9Zn1NPRTDoo/ZTDTA7BbiMcgUr9Q9Be5E4TEfXkBpZxXCSlh4kEEEE2DlsPvWttF8GKMlODQeDhvvHOWiQwFn5FrzP4CpkE58rzTd7oniAs6r0o8bEAB0wcgo5A3OD7oR2hzV75Hs8fjZIuxHq6t8pbAeEoQdBw6UknNPSLWwpCb5z+UGHfAQCHQjrvo7hdHrGiFdCfw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(966005)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JKmA8desCA+jkapzpItgaXMzjqOwYyjlIfDp3Vf70oheo7t4ND7R/YJDKz57?=
 =?us-ascii?Q?zXXP1D3w+d1S4U9+BVY/ivsYj+B/QKRQyvaOcYt9+glOCWp1bdFvqi8CyzX7?=
 =?us-ascii?Q?0CD3RvZnw/nMXDXwbkrVjHX2kxGFBVaizcS300aTqT+FYQeylqnIERaiJO/q?=
 =?us-ascii?Q?XJlfSYlLBqdE9/sThJ/qbU8iSzX5rBmegSPh4IFHydJ1q7jLQugyahjNCfl+?=
 =?us-ascii?Q?pBuQxcBvpUYymSA53DWv7P9R7otexSY5FvtsdbyWFbGGMe/YRpj/8QRY1orQ?=
 =?us-ascii?Q?m4e5zr3Io2BMLIR62Dhc0bYJwjosgpTs/TMooJ3vHeduNPQEessqTxE5g0Tu?=
 =?us-ascii?Q?1FhEQ7OP+QgMUFt3XVLdxn+Z+yRvD8RpFOKC5ykGURiiqmX/OdzcajhAd7ve?=
 =?us-ascii?Q?kha+yqPswzVS0X83c2FkwAeNRhhMzj628KYx6jnsVaM8x9xlwkApRtPhbigl?=
 =?us-ascii?Q?qt3aGh+iEOLXIc86PTGE/TUtUqAZJllP48VeCPKG/bh82aOVsSVFHdQLA84B?=
 =?us-ascii?Q?2arxor0vdCtKxHY3XC8OrMTP68uMU9l7UxnbbBBPD9BmFKrJrnGLMXZvdXRq?=
 =?us-ascii?Q?mn9A/Xr3kpIUcCGU5vh+9Bbs4la6UNBiRxMaBDKydTyGMW93w8I5xEaIiT1Z?=
 =?us-ascii?Q?N10on453glnHwUiWQq+pqIfUMfI4OoIAUidGXNGf3/Sl4sGbraw0XN2DZeJ/?=
 =?us-ascii?Q?LafBIKXDZx1YI9OGzbDAGLCpW7sIGRb1qmlFjy4/QhM4co7/ZOMBM0s8q2Lw?=
 =?us-ascii?Q?rpyJWL5yKJjqKQSmixKUGjlUtxukvYNeBFoiY/ebGk4sHDt50b4TIBjTjaGv?=
 =?us-ascii?Q?kBp9zrUEQ494526dgZSHcsjPAVQp/FwdmKz2jyDWYOgQAqmnse8wtvFVPUUB?=
 =?us-ascii?Q?A8/7rJpLbd1XfWOjRjncpior8Vtv5EdwwDPPPxLH855NpT/NArFfy5CbTZzM?=
 =?us-ascii?Q?fJBK+6RBkTbH1VyrMF49Lp3HVJBFAZDSlyrrcxtpEudWDS218b0bg41zbrcA?=
 =?us-ascii?Q?25kZKJ4GEdmVc1SQKakHa4rCMwzXxIEriuQ9+W4b1U9PeAwIXZK/lHA87QaQ?=
 =?us-ascii?Q?YNOmR+8vXFmPY3+y4wutelEorBvZHEXiSgrGu5UrDvyPBScPRgIGhHsu0hOB?=
 =?us-ascii?Q?E6uV2oNfGPUPC2lk8bDofD9CX4c9iDEdRVDPxr//KGkVAnlP3ws6dLYMl6YZ?=
 =?us-ascii?Q?xv9BpGSwaHx20fG+vNMfKOX6zq40muHbNDz9Ea1RTG6nCYqVz9Rhm/s1lG96?=
 =?us-ascii?Q?QBQGafaTcFSO3Beqrd8bhMmzit9hefDSdJhYnvajwPENk4A+ltT12xnFhoAU?=
 =?us-ascii?Q?JOPtL4eoVaDIsSUaVLv0JgbRB2+SAAr974f+WlLfbJ5i4DVVtaP2dqO+y9U8?=
 =?us-ascii?Q?q97GBf421609awndpYJ0pSqxVvrgJR/IQ+WW5L0DKDwccpJME4+kjcLx5KeL?=
 =?us-ascii?Q?+A4J8aDlpW2PVdGSyS0dSojnFKX2uxnIfLer1KNkwZl2fOtLsofivwqwM4jb?=
 =?us-ascii?Q?zWv0yxeUUDRqyMLNcvio81f9ptuIoEWmh2AuHnp4nWQ83oQrfX2E6OMrO8M0?=
 =?us-ascii?Q?4H3L14QC6I0FumQ22PzJ1SIa7hCOcn7jSqPSLhsBjBXckTefEvPGiQjEBidL?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc9c83f-9f0d-4e0c-e3f1-08da9666752f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:22.5124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYZPO9UaONfFuHci73+1/Pqs4mJbyub3ACVc26ynH6C06v82J5z/TBoSGm5tn/xKsPImGnc67CvaQjxlN/hSSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael and Xiaoliang will probably be aware that the tc-taprio offload
mode supported by the Felix DSA driver has limitations surrounding its
guard bands.

The initial discussion was at:
https://lore.kernel.org/netdev/c7618025da6723418c56a54fe4683bd7@walle.cc/

with the latest status being that we now have a vsc9959_tas_guard_bands_update()
method which makes a best-guess attempt at how much useful space to
reserve for packet scheduling in a taprio interval, and how much to
reserve for guard bands.

IEEE 802.1Q actually does offer a tunable variable (queueMaxSDU) which
can determine the max MTU supported per traffic class. In turn we can
determine the size we need for the guard bands, depending on the
queueMaxSDU. This way we can make the guard band of small taprio
intervals smaller than one full MTU worth of transmission time, if we
know that said traffic class will transport only smaller packets.

Allow input of queueMaxSDU through netlink into tc-taprio, offload it to
the hardware I have access to (LS1028A), and deny non-default values to
everyone else.

First 3 patches are some cleanups I made while figuring out what exactly
gets called for taprio software mode, and what gets called for offload
mode.

Vladimir Oltean (13):
  net/sched: taprio: remove redundant FULL_OFFLOAD_IS_ENABLED check in
    taprio_enqueue
  net/sched: taprio: stop going through private ops for dequeue and peek
  net/sched: taprio: add extack messages in taprio_init
  net/sched: taprio: allow user input of per-tc max SDU
  net: dsa: felix: offload per-tc max SDU from tc-taprio
  net: enetc: cache accesses to &priv->si->hw
  net: enetc: offload per-tc max SDU from tc-taprio
  net: dsa: hellcreek: deny tc-taprio changes to per-tc max SDU
  net: dsa: sja1105: deny tc-taprio changes to per-tc max SDU
  tsnep: deny tc-taprio changes to per-tc max SDU
  igc: deny tc-taprio changes to per-tc max SDU
  net: stmmac: deny tc-taprio changes to per-tc max SDU
  net: am65-cpsw: deny tc-taprio changes to per-tc max SDU

 drivers/net/dsa/hirschmann/hellcreek.c        |   5 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  20 +-
 drivers/net/dsa/sja1105/sja1105_tas.c         |   6 +-
 drivers/net/ethernet/engleder/tsnep_tc.c      |   6 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  28 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |  12 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  25 ++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  70 +++----
 drivers/net/ethernet/intel/igc/igc_main.c     |   6 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |   6 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c       |   6 +-
 include/net/pkt_sched.h                       |   1 +
 include/uapi/linux/pkt_sched.h                |  11 +
 net/sched/sch_taprio.c                        | 194 +++++++++++++-----
 14 files changed, 283 insertions(+), 113 deletions(-)

-- 
2.34.1

