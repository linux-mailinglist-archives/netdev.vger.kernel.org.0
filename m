Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67EE6487B9
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiLIR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLIR2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:28:36 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C5815709
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:28:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3cyOStkIQO5qPeWyaxN+1TzHuFT7f5NsOmtHrFdGlSpEvIO9h3MKoPHd7B1Zt+XEIQhkTdcPHvZDyt41K+HaHz04MXqHGR2aO2gAgq8wDY2bfguFItGSr5g2Bb/yfjv2lgT9FsLL/jqR78mGE09wQ+ugMPkbTrUtrnuPbzGu+Whl/dmxmiSIR0vFPlU9KvTFJr8vqHgcV5XeQ57POCFNceDeTWGZVRDF4gcqaXylF84ZsjtXrDTdgz3OLlVrkpSbr/k5mL9vehntxz6EXGQcL8RlKqa6WgZ8NBBfbJH5+0e0Kp0NNLTS4eRR1xxTonBwbhOj2TEpwO8tfZLhqA/Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AT2WEYDOkBawaok8Nm2T8NPXUxbz6x56Bp5+A781204=;
 b=b2JhFV2txDviOoAfdRvnRQDuSo9zcq2zL3KO6Uht5OLVh8PLETSqGMtyvR4odZmR8idzzQSdePdO/BXHAXNPmikV6dwyST92LLDpJ08xZ3gQiwy6veZgpSm1UN2hbIXBrRozMOhWYe+MwZ/j/XXKil565uz8o0omulpHBMtdLAteRwcsNuJGQPiFbNFC13dY7mqQwEIUY1q8xJ8cw4xd6unaWlZt7XDKV/sJbue4+rjsCXSutfwJN9gHkwyTq8GzJhMGogkzxVxEeD53ZZ0MyN0gR8vEKLRfrDblg/8/Xi19nPopDxMBH8NmGgmQB3XpYhWWYdMn8Ij5a7RGH85YqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AT2WEYDOkBawaok8Nm2T8NPXUxbz6x56Bp5+A781204=;
 b=f9vhZXLBVyaYeZB14GBjMBRkYxEgz3eM1dbURCRvcU7W9eeneD5KVeImyKB6RkZpTJRG0ebSl3Q015RiAlSeTo2TMCmNJgWrMgX6l8qUkrvaejun/IqgTKtjFgyzejvAuOpSOZqKUOyy1OdyFQ+5FbTxvVc7zWMBK4G3xNPewWY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7253.eurprd04.prod.outlook.com (2603:10a6:10:1a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 9 Dec
 2022 17:28:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 17:28:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH v2 net-next 3/4] net: dsa: mv88e6xxx: replace ATU violation prints with trace points
