Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18501687F7E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjBBOER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBBOEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:04:16 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2063.outbound.protection.outlook.com [40.107.249.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74B265F3F
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 06:04:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ilm2BvRTw/2zPGhgMPBvL7GuxDXW/KqxT2d7QwAY0tGJskH0Bha6/Q53HnlSsbeDO/rmql0jlPYqYC5vFvxdugAVPFbLu/YfRH8xkDaj67rJqShb1geBv6g5zBu4DN1fW8uX62e9vh7tv9mk6RV5rhxKSivvqgMOmrcw3zo3kFbTWNNktfZVO0/lvy1Re0jF6XYo4n97YbjCa3TpMgk6VTnGGK08QGVuWr3HI5rr8w55RvUg/n268O6u2yJcRzqus854Fb7leXq1icDWf1G25mSZlXAx78r89AenRagsGG7ZX7idvKDsly+8+wAM9coXvLw0Q3EsBOVvtNAnjIAXuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpT7UhxKNwWZosvGL2J6nL+8LqG1MfKPK0X6/bYwiZU=;
 b=MBn0ce1D04/d6EWMQUjbrf0bM/QvpYLg1IfysLdY96wM7Z+I56xHc4rLT5opkc8jjnfXCt+cXEEQedfxs1LoFUqPOZvtlvJTbbG1l2d1J9zdHr5i6DVCWbdMCM+0J+pzAT2ov0ODExk0FuA8J0HZMTGXXhbVhH240CcPuDzHlNazIYkvCu/aZyouTuETM+/b0n3utIBRgtF3XQVnVG1mZsj4bf0wBgi9Y4/pPasfhy11AuneZFjZqqXsMn6xnt4TBF8pjFM76bJ2z2P4TwhcGcA57YUzVkk8yPRAAThKpZLhV6DFsJiPJo1nnkwnXM0w+IGIaNqAPoRa/t7N0BwHvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpT7UhxKNwWZosvGL2J6nL+8LqG1MfKPK0X6/bYwiZU=;
 b=KKeicU7kTAbnA4pHRm6wmBqCxYWt7m27dO+y56QMi/ojpyF04UiJk+W8+r+qtBQwZslA88GC7PW2enE//IEZ9RF5S7lPXo4ATtX1w7cdZFgWsgaNpAEbrNGrkhexlS67uJ7W0AqJgYIe7+IRTo9fZ5Rw9B9f+B3vfYysgoVY5Mg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PAXPR04MB8909.eurprd04.prod.outlook.com (2603:10a6:102:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 14:04:12 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6064.025; Thu, 2 Feb 2023
 14:04:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next] net: dsa: use NL_SET_ERR_MSG_WEAK_MOD() more consistently
