Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F6B1D3249
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgENOKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:10:40 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56060 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726050AbgENOKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:10:39 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 17:10:31 +0300
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EEAVX1021090;
        Thu, 14 May 2020 17:10:31 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        paulb@mellanox.com, Jiri Pirko <jiri@mellanox.com>
Cc:     ozsh@mellanox.com, roid@mellanox.com
Subject: [PATCH iproute2/net-next] man: tc-ct.8: Add manual page for ct tc action
Date:   Thu, 14 May 2020 17:10:20 +0300
Message-Id: <1589465420-12119-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 man/man8/tc-ct.8     | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/tc-flower.8 |   6 +++
 2 files changed, 113 insertions(+)
 create mode 100644 man/man8/tc-ct.8

diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
new file mode 100644
index 0000000..45d2932
--- /dev/null
+++ b/man/man8/tc-ct.8
@@ -0,0 +1,107 @@
+.TH "ct action in tc" 8 "14 May 2020" "iproute2" "Linux"
+.SH NAME
+ct \- tc connection tracking action
+.SH SYNOPSIS
+.in +8
+.ti -8
+.BR "tc ... action ct commit [ force ] [ zone "
+.IR ZONE
+.BR "] [ mark "
+.IR MASKED_MARK
+.BR "] [ label "
+.IR MASKED_LABEL
+.BR "] [ nat "
+.IR NAT_SPEC
+.BR "]"
+
+.ti -8
+.BR "tc ... action ct [ nat ] [ zone "
+.IR ZONE
+.BR "]"
+
+.ti -8
+.BR "tc ... action ct clear"
+
+.SH DESCRIPTION
+The ct action is a tc action for sending packets and interacting with the netfilter conntrack module.
+
+It can (as shown in the synopsis, in order):
+
+Send the packet to conntrack, and commit the connection, while configuring
+a 32bit mark, 128bit label, and src/dst nat.
+
+Send the packet to conntrack, which will mark the packet with the connection's state and
+configured metadata (mark/label), and execute previous configured nat.
+
+Clear the packet's of previous connection tracking state.
+
+.SH OPTIONS
+.TP
+.BI zone " ZONE"
+Specify a conntrack zone number on which to send the packet to conntrack.
+.TP
+.BI mark " MASKED_MARK"
+Specify a masked 32bit mark to set for the connection (only valid with commit).
+.TP
+.BI label " MASKED_LABEL"
+Specify a masked 128bit label to set for the connection (only valid with commit).
+.TP
+.BI nat " NAT_SPEC"
+.BI Where " NAT_SPEC " ":= {src|dst} addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]"
+
+Specify src/dst and range of nat to configure for the connection (only valid with commit).
+.RS
+.TP
+src/dst - configure src or dst nat
+.TP
+.BI  "" "addr1" "/" "addr2" " - IPv4/IPv6 addresses"
+.TP
+.BI  "" "port1" "/" "port2" " - Port numbers"
+.RE
+.TP
+.BI nat
+Restore any previous configured nat.
+.TP
+.BI clear
+Remove any conntrack state and metadata (mark/label) from the packet (must only option specified).
+.TP
+.BI force
+Forces conntrack direction for a previously commited connections, so that current direction will become the original direction (only valid with commit).
+
+.SH EXAMPLES
+Example showing natted firewall in conntrack zone 2, and conntrack mark usage:
+.EX
+
+#Add ingress qdisc on eth0 and eth1 interfaces
+.nf
+$ tc qdisc add dev eth0 handle ingress
+$ tc qdisc add dev eth1 handle ingress
+
+#Setup filters on eth0, allowing opening new connections in zone 2, and doing src nat + mark for each new connection
+$ tc filter add dev eth0 ingress prio 1 chain 0 proto ip flower ip_proto tcp ct_state -trk \\
+action ct zone 2 pipe action goto chain 2
+$ tc filter add dev eth0 ingress prio 1 chain 2 proto ip flower ct_state +trk+new \\
+action ct zone 2 commit mark 0xbb nat src addr 5.5.5.7 pipe action mirred egress redirect dev eth1
+$ tc filter add dev eth0 ingress prio 1 chain 2 proto ip flower ct_zone 2 ct_mark 0xbb ct_state +trk+est \\
+action ct nat pipe action mirred egress redirect dev eth1
+
+#Setup filters on eth1, allowing only established connections of zone 2 through, and reverse nat (dst nat in this case)
+$ tc filter add dev eth1 ingress prio 1 chain 0 proto ip flower ip_proto tcp ct_state -trk \\
+action ct zone 2 pipe action goto chain 1
+$ tc filter add dev eth1 ingress prio 1 chain 1 proto ip flower ct_zone 2 ct_mark 0xbb ct_state +trk+est \\
+action ct nat pipe action mirred egress redirect dev eth0
+.fi
+
+.EE
+
+.RE
+.SH SEE ALSO
+.BR tc (8),
+.BR tc-flower (8)
+.BR tc-mirred (8)
+.SH AUTHORS
+Paul Blakey <paulb@mellanox.com>
+
+Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
+
+Yossi Kuperman <yossiku@mellanox.com>
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index eb9eb5f..12df48d 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -1,5 +1,11 @@
 .TH "Flower filter in tc" 8 "22 Oct 2015" "iproute2" "Linux"
 
+	"Usage: ct clear\n"
+		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC] [OFFLOAD_POLICY]\n"
+		"	ct [nat] [zone ZONE] [OFFLOAD_POLICY]\n"
+		"Where: ZONE is the conntrack zone table number\n"
+		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
+		"	OFFLOAD_POLICY is [policy_pkts PACKETS] [policy_timeout TIMEOUT]\n"
 .SH NAME
 flower \- flow based traffic control filter
 .SH SYNOPSIS
-- 
1.8.3.1

