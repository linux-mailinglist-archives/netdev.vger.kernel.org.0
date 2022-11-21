Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66348632471
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiKUN4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiKUN4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:24 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EA9C4947
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9U2G9uOl4UjXf6fJ1YCDd4ME2LYcXYUG/anIh8ut4KyN75Czrv67clen6nF+BCWhUnOZVOLHsEl28vifb+n3gyxy6vTHc7sIMlLtURm/DJ3rBZM8EQ4TDHIDD4+d9JXyV7xuZLhHbJ+DajL/w/DfxGTK1DEEQnNqs0VmCLgHcRX71IbsDxLgcO/ObvNIXKjsDoh6pL86/+p+W9DzArs8qRMs/KhMmvw4N+Z/9aJjVSPbqbp/WHyBfHY98ABh0WETIBtQIq8ExT4BCo4w8UYc38vON6AQ0bGv4B6fgSlimbXFhtGhgcKEaYQHyO++kh5AnP12va+uXnURR5iEM8EZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h11wepPtQtpkruLmZ6/SSvhuKWagfq99Qvxy2MCU4KQ=;
 b=CFn5Ur/UOoBZIdYda20hbWZDJZCqYdtwE/vkIN+GpKtV357EsgfIfYiEnUILRkE0ZTzE5Xc8/TZxGmx0x9wmszLMouQbbSfvDOA5TNTpIj9UkveQ0Dicq5iHVvM9kRdTsiivPLHc/uppVR9yISDVJkiuRRvzL3bIlTCKISGCB7Q1kWKieYLoKEpaf/RYVd/o61f7NLlJX8fFzItgqGJxMgZqT1WAKkblwAFjmSUw5meMzOqsGDP9vBneudaWZE5mjy2ZWlso1/z2KyVs0qKl2sC+cM7tj5tZRECFjQDTOWr0I+CRufQm4a4m9+2/6jFh/YrelEOwgDVmE0T/t0HPpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h11wepPtQtpkruLmZ6/SSvhuKWagfq99Qvxy2MCU4KQ=;
 b=NlCJIMh+4CXwBYs94FC6uBXstOVJXKc1K+KY/ORiCV8yMM4RftWSawAdY7PsVNJBNT8NO8Er3BmJH4Z7+9UCFubkFwUw4KXfSvFzZAg2IlIuH+XhezOIs9CgUt4ZJhD2ZcANF0y7vOWe9YV8f17fmpwv/PibX3CaGEoaOaFk1ww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 10/17] net: dsa: move headers exported by switch.c to switch.h
