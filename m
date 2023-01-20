Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17B36756CA
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjATOSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjATOR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:17:59 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD36BCE22
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:17:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HA6o8TN0LEHHAM06eZq93fK3P8w/g4k8b4Du6GPy8AgFUUWQgy2ak4gRHOBA7ea4xYJOozu8A/bt8iMsoQ/tW3/OU5BIpvUaTsVdOExfNDUW1927VMGgazGeFyAYHI8/Q1b1XJdRl2uuAah6VgKOcMCKCG5FtGhPcuolux0P1EOHk/NcD+/jrUZysVkksHR91+zDYYktxJSyK8UVVQeaW6nuEZFoS4qG5qbw8FXfm0BcJTYjhnB0nRJ74aIGdNUdvnb2Uc4bc4QU6vJSUxdm9EHwqqa7kzRVX8CRcdFb6tngYM9/GHLt16zA7cn6XMZAaSptQ+4vdT8QoourvKd06w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lepPJvBRogbr0YjJt7Ew24d8hBOgPK4Q04FvGCiJPK0=;
 b=iaETdF9Yax9g1RCjaornZihfazEn9glAvweUXHawT4Fuods5BDiX3IqtaLyV/zt/0N0os8iHtJg5jqHdYXGapIXHvu3MRSpoEcJHTtUsG4Sx9TOn1kyvBxvKpCPA5YCzEtWi1y/5YOB1+H7+LAeWCfJDhqFhLdWIxYMVoSk/2x6PEiWvl5TlCBNOdiloG5bpujf4sB+CiHnnVuf1W2IP9UV/gcjRF2bpmooNyRDvTHUzbJ5q+d7PIsEDvbqvIz4VOsGG6BMy/0WOXJUCbRD0gJssN3crGFHs6s1ZToU1dtxXyAPEMbL/I9uu/KYLoVSuSmJCmvHM7jE9NuXGmgepSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lepPJvBRogbr0YjJt7Ew24d8hBOgPK4Q04FvGCiJPK0=;
 b=jfEQhlWyC6UJTMdX7adpC/aBHO83sSA4RqwB73phbij1qIPCjRrJSFrYe5jaxaNZdSiqu8kaRgx9nHrHSPJE6k8QDx8RcHXCsFeYzLcanBvqv71Q+Pd/R2GANEHyFeLbj3Hkrheqs7vhAKYB6Jgxhp1vnnjXVKu1La9p6YMz4LU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:15:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:15:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 01/11] net/sched: mqprio: refactor nlattr parsing to a separate function
