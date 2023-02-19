Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D531369C06F
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjBSNxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjBSNxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:53:42 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2052.outbound.protection.outlook.com [40.107.104.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C7710F0;
        Sun, 19 Feb 2023 05:53:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyxKJU63dDQNaIXgdPl7LuFIQgQIRadAqIeojiMQ6JpRSFILUNLJbpDnoy6JV5Un16l+AlP4oIdH+nbXnjqsMNEjNqRQ2IazM+m55TnmqZvXv1aApMKWpGk/6UO35xkMBAbURFthiLbyWf7TkZJ+H9F7m69pmlSMt3BZJK9mnyFcwM77e4uLOX4XefuJb2bgaHyM3kf0+o9OD0YxASturG6HAfNKNomNbkxwD5zFFy5tP5WzhFxQCABSieO+Iyq22l69XvyEXMu/28T5VxpIrvPAosgx9eZVxunO/BOFIRueRsWrFoAqd9gpaxaEFynaXpJlP7SyyMVka+2abikSkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jtxnas3KHImqZ8MLI7OEj8KWz7WqZ59N7RTfcukvf2w=;
 b=iQMo1HJWf5dNkaXPLDV+S94BGNjDnEJY3Hsk72y75igNCSdfMOA39I+mCMbzmkmDbCWYClnUn7UdxPWoK6bT/qOOTmBsJSl0TauyjGOj2oC3LEwh+9V6mUjo5YAHb1VoPcMU8uzWWSuVPj3JBvtp/wJwlN16H3Gt7CizKrlpkOb4AjcrmTiakOlu+gUywpFxH/d3xvZ2n21lB0dMfLK3YbvB9YNbMuqVAyj6d70KGue2DS+qw84qbpf2qLSayK0bQV9+l+qyt7PqQjqEetJeO7wKTJeiFX0ChbzBUEX27LkwUgRYXBPd8pYKdoTk7iEkg1Wdkyn8QHCl0ggF1iuOAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jtxnas3KHImqZ8MLI7OEj8KWz7WqZ59N7RTfcukvf2w=;
 b=W1WMOqT9vc9WBraTCLI5hH2MAWggEtnQGu3WO9K7b4euEEDsgpREZdWJBSwL1MBdBGW5ryborLO3DrNzfgXtWAoYL6RwGemnhCT8l7G+bmPqmzv3O081CLS3ExxrrVVmis75VyXIEY6KBXil1ysOyhVeMtKN2QPjRWjN3pZcInM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:37 +0000
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
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 00/12] Add tc-mqprio and tc-taprio support for preemptible traffic classes
Date:   Sun, 19 Feb 2023 15:52:56 +0200
Message-Id: <20230219135309.594188-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: cdb70a43-3242-4d42-6c01-08db1280b2d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XDlg0iWCiH4xc5c5esALfPRJAKzicfQF3K8Fb/euHGY802rs+Z5W6vQFCtIr0xnpVdlkZPfR8B8722tnA8gUZE2mFvZJhs9qNsGG9zWT3Pj5a9m/AveJAzzQhHId/LXmp39kVJ0pBcK6/ke5tdtnEo7XeLyoHagFMaF4fqhLn2gEPHURwSUS4Gm9KhmMXKibrmeb8UbTUmDBd70hOljZI+GzZxeAcrD8zVNeTQ3+QOahq+Y69/ojLnHeF/zvKOzMkmzzp/OTT8KeZafCjlOQdn+XjCCzIgMrqzlh+8AClgjPGBq7JYEmcgxOhTHFp5aldIxgTTxiPJ2JBaT7/8zYICcaH7ryXUQKMNlVy1AyQwFVZWk2vPNzrwJvJbDUDJZwmXkvrwPEJGZ1BLqnIs0f0OxpSrb/X7I+vF0OpNWs6bQDfvWYrIKHjQnWs4qfX5X/PNX+ZRy+w77hZbFk6f272WdoP90l588EuIuAMrVT6HM5BvWFLk16yZ0iCiKErEDGSis9UdZzHEVba9dCpgznY97FXvnoc9opA0jbKRq2Cfzw9P4B4l4Uul7jL8Zu+fGix1sFl41EK4cVFhlRrqmPJTFL7XHDkpX4WVM8vSOLRa3d/VZSq7cd/31XAcIqBh5ohFDVHqMtN41mRL2Sjx2TnaAjXdzdjEkP81ITtkVpNKvcaWgEvD9q24TP/ZycUq9zsmc0dDcwPL6Ns2jrGbyLZm21rISy1I6kLczRNb8gQ2E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(966005)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E5dlTQ4i1BozqL6dV6zi1jXn7z4S6u9D4VtW8v1pJSi1wfMaxmXCJBUmHx5F?=
 =?us-ascii?Q?yA1vg6zy7Nf4Xpy7ZXaQNIhlarv+UpgcXNM2hbtTzHLty9+daLw6/FqJszj5?=
 =?us-ascii?Q?mw/ekg7Wj8i+9Pjyt59Fcxh9qaT/8mvoXX1OK9G9eSdK5ik7+iZ2lPYYMUQG?=
 =?us-ascii?Q?kTocXeHgODnNNXnf8C2Omw/ETvZa/aLbbALap4ZqhMQg/jL43d33kLZRzxbo?=
 =?us-ascii?Q?+SYA6krNXDh16j68NJaFy6vw9x15YAjX2JihEFLMelCG+qVd3s5PGtUPwsr2?=
 =?us-ascii?Q?1FhSw2Hvp6eWHfKYh3uETKQXZY3iZ6U7OxUkAabHXiB8TznpwoaxnyACKO36?=
 =?us-ascii?Q?zcDuF69DwE+vTid/NR1llgy27srrZissuzB6Me0n05ab145r9KZ3AwQAJcv0?=
 =?us-ascii?Q?46zIaYZ1OAz5T1ziG4ttlVfzd+y8xI9HW8/R23CKKgfL+z+mgacxklabbw2b?=
 =?us-ascii?Q?3FmseAHqXgHOKxTIf7N43265wtiO0b7GSxct1eQGl27hCJ2TYZTDr07sHm4X?=
 =?us-ascii?Q?+pva6kcRgOkSY5P/wfIQX2i6AVzHiwDEuxrAtcsHHJ18TGHVMMPXk6v5r94G?=
 =?us-ascii?Q?ra1Z5ZYM0bV+oa/HzyUZPZqIZhpCiQBgBChzKIIkVx79YW0WWsScgM4U/eHO?=
 =?us-ascii?Q?+lMy+nj7DTl9jMOaMG4aBtiM7nYVX3F2E17XPGtAG4cCLfTsQ8nNYpRKDB5z?=
 =?us-ascii?Q?4aYYIUfZBtsmePTe7MoJsZILFJLGTAon50NCUdI6wyDwnRhPiuXVT/z0YL+K?=
 =?us-ascii?Q?zXEMPExRHurmxG2TsJTlNgMyZjFm1njpQxTdEOaPrDac9GygkeyJeb97wE1n?=
 =?us-ascii?Q?VZdTdO77KgPUkpiuPrqbwlUb5uSVazLbucfxInQ+3usaylgYXg/GJHpvc1hA?=
 =?us-ascii?Q?jyqO8Nhh2SOpukklpM6d8MVSijw5Az48E8xC79kT6UqgEausAkGc07M0lqev?=
 =?us-ascii?Q?RSxe2s34z1iWcX3k9I27Is8bWd7F1eFDWY3n1Rrk5A4Xf1aCPjBmyjfChBg0?=
 =?us-ascii?Q?/QPJaOHYh0sJgE7PL203gdsyrs1L2XX/gPXB4HlxyAR1x2htujGIVWyzreaR?=
 =?us-ascii?Q?gJBKf3Y2DzZ4MHFq8Xjy3p2+GnuVAlxhVBrE/m42T9HxXXBOZCW/pB3+3nOw?=
 =?us-ascii?Q?ZOeZ4mFt3ysaqkMOSIEnnfP2hfqBkeY+nF35j+bbX3resOT9McDXT7oWTJmR?=
 =?us-ascii?Q?bgxrq8gkPcQvcT/BRAIajhmtiwh/zjTzWw3V5UUkDcw+LQ+TU6/jQPGhF7Eo?=
 =?us-ascii?Q?QDIssr/pBDbJQApONfQUFCFIDLkdS8dcLbjlSfsaUuFNopMrsHrJNhH0QC2H?=
 =?us-ascii?Q?r1V1Xb0aQsazeSow48mBTcxU9dwBlx4A3b9vmzlIaUZcKqzAl/jFmCav9plz?=
 =?us-ascii?Q?Esb1NyovZXL+gDAZPm3YuzAVMtxEjzr8l+db1G3wUm3XV4exzKoGk/QnXFbk?=
 =?us-ascii?Q?V7yWUoaDPCLKIJrpod1N82ZZzLYqGgwXWVYweBfVL2BYR5FN5DkoTnKdvXJo?=
 =?us-ascii?Q?taovmlglbzmO2kpoHQFUU34+BOsEl9vBMM/VBTm871OpXEdhb5UKylOXFAf5?=
 =?us-ascii?Q?d2vnCTlPmf3q6qyLkqkWX2pdR3XyeP1oMjNYWVJjadJd7dc8HvJdb22kr+lN?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb70a43-3242-4d42-6c01-08db1280b2d5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:37.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeqdFU4fOD184QXRjPNZZotLBEEfk1faK6myhVOt9YgmBhXgSQbsKxwqr87V1dllU5CNsuHxEbuNJg13dbMxxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last RFC in August 2022 contained a proposal for the UAPI of both
