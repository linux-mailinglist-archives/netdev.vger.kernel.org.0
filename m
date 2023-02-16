Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5DD69A242
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjBPXWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjBPXWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:22:13 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2075.outbound.protection.outlook.com [40.107.104.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C20554D0F;
        Thu, 16 Feb 2023 15:21:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOt3WS2d8USB6w407j269zL2shDXXyIb4UefolaeTbQWr8193Aqb7qLagr/IopnwgKlS7E8aI/1Ned3ZkWlxSm2qlF7Szi5iMxwddBIoHx4ysFv/rmo+Bz8ycMqCpbMpeM5FSLlPVXmZkwrtD6Nw1S++TpCYDLYC7Gx/j5wdjJEPeVRMoAvhBdu6AkMq+8N7OkBQLGENRBs/REAzpEeCv/40P5QEBoJXUW/8QxvAgdwieKf/0UMK9njxtjwEcObN7VambPlhuid7Om7rDlvUaynlWauNPwG+SAm7BRyGZk/2xQN8Coma8Xxu/f5rHxzkyNuIMVi6looYlAAMlhFnzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiUVozUMEjWcF8Zejiu7eEwqiflH6NVFM+g++3wtl7E=;
 b=ICDzIK6qhe/RDbTzy4CCFf2yA7+seB+YojHyiJKfWCdfWb5xjp1dbfoibd1Rkylx1D3TqZdSAbgr8WQhSBX2k6aQ0sECvKqndnvXaAtIU1PcRa34CTZDJYvGb4BH84/JdxsiAz+HNAlKgpG9zbEDXv6bIb4FuCOzgvzKrNxl42YqAxgNunv/e1YOCad/SYN17grc7B/+hIrrf2N63TW5PwoMzzyNtxGLXEsCQAxkQnEEVtCJ+7/Td1fs4WL+3rPQ0JtnzcWcvb3+8BNu7zfw7t6RX6FEChUwG1utw4uRJ/c2i3Wa++fHZP0fqW9bga886UmKhbuHlzpcICassSB4wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiUVozUMEjWcF8Zejiu7eEwqiflH6NVFM+g++3wtl7E=;
 b=kU7vBFi6ulNsgUacvjjhdkfm0VJAhRxDAmfX5M1/JaS8cV24//BhgUgwRDDgdKKM+a+8dk3ZYldjcTGL5Ynbs5qdvIJZYdKe/m9/swos52IgyfnJ/hgYGPlXzKag9ZY5WM5QSaa5MKh3zN0xvk6Tqg2v/x67FHnec6dZ/O5CZw8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:47 +0000
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
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/12] net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
Date:   Fri, 17 Feb 2023 01:21:20 +0200
Message-Id: <20230216232126.3402975-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 961174d8-43f7-4f6a-fe89-08db1074931d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PENbNupF6m/UEy0zscRy7oMLO3CSk0wA4lRyYmAHmZey3moEsP5JM96cfeq0EvD9zf/+kAC3pWGDBToqyKwaQov14NI2HEV2cvEzdyXXmh2iN4aAbzKVqlYgXJJwUGq9yymh+P1wVTmOAzhtQvvL0YEFrcpjek9PPAc0wJD7t8bKAVRGAxHV7rn6+pRLcRO3CP9WSLMi1PVM3P03jflQ26CMOQ+j51v/etPVbxdUcQajzAVe3YphoMgserIVrZOCN8RBBcjaYd0X7PIkj3swJJxB/NfYL+GckLCmnk87OhIg5aZl2DOI+7NjdJPf+VAS5HJdmnCiAqAiAltxpxcU6w40fRwlcPkwhdbot1JoOshYl4ywxIrtdI4cK2Y32jVyey8XG/A7YcvBY7Hlf0iJHuEvrCYoqe7eMbhVmCGCipy6xZe2BGmZDP336ce8uMMtpdjNLJy81zMcnYSYEDvvBPINROLm1R9yLMtuvuc0nhduYkPOpFO/VLZiNvHy1E+vGS+o9sQw2i2t6EPnDchb8XBnUf6yTR2I2mb3TfdXBX0MJytlIb+TV8JsWjzRYdDPZSH/9VazsJVts+od0f8QjjiIqupF0p7MNRmst/Yt90vH7ZXSU9HnLjdPNW3w+WZkDbh2tbeyEi3Pdz8Whwsm3LysP32IXlqnwlwHDPdffdLdCmVBatz9fjn2IWBE4F5/zFUAXmY7vCDKV8ntclLmjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fpWsW2kmHU+lkCtD0abn4gfZDhbn9STsvgs+5odDufpevO6zSh0mGHGYN+lR?=
 =?us-ascii?Q?8KQQorAISL4zfzfKPpKTxIBusXKCsYh7XAvfD6Tg/hqYRXt5gEzVBkrzXOhC?=
 =?us-ascii?Q?xOvVpWFHnLDs1esg2F5/TfndK8CgMuF+A4v19O0dxRAay81M/cohelaR8DV/?=
 =?us-ascii?Q?8L4OkgsNG6EqqM8cu6Uzc1CspukCX/cN5XIyUrPfQrR4y7IJ1OdBiuEpyRI3?=
 =?us-ascii?Q?b6YCOfJWyiQwIr4J9biftoU4kdLoctdiujkPAMLH7xiFAqXRkW6Bokq+Wjbm?=
 =?us-ascii?Q?fy1zlYsTAAvbYnCG7xfKCZC1VFXaRdaK87esuHKj8LkknNiIhv7QFGOigXAh?=
 =?us-ascii?Q?YeAuPi49I6xwsuSWHmvwTQsWZcv17aFkMFQSQOBE6XVo+AArZr/ha2vQaifc?=
 =?us-ascii?Q?nLRdbN7Fpp6M7d9bku6WEhmrdD6mMOEpIsYFITl7glKdRkqZOIr2IL4ODFBb?=
 =?us-ascii?Q?C6//jgMTXYL8P+Y4tIuLe9Z8XSETxnT2k5RxHfG92S6R92r08AKlGuvp31ar?=
 =?us-ascii?Q?+L44qASAYW4pm2VPIFjO5VYDAp30zh6jfi6DESl7RW+RtKsyV8SoOzGrknSh?=
 =?us-ascii?Q?heS9rMwe4tRwLOQ3OoXjZ37NTpm3AZeAYAJvJwWj7M7M05biBEeQF/sirJPy?=
 =?us-ascii?Q?YwKdcX/5F9DXl1W7Da8alxOG/daBOcBzLRH1RGKLC5PB6ZvdXf/A9xC6UwiL?=
 =?us-ascii?Q?0Sr9kDYOpdCYlKhoeNw3M9Z2JiRFcUEb1DSjNAXBU2guG7/VAQ63LdWLcK/E?=
 =?us-ascii?Q?obVrYB0W8GbaCkyJhYjclUzlzJB+ZJ79dJVr2/OSqug4Uj4ein+wUEgXL8Zl?=
 =?us-ascii?Q?7DR9hSZuhc2hW2SCNB1gt8X2q3vQOUaFfYPh+9ezpuTnpcBFBwTYhehvsUH1?=
 =?us-ascii?Q?qGtFweM5mUdYvLhfGKvavehMdzLbAe7tjKf8aQ8sCLKo/L3r2h+mnaBM5P9i?=
 =?us-ascii?Q?8cr5I3JHI0YRnrT+l2WJa+EnoOiGOEYmJFz7gfRPnWlGXSw0nKb3a3qvEnS+?=
 =?us-ascii?Q?YrJuZZgSx3hnhPFgbER0R5HuzS4/EqIt9VVkSD/G6wOTMdlTbi8a/8soHCUw?=
 =?us-ascii?Q?5Hn3RXe2S47MhoBJ3UQS5icRWCcc0cyZjkwBNbBruLCrVZS2GPp01sgdQ2Ar?=
 =?us-ascii?Q?Srr7336805pPzTpPbGgz3UqFmihl6vqM6xZxGp+c/nU4xPw1ZgXCpMH7kJk2?=
 =?us-ascii?Q?oxa1BEN9+OzE82Qb+egobWQ3ZxJOvEAHZ+0pliu5q9P/4kvbiwgGcUssRAaY?=
 =?us-ascii?Q?C6MmkMwnZRyA1ri3ehPkYJ/YPP9LALV51nhuuLAYlcuEQMm39wjBiCD3BqeV?=
 =?us-ascii?Q?fN2uywM4fJuPMrkZW/NfU92B4BUwSPlg+Ou8dJDBuc1bKyb1m6qHqbNUB6x+?=
 =?us-ascii?Q?F3NV0MGemzN/xJx/i/vK+QPrr271gVnXgxH8mD3fs5X/x3V8wXRQrVLpa13m?=
 =?us-ascii?Q?MoBymKkCAzDyStUUrfis+J50y+L6q7l7bxxK0EnzMYIT0g0qmmUuvvoI4D+A?=
 =?us-ascii?Q?Di+6GA5gCO+5VyW96827/NBT3AIzGTdDVoZVGds8RxGxvaLWrbCYK7jH1OJP?=
 =?us-ascii?Q?mwp89ExcBJDJ6jIGRp+QPApr2xMVkWDttm+rwp6iMU4AaADDK+g44N9vYtM3?=
 =?us-ascii?Q?+g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961174d8-43f7-4f6a-fe89-08db1074931d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:47.5086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M3uFzIkXpKujzhMGVTRxvc3RN43cWIhJiw+4dOmmW6QpT6epJ7YxyWxqh2I5ysDXzMK0i+9Qc6WVbWtcQLyLkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
 net/sched/sch_mqprio.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index f0232783ced7..cbb9cd2c3eff 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -147,32 +147,26 @@ static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
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

