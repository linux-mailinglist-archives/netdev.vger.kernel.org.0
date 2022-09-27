Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101C85ED133
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiI0XsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiI0XsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:48:07 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856071B2D25;
        Tue, 27 Sep 2022 16:48:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RahDJZzJLDIEsTnPHeHHHLA554BC8yhDmMIR/TfuQ6GY5jWItj59rISbqBs/oZMoB/b0qKaSlVvWpmfSqK/wK+QlwQEHtX+28xOExeG2SqMSceTrG+Uvk4HnAN6lRb7/ZnjI7d+BCNdka/tDDatCWoiw+QMw6a8hBUEEBtiTPwDArE7xPqy4H+mpQ/0nq07IUw8zCTdC1bFJ2XkYzr72kDPFz10Ebs9zYIL5wqoeMk5YUxvzgknMtURTL4EipEOZVBnsgqvZgEdYegQKM4GSUc1VBBbmtnkt8j0iLfaB4cKCzNYGGsZhKOyIKOuVbrnyeTY7u7RyyeCwBSbxTBYnTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyAuMIrkAuMz5us/4inZFLqxmdMX30NAq4x82Y6sHJ8=;
 b=fnQsolEPaeeti+KcqzznWB3U3BFghndGbrjIHAOWKYuyduVOdYfsqYfbN5uQkhTQ+Ud20VfOrQFnRSlX2ghEzTFysMSM6jSRoT5FTNTXXfiNsO1ZAT1IhgGEJW4Lct8pLLbrW6zUDSQb2EX9YKvjScnmJQlRr/3rd1MhNsdOc0mQa33ie2PR++ehW/0llOmi5q2daodv3c1EO2duh6GtmWcQ+rTko8MtZalqkPt3K2Js1ES9A6Iotb6blbRkAimrDMf7mLh0CLb+JG792v2rxRulyyfOiO6rrrtthYQ8MfuVWsedCxQmyV61Q3qrxNPLfgDLTyuE66RgE5b1znVEhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyAuMIrkAuMz5us/4inZFLqxmdMX30NAq4x82Y6sHJ8=;
 b=p01JqWaXTM9Ij1eLfmM5+UKJPBtUZHn8zAmMWNbCzehdVMsFkk9TB07zSSMUUbIDW5PIfnJBMoTTN1xZp8Sram7JZr3p6FUQia8mAQFVfV8UHAftpJ1d3dSzvT7Td4L1oCX0XV08yaejaYl1FgU8HXrV7+oNFIO24YHOqbj7bJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9444.eurprd04.prod.outlook.com (2603:10a6:10:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 23:48:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 23:47:59 +0000
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
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 0/8] Add tc-taprio support for queueMaxSDU
Date:   Wed, 28 Sep 2022 02:47:38 +0300
Message-Id: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: 172b805e-3175-4d19-b08f-08daa0e2b597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u4LugFOP8FWIq4VGaMiNyF1L9fLnXrh5S8L+HXZEjKyDuBBa0Z1iv6IaU6X1jKfMbYBQT6owVlRoiS2P6KC6p5nkEwX473Zz3AxsgyDXJDD1gyBvsnq6nfyzm5imOpVOQb6XyGqEiFmDuKp8HYWtgoUdfHyxnK2tagie+P7PMlgSzDovK0MQMY50KAAI9Ti4mvhkDOKR1WyVFRwzjVqaGPPLTc9LwdMgiBwVdks+LXTc8QUdjMiFLF6ONZ80yZGTr1u/UZnmPbA+JBnW822GgtKJPf8LDmdSHzhmbAnHFwQhc1NOAST7N6jmbtfGFw3Jztqk/l+WSOWlDbSdq94NRleJTczAyxoYBqaKUHqS9wreWUH/DG8Q5OQhUSUqiraBQgbQNjt6wgQ0MkNzoYaffZt1TARu5E6o7J6Y1FotVcpz4JsbjNtkz0fAv1jMPscumuLgQM81GTVjg8yJbilocG6VBFKN1tZnr5nP9uDm/ZkHD8XPqB1Wwc6T6iC+z7hGTsejFUGq7up+hB6k2f6PhkVvsvgpiXrfjI7DRA6sFEpfFINfmdRRtX3zPNMl3jk+8USigexGKjyILH2UTfg9WEZltxiGIS1568CqFoExDtCCKmx5+pGS1RVmAIWufSAc0vEfytnnpGOpD9DnECqr6S2W+/pd2ruKUY7JnCpFHTQ/VajchJZ9S5i/IhawkJMTSof7S5Nt0ogxXSTxF7AI/a6PE03GHHE+NEEOXVkfEbxWE23eGxrmqL2VhRQXbT4ErKHtEy6XV4apAOom8dAret83oUA5lw3v6nK5zNVccvNb+lAtebyFfqMBPuIJDIbWz5KANwrPNGa23MEI9Ct+OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(7416002)(66899015)(6512007)(966005)(41300700001)(6666004)(36756003)(6486002)(38350700002)(6506007)(6916009)(8676002)(86362001)(66476007)(4326008)(26005)(52116002)(8936002)(66946007)(83380400001)(38100700002)(316002)(54906003)(186003)(1076003)(2906002)(5660300002)(66556008)(478600001)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gB07w/Eb+bulIi6gG5QFJZ6Mm6kYtBUSrEvBQ6l27nrMDi8VHM9kRV1WEk0F?=
 =?us-ascii?Q?4lbX7cPcN3ysscni87V2MpZLHslmvLgPiztTK+jexQMv/P0a/zKzeZRPQAfb?=
 =?us-ascii?Q?IgHaTEBGLwopQxynvfBO3i5wCGSDXmalShAwsgMUjvacjHO/2EMkton8g3uu?=
 =?us-ascii?Q?6Om8f7kQVpxWzo2T6NZi6q4GvfNcb1uPD+Vq/PROQmJZfrDZDY7y/F/0KEOb?=
 =?us-ascii?Q?4XgIPNXcUmpa0B0EoHdtimIM+Elv5IxLj4ujYJdOkj26uEVhOOcZC5tO/jsZ?=
 =?us-ascii?Q?NMwwwvKd+VFdbYMVFh685sLeuWi2hroNlmOacrD3J29wA9QEKFKa6nRNHn0j?=
 =?us-ascii?Q?vHmJG04NDNhlfSdzXZzS7jraJmvLgTz3Jmbnp0UNeujV571lHr2xQqNZuE2/?=
 =?us-ascii?Q?lkNz9J9VaW+nao/cmje0lth3eg7BDfAoB+vsceVg3UVDra6pEkARKv7cC6gg?=
 =?us-ascii?Q?JB6APIQweJMB/u/6C4ZCg+UM+8bSWcR6rONQDcc4yLN3tjUqsQDlsu6qU7ff?=
 =?us-ascii?Q?x4NgNK6gwKkldYHdL46OChcvOLCMmE6p2FoRiUDz/5RBTU1xaFK6As778mvZ?=
 =?us-ascii?Q?gva/oMs0dLEEqn5JPm3KgcPAKAPlg0Qcv5OGIsSnj/PTOICWCUaHi70AUyJG?=
 =?us-ascii?Q?mjpIUzZJJOAhh3diYs2M6rB32OCPWXbkupISv3Rvk/Z51uA1KKOeZ1QnTuFe?=
 =?us-ascii?Q?VQUd0dgyzinXrgtz2Wja0umCyQ2zDWLQS7EekIJm2dcfbgMEUCZcg58j6ebm?=
 =?us-ascii?Q?QMq5c9EHEJdX1Db9M2KwMSjB/AslGgelabrhM6tSybcb6VilftxdC5CkYh7S?=
 =?us-ascii?Q?1fY3QTDsvILH++LtgyDClycijlSwCTbeMVMBku+UYAqekCwNN6MIsW3GuR97?=
 =?us-ascii?Q?zUjOVlYqoMLzmuDWn5c7ZPZ4cSHtWq5L5ALnfkJTEt4PAKWHfCuCzY/KT4wq?=
 =?us-ascii?Q?nz/JiSpIfHz/dMDe9JdE8nCF5kCTDQOX0x82JiZsWY0aLP9vS+K4eZLOaien?=
 =?us-ascii?Q?ioJcyV8eVQ0Z9bmHNQ55VmvDh6oO4NZfr9HfQ6dLdTqwRxV9acv0IkN6yH0H?=
 =?us-ascii?Q?AIFhAEa3heCPV/Ag3y2OLYr2SxgXdZNL6A10H9w79qUCZJHm72UdjC2MRYk4?=
 =?us-ascii?Q?iLI9qp6Hedl0bGcMHYfxm1HFX0WJpzKFw5Murgswev+4tYpsZPU3R5xCMuni?=
 =?us-ascii?Q?zs+rgVLdfB1jash4zs+1txef8eEN2sEU1NscbB0igv+o4JGIMRyYwuYfBpHx?=
 =?us-ascii?Q?Km2NqlOjktA5HubjfCHO5fN6yx8HrdAGONn2O05InYnmJjUsJauxZwzB7jLl?=
 =?us-ascii?Q?2zJNAutnyOFFptpgIJ4/ri3wazejV+atSELLLgv1dAUZUO4J9bBGCg+sEOoM?=
 =?us-ascii?Q?ovDTrWEVjt5ptIzhOyqTh0rHc0IzEi4+udCMc1ONe3jIbgubKe7KI3+HPzsI?=
 =?us-ascii?Q?bmNkfWxP5Vkfva8GUVvYyld298IZhIx9Lz/d4Nx2XuyMir87Gx4tipldPGAT?=
 =?us-ascii?Q?37/tMZmpc4AzBSIjjYdv6SxSDPlF6aMpJW8endLabcrVhg7fPkGxlg7XN3U+?=
 =?us-ascii?Q?36MOt28SNdo9+0EkiSW7yfKnf/Lmm+6gynrly+3yUZbSw2+piTNUbCQYxKPg?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 172b805e-3175-4d19-b08f-08daa0e2b597
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:47:59.7422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZ7hWkYsKZ0dpK5ekxZFad/kQSHuhPdjQANi6Swqcn0xYvISMMnjvQB6rsfmFujoHs4vCO79tjXfNXuq4K2Ztg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v3:
- at Jakub's suggestion, implement a TC_QUERY_CAPS functionality in
  ndo_setup_tc through which drivers can opt into features, rather than
  out of them
