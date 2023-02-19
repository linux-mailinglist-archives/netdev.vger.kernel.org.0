Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A0269C079
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBSNyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjBSNxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:53:51 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409651117A;
        Sun, 19 Feb 2023 05:53:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m00IwGvP7/vXf4A+F64K3DTZB2uyStPL1quPxxlK7Re68IXz08+/svHusAneneGI/OtysDxWvX2MuyVqWv36TqgvVq4QTjBD6XH0Dld11r8PX94lJ7DsQ+YtR1kF4EIbPXesBqsvPCKoUJ69vErSOUwi3BIL6L4i5RtoelfEqExoXweeeGP9UmJisAwxHpby64bsS3ZigjnL98C0ljBblBQBMT/meKXyQPaJWRFMOo27I+CY2ZKmKqwT6hsWNVwfsOdms/RsqAP1gZ3JfDADBm6NgFdlIqOONuNYDI2SprIZv27qbosBJ179VbzbEAHByhcZO6xBj++QdnDPrj+jXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itueYiE25vD14VZjwV/XI4EnB7VRX3t95vpBl1y6Hq8=;
 b=EhDd7coM05Xi2dpYP5zcF5a5ig3atOauS8RJnHs/uhbWx7aek+vOBaoUfxa+30d7T9RJfY40qDByF0nMYQV3tEj3FYpnGiC0CbdH4zAVqEtHxb978wAKQXqKjHz1x9/jE6pXmMaFhLBdQHO1v9ZM/D8OrN9DvWm24Vu7upYdxdZOaBCV5dBLfGcfNU3fzKiorlXmf0YF+nhJqhRRKugH3PDWclT0XzwSYsdu4OnKlTuJzumgPQjXgOtWKghpUNN/s6px/waJ+2JSIdtdKnKNy13BlQ1mjS6LqiLmv8e/0kSIhKjm4/SycEVRMiPbwpgWwj5loOlDZN7b1f99SIKTIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itueYiE25vD14VZjwV/XI4EnB7VRX3t95vpBl1y6Hq8=;
 b=lXW+m/l/S3Pt5Kn/CJ6wfwkalqChDIrFjO9WX/Yg08qVD5ILB221mLkvA+3iD7k67GH95CAf3gmj8MU73ebfDIXFLdbxU9rwDhvzJxBPM0Og/LGIarOeBOSj5x2CGOzu9O6E8dc2XSr7Y9rHcGr2UmlyyRNemKY3BkV+Q+sWy0g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:49 +0000
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
Subject: [PATCH v2 net-next 06/12] net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
Date:   Sun, 19 Feb 2023 15:53:02 +0200
Message-Id: <20230219135309.594188-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8c793e91-4460-4175-1d5f-08db1280ba01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gdtqbq/PG6jv4HIP0UGrY0Ndo22s/ovOGsXo6Q6jeBNLXhjLVJ4aNHqx1O6XG0qvg7/Nc/kcsRYO7KWCVviDsxaeW5RW5ph/g2UFxWchwaq60QTwIkYR9aKM5G0tAurDIlECNZq/M40qJESJ0d8Iu6BW4OKCwBEOghT3A+21pOZImBd+/gB7G++VthxvD5GyML4i46Bts0s3xHCIrjYft2PW8FUQtm2RwXXt31ICxCs/AW5UIsIcPxgqAOZa3jkHHc2KyyKnNi86l8H4GilGpj5Kq1UdyA8bGE32uMBBrq/36gcGsaVLkphgKCk011L2cbFoCs6WuEa2ghQt4fq0MvNLOfTKFmV5wNG3aG7QwQYYIvqaL3+0zT1DgYIkU6z7Q4oUvSj5gcxWZZeTie0nAIjIa0bTRUgwYxdOkkXQeN4EOguhpD5cU3UoEVWNBwZI4v+KYIsMFyAt6Oc74KHWv3v0bWY5QlUANKAybZvdXon7/H8WjaNF+gUhuqRkpMFfpSCazShrMN91rsZLCh2151zdhFj+5pF5KLal8fSNb/lU62w2CVjAG0y1t3UkofV6d0aspsstg8W8DW/12MP445qdY0eU1BBUNylrNFRcQ07KtrMRqBeN5vEZYhC1P5rmA8JpLKmVFJtVX8yvTSzGHVsGgDstVMEtfciKJbTbCy2vcUnQVnjCAPP2lhRZ9RWc7ivuHxkYj9zoxDAGxKXgDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lBpGOPcjnpEXhpGyfzSld80cRZFbxBvBdp+BBZvF8JeMhTPHSPgcOcI/XXUq?=
 =?us-ascii?Q?iD2kjTP6//CeUCYIFHzoMgkbDS6ZbGvodhL7aV/AkNY905w/ELaaUL+yIF8w?=
 =?us-ascii?Q?rzGF3KwtYk75xKBkUBQE3lxKbKoKQHVj7OZ9hS6QoNcFVfses6CQYxuFW4cD?=
 =?us-ascii?Q?/iqI0Toxs32hOutXT0c++bVitO2CcLeJQig6qqbl6Yj7Nq6K9hT0D/eatup5?=
 =?us-ascii?Q?vb+VT00niIZY3wstXwKfsSr89JX0AnE1kO2mpMdbzf+Vafwn5QQitjAP4nKa?=
 =?us-ascii?Q?XNVKSV5EdlwY2k31EWKnEld61N0FR2JKsGzCtqN2/AwYthuEznCModD4UFPe?=
 =?us-ascii?Q?7xL0DetZz6j65ozfmxt2lb2pYG6ZDDUjF/sYPstceczYRCiXBCoZiCo7PUqm?=
 =?us-ascii?Q?g+2ebk5LwccbiWuE97m/2hpB4O060qAg+QyoFleqcPcsEFerA2CRR31tH5x/?=
 =?us-ascii?Q?JKHTGdN2IPmxLmdpV3UrvstMuYoJR3JAdW7FQ+fLJtnt13PG5az/zXE4BRW7?=
 =?us-ascii?Q?UnHFq2JdwBCE+2TSym6f47dpSPdyKBfKM4mxqVj+HNiz6xyFCLpa40ZSy7Y3?=
 =?us-ascii?Q?W+pbOHHRpt8C7Q5SWdQ5V4sajR6zpT9glfn0lrmGHTGEsvMi5vAvvUg7h1XD?=
 =?us-ascii?Q?nW1x8mJSq8786WirCWjxWEPX3vik89JPf95aDXWLia9kEnL7rNHiyI0Mpefu?=
 =?us-ascii?Q?sTw7EHEEa+2B7KWfzNsFpkuHGv7oeAzT8LiNeHe1kaagXeLqMB84J8KaW7PJ?=
 =?us-ascii?Q?osWRluz9YzrYwDG/wf1lPkgQcZPN3C8ArfwvbEW6Ccg7nFOXgkbAQC+wUFZA?=
 =?us-ascii?Q?eXqBqUPNl+/4gChnIrjEhOr49mToIdbBWjM8UK3i9jVEMpM32s75ayBNTwof?=
 =?us-ascii?Q?JEZCICbK5S9wAK1412xG9hpQouK0b1x1hinz5tOqSyz//RgnflS/uPN5uO5a?=
 =?us-ascii?Q?UgR709akui1n+ultri0C4XvCH8IubmQggnUQO8QS3FRz6u+VNITghZCFO4ro?=
 =?us-ascii?Q?Rbv4Krely4sZvOmCwWOiG6+310DF88JAPTTp8y6fXcM5Y3FfyR7QwkD0WGGd?=
 =?us-ascii?Q?fBZLoJ6frNUH+7hOuLRBqLFWEL/A6xJHJV9ksJmeIRL/dYJXwxarxHcn/gA+?=
 =?us-ascii?Q?fYWdof5s0eK9vbugGZh1utUOvIqc18A6j22BvcWJUxsWIV17HWXBgTv27VtI?=
 =?us-ascii?Q?7+KQAcDxujXxg3msulUoA9pljMqWi9rCmAtBIcANVzuBAXe1ECyTSIdzPXye?=
 =?us-ascii?Q?UJHxSIb+lkAD+H0/N8gsfDVhiLzyEVj+6MInHR3T17KH8IF6RPadpWWfB9GV?=
 =?us-ascii?Q?mqmmkSYA9Of2GQRU/ghNoE3BknpjhtO5rwu5Wa/Q6dcHAiezJtRh5V5MeUok?=
 =?us-ascii?Q?KXf5AjCWqZzCm+ga31sJzCKc3SycJwPtUCHC7N3yMsK8buxTooXtGcqhol9g?=
 =?us-ascii?Q?XIWke5rsUNersEpDjQzL1Da3Aiau188tg6KRcHVMPHMfVonJ6hqTijj5tQtj?=
 =?us-ascii?Q?ump35PFM3EQKp77Lst2fGHdt7hCON/CgsAfKYzNC3QfvGMcfv6k11m/Qss1S?=
 =?us-ascii?Q?BqoRRaMBXmVk9JcjYMZmAyeMtUfmdNvVtk0slPvp9OXlI8p8gPoGlRpxJPQm?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c793e91-4460-4175-1d5f-08db1280ba01
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:49.1462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XR5gH9acTcjL5/8GUEe2OcRw9Jlcw6v7sBQLMA3MpG3hTrbpe/NFylEV3aER1GUyrCoEBnMd7/7UeL6t5S8rsw==
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