Date:   Fri,  9 Dec 2022 19:28:16 +0200
Message-Id: <20221209172817.371434-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209172817.371434-1-vladimir.oltean@nxp.com>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBAPR04MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ce7a080-1794-49cc-c2d0-08dada0acae5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uh52DhvAX+CtQudxWAdx+GB781uqksZWr2090FrI0scJYu7v/QhBsR1Zk8OFQuhYevQu5ceZN7yfj0kC15bZG2p72NI2GquWaO5zXndZrguNAlON57aFxj4GeTzg5uuRr498iHO9V4u9NPdqC4UPRFMP0RzjFQVKlRn+BkfOT7b9rK8DadTmbVykgCfrdFLsu8HwGTA9oiU1VBC4cLxA5bIzLPKNx+hzx1LrvgG746gG1dESJdVrds9CzjnN+CIwmP+Lu+ukI/TJg0qF7K0rp7Fzt4SHKe6AKa37LPpYzgm68RvIujZfjNquiwayMpF3AXPh8yhR2MN7q8lCaFyWlhc4j+2ZeSe8X84JSyeXkwzlY8cLAvhY/GFpbrRjpNQOBclLvxH1a7LGmOS7PX1Rt3jjf4kznXDPPtdQFAf0Hpjgz2wJbijDE0+ieuSHBjU7rKjZyJ/Qzsix3SapIBYF5Y+Ez7M6ujdc/yhZDvTtRAOCBsd25S/IsPneTEjhuwvsEAe0nAQ6mqkQAX46Vv+JlF3dy+yjO4myj/SVeBwtPZcRtFcoVtwqYcYNN4no83rY3gillONYOIxRVNtCjW13l1uQUDx6i8CPWXBhmMGY8XDHz1yFoPaIDUN3P99NpuIQsgnnlEXJQ/TajdidF9m+5bOqzYFV3P2t4Aaz/PnUBTtXa2f9oTqRV4yKpSb0VG6oFQ0dKPVBcZPVMl4NxPQIrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(86362001)(8676002)(6512007)(26005)(6506007)(6486002)(6666004)(8936002)(52116002)(36756003)(66556008)(66476007)(66946007)(83380400001)(38100700002)(4326008)(54906003)(6916009)(316002)(5660300002)(41300700001)(38350700002)(44832011)(2616005)(478600001)(186003)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DZMxqSlAqyegPSkhrMAWAVyISYzHlYDgeiNPfa0ClwuKaR8GxQbY+KuTsVrb?=
 =?us-ascii?Q?5G3o+lZ+ABUQaeX7Woblnxzbz50xynFpAt9C2iqFz/AXxNjNdsFriu9HcXEz?=
 =?us-ascii?Q?6OzXJdRcAH5EzgU0wm6Vl1pqY61DGADq5tnPvCeDI66OklyLalHNp1B+RHl4?=
 =?us-ascii?Q?46eppU5LXda+Ce+/GOerZGg5hNB+UcM0mY9R6IWNKJyz5J8yG4LqgSnkoQ+t?=
 =?us-ascii?Q?g7det1goVprcUwMKxsUrFsLqXa/MlE8gK+/HUafiMGU4JB1Hnic7BQWlAE8K?=
 =?us-ascii?Q?+rgEnGtQsq4EU4fk9AGLraGXh3neNVHhgE2MdRVhHhZuAjIAyozH1o+O0dO8?=
 =?us-ascii?Q?ThvEYcpqHfbuTnuPumo3WX6Ly7DJoKeEB34UjOJIRJpibWPK5uhep7Psp5t9?=
 =?us-ascii?Q?TgnOyd/CNASuZbRHgsnvn2o/g45hb5x7ClSvlAvx8rs4r+8HMg7wpqpTAMmj?=
 =?us-ascii?Q?lQkHhSip+jT/jvMUoc0C8njW/v9Ml1iAeyB9pycLv6yKQmSberSBxW/S8Hs0?=
 =?us-ascii?Q?YTE92b8iTViFk54F6ccgPDxfbPrTTwpRoR/Cs738P2M9+GE6DYkaG4QJQ9ac?=
 =?us-ascii?Q?LQzTDeeH8dIoKr7vW0EpFrO+TWLNVI3nrHJH/EgYmPf6BIyVBBI/8/8LluBP?=
 =?us-ascii?Q?OfV3crcasp3sm7e8ZRN8mRaIpUGvG0hpwo2cC0rlMfvAVlI+gkAY+OIW7/Hf?=
 =?us-ascii?Q?M2fY1pg7M1fkeHK29Gnb53NnxwnYiyT4oaFcVVf+4IfBBVwizeKhGEq1pbsT?=
 =?us-ascii?Q?1I7DuSr63LK+t34VhKtbNto2o17MBHdLxnx8hJvRZq74V/RT+gAhf6iZy5ZW?=
 =?us-ascii?Q?G6KbLiBQ7+YwTX92nTkXQSgZciU3sU/TzDn9ZHbUJJb7MtL4EATpqV4DVjlP?=
 =?us-ascii?Q?XvkVyu7P7anHOoBMYmcl1I4+GpFPCgy+xkGNWPNp2u2F5PciyZuJIDTRUYSq?=
 =?us-ascii?Q?VjEN7MAnRuI3WFb17SaYSehAu4fV0UYRXNGVi1BCp7iEdmhxj/k1ft3uGk8R?=
 =?us-ascii?Q?DAlGf8QgO5jZLQtA+uOJ3sN3up+doeClvFiy7b2yot7hQd7BILNxVeC3NDn8?=
 =?us-ascii?Q?4eXsGcokFFcjuKMiKspS5WZafhTjZayfdp4HugTOPXYfZiavHpkH3TF23Pgs?=
 =?us-ascii?Q?T0pstuftF+CXmLhh9x8tl3fR5vQD/7KMuEAKVySnEVB6E4Qf98SwO3cmbrqo?=
 =?us-ascii?Q?NL8CYh3XXNx23SwflF/f5N8PZbqeJC8CJXLeSlqqfcJ9aoK6UzCoHhq3QZp9?=
 =?us-ascii?Q?e4I0XgP+2oeU4vGpdlCr7i7zkshPUniw0PbHM3M6aABjbSiS8nFuJ+jduOhC?=
 =?us-ascii?Q?R9mP0rBoYa+pMtkcVcc8jNPBvWRImKkq/Csa5xVxBKWi7cZMMmme5GNTEdN9?=
 =?us-ascii?Q?T/0TutcK2nUhbMKQu9t+HGtNRRsTFHnO/kNCkTyDXvR6xIh2Qei0d1GCb4yM?=
 =?us-ascii?Q?QCCSCeEY4WOGJ/sfdcnBKKZqhZ5JJg7AoTs904TJkj63y14eWUJ9i44//HOo?=
 =?us-ascii?Q?Rh9RjkoN6AnBgm4Nzl4brXwlKHKBa+6Shd2sUCkde/0KayVWgjKpHymzydXA?=
 =?us-ascii?Q?8IU8GFWI8u0yCb1X/2RjNubIERMQAfkDm1kCnEB/AqUBhnchPNDdGgNdQrdM?=
 =?us-ascii?Q?gQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce7a080-1794-49cc-c2d0-08dada0acae5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:28:31.7273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: thB8NShVqOl9Yu7oL5GOAzvoKvfFDRhwluoQYG+SaK2uk2VPSLiVzVvviiLW9Z5xvnTV70+4RzS9yNn+dTgFlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In applications where the switch ports must perform 802.1X based