- consequently, drop patches to am65-cpsw, stmmac, igc, tsnep, lan966x

Non-changes in v3:
- still not using the nla_policy to limit the range for the tc index
- still not using the NL_SET_ERR_ATTR_MISS() helper to report a missing
  tc entry index attribute
As discussed here, this would actually make things less user friendly,
until iproute2 gains support for policy tables and for meaningfully
parsing the offset to the bad attribute, something which I've no idea
how to do.
https://patchwork.kernel.org/project/netdevbpf/patch/20220923163310.3192733-2-vladimir.oltean@nxp.com/

v2 at:
https://patchwork.kernel.org/project/netdevbpf/list/?series=679954&state=*

Changes in v2:
- precompute the max_frm_len using dev->hard_header_len, so that the
  fast path can directly check against skb->len
- add the newly added lan966x taprio offload to the list of drivers
  which must reject the new option
- add some enetc cleanup patches from
  https://patchwork.kernel.org/project/netdevbpf/patch/20220921144349.1529150-2-vladimir.oltean@nxp.com/
- get rid of some taprio cleanup patches which were merged separately
  via https://patchwork.kernel.org/project/netdevbpf/cover/20220915105046.2404072-1-vladimir.oltean@nxp.com/
- make enetc_vf.ko compile by excluding the taprio offload code:
  https://patchwork.kernel.org/project/netdevbpf/patch/20220916133209.3351399-2-vladimir.oltean@nxp.com/

