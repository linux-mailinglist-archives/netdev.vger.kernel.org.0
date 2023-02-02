Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C5E68725B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjBBAgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBBAgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:36:47 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106DC728ED
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fn4KKTF9MPAvTKDn1tDQo4K/6Wx/7fIS6QdmO1NeePdSm+grA8I0HMBmq+jlGiE+CBGeGzgOfdKpHXYmWitmPgVFzpA2voWG237tND36mQEF9Zm8A4rbCMA/OOCr88WtQn8BG6MZdbWORJpt/MOV88on01vqHqHvyuDoLFayTMVTzN4gtjnAqL52tLpHsdPmrIoXLY1miGS/NbZs34llEHKXjYEUwZ9LPW60GBI/HMq/dZ8Vcmlxh4rZ8S2Rdio1H18fmdnGKqCDKvWgG2Cuy4blrnoyCiOL+MPK7t5/G++yBo7DY4GweVOQs8W9VWEiwLaGxxBipvBpPbBKnXp86A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWELoLYpY/xhvO+bwX2CnE497Ub2vSImKU2XxL1YW9o=;
 b=AKodbmWVqfb6uyRE5mYrNA03VDit7h/tuQGwKHz72nYlNRb0SOOjZqKUkQC/LnMwqkwbBuHZcEiRP/V0j/Zk3aetGTNTRYYtk+2kZ7AiFRZ9Nq7/+ZsVysglkOIZEIXvQd3pWZHrCexucGCECpHDiaVvnZEu1hu9NfTzLwa1BlTpRhMErXJ7jxqnqrjjrPLwkyYVzvYMuIsub5fl+Wf/RDCYSQXg4gBWC+UzXFd9B4d31jPFXWEoFHF6pW11fynaH3HCLYSXCD8OzFCdIXeuoNM5DACVzrmQYIzrl/2seLrXEVBMe/G/ia2MciWj0IJkBjDwyNMpBbP1vCgSGZnNfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWELoLYpY/xhvO+bwX2CnE497Ub2vSImKU2XxL1YW9o=;
 b=dt7h+x8US9pGv9mKntKhY3Q055tpz5HTQLxRGQk2nx2cxIgdVGW5M3297dShjyOqeQFWInv7OyWOtgxGfTjdH8OMZWEGrLOJFEjqLlPxr8HH3u48IaaUj0zPSmgS4dF3PAuQexoBj75OCpNBNoOEX9hKA9ETpLXYNSdT9R5f51E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v5 net-next 00/17] ENETC mqprio/taprio cleanup
