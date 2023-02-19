Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4E069C07B
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjBSNyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjBSNyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:54:05 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BB2113E7;
        Sun, 19 Feb 2023 05:53:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNKBDzUrBKXU2k27OORYefdykPbNRtwkgLVPJ84vKxGfqepVjAaGRzt2bJUOw1ZqX8ZZB7Eh8RLoJIaXQ29PaaBtpsq80QWXP/7A3RF4/aLWvk73CEtLcJFkaPlm0HLCrp3JDCTXsMByMkU0lqKUDMiAdW9avFSiE04kXI78cFEjkqFYFIfi2gyGyJ4+b14/N73pitmegomNKJuupa9hjpWmRsQ0mK0LPo2eESHVq8HOah6jj+yL9Hs2RHVNtrmjc5p+2p5YIIqdArh24sOTMmB+iFKi+er1G5BzswWEYfVHCb0n8/CS+rP16AkJvjhIn1lQ54Qo8ca7tUAeZEiEaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xv3OHoj9xpm2LZXRJ8CcH0mgiYcoB0G7lZO1InBYok=;
 b=bgEgvKUeLrmb4kBH4vQAlMk1wkmNvHwAxp0rT149gtWO0U5yVXQo/4Icd6hrofdCVaZuFb951FZ1Qqm7OSBkCF4L2XrJBBMLZn1fCfQF11nH+m5K+j2eaPlhlKVIhRlIytMWJyFZRo+u81GkHnJyI70P8DS0Fr3EWsBY5kLg7xDqWRcKPjN7cRomILYdvQMPh8qGCwTDqrM/vA5e6RTgrLM9kHYjiJoxCwXv486wHcOQ1MJGUIGdNtz6gpvjBgaYIunaQkMmku/RAKTD9MaYwPR5ZaDU3AJNwx5Dm6izg6uhv8ElzKzK6ZKS8o8MUK4P2PHRg5d7VkpRb+6u1crLpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xv3OHoj9xpm2LZXRJ8CcH0mgiYcoB0G7lZO1InBYok=;
 b=rpNEmRFrwPxiMxIQlgO0UTA1kk1+3m+GUrloHxj+RFNxRB2YSrxYzqndVKOkGsyGk1UwrK6nD9qoN6GgeCmLeBlgCZrPF8M2j05l5cTvvRWQz1oDA4eFZntH2eMLtubV6j4WruqwkwtV1PoXKXjMRtovexu0JjamAg5g5/i0iJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:51 +0000
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
Subject: [PATCH v2 net-next 07/12] net/sched: mqprio: add extack to mqprio_parse_nlattr()
Date:   Sun, 19 Feb 2023 15:53:03 +0200
Message-Id: <20230219135309.594188-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a9926974-8e8c-47e0-6bbe-08db1280bb39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d0N8RBZTt902sWXu6sp9JZ4sQ89d7pOv6MmPYRpTCje00D+qbICCk86w0ml1N2PE9RNdMk/UM7J8I5UPvG0uLdoPGyO+OtH/4oMev8d794Fw/NQCni1Yw1LSZ4ebNBtsCIci4KRDFnyjsAbrtnEVrlbkcUIVvxmv6Y5P9VgcJC71cb+GAqyUylq6nv8pgyA/GU4mwgbDoAsU3yUxIMpuTbnkw7H4i5wyNEf3dLkr+U0+X6P/dTQ6zv6kC9b+kWSxMWjH8rwbEHf0/BPlbuh1euNDim9yL7czhmG9bfjL6WCN7eFgQYbRIQSXlZyr0N/0Vc485dWNSlgd5wRx7IQ45Y3lZG12Up+gg2Q9Fm+1S1MCHkYHiNeTZAOLxKzz6Itf1QSHf0HpcLkGFWr5Nt/YcTCYwYRKHwWsbnAsS5A2fw1aTFOGJUkzeWyCwo5n7LUCWF8EmuP0XXDj7K2XovA8Ib4jk05ohoMmffDD0Lx5hLe4XiXRkQmNWSoRC1U+WYbxddJgWdBckGVHTn85lSflw3ruvgZUhYVJG5YSSQ+HdKXeAqd7w2qC8RIguiyIeNn5ZNS64ODEUF72YpqZ1y129VLrL+sNgRkc79BwuSUOyY5lj35i9l9NQYqmd7+y4Z48ttUx+ir/Cwqv83taYj433AKMtDVO6ak00HluWVXRfsCJbAk3R2XI1WEZIFd9YGdTJ44F7zULY5PWgrjzPkM4pQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nWfks/8YSEOwOzS5WgJgLqoSq2jJnP5BYOHVdd6EJdQD6sJdyTP/n97rf3PI?=
 =?us-ascii?Q?OpaPFIfHOcpshbxxR92c6lThA/0vQsySseDvWHnD2TIiqXnXRDW4wQfa0/3O?=
 =?us-ascii?Q?hd9VdEC0qJivP+xEJiyVmoIGQgTILD8RiPw2eu1pn+IPISedU8gtxiM36eDL?=
 =?us-ascii?Q?zenaHu0QvAPdiKmSMHl1Nb/d5gqALD7cKhlnHIemtpnJLZNY+r4zUieTFLyN?=
 =?us-ascii?Q?axC5nmJ2PJ9qFmEaYcSGiLSvmocktOfDYz99MXl+UK5uKM6VTFzRV+8kPMNN?=
 =?us-ascii?Q?sD3lo28j5Tozd/xMEqutCmvdL7CYr+3MR+l32BeidGP5UpFwOdQ3nxP3WUBa?=
 =?us-ascii?Q?m1ENd2NBTyjNxLV0JKL/v1ldvEfZyP4RxRgqXxaBN8AO6fPMDjSCSSmJAGus?=
 =?us-ascii?Q?9+b/ai6EYEwq6QQNrpBYozxNNQx6kX96MHVbt+hiYrQnvou9HryHQHiO/5WI?=
 =?us-ascii?Q?NvKunTVmcxeH2MsbYEJSv5mWFF4v69KrB/mZqNcsZMVDn6Nh423OcIMHcg3K?=
 =?us-ascii?Q?BYppo0DEwiZep7TaogDhGUaCAvdX0xppql3OdLnPUEkPsFGFd8l5idj8s1pt?=
 =?us-ascii?Q?fcFYZjnk8l5NQYlN75Btg5GuzM1kl4ws7m4OiOq1S/4b3S7dAkX4ixub2tbF?=
 =?us-ascii?Q?G2mhXhlj48KjWOu7Cscui841pxGo7+Lq8/uJvP2DkhhPp6uymHOQ5pUhHvZ/?=
 =?us-ascii?Q?2ssmrtQpmv3B5S1WWEdDpakGOxadRTZPb7TlJGH0B9P/JX5M7qWf4y7+9BIc?=
 =?us-ascii?Q?4LOfsAfD26pXQE38PHJwttPmTAGwBleW27bKleAEw03eb4Je7+cFT+mUNvot?=
 =?us-ascii?Q?tcTJB/+I2KONaCU876dgsrqApxFFZo7Z7PZ0fCoRgM/mb1Q5Q6e3ZLIYqWjW?=
 =?us-ascii?Q?KVUtC2fkp3WPGd5FwlumJPBCDy+07qvZuYvOmJuS1kkRLHpz9DnwYsqZflnY?=
 =?us-ascii?Q?rrht/rMpn2sXPW5dplr63ZIvdHuLPbns/NYniiPxo8i3IqTwS0Qp8QeHTUsV?=
 =?us-ascii?Q?GMx83U69hm2Kuj0dDqs1F9fuh3LVXQRDvwVtCtUmV8FViH57b8z3FT+R/UQZ?=
 =?us-ascii?Q?k+NWtbDFCBY0ZVslCviFVIdZbwKlp7hhJjNJEaBOFJG2gV/OwfJ02rNHAWHj?=
 =?us-ascii?Q?86090iDeCOuixEUKrCBFbzKTUksg7dH3iLRmRWWlf3Zaq0p8MXtWSAGzL/jZ?=
 =?us-ascii?Q?gKgcBwnNSgE3xD6vcAWOA9R1uMNZzey6SbTQebfWgKObyll1UwIG/bUOCXt7?=
 =?us-ascii?Q?ejImpxKZ2TtL98i1LR1YiH3oZz/DuuqzclJy2NDflf2VS/ZnS1wDkWTkPLx9?=
 =?us-ascii?Q?dQHArdhJkpT9jE7ancIvPptqW8tM0TD3JbTbYmrpDU+0OuMI1UI2CXFktS10?=
 =?us-ascii?Q?ICMOjpj5Qx/HYaiswiI1vk8mH8kGOty9avlFOJH1uOVbwUWfcVzP85yzWwZb?=
 =?us-ascii?Q?+YY3Eld1Ttb2ocFpu3OWdynbqXof3VGZQtzQ9DO+CSd695o7AN2u9I4+Y91d?=
 =?us-ascii?Q?hXHV1lBTs22Rp4YxRjticJPJZOMScLx3J5KlgKDNcN5imCRmneIggbHEZhGd?=
 =?us-ascii?Q?K2rsaiwe83AOsuPCBn54L2M0vR1iNHG4jn3489ALHwqicbUaOxIvoODC5J5M?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9926974-8e8c-47e0-6bbe-08db1280bb39
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:51.1773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdkyWdBaI3hK/kMF3Q50cGSTQFWCFB3gG5p/ohjJZiVMs56Lip67/2NqacQJSTgmsVBj7ewJmVF/7gXf7pHCEA==
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

