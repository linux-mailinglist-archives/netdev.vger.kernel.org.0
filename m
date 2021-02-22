Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCD63215B8
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhBVMFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhBVMEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:04:55 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62716C061574
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:04:11 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id q10so21556257edt.7
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g6k4oh2zRkP1eRJK0kXmJZSNZ1I0mop156pboPuP/sY=;
        b=lwHknCv7dkgMaLDWGlupl5+2BL3sC2+65c+yGTO7g0XokJfVqvVDv3KNTzz72IpLaW
         leAdwdh2C/43ejA1LLalOItqSxGJ55/MSEb9RNDmv0kLoaQsCPrqggiWmMtK66xuigac
         KLFjizv1HTJX3RhZwvOIqNJH7IybMqEPiPlYBbnjfQzzr24Y2K4vwhzc+Ex4xoBP1GHZ
         oMzJ+KNIuEikH158+cZ643qK1lBMYrgPUiwRY3fdMMyaBerJ0M81m5lxam4himKSNhl7
         /qoOXCUkdSZH+cx/bw7s33JyJ/PYwo/wAaWiTaFp17zNsiB18w9YmfgZZpYXreDcRcZA
         t+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g6k4oh2zRkP1eRJK0kXmJZSNZ1I0mop156pboPuP/sY=;
        b=jG35cFHg4s3nxQxnQL2UL9mLKcRZB2VnLGrB81Rnqh0SU+EQYR06Ecx9lusIhCK/dO
         t7YqoEA9llbvqWJjq1b1V3h7HqooJQMdwikanjRXxSVpTtvu5R3qHn2EyNf3oa67o4sn
         Y2iYW0Rkh/d95ShRnkgdLo9mXfcUPprMjK5yi4P7VLDQHVJ52PBTkW9a7hwewYNenqGY
         43uKh0pE42Pzc0CKxN1kirlW3SLXSYoQapVzktG/CgHvCD2E72P5lwY2Q2QBk+B1gr6w
         HQSy2C73IqeO4fLpiWWZhq5Xe64JlVYtd3x3qdlDVr2b58uuLumhv07HVSL9JMumS0PO
         HfJQ==
X-Gm-Message-State: AOAM530+9wnVSqXBnXx/3m6GZNSkdEkrPmUosUS9IYRB0zmyLr8Lwj4g
        ndQwohcF+26BBcykrHdBKniokkEembw=
X-Google-Smtp-Source: ABdhPJzgHFXeETrmrlDigeP/1acsoisn6ET7WYkRerSR2ZjUPOdL0We1YIyujhfC5PfCVnKLiODzow==
X-Received: by 2002:aa7:c586:: with SMTP id g6mr21313182edq.203.1613995449803;
        Mon, 22 Feb 2021 04:04:09 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id t8sm1661309ejr.71.2021.02.22.04.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:04:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Marek Behun <marek.behun@nic.cz>
Subject: [RFC PATCH net-next] selftests: net: dsa: add a test for ports matching on notifiers
Date:   Mon, 22 Feb 2021 14:02:48 +0200
Message-Id: <20210222120248.1415075-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA supports cross-chip setups, and this means that when an operation is
performed on a port, the other switches in the fabric are also notified,
to get a chance to implement something similar which might be needed
when sending/receiving a packet to/from that port.

However we find that the DSA notifier match functions are written up
pretty much randomly, so let's add a test that is easy to run even
without cross-chip hardware, in order to better visualize the ports on
which the notifier will match.

[.../selftests/net/dsa] $ make
gcc     test_dsa_notifier_match.c  -o test_dsa_notifier_match
[.../selftests/net/dsa] $ ./test_dsa_notifier_match
Heat map for test notifier emitted on sw2p1:

   sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
[  cpu  ] [  user ] [  user ] [  user ] [  dsa  ]
[   x   ] [       ] [       ] [       ] [   x   ]

   sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
[  user ] [  user ] [  user ] [  user ] [  dsa  ]
[       ] [       ] [       ] [       ] [   x   ]

   sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
[  user ] [  user ] [  user ] [  user ] [  dsa  ]
[       ] [   x   ] [       ] [       ] [       ]

Heat map for test notifier emitted on sw0p0:

   sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
[  cpu  ] [  user ] [  user ] [  user ] [  dsa  ]
[   x   ] [       ] [       ] [       ] [       ]

   sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
[  user ] [  user ] [  user ] [  user ] [  dsa  ]
[       ] [       ] [       ] [       ] [   x   ]

   sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