authentication and are therefore locked, ATU violation interrupts are
quite to be expected as part of normal operation. The problem is that
they currently spam the kernel log, even if rate limited.

Create a series of trace points, all derived from the same event class,
which log these violations to the kernel's trace buffer, which is both
much faster and much easier to ignore than printing to a serial console.

New usage model:

$ trace-cmd list | grep mv88e6xxx
mv88e6xxx
mv88e6xxx:mv88e6xxx_atu_full_violation
mv88e6xxx:mv88e6xxx_atu_miss_violation
mv88e6xxx:mv88e6xxx_atu_member_violation
$ trace-cmd record -e mv88e6xxx sleep 10

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- keep reporting portvec and spid, rather than port
- remove ATU age out tracepoint

 drivers/net/dsa/mv88e6xxx/Makefile      |  4 ++
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 19 +++----
 drivers/net/dsa/mv88e6xxx/trace.c       |  6 +++
 drivers/net/dsa/mv88e6xxx/trace.h       | 66 +++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index c8eca2b6f959..49bf358b9c4f 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -15,3 +15,7 @@ mv88e6xxx-objs += port_hidden.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
 mv88e6xxx-objs += serdes.o
 mv88e6xxx-objs += smi.o
+mv88e6xxx-objs += trace.o
+
+# for tracing framework to find trace.h
+CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index b7e62ff4b599..61ae2d61e25c 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -12,6 +12,7 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "trace.h"
 
 /* Offset 0x01: ATU FID Register */
 
@@ -429,23 +430,23 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 	spid = entry.state;
 
 	if (val & MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU member violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_member_violation(chip->dev, spid,
+						     entry.portvec, entry.mac,
+						     fid);
 		chip->ports[spid].atu_member_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MISS_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU miss violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_miss_violation(chip->dev, spid,
+						   entry.portvec, entry.mac,
+						   fid);
 		chip->ports[spid].atu_miss_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU full violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_full_violation(chip->dev, spid,
+						   entry.portvec, entry.mac,
+						   fid);
 		chip->ports[spid].atu_full_violation++;
 	}
 	mv88e6xxx_reg_unlock(chip);
diff --git a/drivers/net/dsa/mv88e6xxx/trace.c b/drivers/net/dsa/mv88e6xxx/trace.c
new file mode 100644
index 000000000000..7833cb50ca5d
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/trace.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright 2022 NXP
+ */
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/drivers/net/dsa/mv88e6xxx/trace.h b/drivers/net/dsa/mv88e6xxx/trace.h
new file mode 100644
index 000000000000..d9ab5c8dee55
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/trace.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright 2022 NXP
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM	mv88e6xxx
+
+#if !defined(_MV88E6XXX_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _MV88E6XXX_TRACE_H
+
+#include <linux/device.h>
+#include <linux/if_ether.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(mv88e6xxx_atu_violation,
+
+	TP_PROTO(const struct device *dev, int spid, u16 portvec,
+		 const unsigned char *addr, u16 fid),
+
+	TP_ARGS(dev, spid, portvec, addr, fid),
+
+	TP_STRUCT__entry(
+		__string(name, dev_name(dev))
+		__field(int, spid)
+		__field(u16, portvec)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, fid)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->spid = spid;
+		__entry->portvec = portvec;
+		memcpy(__entry->addr, addr, ETH_ALEN);
+		__entry->fid = fid;
+	),
+
+	TP_printk("dev %s spid %d portvec 0x%x addr %pM fid %u",
+		  __get_str(name), __entry->spid, __entry->portvec,
+		  __entry->addr, __entry->fid)
+);
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_member_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 portvec,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, spid, portvec, addr, fid));
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_miss_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 portvec,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, spid, portvec, addr, fid));
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_full_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 portvec,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, spid, portvec, addr, fid));
+
+#endif /* _MV88E6XXX_TRACE_H */
+
+/* We don't want to use include/trace/events */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE	trace
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.34.1