Netlink attribute parsing in mqprio is a minesweeper game, with many
options having the possibility of being passed incorrectly and the user
being none the wiser.

Try to make errors less sour by giving user space some information
regarding what went wrong.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/sched/sch_mqprio.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 94093971da5e..5a9261c38b95 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -150,7 +150,8 @@ static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
  * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
  */
 static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
-			       struct nlattr *opt)
+			       struct nlattr *opt,
+			       struct netlink_ext_ack *extack)
 {
 	struct nlattr *nlattr_opt = nla_data(opt) + NLA_ALIGN(sizeof(*qopt));
 	int nlattr_opt_len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
@@ -167,8 +168,11 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 			return err;
 	}
 
-	if (!qopt->hw)
+	if (!qopt->hw) {
+		NL_SET_ERR_MSG(extack,
+			       "mqprio TCA_OPTIONS can only contain netlink attributes in hardware mode");
 		return -EINVAL;
+	}
 
 	if (tb[TCA_MQPRIO_MODE]) {
 		priv->flags |= TC_MQPRIO_F_MODE;
@@ -181,13 +185,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 	}
 
 	if (tb[TCA_MQPRIO_MIN_RATE64]) {
-		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_MIN_RATE64],
+					    "min_rate accepted only when shaper is in bw_rlimit mode");
 			return -EINVAL;
+		}
 		i = 0;
 		nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
 				    rem) {
-			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
+			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Attribute type expected to be TCA_MQPRIO_MIN_RATE64");
 				return -EINVAL;
+			}
 			if (i >= qopt->num_tc)
 				break;
 			priv->min_rate[i] = *(u64 *)nla_data(attr);
@@ -197,13 +207,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 	}
 
 	if (tb[TCA_MQPRIO_MAX_RATE64]) {
-		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_MAX_RATE64],
+					    "max_rate accepted only when shaper is in bw_rlimit mode");
 			return -EINVAL;
+		}
 		i = 0;
 		nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
 				    rem) {
-			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
+			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Attribute type expected to be TCA_MQPRIO_MAX_RATE64");
 				return -EINVAL;
+			}
 			if (i >= qopt->num_tc)
 				break;
 			priv->max_rate[i] = *(u64 *)nla_data(attr);
@@ -252,7 +268,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	if (len > 0) {
-		err = mqprio_parse_nlattr(sch, qopt, opt);
+		err = mqprio_parse_nlattr(sch, qopt, opt, extack);
 		if (err)
 			return err;
 	}
-- 
2.34.1

