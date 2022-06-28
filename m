Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090A055E74B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347450AbiF1Oxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347415AbiF1OxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:53:04 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30051.outbound.protection.outlook.com [40.107.3.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C42532EC8;
        Tue, 28 Jun 2022 07:53:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LldfNQVqdgM/t3SdO6navghocMhELmF00Jhra9J/q4Zbd23meDm8KPO2m9RbHR5FooqqDmx/5KbCqYl43MhDGPl1S2pf3SUiNZGlbn/HE/yFKd+cKvbpKYnFwHjNlDbz8ldqT8CsTTsEEpNrhxSwfY0Yt16XmVFJPZ7GVt4YsygAflmsEZ24YkiiGHR8OTd3CUHsWiLgbP3YQFzKcXizp8y5cCI8KVyQXbydXbm8j10UO6YjCQNU+QNK2d9vB0JpM4Qab/J57H/0nnArD2KDcBV+eKMYZj2eF3TJ6mhpLkn9oJmZw5GHnqWCGRUG/oIXhZErSqxpfJYCNYsNpdkU0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fYUoBVQCi7erbsZejismTN36Y+bW2Za8NS4F81gaox8=;
 b=kvnK+bLHn/GWGCcJ4mLjzv4GZALfKqOWxhkztLrQXi90/h4HJvF66YEWsjmxU8qugEh9Q7BfXeD8JEVjQy8OpmgkEEuf+GgRs27LaMavrl8r6aBs2c/90VD6c++Q6r6lRndgAYYG6XnmxRBzy8xpx+mSM4gwlNiMq8kc/wrJdzwAHTF0Yo+mRtqI0snZz2WelllgpNV+Lrjqs7FrhgWhKfdbxCsZ52icwGI6oqiRT7I+QS9yQ7RP9Ps3AxZpFGEiE/8bdVHmmF4+YAKHAhTg/3wfhBbRWx6qm6Pr3o3d0AjRvm1IeZzS77ptOTckeQucOCLnB5eOaevTHFIpVziJcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYUoBVQCi7erbsZejismTN36Y+bW2Za8NS4F81gaox8=;
 b=DE6uYpkGJzzz/OEDvVehss9/wyQaGz3/4NlnpwqIJm+BOXfW5N8Vn1/RtR2JgCyIUAiZas2MoDpAErcoW+2vywDliAlGS8hgxDPQv4pWLrmQgvCLQ1k6rKq8/bPh0Bx1w3dosdY5i4MJ3tBlpYenSDq7zkWa7M+qQTNAkW/WX90=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3810.eurprd04.prod.outlook.com (2603:10a6:208:e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 14:52:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 14:52:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH v2 net-next 4/4] time64.h: consolidate uses of PSEC_PER_NSEC
Date:   Tue, 28 Jun 2022 17:52:38 +0300
Message-Id: <20220628145238.3247853-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
References: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0104.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 869e8d27-b5ab-43b8-1e72-08da5915e4af
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3810:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tacW+2JsiHe4YaqmzgwGmMTk21xZMIdq51DYF/Ea8WPLOHSKdNNI8FFI956s8tAkBy6iqmUyi7YSAGT7JASfupWbT4maPi6SQhKYbimO12x7Hi/pMupu8Mx10j3BXQrMjFZ+fzTT53xS7v1NwtfUGQLwW3Xc6mU4IPSpTAJfldvXne7Gs9kvIePlJvPc8vEqMx+MXAZT75tAG1DB8JdsJX1BbfUFMs0czEW7cPaU582Vf3cICUhdtk2vtCzvKIbGUkyda7WlqB+uWc/1vYgFdvsBsPFxP/HtUyQ+p5QgS/QOWQKzMat3hXWvwq8oIyeC2CXqLdYs0zktcqvTaNXEUx4R9L9rWpCQ1sCJzAsGRF+umM2HNDu325pUhUfhQGN55WA0BCyLfAzqswEpDKwoK+tsV4/NyAXdIJ0kbr+K8Skb+A8drzlftw9Tk4WvZX5lA0VCvRZfhKS8dFefAEwUAacb8U1EN1gH0Cz/o4/RdUA9GZXtxAI+wAcOUOVmPeFgkB+MQXqIdnMCU8jF225D3rynUX0cyGuszSVuBo7wkUreWIGghcLNVB87U1qyizgMyRtNhitUyKbCeSPzMeNFwKFL5f8s9ZEv9NQaM7zJlpruZea7AkDI4MD+QaOg/tkbRkQ9mdteDRQCPEnUqEg9ECWqw6bMNpU/U1iM3bhxdwbrgWtSqZiGHBTNO+2ijR86epvKUL3xeiJuXyL0ap71ukoO2HMR/qhl9oNWiV5bWM83MEDEmy3fLj5mDsnNFPIx9xiL9cHXZrk8qwNMZfJlArx4mQFpEd2ZI/edlnaX0Bs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2616005)(38350700002)(38100700002)(41300700001)(54906003)(316002)(7416002)(44832011)(1076003)(26005)(66946007)(66476007)(6916009)(66556008)(8676002)(36756003)(4326008)(6486002)(86362001)(6512007)(2906002)(186003)(52116002)(8936002)(6666004)(478600001)(83380400001)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YPE5Wgck2B8rSBICxGbiE+Ngw+MsGjNpg/i8E1F/Unnzv6slWp7xHKXJgieu?=
 =?us-ascii?Q?QTf3ISUTjTndk/Dht8gPkDoE0RG8SCDbuCd7My8WpkXzBiySPCfUr8xiJ94t?=
 =?us-ascii?Q?j1M2T8YyMsDXWGWkTQYVm8Ry2dLdGGB+yWGp1Rtw+fanz8ZMllAMugGJrCdl?=
 =?us-ascii?Q?xeBWKUx5eH9/TVyqrRq2H2UOicDqzyN2BOngLc86rLPwYMgWWwtB+2CGQBR+?=
 =?us-ascii?Q?6wTC4VFvAA3cf0RzitGfFWUAQcglSCrLBSBF7ozfakIZL9h0/c43QvL+AY1p?=
 =?us-ascii?Q?NhWn1+XoR6PSJC/vfgbS07ax6m+QeK4+BWZvsCuJRAL83ReOR59Qe+k0pYTX?=
 =?us-ascii?Q?3PHeUDSFCNYcYG0TsjVSrsMqPzihQW/3G6qEiNYOs7z8hukZXu4FnFnsFVds?=
 =?us-ascii?Q?wrV73MK6Ecxarm89ICJFg+l4drIeNcyoyL97TsgjnM7Y3uEIsEdeeiASBiFk?=
 =?us-ascii?Q?F+qd7qs/XQimQFHwHcaKIpR+sIjRX6LJpTZ+eMSrMpms559dv5gtdIhplQi3?=
 =?us-ascii?Q?IlW3exd8vdrwCqxF+0R7ixS9KvLDho1fmAjtP4qRR7WC1aF6+yYC4IIO292X?=
 =?us-ascii?Q?+RMGskaGcbEmHKpIp3nnUmgyeb8wumNzW2vo1S73I2lfpsvIlf3PINNolSM3?=
 =?us-ascii?Q?qM5rMvLHVAzpVJO3RU3GkUU8ah/iuMJKzPZ/14sCYu2heiXBN82MU2+4+Fsn?=
 =?us-ascii?Q?/GC/F5l64cRq3YVDSfGTqBZMKYlDSJIXyZFtEfF4y9MQTMRSA1bxxYrLuDSO?=
 =?us-ascii?Q?0h/+qGAC4cMqV0lrDgFJ8zeLegnl/s99PAu0JS/Q0KVSmy69R0+IMbY/yzZ9?=
 =?us-ascii?Q?UVOERMwyHxzdvRNrfZJZVKPtcB4haBYFzz9edIfcwtOBsan4BA8g/CTlEl0T?=
 =?us-ascii?Q?QieHcN6qmXwNCBg85WqVBzv5YYh34pYd4lxmvyyaSVHo20xg8SWIcGRRbx5B?=
 =?us-ascii?Q?MbM61IC3uhBjr3zextLz+WJ5u/1XmKCvI5JjQ2X3eN0eAIxyTyWXCPvJPVai?=
 =?us-ascii?Q?GYhxaO1xnSEh5f8CHjGOQvcvZVJsg1ZlFYCPCUvmuQJlBIO2GwQcI8CSx4kM?=
 =?us-ascii?Q?smmrWqbudBNW/GgQPFihTuz037+ugvwn8YNl8dtBI5fUnPzOZts6U263Gm+i?=
 =?us-ascii?Q?FBOsfDLXCzBsFgwiX5Ef3qPb1PIcf4dKZRDAbuupZY1hQ19GEYLvD2R0tOCF?=
 =?us-ascii?Q?aqe+VUY2dBoYalUjqJ4ujU11L1osVHhz6uLPCb+Efb2dpAzet2QqJJHwni5Z?=
 =?us-ascii?Q?zbnYMoPtLARzk5Kk7pOvAKcZG+HHQS6+7BAkVUY1qC4leY47ktMivS+ARX7S?=
 =?us-ascii?Q?HDuYCDIMbcCCVerRZguvpiJP9GAQjD5B7X4iky3QcQuRVCqwCnOYXHH77g9o?=
 =?us-ascii?Q?2W9SZey4D3DZRKQIeeJzNe2GswJBmEcWU5aY5PPx/ntuK+V5WOcuswtbBvwO?=
 =?us-ascii?Q?DNp3A1btPvz5bwusLfNL7qLK14rdYRKmFTSYDInvGztr3K2EKUGHyblDoEKQ?=
 =?us-ascii?Q?09c+o/jTb9cjksvbJBXPIfszB09QN2VCHw6nIoexuSD1Enrid+VCc4ap92me?=
 =?us-ascii?Q?svLo18FEDU3WCgGEDhDHLmaJABG9DEWTVNgylbG7GaHfXF/ELtQmXyfjKyug?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869e8d27-b5ab-43b8-1e72-08da5915e4af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 14:52:59.3620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzLbYX8HpX6ySvUvS8f860hQY8o5H/YFtsS6uyhp50XRdINSkxyuOQnLvCWKk/ttYuZFoO+ZVP9F645nhIhPsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3810
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Time-sensitive networking code needs to work with PTP times expressed in
nanoseconds, and with packet transmission times expressed in
picoseconds, since those would be fractional at higher than gigabit
speed when expressed in nanoseconds.

