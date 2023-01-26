Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE2567CB51
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbjAZMyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbjAZMxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:53:47 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2059.outbound.protection.outlook.com [40.107.241.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8C62B619
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlviKZwKeTV2/9FbPZzZ7KTJs1v9HuMwrUSaGnr1X7zYK4JV1DvIiQQWtqptX8q7vGPUWXcMXc/Hg5LrjEQf+H7ATqMLUdUjNpqdwtFzVFOn2tpW1tFzjFqW4T41SKouL0FROfHNVp3+x8Xi7//wjwd914AFRWQsFoNZmAj7IrRehTIsxJKRNoTFMZNTZBqHx1mX/P0pTXqY7NrsBZ/olMClFgNPrrT4n9dszrhUXsGBfqFNHttRgvIKB+s64Bgj+XK/u0bJ2KWxETAOv/RixuousKdDaS/eGUPZwDK6uCUxTShzP808/FUdzD7woEILziKeFuEfkpd4Z6ah4pd/ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lnSlO75VqnO/3Q8W+WNASVfC1K/+0/0UWZEPlrfsYo=;
 b=bLQzgjhPafyduRKnF9jDb2H1XbQxXbxuNKJnc7gBAHmX/tP0u2JL4VehW2GmDQrxQqD/y/JOnnCsCuXJe32NTrdzsKl7Gws8i/wIwMWox0Cm++/vn/BtJVokSWX3Ma8IS+UC4E/mwrBDZA12nodmVEi1EZbzeekGPZ7l2itiTEcgMYa0fRmO6bqrQZUubhfUdbq4+c2I8hwztIpAEVGOJOg8UZ9hOW+KnnDBpiP9pUD5XCi6E5DXYyIl7raxDTgC4KFhdxzVs6Sr0wdgvUu2cmF0O0MWxWOuI7GUHMHZ/jbHjv2zezE+2MWOeM2iBAkAMzbw+cbT8g+DTHnZVyFHkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lnSlO75VqnO/3Q8W+WNASVfC1K/+0/0UWZEPlrfsYo=;
 b=N0hp6ETW+sIvwfYU+ral4W+a+rZF557mt168sAZcXNCsvhkxdE1cJEEr85FczNsajzws/8AV6gEooh/LYnScHd+SFjUy/7sFC+cRtRARMwZ26OcbEGlYcD5iWzbZyURidqYIb+U/Gq3Gs6U5Vp8JbPQidMNR5WBRQAA5AeO1x5U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 05/15] net/sched: mqprio: refactor nlattr parsing to a separate function
