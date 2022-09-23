Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE4B5E7FD7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbiIWQda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIWQd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:26 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60040.outbound.protection.outlook.com [40.107.6.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CD413EEA1;
        Fri, 23 Sep 2022 09:33:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=go8WS67jd4MYWLpNAIg62H7FVKcxvOyY1YLwWBAfcjIfkhLggFtRdOt3meyHLCbN3yVGnMb7u9n2+Ns/fVS5y/iWm72clWrJNfIqBXuAlf+R4RnlM1x70xKwtWZvbvrxPyTbiaHTAdl+yEST4WeXtP82y4LFBIRO61bLio8ghhgHx0ZTmhN3g6EsJDTJ3xalpK+39MDunQG7WYAhmzkByI5ldXHNHd5tFtN3vb0RmPQ53UjJriIhgPirOIxwMMEaDiM5eeMG4iirDgBiLKkQBPw7WMEZTA7DM8tPv0BilPdh0vMtX/s9DtJy786iZD3pMIheAEMh5fVBCbkC6NTLZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbRy6toclTowKxVf6hFDcJ3s5tiwQgvPfFT4M0K06us=;
 b=AsoOjlvGn+ubhguXb2+6wa2OhGg+DoyNTf3mH60z7+n6zBKCWjMKtlKZBo8ZhZZ/rK2JkgkRr+OcwS1xeaYEMjVe44e6VNH0CB/BMKK9+jthS2kSDKvymrgF3gIbI+aTy60CZqNtGvX2wjJjqEF7bvLcmik/+vmnFjgY03Gsri7k2RNKaUFDDn2l8KE0eSmgkSrihPmLHCzBmNM+oQToxrsX3ud5FYcsNDdKn0buQIeLPS9NymqW6+7FAyPof0WoBEd6eIFi5Y7UY0rdGw6q+cStyIv2HqJyjIHwsbMMhGp08FBc0W+C8moyYUpKQZdokrcBcGRnWzs55WON78sLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbRy6toclTowKxVf6hFDcJ3s5tiwQgvPfFT4M0K06us=;
 b=qC79nTyqlo62XLid/ZB1O9hoW8mt1QOm/XOqrURdq0spu57EKqQj0CzAr4lX6r9Dvc0qKaovazWKnJarj8sKx2OmnrlebZvyiLKIq241y0YKloD2XRHQqCxPU6YPif8nasMvwO3dH1dnRJHYGaC7LFta/zkcjqIXJbRMel8O+Lo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:22 +0000
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 00/12] Add tc-taprio support for queueMaxSDU
Date:   Fri, 23 Sep 2022 19:32:58 +0300
Message-Id: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e004e76-b90c-458c-0cea-08da9d8154b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXMLhzeb9gf1sL0AqQ9fYqPIcrbaaeufQAQP/is6gcLHouhji8RYhgT4rZH0OOT8XyDG0LwzNgsvDM+dlFGGTk4xPZqk5i6GQYyGmaXJx/3KDN0W8suOYBNirck1s0LUxNY6QNTqsFinhAiWgPcU+HuzlM58okgYJWyGAWx4jEtc5ShOWWuvCExSXav+iyv1TYtOx1e32FeT/Pdi0/EmoUfb2uCq9XSOaGYetHpIXnFTz9LuRe12pZeJtZiqO0HgS5EmMDdFSkwC6ySp9yK+Nhldug5IlRPuyKk6X08sntjnCDdzo9GY3Ytfp0kc7zxyCmrDEu6ZI4f5B1u/HnWN+PNdrPyxBtVs59raCrPAZ38hByuVPjxq8VyhEbuHNDPoltPHcZU/bh/+Ir6DU/UjVR3g2eDRdxfuaTM/G2+sQ8CQGJlJRfzOEc/Z3J6FkSqbiuF+vV4MlAZh61T2gTP6bp3lmHpcmzEJZttlLl08AX0trp9hMPBFDt7ArliyrCbzvNE/FvnLMNkBfBLLA0guJpj0nUqhKkIbBaDzAfg8o5ZzToVnw5upk0VaoNkTn9HApqL1kMNMe6Dboy9V82baMcaJGHD/qqUbtAgYcuws3UoIOIOtLhhAYlXfAJKECb0BTXtL+GEcr5xG+TeA8ksbSuiVOFvX1Kmym+Ma60cwhC57xAo5fs32o0e7cF4KS6ggVVsV29eMJdtGx8IQ5+ipKOjefpjRfEBE3l8BTtD2zMrY4I6M/XE0K8kTlSdDYYGjQH0mUFXNTPBMCHwaWSRJNKpHcatlHWIO804jPb/8amX/lfQtgh1R094ylKR2X1u+rEV/zVhkIxIB/dlY+Mprbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(966005)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DfoRzF3SU4ZHsjtNQzUH3mBUqhp9fezi2jrMuY63C9QGL0Led8CkHS/wTPQj?=
 =?us-ascii?Q?ffWGt6EZu9m9oZkLsa6VIkNzt5jJFBmWQ/8f57CIITy6VCniQIpZee/oT0mE?=
 =?us-ascii?Q?NTuRidtuOGWlRF3cJO5R7s5XHNTCv731UlluXLMyNMLxFU33NnXOy01Z/Je4?=
 =?us-ascii?Q?Dgi/nwpwtpissXZhUb+mfawdunoSbU9zdufWVreGejC+X5DPH/oJzAUtjWrD?=
 =?us-ascii?Q?SZDGT85ZKpaNRjHioCWCl6cwvJ5uvQYJq/2+5x+Owatk3jgOAVxg8QzImIXT?=
 =?us-ascii?Q?uKGCt2XPA8wRCe3dpKSVY80WNqQeh0ypWFdBNLkU0bhcc0Z2pzbgj00HQXWW?=
 =?us-ascii?Q?mcV5tGh8i3jySgWGjNVGyT4q8X+LwLg0h+WgcNechvpZZHxw8GQ5MfCbwq06?=
 =?us-ascii?Q?ct6M69cfHPGS/WM9ddbgsWdoFDsJbG+Zem1HDB7Xl1VE/kVhL3LbipeVmqDZ?=
 =?us-ascii?Q?jgYJGP2IYb6RSlAb7kkJmQCiK78rv4YXqpVF1IPEVNyAMHHhTl34sv1Uqi1Z?=
 =?us-ascii?Q?jOyYFSuOcniYcbYshLjBaLCogXg3qA4NRQ0C1xrryLjAKKR9bkb3f5DDhce8?=
 =?us-ascii?Q?e/nF9AXYbkz9tunnbMBPX+CX1juWPBMTqWiMsQ/RlTlXdpNu2lurPVAlrME5?=
 =?us-ascii?Q?xxqtQGoVK5pum5PAJksZ+BNck0U3+ahTKREzkCXdXqMEGBCVY0aL+QV0YDb8?=
 =?us-ascii?Q?mT8GQrYHoe46navxD+koJLSmEUp/i/y/AwLJ4riahlGUSVHIO5tXAemM7Q8q?=
 =?us-ascii?Q?Twcb+xzXnvc2RP/cjeTr7Muse1F5b9S3siEGmzJA+97hsE09m7e+Iw8Ja+zc?=
 =?us-ascii?Q?/HSzkm/cR6fWfk7cZnsvB80q8q78mYZKk1PTAMGX32I6VpmAiXs1vmuxlpzu?=
 =?us-ascii?Q?TegrheWTfUABEcFv4uvxvSst1r5LSjZOmrEw7HATKblsR0FrwdYLB2Xgmy0S?=
 =?us-ascii?Q?gj5C2ubmpoSbt+dox5hNznf0808EZK1N7Ca5O2iPHaZIk3jfeTO8UAO5wUHq?=
 =?us-ascii?Q?xs0AhFCaYqAwIUORtKJfhWxZDpY1u2OMVu5nl8Af9dB51waqadHXZyy4f4fV?=
 =?us-ascii?Q?uGEZF4IlZYQ8CvtsHmFkBs/FFVXtHTJge98GwQC2l4bPceBE+eoGit1y/BIo?=
 =?us-ascii?Q?9kAEbLOx+Kcyrsy/QtTfSSRM/oJS8OAZ2nyFHDCMQZmvyoZ+zrVk5SWjcJT5?=
 =?us-ascii?Q?hTHwOxzpkHv0Wz3d2XGrrODiHCAPKdJmgDe1foOEZZ0YvQKNaartscPETs2u?=
 =?us-ascii?Q?2wfa5+HjE3TDmglcU6PKb3BqX/r9R5gEBUoD1IdhCn1lLENi1yIZuggk7Sog?=
 =?us-ascii?Q?PZZE4SxLGMhGDG3zx+bs/d9f0ZRHOktRX0jExc+9o8GhtqALNqL7KIykuMkw?=
 =?us-ascii?Q?DJL8b2EvaAwPEPy2T4YSKgn93lOvnhrP98iC78y4SZJdOpswG5hBLU9bcEze?=
 =?us-ascii?Q?y47l2ItyWiWNI5O9WeT6Hcta+5ghf1D0oxbaMm1i3zIGj92h8Li+17KFNgsA?=
 =?us-ascii?Q?Q5DgPHpKexF9f3yyAM5rx5CJ16Z1XIwAf7Sqc8E9aDE7CZyjAADQjv/6NuVV?=
 =?us-ascii?Q?LE+WSKJ4SFnUS8cPwROG/DhIMfEpCfqt1QZVLtY41tXLW/pgwQrWCp69Csba?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e004e76-b90c-458c-0cea-08da9d8154b9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:22.7851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIHMQJCNRFLc9PpyL5Dv+QuQDl8yRuAafmlxu8LrWjJjkjU6IdekAWc6+4EI9cnYEp7fX3w4rk+dWCePqXS0eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