v1 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20220914153303.1792444-1-vladimir.oltean@nxp.com/



The tc-taprio offload mode supported by the Felix DSA driver has
limitations surrounding its guard bands.

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

As discussed with Gerhard Engleder, the queueMaxSDU may also be useful
in limiting the latency on an endpoint, if some of the TX queues are
outside of the control of the Linux driver.
https://patchwork.kernel.org/project/netdevbpf/patch/20220914153303.1792444-11-vladimir.oltean@nxp.com/

Allow input of queueMaxSDU through netlink into tc-taprio, offload it to
the hardware I have access to (LS1028A), and (implicitly) deny
non-default values to everyone else. Kurt Kanzenbach has also kindly
tested and shared a patch to offload this to hellcreek.

Kurt Kanzenbach (1):
  net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio

Vladimir Oltean (7):
  net/sched: query offload capabilities through ndo_setup_tc()
  net/sched: taprio: allow user input of per-tc max SDU
  net: dsa: felix: offload per-tc max SDU from tc-taprio
  net: dsa: hellcreek: refactor hellcreek_port_setup_tc() to use
    switch/case
  net: enetc: cache accesses to &priv->si->hw
  net: enetc: use common naming scheme for PTGCR and PTGCAPR registers
  net: enetc: offload per-tc max SDU from tc-taprio

 drivers/net/dsa/hirschmann/hellcreek.c        |  94 +++++++++--
 drivers/net/dsa/hirschmann/hellcreek.h        |   7 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  35 +++-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  28 ++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  14 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  10 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  27 +++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  94 ++++++-----
 include/linux/netdevice.h                     |   1 +
 include/net/pkt_sched.h                       |  10 ++
 include/net/sch_generic.h                     |   3 +
 include/uapi/linux/pkt_sched.h                |  11 ++
 net/sched/sch_api.c                           |  17 ++
 net/sched/sch_taprio.c                        | 152 +++++++++++++++++-
 14 files changed, 429 insertions(+), 74 deletions(-)

-- 
2.34.1

