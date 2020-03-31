Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93819A26E
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 01:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbgCaX0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 19:26:39 -0400
Received: from haggis.mythic-beasts.com ([46.235.224.141]:33231 "EHLO
        haggis.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731364AbgCaX0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 19:26:39 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2020 19:26:38 EDT
Received: from [2001:678:634:203:cf83:32c6:10b8:3403] (port=57814 helo=phosphorus.lan.house.timstallard.me.uk)
        by haggis.mythic-beasts.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <code@timstallard.me.uk>)
        id 1jJQ8f-00033v-H7; Wed, 01 Apr 2020 00:17:45 +0100
From:   Tim Stallard <code@timstallard.me.uk>
To:     netdev@vger.kernel.org
Cc:     Tim Stallard <code@timstallard.me.uk>
Subject: [PATCH net] net: icmp6: add icmp_errors_use_inbound_ifaddr sysctl for IPv6
Date:   Wed,  1 Apr 2020 00:17:06 +0100
Message-Id: <20200331231706.14551-1-code@timstallard.me.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BlackCat-Spam-Score: 50
X-Spam-Status: No, score=5.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IPv4, normal source address selection is used for ICMP, unless
icmp_errors_use_inbound_ifaddr is set in which case addresses on
the ingress interface will be used. For IPv6, equivalent functionality
exists since commit fac6fce9bdb5 ("net: icmp6: provide input address
for traceroute6") which enables this behaviour by default.

Scenarios where source address selection is manually influenced are
broken by this, eg by setting source addresses on routes:

ip -6 addr add 2001:db8:100::1 dev lo
ip -6 addr add 2001:db8::2/64 dev eth0
ip -6 route add default via 2001:db8::1 src 2001:db8:100::1

In this scenario, ICMP errors would be sent from 2001:db8::2
rather than the manually configured 2001:db8:100::1.

In practice, this causes issues with IPv6 path MTU discovery in networks
where unroutable linknets are used, and packets from these linknets are
discarded by upstream providers' BCP38 filters, dropping all Packet
Too Big errors. Traceroutes are also broken in this scenario.

This restores the original behaviour by default, and adds a sysctl
to enable the modified source address selection for ICMP errors,
in line with the behaviour for IPv4.

Fixes: fac6fce9bdb5 ("net: icmp6: provide input address for traceroute6")
Signed-off-by: Tim Stallard <code@timstallard.me.uk>
---
 Documentation/networking/ip-sysctl.txt | 13 +++++++++++++
 include/net/netns/ipv6.h               |  1 +
 net/ipv6/af_inet6.c                    |  1 +
 net/ipv6/icmp.c                        | 12 ++++++++++--
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 5f53faff4e25..674e41f2ffa0 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -2014,6 +2014,19 @@ echo_ignore_anycast - BOOLEAN
 	requests sent to it over the IPv6 protocol destined to anycast address.
 	Default: 0
 
+errors_use_inbound_ifaddr - BOOLEAN
+
+	If zero, standard source address selection is used for outgoing ICMP
+	errors.
+
+	If non-zero, the message will be sent with the primary address of
+	the interface that received the packet that caused the icmp error.
+	This is the behaviour many network administrators will expect from
+	a router and it can make debugging complicated network layouts
+	much easier.
+
+	Default: 0
+
 xfrm6_gc_thresh - INTEGER
 	(Obsolete since linux-4.14)
 	The threshold at which we will start garbage collecting for IPv6
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 5ec054473d81..cbe2a151c932 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -36,6 +36,7 @@ struct netns_sysctl_ipv6 {
 	int icmpv6_echo_ignore_all;
 	int icmpv6_echo_ignore_multicast;
 	int icmpv6_echo_ignore_anycast;
+	int icmpv6_errors_use_inbound_ifaddr;
 	DECLARE_BITMAP(icmpv6_ratemask, ICMPV6_MSG_MAX + 1);
 	unsigned long *icmpv6_ratemask_ptr;
 	int anycast_src_echo_reply;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d727c3b41495..1a9b817e0266 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -875,6 +875,7 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.icmpv6_echo_ignore_all = 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_multicast = 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_anycast = 0;
+	net->ipv6.sysctl.icmpv6_errors_use_inbound_ifaddr = 0;
 
 	/* By default, rate limit error messages.
 	 * Except for pmtu discovery, it would break it.
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index ef408a5090a2..6ac65705f505 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -527,7 +527,7 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		saddr = force_saddr;
 	if (saddr) {
 		fl6.saddr = *saddr;
-	} else {
+	} else if (net->ipv6.sysctl.icmpv6_errors_use_inbound_ifaddr) {
 		/* select a more meaningful saddr from input if */
 		struct net_device *in_netdev;
 
@@ -1158,6 +1158,13 @@ static struct ctl_table ipv6_icmp_table_template[] = {
 		.mode		= 0644,
 		.proc_handler = proc_dointvec,
 	},
+	{
+		.procname	= "errors_use_inbound_ifaddr",
+		.data		= &init_net.ipv6.sysctl.icmpv6_errors_use_inbound_ifaddr,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler = proc_dointvec,
+	},
 	{
 		.procname	= "ratemask",
 		.data		= &init_net.ipv6.sysctl.icmpv6_ratemask_ptr,
@@ -1181,7 +1188,8 @@ struct ctl_table * __net_init ipv6_icmp_sysctl_init(struct net *net)
 		table[1].data = &net->ipv6.sysctl.icmpv6_echo_ignore_all;
 		table[2].data = &net->ipv6.sysctl.icmpv6_echo_ignore_multicast;
 		table[3].data = &net->ipv6.sysctl.icmpv6_echo_ignore_anycast;
-		table[4].data = &net->ipv6.sysctl.icmpv6_ratemask_ptr;
+		table[4].data = &net->ipv6.sysctl.icmpv6_errors_use_inbound_ifaddr;
+		table[5].data = &net->ipv6.sysctl.icmpv6_ratemask_ptr;
 	}
 	return table;
 }
-- 
2.20.1