In commit 4e8b86c06269 ("mqprio: Introduce new hardware offload mode and
shaper in mqprio"), the TCA_OPTIONS format of mqprio was extended to
contain a fixed portion (of size NLA_ALIGN(sizeof struct tc_mqprio_qopt))
and a variable portion of other nlattrs (in the TCA_MQPRIO_* type space)
following immediately afterwards.

In commit feb2cf3dcfb9 ("net/sched: mqprio: refactor nlattr parsing to a
separate function"), we've moved the nlattr handling to a smaller
function, but yet, a small parse_attr() still remains, and the larger
mqprio_parse_nlattr() still does not have access to the beginning, and
the length, of the TCA_OPTIONS region containing these other nlattrs.

In a future change, the mqprio qdisc will need to iterate through this
nlattr region to discover other attributes, so eliminate parse_attr()
and add 2 variables in mqprio_parse_nlattr() which hold the beginning
and the length of the nlattr range.

We avoid the need to memset when nlattr_opt_len has insufficient length
by pre-initializing the table "tb".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/sched/sch_mqprio.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 48ed87b91086..94093971da5e 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -146,32 +146,26 @@ static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
 	[TCA_MQPRIO_MAX_RATE64]	= { .type = NLA_NESTED },
 };
 
-static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
-		      const struct nla_policy *policy, int len)
-{
-	int nested_len = nla_len(nla) - NLA_ALIGN(len);
-
-	if (nested_len >= nla_attr_size(0))
-		return nla_parse_deprecated(tb, maxtype,
-					    nla_data(nla) + NLA_ALIGN(len),
-					    nested_len, policy, NULL);
-
-	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
-	return 0;
-}
-
+/* Parse the other netlink attributes that represent the payload of
+ * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
+ */
 static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 			       struct nlattr *opt)
 {
+	struct nlattr *nlattr_opt = nla_data(opt) + NLA_ALIGN(sizeof(*qopt));
+	int nlattr_opt_len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	struct mqprio_sched *priv = qdisc_priv(sch);
-	struct nlattr *tb[TCA_MQPRIO_MAX + 1];
+	struct nlattr *tb[TCA_MQPRIO_MAX + 1] = {};
 	struct nlattr *attr;
 	int i, rem, err;
 
-	err = parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
-			 sizeof(*qopt));
-	if (err < 0)
-		return err;
+	if (nlattr_opt_len >= nla_attr_size(0)) {
+		err = nla_parse_deprecated(tb, TCA_MQPRIO_MAX, nlattr_opt,
+					   nlattr_opt_len, mqprio_policy,
+					   NULL);
+		if (err < 0)
+			return err;
+	}
 
 	if (!qopt->hw)
 		return -EINVAL;
-- 
2.34.1

