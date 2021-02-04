Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E44E30F56E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 15:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhBDOx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 09:53:26 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42691 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236906AbhBDOwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 09:52:44 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maximmi@mellanox.com)
        with SMTP; 4 Feb 2021 16:51:37 +0200
Received: from dev-l-vrt-208.mtl.labs.mlnx (dev-l-vrt-208.mtl.labs.mlnx [10.234.208.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 114EpbLG018268;
        Thu, 4 Feb 2021 16:51:37 +0200
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next v3] tc/htb: Hierarchical QoS hardware offload
Date:   Thu,  4 Feb 2021 16:51:37 +0200
Message-Id: <20210204145137.165298-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for configuring HTB in offload mode. HTB
offload eliminates the single qdisc lock in the datapath and offloads
the algorithm to the NIC. The new 'offload' parameter is added to
enable this mode:

    # tc qdisc replace dev eth0 root handle 1: htb offload

Classes are created as usual, but filters should be moved to clsact for
lock-free classification (filters attached to HTB itself are not
supported in the offload mode):

    # tc filter add dev eth0 egress protocol ip flower dst_port 80
    action skbedit priority 1:10

tc qdisc show and tc class show will indicate whether the offload is
enabled. Example output:

$ tc qdisc show dev eth1
qdisc htb 1: root offloaded r2q 10 default 0 direct_packets_stat 0 direct_qlen 1000 offload
qdisc pfifo 0: parent 1: limit 1000p
qdisc pfifo 0: parent 1: limit 1000p
qdisc pfifo 0: parent 1: limit 1000p
qdisc pfifo 0: parent 1: limit 1000p
qdisc pfifo 0: parent 1: limit 1000p
qdisc pfifo 0: parent 1: limit 1000p
qdisc pfifo 0: parent 1: limit 1000p
qdisc pfifo 0: parent 1: limit 1000p
$ tc class show dev eth1
class htb 1:101 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
class htb 1:1 root rate 100Gbit ceil 100Gbit burst 0b cburst 0b  offload
class htb 1:103 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
class htb 1:102 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
class htb 1:105 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
class htb 1:104 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
class htb 1:107 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
class htb 1:106 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
class htb 1:108 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
$ tc -j qdisc show dev eth1
[{"kind":"htb","handle":"1:","root":true,"offloaded":true,"options":{"r2q":10,"default":"0","direct_packets_stat":0,"direct_qlen":1000,"offload":null}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}}]

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 man/man8/tc-htb.8 |  5 ++++-
 tc/q_htb.c        | 10 +++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-htb.8 b/man/man8/tc-htb.8
index a4162342..031b73ac 100644
--- a/man/man8/tc-htb.8
+++ b/man/man8/tc-htb.8
@@ -12,7 +12,7 @@ major:
 minor-id
 .B ] [ r2q
 divisor
-.B ]
+.B ] [ offload ]
 
 .B tc class ... dev
 dev
@@ -104,6 +104,9 @@ Divisor used to calculate
 values for classes.  Classes divide
 .B rate
 by this number.  Default value is 10.
+.TP
+offload
+Offload the HTB algorithm to hardware (requires driver and device support).
 
 .SH CLASSES
 Classes have a host of parameters to configure their operation.
diff --git a/tc/q_htb.c b/tc/q_htb.c
index c609e974..42566355 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -30,11 +30,12 @@
 static void explain(void)
 {
 	fprintf(stderr, "Usage: ... qdisc add ... htb [default N] [r2q N]\n"
-		"                      [direct_qlen P]\n"
+		"                      [direct_qlen P] [offload]\n"
 		" default  minor id of class to which unclassified packets are sent {0}\n"
 		" r2q      DRR quantums are computed as rate in Bps/r2q {10}\n"
 		" debug    string of 16 numbers each 0-3 {0}\n\n"
 		" direct_qlen  Limit of the direct queue {in packets}\n"
+		" offload  enable hardware offload\n"
 		"... class add ... htb rate R1 [burst B1] [mpu B] [overhead O]\n"
 		"                      [prio P] [slot S] [pslot PS]\n"
 		"                      [ceil R2] [cburst B2] [mtu MTU] [quantum Q]\n"
@@ -68,6 +69,7 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
 	};
 	struct rtattr *tail;
 	unsigned int i; char *p;
+	bool offload = false;
 
 	while (argc > 0) {
 		if (matches(*argv, "r2q") == 0) {
@@ -91,6 +93,8 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
 			if (get_u32(&direct_qlen, *argv, 10)) {
 				explain1("direct_qlen"); return -1;
 			}
+		} else if (matches(*argv, "offload") == 0) {
+			offload = true;
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			explain();
@@ -103,6 +107,8 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
 	if (direct_qlen != ~0U)
 		addattr_l(n, 2024, TCA_HTB_DIRECT_QLEN,
 			  &direct_qlen, sizeof(direct_qlen));
+	if (offload)
+		addattr(n, 2024, TCA_HTB_OFFLOAD);
 	addattr_nest_end(n, tail);
 	return 0;
 }
@@ -344,6 +350,8 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		print_uint(PRINT_ANY, "direct_qlen", " direct_qlen %u",
 			   direct_qlen);
 	}
+	if (tb[TCA_HTB_OFFLOAD])
+		print_null(PRINT_ANY, "offload", " offload", NULL);
 	return 0;
 }
 
-- 
2.25.1

