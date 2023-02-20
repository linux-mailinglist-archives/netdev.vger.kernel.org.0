Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC78969CACA
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjBTMYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjBTMYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:24:06 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B6E1C335;
        Mon, 20 Feb 2023 04:24:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRo4v9Hn62gzM3kfZhGY31e2s06HVha1fuqE+U3+g081koy0kwqqW/TXzwDB+h/orNxGwlP+Dkv7FKpbeDM2cAaJIljmuHPo9aRzM9NRKPNrh1W4zSgs1+YB5tqQ/iAFsyiI9dbB5YJR4ZSf/nkLrLzMhUNIfBjve6AGngd38THrNzyZPUr7TiY5TKFOFgK4xpJxtoUqDEgIrTAd42Ml75wpubm7K0kiBTpnklSizJob3T55LypIl69MLrLR9Ms52OX5jogzQ76UhYrWsVBhNKgI6iTWxyqS0orVFn67cWdcPCl/j6PivgAPFvqXxqDVlxzCBPFTgFpsTwdyudlltA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9EZg6hgUN/dPAkIluWwcqmYHyResOBRpUhAQpACT28=;
 b=EK57XGBhTe0CBiPhuJOgKFt/H/6KmyrMbT5XMwEYI1v475fE+mH1P1541s4ZOE3BcR9dGBYDWDj3J0ScL54dA2beGrYjABOsAMoKF7ipRUAjckkEh2ppSX/P5Ml1EiEZCBiHcpfC7xhXdZ7lxJfSKRBQsAkiqtlwQJtcmkvKLynkB6Sm+DxgXky/1Flp/eJgqVMJvNkaV1kihgN2dla/Q+z2Mn5im/UZDIEgv27HFApcrrA1o0fyjRi5xcBt1eVoJByjfahK0HI/BaV8iA2mM0U4Z0RbaS12uKniYTfncj59ZpcWHnO6vEFo7EKMX+Zk2Wa6Awu0nfJqFgdWfCKiCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9EZg6hgUN/dPAkIluWwcqmYHyResOBRpUhAQpACT28=;
 b=Dr+LPQGrfPyoTLQ6ANQdZ+/2bpTxuD1JL2g1BbZ84SMHiiu5FtJQ2LZqtLaDVg/rLBJVdKxp7DkDl83I3oQu97Sey59Xto7+Nl79vyipyzy1iFDoiUmWXYwHgPoF7MyRZy4uoXmwEGZSffhK6y1onrXuB7BSFMqVyEAKMPjwwn4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:03 +0000
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
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 03/13] net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
Date:   Mon, 20 Feb 2023 14:23:33 +0200
Message-Id: <20230220122343.1156614-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d7992e-9601-4482-3e7e-08db133d5a24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1mJWe/0sA+JGI22kY9o6nfNvQE0z1iT0QCYfztEM31VKnKYf4OOerdTZr0xVRYjWmr2P2JzlV42Dv+S/O9ysoQVOWXNbLAeLLnFELERidgExJggdIbI3vYkmfUYxr29O+nVG9PzSMtRdsxMeIhIeOfN8dOGih8OBAz8jj5maXfKlHTh8BETvu1VrZQz+CzAulPpZU7YOGyZTRqP0Fm27DboUrvRFgY5A6TI/RKZD7d1b+WIYCRSIKRJXqXnS6maxyafqL7ipBa/zyGVBvPuxlvOnc10o/mcxNdhIAiCVzyNhO8Rlk1bwCledfmSwMRSRdZjc65jS20RMknVDuWVUH8fL9vD0C0SCQlzJ/1BKuUBsksUgJdZGfJwrgw5vRdxg+Mr703mIbLaMCv6tsbmalSskIFpCxG5UMg4Dfl8Ru8hUjdk7dcoID0UhP1hjxx71bzRm8TS0Ps9J+CE2wug1kZD2qroCbYEVY5mhOi6nitKhBsou1lsHi7zDyJnoNdsZ5qBSsSpO5oV94lRkCD//KDGc4F0bAo7enwdYXapsmR2oZPqX+wgbM7Oi5sSlMZhJe04uHSlS3o9s9pL34y5om6F05AZ9RYBxJB3+b8mjKp7usXXaGRxgTOTRFKnm3u5QhbkuSfz0uOzhSeqS04Rw4pdYGKoZnd7R39dpLTFcoM2xyFux7zT/kWH4Cy+wzzwgbZ3eDdeZDikipW+d3ecfaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XLfFqcsfCv3fCQl872yi13Qnn942eAYpBeaxZwA6Oc13se1R3NWJYb/oIFdi?=
 =?us-ascii?Q?0Lyq44L0LW28gIs6/y4rIjNSrDxtxG8wbtyMhKKrOWtTLHUoGqCV9fI1SgSd?=
 =?us-ascii?Q?ZPqv2pzaEeg86/vwZKAQagNip9f0B58HNVnMELF4CHYxfhw8uguyFCIsNSbE?=
 =?us-ascii?Q?YvI2MaQuwBrN1YLtam1fBHp6fUZdnC4ypoovY8jxeH47FNpflKWd9Do77r4x?=
 =?us-ascii?Q?KFChbW6wc/ypfr/9CPgI/+qBQaU86uopd8VnoJnnaVUt8VLNius4K4PFKSPW?=
 =?us-ascii?Q?8OkXpsTewYZ+ihYWAzEqO2Kk7eBwVePRdMNYQBmQDwqrtoLapZoQoYbpbkDd?=
 =?us-ascii?Q?Dxc5MrAzAt0oXNFO9QO+mEMyFtV8J3Hb4DnFySs8nGiI2uFhYvfOtBI86vQq?=
 =?us-ascii?Q?3gxUdTohGWGl876PQatPY7NJZ2xBLQ6B/cFijCSq+sZ6npjN2Wk8CT0BnRAA?=
 =?us-ascii?Q?JovuRKXsIJ2BZp/jYW/SgrcToWNiYbVE8IK/JL7ssH76K7BRuxIs6ICYqqth?=
 =?us-ascii?Q?v9AhFzTEzmFPaWzUBjJi2fujaOYNEO7pnlvDvABk31+G6KBUozIFS3P/m6DT?=
 =?us-ascii?Q?DMnGLAgEJNcRLeAb6S47/uCKz82oH2VZm9/9dd5SUbZpsH/OO8X9aLR9QQal?=
 =?us-ascii?Q?bmdPQfNew2hNwcrxYVQ+FlHyGj96DIsQvcNGS1G13CZ24M10cphb108lXEVx?=
 =?us-ascii?Q?AmeDTmsw4Kahq7PhGBqF7ChcVr3OieSI9SyMPs/+ykAILhXdPYBmT0KUV8L/?=
 =?us-ascii?Q?9/BYDfdAYGSTi3NDZuNafJZDBK8CxJ86VqhNHU2zjnk9jpcW4c2YxsRndAjE?=
 =?us-ascii?Q?0VLadD/vLqvnUUJkGHx0MMn/WBI788GjVxaqoMRNhV6TGCGAALRbyuChqPEB?=
 =?us-ascii?Q?Wlv/QQIX0OlkR1rc+H0psWqVUtIDuNnAPj42FcARiUptqHSi7+LMeKQpHzRo?=
 =?us-ascii?Q?Zu5MJx6NbNBXQAFBZ0r+lcVtFYEWV75bD5RAjVUVqrr3je0hZ0Lx8BYzdY/E?=
 =?us-ascii?Q?DjUqXwa3q6hVYD0vzlt1BJblb9s3CJup6bARLwteg3wzj5XMztICpOk7iRWj?=
 =?us-ascii?Q?aLcsavKa2uXz1fDu6iRf2dmX/9vK81PFrLxRBD3SI1yddLcB6EIAnRGxXHhL?=
 =?us-ascii?Q?ARr3RwmoVfjR4fBUcnMGO7dDsjycEPbm/mk6MMgy1jNq5+tBOCDl7U7OW0qm?=
 =?us-ascii?Q?Gld56wFCVJbPHWQfAt8VllvSVTJS8sgGukdJ2FzYyv29HZQC9Aqigf9VLys5?=
 =?us-ascii?Q?GxCgQqN9jrXwaC614mROPKhc4NJ1ig29KeMPnF8IQ2Ut98NgMt6dWToPB487?=
 =?us-ascii?Q?krHCF6LSut/L5//AKpisiXoFpJ5K0i6i22KQY7xEyYQgPGa6lCM6y6AXMzr1?=
 =?us-ascii?Q?niTP9zUtLjDeQs+Yb07+g8a+ph0OrlwU8Ay2N8TM8yiXkhjYMrNMEtETqu0i?=
 =?us-ascii?Q?34xWRLD9B3KB48N38hYZG/Z89+GU2xJpC3aALG2is0w5zCeh+N+qGimNVzdg?=
 =?us-ascii?Q?D2NVxnY2Moe8NCqUdHmev+VSMoBDN393wttJuKotz1/eHfegQoftdNQomopA?=
 =?us-ascii?Q?+I6kkL3TRi1WpfdQuXtjE4fj4HScWIbo2ezobmTaR7TrrdGMEXp+X27yoVe5?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d7992e-9601-4482-3e7e-08db133d5a24
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:03.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9EoS3hWEcesVce+kjXFuas0D3BsxA1QUwNh30g90Jr8ZhGFzoTva/bN4McMoS2+gKHpCPjzvmeZbTv7fimzHYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
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
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
---
v1->v3: none

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

