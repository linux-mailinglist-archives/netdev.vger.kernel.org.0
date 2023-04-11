Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073C16DE353
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjDKSC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDKSCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:02:25 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6505267;
        Tue, 11 Apr 2023 11:02:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRLQouvAjz8zs2RcIrITKMI9OnyaXbFoHaATx6janBY3Rj6c+MIuTpAoUeh9SDsksBHiqA22T7dWuzQmHe3jRHNlDP4SYMA9+Nhkb7aDBmr0ee7ldNEB9J7mFYN3t0Utuw7AmJvDgVlYCbRer2HmurRMgbq0ZMcPGnULMEnd7lDGzNMMym15Xi2PdCnXfH1gZc2fiwlaHVlHGcWkHTZsVB9rE271koUN9KfU0muLxMT2gbL7RZwN0xHwm7/BkFW/UbvyoRqATeDMMD6AQIBYNc0O0aAkSb31OXN5uYFRKnbrZKBTHJCYcllmHOlD7nXVLh9ALcCsXzGOYYFleUHIMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPS+uvZWF0sLd1JUrumgwP2HpswoRruhs9cVisfY/uA=;
 b=TptKQ0ZSXp1hmHeLxU0horydYg101JXDeFQ5uuAnu5zqd+NHx1wH8naPN8/LQ8o00naZZGH1FIMgI+i7CUebxg6oLJwuNw6Ofxvsks1cRT+izaGIILdr3oXusE8q9gijiwkgvKiRgnLMVIeiMxUt4zFt7DqqgI57c3BlRUomHhLbb6z7/zHnF1x03qzTaw1IMhunAd4nEUaVeYZXhQSAFNobJSOiyI2jKcsaN8OpT2ydO8CtSuUbcesH9b1JFGrIzR8B4DlQ8EKICpsZRJXQ1uAv6SRu9v1qqXZoELU6tSWwtcosg3siD1FqZrWEydnE0Q2sYt3WwoE8UihWFUV1UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPS+uvZWF0sLd1JUrumgwP2HpswoRruhs9cVisfY/uA=;
 b=Q1STq92Y86UqQJ7C39IvdueRDS48217mu9DLjbMCozRhZcPLi2HQT+BF63tA98CUvNvCqS/gGSo5Pacrd1iJfGYUStg/hK3s/surhxjfEEHarf6JEXtXKQgo2kDHrt7i1JO/x40pTu5rCnEkpslX1YXHMo1RtTcHYg889reR5qY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:20 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:20 +0000
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
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 net-next 0/9] Add kernel tc-mqprio and tc-taprio support for preemptible traffic classes
Date:   Tue, 11 Apr 2023 21:01:48 +0300
Message-Id: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 29876c61-c736-4bc0-2314-08db3ab6e4f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXSfqDqm8m6lkAiQ3vjvxb8XcaK0isJnPwQB/k/XhApdwyYCVIdRXUb33YrUuzhe6W7vkshEdnZm5JVrDeGugo/Qc9QpT/sD6tJTI4HoB0l3RvqzxbkYE2mwNmBZDH0zWm5lrMcscYEeH+1XvA2PHIVdH6wb4rvyqtn+OJmAkuU063813tpsIFO90h414GYXbLx5GboAV+2AgDDc67nFTV5Gs+0M0xoLzVRbvXYWrbHiqofiIE/Qcqv0nZrNM8sclZ0CpQqcfySYKzZvWr8UOF0ZVihp56/uibnRxBONbvxN9emekNDjXdhfg2/Cr/dCjrfbN26cTSfY9WiOw9/yAtAw85jCFTkZaxwR/OFZpx8qlyN8SvjXr1/cUqJnRLOxb/Pe/IXTy67rokdtzD9eQMgVmUeCUCj12Uu1Fh85cXV7lmJgBzjv/jvoISTpdM8atxDcrfE2PImPl7A3pM96ZYcaQsjaNFIcI3azk+3WVzSq6rGNCL8cwrjZX9ldgQljB5V52FnkpXV64y26bfbTli7ZDS6Q+nfGX+XzZKvexyPwGesNPbl6kTKvh2NAoe9sAi3wJLAzxXpoMNHyGq9TCsdXCXXGnCDN01+ZZFy0fdoVRW5g4QFgIoHiKFfHzPcqJJXzP39LbvtN9KeIEtlC6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(966005)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m+xNCfzOoRPhx7u+A2WN2CsGVt4fq5+vyR8kuOKWaBFbIEHohneJWko1WYUE?=
 =?us-ascii?Q?H/XkLWPI/jp8dMVI/1FQhT05LjH6Y1WXyZArHVp/i73B+sFAyQWUqIv7GEej?=
 =?us-ascii?Q?UoDdBk5eQWDp/mgcGPx1kS3Box/EjfCSsjqx1dJVFKFrW/UrJRysI6HWvGrR?=
 =?us-ascii?Q?4fw8YO0Anint7DMaPCmG3pc64yOcrv+NuleGBMg1d9sreBoawSMfvvJtRMIL?=
 =?us-ascii?Q?AWhrUm7J/SFCtUuMOuVQc5G+hvoZDnfSUYpa3sLZxAqzALHa0nWsnalqiro3?=
 =?us-ascii?Q?+9w2WgwZqd6IYO/YniakIeB4hIwlc4srR4Yf+glARIiJHFZ2KwvOl/zkfhmz?=
 =?us-ascii?Q?x972fy1wSyiANH0QaO5WHFz0jmJ/cYpD3bgEQ/P9RDKlJyxZEDcoEqO+8RzJ?=
 =?us-ascii?Q?uXC4XIMtU4ms0epSpc+6dETaSBVN+rcbW9Hqtv2I5sXvDuFf8kn21fNle5aW?=
 =?us-ascii?Q?6oOkXhx+3vp1m0UTm3CSSz1prfvJ/vpq93+TItr0azD5zmcnlx63ZhECz9UZ?=
 =?us-ascii?Q?3QTM24ZBfgIW0VAX66ntnIaiK3e/6roDoGMLrY0DpO87Kex1o7MaWO/3oPSM?=
 =?us-ascii?Q?AHHtIJT3Ui5q1WKM81B9K+rVIW95eD2dInjx37HYnPLod1u82+aaeDmQpNvJ?=
 =?us-ascii?Q?0W+YbuhFMTJrSxwLdmHVtYwzcEQEt+XxgBTY/fUcHa894PJqOY3LXJ+1zxwc?=
 =?us-ascii?Q?2C8mKkQ/bQVnkCiUpbHUYqweap4ij60cB6KKriRD8jQnJh9pXC9OPQ6U4sk0?=
 =?us-ascii?Q?iYr5uRQwhea8VRbr9pz15XSWztTCfbD8Eu0Mgt0XryiqQMUnRZfj3y99/XgG?=
 =?us-ascii?Q?RFbS84NAlffkIQnNkxR4WzwrZJ1CyUDmjMPLga3vRxqEI5SeMkwbB7Y3eSJB?=
 =?us-ascii?Q?QUivCAAAzMt5BGFrDW8yS7YBYW/cM1DOPld6APa2KTlDLxLfXcxJeTrGuqVl?=
 =?us-ascii?Q?Pmd7R+ZwGA19ihtrh3M0cuXOKtmpLw0XtWQX6j4nZPvSchsrYK6uKqeiqmVB?=
 =?us-ascii?Q?EFRFWYtFH2SbDB06j78AuaU/YkCyc4+mwN1Y84GRfQ7yoz9v7BGMvwD8dctb?=
 =?us-ascii?Q?fjjUVXILYnnZDZERxCQDFYKuRiVKAkkt5FG9d20cGRK04Qeudu4ioQ0hf9Nx?=
 =?us-ascii?Q?SEY1veapUdtXdsQyCfgknzQ2rtpvVU5a6OYgsjRIXM61r/CqRt/ra9kl5g93?=
 =?us-ascii?Q?XW9+dqll0Zh01jVYTqQRgHvMjdcPtRFW0LOB7mKI9WkLrjYBntzWAT2PZGB4?=
 =?us-ascii?Q?m5ByLnEM7ByO8v0OqC6BZ4v9aLh5F7VPj+HFLM5kXX35buj58lrH7JXFWBHv?=
 =?us-ascii?Q?CAqXxLknfQ7fDl/8GxFu+x5pbT6q+sr/3UAOOr2Jz8hwxCJGlPqmQo00oH01?=
 =?us-ascii?Q?Ofz+DWIiFaUC7ltX7FCS64pEqF11d5PnqNPDu5mHLUHPz24730tvrJE7O5Ks?=
 =?us-ascii?Q?4yCzSZhvkgBfmaKHIITLg+5eo22vJjbJBkcfTZQ9QoDQlb8LJZYC+HbxZiJR?=
 =?us-ascii?Q?jizBJ2s+L9ZEV6bv84pgitCD0Xm1hSXMbO/mVLiJudI/ksJ9d7uSFkN9XQ/V?=
 =?us-ascii?Q?P54VqPvd2BaFiJaumyLrjamLpOgOwUEoOU1fpadLriEyt+aXelzyA7t6ImZw?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29876c61-c736-4bc0-2314-08db3ab6e4f4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:20.5177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hq0p6E9H9GbWG+Ejlmsh1VenUIEfwDvYIH/mK2mxDdjHw5BdMURUPeRQZTnp2kH84X0wXzt9tTnyoMVp3HvGuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