Date:   Fri, 20 Jan 2023 16:15:27 +0200
Message-Id: <20230120141537.1350744-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0dd12d-525d-438d-0f0e-08dafaf0d6ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NW3Jis3dQ8cyL5ht8xd2wCXqWeZKX6onZR/PDc7+cSmQt7md+yyQZDmaLmFwAnaqwUl9ht51aWfa9CAlGvEmJ77J/xjnYgm34VK2HbPARMXXNFjB6mIsRW0vsIaoOZrsC6CwEH8OJQ1bBK4+Rq+sUGr7nIJS/SfbHwaBNQDy/gyl1XaDpkZpS6upwQ//EoLB0yqAin2rpjOyPe3aS/PQ8pLkt83X0gn/l+QHn8PYyDW/JHYSAGQY/cYxIqZlD1NBERNfK235ZYQFYro3iYmQrgKe4b2mgrndZxNcK0FbQ7fB1urgJtYFSKK8h+RgCRVCwkNRcp15Mrv1f0vLb6K4NyY8lPaAq8GqhkFNBCCGx6adkGuVwn80TiKrn3USO2KtcM/T/wio7pQyKSI2RXWaD50CJXaF10yh/i4wt9buDJN3Dnou2xdkMSbOzTo+RKPc5az3YWqYkaBEVygKmvOQUB/Y9L8ncSwgrTTz8z5EwsIdSFX4mh96t5HEU/jibmbSgoiwi4kimf6zC8Wi0AWTAC9uzmSnNlLKAvGdMMTa0lwRFYFw16NKDjPhEKrJJm2ddpnek3UyZZqKCSvGVnPuOh9BTJLWlMsV3RiKOBzz6oOGlnG1WebT+Fq8MuO7xTKizJ1HiEEORy8yDu0EAuvHYeUtL/z2+ZCce+pEFesc8MH4r/94/1Q+3ZkfBNS47OCiEVp2Yw44Ap+NNWGTv5t6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krl+RCMVV2sxdVhewEcO1quWKI6PUqnsRDYTTV0cthwmXVDikXYDKf3VK3zn?=
 =?us-ascii?Q?qltqgxEPIPnvSjdYMnVoOdcyx4vedfFrtT+jf3P+LJjSt4iyXJe9dr3TbUhp?=
 =?us-ascii?Q?eYBh7GRRsNTMzFzGwuLkBSI7+S2RPgWGwcf6MxQZuHvQFlcVtg4cbtNszLec?=
 =?us-ascii?Q?vOQUJ2eSQ6+58TbJqSO34t4ykgujWoVjyI9qwPgFI8MdgyvJwfzbTYbWRS9f?=
 =?us-ascii?Q?nbty3sEs9AWBKnoQnXVj7TZ74Cndqn0Bqjmf5aAoIi2rt9qCDof/MsElB11L?=
 =?us-ascii?Q?GqeY7Gia57O/S6XbvgMXEoRejnmOEkMz9RRbbaJv3SXqVkaQeUiHtTgOWCSO?=
 =?us-ascii?Q?kR7otQ2Dk4hj7zSBn3DFkHCaOqCj8pdy93UFnp4B2vcI5FnvGOUezpxFn3sc?=
 =?us-ascii?Q?9S5zg3fvDZrUdi/FnRi2Mh1lRtMf9borrKcHoBsqZ41F02+E2xXP0D0NwKvG?=
 =?us-ascii?Q?1ZLdKxGmxCYFiFFg2RSwU6aiuFZyyubDdSqgmdYx9pmbU8cW+FEXH6z9lMv4?=
 =?us-ascii?Q?YOpjDApRfVhU3zmInXHUFGhiXiyAwGnJHPA0AYRgrLWN9keoXQeLNYdiS+pf?=
 =?us-ascii?Q?xE5GatJCgJ6Xfqnp9Rqs2ZeRvLh26l9/+Zlt3YZ/YwViKz69kmzLG3wgXSHS?=
 =?us-ascii?Q?k38zulSFJAl7lXZq4Qx/PF2Me67Cwayzy0vqXLvCrwUNeUtYsYVwlTmBHxTw?=
 =?us-ascii?Q?SPct19lBbZAqwNhxzA6XPNZalC+bSMTZdK3rjgUTSGdUPwVARnAjW0VtP9mR?=
 =?us-ascii?Q?z9tJMOVW+f5L4bzqtDfr28UkRjzg4fPFm6kaAqnOtPwWHsrsV8X1C6cSmih8?=
 =?us-ascii?Q?ZsrpeVaOv4AdKL47/8SPZT/fwXxvHbyBFFLpGg5rt3vFG/zxsrPzDICanvYz?=
 =?us-ascii?Q?RdCr9CvLp4U6+dZn6A+E5I0ZJoLKiNDrrdGhRqXReETSSeEos1BuOlkTS6hn?=
 =?us-ascii?Q?S9Dt2TNWHuTfWs0ELm7CpPY6bp+a/lbgcV+aNW77Oz/kVA/TVlGm8JFCflrZ?=
 =?us-ascii?Q?5ZGJtRT08qxu+nJgMiOotkj15I48Ksw0kL/Ea5tJG7e50f10hQo3YdoxrjE7?=
 =?us-ascii?Q?nT/ijgQGo4MVDn1gAROl4uFjONNulc5a8+US+bvVNliQXNFsLTvHsyuJsMcH?=
 =?us-ascii?Q?FuOUUZxRpVACCk17QZNVbhpGHwJE11PRXnW+N65B3Y30uxL1IUDLKPxByvD+?=
 =?us-ascii?Q?Pn223CIrtaK7yOkjt6r3TClgLITg/eypAGL7m33ZMxLLd7YH9W7yQIx5KzwE?=
 =?us-ascii?Q?Ga9hgjMPcE9ZA0vO8uArAmEGyViLptXrVW6vCWXBdcKpT+kROMY9FDoyI1xo?=
 =?us-ascii?Q?lsTlEC3Ye6s+jH7FflxLnFfsxV4VKTr+VF6orlThlCUF6kVK4UnWdu8WyFKM?=
 =?us-ascii?Q?cq/flyggmCoalmT1WVbQuZE0tAyRQ31sBfO2CwTzAUMlUbPdXIYiDg7yvipW?=
 =?us-ascii?Q?hOUT/YRqchRNg3YpnIIalJiXuGdBoxHY7E8P/8yL2DgwAwRV738xvZoeJxB+?=
 =?us-ascii?Q?kLPbSIR2k/U6Y/q0vnzzXtozfOIKGZUaZnzZHd8BRsrs4wRw8tcbnzuMpN3y?=
 =?us-ascii?Q?uqj3ZP7e9gTOpDCU7f9UiEsOrQExLqX5/uzgI0GINHsG5PrOODN+s2DmKtQT?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0dd12d-525d-438d-0f0e-08dafaf0d6ae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:15:52.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMvWIq4FoBBecp/FzgIRYjc+h62BPX77ZTV+WQXfE3ZijQ3fMY4QhLuX6c9SDxoh9GWncMw7pdoRA/PhHPWiDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8085
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
---
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

