Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A07EF1EE
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387758AbfKEA0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:26:22 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:44029 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387484AbfKEA0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 19:26:22 -0500
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 04 Nov 2019 16:26:21 -0800
IronPort-SDR: o7SLOGd+HqI5OHB/6L9DJZXEPFpb96cCNJBQHWAapbOHc1aCdDDHbTxoFSZOqMweJy1R4ERW/0
 bwjeiuwsHPT9AGcI/NSfqfRpWf863U6NU=
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 04 Nov 2019 16:26:20 -0800
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id 660854697; Mon,  4 Nov 2019 17:26:20 -0700 (MST)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net-next v2] net: Fail explicit bind to local reserved ports
Date:   Mon,  4 Nov 2019 17:25:41 -0700
Message-Id: <1572913541-28236-1-git-send-email-stranche@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reserved ports may have some special use cases which are not suitable for
use by general userspace applications. Currently, ports specified in
ip_local_reserved_ports will not be returned only in case of automatic port
assignment.

In some cases, it maybe required to prevent the host from assigning the
ports even in case of explicit binds. Consider the case of a transparent
proxy where packets are being redirected. In case a socket matches this
connection, packets from this application would be incorrectly sent to one
of the endpoints.

Add a boolean sysctl flag 'reserved_port_bind'. Default value is 1 which
preserves the existing behavior. Setting the value to 0 will prevent
userspace applications from binding to these ports even when they are
explicitly requested.

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 Documentation/networking/ip-sysctl.txt |  5 +++++
 include/net/ip.h                       | 11 +++++++++++
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/af_inet.c                     |  3 +++
 net/ipv4/inet_connection_sock.c        |  4 ++++
 net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
 net/ipv4/udp.c                         |  4 ++++
 net/sctp/socket.c                      |  6 ++++++
 8 files changed, 42 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 8d4ad1d..20ed5e5 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -948,6 +948,11 @@ ip_unprivileged_port_start - INTEGER
 
 	Default: 1024
 
+reserved_port_bind - BOOLEAN
+	If set, allows explicit bind request to applications requesting any
+	port within the range of ip_local_reserved_ports.
+	Default: 1
+
 ip_nonlocal_bind - BOOLEAN
 	If set, allows processes to bind() to non-local IP addresses,
 	which can be quite useful - but may break some applications.
diff --git a/include/net/ip.h b/include/net/ip.h
index a2c61c3..d6d3a2b 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -346,6 +346,12 @@ static inline int inet_is_local_reserved_port(struct net *net, int port)
 	return test_bit(port, net->ipv4.sysctl_local_reserved_ports);
 }
 
+static inline int inet_is_unbindable_port(struct net *net, int port)
+{
+	return inet_is_local_reserved_port(net, port) &&
+	       !net->ipv4.sysctl_reserved_port_bind;
+}
+
 static inline bool sysctl_dev_name_is_allowed(const char *name)
 {
 	return strcmp(name, "default") != 0  && strcmp(name, "all") != 0;
@@ -362,6 +368,11 @@ static inline int inet_is_local_reserved_port(struct net *net, int port)
 	return 0;
 }
 
+static inline int inet_is_unbindable_port(struct net *net, int port)
+{
+	return 0;
+}
+
 static inline int inet_prot_sock(struct net *net)
 {
 	return PROT_SOCK;
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index c0c0791..466fc7e 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -115,6 +115,8 @@ struct netns_ipv4 {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	int sysctl_tcp_l3mdev_accept;
 #endif
+	int sysctl_reserved_port_bind;
+
 	int sysctl_tcp_mtu_probing;
 	int sysctl_tcp_mtu_probe_floor;
 	int sysctl_tcp_base_mss;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 70f92aa..e1ad45d 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1814,6 +1814,9 @@ static __net_init int inet_init_net(struct net *net)
 	net->ipv4.ip_local_ports.range[0] =  32768;
 	net->ipv4.ip_local_ports.range[1] =  60999;
 
+	/* Allow explicit binding to reserved ports */
+	net->ipv4.sysctl_reserved_port_bind = 1;
+
 	seqlock_init(&net->ipv4.ping_group_range.lock);
 	/*
 	 * Sane defaults - nobody may create ping sockets.
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index eb30fc1..0c330dc 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -307,6 +307,10 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 	head = &hinfo->bhash[inet_bhashfn(net, port,
 					  hinfo->bhash_size)];
 	spin_lock_bh(&head->lock);
+
+	if (inet_is_unbindable_port(net, port))
+		goto fail_unlock;
+
 	inet_bind_bucket_for_each(tb, &head->chain)
 		if (net_eq(ib_net(tb), net) && tb->l3mdev == l3mdev &&
 		    tb->port == port)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 59ded25..f9317ba 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -742,6 +742,13 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 		.proc_handler	= proc_do_large_bitmap,
 	},
 	{
+		.procname	= "reserved_port_bind",
+		.data		= &init_net.ipv4.sysctl_reserved_port_bind,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "ip_no_pmtu_disc",
 		.data		= &init_net.ipv4.sysctl_ip_no_pmtu_disc,
 		.maxlen		= sizeof(int),
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1d58ce8..d71cb8a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -274,6 +274,10 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 	} else {
 		hslot = udp_hashslot(udptable, net, snum);
 		spin_lock_bh(&hslot->lock);
+
+		if (inet_is_unbindable_port(net, snum))
+			goto fail_unlock;
+
 		if (hslot->count > 10) {
 			int exist;
 			unsigned int slot2 = udp_sk(sk)->udp_portaddr_hash ^ snum;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ffd3262..7a653ad 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8210,6 +8210,12 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 */
 		head = &sctp_port_hashtable[sctp_phashfn(sock_net(sk), snum)];
 		spin_lock(&head->lock);
+
+		if (inet_is_unbindable_port(sock_net(sk), snum)) {
+			ret = 1;
+			goto fail_unlock;
+		}
+
 		sctp_for_each_hentry(pp, &head->chain) {
 			if ((pp->port == snum) && net_eq(pp->net, sock_net(sk)))
 				goto pp_found;
-- 
1.9.1

