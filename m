Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B531C6C57
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgEFJBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:01:08 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:11519
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728885AbgEFJBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 05:01:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXghBny6xPonm3jrBUDUgpc24zFyoczq+PzSex6NTBXPv3H38wIMlyM22aelsb1C4dCZsXpgpJFyM5eXUvtN6ar+vPDGfmvhZGC5bj2D9ffmZozv+GCMP8MAqnSHVCwFmzd+m8WGdpCGN+prHv0i7wqz1f+SmHTvlNxy98XFAxCGyxZb+sDBBTQ4ltOrT9VfmHoCzcLbN37sUowZwA8i/vTpfmFjp35ZJxIEOPwhdCMD010QgY6eeqNkfhPQpxqbf57aE+Uol1HiSoeCs7bJSLrM4EicO5nswz+7PAAMna54AhZcEH9T/IV0yeZR4R7yNYSNC5kF1E1QOx2zlabJvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijqeUoyjex+K59Y3gjb4AY9b1gHjEpMA0UgadWk+CmM=;
 b=blDEDkOphHgNwPuh1AP6MGcxZG+yFFXsxkMAiq0zxy9CpGJVnRxI42hgj6g7972QXFpTXFG1HXExxb7c4BRZ5cYn+gaagJ1Ty4qFQ+Xhpeu5nEwdGYqN0ZNfqtg3hyP29kWxxANWuf1f3qWjzaf5sJGM1ttCjBiPZGLcgnB7C44/buVR/rL3V/B8dJNtgdmk4WqVd06fO6XuJoqLe1G19xT2Y5HO7KPZWCN0KdRrBHOcHMK67ojZhbmbenhSlgCSQW3nAvVVXw6MnDbkbfNT4QWhhbm4Pq62i7FTgAispUCoL0acmjrRS/PgrlqSrgezJUA+ym/SbGZqJJc2x1u1gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijqeUoyjex+K59Y3gjb4AY9b1gHjEpMA0UgadWk+CmM=;
 b=rizWcWMduhPWw4G0CoU0hnNq4b0cbpe4haAGw2pt+lVQnbmJ7XNcP66J5WSnhaT75eNoVqgfhmwiQhEfNy1f94/QT4dB26/frBWgfnR/VnDOQT1U0KG6CVKyvOq83tRIG5IfsfVDwoX4Fk4jKqY4w6z/SM0Bo+EHLeplNGv5Ryw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6464.eurprd04.prod.outlook.com (2603:10a6:803:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 6 May
 2020 09:00:59 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 09:00:59 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, stephen@networkplumber.org,
        davem@davemloft.net, vlad@buslov.dev, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, Po Liu <Po.Liu@nxp.com>
Subject: [v4,iproute2-next 1/2] iproute2-next:tc:action: add a gate control action
Date:   Wed,  6 May 2020 16:40:19 +0800
Message-Id: <20200506084020.18106-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503063251.10915-2-Po.Liu@nxp.com>
References: <20200503063251.10915-2-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0010.apcprd04.prod.outlook.com
 (2603:1096:3:1::20) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR0401CA0010.apcprd04.prod.outlook.com (2603:1096:3:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 09:00:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a2533b34-7a01-4007-3756-08d7f19bfeb4
X-MS-TrafficTypeDiagnostic: VE1PR04MB6464:|VE1PR04MB6464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6464D0191E7D0C5BEC01C18392A40@VE1PR04MB6464.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hEMf0IzYPtwjg2NKggvB6lDd80g3947/TQys9EzUVCDACPY8v7fhtJ6ostWzJnsrP9MEy1xFJ5/gBNiVXIW6rTmNpsxu4dXEBLW73fB5IhmlMM0yV7b/WUB3nLDuhxvhDCpx5hvSOXIWd7Kggxfb7HBJ+wdC1+V2mx/AhZ33WcXUFW4je6eQOWzs3rAeFxjbKscYhuDYdjjFXBvWxEboB93J0bhN+fmrtluTN+73aNtXYxT3SlccP9wnMHWeUiK5jCGolpr+uOVl1YhkTcE0GNOAC0bfO8ClJQqoVPwUPMld6TBdJmO95EhRHmzu2OwDIpu9faLahukQKlMc8eI5Lcisn0U90J+fztXtLpbeiFQ85XBMlm2l6ZkdFYjbt5d1rJGSooAU+5yZjSJhNWSP4VQo1Gj+fYwyKO1JUwgaImifsrl2/FRunYDQDmAhTg31+mh+5AhTxqeBKzKa7YOAPX+vb7h27mDEqLraaMRw4WwEPzZpfml8AqvkoHiM19RWacyZyLgJmiK0CIqFP8iXfS+93wjW9M93wKM26QRLUurmWgacPjqHRroT6ILiRVIT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(33430700001)(66556008)(66476007)(69590400007)(6506007)(26005)(16526019)(186003)(66946007)(6486002)(30864003)(4326008)(6512007)(86362001)(52116002)(5660300002)(316002)(33440700001)(8676002)(2906002)(6666004)(1076003)(8936002)(36756003)(2616005)(956004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gx1nX9OkwUb5wl1u3+Q+cBbUtLxOqbvFiZkGJxsuQFw0nzp2vJhMj811dDTDzXVDPt+0gunwgnUL8pokvxcCa5IkOsJ42p8fJZ3svmwLg25O8IyfsuObqEpsqQ3MrM8pT1783ov5K8HiSC3mxLogwVfW/oDqgu3ICBWungNc4cLn2XigUDbECl0cXWzuNiTCpWSOw/U/ZTtldqvSmKqjFaYgonFY2AVn27E86ua9vBZA0kSKTPE8bRD5LvCgclBTqBdfm/UdOrQqtJMp9gGW0U3WeAUddWAdTsewKlunwU5onmeOaBjnqDm9WxdF38Y8zHj7HB9LT2E71fAweBtVrygtYQ7mFmyHdE3TIKlk8ysYrmsaBvQ844v5b9e9kJ/k9dwFuVSceGWcV6TxwbvVbc8wcBaezeIKDn4NJAAgEEkG6XUPnOK3OrBrfXufpw42SSmKYFzQgGhZLXNHeWJvu+9b36Q0hKw4QgT2+v0ZdaXlC5UobiZ7BO3KdOtGVwu1AM7tpuOMG1asK8n9CLCbgaEHU2kliEvn1GZ65GsT5H4X9+vzRWDkvhv3x3eycdozpr2AkJmUWM8xZ990U56KdICHNesGndkJPtiPV+GvV8HoaUtT8FkBKbKsorHwNe/Whr1TAtt5q3V89Jb7GNefIJs0TfPUR4QTxxuEXe3BDt5/Z3hQ5E3PSz/hIRZysoOqWRJIfcIH09XA/HHl29R4FVpGqU0ENJ53wWcfycLPlNoaZW3q4tXkTgVbyxvYF1Nb1aGMfD532RTdSlJSiZ6tCGVrbwU23kZuom5Ieea+vPE=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2533b34-7a01-4007-3756-08d7f19bfeb4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 09:00:59.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QlfmUBQkE3ai482ep74qZZNZUNTbmluabr8WS9a3wGMmzi5zzsMxFBGlb6OydtRm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6464
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
            sched-entry open 200000000 -1 -1 \
            sched-entry close 100000000

 # tc chain del dev eth0 ingress chain 0

"sched-entry" follow the name taprio style. Gate state is
"open"/"close". Follow the period nanosecond. Then next -1 is internal
priority value means which ingress queue should put to. "-1" means
wildcard. The last value optional specifies the maximum number of
MSDU octets that are permitted to pass the gate during the specified
time interval.

Below example shows filtering a stream with destination mac address is
10:00:80:00:00:00 and ip type is ICMP, follow the action gate. The gate
action would run with one close time slot which means always keep close.
The time cycle is total 200000000ns. The base-time would calculate by:

     1357000000000 + (N + 1) * cycletime

When the total value is the future time, it will be the start time.
The cycletime here would be 200000000ns for this case.

 #tc filter add dev eth0 parent ffff:  protocol ip \
           flower skip_hw ip_proto icmp dst_mac 10:00:80:00:00:00 \
           action gate index 12 base-time 1357000000000 \
           sched-entry CLOSE 200000000 \
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


 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_gate.h |  47 +++
 tc/Makefile                         |   1 +
 tc/m_gate.c                         | 556 ++++++++++++++++++++++++++++
 4 files changed, 605 insertions(+)
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
index 00000000..15d9995b
--- /dev/null
+++ b/tc/m_gate.c
@@ -0,0 +1,556 @@
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
+	__u64 base_time = 0;
+	__u64 cycle_time = 0;
+	__u64 cycle_time_ext = 0;
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
+			if (get_u64(&base_time, *argv, 10)) {
+				invalidarg = "base-time";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "cycle-time") == 0) {
+			NEXT_ARG();
+			if (get_u64(&cycle_time, *argv, 10)) {
+				invalidarg = "cycle-time";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "cycle-time-ext") == 0) {
+			NEXT_ARG();
+			if (get_u64(&cycle_time_ext, *argv, 10)) {
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
+			struct gate_entry *e;
+			uint8_t gate_state = 0;
+			uint32_t interval = 0;
+			int32_t ipv = -1;
+			int32_t maxoctets = -1;
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
+			if (get_u32(&interval, *argv, 0)) {
+				explain_entry_format();
+				fprintf(stderr, "\"sched-entry\" is imcomplete\n");
+				free_entries(&gate_entries);
+				return -1;
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
+			if (get_s32(&maxoctets, *argv, 0))
+				PREV_ARG();
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
+
+		} else if (matches(*argv, "reclassify") == 0 ||
+			   matches(*argv, "drop") == 0 ||
+			   matches(*argv, "shot") == 0 ||
+			   matches(*argv, "continue") == 0 ||
+			   matches(*argv, "pass") == 0 ||
+			   matches(*argv, "ok") == 0 ||
+			   matches(*argv, "pipe") == 0 ||
+			   matches(*argv, "goto") == 0) {
+			if (parse_action_control(&argc, &argv,
+						 &parm.action, false)) {
+				free_entries(&gate_entries);
+				return -1;
+			}
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
+		print_string(PRINT_ANY, "gate_state", "\tgate-state %-8s",
+			     gate_state ? "open" : "close");
+
+		print_uint(PRINT_ANY, "interval", "\tinterval %-16u", interval);
+
+		if (ipv != -1) {
+			print_uint(PRINT_ANY, "ipv", "\tipv %-8u", ipv);
+		} else {
+			print_int(PRINT_JSON, "ipv", NULL, ipv);
+			print_string(PRINT_FP, NULL, "\tipv %s", "wildcard");
+		}
+
+		if (maxoctets != -1) {
+			print_uint(PRINT_ANY, "max_octets",
+				   "\tmax-octets %-8u", maxoctets);
+		} else {
+			print_string(PRINT_FP, NULL,
+				     "\tmax-octets %s", "wildcard");
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
+	__u64 base_time = 0;
+	__u64 cycle_time = 0;
+	__u64 cycle_time_ext = 0;
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
+		base_time = rta_getattr_u64(tb[TCA_GATE_BASE_TIME]);
+
+	print_lluint(PRINT_ANY, "base_time", "\tbase-time %-22lld", base_time);
+
+	if (tb[TCA_GATE_CYCLE_TIME])
+		cycle_time = rta_getattr_u64(tb[TCA_GATE_CYCLE_TIME]);
+
+	print_lluint(PRINT_ANY, "cycle_time",
+		     "\tcycle-time %-16lld", cycle_time);
+
+	if (tb[TCA_GATE_CYCLE_TIME_EXT])
+		cycle_time = rta_getattr_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);
+
+	print_lluint(PRINT_ANY, "cycle_time_ext", "\tcycle-time-ext %-16lld",
+		     cycle_time_ext);
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

