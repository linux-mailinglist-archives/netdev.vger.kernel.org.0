Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0153869CAC4
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjBTMYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjBTMYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:24:00 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2056.outbound.protection.outlook.com [40.107.105.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5864EC666;
        Mon, 20 Feb 2023 04:23:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EF92c9bzzH3PhvyD9cD+o5NzeqyWN75m5LD588Ddri/ZB5n3F/4wV44cB1PtfR8xyn4uWiKPRPBqUWX3OE4KhMVdl0d7C5XG7mRGaoHkFYS5wFCAma+HZ8PzeKKmj6zmdht75t8dL0zd7nWJdmtiYfZVXc4dNrNylt8C+PfdtC8j7dJcUDjtZ7AP1uzOni7uJ9mgglrqFlAk98PiZcopDQFyfd4Iadn3qJoYpwJ/T7ukS+yOZuKeSQQpSOE8HAydDQ99Nt5RWxbeN5S/ET01FLIYfF7rpVshozYQyiwtNniIwJfHSX592ZnHY1EtCM6NvAEcjG4DkY0rF35iU4ukhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+LTUaIE0Ikc7XtpwDkLYIH8r9lvnmmldzltBcOqElc=;
 b=bE/GaoL3J3jnJJxeLpPSjPxUAIRU23QHL5ud8sH2ELlNKWWb728tba36s26e4HYFd89/+8SaNijnHParFZN9kvRESymPQMABEvSsw4DdZRhpgqdi/F4uMPkZUHxlR/KIS9zQB2b244+1DxtZ24TW7KymBVxJwm+IPMVnTrI7TSK2oMTdGZpfi0BqnJc2IIT3ZgibYRLrujOhoG/VUws2G1Co84osZlwMojybCiKjQqbBWKKtePEkFkn7a2sMDXJuAUOwzNOUSCPJFR/iI4uAE5KOHJBDp4OLIyPqjYnaf00pOQguJyVRCu3i2C3IcdSWOcS77LlLQdiUs9uJ042tyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+LTUaIE0Ikc7XtpwDkLYIH8r9lvnmmldzltBcOqElc=;
 b=poRoi/v9tc3hp/wxww3BPNZKZl6eZlqCI0gN9e1cyf0zBOdOp3aoANPMJMjCEM/xCpS+wrtmdoWT38dNsetSd5PKbTiqMyZOIwgXVSR8YCRpRXUqXDStxEkAkXQB6yjrKg/TfYm1JvxX94altKKToI+byFF40LjNgQcn0o/PNfM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:23:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:23:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 00/13] Add tc-mqprio and tc-taprio support for preemptible traffic classes
