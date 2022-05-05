Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450C451C485
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381607AbiEEQHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379571AbiEEQHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:07:52 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2069.outbound.protection.outlook.com [40.107.22.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23802CE19
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kT7TkWsPK0a1wVfvt4m8QQxuS0Iuv1sqVVZGFBx6Sr1U0KfZcmvlMXGyse3Omk0GdqWAiXVi92TcdV3yJoubZ94N9cOkLUARF1mpQJYqhXPSxqQykZmN/DO1Jlzf+DnQGPsgFTNOnFEZDZ2VUP5IpDISbKvYbbnss/T8pltOeUrTfRku7hf9ZOdS00ALp6TG79zxDzjgoYPRF4eqA+6dGYU+Rtou1tU2EL+lCbDxBN8JLUdjKnlqDTINs+ylS6fmyMc4sU7JfKQzTz9cR8DTgBKxpkBWqcZugiaFyndwLulbXw/WQfOEfOhjVlghrIcSdW+I9TEXWgiHVG7Rm6JEow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12ItFIsJjMq4jGJkVYMwL60L8BuczOCJQSteQMJuOKE=;
 b=TwVyvhxm1miYNj1b6XtiilCFIiDNdJ6/X6EIKT54CMwkD4WJhkfCZ8ju9XAknFNtSFow4Zfzyaw3ahoTI/8Kvd3QhPLHXjfgJJE7DmeAO4JSbl3hZTzK22H9f4EEy4+xrXCr1QGQOfzmKs2bmXgrGpE2NnuxvKF+ILZ0ssD5HygMXNco+Wo5T2AKeKowzDRFeoU14JY0WP1X99UVSJ8M7K8RsSf/ibguo/VAf9hdrc51MKevMJHS6DIkGaM0AP11FLT1toDG3nvd2wlqP7JnpT8/2mAMDYgvde/TUpDNJOf3/YWiAeDFoCEJmM3j3C/l0b2u9d0txkgL2GJFrLjWkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12ItFIsJjMq4jGJkVYMwL60L8BuczOCJQSteQMJuOKE=;
 b=UMPv7N7459Qfnr2y9lB8JGHix9Dwx45Zr24X/ntkiC2sN0LLdsCq7Pr96M94iU6wpJbbuoIIrEGOenCSrkGM1GsNBtGaLHQBYKhwy8XUdu2Wj5lqoBq0h++lzhdVd5H70viSK76nKtwkbRsSw9A4lBGmQG9hkU/VLTg2qxH2yLU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4631.eurprd04.prod.outlook.com (2603:10a6:20b:18::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Thu, 5 May
 2022 16:04:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 16:04:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [RFC PATCH net] net/sched: taprio: account for L1 overhead when calculating transmit time
Date:   Thu,  5 May 2022 19:03:57 +0300
Message-Id: <20220505160357.298794-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e886fb2a-3866-4bdc-def1-08da2eb0e407
X-MS-TrafficTypeDiagnostic: AM6PR04MB4631:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB463139835C044170E390F914E0C29@AM6PR04MB4631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5RzvmUHISVUteYq9oT7C4MkFrXoI5t+UeXB2DR0tz944aUHFlvebUmhHs7dFcr+Emaw74s3G8ztOzyoowY+GoBMT+tQ/yd2u49FMfLuRX5rESzE0ugnpWM7C9oi+DOcRUg+0zHaDBr0H7T9IksKnz9Fc88AuPdHjOMINheBbt1u/LXxgnjdoglj423V/SU+1L3sxL/nYr9/mCguvl289MWgiwjUiEEqRoYvNNovyIvZW5xwDfK8cTyMSgMvhPzi4uiRlpEoxVkz6+94gvGVzIAaVzun6plmz2x2hEBGCBpJR7tnqa4J0XPZ37orLnDapBMgfnR9VaXoXiXTDb16TZzEFnEoI7UqzJ6opCmBHrYITOORI4ZvIFZW6xvIO3a31Cmh7bRwMVFnS3XfhRt3JD1jph2GfeL8GrE//eQcUz7hrc5Ln77EvKc+/HWIo8DYBkC46xSlNKdUedoawcF0Y8ucVTST9a3rGD+7bQbeUsDL9JHUz9JXQA8Kiy0+n8yRjgKeztkhOM7idsJ1q9tVYC1QzRIZqwtvr73CmTGoCitYj8TeinBomnbnzPk47y46t7VCQJE+ozTWZUkg50Nn8pk3zjr1tS237m+9QtLw+AiXzTX3PH74y2ihSppP6waHyvff3CIGW844aaNAODPQQ29Kx9G0p+ie5sliJf5Mh2yLEac6nD/DM84HiMcDTEx77LcQLv9I/EZCdiBgHT+Thg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(83380400001)(52116002)(508600001)(38100700002)(6666004)(5660300002)(38350700002)(6506007)(15650500001)(6486002)(186003)(66946007)(26005)(6512007)(6916009)(54906003)(316002)(4326008)(66476007)(66556008)(44832011)(8676002)(8936002)(36756003)(86362001)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PCA/7IufYnphhVq7en50jwM1BXhunsOc4o98pBezH3FtZW/v5AW0kCPR7jLr?=
 =?us-ascii?Q?gQQs11fY64dLAvmyaHqSNuk9cGcpkmd/nkrUkeHBF3RRattAtEdgdJ2cndJq?=
 =?us-ascii?Q?rOr9ANKISoIEgK3GMdvDPhEqu9y5b8LxfWlUbA2RHmOTLWyXPXrGKA+QA27D?=
 =?us-ascii?Q?L/lX2ZO2/SRwCHszigEhk4vIdN2YyFk8dMOeYzUuVTBUo6FEDaqiw9pj/KfZ?=
 =?us-ascii?Q?e4sfE27WXIp3LUvPXo07Gktiic4C0OZ9EyOzvhcVKhI1GJlDvzsXUzh3XPo8?=
 =?us-ascii?Q?DMvrvxm9sWfrkXv1o0rS9uTAkcXzTNznUiIF11txL7BtrYKgvfsgmHueB5mt?=
 =?us-ascii?Q?ulDdwjk3RVLhRnIvFlaXNIVx7JFrXibsuSNi+bU8aOStlVcRLFaGHGxtgJfC?=
 =?us-ascii?Q?Zk2ATKdjdp7/Yl05838JumXpTzyrjcMyV69V00iDXQw+XTG9qyBw3KZXgAbL?=
 =?us-ascii?Q?Tv+fzDR98EoYriQ4zSoMgwR1NNnkm9AIe5ncmCHJB3ZwYQMjVmNpSRUUKECS?=
 =?us-ascii?Q?uD+rR/LoWSkhh6MRVHWCUEdNfpnMqHDBqC4koZg/BfGrdTtolF2U/ENsqMwU?=
 =?us-ascii?Q?Scq9esJ+7eSJRVlhmPsW2AltEPoVHgtOXeMyhRXZ6b+XsBKC6mv6BRXZO3C1?=
 =?us-ascii?Q?spWb8/Ay3RvGKeWyZASZNmrI5FMEF2D1oMCapy7TxJmxyJhQrT3GMbKSKRu5?=
 =?us-ascii?Q?LHGXDs+8Ti/+17Jdxj8kwvt9EED7pKhde/ClW57s6bDup8W02RrqYu30U5b6?=
 =?us-ascii?Q?WVhLiEI39m6GCShs5mlrrydxepCf6Zgq+fkeFCMwP+Gp0YMSe4uEgcvvWoVE?=
 =?us-ascii?Q?SKFBQl8pX1O/eEv2bc0Bhvol0wRJrDSQvOxmc4BgHF7ZwrQMlWOcusYmQW+6?=
 =?us-ascii?Q?JaXCcQp88suZpWWVk8LLdGwPryzDMLNKgghFDljSjrHf30GGSRzFV/K6Wd6z?=
 =?us-ascii?Q?VDK+/BAOOtUIf2uFymx04+s+BPIqPkg+QubU+ouRU9LdU/TNzTB88Q8+Q5r8?=
 =?us-ascii?Q?s4S0d552BK3jpYQnddSZT/Tprl9McnM8qVV+ZrXHYmYrKp9MDu2WAuuE7I9O?=
 =?us-ascii?Q?i/ec1pn4TOEvZjXGKhf20dzESMiVKvTkaNuJ5tY/bc2zuCdXIeX08Me/lIi4?=
 =?us-ascii?Q?I7Ws1XnXhIlI3JbJl4Rn6SNB3WczTqXOWvYNZJ6YUvi4PoXx03GObaLCiNjf?=
 =?us-ascii?Q?5j++9vYCDKXQ0g6BPzPhWnih8PFQhO6c0dD0/m7+F9wcLUv/qosAnTP+AAPP?=
 =?us-ascii?Q?VWCCW84ygvwrj4ni1Q2dk3wBP6UiDLXVjKiFpdk1bS5jyX5Ml/bgOfgyOV4N?=
 =?us-ascii?Q?JvDHSJoaS31VzqzVaxXc5oaor2QnuwMsVw8uRKMs8clt83WlhMzT6TcM7C3W?=
 =?us-ascii?Q?bsCIrNGqDoaZkMeO7dCGF02SZTHAoza1MbTHAlcIN/LUy/59eEe3MOt+kXgV?=
 =?us-ascii?Q?IuCbrpofkuQrXbtUhyPLdtKytHpRYHNWGl2NTbBhG9zddr5PMoqSg9Edp0ij?=
 =?us-ascii?Q?motZM7PXlCfZxTGv9obAjcLErg/vvfIkSdYdCA1osK7/jpLx+qddF2utjbfP?=
 =?us-ascii?Q?S2+bi7BfTVPhbo66GT5PVfQNheXUWi8zzNiEFAKsKt4yrtGvLdaqlLXgFurp?=
 =?us-ascii?Q?mEBApF8G/twGL+fj+NA6qEVAE/LXAFkx35PUnSTYw6QBebnttuH6qIxqgSc1?=
 =?us-ascii?Q?Ox7eq4Gtzh0Egp1hTQ3/8c0x6U/2iQmk+1luMkPOgWXGCuBKAUgn3ef7R3FR?=
 =?us-ascii?Q?fJSjUeFv1+XP36VVikFk2WU7Idnd23k=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e886fb2a-3866-4bdc-def1-08da2eb0e407
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 16:04:10.2907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejLo+26bbKBuVGIHAIOtXObZIE7IxLQ4JsJtoCY3MdIZAb71yGwvKYZMjl6ez9ubSNyElw/rhpg7UA/ZhYV78Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4631
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The taprio scheduler underestimates the packet transmission time, which
means that packets can be scheduled for transmission in time slots in
which they are never going to fit.

When this function was added in commit 4cfd5779bd6e ("taprio: Add
support for txtime-assist mode"), the only implication was that time
triggered packets would overrun its time slot and eat from the next one,
because with txtime-assist there isn't really any emulation of a "gate
close" event that would stop a packet from being transmitted.

However, commit b5b73b26b3ca ("taprio: Fix allowing too small
intervals") started using this function too, in all modes of operation
(software, txtime-assist and full offload). So we now accept time slots
which we know we won't be ever able to fulfill.

It's difficult to say which issue is more pressing, I'd say both are
visible with testing, even though the second would be more obvious
because of a black&white result (trying to send small packets in an
insufficiently large window blocks the queue).

Issue found through code inspection, the code was not even compile
tested.

The L1 overhead chosen here is an approximation, because various network
equipment has configurable IFG, however I don't think Linux is aware of
this.

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b9c71a304d39..8c8681c37d4f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -176,7 +176,10 @@ static ktime_t get_interval_end_time(struct sched_gate_list *sched,
 
 static int length_to_duration(struct taprio_sched *q, int len)
 {
-	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
+	/* The duration of frame transmission should account for L1 overhead
+	 * (12 octets IFG, 7 octets of preamble, 1 octet SFD, 4 octets FCS)
+	 */
+	return div_u64((24 + len) * atomic64_read(&q->picos_per_byte), 1000);
 }
 
 /* Returns the entry corresponding to next available interval. If
-- 
2.25.1