Date:   Thu,  2 Feb 2023 16:03:54 +0200
Message-Id: <20230202140354.3158129-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0060.eurprd07.prod.outlook.com
 (2603:10a6:207:4::18) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PAXPR04MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: f2686628-db53-49e3-3036-08db05265c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7fjuh3+gVKUu2dstDo3RfJ6yUxx4VelQBGtocRhpKWR453US5ynToOO13rCNCuoAlZaK3j4QiaftTiHOUwV10oEg1QszOy1gCzdPK+a/ZnMcpeyaEoTICAuIrCdmwpgKRvjVc4nN7nOFNx5He/c6Reqk23LJz9PYdyGX09O0fmcLeMZ9Y8gGf3v+GJfzgGHjLvW428B34eTdu236koCBcZrVw3rnQpRhHwfcwRyq8hDONgadmtLK7MmY1OLZo4q9Xn6E1p4t+TfCDehoblxd0Gcz8ygQxIIOYMmorFeCXbbQRcgAjfmpovWHn1n+fJhsCc6BtyJjXU4bCJDu7BAIyWzgwl2CSOoill4YEe2qrlwPgwR7DaUO2zCWSMroVEF2YSM2ZkvIW/tHk0OWSgPucIydzUbQHy9acUf04+iTI+gXgR655qP6Phe3kfRB0YJGwkufq6L+cCQLJhrUOEt+HIBJkw1BgXik6G0efP3c8h35sFM7hYeEjv4D6FXnNtsJjs0NFPUrhewxu0KqI0Qk4CaqLmoq6sLPmui+2/B+5mQz1aFD3TGXjZRX+KsCy5L+kgin+YEON7GZ8GN1DYWlO2EShq7rPpNsrFlXUaVYh6NqAkCnaBdXlADsqT5BDxk8fhmwHNJL+aegwCDNdWc1D9MbTPjp4m2Lf9xV39IDVnuj00FJbw49JoQEqmCS+qaAP/TVwu0zfKYQo17PPqvDdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199018)(186003)(38100700002)(38350700002)(8676002)(316002)(54906003)(5660300002)(2906002)(8936002)(66556008)(66946007)(4326008)(44832011)(6916009)(66476007)(41300700001)(83380400001)(1076003)(36756003)(6506007)(26005)(6512007)(6666004)(52116002)(478600001)(6486002)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cr220H/IjAjL5NG+jgmIZsu62rAdRnz6Jhzq0wGOosvaW6/g0G3HPHCPsOUy?=
 =?us-ascii?Q?Fnc5vKwDCzktx/5FtrIJM2MXMlIcG/fqgDkM67mjwbhQXWen/bn++cgMqNkH?=
 =?us-ascii?Q?gek7pzjnqwUzowq9h1hdvs/gLz50VYb9i/O/MAiqDUt2iFt29p6FBQQCH5sY?=
 =?us-ascii?Q?+0jlgQ+83TFWBw3wqJSpi4BjM6toFJuKxrGc8uLJCJB/7LA+cZpULZZzuo1H?=
 =?us-ascii?Q?BkAdgKOH0n/R+iJNcrUu/yVnqD/G92J1GyHXTeZWtl9T0PC/NkozwAMcLArh?=
 =?us-ascii?Q?C1SWCyVK2wrPwPB3rH/3OFwSCVRD4A4IbOW530IDWYnjcm33cm0fvmv2MMn4?=
 =?us-ascii?Q?zG1o0OiPw4crbGUT7rkzHLDTcLnV6m4SVtcrL9yUw1buQcFmYJwJ4E2giJJP?=
 =?us-ascii?Q?nQux4S5ZBBHwxzgaWm91LPD0J1d2r9CEUVZjZy82NWTjFbFW4kk6fBpHi6NE?=
 =?us-ascii?Q?B4wyt9mN9FFLZZopEpqIHXmaE+uefX0sbvYqcMnZ7JSNwP4P/AOWOV7z2X+p?=
 =?us-ascii?Q?SViLDU4FMe7YbG0q1jTYvdHfGtaV9MRvoi9TZ6K9H9ApJXAnMw8LLEa/SUHD?=
 =?us-ascii?Q?diD/1M9nbswOaQ0FB8nSf3ekuoFAiNcyLuZFduI/zJnf460HKXN4rKKEtk4J?=
 =?us-ascii?Q?9SNGBHoIcQewY4ZNfnez8bqO0/gpTMNpdF4ajsQzVRRWsHypFvcDqYO0UjMN?=
 =?us-ascii?Q?gXRSXBgZOTbciUcw5wSMu+Gx5kIE3WYC6Ay/gRPmbYQ5xuF8+2zEw7XoB3fz?=
 =?us-ascii?Q?2f3phiMZGsPdeSbTWEVhNPsUFvQgdPEBjUEvumBCp6djCJkq6xhTQZQO85Ye?=
 =?us-ascii?Q?9Fvds7Pn/2pKj1/1tPw9QJ5jK3l+nJxne2OJkTzz2a4DQAVHqUZJPlX2ze6a?=
 =?us-ascii?Q?fBidQnF3NSfXWA0QuKu91/DZ0DBJ6ZLpmuqPl3jfhvVrNJAmUBl5cjXOQfov?=
 =?us-ascii?Q?DMrFZAQxPDpF1UOOS2XIxjTU6n7BETOuert2T8vI5kjTNNmw1dUenHo0rvjE?=
 =?us-ascii?Q?cXLAoCLhBzvNGirvpNgUoj7ZLD5c99qH4AxPyhZ+77mt9njm4/JNuYfHqk5A?=
 =?us-ascii?Q?MqmV1lD9KIxhWjt9J614cDUefQpWTuCuPiP1TGh+XXVNiZdXxsz3lrYXATV0?=
 =?us-ascii?Q?GLQ+tWhZLmxz+Z2QFPvn8xPnJdwTne36KS5bE1vAZF4oV3QS9WzXAUP57LTE?=
 =?us-ascii?Q?eR2fhGRI6nf527rjHcXjgixSKVjYSaIoq7xCLBmGjYWfmYITUmyY8F7keuMH?=
 =?us-ascii?Q?SF8Dp78e5LBfqyqjHle2ESazWQHLeO7GlsZzocZn+/twJKqrswDRxjfG+uNA?=
 =?us-ascii?Q?w2I8harTr/cEpX4UAOWEjPMcSRWUE3YIWuJzDyPLK8PeQW1j0RiLVzDgFrYZ?=
 =?us-ascii?Q?HCy6YyKwVluDGZ1QLzq/BHb1ZE3pOTn4nisMAdzvM4fYlGF5fbg/PY+wirY3?=
 =?us-ascii?Q?/ZiGw0RGliDKFH0yr+AuhjJvYfGcry3giNzdtLfmA6X+BvIDe+k4wbmHbX/a?=
 =?us-ascii?Q?/taKODUi1+/XwqYdahVBRIRQGiQemqRNR5ZNf1Wzxa9WySKRqbOr1SH2dkco?=
 =?us-ascii?Q?1ozcm3Qt88eKozK5dOFajX9/lUZomhUVUGARNXD10OqD669c9Kc51/Z/nlwL?=
 =?us-ascii?Q?rA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2686628-db53-49e3-3036-08db05265c84
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:04:12.4776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jsPw+nnuyEptwwS/sCRia4bWO9RziU8LrRGrKx1GGTy8IXr/f4c/FAQAg91oUnHq/8ALTZyeORDACuxmof6RnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that commit 028fb19c6ba7 ("netlink: provide an ability to set
default extack message") provides a weak function that doesn't override
an existing extack message provided by the driver, it makes sense to use
it also for LAG and HSR offloading, not just for bridge offloading.

Also consistently put the message string on a separate line, to reduce
line length from 92 to 84 characters.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 26c458f50ac6..6957971c2db2 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2692,7 +2692,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
 			if (err == -EOPNOTSUPP) {
-				NL_SET_ERR_MSG_WEAK_MOD(extack, "Offloading not supported");
+				NL_SET_ERR_MSG_WEAK_MOD(extack,
+							"Offloading not supported");
 				err = 0;
 			}
 			err = notifier_from_errno(err);
@@ -2705,8 +2706,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			err = dsa_port_lag_join(dp, info->upper_dev,
 						info->upper_info, extack);
 			if (err == -EOPNOTSUPP) {
-				NL_SET_ERR_MSG_MOD(info->info.extack,
-						   "Offloading not supported");
+				NL_SET_ERR_MSG_WEAK_MOD(extack,
+							"Offloading not supported");
 				err = 0;
 			}
 			err = notifier_from_errno(err);
@@ -2718,8 +2719,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
 		if (info->linking) {
 			err = dsa_port_hsr_join(dp, info->upper_dev);
 			if (err == -EOPNOTSUPP) {
-				NL_SET_ERR_MSG_MOD(info->info.extack,
-						   "Offloading not supported");
+				NL_SET_ERR_MSG_WEAK_MOD(extack,
+							"Offloading not supported");
 				err = 0;
 			}
 			err = notifier_from_errno(err);
-- 
2.34.1

