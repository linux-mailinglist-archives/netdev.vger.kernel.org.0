Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1ABA69C07E
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjBSNyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjBSNyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:54:25 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B5710F0;
        Sun, 19 Feb 2023 05:53:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6xM13ygB7KrqzQZC/kXFl7TYGj1bf4JJQAmhieSQZEuzbr1sPJjn+AJrJEi6oc0kL2N/hSqGAvVRPIV5MaodKtmbOWlxCguM28O6dSerMGPG/jERsFRo/FnvNffe4iFjSo3yPx4MlAvSTSJRxH9uiI9WPJfCLpEa6JYWYq1aXtrAX8sO167fHA2tSwbJmf7nnBzPegjheM3MdvbXbDqqR1UZEteNcu1iEqBy4DLQq/9sSrif4QFs/dLIfnIUDOgrdOxYGTFfSAlLE92yXo3/MPqL68i1mnhKZYBEr3XeLeWh4/MIm2dIG9R5rxxiXhxMpRcAWH+I/eUCNc2WwBAyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWA5ZVkzye1cWQMELYAg+E5GiyqEGuVWmdf9EzSQVbM=;
 b=SbiMv4FhWnlv5kClsNt94nlnVi+jwhaxB/4jLAzaeUScP0I0B8+dojBJB8NVou28XnYAdLTW3FaPMpqa2UOGIkAvJBSdrgn2Wb2myGilqZV2I6eUQa2ir7lWGtR+0IggKbEXxFOPMBwSg6L/y8gt2OiGieNfleL73XMVQQKCKGJdxdBXsZDkA8adk17Vnp7nmVyr7GO3OfpmHnfpEL0pg7stxn6snDUcyy/VjsTxu5utyXsrre36fEZG/fn1H8RjO1rD1ffs7cs8smbw+WFBGLXnl3cgJJHutrdCBvtlRTCE1gm5N+ZuJ3nRM1Hgsw9ZWbUOZ7I2OWtVK/7Nguhl2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWA5ZVkzye1cWQMELYAg+E5GiyqEGuVWmdf9EzSQVbM=;
 b=FQL/jHqHqMpedhbvvjUc3xtS6r2xANoA2r7i7sSe5wN7OewpPN/g97g0FkWZ0s+zMNjzvF7KqTBqd5l6ZxGUbbd01dVeXDrKwaPYmRIZs5zl2prj+TZJ+ImG3ZxX1JutM8EBNJF1JxMGluDv48ZsSXsbXVqvVAWQarV8L6389M0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:53 +0000
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
Subject: [PATCH v2 net-next 08/12] net/sched: mqprio: add an extack message to mqprio_parse_opt()
Date:   Sun, 19 Feb 2023 15:53:04 +0200
Message-Id: <20230219135309.594188-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f92ad06-8180-43bd-9313-08db1280bc6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1TjPIbliq730M693J794ImFT69MqsaxiqOSXM0MHL5c0vxga6mrt7GYYV9UYDPMUxe4jJY1qIzhFS9WojMEtvWhWQONb6CsRDct4DIPODntN1uGVlrOm8clTWovqINdhL7RfNMhMf5HZtZ6p7eF4XzkidsXZARUfLcUy6UvAH/6Hp6zD20l1HRaHvNls2QEDtclBAqDG7cVo6NoNveo/Jyyt42vIxJx1rXozRkzS9sZIK3HXPYfgyuzZSOoWV9y7MDuBWt7gDztqqf4GU6HMVBpUHOrP8vvHkHXEgU14LG9uuy5npCv+O22OANT6OGpcDb+HQKSzmoQFoBXoqNEgT40c/1KikT3AUev8JOqRWcIKCBDBKmqNbvKio66QVC7b8FxU4EQHMNpGvrnbW0S9k3idrbN1XSk/btWORUJ1sCxoX22wtBqeeFWKAhlhPnSAybtxoDFQvYqVPilECVsE1ir1GpkLOaggH6j+3NIjuulL5pmFBB0waI2LoQXVW7wx6ItCiyBVDEBPlxjzdWrd+0sHFbI3RPZOhXQzAI4pkitNphywqg3bbQ++rbWFH27jQJkWXuh5hf+Jb712DHU61DIHhT/6JLqkidH4IKC9i2WtiqMPkKTeyTiZrdprb6vRje6Lbw09ruKxN/cELk6D+PRNlrNhZM+n4eL8tIe+ejJ9phTuLOTdXntCUaFbRkN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(966005)(1076003)(36756003)(316002)(54906003)(2906002)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EIlrReJEwhEN9b1qF+Gao4PLi1wIBABS4fqLGMfU0f+znUCrDmGsbrPADO8O?=
 =?us-ascii?Q?9X8gj2MHg7pJkmeCZv5oj+yIQXW1RhYq5afgpbsHBa87TJKxSGI4kzQlnuCb?=
 =?us-ascii?Q?Zvx3DizVhoVv9XQRFqtQnM6qhMftvI61Y8vQbO8i7mZCt+vM45+UXbzGUnnL?=
 =?us-ascii?Q?xHYU5IlaoYPCDQOUtumilswMwSNSXZ+kk22OltKzxeJT+AfWPxWu5Nddi2bp?=
 =?us-ascii?Q?lvwUqcf3hvk6O7tyEqU1Q/MlpzYzYRTHMvwRC8uZnTg6zmf3cNCEO5QjAYk3?=
 =?us-ascii?Q?QioDT+/3XBFBQA0NvEVULuLSCSBF0df84t6nsNx9SYPFKTr2hHSBwBAjZnD6?=
 =?us-ascii?Q?Lj28jH+zIQ9u+COeEEUJ57IRgTvX8AVHNHurI7FWHRm1KEqb8jUFbSTeU9aX?=
 =?us-ascii?Q?hwFE5w/T5AuuZu1Uekban5B0s4OsVxDa5bTCL/5lemiswMTEWpq9JmB4h7Dd?=
 =?us-ascii?Q?DTkRXbvNBK0xDPCNlenf83TvlQXNFeeFw4wcE1YjsyFYv+Qu9NemaokmIad0?=
 =?us-ascii?Q?O93z1RZpF1EnZOoHN1VX71t0zNL+u6jO5jTp0EPWJotGHfHo9rDGCdY3HIYq?=
 =?us-ascii?Q?RcrqMu0hLSGDkNaxwlTWyDk0RIw3PbyKoUV60kgHZteNkfZFObBwBay1EMPU?=
 =?us-ascii?Q?1FWshi9Vcm/7NxM8xqBA9nCcNmsSvGL4Y+HsJx7zsxvvLAyQDN2YsHGOrmpY?=
 =?us-ascii?Q?tCxDMCwBnya7EgNxdSq7hJMfuOyWIuCTEXUuvYgm2mfeZM2vYfkrOGZ8pX1x?=
 =?us-ascii?Q?1swQe9+fKTs/gBHLPpZ/yC2k80XfzLgjYwh+9WzO4xpuMKGDjIdtlUkuKxoK?=
 =?us-ascii?Q?UBq56KLxjAgBO9aCLFDlE1tQARdbogg9TPtWNnYsZWXBBNF1/DlKtMDRd7XA?=
 =?us-ascii?Q?ii6bLOt1GzmhNLuYU5debODCYEaMyNe0Tr8XFuOMo/RER30g1LlGA0bXgUnL?=
 =?us-ascii?Q?HRAEY2h7QyFbbB6t63IIeJ8ccEK01X1n88R9tVxTKNXdPNBSgWXRosQpgaa7?=
 =?us-ascii?Q?qoVkkCikhFQq8IZk35a9sGn8x2r6fQdUTRz/puNJ+werpkbznuEF2j1599pC?=
 =?us-ascii?Q?jGDj+zQUQTlHJFWpTAg1F42OMLZzmG6yj1AnSFU8jNM0yAWUJWOl0P2ZejDU?=
 =?us-ascii?Q?VGMxePVWW9SVRKdFcdWrmx8GjPMTosxSFv1B73u1RiQYWR+1p1vIl0UUbg24?=
 =?us-ascii?Q?HHhTchH1wWo/PLurK/Dui++om6Azk1JFoQ1cgpOfjIaAiFyaUMBga7I50uwv?=
 =?us-ascii?Q?ldhP4LnGIVSp4+wLkGSVHw0Huf8E969EQ0/YNMM+bo/1ilxQ78vViQGz7R3p?=
 =?us-ascii?Q?X7tiQWZPOPMKKthqKrTEoBGAV6/bwRP5uuFRD+WrSYDgPRkB7iBOTe2cRkDR?=
 =?us-ascii?Q?tecsUhWk6H5JhwhExgGCujBUNBCQ5Pcjf9AIx38TQmAhzvB0aN+JsTiuGQsY?=
 =?us-ascii?Q?cWzSpNfPa6lpqJTtyh3aUzCBHFfuCvPRoLZPOIbEI/n6iXzdh6OVtioA4jRZ?=
 =?us-ascii?Q?5s2c3SV+xBT6w7pzn04lxI1pPuI70B4d7AcbT/2a4Hcz1jU4C+9KWpo7gbTI?=
 =?us-ascii?Q?Hu5kaQMiJHKpjyK9yZP5tZgo9kfLP9h2flRDTFxL7i76L0GKukICUupU8x23?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f92ad06-8180-43bd-9313-08db1280bc6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:53.2084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5spolHz5ZBEOD18BX7oRQ5QSga4E8Vc+lSUT1RLEi3w5hjumlvXZeAr9FQVhooC9pV60FeHMN+A/b9gUcLxlMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ferenc reports that a combination of poor iproute2 defaults and obscure
cases where the kernel returns -EINVAL make it difficult to understand
what is wrong with this command:

$ ip link add veth0 numtxqueues 8 numrxqueues 8 type veth peer name veth1
$ tc qdisc add dev veth0 root mqprio num_tc 8 map 0 1 2 3 4 5 6 7 \
        queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7
RTNETLINK answers: Invalid argument

Hopefully with this patch, the cause is clearer:

Error: Device does not support hardware offload.

The kernel was (and still is) rejecting this because iproute2 defaults
to "hw 1" if this command line option is not specified.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230204135307.1036988-3-vladimir.oltean@nxp.com/#25215636
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: slightly reword last paragraph of commit message

 net/sched/sch_mqprio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 5a9261c38b95..9ee5a9a9b9e9 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -133,8 +133,11 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	/* If ndo_setup_tc is not present then hardware doesn't support offload
 	 * and we should return an error.
 	 */
-	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc)
+	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support hardware offload");
 		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.34.1