[  user ] [  user ] [  user ] [  user ] [  dsa  ]
[       ] [       ] [       ] [       ] [   x   ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/net/dsa/Makefile      |   6 +
 .../net/dsa/test_dsa_notifier_match.c         | 446 ++++++++++++++++++
 3 files changed, 453 insertions(+)
 create mode 100644 tools/testing/selftests/net/dsa/Makefile
 create mode 100644 tools/testing/selftests/net/dsa/test_dsa_notifier_match.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 986a8eef8633..0b501750065a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12397,6 +12397,7 @@ F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
 F:	include/net/dsa.h
 F:	net/dsa/
+F:	tools/testing/selftests/net/dsa/
 
 NETWORKING [GENERAL]
 M:	"David S. Miller" <davem@davemloft.net>
diff --git a/tools/testing/selftests/net/dsa/Makefile b/tools/testing/selftests/net/dsa/Makefile
new file mode 100644
index 000000000000..650d99bd6dab
--- /dev/null
+++ b/tools/testing/selftests/net/dsa/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TEST_PROGS := test_dsa_notifier_match
+TEST_GEN_FILES := test_dsa_notifier_match
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/net/dsa/test_dsa_notifier_match.c b/tools/testing/selftests/net/dsa/test_dsa_notifier_match.c
new file mode 100644
index 000000000000..8118e97c6294
--- /dev/null
+++ b/tools/testing/selftests/net/dsa/test_dsa_notifier_match.c
@@ -0,0 +1,446 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (c) 2008-2009 Marvell Semiconductor
+ * Copyright (c) 2013 Florian Fainelli <florian@openwrt.org>
+ * Copyright (c) 2016 Andrew Lunn <andrew@lunn.ch>
+ * Copyright (c) 2017 Savoir-faire Linux Inc.
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ * Copyright (c) 2021 Vladimir Oltean <vladimir.oltean@nxp.com>
+ */
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/queue.h>
+
+struct dsa_port {
+	enum {
+		DSA_PORT_TYPE_UNUSED = 0,
+		DSA_PORT_TYPE_CPU,
+		DSA_PORT_TYPE_DSA,
+		DSA_PORT_TYPE_USER,
+	} type;
+
+	struct dsa_switch	*ds;
+	unsigned int		index;
+	struct dsa_port		*cpu_dp;
+
+	STAILQ_ENTRY(dsa_port)	list;
+};
+
+/* TODO: ideally DSA ports would have a single dp->link_dp member,
+ * and no dst->rtable nor this struct dsa_link would be needed,
+ * but this would require some more complex tree walking,
+ * so keep it stupid at the moment and list them all.
+ */
+struct dsa_link {
+	struct dsa_port		*dp;
+	struct dsa_port		*link_dp;
+	STAILQ_ENTRY(dsa_link)	list;
+};
+
+struct dsa_switch_tree {
+	/* List of switch ports */
+	STAILQ_HEAD(ports_head, dsa_port) ports;
+
+	/* List of switches (for notifiers) */
+	STAILQ_HEAD(switches_head, dsa_switch) switches;
+
+	/* List of DSA links composing the routing table */
+	STAILQ_HEAD(rtable_head, dsa_link) rtable;
+};
+
+struct dsa_switch {
+	/*
+	 * Parent switch tree, and switch index.
+	 */
+	struct dsa_switch_tree		*dst;
+	unsigned int			index;
+
+	STAILQ_ENTRY(dsa_switch)	list;
+
+	bool				*heat_map;
+
+	size_t				num_ports;
+};
+
+static const char dsa_port_type[][16] = {
+	[DSA_PORT_TYPE_UNUSED]	= "unused ",
+	[DSA_PORT_TYPE_CPU]	= "  cpu  ",
+	[DSA_PORT_TYPE_DSA]	= "  dsa  ",
+	[DSA_PORT_TYPE_USER]	= "  user ",
+};
+
+static struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp;
+
+	STAILQ_FOREACH(dp, &dst->ports, list)
+		if (dp->ds == ds && dp->index == p)
+			return dp;
+
+	return NULL;
+}
+
+static bool dsa_is_unused_port(struct dsa_switch *ds, int p)
+{
+	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_UNUSED;
+}
+
+static bool dsa_is_cpu_port(struct dsa_switch *ds, int p)
+{
+	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_CPU;
+}
+
+static bool dsa_is_dsa_port(struct dsa_switch *ds, int p)
+{
+	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_DSA;
+}
+
+static bool dsa_is_user_port(struct dsa_switch *ds, int p)
+{
+	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_USER;
+}
+
+static int dsa_register_switch(struct dsa_switch_tree *dst, int index,
+			       int num_ports)
+{
+	struct dsa_switch *ds;
+	struct dsa_port *dp;
+	int err, port;
+
+	ds = calloc(1, sizeof(*ds));
+	if (!ds)
+		return -ENOMEM;
+
+	ds->heat_map = calloc(num_ports, sizeof(bool));
+	if (!ds->heat_map) {
+		free(ds);
+		return -ENOMEM;
+	}
+
+	ds->num_ports = num_ports;
+	ds->index = index;
+	ds->dst = dst;
+
+	for (port = 0; port < num_ports; port++) {
+		dp = calloc(1, sizeof(*dp));
+		if (!dp) {
+			err = -ENOMEM;
+			goto out_free_ports;
+		}
+
+		dp->ds = ds;
+		dp->index = port;
+		STAILQ_INSERT_TAIL(&dst->ports, dp, list);
+	}
+
+	STAILQ_INSERT_TAIL(&dst->switches, ds, list);
+
+	return 0;
+
+out_free_ports:
+	while ((dp = STAILQ_FIRST(&dst->ports))) {
+		STAILQ_REMOVE_HEAD(&dst->ports, list);
+		free(dp);
+	}
+
+	free(ds);
+	return err;
+}
+
+static void dsa_tree_teardown(struct dsa_switch_tree *dst)
+{
+	struct dsa_switch *ds;
+	struct dsa_port *dp;
+	struct dsa_link *dl;
+
+	while (dl = STAILQ_FIRST(&dst->rtable)) {
+		STAILQ_REMOVE_HEAD(&dst->rtable, list);
+		free(dl);
+	}
+
+	while (dp = STAILQ_FIRST(&dst->ports)) {
+		STAILQ_REMOVE_HEAD(&dst->ports, list);
+		free(dp);
+	}
+
+	while (ds = STAILQ_FIRST(&dst->switches)) {
+		STAILQ_REMOVE_HEAD(&dst->switches, list);
+		free(ds->heat_map);
+		free(ds);
+	}
+}
+
+static struct dsa_port *dsa_tree_find_port_by_index(struct dsa_switch_tree *dst,
+						    int sw_index, int port)
+{
+	struct dsa_port *dp;
+
+	STAILQ_FOREACH(dp, &dst->ports, list)
+		if (dp->ds->index == sw_index && dp->index == port)
+			return dp;
+
+	return NULL;
+}
+
+static int dsa_setup_link(struct dsa_switch_tree *dst, int from_sw_index,
+			  int from_port, int to_sw_index, int to_port)
+{
+	struct dsa_port *dp, *link_dp;
+	struct dsa_link *dl;
+
+	dp = dsa_tree_find_port_by_index(dst, from_sw_index, from_port);
+	if (!dp) {
+		fprintf(stderr, "failed to find sw%dp%d\n", from_sw_index,
+			from_port);
+		return -ENODEV;
+	}
+
+	link_dp = dsa_tree_find_port_by_index(dst, to_sw_index, to_port);
+	if (!link_dp) {
+		fprintf(stderr, "failed to find sw%dp%d\n", to_sw_index,
+			to_port);
+		return -ENODEV;
+	}
+
+	dl = calloc(1, sizeof(*dl));
+	if (!dl)
+		return -ENOMEM;
+
+	STAILQ_INSERT_HEAD(&dst->rtable, dl, list);
+	dp->type = DSA_PORT_TYPE_DSA;
+	link_dp->type = DSA_PORT_TYPE_DSA;
+
+	return 0;
+}
+
+static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst,
+				      int sw_index, int port)
+{
+	struct dsa_port *dp, *cpu_dp;
+
+	cpu_dp = dsa_tree_find_port_by_index(dst, sw_index, port);
+	if (!cpu_dp) {
+		fprintf(stderr, "failed to find sw%dp%d\n", sw_index, port);
+		return -ENODEV;
+	}
+
+	cpu_dp->type = DSA_PORT_TYPE_CPU;
+
+	STAILQ_FOREACH(dp, &dst->ports, list)
+		if (dsa_is_user_port(dp->ds, dp->index) ||
+		    dsa_is_dsa_port(dp->ds, dp->index))
+			dp->cpu_dp = cpu_dp;
+
+	return 0;
+}
+
+static void
+dsa_tree_convert_all_unused_ports_to_user(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	STAILQ_FOREACH(dp, &dst->ports, list)
+		if (dsa_is_unused_port(dp->ds, dp->index))
+			dp->type = DSA_PORT_TYPE_USER;
+}
+
+/*  CPU
+ *   |
+ * sw0p0 sw0p1 sw0p2 sw0p3 sw0p4
+ *                           | DSA link
+ * sw1p0 sw1p1 sw1p2 sw1p3 sw1p4
+ *                           | DSA link
+ * sw2p0 sw2p1 sw2p2 sw2p3 sw2p4
+ */
+static int dsa_setup_tree(struct dsa_switch_tree *dst)
+{
+	int err;
+
+	STAILQ_INIT(&dst->ports);
+	STAILQ_INIT(&dst->switches);
+	STAILQ_INIT(&dst->rtable);
+
+	err = dsa_register_switch(dst, 0, 5);
+	if (err)
+		return err;
+
+	err = dsa_register_switch(dst, 1, 5);
+	if (err)
+		return err;
+
+	err = dsa_register_switch(dst, 2, 5);
+	if (err)
+		return err;
+
+	/* sw0p4 to sw1p4 */
+	err = dsa_setup_link(dst, 0, 4, 1, 4);
+	if (err)
+		return err;
+
+	/* sw0p4 to sw2p4 */
+	err = dsa_setup_link(dst, 0, 4, 2, 4);
+	if (err)
+		return err;
+
+	/* sw1p4 to sw0p4 */
+	err = dsa_setup_link(dst, 1, 4, 0, 4);
+	if (err)
+		return err;
+
+	/* sw1p4 to sw2p4 */
+	err = dsa_setup_link(dst, 1, 4, 2, 4);
+	if (err)
+		return err;
+
+	/* sw2p4 to sw0p4 */
+	err = dsa_setup_link(dst, 2, 4, 0, 4);
+	if (err)
+		return err;
+
+	/* sw2p4 to sw1p4 */
+	err = dsa_setup_link(dst, 2, 4, 1, 4);
+	if (err)
+		return err;
+
+	dsa_tree_convert_all_unused_ports_to_user(dst);
+
+	err = dsa_tree_setup_default_cpu(dst, 0, 0);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+enum {
+	DSA_NOTIFIER_TEST,
+};
+
+struct dsa_notifier_test_info {
+	int sw_index;
+	int port;
+};
+
+static int dsa_switch_test_match(struct dsa_switch *ds, int port,
+				 struct dsa_notifier_test_info *info)
+{
+	if (ds->index == info->sw_index)
+		return port == info->port;
+
+	return dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port);
+}
+
+static int dsa_switch_test(struct dsa_switch *ds,
+			   struct dsa_notifier_test_info *info)
+{
+	int port;
+
+	for (port = 0; port < ds->num_ports; port++)
+		if (dsa_switch_test_match(ds, port, info))
+			ds->heat_map[port] = true;
+
+	return 0;
+}
+
+static int dsa_switch_event(struct dsa_switch *ds, unsigned long event,
+			    void *info)
+{
+	int err;
+
+	switch (event) {
+	case DSA_NOTIFIER_TEST:
+		err = dsa_switch_test(ds, info);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
+{
+	struct dsa_switch *ds;
+	int err;
+
+	STAILQ_FOREACH(ds, &dst->switches, list) {
+		err = dsa_switch_event(ds, e, v);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
+{
+	return dsa_tree_notify(dp->ds->dst, e, v);
+}
+
+static int dsa_test_notify(struct dsa_switch_tree *dst, int sw_index, int port)
+{
+	struct dsa_notifier_test_info info = {
+		.sw_index = sw_index,
+		.port = port,
+	};
+	struct dsa_switch *ds;
+	struct dsa_port *dp;
+	int err;
+
+	dp = dsa_tree_find_port_by_index(dst, sw_index, port);
+	if (!dp) {
+		fprintf(stderr, "failed to find sw%dp%d\n", sw_index, port);
+		return -ENODEV;
+	}
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_TEST, &info);
+	if (err)
+		return err;
+
+	printf("Heat map for test notifier emitted on sw%dp%d:\n\n",
+	       sw_index, port);
+
+	STAILQ_FOREACH(ds, &dst->switches, list) {
+		for (port = 0; port < ds->num_ports; port++)
+			printf("   sw%dp%d  ", ds->index, port);
+		printf("\n");
+		for (port = 0; port < ds->num_ports; port++)
+			printf("[%s] ", dsa_port_type[dsa_to_port(ds, port)->type]);
+		printf("\n");
+		for (port = 0; port < ds->num_ports; port++) {
+			if (ds->heat_map[port])
+				printf("[   x   ] ");
+			else
+				printf("[       ] ");
+		}
+		printf("\n\n");
+		memset(ds->heat_map, 0, sizeof(bool) * ds->num_ports);
+	}
+}
+
+int main(void)
+{
+	struct dsa_switch_tree dst = {0};
+	struct dsa_port *dp;
+	int err;
+
+	err = dsa_setup_tree(&dst);
+	if (err)
+		goto out;
+
+	err = dsa_test_notify(&dst, 2, 1);
+	if (err)
+		goto out;
+
+	err = dsa_test_notify(&dst, 0, 0);
+	if (err)
+		goto out;
+
+out:
+	dsa_tree_teardown(&dst);
+
+	return err;
+}
-- 
2.25.1

