Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BD96DE356
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjDKSCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjDKSC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:02:27 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AE1526F;
        Tue, 11 Apr 2023 11:02:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=li9OUysshzh40t/9khDNV+Uxa+wUyCBDHm/6EcbViVddtdR+AySIQ0qw5oKzd/NX/GCSFuawGc+nRCVGnk5C/sxP79j4X4beWdg92YIM4GGsPuj31Q7lDxkKy5b9hH6DglM+ej2ASS9d54CoANwmSUE73yWdLKx5Pm6LgQaYuzi2vBe9u40v2jrHbO6YpRzp3qymS1o3AfP1T32M4g5KpBMxs9M7RBSX/BgfqBw3Tbnwhpu/9tEBLgrh46FVBcyrVVGY8LHrFwBhKX6u7Y7ZCB8Roqye3iItDMFk86uiRw4szLGHqhnS9G7ebn7oPMY/iBG/+513o6LA5dF1Xl2Exw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHICxalMYFf3wJI2upcaICK+32vwVcjiEmzN8xDnquc=;
 b=P8HfNPO3yGU9tijACQKr0zGpbmIwUdOBYiALkRxeRDPEYrRneyQJ2W/S9QmglNAE5S8C1thGkqSDliREACweih4dL92K3F1kzrVQNKnvKPNklffkpStdHCEekJYYby9ff95tYPP+QL5Knlb+nw8gydxnauO/jpeI7gNCf5+6SIDayxfC3H6keoCddn1RoUyIixFn9cVSIo4w4ZsNdABXOoSR41G/31VeZVj0BFT5xVRSPdcIGZeKfKqvKTWyAlDGuoTvDGj0QRdfMa6fpxhTZ/u52to8Fou4NLjXuiD1940pyUsfyhNy85otYzkPmUDa97f3NL6VgfFhqhgZrq4fUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHICxalMYFf3wJI2upcaICK+32vwVcjiEmzN8xDnquc=;
 b=FCyi3UZxXjev/pLYkM3BQjKDmKwDZwCEZBaUHBqiq8/TuW5goKL4Gw2kNjWKFkgqi6d3brgjYalIZ7arCB0OEwWJCI9QA1l6HU4qrFjtGK0nTaFGuGpLROsGIlAwz1G7huMdUOgSjyYf3VIHaxLGZl0u34wklGU6+UM6RwAc0Io=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:23 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:23 +0000
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
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 2/9] net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
Date:   Tue, 11 Apr 2023 21:01:50 +0300
Message-Id: <20230411180157.1850527-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: e5ce62a9-6dc2-4829-efdf-08db3ab6e6ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4GpMN4zYY6UeAFDpcFcE8OehCj87RyR6Onp7VNKewQZ38YOQd3oB8Rvhdm1jwEzU3NibBM8yTEuS0Gkbap+LfwAeUQupSH1fkXNYBUnczLOy34tTGC7Na1K2qlhYR2zsd0hdaIII/BV28hBtyCAJ087G0rLYyYHFAWcLy9OA+/tShQnBmehTX8hJ3QAqbuqi0SHm4a0OYi+0IDXQ/N5qVOrMORfQY6p+r6MuydCds0gm6U/EVRrxB8yWbZ5PYcnuEzTkAz7WXpfn1Cx+gOyqXG8DVrKnFE/Pat97UNYSHPuDtpAkWLLRWNv/Pvceg9kH8ZJCmSdZG1fM1XRb4/eHsVbrKlaqmso18ypG1Q1tixCymE9xerRfGAF4fj6/eIbgJ8jJFM6ZXaZAlOvcdvbtAXhfoTVqfmHpv7rgtcy76apWNKzCYMI2NWjgwW1O1agV5JwQ50JQ8RN2ztaP2Fl/SO3Cix7NymWGmODWD/oVM9Q1Hx80P64wVTKp7HRgklsT4gLK3fOA2RDh/MaoszM16EQiBHwU+CXzyxJsoyxdeH8Sp7p2jx3+37KRrWd1wSKSt3n0jY1CEbmUTabJvDHOf1n6vCX1/2JOmDudkyJ+9Vu+jTZmlC555/sANOUQvds
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JvROdNK7oFLYZc+1wutND6ia3cAx+ePCRsAisNYZgIjWVvQAnba+oaXQEvZl?=
 =?us-ascii?Q?SUVwbWWOq76skbnoEabP3vz0MBQcKAIbPNAo5PMuAcEZw2+z6WKGQ9yEQ6v/?=
 =?us-ascii?Q?U7qIwdSipXNdMh6R/9jnLlvjlyflkgIXr8b4rVQ+LWDDRZzshBrvRgpj4am1?=
 =?us-ascii?Q?noGVFWvFhW0GIXDXBumILqaKnQp6QWSPJW1a3mTxAZ//8XdUk0jONPvOY4ao?=
 =?us-ascii?Q?ZH8anyeRNzJtqpE8OSEknQlsCPiUP5zUcsn10mTkgPPEJ/yWrfVV3JnuXYCd?=
 =?us-ascii?Q?QfmRw4ZyKdWoXMJHaZsVVpQzXvWI8+W5b3grFGktF2QReKkWyLfzCIXKmsgX?=
 =?us-ascii?Q?q6mohEfQIw1fciyAEaJ4jGLSSSC9Cxs5unvEIACp+Xg6y2rhTqLrtG5LrFRh?=
 =?us-ascii?Q?Zk39eNlmiE0lSDa5W7CqCnqgWssBoiy1jWt313QCM7SPesvVYaKX4vf8QpGt?=
 =?us-ascii?Q?ivDi3otJ9ns8qdPkUok5Ajb1CgVboDhSrd1Qs279glsmzxrSRmcnYBfVcF8X?=
 =?us-ascii?Q?cdsUxLyULMKN41wDZmkaddDRR2OMd5irdZDyZC95GASD1gn2gLRoyM3iAiL6?=
 =?us-ascii?Q?o+o7/dYyHDrEdd5QawIRUE027W39umCOHVnsdtUSRNHpXIWd7FDmEaiazLWk?=
 =?us-ascii?Q?b1cidllQ0g7KkNA8SSaP8KxIWSmCt8oX1xkWWA1outQa4ER6bHfHtjvzd4fK?=
 =?us-ascii?Q?6WLYe1Fy1g3Dbtr8MN37Swzj5zRZJU1uP2veT4fZl/nA6Qr6aEevgPLmtbII?=
 =?us-ascii?Q?CHczgDX3xlwF3j85SIjOQylm1SEmyYiHPWJV1xQpEqEqjRFYVJ+x9xuUFtXu?=
 =?us-ascii?Q?am2ssAvnaVSXs7VOX1lYwBZCsXsARYv0xTxSaGB6a6E9TwLMEVsfG/nDYpgk?=
 =?us-ascii?Q?mLyRVbzH8mUP3fEepqOvXm9/cG+Xqvke5lzoOKiAWXu4nKgayVvkVCJ++H8Y?=
 =?us-ascii?Q?ADHvH+qUJ6SpFBo8FWlnZAOc8XADdjRWhKQuDfauL+ybY4i2Mx43YFQQgf8Z?=
 =?us-ascii?Q?4j20YZEqxUl22rOYeCwclGgNM6+T7unLQxo+uqLNmO61Y/H9geRLHIKbsN9x?=
 =?us-ascii?Q?075Dwmg8G76UreBSYG4W5AzaFfJta6S4Uzu+ZFS5hHkB6IJX1y4v3GeRNFZa?=
 =?us-ascii?Q?ynSgZqut3grq5SF8e6X01oI//k7ik+p9DzWSxdxb4l8SueWMGYEb18IbmcoJ?=
 =?us-ascii?Q?JjFBIG2WD9ybeuauz1D4EmX1bv4WoZcsZyYtvw/bxt354sEoGEziJRvz/4e7?=
 =?us-ascii?Q?8+SBh9OZOYml/2wgnN4rrZkdXPyPNchFMMWUMz4Ved/q+fxyZQSzzjZR1/Ky?=
 =?us-ascii?Q?oMuSRDcHEPDrFpF1BXiTnKffHAEzp87xYIvew2YgfrGaHxmli52Fty5fPe1Y?=
 =?us-ascii?Q?UB11RNFk7xV0skZvTIZkUBrJb1BWXmAiOyHH1rzpGpfUOXHCXJYhEwOBBawu?=
 =?us-ascii?Q?aZ7fPaJ0u3kVyjuKe+qyr7q9Uk3BznZqqLsiyy9qTwxpgw9GRoHQvTwYIb2c?=
 =?us-ascii?Q?hx5PMARTOrrwgyWNj3y9C2lEUFggtQhNQGld2wrjeUdMHAHwOQalG+TkD3eO?=
 =?us-ascii?Q?NExcgv0elkizsdaua0br89yFM9bcwph93i738W00AJp9DUhvCC9KD1vmXQIA?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ce62a9-6dc2-4829-efdf-08db3ab6e6ef
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:23.8427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XvWb2A846lsAGUFYJbM1GAA0Y805I2rTlBBqbBXYgwf+4na7Ne+Wx6fNUeH3YA/GO9BIo00fRtNbzkeXN9sXjA==
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
v1->v5: none

 net/sched/sch_mqprio.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index fdd6a6575a54..89e5dfb22db6 100644
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

