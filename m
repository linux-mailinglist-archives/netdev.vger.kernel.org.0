Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B0E67DA8E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjA0ARB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjA0AQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:16:58 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A70B15559
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:16:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pm/8hgZLyWgikrbWQCVK+pQqDQMe3PQ2h8nCVrtweh/YU7ABPQbh95y04tWWCKitd6ZY6RJOChMWAmadp/JRsO7Mipm560RGt2HAYQ9AhSXMr7Pm4dSu06pDUhvO6TckyQTPdewXk6VpIDzLeLyAcqFoKafs8cdpmaGA6WxmuvUispDlHtiamyzwf+5SlftKMbsLrO0VS/oxDPHkMVV6O3wtkICB7S5qEmhrAnBwUwMJB7VBHdtwN4pfOlR1TkAFQaqTF/NHfLgFyR36IHXzRq5tAT4RDMEa36guoId9aeTDS0AhL90qmCS90T4y7OE1yZXW3GwPyqDKTZGqICkE6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VufY9xKi6UQ2712KSa7Jajt+CXhqwn3kd72+mZyS6YU=;
 b=EeYjspu+GAIXJOyx9K5vgruIZk258bjp6siNd3zkQfpUmT2Tidg4Di+EgRAZB8wyDT3UJTpKofDGCOVDkFhFtrMeR/+HRZGCNHbMUt8rP/YUSlaW1Q3xa+OBtx/WwQuQnt2FyvcLJika6i/o7VtghXmSkpuirQkU0fN1DkISd+mC6a59WvwmNoZxJk8GDGAcPVwVzvAJoPY9etVQe3QpQ+5Kuma36HzkymCnqPA98Hl8sgeEo8e3M1yq1siJfG6m2uvCC+GOoDgGUOC7ol9ncFOM3+fsctJ7MeLNdtHtbwRcLZkGb1PJIcwhuBokfLsH4il84lnCdHrCbGeboNzMuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VufY9xKi6UQ2712KSa7Jajt+CXhqwn3kd72+mZyS6YU=;
 b=eJAiq9qQYw7aR7suJHRkUS+UWRxCjkrf/I/Bktf6pN+9aCf4gadYzY6E/v2OHVAV9ejun5oTP9J/+Jc0X9TtxzXNFkQeRQMBVew7Dfgxq86XL9lJmT0FnvebonuMMVP4XPkyKLBR5RXy6BFWffHUAd1lxs4zJBU5JaMywWn24qU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:15:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:15:57 +0000
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
Subject: [PATCH v3 net-next 00/15] ENETC mqprio/taprio cleanup
Date:   Fri, 27 Jan 2023 02:15:01 +0200
Message-Id: <20230127001516.592984-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: f87285dc-f020-4bac-ba1c-08dafffba93b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VJhN7JGSFun8RSUFZ4aVPmHKkChbfb1ioHVscUm0UUXXP2GtMWnBsmRgy4BoS9VWCsRsYZxxEPkKzw8VJKWwKQtpdUaMRzOjOkjZ9wKvpVvgVFbih7rcIenEGfl/OF3nYmlbCdJgT41cpBmFOpCT/vJGIIExp7EHbxae/sKGmTsSDPDr1v16b9+jFWO2hegJkbQb9zVSyuomFZp2Pb0hu2R2G8JFr2VgGyx3z2JM0l2HJw58gzFTG3+WfXsCZjlN3cel4j0vLWbQzHbqhmeQMV6p7f7Ys6jMVMWAcnsTEfEyTo3i9zniKzgbqyLEA26oa9oljfov0H9nmtMO+h3EhJZRfX0JTemlEv8fXWu69MqKUh+IOFQBH1t+iMHy54BUMp9A71FdnPfx5xUq6XAkf60X5Q8oLJPrW8gdl7sTCvE27DFzFjKHM59ZB5wF7XtSAu17NK6tffKBEyXVdYlteRzGu5JBfZ2+0w671hSSYCWKb8uR4l0Wncan9wU3MlHDSS02urF6w00sRutYVIqZ+ZvY5aypsCDOqPxwUNLAo5GYvbbktYQbBIow0qsQlDXLKXXZhOnkAkvnunN05X9prRm4CKbP1/9cLT+GUjKH2lg31/X9M1wypYhndzjsihK68lUPvPsykAgrd93xeje7GA7ChvjIHa5Tz2z4CDI/817r8WrtHkgZ1tFOTSMiy9zX8A9lP/Zy66x5HQOoJe4BURgFSOY5FBKUeGGhugtlFuLtHkgMDSD33tOXT5WTKlwVDu/V3L9iK9W5kcvIqvQd0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(6666004)(38100700002)(26005)(6512007)(186003)(478600001)(966005)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tv3zCa0uJyba83ONcZnEoqZ3x7ELmrzFLKcIvRFSCL71RUU5BSSpZSqy4ux/?=
 =?us-ascii?Q?oJGPX2daydidLfCY4M5C722hcIv3XdyiV5+YEkHXJvFzVwkHSmPQ1CG8SI+S?=
 =?us-ascii?Q?dD2Nu2nsidYt9ZD4oSb72P9+t1swhSbvJ3TTpaEgjxpfJXtpokK6VRLAYkDI?=
 =?us-ascii?Q?A2u/Hu0wQEvgEx8CTybF4Qu5ojX3GQTUDa7NYbZPaS1O+ypMO1ltmXR8M4Y/?=
 =?us-ascii?Q?2HYWOerqlu0OeP31h7EHnEclsWCBnuMMnwNbuq8HRESyEg2MoHmpOmrCA+Tb?=
 =?us-ascii?Q?GbCuszFWOvQ8h3X5Eu608EvTuYnrNxd3qaLu3As1WOojmeBGndK9qfPFY9w5?=
 =?us-ascii?Q?2iVVOUdzcQKvV/G35ePkC5Rg37tT0LjzH8jddIGliEax+uhdj67ICHgZdMvZ?=
 =?us-ascii?Q?JNsFpD00yzKSUoLqA1sciwoJoZNfIgEqA7Gt+SoXT0N2Hileyf0si5Z0v81Z?=
 =?us-ascii?Q?9GLUZzBinVNR2I+F5P2qqy8MxQrRpDBg2ZAoIgcc1wrBA++hwrd895CEWnsI?=
 =?us-ascii?Q?FvNFyyys5c9mZH3cN1HlO50w8xUhEYtZEguMdbV6QrMFydcvFm6gNv00gOie?=
 =?us-ascii?Q?SiW5kb4etcWqMP9wTivnasBiR8GWdQ2E9ArRGX4z3zGlbfJPsY5xg+Yijjn1?=
 =?us-ascii?Q?syWKrgKAvrdaFeOYydh0PbgZXuZxe2mOcxa0jAKM2Yb1EvEJ0LQt7VdAf2A5?=
 =?us-ascii?Q?G/tF61byUXC0xMMCYfTdkE8dspmfOfIQT2eUTj/Rm7jiWuzzVU6whUlIqPj8?=
 =?us-ascii?Q?QY9dohCZ/zaQXOGYeHLlQe0hPopy/MbPXS+ESDuOxc36Iiu2eGI2xX+ZdsqX?=
 =?us-ascii?Q?3tgkzs3T/4unqlFgyCzHwHgBzPZMYjfKQCHltOPa20ZdvoyhavDzeyJbw03y?=
 =?us-ascii?Q?SXvJe1Rf/eK6NzaVjAqWqhXiFnOwzgPcuRql/rvZ6qAol3d0/+oBPNaPl52N?=
 =?us-ascii?Q?0tFu0pdWa5WrEib9KVVU/KgWGGyO9GPxBa6Z2i5CR3UQdtJ2gGY0XezP0RZ6?=
 =?us-ascii?Q?jtVoLS1dT6vbWGY90SUfkjemgaHNT/aEGchTn5l2CkdCkwYIIfPgaIgy6YFp?=
 =?us-ascii?Q?enDbHa6fNzp1/5L42TsVrvxRWHe+EHBYPfqGGGF3ioa8Nb912YzQ3MVAu2KC?=
 =?us-ascii?Q?rPuYUo/isQwhsDA4STFrwWxsWgE5fHXTrrTmsWaiojjNxoAJILHKhUiRbbOM?=
 =?us-ascii?Q?dfu4KmjrUiBSPDxz6fmA3dt22BZWv7hG8lVQvs6MKN9ts1+gtmNDXdQUkR51?=
 =?us-ascii?Q?iL3Kufu82WN8hhbvd5ZyehMpvw6bEcw6YN2vc1+FgdvKwYBV5Lsnly9W1jiu?=
 =?us-ascii?Q?Eued/zlnxlUVAPjXLJwvKL29mcvBOIrtnZzc+xbbRctreUGa2iGqyK5XfGAw?=
 =?us-ascii?Q?YmjyYnS7TA0il0TAidSswRKqq/2m1N7CePtKnbXkzjvjvprinKclY08OBcwr?=
 =?us-ascii?Q?bC5ZVlsCEX1gZvrkHy0HFd4cHfWoqEWo/hYNBO6xD0hZA3GqDAmP8lpmYZUo?=
 =?us-ascii?Q?nGlOYbP+QOeEbT9J0YZgv1vxkGtHI/x+pAdbfYe7/HLBShxSi6lW8BfitpSf?=
 =?us-ascii?Q?7LG0NwyYCzTTD3eL88bbUf9OIPibkWDu47pQbgK7F58zswVNWPeZXGCY/HNG?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87285dc-f020-4bac-ba1c-08dafffba93b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:15:56.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3WNLAu6DdP9lQPuJlA3aERyPa4z16d50vu3yqenxpSHtXVHWrA0BqsYwu75snrkEtj3Yp8REJa5MuGm6YUUbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main goal of this patch set is to make taprio pass the mqprio queue
