Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B099BAF2
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 04:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfHXCnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 22:43:05 -0400
Received: from mail.nic.cz ([217.31.204.67]:37268 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfHXCnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 22:43:03 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 94D1E140D1E;
        Sat, 24 Aug 2019 04:42:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566614579; bh=jPa21EsnWy9WksW68HSx/O+la2qm4ImIACY+K2cEnLY=;
        h=From:To:Date;
        b=Kl8qU9MxZdC3EQnTetDA7VbGXYIuwCO2zS6HinOo7XykIKQDlvB7jIUcH0FQLgG6T
         BNf/aIsDASIL1PBSAlNynoTMSDf8m6I2Xo8auxQr4L6sslF683w8hY9PN7f+pYyL2R
         FQs93FIJYSp5I2NCSktTxGFNumTvYPxA8lEqBaZo=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC net-next 1/3] net: dsa: allow for multiple CPU ports
Date:   Sat, 24 Aug 2019 04:42:48 +0200
Message-Id: <20190824024251.4542-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190824024251.4542-1-marek.behun@nic.cz>
References: <20190824024251.4542-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow for multiple CPU ports in a DSA switch tree. By default assign the
CPU ports to user ports in a round robin way, ie. if there are two CPU
ports connected to eth0 and eth1, and five user ports (lan1..lan5),
assign them as:
  lan1 <-> eth0
  lan2 <-> eth1
  lan3 <-> eth0
  lan4 <-> eth1
  lan5 <-> eth0

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 include/net/dsa.h |  5 +--
 net/dsa/dsa2.c    | 84 +++++++++++++++++++++++++++++++----------------
 2 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 147b757ef8ea..64bd70608f2f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -123,9 +123,10 @@ struct dsa_switch_tree {
 	struct dsa_platform_data	*pd;
 
 	/*
-	 * The switch port to which the CPU is attached.
+	 * The switch ports to which the CPU is attached.
 	 */
-	struct dsa_port		*cpu_dp;
+	size_t			num_cpu_dps;
+	struct dsa_port		*cpu_dps[DSA_MAX_PORTS];
 
 	/*
 	 * Data for the individual switch chips.
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8c4eccb0cfe6..c5af89079a6b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -194,11 +194,12 @@ static bool dsa_tree_setup_routing_table(struct dsa_switch_tree *dst)
 	return complete;
 }
 
-static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
+static void dsa_tree_fill_cpu_ports(struct dsa_switch_tree *dst)
 {
 	struct dsa_switch *ds;
 	struct dsa_port *dp;
 	int device, port;
+	int count = 0;
 
 	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
 		ds = dst->ds[device];
@@ -208,28 +209,38 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 		for (port = 0; port < ds->num_ports; port++) {
 			dp = &ds->ports[port];
 
-			if (dsa_port_is_cpu(dp))
-				return dp;
+			if (dsa_port_is_cpu(dp)) {
+				if (count == ARRAY_SIZE(dst->cpu_dps)) {
+					pr_warn("Tree has too many CPU ports\n");
+					dst->num_cpu_dps = count;
+					return;
+				}
+
+				dst->cpu_dps[count++] = dp;
+			}
 		}
 	}
 
-	return NULL;
+	dst->num_cpu_dps = count;
 }
 
-static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
+static int dsa_tree_setup_default_cpus(struct dsa_switch_tree *dst)
 {
 	struct dsa_switch *ds;
 	struct dsa_port *dp;
-	int device, port;
+	int device, port, i;
 
-	/* DSA currently only supports a single CPU port */
-	dst->cpu_dp = dsa_tree_find_first_cpu(dst);
-	if (!dst->cpu_dp) {
+	dsa_tree_fill_cpu_ports(dst);
+	if (!dst->num_cpu_dps) {
 		pr_warn("Tree has no master device\n");
 		return -EINVAL;
 	}
 
-	/* Assign the default CPU port to all ports of the fabric */
+	/* Assign the default CPU port to all ports of the fabric in a round
+	 * robin way. This should work nicely for all sane switch tree designs.
+	 */
+	i = 0;
+
 	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
 		ds = dst->ds[device];
 		if (!ds)
@@ -238,18 +249,20 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 		for (port = 0; port < ds->num_ports; port++) {
 			dp = &ds->ports[port];
 
-			if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
-				dp->cpu_dp = dst->cpu_dp;
+			if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp)) {
+				dp->cpu_dp = dst->cpu_dps[i++];
+				if (i == dst->num_cpu_dps)
+					i = 0;
+			}
 		}
 	}
 
 	return 0;
 }
 
-static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
+static void dsa_tree_teardown_default_cpus(struct dsa_switch_tree *dst)
 {
-	/* DSA currently only supports a single CPU port */
-	dst->cpu_dp = NULL;
+	dst->num_cpu_dps = 0;
 }
 
 static int dsa_port_setup(struct dsa_port *dp)
@@ -493,21 +506,34 @@ static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
 	}
 }
 
-static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
+static int dsa_tree_setup_masters(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *cpu_dp = dst->cpu_dp;
-	struct net_device *master = cpu_dp->master;
+	int i;
+	int err;
 
-	/* DSA currently supports a single pair of CPU port and master device */
-	return dsa_master_setup(master, cpu_dp);
+	for (i = 0; i < dst->num_cpu_dps; ++i) {
+		struct dsa_port *cpu_dp = dst->cpu_dps[i];
+		struct net_device *master = cpu_dp->master;
+
+		err = dsa_master_setup(master, cpu_dp);
+		if (err)
+			goto teardown;
+	}
+
+	return 0;
+teardown:
+	for (--i; i >= 0; --i)
+		dsa_master_teardown(dst->cpu_dps[i]->master);
+
+	return err;
 }
 
-static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
+static void dsa_tree_teardown_masters(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *cpu_dp = dst->cpu_dp;
-	struct net_device *master = cpu_dp->master;
+	int i;
 
-	return dsa_master_teardown(master);
+	for (i = 0; i < dst->num_cpu_dps; ++i)
+		dsa_master_teardown(dst->cpu_dps[i]->master);
 }
 
 static int dsa_tree_setup(struct dsa_switch_tree *dst)
@@ -525,7 +551,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (!complete)
 		return 0;
 
-	err = dsa_tree_setup_default_cpu(dst);
+	err = dsa_tree_setup_default_cpus(dst);
 	if (err)
 		return err;
 
@@ -533,7 +559,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (err)
 		goto teardown_default_cpu;
 
-	err = dsa_tree_setup_master(dst);
+	err = dsa_tree_setup_masters(dst);
 	if (err)
 		goto teardown_switches;
 
@@ -546,7 +572,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_default_cpu:
-	dsa_tree_teardown_default_cpu(dst);
+	dsa_tree_teardown_default_cpus(dst);
 
 	return err;
 }
@@ -556,11 +582,11 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	if (!dst->setup)
 		return;
 
-	dsa_tree_teardown_master(dst);
+	dsa_tree_teardown_masters(dst);
 
 	dsa_tree_teardown_switches(dst);
 
-	dsa_tree_teardown_default_cpu(dst);
+	dsa_tree_teardown_default_cpus(dst);
 
 	pr_info("DSA: tree %d torn down\n", dst->index);
 
-- 
2.21.0