TSN standards which together form Frame Preemption (802.1Q and 802.3):
https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/

It wasn't clear at the time whether the 802.1Q portion of Frame Preemption
should be exposed via the tc qdisc (mqprio, taprio) or via some other
layer (perhaps also ethtool like the 802.3 portion, or dcbnl), even
though the options were discussed extensively, with pros and cons:
https://patchwork.kernel.org/project/netdevbpf/patch/20220816222920.1952936-3-vladimir.oltean@nxp.com/

So the 802.3 portion got submitted separately and finally was accepted:
https://patchwork.kernel.org/project/netdevbpf/cover/20230119122705.73054-1-vladimir.oltean@nxp.com/

leaving the only remaining question: how do we expose the 802.1Q bits?

This series proposes that we use the Qdisc layer, through separate
(albeit very similar) UAPI in mqprio and taprio, and that both these
Qdiscs pass the information down to the offloading device driver through
the common mqprio offload structure (which taprio also passes).

Implementations are provided for the NXP LS1028A on-board Ethernet
(enetc, felix).

Some patches should have maybe belonged to separate series, leaving here
only patches 09/12 - 12/12, for ease of review. That may be true,
however due to a perceived lack of time to wait for the prerequisite
cleanup to be merged, here they are all together.

Changes in v2:
- add missing EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported)
- slightly reword some commit messages
- move #include <linux/ethtool_netlink.h> to the respective patch in
  mqprio