Date:   Mon, 20 Feb 2023 14:23:30 +0200
Message-Id: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 144a3aca-fa83-4254-7583-08db133d5596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zrrQ1FZ4P1qXtLdqDIvZCbc9QTe88Nx4wW8hmV6g8JmL96cGl4BVCx5NOzjHnyVrk4IF1j+NrfyJdKkp3gpS7dQ+LiJ84cVjjKyFF8gXP2XP3v2Prd9n5UF1VLLDGeyE/16Ssw029FtHM0bujNuJgezplAfp8BS0GBGU8uKBgn1YGc1E0f6KHDg1UbT0oAE3CtzhepRJ6POPJQnWR/ZrAejfyCUtRRC/IQpFZsyDDfwfXMVpVGYRjgL2NI3NjFSuesrVIGmqVX0+BjOxf0kT/dDvXZxcLpzUPh/KVesERYzzJYeWlwgZZkn2AmWspbwZJDrQeUH4bctEq2i/IPrtRW9FXZDTYmE4rNsnd8C/pNLCQM9CWHwOIFimUAoVoZUHH/ZZl/YsLSp1Yk4ATCCbwxmKfBmQmHhI4vziHKa+OzJjLZvxtND2XrK6tPpBbkzFoTzyKyCMy1TpdT5stjTZDLDCAwvJoKOcYnbrgRQABdElkiORxYi3q3Pbkcbi1NWM/P8auX0y6h86wCCn+XxJ09aysxPQiR4WkH0RtDiOBh3GWKDAM8mf0hTCOf2o1TlqrnpqK22mgCIGgp2XO+2zql8rnSF2EHoQc7fYQpNkyJqyRV9c1uJm3m0wraKJYLYuwF42X23lF206r5blZPsEcsLMueRHUhNM/f6sPO9qV2RkQ2pdXR0A3RX8+DYsMfMt73gG2x+jRb5EkTUmo7WnUiPo4/JYUWIDCPFH42rgsT8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(966005)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cr0QwTgZrauCoC6E6uzi1rOjvNvdMp36/Av77nfCJmq+qJaRaeakwZgEnW6P?=
 =?us-ascii?Q?68xsMESvQUWnbqeQRspTWMIMyQ5jp0Lh8DzbXfLjTWsI5DJ0jWjkoHYfoZwr?=
 =?us-ascii?Q?SYW6cLrOQhYWvDsNuU6pAxXzYEsmt6/o1o0p/u09RSXNh7DQAiTFfzkmvYjk?=
 =?us-ascii?Q?JbhUugf5M7qgDZKPMj2owfIUp+2HSd2viHlFpbIiN6WKgPm4qjCSWjBs0x52?=
 =?us-ascii?Q?sbmqcKBE63J7v7n8KNGvp/1BA+bd88CvK7A2JTjSOLIwG/u2eXWcy4B3aF2O?=
 =?us-ascii?Q?VQT4OcM8T3NTN3/tdrc3kZMEEby2qTiHZZe65THPIGEO3hppr1YUJ55ESLp4?=
 =?us-ascii?Q?PHgEo4eVr8lL6lZVbvQtajKbcyDt01ErumAHOU26DdxRFAg38mCKkikjTnnE?=
 =?us-ascii?Q?9D6qSSNV5Mc5+7zGu/SPsTSS7RdEUeQsi/dxcP15Qis9cL5UlWunBsIdz2Ay?=
 =?us-ascii?Q?mCzOpvxSC7n/8PAvivXrBa7Y4xbU8dxzkZk4Qq1WSzVEHWNsf2LEDQd3TLkg?=
 =?us-ascii?Q?kDVwPLz4OucKkJF8bVYLShmJfwFH+BDMr9LutqQ7aZSAOBLBwr90SSxthcs6?=
 =?us-ascii?Q?2O7kYE8IqKNajy9mY/iukKBpFk8TcJOd92Sa4TYlRrlqS6uQghFlf7NCKwyy?=
 =?us-ascii?Q?Jqh3APPsyI4JvzN4Z4Wqcup3PRVcKMr2yxjqhoCgtNy5IxVc8qRdbwRxYIfN?=
 =?us-ascii?Q?JxO7f42aIaz08gBx+8f0JDxKPKixiR6RgaVaHAJ6wBmAqBKzMSD7mOBaQiol?=
 =?us-ascii?Q?K6yCfsdnQYLGbUQdqZluUJ0Wi5rE/2Ohxp7vdmG2L2JoGlZf4xvgRgLraS5O?=
 =?us-ascii?Q?WvtJOzIp/uPhQF6xfaL2VKxVGezdOJG20mYlwcmqeBdfQSnBWWO8/WW18ECa?=
 =?us-ascii?Q?TSmAgdwW7tegZRjPlaXzbM/mI9c8Il7F5m5Dk67C4V6skkvgwlzrrN+Yic5Y?=
 =?us-ascii?Q?3GJvG4heropqhFNUHA3NU4e70MjDoBIwM7A5M//Ix+tQwTqmGX6Ae1yGnkad?=
 =?us-ascii?Q?Jrj87lt8zeXFLsHg0DCPmmTdp2DzLGDrElqGOeVp52/In7iGkaEFyZeQE1HA?=
 =?us-ascii?Q?vkacuklfnhEGAnBmGLRwHptakNbS1wLBYk3jviYvVVciq6qWgbdm+uzFDuPm?=
 =?us-ascii?Q?tvL6H2Yzu83o2JCvor2RDObsNe/GSR8F5Kz1vTBFc/E6NSXO0kj4bqjeSeDX?=
 =?us-ascii?Q?7sL9ZWCKSZSPGAaWk/9Lw9usekvQjYO8NAbviddn0gY8Bl88r+3JNCg75wDJ?=
 =?us-ascii?Q?jVaRNZo95Fe7z6DOLNP2RadZk4qVbrN1XGcn9sFCUnDS9MeQEFOBwLVBBR2Q?=
 =?us-ascii?Q?wD8pt+YVdetWkqwNIeKWejFmFt2jnIOWIdrw5QX2ek3KsIF921PsF/hSwYjy?=
 =?us-ascii?Q?69xu6kpUsXur/gvctjxyFGT8yIHMkT1q/p085EjOynbCDisq8gL4b1II3D+E?=
 =?us-ascii?Q?CYXNQHLHUtVblhWQcjNrhG3mckxuHK1hZWQQSx7aTDsAWdZZ6ROB8/Anx3mq?=
 =?us-ascii?Q?0SuZUMUWNCv9F37Stc4qTuyC5Cm2m4wqEdxyaKXs8wdUtXHu+GYNGcVKJZ1B?=
 =?us-ascii?Q?rZYWNHuPgwQ5+7iw4h0ReiKWJ/jDW7Q3q+H9T5BpCFXfPxMspYxsWB+q4meT?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144a3aca-fa83-4254-7583-08db133d5596
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:23:55.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/uo5bdzQL3uFYq4fZJuH2dt8t48EK3fmM80nGRRcFYgA3ztkjzA91QexB8XEu8CexCFEpBdHfQ9Euf6WQkW9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last RFC in August 2022 contained a proposal for the UAPI of both
TSN standards which together form Frame Preemption (802.1Q and 802.3):
https://lore.kernel.org/netdev/20220816222920.1952936-1-vladimir.oltean@nxp.com/

