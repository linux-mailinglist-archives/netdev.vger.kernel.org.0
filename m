Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2557A698812
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjBOWq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjBOWqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:46:53 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6E623DAA;
        Wed, 15 Feb 2023 14:46:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nrxs2vAWpX1GrwYWriJYsfBPfGUV7NInIOITFzZyCd587tjkBZ0hbJtr1tJWgfapslvXCqcCqRCgiX1jPjeqf6likXYpvbL0jOtCoioQL8Kd+zOOIl7oYqSFj2Ij3N6hfUwyuHB2VT5L7rUHo51SP9Wv6uSGgUYMXNut60bzsnj8NejtIbHqmqWPqnuGP8zmBqhZmozYhZ2F/JrkN62DnuNPDhMdVA2J3rGoCckfe8sr6tyOPSb4Mr7IXOD8p3m6kdHoZCjAyufdmP8vkAdCmFOvIFQeCVN6FluL1Sz0F8Q3IaXzjT+sPxuWf5dQHDESDIcbpbXjhivcusma/Yv82g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lp+bsTyAopi70tU4J8WcgcfETW/aUyO2Rd5PKteqqR0=;
 b=dQbgP3XqvKMvsXZ90oKAuaweOGwyfKmYjlIurRsMWuvi8VbrTyplcDf3wFZ7SUqAU0nqRIk9lgQvl1Z9zMokfKKG1niMYGKLnL7RKor7riTlMmqMo5FBAF5wk0iYildUGh4g07C8szwjuo5ZLuZQqmhe/BgKZyKsLT83y5bQxOE60B89KFo391p/xdorledHpcMaFJvNHsfzKGFLxntPVlfJR+7sZaeJ7sSphLbyiTNVmCMLxERtG6ViCNqVr0ECKW3bh5yO6Ebl1bDr/Jt5QsyxiWCOZi8bg2V4Y1uLstos61RQCtwy06rAeTqnxwDAxpk39Ac5553u79+i/+dkEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp+bsTyAopi70tU4J8WcgcfETW/aUyO2Rd5PKteqqR0=;
 b=QcCF+uH/d9l/qKyPZLXYS+5+7bNwwMFp03qHR5kAlqrcqmWUh8x+M//0FLKiOko7dC27lnu1efJSH7zrCyRGqnwQNLWBrI/IjxwGBmVNG76yP0CGInlncTx3Q5vCHqsOM0cPhreLogm4/cnWFUI+4r7tpAUGbJSQ308fyV0HG+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8748.eurprd04.prod.outlook.com (2603:10a6:20b:409::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 22:46:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 22:46:50 +0000
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
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net/sched: taprio: don't allow dynamic max_sdu to go negative after stab adjustment
Date:   Thu, 16 Feb 2023 00:46:31 +0200
Message-Id: <20230215224632.2532685-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 47dc1550-53b1-44d1-9319-08db0fa68699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FDdXLfIxW/tJyNTh/dXDZCdEFVrwESPfm2cCTKn4exbaruVRZSXrcMxCIRTxLQdZ00KTC79yg1x5N2vPCylrS2yJI661HqB7Yqst5k2k/3j6e3Qe5UDI9sgZ9RlfudoesAp22/+DK2YCwEby5Jyk3LVShz+C9mMsQbnylNN8O6nZxSJaU85YlxDFXAfcAKTneTl0RqAQABTR33A8H5LBg/31aYZSb/NYqXuPCuKxxWDE5hRAZfy9VzR7b41txDdX+3XXfMWiNXJr/p5j9oCPWy70TExI2jrLR6I4V/qFozUTD449Mxyj0AKx/QrOmam9r/dFWuSzzVTtM+juXClujVc9JeSrW4Onin/Dbrfe8WEFley0/ZhTzmvhFSEtWKUJJ6Xo2hdM+ROAspQxayWOa0Jrn2Rxc0SkVby8bbRkzmog5H73k0U6l9a+JB9Xk3cb9T/JRzg6jY1xRAjc1mTPspEFi0ydGnVV5dSyP5svOxLnnBHWTeF34grRnHMTeXoSjDQWfuvXUIKhnc5i+ZegiVLumA8iOZe3YBU5+MTXnUXGlP0vX2FjFSuNaHBCiGA6ID1/UTcJR/9q/Cm5oga9ATzalwlfE6WRsVIVRoTcGeB0vwi5soPE4gCBGcB9X6/4wEMR2B0ybs6jdORSumbaRoEX8Kg/oiETY4Pd4Lj1tPEizEYHNyxl820wNUGy9GyxPAvXvTd6XGkQ42RFRgo45w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199018)(478600001)(6666004)(6512007)(26005)(38100700002)(1076003)(186003)(6506007)(54906003)(6486002)(83380400001)(38350700002)(52116002)(41300700001)(2616005)(2906002)(86362001)(36756003)(4326008)(8676002)(6916009)(66476007)(66946007)(66556008)(316002)(44832011)(5660300002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bvYTNHMyULvpfAAkC31qZrV0hWKX/7smfid03xcnzB/SjLuh7FPVWxIcQ88g?=
 =?us-ascii?Q?ELTymWBQGH/OKLuYMltrUpXSjD8Ukb3W1uiOK0JG6+rySsp7Wi12uxHG+Pvh?=
 =?us-ascii?Q?r/rm/kiEb3M1r4FokNrf0YZkcH4X3Gfgeu1/kRrguM9D0k9LmFaDRztHKJB4?=
 =?us-ascii?Q?yvl7sm/dP4RUmJGDrFSEv/8do7Cbyaxgr/JEUne2kw8Q4bm9ciRpRXD8ShSW?=
 =?us-ascii?Q?G8F2E8IuJpQgDUe0gGezHCvJ3GcTNfy0y8AXShEbhiiC/6Ma7NIySw1mPUFD?=
 =?us-ascii?Q?nn+2/K0YST9rCkCfjmCkkOnu/XzQDBE9IZtGUgfJe3umE/BBhZ0HkbZZfdcz?=
 =?us-ascii?Q?L0GPIUtSUfdG9QCcOFDc1aqna+ALq4hGFdCS3spj/ksonn/8QEBU9oyYculC?=
 =?us-ascii?Q?rFJ1Ta0e2PLt956Tw0jj3ShF5OnI0ZHZhy/nfBVY70U3DLLUEkvnFMvsb2NT?=
 =?us-ascii?Q?HzZyxG/S9v1jQI7qU6n0O5XlR25CembhAeTLLJMP0/NBcymSSNhf10qGZYYc?=
 =?us-ascii?Q?eQB5XvynRSyJQQIT48JuVTU4ZtQANYGJ3CFVLdAwDGO+A1UdS6Esz9iaBy+L?=
 =?us-ascii?Q?QXtGMWAw99hqEVey/u9LDAMyAsBZuzXi1wolMJsOChsnBP6IkVrC1DTCyzHQ?=
 =?us-ascii?Q?xXmVgNNawffYqockg1LaXBYzpFVGMJcScikM2QIR5Ay6clAhlC/pXRao9uTt?=
 =?us-ascii?Q?mQvPgYFst88/PzI1DeOvcbUosxwJZslM+kruGNKR4Vp3lFVIdltdh4b9senx?=
 =?us-ascii?Q?HTenyCxpgZdVtab56ZguJcfiuzl8n+AfeNuEZrnE7QWjnfxVDhE0tEGCqh8m?=
 =?us-ascii?Q?oPko51bJxTtH4Cq186MPpoza4P8HsDZrW5ozGqj04Bh98lEHJDPBZ1TvWEQ8?=
 =?us-ascii?Q?wbcS8IJYTxvce1h0P7sljWgvE19pQafk5A6QGH7AX7r1aUkExD1Q/vQmyYq4?=
 =?us-ascii?Q?1ZnEjIjgi6AMHZxbzXxMtAco78Dcrg2vQ/+NShxqUFLhgGzNfGSGn/oWhfpO?=
 =?us-ascii?Q?IkWbYIChUZpk1m3szshDzQdNFRmzdzKuS2qSXZS/ffd99SmlOlz4GL6cuvMa?=
 =?us-ascii?Q?HdTTRK/q5sObca95Zk/8+4AOYPNfk1BI86K6tzECKPtYVgApClecvNyFoe+3?=
 =?us-ascii?Q?cuaAGP9VM0w7/xmzM19fUZxGHEONUe6PqtopTSiIEv+7xrW0X3QVvJY7pAB9?=
 =?us-ascii?Q?f8EYOvxtrOsQwES9Nvb4g89vN/BSFYdzRLYOFReKDBcqTaA24Zkxzx/IByVJ?=
 =?us-ascii?Q?l8/DhmzKFBwo59ABTmUIFkQGxIc7eUid4Uw2+aq0zJWSup0KwS8APtOXTmXb?=
 =?us-ascii?Q?TU2rzMda9kWMCNgW5xbilHNqLNuo+2NRsEfQP+Z7Z5KNho0o8MldrN47xgSU?=
 =?us-ascii?Q?HLQ+xeeRyJbL1+BPCayiUFlR+IyhXoSVet8i7Vyl+2kj+ozrOIwckmCkzwrt?=
 =?us-ascii?Q?fjC2VQy+c5DgiXBgG9HpWJviiSRCiH5L7JKF4LR2HpPyhEneL4LF9xZ7By8q?=
 =?us-ascii?Q?C09ErE6tzn1iiy7z67CvrkUWXvwv+FU2UCuIQsz79bAQQOMqlgxEfUO49LaQ?=
 =?us-ascii?Q?Kc+TaZpDChvvmm8BRHiyRvSBdGdR0AtGk5xcGuVYlBVnRBISINhDdFa/Lsmc?=
 =?us-ascii?Q?XA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47dc1550-53b1-44d1-9319-08db0fa68699
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 22:46:50.2131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ji0bvSbknheIjZZQSo7oJC9czJHoTp5RUVtTwmJKoP4v4tW+kqATIHs5vE8qzJYF5W2JJA5U+zay2Qi0m1A5Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8748
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The overhead specified in the size table comes from the user. With small
time intervals (or gates always closed), the overhead can be larger than
the max interval for that traffic class, and their difference is
negative.

What we want to happen is for max_sdu_dynamic to have the smallest
non-zero value possible (1) which means that all packets on that traffic
class are dropped on enqueue. However, since max_sdu_dynamic is u32, a
negative is represented as a large value and oversized dropping never
happens.

Use max_t with int to force a truncation of max_frm_len to no smaller
than dev->hard_header_len + 1, which in turn makes max_sdu_dynamic no
smaller than 1.

Fixes: fed87cc6718a ("net/sched: taprio: automatically calculate queueMaxSDU based on TC gate durations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 556e72ec0f38..53ba4d6b0218 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -279,8 +279,14 @@ static void taprio_update_queue_max_sdu(struct taprio_sched *q,
 			u32 max_frm_len;
 
 			max_frm_len = duration_to_length(q, sched->max_open_gate_duration[tc]);
-			if (stab)
+			/* Compensate for L1 overhead from size table,
+			 * but don't let the frame size go negative
+			 */
+			if (stab) {
 				max_frm_len -= stab->szopts.overhead;
+				max_frm_len = max_t(int, max_frm_len,
+						    dev->hard_header_len + 1);
+			}
 			max_sdu_dynamic = max_frm_len - dev->hard_header_len;
 		}
 
-- 
2.34.1