An implementation is provided for the NXP LS1028A on-board Ethernet
endpoint (enetc). Previous versions also contained support for its
embedded switch (felix), but this needs more work and will be submitted
separately.

Changes in v5:
- don't initialize tb twice, nla_parse_nested() does it
- use NL_REQ_ATTR_CHECK() and NL_SET_ERR_MSG_ATTR() for
  TCA_MQPRIO_TC_ENTRY_INDEX

v4 at:
https://lore.kernel.org/netdev/20230403103440.2895683-1-vladimir.oltean@nxp.com/

Changes in v4:
- removed felix driver support

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

Vladimir Oltean (9):
  net: ethtool: create and export ethtool_dev_mm_supported()
  net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
  net/sched: mqprio: add extack to mqprio_parse_nlattr()
  net/sched: mqprio: add an extack message to mqprio_parse_opt()
  net/sched: pass netlink extack to mqprio and taprio offload
  net/sched: mqprio: allow per-TC user input of FP adminStatus
  net/sched: taprio: allow per-TC user input of FP adminStatus
  net: enetc: rename "mqprio" to "qopt"
  net: enetc: add support for preemptible traffic classes

 drivers/net/ethernet/freescale/enetc/enetc.c  |  31 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
 include/linux/ethtool_netlink.h               |   6 +
 include/net/pkt_sched.h                       |   3 +
 include/uapi/linux/pkt_sched.h                |  17 ++
 net/ethtool/mm.c                              |  23 +++
 net/sched/sch_mqprio.c                        | 188 +++++++++++++++---
 net/sched/sch_mqprio_lib.c                    |  14 ++
 net/sched/sch_mqprio_lib.h                    |   2 +
 net/sched/sch_taprio.c                        |  77 +++++--
 11 files changed, 324 insertions(+), 42 deletions(-)

-- 
2.34.1

