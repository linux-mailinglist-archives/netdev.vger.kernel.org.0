Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014D85ED978
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiI1Jw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiI1JwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:52:24 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB3DA74CB;
        Wed, 28 Sep 2022 02:52:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFKRljMlPYYF9SWVUZK4QJZ/McB6N23n3PgczwlRKW6+mdqrL05U2AEYlGBn05rP6FHHNagcnbRftFET828xv5Lv1n54VygWMAGoNbMAh5+M0mRGN+ykpJm8yKyR+tuZAOtGV/W/TeQIbwKjGHEBbIAa4evu0VgkKQZf6Ve/T23Kn07sNE4QT7gXaTdGq4B+TgR/UNyrUH3C5iPIMU52X6OFK7CUz5KO4UzC76qUTTPIhuQxNENAP3iMRywsafqPdc6GjvC9Jz0rkuRXwqoIgIsvU7WIzN3grTecfyjKdjlACQ4E+uf7cBJd4FCQMYJgbdw28QdYURSywL98ieTdyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L0Jfsw3heINF0gyVfCTgEDq3j8NKK8SXiQFlAVTaBjA=;
 b=fiLv3UmWyf8GcXOMuwz6csRfjE6R4kMc30nyUFBfhF3Jwq3dvn1vtyL2SRvIR8JH2LAiwTzmb+AH1V6d3mGpptukBJ4xhUMiJgM6lQvIuzW692tzE9GMyVdES8Iw1rOOkVdEL1vnctr6W7jafR7zjXzppPWLqJ+Wt7DWynOUjjErNNemwTrh+E9p+cK5yjzcUhgy/Vwzg+FhpWCbBvcSnSl0vyHr6ohTxrbYgQqNl4+o+c7fmYeIpsxY6qM4eT4eJghJdXR+nnyItIPb0swzsogkjyat9zim8vvaMXeyCepXB82cpeZgg1CQadkLRzIIpuo0OysFVtgRVXNsTXDQjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0Jfsw3heINF0gyVfCTgEDq3j8NKK8SXiQFlAVTaBjA=;
 b=Zp0YvMLUNqw0eO7+ApR1P7qx1yIxfPI1T76NPTMUOAQanBnNzsZQ6LpRXv0uLtsfLn4muHy3mXWAbelA5yuPP788roF7/mqQ7R3Oq+lYwalQp1L7emA7mZzJy+6XuXZONffVd5Ql93X1O5fpWo7ExMCUhnTif/s0GlCh0EVZjd8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:18 +0000
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
Subject: [PATCH v4 net-next 0/8] Add tc-taprio support for queueMaxSDU
Date:   Wed, 28 Sep 2022 12:51:56 +0300
Message-Id: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0006.eurprd05.prod.outlook.com
 (2603:10a6:800:92::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 128036fd-d0cf-4159-0bca-08daa13721ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06jdbQYRpZf3V7AT5eModJD32j5g5xJxtwhThXvVHGI70MQ/L1/yXUr+H8SGUeETj4HYsb69l8xoQh/cHiq4jSlb2ON1jYwpPyD1C2BaWrwwUfLrHg2cifQpihiwezLIb9goFUsRF7EfoCf0Rq7EdD7PAD6vAPE6R5DA6CeBKqx9oFPYzE9lMcC+V1RdXfQfBe2TEejWKChynEaT19mq8dtBd83gpCr9RB2ntAC/C05y8ZgFJb6xVd+N3Fy10nfa7l3U3VTiUgUNlIM8pf41maTY8cbyhy37+RtgqFbS7tHHoKeIy8tz5in7ysw4EsW27DTl/c/YKFLy3gCoaeOVyYSj4dStnp1wf1RoauqFRFNE4xVBu0/o+gHhjNQIS7z2OIPip2h6CKYTn5ITNDFwrPljGCg49NGMm4DtI0gn+OS0ApZ8K/VHe49KNJKXmLDUKrChcfrvPnOvHMK4ZKVFqVEvQYZWR3L/wKbs9i2baGV/RkEMxLNkP708Qn4kgdFXdHltpikWaTe+9+YgP1jhr7m1as5xjBmESNXnmpemgSt7JHlVXseSKc8R4ZRHspRdGfIAiEgrVMY9OHZi3FFhrvqMY7vf8EdXi4aom4fgAqPhadhy2T0w+QnqLAzOLCA4U9EG1pANGE0UhpOJAXZ/18lcatKrflYsB/dVbE4FqRLHsdE+DWJgCr5z5rZTpTlpukILwmVmnevjVtGr+rCxR41D0qcmDf/e4ztdUAKGNwVnH2fFUMPUH4eZXyIsXJBmNj7vdJn0LxO2REIKMuEzzqN3REi0Tw6F4ogLLTn9bHn9KV6hgygr1QSV/RjD/GeDXiDB92FJjgnkOK3Y8mZRJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(36756003)(6486002)(478600001)(966005)(86362001)(54906003)(6916009)(66899015)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BlbaGF3p6cMFCqCwuRiJLI5wirOyI4w0zeI6BCEjFo1c6qVsb1HRftdlI7Aw?=
 =?us-ascii?Q?4Wg5ES0OdymXJivAq0X4WAUB/bOmn1s5SrHG0InKjy+uUTewEh6wnbCRrCg/?=
 =?us-ascii?Q?tyGAuGQJFOL/7ZL3GCwTC9P3i+SxvEsQVyIqN981O3F5iGUXoCeM32Q5kWVD?=
 =?us-ascii?Q?ANuchf1yMJGL1N1bXaU01PV6w2HJVg4R3eKSb2cQI0RcuRp45O+uAKQx6yZh?=
 =?us-ascii?Q?mehD/GLKahSn39DVC1rNO9uxp+hQ0C3ZJb0Yr7y78sWvW4jk694r8rCO+ER9?=
 =?us-ascii?Q?yyKaJ3KXdnZktx4khRnIqm8fo28sFZ0706IcjTdhdQ76SjRE83JTlz+OCH8c?=
 =?us-ascii?Q?9NudWia4FRXW2gSrFrqE4iKdN+3menz10QsB+iJ6AzpCR6kmEnBSJt37BPEm?=
 =?us-ascii?Q?lQptwsDrxE+oWeaI/DQOxUhtmNiyYXyXYCN+TE5O2RWmI8bAO9fP5pXjvMVH?=
 =?us-ascii?Q?zS/DavV8rAPR/QZB+e37jy++lmmtSjmdItOZOxaeltY6+3XGiZz0cWfckt5/?=
 =?us-ascii?Q?A4p6VXnn1DrpjUVCpABB+woxpxFDKe0Fs/Uj9iRrtQvjYUR416U2I7Ggo2N7?=
 =?us-ascii?Q?aEkfX+VfxSBxpeknVcfHqm/fmAYgQ2hQqneCHgwktjTlS0Mx4vm6kQ0TekDs?=
 =?us-ascii?Q?fiQPGnKv1HKSfSGk5skr0c2BabG4bb/HhDUu6jCKD8K7zMidMB7Nhw/PgUGU?=
 =?us-ascii?Q?iWo9MuLw9CuGi5hdfKPkjTT39GT5cPe+v6q9gnF0UJfCsp7sCG7R3cyW3D5Z?=
 =?us-ascii?Q?o9xPr67zf3IhYuZKStJNXu2UO3pz3eQ5Icyy06rkQP7dgQtRC+eX0SZddvzx?=
 =?us-ascii?Q?keQgPepNSBqneZ9vB/8AaNkOc+6vEQ/bPuJ1MNmyp9CtG/siwFO3kJR0COro?=
 =?us-ascii?Q?Rm0OUByYtFfN023nWYr71bJqKIPOTTKupeEXCOY+ux6KuM5Hy/sRdhW911ZO?=
 =?us-ascii?Q?c1VSg0IdFk/Frd3fExEOTMBVi1Ih6BoAJzCzqGvVOIwpgzNVxKWv1fv7PZxw?=
 =?us-ascii?Q?gIkmLqWL+/zA800WfWQZG6SAzjTM6GWQVQl9zwciG3F+dk3ecRkhFPrmrsVe?=
 =?us-ascii?Q?w+EQBmtTud/vMivsYGYTGg/rFQ48r4afzBQHRNqyBYcPLDRNMrJzC1ArtpC2?=
 =?us-ascii?Q?EfUDITZlvi5tY/Ggvfg746VupE7b+ksxJbosGhZIY8TD4SXYFveNuSHcU/Ka?=
 =?us-ascii?Q?pbOn0J1bqwtI1YeJVi64XcCSgE+PYmQlsu3Virf+0Zhxg5pJvHvM53qpTmJg?=
 =?us-ascii?Q?lu0L2QsKHEL6SjIrTmCRtO+NswXOvRFA5g/cXMPCnLNOQ1nto3kB5Br6EoVl?=
 =?us-ascii?Q?OeFTRFbD1Ro4xsJHuhHZwqaw/Fg8Oz+pLiPyU/Dnyx1wmqT3Wmt8LTKrdGCs?=
 =?us-ascii?Q?UotbfoGO7osOYVRU9onQsZXEHF5d9gJn3/K38ZyjmAgoQCiINjDE4rUDegDP?=
 =?us-ascii?Q?2h/7XY5nt6pac2BlGuP8CxockxxIodjWTY7qAsSdjzYOxG+bYfViYt7Fy55j?=
 =?us-ascii?Q?0GIAsI+jfYnQfiPlNnMwwIUqr7OOEux744tl7nD2+mU1ALd0afUggkzlHoBp?=
 =?us-ascii?Q?4HSvomXseYl1R1dFFaQu6LX4cp2ekix+pHHk3vVTvM3msFlPRi+8OYtAIfdd?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128036fd-d0cf-4159-0bca-08daa13721ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:18.8352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zeuudc5HFd4k44DL+XvKU6qeNozU4nN4D5fCDyoEv9317SmWSMvG7EOvNP/PxhBkrCCxImZSNyVE0cvXkJy/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v4:
- avoid bogus fall-through in the implementations of the tc_query_caps
  methods
- fix bogus patch splitting in hellcreek

v3 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20220927234746.1823648-1-vladimir.oltean@nxp.com/

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

 drivers/net/dsa/hirschmann/hellcreek.c        |  96 +++++++++--
 drivers/net/dsa/hirschmann/hellcreek.h        |   7 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  37 ++++-
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
 14 files changed, 433 insertions(+), 74 deletions(-)

-- 
2.34.1