Date:   Thu, 26 Jan 2023 14:52:58 +0200
Message-Id: <20230126125308.1199404-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: c08cc9a1-cc01-423a-9f75-08daff9c58b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MNtlz0tndT7gF3M0Zp/OkMhDBR/pYr0A2q5fFHs5O11W8iwJ0iDnejXQk5DPqxEpPRn9LgUjHxCZwlWP61N8YwlLuTjwhy3EOpXfK+ZOwowUys86DYhtst1rhY4MBLQcpWXVFwOYE5vdJuVtHKK838AJF/FezqnNoA3Tih57tSZy+z2VmgpoZlzy5hDqEkDgooaci6DX95DAKHAhQuIxAspVeOI09/tIfY9NFFsVockrgnSsNM6IZ5oLssrMWhIQ0uCRvWIpkAzvrXw52qjEfoFSf8pOF/UCndpVKVguw0LlRxazQhw9MbM3JbgrCgUHlpbuBAJoEPPmJuH5xRwKhSvRDvOf7yHTSoOx+s01SR8LP4YYeGsMz9/+ytZYs4u9IPfkLzjvmGcWltNDuwIuapQ1qqjySJ6aBOK3cxkP71+DAKZolm2lQY/WDcUnK9vrfVlnuf3MtWLVIgRsRawd4ZTwMmnPj8I8G9kg3EGmtlJXOexxQGXEmIq83fQIyxtPbrjkemB/MrU7Dt/nk/2EIqYTHV22vFrKDBvVCAqHoou+J1o4Bk2CxrMIdQg7JQJ34gu3mAxCsMySrxv97+/qghI6Wiv1CpbjIblwfXJNbLs4oboNmyKdw6IqXapZnAlq4E7zgvqPG9SGAsASA4T0zYpb99r++PoLI4ogTMJiHE68x3OB90LwZPPdPpCrtkhfZ4oOwf3piclbvqb2rjLxOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q+VWAdL44bMUno0A9Komv03GGdNjKVNuf9w1rzKfRcWH/0n+WPL0GcBzckvB?=
 =?us-ascii?Q?X/xNB1XH7XLy9y0BpXtpEUCkhQnF2dCf16nvprE51UPG35UZq48p32X9q20R?=
 =?us-ascii?Q?GMPk+bOwpaOopNSCIqfj0LXBSc4snasrU82EFDZEYALPPAh3rqtWjMKwNxMg?=
 =?us-ascii?Q?P3czwb/YMWpGYK6AQD44z68pEZHLD5aPYk+IXi3p6ftFsurLKzsbFt+zJx8m?=
 =?us-ascii?Q?LcEIElJC91J6hyDeYz7BLPUURxDFAFfRAA9EURRzM1rkVWawXC2gfDoEWCGr?=
 =?us-ascii?Q?jkq8yx8/JsV2t3q0pUmQUDkzRIGWffv9ky2HYbdsFM5XJJ0kxNXWA/IOND4r?=
 =?us-ascii?Q?qDC79vawFkE9EVtiLqS6rs84/zHcX7v2F0uoMMlav34CdBo0U/mtngfiyqfe?=
 =?us-ascii?Q?IzVCdFkh/1VezdEAA7FpH9y6AjkJmTQr7nTKaLiis/miUVDo9oYG728n3q6G?=
 =?us-ascii?Q?ELXwZIrmZ76pRmiDhpVtLz8H1/PQLx41o2wMDXoebg4+p5FDA2dG1S3g1+U/?=
 =?us-ascii?Q?qvF4rYW1tWKHAP9p3KrQmsoPTT8OuT59wwAdPBVBEDGOfsg/DcXm5oO4SC3y?=
 =?us-ascii?Q?HCTI1xwXZOjvsrWSzkFYNElxnBIecXIZ1e5+wToCMoedVPC4QLq8QG/HDekZ?=
 =?us-ascii?Q?o03BOqJDVE+zof+M5Rxr7MoXLMWd4zanmJc+5nTqKtZxtUA9oUc0TlJwWrtX?=
 =?us-ascii?Q?6xkUM3tXnHZCmlL9V88YjS/BCDu5j5jNxr+qTaOe0liHHwpcYemoS/mTmAO3?=
 =?us-ascii?Q?1zfAX6dueJLyCQIUnQ1ZEsjv/+QTfqBx/1V5kea4Q52Xd4bdkhen6P8jX5c3?=
 =?us-ascii?Q?LIrHFbqWf/uEU66ag8m4XuxW1j/CwIihrWC4SJ1iE3u2+/u3Zy7wuM7JJ4Mk?=
 =?us-ascii?Q?NItQeNHPUK+KsL/JCs0IiqllPbkor2Fho0DBQfqNUCQB1uWL8Ttpo9TKbVe7?=
 =?us-ascii?Q?YE6w3DrchoC0D2WcdixEb9JdLWjAE8amfRsxatfUpSD5Wny/2BfYRVKdjglF?=
 =?us-ascii?Q?y6imUaLm7jA8VACKp4rFPtXx/dwfbwt7epYtAXPcetB1hUOo+7E3GicxmgOg?=
 =?us-ascii?Q?OPQbFXJq0jY6MmddxD7eUEVJEw32llz0JpZRaM4O5BU78q8UOa6OXUYH/W0h?=
 =?us-ascii?Q?8cCZqCw4dUiO8MC7X1feTkO9S+YpL7787zZEtfkcacqALCSSa+M8/h8mRu0X?=
 =?us-ascii?Q?Vgz1vCJftf48L64KUODXov1W1Q/YCYZZFpf60cssBfKT9Da4rh8rQERcZJiD?=
 =?us-ascii?Q?NLQeq1H9dqbeyDnEJzcXkBFpZYn1qdI0D/xskE9vkgzGggpwwlG0cSzlEAFT?=
 =?us-ascii?Q?H/Z8zGV0fNQBeJc7d2xGTg6ykaymLgOwiSreIUYY2z6XVHv3cyJyCNraxxmM?=
 =?us-ascii?Q?kBVATBAGg6N6Ik7UgVcku0mAzBJrSZ/oysxeyDp5+Pn8arp43GnmKYXx5Hz2?=
 =?us-ascii?Q?nqE0qD16XKPewVP/3ivif/Qs0dG/R9x2m0jx05h06JoaX2ESSB2RKWDuNyJB?=
 =?us-ascii?Q?dYliGUs6GJSBMjSJvZPMnEhiqSPLnVVnzNN61AnFBWY4mb+iJM11QN5gbNo1?=
 =?us-ascii?Q?Tgeh5Tg/fb4HFs0Z8luTIKh0BfJF8yfugWhcQCyml5/iQm5pITa4mCe8Mhpc?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08cc9a1-cc01-423a-9f75-08daff9c58b4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:39.6903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9P7y+AwZ535GY+txb0rNwDi3nFbZRPs+ztbIsYp8zuO7NZ2F8W+MzDgr1zhESg4e2CEXIa5Wgp3RU1S+928jlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mqprio_init() is quite large and unwieldy to add more code to.