configuration structure down to ndo_setup_tc() - patch 12/15. But mqprio
itself is not in the best shape currently, so there are some
consolidation patches on that as well.

Next, there are some consolidation patches in the enetc's driver
handling of TX queues and their traffic class assignment. Then, there is
a consolidation between the TX queue configuration for mqprio and
taprio.

Finally, there is a change in the meaning of the gate_mask passed by
taprio through ndo_setup_tc(). We introduce a capability through which
drivers can request the gate mask to be per TXQ. The default is changed
so that it is per TC.

There are people CCed to patches 07/15 and 15/15 whom I kindly ask to
double check that these changes do not introduce compilation regressions
(due to the movement of the mqprio offload structure) or behavioral
regressions (due to the gate_mask change).

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

Vladimir Oltean (15):
  net: enetc: simplify enetc_num_stack_tx_queues()
  net: enetc: allow the enetc_reconfigure() callback to fail
  net: enetc: recalculate num_real_tx_queues when XDP program attaches
  net: enetc: ensure we always have a minimum number of TXQs for stack
  net/sched: mqprio: refactor nlattr parsing to a separate function
  net/sched: mqprio: refactor offloading and unoffloading to dedicated
    functions
  net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to
    pkt_sched.h
  net/sched: mqprio: allow offloading drivers to request queue count
    validation
  net/sched: mqprio: add extack messages for queue count validation
  net: enetc: request mqprio to validate the queue counts
  net: enetc: act upon the requested mqprio queue configuration
  net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
  net: enetc: act upon mqprio queue config in taprio offload
  net/sched: taprio: mask off bits in gate mask that exceed number of
    TCs
  net/sched: taprio: only calculate gate mask per TXQ for igc, stmmac
    and tsnep

 .../net/ethernet/aquantia/atlantic/aq_main.c  |   1 +
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |   2 +-
 drivers/net/ethernet/engleder/tsnep_tc.c      |  21 ++
 drivers/net/ethernet/freescale/enetc/enetc.c  | 174 ++++++----
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
 drivers/net/ethernet/ti/cpsw_priv.c           |   2 +-
 include/net/pkt_cls.h                         |  10 -
 include/net/pkt_sched.h                       |  16 +
 net/sched/sch_mqprio.c                        | 298 +++++++++++-------
 net/sched/sch_taprio.c                        |  77 +++--
 24 files changed, 473 insertions(+), 218 deletions(-)

-- 
2.34.1

