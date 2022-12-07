Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28C8646542
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiLGXk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiLGXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:40:14 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850E88AAD1
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:40:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xj9Ug/+wIhk3wOPZHJhOEMRFTVM/bXBOopHGG8GlZfQmvqeiCOQPf+sLKDqeI6iZB+WOgOtoQi84O46z0WpUzbwvk1cy3YTUtDhe06gQeLOr6outKk9BfG0SGSO4M+pKEEfQ3iXAtrXzRCvF7GToycbvemLhjF5BjxAQ8vzQIgIN24+QDEdStcl1LGcWAUu5A8AHDwQfme6cyy4iKkt/5M2NAT/jM36Qu2OF8UH3HxIE8A/BsDKXyaUYsYpr4AhKtofjd0kENVe0OKYWjZM/vnYIr6TBAfAuqHNYVANA3CZPbxaIgPolTsEzR6oMAWeqqdQlufNhxK7my1vtl0SspA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3caiiJ1o1HuSfrrkv4CHt0bCAYpR8ibRcVOehoa7v7I=;
 b=CTBHcPqJ/Z7WGLEpCe0Tvta8kSA2+GDV4M/Z5imZ2wUrmFa+ck8OY2Qm7wqvVAXoXzvkT1ffw0dFrmsICz9GdcgLdoDgmdDCnYN6zzJ4Ujxwi8bxePpOHFExLUo5fEHP0R5EtReMNcUPRNaBP0OxJletKv2e4eLkUQBiYkhd9QAnwM7ud+pLKnNgNUCrvCybd5r3fdK4ceJ9Oh/s3SCdEWXHZMtNkmS2awoaNWsYZe48d07b5onri9wKITro1+C06IgljVk2zkvjNEsUCKjPbXpJlhNAabKq1kP5gCx/F4XYgXEcpHiC3WLAlIohoe0tDLy6yePPx5HeRlPUzeivdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3caiiJ1o1HuSfrrkv4CHt0bCAYpR8ibRcVOehoa7v7I=;
 b=QP90kFEIdWcLnm6cbYqBxTkQnUoRZdjEOCSgOo+kJcr6Mz1cuSDk9vT5k3sHV+bOR0zykFWc5G5+x098QcWhM25Vkx99NfLbY7pObQK/PXlv988DiwGwqLdIW4hlgb0G11pEJ89gs+NQ4nX3s81TkPa2QTrOEk2wXOLjNCzBVYU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9659.eurprd04.prod.outlook.com (2603:10a6:10:320::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:40:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:40:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: [PATCH net-next 2/3] net: dsa: mv88e6xxx: replace ATU violation prints with trace points
Date:   Thu,  8 Dec 2022 01:39:53 +0200
Message-Id: <20221207233954.3619276-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9659:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b9a0a9d-7b11-4a13-3dd7-08dad8ac5f64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3BmsnAWPCpMlP7knw/9YTAs+XNSkUFiygR58Q4YlsmXvUgMGwU4HNz98ioUndl1mdC1yAoaeDv0fmO9oD5Do7MH4emrklC5Fnel5lGgvw5Ab1z8xK/TuFWqs2yepvNrU1jxn7Pvz6K1yk+qb+2px9mBEwpL1RZt7dcQ425cGMezP46y7fmVcASvtVULpWHTM6VtPTFoF4KFrvI4kfXKEyeCPsOS9SUegeeqj7A2hEyqlq3LtpRfdjRM95BfiVRT2dmPeBFJuhs1c0pHuE+Q4t1em1oSgSZ5v/1lZF2+RloheulT/6JnuUWrRPbrdJeVxRtC8vWZtA4c8uIm6Whm12qfrM+BIcjX/yevnLxxbE0LIvoXp0wl12MiyYqLuZnXOmFJNiTc8nj2D0yTIAbGu+pexHTVJqci50Qg0LgWvn2VDF21HT6KMEam9RMWycmGJbxiduYQXvzLiuHovvDGSmOTJgd777eHP+Uo/53106M3pQMWXgHCQaNF2tJ1yf4JeupNiS/u70cJhkMTCeoTSkcWqMyKMZYoONZeQpiUSq61tHXax9ZX83JY4UuI+vCpnJWXjZp2lDeRxDrgybBzEUkkufY309x/nod7FWL3mS9598Ed2YNRJ+Ezp09nVfxgWQvYFcgylG9ccPcHiht0noqceol+rsgI3QJEn0uhe/K7jWZHOIJEtOOj3KbRJ7Tl8/ZdZdpIhlJjExhx/BCJnrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(41300700001)(44832011)(8676002)(66946007)(4326008)(66556008)(66476007)(8936002)(316002)(2906002)(5660300002)(6486002)(478600001)(36756003)(54906003)(26005)(186003)(6916009)(6512007)(6666004)(6506007)(52116002)(1076003)(2616005)(83380400001)(86362001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wTCPAt0mOAHOhOqp9OT3yqBcb0+5UUUML0Lx6Vf+Ss11EYN9GGP/pUzB/1DW?=
 =?us-ascii?Q?BHuEN76HW8EbcsTxzc6r7jMzDhvVn/QD2FJNAEkD1ww/vn1mh38uVWYzxitb?=
 =?us-ascii?Q?Br01Uhskz407RDJFuBum7S4gBHY1e4GHKq+p4f283oksLfuGzQykFmibkxmP?=
 =?us-ascii?Q?2QU6f2y15KLrYN7n2h6oh6N8PnESOX5YkNFHi9o5VkkaYJMQk5EZGEt+zrEx?=
 =?us-ascii?Q?/QGGSjflttr57aGBtAAYtpeqQ9ZGVnGnfu3pjVKLC6T2aVjkFevXZec2XZFe?=
 =?us-ascii?Q?zwzwPZ1CwlrE9xsEI6oqMZRwtObSzCMZmbFiiGNqkLOAOr2Kr6/6S48Bq+fU?=
 =?us-ascii?Q?X9RSoopQw7B1rv5S5p2Nlcs7Pfo9xPBWTeSfpq2lHLnclJ82vF6Uf3N4ziho?=
 =?us-ascii?Q?lV+URj8sYvTejg8JMNYHAiWlOlodFNuCBODU0+xmA69lhZ4Y8vLtFW9/zBOn?=
 =?us-ascii?Q?ZjnzyDUuyQcVPUu1dMwviP8XxKssnCHP58mo2owf0YXriWgB7ilnbcNS+Pk0?=
 =?us-ascii?Q?aEZA/J6HTXETBqRpiHudvEPSwKX7UZAUg+WTkevDJG0B88eWZpD7Kkf9GjJE?=
 =?us-ascii?Q?tFcGWmGTe1rFKxcCOdaAjlAsGE/BsH2PC2bC1uDWb7j8Qoj2Sya+Vo3SnKT4?=
 =?us-ascii?Q?1ghVLILD1kmWnh8lFDNiiDAWXC6Zeva66lNNKwBgXeb9+FzgAY7lZgtM59IT?=
 =?us-ascii?Q?OSiXyiI2GNEu4BqdbKDRvwr/ohtKqQ0mDAKAjpZgY1RP/zJ9qhp7NCgb+rcx?=
 =?us-ascii?Q?t13q6QifwBe7APw5BSfMDZPI3p/yLyp0J8cuv+3r7xCavFeB5NKpim25WOKC?=
 =?us-ascii?Q?FIyqVc790SkQEtoQwYROpKuE60HdYWrvVPZjfBgG7sX3FF1bvsEItCqkeQC5?=
 =?us-ascii?Q?o96WF1Vu6GC0/fVxoHtAfyzBBUwZc0gK/jgM3/rtlfjc+pNX5oFXmHCS19tp?=
 =?us-ascii?Q?ph14P8nI+9E3a9QE0V6XNei5O51oStiiuq55zdABSQPJeXtHZOwZVSgcRljl?=
 =?us-ascii?Q?NRiZUyY5GL2+Uv5Wbv2E5Bqh/E8Yht+fq9xfSqWxngVCtiv2FqmG+hNgUgFh?=
 =?us-ascii?Q?HctFJONEj5IJce4qAA197WyRxxeumZizl9ZODT93mQKpcEQnDdhHobiFwMLP?=
 =?us-ascii?Q?3BWNdqq1JUdv0ZhykrvFl3ZMwZy68Ez6pbpF59wi3zIa2YBML1Vh5alCoHAM?=
 =?us-ascii?Q?2U2KvyXGyWrfISP8JziOZ4QG058ltM+YDEbg8rB8s5/VP4pVM/JmnBgpINKM?=
 =?us-ascii?Q?kKor8XaWqJUcHMNxl2JgZNf0teUNA1RaoMiKB7zsHnEzTyJS/h9fLBK5v/Dn?=
 =?us-ascii?Q?juCLkZK4pFiYtcgs1hLFzRFf2yNK11KLYgP99to6DDX/4dSHQJCxZOlKe0kg?=
 =?us-ascii?Q?od3+UQMvzpjMendZJ6dNGYcBapG539Xg0tXf13daz6L22BtXazsxWVxQW5Ik?=
 =?us-ascii?Q?os8JvAKLdUxy5wsSozUAFsg2C/2TXDF4Y76R2b7ADnoCSnyekbkWh581GAUv?=
 =?us-ascii?Q?j8+OC3ui96/o2tI0ssfkSXcY/DSlA8WmwqQjAbbTcsiJvO+lHPeDrdklWsTI?=
 =?us-ascii?Q?cmlspxSgEtrhFjmjF+J8R7DB1xCd9D00AKanyYEO5kzHJF7mFWt5d5rtXPZ9?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9a0a9d-7b11-4a13-3dd7-08dad8ac5f64
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 23:40:07.4444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TVdC2lO0/TuMDKTMyUGa/fe0ujANEGUuvOMKds3PhaN86pti4sJYlOXqW/JmtmNLx64zWuXyPqiyIrtYj1PSiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9659
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

I've deliberately stopped reporting the portvec, since in my experience
it contains redundant information with the spid (port) field: portvec ==
1 << spid.

New usage model:

$ trace-cmd list | grep mv88e6xxx
mv88e6xxx
mv88e6xxx:mv88e6xxx_atu_full_violation
mv88e6xxx:mv88e6xxx_atu_miss_violation
mv88e6xxx:mv88e6xxx_atu_member_violation
mv88e6xxx:mv88e6xxx_atu_age_out_violation
$ trace-cmd record -e mv88e6xxx sleep 10

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile      |  4 ++
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 21 ++++----
 drivers/net/dsa/mv88e6xxx/trace.c       |  6 +++
 drivers/net/dsa/mv88e6xxx/trace.h       | 68 +++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 12 deletions(-)
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
index a9e2ff7d0e52..6ba65b723b42 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -12,6 +12,7 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "trace.h"
 
 /* Offset 0x01: ATU FID Register */
 
@@ -429,29 +430,25 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 	spid = entry.state;
 
 	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU age out violation for %pM fid %u\n",
-				    entry.mac, fid);
+		trace_mv88e6xxx_atu_age_out_violation(chip->dev, spid,
+						      entry.mac, fid);
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU member violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_member_violation(chip->dev, spid,
+						     entry.mac, fid);
 		chip->ports[spid].atu_member_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MISS_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU miss violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_miss_violation(chip->dev, spid,
+						   entry.mac, fid);
 		chip->ports[spid].atu_miss_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU full violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_full_violation(chip->dev, spid,
+						   entry.mac, fid);
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
index 000000000000..dc24dbd77f77
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/trace.h
@@ -0,0 +1,68 @@
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
+	TP_PROTO(const struct device *dev, int port,
+		 const unsigned char *addr, u16 fid),
+
+	TP_ARGS(dev, port, addr, fid),
+
+	TP_STRUCT__entry(
+		__string(name, dev_name(dev))
+		__field(int, port)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, fid)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->port = port;
+		memcpy(__entry->addr, addr, ETH_ALEN);
+		__entry->fid = fid;
+	),
+
+	TP_printk("dev %s port %d addr %pM fid %u",
+		  __get_str(name), __entry->port, __entry->addr, __entry->fid)
+);
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_age_out_violation,
+	     TP_PROTO(const struct device *dev, int port,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, port, addr, fid));
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_member_violation,
+	     TP_PROTO(const struct device *dev, int port,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, port, addr, fid));
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_miss_violation,
+	     TP_PROTO(const struct device *dev, int port,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, port, addr, fid));
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_full_violation,
+	     TP_PROTO(const struct device *dev, int port,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, port, addr, fid));
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

