Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067C74D6A4A
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiCKWvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiCKWve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:51:34 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2041.outbound.protection.outlook.com [40.107.22.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E687D2D459B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 14:25:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrtZZHdcqdTJH9D/ieaFV2MI9DTdBrcqcLzTiF+3DVc+Ay5ew5YtWabsaR2WP1zQLbGYiMTJx8Avk9L85VA1vyC7CHg8lumEO3102XrX+12++uNegK2ikVdR6naIWemoude3hI4TgF6Q1EZ+8lnm1Rmy75NPho5Fd3JKvInIAi9clwOx96DqL1RHjzhlzqPSZJnOWXVxSLAk2vPVKNvC+1aZMKUui8av2X8gs3nfJpGlaLxd+zfxotmwbxEWxVc+vKl1HLetVeBZjNT1U4jkOI7wJdtkk9TvLpgPJWe6Z2v7h4LnHg96dg6hItVP4VZIMRW0+/+a04QUk1jJ1POiqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNXOO29b/zTXRzShsVJVT692WRn1vBnKObCqtIp+ZbM=;
 b=KQbtFsrnSLDRNcmp+kNhvLQTE2UozbnhgH+O0H99OLIzaMsl8tduw2TwQQJrcG6PnhL+qYjElkXitK91hQFAVDrf78xZ4xP8HGkIGrIBWyrXBBGtpyLL2m29ml0ZHN04gVtpWjyvQMxcAqykVlIBEqeBrkulFdHfsrK+O6kcDtjXB5q7i4+4rkmpeMd/z6xxGnOymMFKKRMc5rmAu5E8d7azQYLEZjjzfOKq1MDVwJVg/YYLUPKGUEvCQfqRPuDbjwmIW+VejENoYTryygOGfTDAIp4peDVy1m3IszGcSpwvdhj+xWsrlr24N2FU+3WQw6B83irJbMDwBAzoI8PA1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNXOO29b/zTXRzShsVJVT692WRn1vBnKObCqtIp+ZbM=;
 b=GJHjnd7mgW+8Nr4IepObQoAPU587UGzrzirxyO/XFStV8sWWmExtYU/awztZpRF+QwS3l8Brm8jKROdg7kqdLfawIwCc/3E5yhrKQFyEane7Q3MZh2nt0sdznE9TNySknajwtDPKX6DTvt9yqKfua1xkK4LYq3Y4xGXAcKnp1NA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8934.eurprd04.prod.outlook.com (2603:10a6:10:2e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 21:15:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 21:15:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 0/3] Basic QoS classification on Felix DSA switch using dcbnl
Date:   Fri, 11 Mar 2022 23:15:17 +0200
Message-Id: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0188.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96d2fbff-5501-4be1-ac7d-08da03a4455c
X-MS-TrafficTypeDiagnostic: DU2PR04MB8934:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8934A750E0EA560C2C128E21E00C9@DU2PR04MB8934.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pWEeSlUiX18/7t5FmbKot+8+oLi5PukrZ7hJVt5X9H+JYFHL+2v73w1cs+McKjrxA1XFy3yjMgfh5VFeqHCyfItWt6xphd+FxL74YU+Rki72OfGiKUDw7uhl1BcCUNyintApazBrbfo1BBIFpiwcwQ80Su/Lma1ksllvakX7Q2GoWp8EoP21wWAisuheafqPo1avCCuJQkxT6/Cg85JyKeozGFIdDLznovCN1GVBfdvWwz+suaw/upALdFC5NFeYlLmqyagWoW+Js+VBptxbPE/iqcb11YvgqX3K8btYzhpnT9R8+miOpGJ0ajyRoZ12tJyhUTBK4+j0Qtk2PTMMGgjgJb4GPPFi3d0h+kZWqVYRvn0agCNtfXar3EYUcfTrWzWMpAe2snXO/IEofhFxQGFXlyyXDPNkpAqnnrUNH1q0wndyW4x4VnZTdDUAcLJZfXCEADv/OUsThXTFQG2xY0LNISeDyfYax4IQAmqsvr0EPDc54DQMpiC41SsaZYkKxM0s/BqiuuDzXe8sru+vdpQXsCxOgYvxzpn/WKm+RTa5P67kAwvymhd0EA8SirEw9ZrKmrt0yRsvT+2tLEYAW/EYxSh0p7GikWGfh+CeQ3oNgapeJ5Ee6hCVIILDHcL6U1fyFhv5w65x7cCQFLyv7zhmAqxO9tNCmhLbb4OBvM0xuJx3fQBk5XzoOBTBfIfgFBoPoiZ6Phyrp3oTTqVbx9At6b3Bjp2ubrNtR7tJng/h1D4w3PG3qLqEW771CgR0xX9Ay912R8osLeY0Z/GbBtDLxF31OMeEQY4vubK5vysbACKe8I5ywJjbpiTL2em0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(36756003)(38350700002)(1076003)(54906003)(38100700002)(316002)(66476007)(6512007)(86362001)(508600001)(2616005)(2906002)(8936002)(66556008)(7416002)(6666004)(26005)(6506007)(6486002)(4326008)(8676002)(66946007)(5660300002)(966005)(44832011)(186003)(52116002)(17423001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HSRqIpt9YiqdeCSvsA3OGQ6Xz8eX3eZboIZ8qYjCrBGJ+GMbS8tAlJfgTJyo?=
 =?us-ascii?Q?M0IwMOfWrIM+GxI06LA6CR3S9FjJ/XNz0JCtMPK3QSimTCreeZ9OLZBHHEJI?=
 =?us-ascii?Q?HTikY2aX2ofxDueoJApdyfNw3ZMXjVdFdEZuLdnyEI3oCuaFBhShAzDOo5gm?=
 =?us-ascii?Q?CtjFTu0tpjH4yunkaLLC5Fns6x8SPljdfAhmhWQJ04LIZLHrRoV0gGDTHhyu?=
 =?us-ascii?Q?aZAD46ILH1ESuaeCJGhZVzjk9hBgAZaCtuRZU5f5+aBQ76A6FH/O8/NG4XkD?=
 =?us-ascii?Q?hdSISV3PP+t17TkMEwNSJXDum7QCUtr1DuUBcnjuYXnM08SYavjvCCnYGrVo?=
 =?us-ascii?Q?1lUMU6WECTjoK/eImMuYI70ISDib1LP/wr40jBii4O+W0FY42X3JVGPuQQI8?=
 =?us-ascii?Q?3NuPkQR0GazFs7wdmyBs+9JkhbOX33VRJQ9XYn+8Bj9j7ScDL41cHsRUDIWh?=
 =?us-ascii?Q?9xWhIyf728kbxTCAOAkTffafZTDn5HABTODg5H8+2hr+/Bp/S+z3uq3k8/wn?=
 =?us-ascii?Q?odwz66xDPWb4e32W2LV93+Cqy4VoCnMbqAxzuAyqpx2Ak0PcFfhZmI+2jKfA?=
 =?us-ascii?Q?BfZAh6ovHD6fU96OnsK0BlSZ9+3l1SrowtsTA52eNwMQ61uS5xp0HwE38ZLb?=
 =?us-ascii?Q?tultP3HzkzjEoPukxSDknlhlV0tBTEVEKrksZmzF/2SV2VFNzyayi9s6eYJ0?=
 =?us-ascii?Q?hCw7RWKM1pYYprmG+M+Y0TCKRd8zJgD7ZxoPPJd7BABzjfLdKSpurt0QxWyA?=
 =?us-ascii?Q?QU0it8+FQSwWt8K4dLyJ/CwcmArKcfkswFPBS7Se18AN0AHfs1x9FJeMfqTI?=
 =?us-ascii?Q?PUYmLxY5fQTIBMjEOrA4hPjK5XbPH6UaphRsTVcPvknDmWQqe99GukrkGzeY?=
 =?us-ascii?Q?suehlxbCTWXYs3M/NQoGtCfcrqr42n9OA22HezFQJ9bDmGvkTPJsgqGpLZ61?=
 =?us-ascii?Q?jOAd6sDfpvTnr5WhDSMtqEiPX4t2TZSR5dLsw0YZY+VXjFMesIfbrp0HQYCr?=
 =?us-ascii?Q?jgWz5ph4f8zGKaErVTPfQAy6YwCN92B54oJQE59/l7DbyDH1+53EL6KS9Yj/?=
 =?us-ascii?Q?aqDW+wv/4X0tujP7vBFbRcb6b9SBgAQZCvkZwdkv10mfEtk3Mo887Mn7pWCU?=
 =?us-ascii?Q?enRvufdax2tWi3IJsGPN97ci9A8HW2A6g2b09pwXrzHwOOrDkQyRrrPqZ2Ys?=
 =?us-ascii?Q?bJ3uFSuNhU5b4wgM6iUeLi/bMfLSsoVouObXf3xbWfTKd5j9n+95iCsQNr4/?=
 =?us-ascii?Q?+ka5y0seHkm3g3xSHH4Z4tTXyvTvYWN0pRa47NZLtlnKrFPkPF4JjLoYCBUg?=
 =?us-ascii?Q?bgn1avAh2NPy1jMbscbP+rc1+SRCETD8Co1JywX8XiUnL7TEkqLbUPrWMjnL?=
 =?us-ascii?Q?4pyTL+Ymd27rT6NGOYtqU0kUVesNmdOo8G1axd8dHhgW2NB3tZkemLV5Pi6w?=
 =?us-ascii?Q?v9mxA9vXWjiEegwdktJcdlUVoihKBBlOZkHprw8Cc0J7qr9190UELA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d2fbff-5501-4be1-ac7d-08da03a4455c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:15:30.1598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvRLx6IzjfPhKDAzOLDCQSwhD5v+ugIvDP5W3B/xZrP+KE+knyDPjI5usOwt3FuGLrGk6+xR1hbdc304IK5AZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8934
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basic QoS classification for Ocelot switches means port-based default
priority, DSCP-based and VLAN PCP based. This is opposed to advanced QoS
classification which is done through the VCAP IS1 TCAM based engine.

The patch set is a logical continuation of this RFC which attempted to
describe the default-prio as a matchall entry placed at the end of a
series of offloaded tc filters:
https://patchwork.kernel.org/project/netdevbpf/cover/20210113154139.1803705-1-olteanv@gmail.com/

I have tried my best to satisfy the feedback that we should cater for
pre-configured QoS profiles. Ironically, the only pre-configured QoS
profile that the Felix switch driver has is for VLAN PCP (1:1 mapping
with QoS class), yet IEEE 802.1Q or dcbnl offer no mechanism for
reporting or changing that.

Testing was done with the iproute2 dcb app. The qos_class of packets was
dumped from net/dsa/tag_ocelot.c.

(1) $ dcb app show dev swp3
default-prio 0
(2) $ dcb app replace dev swp3 default-prio 3
(3) $ dcb app replace dev swp3 dscp-prio CS3:5
(4) $ dcb app replace dev swp3 dscp-prio CS2:2
(5) $ dcb app show dev swp3
default-prio 3
dscp-prio CS2:2 CS3:5

Traffic sent with "ping -Q 64 <ipaddr>", which means CS2.
These packets match qos_class 0 after command (1),
qos_class 3 after command (2),
qos_class 3 after command (3), and
qos_class 2 after command (2).

Vladimir Oltean (3):
  net: dsa: report and change port default priority using dcbnl
  net: dsa: report and change port dscp priority using dcbnl
  net: dsa: felix: configure default-prio and dscp priorities

 drivers/net/dsa/ocelot/felix.c     |  43 ++++++
 drivers/net/ethernet/mscc/ocelot.c | 116 +++++++++++++++
 include/net/dsa.h                  |  12 ++
 include/soc/mscc/ocelot.h          |   5 +
 net/dsa/slave.c                    | 223 +++++++++++++++++++++++++++++
 5 files changed, 399 insertions(+)

-- 
2.25.1