Date:   Thu,  2 Feb 2023 02:36:04 +0200
Message-Id: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 4389c7bd-b526-4084-4944-08db04b58d80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jkmbAByqtTzk4ygObUhBWuHBedIYHlWPoUoFrco0ssAfhNlhOu6KRUXDt52/jJd4XOYR7mBOrKFIMdQqLE6jcdsdcDjaEenyKZFO62izB2lwN6VyZGuqg5h9KhabxUTHGzIitKA8GzSbw9eZgL8b7Xo0xv+tJC8lw/z67ZaltN+0djqra5Bibfl5reXBhYn7ej8qTmRFsKuqrCejuGKTguXADbYQO2YwWXYw1dFYxBUc/x9lj85y1hlkpmsQsYQApw5QYH3pG9ijH2zkiXM3SZ/CjU4nG7G0cCYXmoDsr1srohpiYa6oRF8FDFY1MzFOj1wxm/JcsEcBp7EFeMvpUNOiLjHtU0/kwEf/DetnllzCuxeDegYjGYAkjP84fMv+5hL6Kgnp4B+n1hCH88xYWKYmgV2f6fR31Kam8Og9y2zwc4SoPrATY2lDO86KW3F4eDfv/N4+D5kMdV9NzAMVsj69uUWRVlVf2wDxDvpm0zeEiibPckVGgTkN7BevA1hNrUXJT2AFghoVmDQf2r09rLkDGnx5a+rTq5VsuxCq9SsdWbaNs8QrXuoXRxg4cJVYVgkgnWUj10MkYncj76Lj+LKGyWlvH3HzonAIcCYCio1hxVrEefhtM6M4Nb4ux6qoHwYTY61Z/qlC967GHtPgC2nTjRAi5q8Zx3dRBoOJ7UlnSu+Bi0HH/KK5A/xAbHSqmikDUwLzN9dK26F7FPGhEPQwePKY8nyqYhEgoCByNDox1zEqzaJISDMCWY2CK0IpdSJ5gew28kzUxRe597ehKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(966005)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gC17Sa5f4KONX0iqNw5Ra4yI37DCKIv6N+K7jJJ10WmyiwPFgKVlN2vh0Bh0?=
 =?us-ascii?Q?9j/SJEti5/xLIqLjXdJgdetxGfb8Ir3LJTe8da+w2P/L361avBbFxRTN6v1e?=
 =?us-ascii?Q?gWNbYy1cV5kExrJd1ny0SZ+s67iixWJoA3WthX1iAbP1jhrljQaw6PN1c/DM?=
 =?us-ascii?Q?Rk+kZ4HNf31P1UXpitr5vmuNQ/VGxQyVp7JFOoiPOjMNXUSDuWHnA4HzwTB9?=
 =?us-ascii?Q?EQ2zZIRxjkqaYTjYqiHahp6k/9bg+fgwkWPw9O8Dgmwzw5pyBwUYncyAv3EE?=
 =?us-ascii?Q?2cg62iE7sRU+sG1CWOoL6sGTGlC/0be2zlZ2LJY7lYsU//nywvYfm+8fVP07?=
 =?us-ascii?Q?xrUoD2ex8y73pacXYZZ4/J7Vq1dWiWXkWsQN0UfoJCBf9zgcqumO8McbHmXH?=
 =?us-ascii?Q?WegK/JsA8MerPKhlvUOdD7OvVqCM6wTZc+x+hF47kGo+GVj6FPWhh6zKVk0g?=
 =?us-ascii?Q?us+/OE+lgAcj5iwFOHVkXTEebOeQIGat1VK2d3Se9JxdPoY/Yzpp2c/5zJWj?=
 =?us-ascii?Q?JIpOOTPgYMtriSg+jlVkgu7ouLGdycZ9VzN1iqNurZkaIXpSG4bnfxluAi9s?=
 =?us-ascii?Q?/srjj+yIHc/49jcVBtMUznnqeUB6izVpeZnDNVA0qVVpYYlxhKEsl8NF4mFi?=
 =?us-ascii?Q?RBlPyMWx8iAo8NAjoW8FQSFwNh2QIgMOpKU1b7mjpGk+ccjsFkei77HGOHTY?=
 =?us-ascii?Q?/2cEgTKY0rvf8SkbIxreBkMldybRmrW+gLgniTN/m8kd/WB80YE1lnply/Ag?=
 =?us-ascii?Q?px1Cl2Gv9WYAdG7DJUpL3mv9vjGUZeTY4cu/SwEkGIS6kR/6NaoV+Yv1Gi1W?=
 =?us-ascii?Q?dSp5hNHp9yLt4QEBBmYvXfLBwQcFEMmTOQkiA9VaegfdkB7kevqsaKsjLzOl?=
 =?us-ascii?Q?S2enJ8VTCQ+boBzSMq6AVZUJ6Nu9lEcsUq7hsRcyBYJCPljtBbT4uPVEX488?=
 =?us-ascii?Q?XUi7od+IovUkt7AS+sKKTJmyeXRttEIPQnJt9/vPiJ77VJGc5IDWypaGO+m/?=
 =?us-ascii?Q?z1WGlfpRnEfibspFORnbTaO/48Ds541zQHPa8EaEJQm0hB/F6qfKdCDY7hHj?=
 =?us-ascii?Q?IZMEb9MAMGknEuFaYzpHzJ8xFppmSsjhKinF/rtjDBE/VT0HyXuXffgc4WuE?=
 =?us-ascii?Q?y8J1+sQjEOjGZtjNlUJsjiClY7MCJdhTqNNXCFz0BysD+67l2/qGYEaNnIQ7?=
 =?us-ascii?Q?kHmxkBb0PCXWUzVjGoCb0lJPiu2SK5NpW8BUWT3OHkX+mX9WMa+jX1bdUgFa?=
 =?us-ascii?Q?UIfU1VSCZxyQqIVkvlwwEcEzP+woRQ1bg55dXlAD+4rvWTKsGxjyLH5uexnd?=
 =?us-ascii?Q?R/4UzXY1665gaz66uN9ufCkfZKwMZ75BaY0zfFPtXDkxfPSUa8YGOzlM4lfy?=
 =?us-ascii?Q?1LpKmrHzV0DNjdIDuvBK7WwCzPBVo4kwYXNFwwz09ffSDIOravbt8I88Q7g+?=
 =?us-ascii?Q?GZTqZycBiB2c3Wji964seeIevcEB3Ns5GgM9oTlRry7bRwswBAe+vL2DygnJ?=
 =?us-ascii?Q?R8R/JSHUXZneenrmXF1pprBtr7WCOphmFwoTx1Lrjepu+5UL5ubmG1NJLMNv?=
 =?us-ascii?Q?Xa5xR1R1gsame/yqfwcvejzlXS82iMUhEEHLRVsuz18/2fF43sxM7AdrK4zD?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4389c7bd-b526-4084-4944-08db04b58d80
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:43.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5C+B21QMYCfdovxXf1nBR4ly67TUlIY6EuwnMayE0eNAERiHEZqDO0lToX+95nCln05jfuA8mlK6xI9AzUQJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please excuse the increased patch set size compared to v4's 15 patches,
but Claudiu stirred up the pot :) when he pointed out that the mqprio
TXQ validation procedure is still incorrect, so I had to fix that, and
then do some consolidation work so that taprio doesn't duplicate
mqprio's bugs. Compared to v4, 3 patches are new and 1 was dropped for now
("net/sched: taprio: mask off bits in gate mask that exceed number of TCs"),
since there's not really much to gain from it. Since the previous patch
set has largely been reviewed, I hope that a delta overview will help
and make up for the large size.

