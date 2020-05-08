Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E422A1CA526
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgEHHY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:24:28 -0400
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:53667
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgEHHY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 03:24:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNC9+731a3CWCcECrm/R47pxoTFQUWIbsYx70U0uXuyeKV1V2VVuXgSI1HvM1kDWHPHOmTAf6BqdlZnAP1IrIDAHybfHaMaSkyDW+ObIELYMuNYzqBcRwTiWd1duYLEk9MM/tB4/bPXfVSckjHSWk72DWFm2rhQ+AMMzpTmfMEoZzu1A6kp4boTH6l39m5CtcWZwV/etJ7C+r4pN4f5pILG+KEAlMsboP0b1o+vf9W3AHyCYBxGpu10C8/QsAYlY8TKP5kaA/CfeXmS27299IaWsfmRUZ8UENEYIjpfkYiK/OtwmhSfik7AB0UnAlYs/V8rjP/CdqLFTdibnQ7phlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgjWMsPxuiOr6wE/8sTzOvGiwmjz37fLOThclwBCxnI=;
 b=LVN5K+UkpT6kzauuLlu6mB0bd5H59tItPAhTdDz5LB4DDwE5k43uIEM7Qa0Sj3rtm0HyR2Drs7U14GMtoF0lgb0kQvQ8GYCUAZP8iBeplEYyBK9TXyjTmd9uM0Bmviz4VKTIVrSVoNB9jXFwnKKADbCG3wJNnUJifG/2OKYfpbr9C4o8E6VJZXn8w0R65sMEZYl6BfS92Zip1JNdsisJiEEcEkLjt7OqGj87hHxT5WGWiF/ddJoGPdPweUFK/aY4Wu0lRkicjgU34DdfOXEu0FxZWYF+qxVm1Q6gfrc1Jcg3qfyrc6v3n6tZWBhEZglIelMop/63Krjdqd8jR0jNYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgjWMsPxuiOr6wE/8sTzOvGiwmjz37fLOThclwBCxnI=;
 b=o4kFXzl0AOCU4B5NOXbuQX8pM4h1nZMt+xJw9+BCHy05GYbeVovJAqSk77dAm77aTjB8RR6O+wyY5zMjlikR3NBgIwOl16GeMGF4DQL78yRhrkZsJCncfy2V0cQhpWD+gpbsUXOK/2bFVlGjAY3T0LYnJ2T0zRjneZMW+qrZkyA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6494.eurprd04.prod.outlook.com (2603:10a6:803:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Fri, 8 May
 2020 07:24:10 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.034; Fri, 8 May 2020
 07:24:10 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, stephen@networkplumber.org,
        dcaratti@redhat.com, davem@davemloft.net, vlad@buslov.dev,
        po.liu@nxp.com, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, Po Liu <Po.Liu@nxp.com>
Subject: [v5,iproute2-next 1/2] iproute2-next:tc:action: add a gate control action
Date:   Fri,  8 May 2020 15:02:46 +0800
Message-Id: <20200508070247.6084-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506084020.18106-2-Po.Liu@nxp.com>
References: <20200506084020.18106-2-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by BYAPR06CA0041.namprd06.prod.outlook.com (2603:10b6:a03:14b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 07:24:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d371124c-9d64-4867-d674-08d7f320ccaf
X-MS-TrafficTypeDiagnostic: VE1PR04MB6494:|VE1PR04MB6494:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6494FF89CFC2290C0495907E92A20@VE1PR04MB6494.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ku9dEgHTqziZKISVANpZWlXhhpO/QzKSR+JJvg06U8D2LfzYHLOXAThVHb3Eewu/FqfWQf/hV453/uYnb90P5atyEZK81+g2XmsFfQqzyIB2bxtgwB44/aD8qFfN2hupfzfr5kkfRIuVsyUe3WxHgcJpF8sDd5rOUh1wOKO+eKErf8mkutDByJQKI1YtsdeSuAsI+teZqbBB784mQTh47CJWXprOxNQdILs7BpMt4eKRV1j7ZRFEKTkyq2dSYyPfGfTGTZLkbniMWiDu+7mP9mjl5NQBZocoFxWKMB7NsQRFZJycs+TFVSXS9tt+wBX3/+pZ7I54lpjuMvWFRC8AhNCFcadZ911Fz8xWtLYq83wnqQrrgqmkAVAQb4ttszLtw7K8Y71+P+4IAtalrmCM9t43Vd+pc5G66I3nTtvszeph/gRUkhP4AovdcOsyyoJu+sCnAIwb9W5Dg7eQT+nndRWNSjy20offzX4Kqf7IDitZS0Msmq5keP+eQ22jwApYvx25X+3Z3g9bhYrdMgZI+p8u98Vo90FUHxUENC+XItlkEaRfUdALfxrWbpNUnVXK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(33430700001)(6486002)(4326008)(8676002)(8936002)(66556008)(6506007)(66476007)(2906002)(6512007)(16526019)(26005)(69590400007)(52116002)(66946007)(186003)(6666004)(478600001)(2616005)(956004)(36756003)(5660300002)(30864003)(83310400001)(83280400001)(83300400001)(83290400001)(83320400001)(33440700001)(316002)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E4PZJiL6DzR4Zx46L6D/JkxY5pa9MiJv+v7XnCdeynXw+qgiB7qf8hjL7QjTcaXG/9Ge0ItmZiyDBIQV+Z9kfIjk0m8irC3RQLNPIPUQtf1Oy+5/lBtROpRcsyd+QekDw757f2/mf7wefHM9ZGIhllHoG68e9UChYSmiUNvF7yaU3cVE+5ctQrif4vdkmzq4oFXCXf9BnxLiRgIK6Muf9z+0CjhgjdXXsdbqGHlIzlWTpSD3X5vSp/dbIqQ3EfcrnLZk/pMNUlKMSqSU44PflPnlqn2/btyp/72PnybTAXy0cP/b0xH/BuxwjD8YMNKDYlft4WgcWX2RxQkitBiOeqdVyEZA6/+ts9NPnRHWaoql6DFe/xUYV6gD/WKWw+pSg3CdueIPgNESq3e7YFoSgiOZZj/+KyuVDH1exH2tRoxrC114MvtUxPg/CqMaqd39q7jKnJ3c9MZgAsaDwTYQ3tSPccNucil5X/5pJKWiLLA=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d371124c-9d64-4867-d674-08d7f320ccaf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 07:24:10.3698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1lwlwotfXTSqDSchIoST3cDqLAvKzGnBMgX9MUVnmf2hgMbeIPhFu0OL3LXsZy9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6494
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a ingress frame gate control flow action.
Tc gate action does the work like this:
Assume there is a gate allow specified ingress frames can pass at
specific time slot, and also drop at specific time slot. Tc filter
chooses the ingress frames, and tc gate action would specify what slot
does these frames can be passed to device and what time slot would be
dropped.
Tc gate action would provide an entry list to tell how much time gate
keep open and how much time gate keep state close. Gate action also
assign a start time to tell when the entry list start. Then driver would
repeat the gate entry list cyclically.
For the software simulation, gate action require the user assign a time
clock type.

Below is the setting example in user space. Tc filter a stream source ip
address is 192.168.0.20 and gate action own two time slots. One is last
200ms gate open let frame pass another is last 100ms gate close let
frames dropped.

 # tc qdisc add dev eth0 ingress
 # tc filter add dev eth0 parent ffff: protocol ip \

            flower src_ip 192.168.0.20 \
            action gate index 2 clockid CLOCK_TAI \
            sched-entry open 200000000ns -1 8000000b \
            sched-entry close 100000000ns

 # tc chain del dev eth0 ingress chain 0

"sched-entry" follow the name taprio style. Gate state is
"open"/"close". Follow the period nanosecond. Then next -1 is internal
priority value means which ingress queue should put to. "-1" means
wildcard. The last value optional specifies the maximum number of
MSDU octets that are permitted to pass the gate during the specified
time interval, the overlimit frames would be dropped.

Below example shows filtering a stream with destination mac address is
10:00:80:00:00:00 and ip type is ICMP, follow the action gate. The gate
action would run with one close time slot which means always keep close.
The time cycle is total 200000000ns. The base-time would calculate by:

     1357000000000 + (N + 1) * cycletime

When the total value is the future time, it will be the start time.
The cycletime here would be 200000000ns for this case.

 #tc filter add dev eth0 parent ffff:  protocol ip \
           flower skip_hw ip_proto icmp dst_mac 10:00:80:00:00:00 \
           action gate index 12 base-time 1357000000000ns \
           sched-entry CLOSE 200000000ns \
           clockid CLOCK_TAI

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
These patches continue request for support iprout2 tc command input gate
action since kernel patch applied (a51c328df310 net: qos: introduce a
gate control flow action).
Continue the version 3.

Changes from v2:
Fix flexible input for a time slot - sched-entry suggested by Vladimir
Oltean and Vinicius Gomes:
- ipv and maxoctets in a sched-entry can be ignore input default to be
wildcard(values are -1).

Changes from v3:
- Fix json 'gate state' output update json format output: add array for
'sched-entry'
- Update input for 'sched-entry' parameters absense conditions

Changes from v4:
- Add support unified tc command time and size routine suggested by
'Stephen Hemminger':
input 'base-time' 'cycle-time' could input as '100ns' '200.0ms' and also
support the default decimal number input as how many nano-seconds.
input 'maxoctets' support as tc command size routine and also support
the default decimal number input as how many byte.

- Update the commit example with input/output time and size routine

- Fix duplicate parse_action_control* action control suggested by 'Davide Caratti'

---------------------------------------------------------------
 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_gate.h |  47 +++
 tc/Makefile                         |   1 +
 tc/m_gate.c                         | 580 ++++++++++++++++++++++++++++
 4 files changed, 629 insertions(+)
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 tc/m_gate.c

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 9f06d29c..fc672b23 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -134,6 +134,7 @@ enum tca_id {
 	TCA_ID_CTINFO,
 	TCA_ID_MPLS,
 	TCA_ID_CT,
+	TCA_ID_GATE,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/include/uapi/linux/tc_act/tc_gate.h b/include/uapi/linux/tc_act/tc_gate.h
new file mode 100644
index 00000000..f214b3a6
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_gate.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/* Copyright 2020 NXP */
+
+#ifndef __LINUX_TC_GATE_H
+#define __LINUX_TC_GATE_H
+
+#include <linux/pkt_cls.h>
+
+struct tc_gate {
+	tc_gen;
+};
+
+enum {
+	TCA_GATE_ENTRY_UNSPEC,
+	TCA_GATE_ENTRY_INDEX,
+	TCA_GATE_ENTRY_GATE,
+	TCA_GATE_ENTRY_INTERVAL,
+	TCA_GATE_ENTRY_IPV,
+	TCA_GATE_ENTRY_MAX_OCTETS,
+	__TCA_GATE_ENTRY_MAX,
+};
+#define TCA_GATE_ENTRY_MAX (__TCA_GATE_ENTRY_MAX - 1)
+
+enum {
+	TCA_GATE_ONE_ENTRY_UNSPEC,
+	TCA_GATE_ONE_ENTRY,
+	__TCA_GATE_ONE_ENTRY_MAX,
+};
+#define TCA_GATE_ONE_ENTRY_MAX (__TCA_GATE_ONE_ENTRY_MAX - 1)
+
+enum {
+	TCA_GATE_UNSPEC,
+	TCA_GATE_TM,
+	TCA_GATE_PARMS,
+	TCA_GATE_PAD,
+	TCA_GATE_PRIORITY,
+	TCA_GATE_ENTRY_LIST,
+	TCA_GATE_BASE_TIME,
+	TCA_GATE_CYCLE_TIME,
+	TCA_GATE_CYCLE_TIME_EXT,
+	TCA_GATE_FLAGS,
+	TCA_GATE_CLOCKID,
+	__TCA_GATE_MAX,
+};
+#define TCA_GATE_MAX (__TCA_GATE_MAX - 1)
+
+#endif
diff --git a/tc/Makefile b/tc/Makefile
index e31cbc12..79c9c1dd 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -54,6 +54,7 @@ TCMODULES += m_bpf.o
 TCMODULES += m_tunnel_key.o
 TCMODULES += m_sample.o
 TCMODULES += m_ct.o
+TCMODULES += m_gate.o
 TCMODULES += p_ip.o
 TCMODULES += p_ip6.o
 TCMODULES += p_icmp.o
diff --git a/tc/m_gate.c b/tc/m_gate.c
new file mode 100644
index 00000000..327df7eb
--- /dev/null
+++ b/tc/m_gate.c
@@ -0,0 +1,580 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2020 NXP */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <linux/if_ether.h>
+#include "utils.h"
+#include "rt_names.h"
+#include "tc_util.h"
+#include "list.h"
+#include <linux/tc_act/tc_gate.h>
+
+struct gate_entry {
+	struct list_head list;
+	uint8_t	gate_state;
+	uint32_t interval;
+	int32_t ipv;
+	int32_t maxoctets;
+};
+
+#define CLOCKID_INVALID (-1)
+static const struct clockid_table {
+	const char *name;
+	clockid_t clockid;
+} clockt_map[] = {
+	{ "REALTIME", CLOCK_REALTIME },
+	{ "TAI", CLOCK_TAI },
+	{ "BOOTTIME", CLOCK_BOOTTIME },
+	{ "MONOTONIC", CLOCK_MONOTONIC },
+	{ NULL }
+};
+
+static void explain(void)
+{
+	fprintf(stderr,
+		"Usage: gate [ priority PRIO-SPEC ] [ base-time BASE-TIME ]\n"
+		"       [ cycle-time CYCLE-TIME ]\n"
+		"       [ cycle-time-ext CYCLE-TIME-EXT ]\n"
+		"       [ clockid CLOCKID ] [flags FLAGS]\n"
+		"       [ sched-entry GATE0 INTERVAL [ INTERNAL-PRIO-VALUE MAX-OCTETS ] ]\n"
+		"       [ sched-entry GATE1 INTERVAL [ INTERNAL-PRIO-VALUE MAX-OCTETS ] ]\n"
+		"       ......\n"
+		"       [ sched-entry GATEn INTERVAL [ INTERNAL-PRIO-VALUE MAX-OCTETS ] ]\n"
+		"       [ CONTROL ]\n"
+		"       GATEn := open | close\n"
+		"       INTERVAL : nanoseconds period of gate slot\n"
+		"       INTERNAL-PRIO-VALUE : internal priority decide which\n"
+		"                             rx queue number direct to.\n"
+		"                             default to be -1 which means wildcard.\n"
+		"       MAX-OCTETS : maximum number of MSDU octets that are\n"
+		"                    permitted to pas the gate during the\n"
+		"                    specified TimeInterval.\n"
+		"                    default to be -1 which means wildcard.\n"
+		"       CONTROL := pipe | drop | continue | pass |\n"
+		"                  goto chain <CHAIN_INDEX>\n");
+}
+
+static void usage(void)
+{
+	explain();
+	exit(-1);
+}
+
+static void explain_entry_format(void)
+{
+	fprintf(stderr, "Usage: sched-entry <open | close> <interval> [ <interval ipv> <octets max bytes> ]\n");
+}
+
+static int parse_gate(struct action_util *a, int *argc_p, char ***argv_p,
+		      int tca_id, struct nlmsghdr *n);
+static int print_gate(struct action_util *au, FILE *f, struct rtattr *arg);
+
+struct action_util gate_action_util = {
+	.id = "gate",
+	.parse_aopt = parse_gate,
+	.print_aopt = print_gate,
+};
+
+static int get_clockid(__s32 *val, const char *arg)
+{
+	const struct clockid_table *c;
+
+	if (strcasestr(arg, "CLOCK_") != NULL)
+		arg += sizeof("CLOCK_") - 1;
+
+	for (c = clockt_map; c->name; c++) {
+		if (strcasecmp(c->name, arg) == 0) {
+			*val = c->clockid;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static const char *get_clock_name(clockid_t clockid)
+{
+	const struct clockid_table *c;
+
+	for (c = clockt_map; c->name; c++) {
+		if (clockid == c->clockid)
+			return c->name;
+	}
+
+	return "invalid";
+}
+
+static int get_gate_state(__u8 *val, const char *arg)
+{
+	if (!strcasecmp("OPEN", arg)) {
+		*val = 1;
+		return 0;
+	}
+
+	if (!strcasecmp("CLOSE", arg)) {
+		*val = 0;
+		return 0;
+	}
+
+	return -1;
+}
+
+static struct gate_entry *create_gate_entry(uint8_t gate_state,
+					    uint32_t interval,
+					    int32_t ipv,
+					    int32_t maxoctets)
+{
+	struct gate_entry *e;
+
+	e = calloc(1, sizeof(*e));
+	if (!e)
+		return NULL;
+
+	e->gate_state = gate_state;
+	e->interval = interval;
+	e->ipv = ipv;
+	e->maxoctets = maxoctets;
+
+	return e;
+}
+
+static int add_gate_list(struct list_head *gate_entries, struct nlmsghdr *n)
+{
+	struct gate_entry *e;
+
+	list_for_each_entry(e, gate_entries, list) {
+		struct rtattr *a;
+
+		a = addattr_nest(n, 1024, TCA_GATE_ONE_ENTRY | NLA_F_NESTED);
+
+		if (e->gate_state)
+			addattr(n, MAX_MSG, TCA_GATE_ENTRY_GATE);
+
+		addattr_l(n, MAX_MSG, TCA_GATE_ENTRY_INTERVAL,
+			  &e->interval, sizeof(e->interval));
+		addattr_l(n, MAX_MSG, TCA_GATE_ENTRY_IPV,
+			  &e->ipv, sizeof(e->ipv));
+		addattr_l(n, MAX_MSG, TCA_GATE_ENTRY_MAX_OCTETS,
+			  &e->maxoctets, sizeof(e->maxoctets));
+
+		addattr_nest_end(n, a);
+	}
+
+	return 0;
+}
+
+static void free_entries(struct list_head *gate_entries)
+{
+	struct gate_entry *e, *n;
+
+	list_for_each_entry_safe(e, n, gate_entries, list) {
+		list_del(&e->list);
+		free(e);
+	}
+}
+
+static int parse_gate(struct action_util *a, int *argc_p, char ***argv_p,
+		      int tca_id, struct nlmsghdr *n)
+{
+	struct tc_gate parm = {.action = TC_ACT_PIPE};
+	struct list_head gate_entries;
+	__s32 clockid = CLOCKID_INVALID;
+	struct rtattr *tail, *nle;
+	char **argv = *argv_p;
+	int argc = *argc_p;
+	__s64 base_time = 0;
+	__s64 cycle_time = 0;
+	__s64 cycle_time_ext = 0;
+	int entry_num = 0;
+	char *invalidarg;
+	__u32 flags = 0;
+	int prio = -1;
+
+	int err;
+
+	if (matches(*argv, "gate") != 0)
+		return -1;
+
+	NEXT_ARG();
+	if (argc <= 0)
+		return -1;
+
+	INIT_LIST_HEAD(&gate_entries);
+
+	while (argc > 0) {
+		if (matches(*argv, "index") == 0) {
+			NEXT_ARG();
+			if (get_u32(&parm.index, *argv, 10)) {
+				invalidarg = "index";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "priority") == 0) {
+			NEXT_ARG();
+			if (get_s32(&prio, *argv, 0)) {
+				invalidarg = "priority";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "base-time") == 0) {
+			NEXT_ARG();
+			if (get_s64(&base_time, *argv, 10) &&
+			    get_time64(&base_time, *argv)) {
+				invalidarg = "base-time";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "cycle-time") == 0) {
+			NEXT_ARG();
+			if (get_s64(&cycle_time, *argv, 10) &&
+			    get_time64(&cycle_time, *argv)) {
+				invalidarg = "cycle-time";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "cycle-time-ext") == 0) {
+			NEXT_ARG();
+			if (get_s64(&cycle_time_ext, *argv, 10) &&
+			    get_time64(&cycle_time_ext, *argv)) {
+				invalidarg = "cycle-time-ext";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "clockid") == 0) {
+			NEXT_ARG();
+			if (get_clockid(&clockid, *argv)) {
+				invalidarg = "clockid";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "flags") == 0) {
+			NEXT_ARG();
+			if (get_u32(&flags, *argv, 0)) {
+				invalidarg = "flags";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "sched-entry") == 0) {
+			unsigned int maxoctets_uint = 0;
+			int32_t maxoctets = -1;
+			struct gate_entry *e;
+			uint8_t gate_state = 0;
+			__s64 interval_s64 = 0;
+			uint32_t interval = 0;
+			int32_t ipv = -1;
+
+			if (!NEXT_ARG_OK()) {
+				explain_entry_format();
+				fprintf(stderr, "\"sched-entry\" is imcomplete\n");
+				free_entries(&gate_entries);
+				return -1;
+			}
+
+			NEXT_ARG();
+
+			if (get_gate_state(&gate_state, *argv)) {
+				explain_entry_format();
+				fprintf(stderr, "\"sched-entry\" is imcomplete\n");
+				free_entries(&gate_entries);
+				return -1;
+			}
+
+			if (!NEXT_ARG_OK()) {
+				explain_entry_format();
+				fprintf(stderr, "\"sched-entry\" is imcomplete\n");
+				free_entries(&gate_entries);
+				return -1;
+			}
+
+			NEXT_ARG();
+
+			if (get_u32(&interval, *argv, 0) &&
+			    get_time64(&interval_s64, *argv)) {
+				explain_entry_format();
+				fprintf(stderr, "\"sched-entry\" is imcomplete\n");
+				free_entries(&gate_entries);
+				return -1;
+			}
+
+			if (interval_s64 > UINT_MAX) {
+				fprintf(stderr, "\"interval\" is too large\n");
+				free_entries(&gate_entries);
+				return -1;
+			} else if (interval_s64) {
+				interval = interval_s64;
+			}
+
+			if (!NEXT_ARG_OK())
+				goto create_entry;
+
+			NEXT_ARG();
+
+			if (get_s32(&ipv, *argv, 0)) {
+				PREV_ARG();
+				goto create_entry;
+			}
+
+			if (!gate_state)
+				ipv = -1;
+
+			if (!NEXT_ARG_OK())
+				goto create_entry;
+
+			NEXT_ARG();
+
+			if (get_s32(&maxoctets, *argv, 0) &&
+			    get_size(&maxoctets_uint, *argv))
+				PREV_ARG();
+
+			if (maxoctets_uint > INT_MAX) {
+				fprintf(stderr, "\"maxoctets\" is too large\n");
+				free_entries(&gate_entries);
+				return -1;
+			} else if (maxoctets_uint ) {
+				maxoctets = maxoctets_uint;
+			}
+
+			if (!gate_state)
+				maxoctets = -1;
+
+create_entry:
+			e = create_gate_entry(gate_state, interval,
+					      ipv, maxoctets);
+			if (!e) {
+				fprintf(stderr, "gate: not enough memory\n");
+				free_entries(&gate_entries);
+				return -1;
+			}
+
+			list_add_tail(&e->list, &gate_entries);
+			entry_num++;
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			break;
+		}
+
+		argc--;
+		argv++;
+	}
+
+	parse_action_control_dflt(&argc, &argv, &parm.action,
+				  false, TC_ACT_PIPE);
+
+	if (!entry_num && !parm.index) {
+		fprintf(stderr, "gate: must add at least one entry\n");
+		return -1;
+	}
+
+	tail = addattr_nest(n, MAX_MSG, tca_id | NLA_F_NESTED);
+	addattr_l(n, MAX_MSG, TCA_GATE_PARMS, &parm, sizeof(parm));
+
+	if (prio != -1)
+		addattr_l(n, MAX_MSG, TCA_GATE_PRIORITY, &prio, sizeof(prio));
+
+	if (flags)
+		addattr_l(n, MAX_MSG, TCA_GATE_FLAGS, &flags, sizeof(flags));
+
+	if (base_time)
+		addattr_l(n, MAX_MSG, TCA_GATE_BASE_TIME,
+			  &base_time, sizeof(base_time));
+
+	if (cycle_time)
+		addattr_l(n, MAX_MSG, TCA_GATE_CYCLE_TIME,
+			  &cycle_time, sizeof(cycle_time));
+
+	if (cycle_time_ext)
+		addattr_l(n, MAX_MSG, TCA_GATE_CYCLE_TIME_EXT,
+			  &cycle_time_ext, sizeof(cycle_time_ext));
+
+	if (clockid != CLOCKID_INVALID)
+		addattr_l(n, MAX_MSG, TCA_GATE_CLOCKID,
+			  &clockid, sizeof(clockid));
+
+	nle = addattr_nest(n, MAX_MSG, TCA_GATE_ENTRY_LIST | NLA_F_NESTED);
+	err = add_gate_list(&gate_entries, n);
+	if (err < 0) {
+		fprintf(stderr, "Could not add entries to netlink message\n");
+		free_entries(&gate_entries);
+		return -1;
+	}
+
+	addattr_nest_end(n, nle);
+	addattr_nest_end(n, tail);
+	free_entries(&gate_entries);
+	*argc_p = argc;
+	*argv_p = argv;
+
+	return 0;
+err_arg:
+	invarg(invalidarg, *argv);
+	free_entries(&gate_entries);
+
+	return -1;
+}
+
+static int print_gate_list(struct rtattr *list)
+{
+	struct rtattr *item;
+	int rem;
+
+	rem = RTA_PAYLOAD(list);
+
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_string(PRINT_FP, NULL, "\tschedule:%s", _SL_);
+	open_json_array(PRINT_JSON, "schedule");
+
+	for (item = RTA_DATA(list);
+	     RTA_OK(item, rem);
+	     item = RTA_NEXT(item, rem)) {
+		struct rtattr *tb[TCA_GATE_ENTRY_MAX + 1];
+		__u32 index = 0, interval = 0;
+		__u8 gate_state = 0;
+		__s32 ipv = -1, maxoctets = -1;
+		char buf[22];
+
+		parse_rtattr_nested(tb, TCA_GATE_ENTRY_MAX, item);
+
+		if (tb[TCA_GATE_ENTRY_INDEX])
+			index = rta_getattr_u32(tb[TCA_GATE_ENTRY_INDEX]);
+
+		if (tb[TCA_GATE_ENTRY_GATE])
+			gate_state = 1;
+
+		if (tb[TCA_GATE_ENTRY_INTERVAL])
+			interval = rta_getattr_u32(tb[TCA_GATE_ENTRY_INTERVAL]);
+
+		if (tb[TCA_GATE_ENTRY_IPV])
+			ipv = rta_getattr_s32(tb[TCA_GATE_ENTRY_IPV]);
+
+		if (tb[TCA_GATE_ENTRY_MAX_OCTETS])
+			maxoctets = rta_getattr_s32(tb[TCA_GATE_ENTRY_MAX_OCTETS]);
+
+		open_json_object(NULL);
+		print_uint(PRINT_ANY, "number", "\t number %4u", index);
+		print_string(PRINT_ANY, "gate_state", "\tgate-state %s ",
+			     gate_state ? "open" : "close");
+
+		print_uint(PRINT_JSON, "interval", NULL, interval);
+
+		memset(buf, 0, sizeof(buf));
+		print_string(PRINT_FP, NULL, "\tinterval %s",
+			     sprint_time64(interval, buf));
+
+		if (ipv != -1) {
+			print_uint(PRINT_ANY, "ipv", "\t ipv %-10u", ipv);
+		} else {
+			print_int(PRINT_JSON, "ipv", NULL, ipv);
+			print_string(PRINT_FP, NULL, "\t ipv %s", "wildcard");
+		}
+
+		if (maxoctets != -1) {
+			memset(buf, 0, sizeof(buf));
+			print_uint(PRINT_JSON, "max_octets", NULL, maxoctets);
+			print_string(PRINT_FP, NULL, "\t max-octets %s",
+				     sprint_size(maxoctets, buf));
+		} else {
+			print_string(PRINT_FP, NULL,
+				     "\t max-octets %s", "wildcard");
+			print_int(PRINT_JSON, "max_octets", NULL, maxoctets);
+		}
+
+		close_json_object();
+		print_string(PRINT_FP, NULL, "%s", _SL_);
+	}
+
+	close_json_array(PRINT_ANY, "");
+
+	return 0;
+}
+
+static int print_gate(struct action_util *au, FILE *f, struct rtattr *arg)
+{
+	struct tc_gate *parm;
+	struct rtattr *tb[TCA_GATE_MAX + 1];
+	__s32 clockid = CLOCKID_INVALID;
+	__s64 base_time = 0;
+	__s64 cycle_time = 0;
+	__s64 cycle_time_ext = 0;
+	char buf[22];
+	int prio = -1;
+
+	if (arg == NULL)
+		return -1;
+
+	parse_rtattr_nested(tb, TCA_GATE_MAX, arg);
+
+	if (!tb[TCA_GATE_PARMS]) {
+		fprintf(stderr, "Missing gate parameters\n");
+		return -1;
+	}
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+
+	parm = RTA_DATA(tb[TCA_GATE_PARMS]);
+
+	if (tb[TCA_GATE_PRIORITY])
+		prio = rta_getattr_s32(tb[TCA_GATE_PRIORITY]);
+
+	if (prio != -1) {
+		print_int(PRINT_ANY, "priority", "\tpriority %-8d", prio);
+	} else {
+		print_string(PRINT_FP, NULL, "\tpriority %s", "wildcard");
+		print_int(PRINT_JSON, "priority", NULL, prio);
+	}
+
+	if (tb[TCA_GATE_CLOCKID])
+		clockid = rta_getattr_s32(tb[TCA_GATE_CLOCKID]);
+	print_string(PRINT_ANY, "clockid", "\tclockid %s",
+		     get_clock_name(clockid));
+
+	if (tb[TCA_GATE_FLAGS]) {
+		__u32 flags;
+
+		flags = rta_getattr_u32(tb[TCA_GATE_FLAGS]);
+		print_0xhex(PRINT_ANY, "flags", "\tflags %#x", flags);
+	}
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+
+	if (tb[TCA_GATE_BASE_TIME])
+		base_time = rta_getattr_s64(tb[TCA_GATE_BASE_TIME]);
+
+	memset(buf, 0, sizeof(buf));
+	print_string(PRINT_FP, NULL, "\tbase-time %s",
+		     sprint_time64(base_time, buf));
+	print_lluint(PRINT_JSON, "base_time", NULL, base_time);
+
+	if (tb[TCA_GATE_CYCLE_TIME])
+		cycle_time = rta_getattr_s64(tb[TCA_GATE_CYCLE_TIME]);
+
+	memset(buf, 0, sizeof(buf));
+	print_string(PRINT_FP, NULL,
+		     "\tcycle-time %s", sprint_time64(cycle_time, buf));
+	print_lluint(PRINT_JSON, "cycle_time", NULL, cycle_time);
+
+	if (tb[TCA_GATE_CYCLE_TIME_EXT])
+		cycle_time_ext = rta_getattr_s64(tb[TCA_GATE_CYCLE_TIME_EXT]);
+
+	memset(buf, 0, sizeof(buf));
+	print_string(PRINT_FP, NULL, "\tcycle-time-ext %s",
+		     sprint_time64(cycle_time_ext, buf));
+	print_lluint(PRINT_JSON, "cycle_time_ext", NULL, cycle_time_ext);
+
+	if (tb[TCA_GATE_ENTRY_LIST])
+		print_gate_list(tb[TCA_GATE_ENTRY_LIST]);
+
+	print_action_control(f, "\t", parm->action, "");
+
+	print_uint(PRINT_ANY, "index", "\n\t index %u", parm->index);
+	print_int(PRINT_ANY, "ref", " ref %d", parm->refcnt);
+	print_int(PRINT_ANY, "bind", " bind %d", parm->bindcnt);
+
+	if (show_stats) {
+		if (tb[TCA_GATE_TM]) {
+			struct tcf_t *tm = RTA_DATA(tb[TCA_GATE_TM]);
+
+			print_tm(f, tm);
+		}
+	}
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+
+	return 0;
+}
-- 
2.17.1