Split the netlink attribute parsing to a dedicated function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v2: none

 net/sched/sch_mqprio.c | 114 +++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 51 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 4c68abaa289b..d2d8a02ded05 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -130,6 +130,67 @@ static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 	return 0;
 }
 
+static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
+			       struct nlattr *opt)
+{
+	struct mqprio_sched *priv = qdisc_priv(sch);
+	struct nlattr *tb[TCA_MQPRIO_MAX + 1];
+	struct nlattr *attr;
+	int i, rem, err;
+
+	err = parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
+			 sizeof(*qopt));
+	if (err < 0)
+		return err;
+
+	if (!qopt->hw)
+		return -EINVAL;
+
+	if (tb[TCA_MQPRIO_MODE]) {
+		priv->flags |= TC_MQPRIO_F_MODE;
+		priv->mode = *(u16 *)nla_data(tb[TCA_MQPRIO_MODE]);
+	}
+
+	if (tb[TCA_MQPRIO_SHAPER]) {
+		priv->flags |= TC_MQPRIO_F_SHAPER;
+		priv->shaper = *(u16 *)nla_data(tb[TCA_MQPRIO_SHAPER]);
+	}
+
+	if (tb[TCA_MQPRIO_MIN_RATE64]) {
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+			return -EINVAL;
+		i = 0;
+		nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
+				    rem) {
+			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
+				return -EINVAL;
+			if (i >= qopt->num_tc)
+				break;
+			priv->min_rate[i] = *(u64 *)nla_data(attr);
+			i++;
+		}
+		priv->flags |= TC_MQPRIO_F_MIN_RATE;
+	}
+
+	if (tb[TCA_MQPRIO_MAX_RATE64]) {
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+			return -EINVAL;
+		i = 0;
+		nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
+				    rem) {
+			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
+				return -EINVAL;
+			if (i >= qopt->num_tc)
+				break;
+			priv->max_rate[i] = *(u64 *)nla_data(attr);
+			i++;
+		}
+		priv->flags |= TC_MQPRIO_F_MAX_RATE;
+	}
+
+	return 0;
+}
+
 static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 		       struct netlink_ext_ack *extack)
 {
@@ -139,9 +200,6 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	struct Qdisc *qdisc;
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
-	struct nlattr *tb[TCA_MQPRIO_MAX + 1];
-	struct nlattr *attr;
-	int rem;
 	int len;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
@@ -166,55 +224,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	if (len > 0) {
-		err = parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
-				 sizeof(*qopt));
-		if (err < 0)
+		err = mqprio_parse_nlattr(sch, qopt, opt);
+		if (err)
 			return err;
-
-		if (!qopt->hw)
-			return -EINVAL;
-
-		if (tb[TCA_MQPRIO_MODE]) {
-			priv->flags |= TC_MQPRIO_F_MODE;
-			priv->mode = *(u16 *)nla_data(tb[TCA_MQPRIO_MODE]);
-		}
-
-		if (tb[TCA_MQPRIO_SHAPER]) {
-			priv->flags |= TC_MQPRIO_F_SHAPER;
-			priv->shaper = *(u16 *)nla_data(tb[TCA_MQPRIO_SHAPER]);
-		}
-
-		if (tb[TCA_MQPRIO_MIN_RATE64]) {
-			if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
-				return -EINVAL;
-			i = 0;
-			nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
-					    rem) {
-				if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
-					return -EINVAL;
-				if (i >= qopt->num_tc)
-					break;
-				priv->min_rate[i] = *(u64 *)nla_data(attr);
-				i++;
-			}
-			priv->flags |= TC_MQPRIO_F_MIN_RATE;
-		}
-
-		if (tb[TCA_MQPRIO_MAX_RATE64]) {
-			if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
-				return -EINVAL;
-			i = 0;
-			nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
-					    rem) {
-				if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
-					return -EINVAL;
-				if (i >= qopt->num_tc)
-					break;
-				priv->max_rate[i] = *(u64 *)nla_data(attr);
-				i++;
-			}
-			priv->flags |= TC_MQPRIO_F_MAX_RATE;
-		}
 	}
 
 	/* pre-allocate qdisc, attachment can't fail */
-- 
2.34.1