Date:   Mon, 21 Nov 2022 15:55:48 +0200
Message-Id: <20221121135555.1227271-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: e86e140d-5293-4d30-a84b-08dacbc82a7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9m5riIrq946pCrcxbXjrMzUmMEn3GCCHf3AQ3TEatdqKrVxpZ39uehRM+NXMRpAV3Ut3caSRo8K46SKG5m9oYA3nZLkWHtzHDST8tOeCHNpkgrCjFAaduMRcu/fiZfsZRSyoyaW6/PAHb99wPBlDiL7NS0Q5PEA0lLxgccKiF8DBJmWPbxHMtHH2FHFwUET9GVjAWnTlFgCDVMJ5tuaYn6Dstrt+PelVjh/nsftRM0Ck9Uxv437Z2u64KmFgnn9/KOOGNtYVJxmJaWhEYqJr82kXK5jRBzRVRCamFo2CYMcR/yPyklwCYjRuz1LCMTh5eub+Na94zVhlGa6PMm2lUA6mQHFDAjhNZYlP7ua49qIHaIyuaKKX7s/Q2/xy5lOwvetsJtmJnsbkGknjdUCX9+tLkjnmsG4hGUHIeUacNBeF6XjDNRUUtbt+TAxp13xYYHyq0Tjq81G+k3kBbgCkNZcVT2lX7DNsys7YN7zy03SZ7OxAY6rKra6MfxwyGLiOrP7v92+l+sv0c/XqTOuXVAWPPQsmKmqvttYQL9KxbU+aw6SDoygsP2yZDOSBkneDDBhYEwfqDzhfVkkY2TUNBZ2Ozx4jP+LTltH455xgj2i+p9UHJwh9KBQUNbYGnLs9/tnhp7AU8RILUOTC57u973IIE8VWyhc/5kzbxsw+Pw6+kikoBRdiZVDOUk06MOt2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2QKbSCHqVhV0YpXJgHGTsixgt8L/bWwoS6xkkvWE0j5dJ1+Ql7HDNY1Ul3N4?=
 =?us-ascii?Q?qa2sGCOkid0JXqAELMjrXB8wigw9fqHJTM8i8OnqExC+VynCuW1uCoCso495?=
 =?us-ascii?Q?nT7bKGm3e1LkD1Pzd9UhAVeId08FpEYjyZfaWdr882ykk4ooAfqTrG6fJD/1?=
 =?us-ascii?Q?dO97ftAcHC3XiMUaFkJQds6rt52D8J3Qp4N+4q1q1PoT4M+qsKMU+ufkt8H/?=
 =?us-ascii?Q?wE1g7cZN+fZpZUGdrhjMnE2A5r8xd0BDa0f2kxTOnozRx5WqbSs5N/ygtZxZ?=
 =?us-ascii?Q?qN7imUYNQLxrVzCnFfPqNYRsWHkFMQt6vL+CFEVmvt5ufmHVwAktonsCa/ue?=
 =?us-ascii?Q?7qczYvRiygMxGzmXcPSumii0Q7cdumy80pqozoXk/ztYJStW5xl0tKpz+Gdv?=
 =?us-ascii?Q?P7Z3SzYRsiYu5OYNQEahaDPG19QMjF9naYuJ3iixxr+i2Vx8t+otYwzCQmHR?=
 =?us-ascii?Q?CQQJfFIOWBQvL9BUbsNPnc5KlnsmtaQsy8CkHhYCXwwUF45WC0pbevgNZeGG?=
 =?us-ascii?Q?CCpHlmxB+uqOr17BZtDB8j7W9ANAMk1Oj8WUNMzBHGETAy+gBGjqGCY7zMvJ?=
 =?us-ascii?Q?m5o8pS2OLombtRPccSlrBWf7kRbBjXMEkD8LkGrlCgJEWHD2YJrIQyC25c6u?=
 =?us-ascii?Q?HaytCjwcRbJxPsOgStXz36K1D7aLYe+WYy5Q2eKY1ewrE+uQhbvehbtCb0pp?=
 =?us-ascii?Q?6mMk7lUEScbTgfps1vBlYHk7RmSgbL/5wTVwDlFmAUmuYt6WF1SNarQAUzfo?=
 =?us-ascii?Q?ZHCYOx+k2eirpfEXTBDuBIjXfA9klrt1tOEwxjsxlworVc2geRfWsxFZ5H0A?=
 =?us-ascii?Q?brXps/ZvpoW1odk0L+D4jTJD6HkGfn3xCDFATLfZGFcJYMkzx88MHk7ACubS?=
 =?us-ascii?Q?SQZ0shPTvfuAhhjWKwARHaKDjYE3nMPDBkQuXYMjidChvJBHPqqL1W9akTS+?=
 =?us-ascii?Q?2g2SOVoSfrO03Hw0eL+Qaf/6eHCx2y52XlL6Jig4CNWF6pPGX7g3K4bYTgUp?=
 =?us-ascii?Q?2/T78mp8O+uIuJnfy3QGSnnJBxDTUJvskqYk+ltS2Y5owCnHkkibZAcVvJ4q?=
 =?us-ascii?Q?SpdQ/+cspY3nR8uDuqE0+n0E+gZka964SJGJqKb3V9+pzGVb1b8rgKE5dCEg?=
 =?us-ascii?Q?buIpZmn5tVZP31FS3p7dfr5qXwMK9cCQnRkXtqctgXv5Sua/2hd8EUKKMIoG?=
 =?us-ascii?Q?UKj+SvRw+ADRe1K5HDfaYgHi847rfn6lFLNRGvMXcxnDuHXEtu6g6g6TqpzN?=
 =?us-ascii?Q?x01SNC1a2O7ZnoapNMun+xtq8KV6QRc6UFU+SBPv15AiOuqw9Br9Lj/CC51c?=
 =?us-ascii?Q?pDXA9+VVC1G5v1XorTgiEtaHxQ9WRKPGGOYya5NC6QRLms7tNyIwvxBtu6Nx?=
 =?us-ascii?Q?W4mYMOUHbD2/7Escfof6qVKxl1GHhON9UR4Kqxgp1aowUwqEJkSgoQaMlbQe?=
 =?us-ascii?Q?sDuODEzmEGS3oxX60EDRkBXMpKlnFzJ5sSCloeNgX3Ojrm329NIy0QuRZWdk?=
 =?us-ascii?Q?mqVNR79Lpq7J7ogEBrBrn0ZnBkhvlssCw85qwwKuq0lQkYS75IBf5tXF6DEB?=
 =?us-ascii?Q?nfEAEhzeL+rrumJfsEJxm4CUm1Yj/r4f4My+Qk9Uu357LtxMeKkz4JCYmA2T?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e86e140d-5293-4d30-a84b-08dacbc82a7f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:19.4972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62t3AHMNPdp0cdX/rYv9t3c7xQOtzGfK56HXO34GAMTNiZsgiZSj99OOT90eGcdBffji/UeDQqaFGnQfJV0OHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce code bloat in dsa_priv.h by moving the prototypes exported by