Convert the existing uses in tc-taprio and the ocelot/felix DSA driver
to a PSEC_PER_NSEC macro. This macro is placed in include/linux/time64.h
as opposed to its relatives (PSEC_PER_SEC etc) from include/vdso/time64.h
because the vDSO library does not (yet) need/use it.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- move PSEC_PER_NSEC to include/linux/time64.h
- add missing include of linux/time.h

 drivers/net/dsa/ocelot/felix_vsc9959.c | 5 +++--
 include/linux/time64.h                 | 3 +++
 net/sched/sch_taprio.c                 | 5 +++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 27d8b56cc21c..28bd4892c30a 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -16,6 +16,7 @@
 #include <linux/iopoll.h>
 #include <linux/mdio.h>
 #include <linux/pci.h>
+#include <linux/time.h>
 #include "felix.h"
 
 #define VSC9959_NUM_PORTS		6
@@ -1235,7 +1236,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 		u32 max_sdu;
 
 		if (min_gate_len[tc] == U64_MAX /* Gate always open */ ||
-		    min_gate_len[tc] * 1000 > needed_bit_time_ps) {
+		    min_gate_len[tc] * PSEC_PER_NSEC > needed_bit_time_ps) {
 			/* Setting QMAXSDU_CFG to 0 disables oversized frame
 			 * dropping.
 			 */
@@ -1249,7 +1250,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			 * frame, make sure to enable oversize frame dropping
 			 * for frames larger than the smallest that would fit.
 			 */
-			max_sdu = div_u64(min_gate_len[tc] * 1000,
+			max_sdu = div_u64(min_gate_len[tc] * PSEC_PER_NSEC,
 					  picos_per_byte);
 			/* A TC gate may be completely closed, which is a
 			 * special case where all packets are oversized.
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 81b9686a2079..2fb8232cff1d 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -20,6 +20,9 @@ struct itimerspec64 {
 	struct timespec64 it_value;
 };
 
+/* Parameters used to convert the timespec values: */
+#define PSEC_PER_NSEC			1000L
+
 /* Located here for timespec[64]_valid_strict */
 #define TIME64_MAX			((s64)~((u64)1 << 63))
 #define TIME64_MIN			(-TIME64_MAX - 1)
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b9c71a304d39..0b941dd63d26 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/time.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
@@ -176,7 +177,7 @@ static ktime_t get_interval_end_time(struct sched_gate_list *sched,
 
 static int length_to_duration(struct taprio_sched *q, int len)
 {
-	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
+	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
 }
 
 /* Returns the entry corresponding to next available interval. If
@@ -551,7 +552,7 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 {
 	atomic_set(&entry->budget,
-		   div64_u64((u64)entry->interval * 1000,
+		   div64_u64((u64)entry->interval * PSEC_PER_NSEC,
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-- 
2.25.1

