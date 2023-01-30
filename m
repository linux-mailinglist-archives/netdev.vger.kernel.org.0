Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112F56817A3
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbjA3Rcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbjA3Rcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:31 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2079.outbound.protection.outlook.com [40.107.241.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E041EB50
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOstu4lVl48rwRKErn1LikTeea0uOB2hq81fAQxvlDLvmy0To/WVHsUBKtZV5rtdqC4hwHCo6QcZMd1W+zjEcbUF3KmCXjSOjgLrW8D0CNDXzYf5jpahpMMBAuLVd+4orXSfFYdRm77BQIBX19Zn6xDIWXxKVTd9+iLqflq/WMWEAwTMV/cpLYeHBYIitBd5eUX86vYxUAd5sRNekaGdbdUgTpY7zxh4srt0D5hqETNKbaKD4UC/1yDATG2GD+0mq2Nm0k5EQbiExG2PxruZK9ciCA6IFKLtcPZIArMicFZKyyNv9vdFqRdYd683VE254TGnV3Oji8pIst6T5HmVnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8amqR4J5yiw+YzqwyMjewmZANeV4ZhPQhmdsluEI+qo=;
 b=IQxcVkLe0ILZCQgw5r5oClFJCLjxnQJxg+NcrRUuAWCHedWIatT7T1oaBgezAaX7ZNQ94XDvj7leHbOdsSVQJfwy9fbL1y7+ntIAk12LA0zCfNY54D6VYctwoMwa8LUBR2YfaKj1Rne4HZHOS7yD4EbbTBXj24b4lzXB0tfBM82uloujEvV0mMWtoCuUgaTmqYDXobW5OpMFk7oMiePdeREB1MAkxUEbVLoExH3DVTUV/ZjuZXA0/0mVZiqFf19ifIEVYEBxWBb16vnjoZAYAMUzGaolWt1rrUHI4hMtu0sLoAsm4O0QyHhmHio+4tpi9O24HtreX+SSZ0oqc1ljrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8amqR4J5yiw+YzqwyMjewmZANeV4ZhPQhmdsluEI+qo=;
 b=JJSd6WWERtGIrF3S/mh/VzKnOBbUvyhUBEtSIV3KcKH7x2wwvT22OaiAfT4721AreNULv/EJQYcylHP+RRN0CApy74v6SNG/2n16TP1T4YYb+SxFueTGRamk+HDcMJOEZesrRkDp9cKI6Fi+5yIJzNw7f22hnXEEB69NbKac4D4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS8PR04MB8547.eurprd04.prod.outlook.com (2603:10a6:20b:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:05 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:05 +0000
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
Subject: [PATCH v4 net-next 00/15] ENETC mqprio/taprio cleanup
Date:   Mon, 30 Jan 2023 19:31:30 +0200
Message-Id: <20230130173145.475943-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS8PR04MB8547:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3670be-ec44-4140-1734-08db02e7e7ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nd5pBdyA9yi6taUbTarBTgUpLRYGRjqx5bGlkREHwWf3z1FW5jVKQfc0xhApayiRcQ6rV7ve+98YUgNATqZnpnFOzLxPg/1p5tRi0h88S2ibqAYhbxYu3icMMlBmornNPnQxLTbtWkBrJ90pOVB6TVgKHk+37Ijt7W+xy3hn5cljNBJX1h4S1DM9cY0CGhElW/QVWbv24FcTNloqYPOsjimFqLtx1qWJMo7k8DOGPdmTHXtfTf0Ychof6S4NewMCXYAZJHRFoD8D4wMdu1MH5iaG72B+C4+38NdBtFisdSxNlkQ5PGNOt+lLPiZTZ0wOeCYfal3CEHEUA74rQjNqJyaEC8cwZzLXIq5nxXvRv70XyAOZF88QI/xpjm42F1sT0wipb+yYRVQhHeNwWDcSFugHcjtVKsdQCb5epsWfvCpwIy/dJN4f+6VuXCY+XNNljwZf+UMmLQTPdbNasM6DUeDYqJyB1AXRsBPGeePBNfnDWVqQZVT0IzRCHQKnoLDXUVVFMFKYCf5k7wd2rWVvVqLmp3Dit8f/Mjo/h+VmRmXK1PDlsijTIOCOoLn539GLLUVFBnUWvLf84SOeioL9mPKq94uXTEcmHxDWRRERXCfLkFucJVMOw+LpbUNyVbJ8I68a8TS4noNl+bvWeh7n0QhT/iIfEbcPb79B+Ad291x8dpJUWu1K+wyBxCxh6PxqjWs2gWf1MzV/edUCp/nkBL6gTskzPlzW6qNJu7UgASn1lasLdOAc/Ttwg8UVA4hg8P4SJ6D6yWhUVPObJ8z8CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199018)(44832011)(5660300002)(7416002)(36756003)(38100700002)(38350700002)(2906002)(86362001)(478600001)(52116002)(966005)(6486002)(2616005)(6512007)(6506007)(26005)(186003)(54906003)(83380400001)(66476007)(6916009)(66946007)(6666004)(1076003)(4326008)(66556008)(316002)(8676002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZM8vshUHow+v1emPvKCeFBwdWVNS+XVXKqglQJ6y2/xO2gNpXPDvKTmos/Y+?=
 =?us-ascii?Q?HjJlApbzEwzih9iXyZUWJm0KcddL9olBupJF2VkGxbHnOu1RjqtY10nn4rl0?=
 =?us-ascii?Q?0j7j88fMq8xIY5PtV0rRtdr/42hSA2SzQgBB5ucRjQNJhoZksLeT7osog+ti?=
 =?us-ascii?Q?V1yZzoiMY5Piff7pUzg/m7n0ndYqZC2w5x0lWVVH6Zz+o2oieAYtj5o/IisX?=
 =?us-ascii?Q?xw5xGWScI2QeuaXYHThwuUnKkoeEy1xJzYtXj2H/eNt7Z7bAtmZenpqBgjWL?=
 =?us-ascii?Q?BemO7mOHbmjszfgsb8aHi/Yo+SWKdAHiAaAkTaZnt3ssFlf2NKKHU4wLC6yv?=
 =?us-ascii?Q?RNoCuBzJh2Z3voN0lYAq97Aec5h07CxqHAXy+ICRD01uR7/t5TxLzU93fllA?=
 =?us-ascii?Q?Li19ZVWdpChrYTu4ckXOrSWlPzvZjXJ+jr747w6K3TLQ6SpS4CsjPnU8o47Y?=
 =?us-ascii?Q?tDYNyym5SioGwy7lNz5qySilDxTT0HdsUFu/nyRKh9oebHTDdFdEkxzdwGD3?=
 =?us-ascii?Q?sZ2Lvce/tWP/hlirVEoiUgn3Tr82CL43AM74bz/NaiZ1d7z3YVcyqwOGVsCG?=
 =?us-ascii?Q?9hvvsL5gj6B66CJuraAxf2e8aBv0zht/uZsNkerGJaEmyoH4noqb1ZtmAAwi?=
 =?us-ascii?Q?bW440vCq9XoNEVrfxP9u22FB/cX2260i6FoZ2kbHFhVP6CHofxSKhs+AS3r1?=
 =?us-ascii?Q?52273gcLdm1wsQw5uX+wPDgVice9S0za6XtlOG64z9By4zUxX5NnNvZHc7MK?=
 =?us-ascii?Q?bo3v4RIH6kw/tEQfwTlq2fk/DEBGkEFGvDsn0PQlfnmfwXJ2/zoCVWhP5xXJ?=
 =?us-ascii?Q?MGwlEZCtsr1y2INhSPys2lxG6EFLrKNqUTBfB1ybafh/ts2wWbLPP3m7uI+B?=
 =?us-ascii?Q?xOjBrvZGGiokPEQ8WxVvVpJsMtEtqkP6YK95gz7racF6tgVpaJLv+Ahhpn3v?=
 =?us-ascii?Q?ogydtwaeNrvPWLrzTSdTlWvxZt31KsP2Rc9Z1fdrpuQM7kEoyVdAKcvvNjae?=
 =?us-ascii?Q?aptf+2/gqfiLAN65n1iyFa/KpvIs8SDdWzbikCHUHiXEQuqmNMKL/4v4ZrmV?=
 =?us-ascii?Q?psZPXN67BtQgjaPyc7QNoS7xjiHbBotGM7zJd+ZBC9R9Wc1+7q1IVW07eaJK?=
 =?us-ascii?Q?dJx9yqKvCvj8T2yS3OCkAxSXSWmg7/QD+mT11odAShXfuN+9mvIci8m/8cd+?=
 =?us-ascii?Q?DV4iAOukt2qSEsch2ECLmYvjh7rG7wYE7GTTbOhFHlnSnTR2u61wO3g6hkJy?=
 =?us-ascii?Q?oO8wI5h+yDlQ7JOJd8WfReduDSh/O2aW+N+C9HDFYhaM2ESQkkv9v0c4smfi?=
 =?us-ascii?Q?xkWLViikobIB30UK+f/j1KZwsY3MaJe4qyrTtKjyfM/QwAEjxNdor+X8hNrg?=
 =?us-ascii?Q?bRx/FZwakyD4D0mfpvQLGms6uRK84adOv9to60SJN1EM2ZawGReNOcV/XnD5?=
 =?us-ascii?Q?ClYMY+jcF507xaSV3VxRvJSH8jY4+pMRGt8f32r6vD/V+W6Ab1xXyp2swQIu?=
 =?us-ascii?Q?XaJ22MXTk1SQ2Hh65/kdqXDjtA9HpBAu+R3H9GCnvfbXMVhsh/CtwVn6L/2R?=
 =?us-ascii?Q?XtkEF/YxoIGP8IcpdCujlLH/NEVv3kiKji/TOmTy5jqBfegXTcmxpMG9l5vj?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3670be-ec44-4140-1734-08db02e7e7ae
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:05.6172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwMVrL+yFLB3JgxwE8dMydJm6tl6shOPuMSOkaqZVBo3SGSuQO0a3MJFlFTw59x7QYO5/d4/G91E+D5hXBLdIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8547
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please excuse the spam, I had failed to compile-test CONFIG_TI_CPSW with
the previous version. Not deleting an #include is the only delta between
v3 and v4.

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
 drivers/net/ethernet/ti/cpsw_priv.c           |   1 +
 include/net/pkt_cls.h                         |  10 -
 include/net/pkt_sched.h                       |  16 +
 net/sched/sch_mqprio.c                        | 298 +++++++++++-------
 net/sched/sch_taprio.c                        |  77 +++--
 24 files changed, 473 insertions(+), 217 deletions(-)

-- 
2.34.1