It wasn't clear at the time whether the 802.1Q portion of Frame Preemption
should be exposed via the tc qdisc (mqprio, taprio) or via some other
layer (perhaps also ethtool like the 802.3 portion, or dcbnl), even
though the options were discussed extensively, with pros and cons:
https://lore.kernel.org/netdev/20220816222920.1952936-3-vladimir.oltean@nxp.com/

So the 802.3 portion got submitted separately and finally was accepted:
https://lore.kernel.org/netdev/20230119122705.73054-1-vladimir.oltean@nxp.com/

leaving the only remaining question: how do we expose the 802.1Q bits?

This series proposes that we use the Qdisc layer, through separate
(albeit very similar) UAPI in mqprio and taprio, and that both these
Qdiscs pass the information down to the offloading device driver through
the common mqprio offload structure (which taprio also passes).

Implementations are provided for the NXP LS1028A on-board Ethernet
(enetc, felix).

Some patches should have maybe belonged to separate series, leaving here
only patches 07/13 - 13/13, for ease of review. That may be true,
however due to a perceived lack of time to wait for the prerequisite
cleanup to be merged, here they are all together.

Changes in v3:
- fixed build error caused by "default" switch case with no code
- reordered patches: bug fix first, driver changes all at the end
- changed links from patchwork to lore
- passed extack down to ndo_setup_tc() for mqprio and taprio, and made
  use of it in ocelot

v2 at:
https://lore.kernel.org/netdev/20230219135309.594188-1-vladimir.oltean@nxp.com/

Changes in v2:
- add missing EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported)
- slightly reword some commit messages
- move #include <linux/ethtool_netlink.h> to the respective patch in
  mqprio
- remove self-evident comment "only for dump and offloading" in mqprio

v1 at:
https://lore.kernel.org/netdev/20230216232126.3402975-1-vladimir.oltean@nxp.com/

Vladimir Oltean (13):
  net: ethtool: fix __ethtool_dev_mm_supported() implementation
  net: ethtool: create and export ethtool_dev_mm_supported()
  net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
  net/sched: mqprio: add extack to mqprio_parse_nlattr()
  net/sched: mqprio: add an extack message to mqprio_parse_opt()
  net/sched: pass netlink extack to mqprio and taprio offload
  net/sched: mqprio: allow per-TC user input of FP adminStatus
  net/sched: taprio: allow per-TC user input of FP adminStatus
  net: enetc: rename "mqprio" to "qopt"
  net: mscc: ocelot: add support for mqprio offload
  net: dsa: felix: act upon the mqprio qopt in taprio offload
  net: mscc: ocelot: add support for preemptible traffic classes
  net: enetc: add support for preemptible traffic classes

 drivers/net/dsa/ocelot/felix_vsc9959.c        |  44 ++++-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  31 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
 drivers/net/ethernet/mscc/ocelot.c            |  53 +++++
 drivers/net/ethernet/mscc/ocelot.h            |   2 +
 drivers/net/ethernet/mscc/ocelot_mm.c         |  52 +++++
 include/linux/ethtool_netlink.h               |   6 +
 include/net/pkt_sched.h                       |   3 +
 include/soc/mscc/ocelot.h                     |   6 +
 include/uapi/linux/pkt_sched.h                |  17 ++
 net/ethtool/mm.c                              |  25 ++-
 net/sched/sch_mqprio.c                        | 187 +++++++++++++++---
 net/sched/sch_mqprio_lib.c                    |  14 ++
 net/sched/sch_mqprio_lib.h                    |   2 +
 net/sched/sch_taprio.c                        |  77 ++++++--
 16 files changed, 474 insertions(+), 50 deletions(-)

-- 
2.34.1