switch.h into their own header file.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c      |  1 +
 net/dsa/dsa_priv.h  |  4 ----
 net/dsa/port.c      |  1 +
 net/dsa/switch.c    |  1 +
 net/dsa/switch.h    | 11 +++++++++++
 net/dsa/tag_8021q.c |  1 +
 6 files changed, 15 insertions(+), 4 deletions(-)
 create mode 100644 net/dsa/switch.h

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 5373edf45a62..7c6b689267d0 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -22,6 +22,7 @@
 #include "master.h"
 #include "port.h"
 #include "slave.h"
+#include "switch.h"
 #include "tag.h"
 
 static DEFINE_MUTEX(dsa2_mutex);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index eee2c9729e32..4f21228c6f52 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -155,10 +155,6 @@ bool dsa_schedule_work(struct work_struct *work);
 /* netlink.c */
 extern struct rtnl_link_ops dsa_link_ops __read_mostly;
 
-/* switch.c */
-int dsa_switch_register_notifier(struct dsa_switch *ds);
-void dsa_switch_unregister_notifier(struct dsa_switch *ds);
-
 static inline bool dsa_switch_supports_uc_filtering(struct dsa_switch *ds)
 {
 	return ds->ops->port_fdb_add && ds->ops->port_fdb_del &&
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 56728242f079..bf2c98215021 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -15,6 +15,7 @@
 #include "dsa_priv.h"
 #include "port.h"
 #include "slave.h"
+#include "switch.h"
 
 /**
  * dsa_port_notify - Notify the switching fabric of changes to a port
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d0d5a1c7e6f6..6a1c84c5ec8b 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -15,6 +15,7 @@
 #include "dsa_priv.h"
 #include "port.h"
 #include "slave.h"
+#include "switch.h"
 
 static unsigned int dsa_switch_fastest_ageing_time(struct dsa_switch *ds,
 						   unsigned int ageing_time)
diff --git a/net/dsa/switch.h b/net/dsa/switch.h
new file mode 100644
index 000000000000..b831b6fb45e9
--- /dev/null
+++ b/net/dsa/switch.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_SWITCH_H
+#define __DSA_SWITCH_H
+
+struct dsa_switch;
+
+int dsa_switch_register_notifier(struct dsa_switch *ds);
+void dsa_switch_unregister_notifier(struct dsa_switch *ds);
+
+#endif
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index ee5dd1a54b51..abd994dc76d5 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -9,6 +9,7 @@
 
 #include "dsa_priv.h"
 #include "port.h"
+#include "switch.h"
 #include "tag.h"
 
 /* Binary structure of the fake 12-bit VID field (when the TPID is
-- 
2.34.1