the hardware I have access to (LS1028A), and deny non-default values to
everyone else. Kurt Kanzenbach has also kindly tested and shared a patch
to offload this to hellcreek.

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

Kurt Kanzenbach (1):
  net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio

Vladimir Oltean (11):
  net/sched: taprio: allow user input of per-tc max SDU
  tsnep: deny tc-taprio changes to per-tc max SDU
  igc: deny tc-taprio changes to per-tc max SDU
  net: stmmac: deny tc-taprio changes to per-tc max SDU
  net: am65-cpsw: deny tc-taprio changes to per-tc max SDU
  net: lan966x: deny tc-taprio changes to per-tc max SDU
  net: dsa: sja1105: deny tc-taprio changes to per-tc max SDU
  net: dsa: felix: offload per-tc max SDU from tc-taprio
  net: enetc: cache accesses to &priv->si->hw
  net: enetc: use common naming scheme for PTGCR and PTGCAPR registers
  net: enetc: offload per-tc max SDU from tc-taprio

 drivers/net/dsa/hirschmann/hellcreek.c        |  59 +++++++-
 drivers/net/dsa/hirschmann/hellcreek.h        |   7 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  20 ++-
 drivers/net/dsa/sja1105/sja1105_tas.c         |   6 +-
 drivers/net/ethernet/engleder/tsnep_tc.c      |   6 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  28 ++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  12 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  10 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  25 +++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  73 +++++----
 drivers/net/ethernet/intel/igc/igc_main.c     |   6 +-
 .../microchip/lan966x/lan966x_taprio.c        |   8 +
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |   6 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c       |   6 +-
 include/net/pkt_sched.h                       |   1 +
 include/uapi/linux/pkt_sched.h                |  11 ++
 net/sched/sch_taprio.c                        | 138 +++++++++++++++++-
 17 files changed, 351 insertions(+), 71 deletions(-)

-- 
2.34.1