- remove self-evident comment "only for dump and offloading" in mqprio

v1 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230216232126.3402975-1-vladimir.oltean@nxp.com/

Vladimir Oltean (12):
  net: enetc: rename "mqprio" to "qopt"
  net: mscc: ocelot: add support for mqprio offload
  net: dsa: felix: act upon the mqprio qopt in taprio offload
  net: ethtool: fix __ethtool_dev_mm_supported() implementation
  net: ethtool: create and export ethtool_dev_mm_supported()
  net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
  net/sched: mqprio: add extack to mqprio_parse_nlattr()
  net/sched: mqprio: add an extack message to mqprio_parse_opt()
  net/sched: mqprio: allow per-TC user input of FP adminStatus
  net/sched: taprio: allow per-TC user input of FP adminStatus
  net: mscc: ocelot: add support for preemptible traffic classes
  net: enetc: add support for preemptible traffic classes

 drivers/net/dsa/ocelot/felix_vsc9959.c        |  44 ++++-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  31 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
 drivers/net/ethernet/mscc/ocelot.c            |  51 +++++
 drivers/net/ethernet/mscc/ocelot.h            |   2 +
 drivers/net/ethernet/mscc/ocelot_mm.c         |  56 ++++++
 include/linux/ethtool_netlink.h               |   6 +
 include/net/pkt_sched.h                       |   1 +
 include/soc/mscc/ocelot.h                     |   6 +
 include/uapi/linux/pkt_sched.h                |  17 ++
 net/ethtool/mm.c                              |  25 ++-
 net/sched/sch_mqprio.c                        | 182 +++++++++++++++---
 net/sched/sch_mqprio_lib.c                    |  14 ++
 net/sched/sch_mqprio_lib.h                    |   2 +
 net/sched/sch_taprio.c                        |  65 +++++--
 16 files changed, 460 insertions(+), 47 deletions(-)

-- 
2.34.1