v4->v5:
- new patches:
  "[08/17] net/sched: mqprio: allow reverse TC:TXQ mappings"
  "[11/17] net/sched: taprio: centralize mqprio qopt validation"
  "[12/17] net/sched: refactor mqprio qopt reconstruction to a library function"
- changed patches worth revisiting:
  "[09/17] net/sched: mqprio: allow offloading drivers to request queue
  count validation"
v4 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230130173145.475943-1-vladimir.oltean@nxp.com/

v3->v4:
- adjusted patch 07/15 to not remove "#include <net/pkt_sched.h>" from
  ti cpsw
https://patchwork.kernel.org/project/netdevbpf/cover/20230127001516.592984-1-vladimir.oltean@nxp.com/

v2->v3:
- move min_num_stack_tx_queues definition so it doesn't conflict with
  the ethtool mm patches I haven't submitted yet for enetc (and also to
  make use of a 4 byte hole)
- warn and mask off excess TCs in gate mask instead of failing
- finally CC qdisc maintainers
v2 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20230126125308.1199404-16-vladimir.oltean@nxp.com/

v1->v2:
- patches 1->4 are new
- update some header inclusions in drivers
- fix typo (said "taprio" instead of "mqprio")
- better enetc mqprio error handling
- dynamically reconstruct mqprio configuration in taprio offload
- also let stmmac and tsnep use per-TXQ gate_mask
v1 (RFC) at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230120141537.1350744-1-vladimir.oltean@nxp.com/

The main goal of this patch set is to make taprio pass the mqprio queue
configuration structure down to ndo_setup_tc() - patch 13/17. But mqprio
itself is not in the best shape currently, so there are some
consolidation patches on that as well.

Next, there are some consolidation patches in the enetc driver's
handling of TX queues and their traffic class assignment. Then, there is
a consolidation between the TX queue configuration for mqprio and
taprio.

Finally, there is a change in the meaning of the gate_mask passed by
taprio through ndo_setup_tc(). We introduce a capability through which
drivers can request the gate mask to be per TXQ. The default is changed
so that it is per TC.

Cc: Igor Russkikh <irusskikh@marvell.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: Daniel Machon <daniel.machon@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: Gerhard Engleder <gerhard@engleder-embedded.com>
Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: Roger Quadros <rogerq@kernel.org>

Vladimir Oltean (17):
  net: enetc: simplify enetc_num_stack_tx_queues()
  net: enetc: allow the enetc_reconfigure() callback to fail
  net: enetc: recalculate num_real_tx_queues when XDP program attaches
  net: enetc: ensure we always have a minimum number of TXQs for stack
  net/sched: mqprio: refactor nlattr parsing to a separate function
  net/sched: mqprio: refactor offloading and unoffloading to dedicated
    functions
  net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to
    pkt_sched.h
  net/sched: mqprio: allow reverse TC:TXQ mappings
  net/sched: mqprio: allow offloading drivers to request queue count
    validation
  net/sched: mqprio: add extack messages for queue count validation
  net/sched: taprio: centralize mqprio qopt validation
  net/sched: refactor mqprio qopt reconstruction to a library function
  net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
  net/sched: taprio: only calculate gate mask per TXQ for igc, stmmac
    and tsnep
  net: enetc: request mqprio to validate the queue counts
  net: enetc: act upon the requested mqprio queue configuration
  net: enetc: act upon mqprio queue config in taprio offload

 .../net/ethernet/aquantia/atlantic/aq_main.c  |   1 +
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |   2 +-
 drivers/net/ethernet/engleder/tsnep_tc.c      |  21 ++
 drivers/net/ethernet/freescale/enetc/enetc.c  | 173 +++++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |   3 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  27 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   1 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 drivers/net/ethernet/intel/iavf/iavf.h        |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c     |  23 ++
 drivers/net/ethernet/marvell/mvneta.c         |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 .../ethernet/microchip/lan966x/lan966x_tc.c   |   1 +
 .../net/ethernet/microchip/sparx5/sparx5_tc.c |   1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   5 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  20 ++
 drivers/net/ethernet/ti/cpsw_priv.c           |   1 +
 include/net/pkt_cls.h                         |  10 -
 include/net/pkt_sched.h                       |  16 +
 net/sched/Kconfig                             |   7 +
 net/sched/Makefile                            |   1 +
 net/sched/sch_mqprio.c                        | 285 +++++++++---------
 net/sched/sch_mqprio_lib.c                    | 114 +++++++
 net/sched/sch_mqprio_lib.h                    |  18 ++
 net/sched/sch_taprio.c                        |  70 ++---
 28 files changed, 538 insertions(+), 271 deletions(-)
 create mode 100644 net/sched/sch_mqprio_lib.c
 create mode 100644 net/sched/sch_mqprio_lib.h

-- 
2.34.1

