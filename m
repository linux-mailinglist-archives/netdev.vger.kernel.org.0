Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464E1A22D6
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfH2RzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:55:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbfH2RzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:55:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4B24466DAB; Thu, 29 Aug 2019 17:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567101282;
        bh=Zr8jQ0er++3LtWrm9YPyCd6QN0i2iHZ5GFJN0WXv0UY=;
        h=From:To:Cc:Subject:Date:From;
        b=CpuZv3YBSanFmTIjVeH61TTGLHM01PgXeoRJbAcfQt5Kjxu4RYLA/NK+YGb2sAc79
         yGjPtRgUP6OIdoAgmROdfQXfsSaA6Y0JSryaesDWUa7V51zBUFuuf47h0NuzVw4dd0
         4c9rnnsNc2wgW8jHJjIefXnlF4HheVzzi039Ib1I=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B880759FA;
        Thu, 29 Aug 2019 03:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567049246;
        bh=Zr8jQ0er++3LtWrm9YPyCd6QN0i2iHZ5GFJN0WXv0UY=;
        h=From:To:Cc:Subject:Date:From;
        b=jbbuNn20GyZkxxyUt9P4g0xBvIdkkvN3sij/+j2dRG3XoATxYIT46ibJGJZwUJjck
         sLL+pbMTSB1Yob6I0NdvBkxMMr4AP6A2R9oqWUHydn9A07/+IOytjdX58anGQZxGCU
         /B9z9WRIKPAu9C50veU2ZMWUHXGcHOxm8GERtpvw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B880759FA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net-next] net: Fail explicit bind to local reserved ports
Date:   Wed, 28 Aug 2019 21:26:54 -0600
Message-Id: <1567049214-19804-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reserved ports may have some special use cases which are not suitable
for use by general userspace applications. Currently, ports specified
in ip_local_reserved_ports will not be returned only in case of
automatic port assignment.

In some cases, it maybe required to prevent the host from assigning
the ports even in case of explicit binds. Consider the case of a
transparent proxy where packets are being redirected. In case a socket
matches this connection, packets from this application would be
incorrectly sent to one of the endpoints.

Add a boolean sysctl flag 'reserved_port_bind'. Default value is 1
which preserves the existing behavior. Setting the value to 0 will
prevent userspace applications from binding to these ports even when
they are explicitly requested.

Cc: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 Documentation/networking/ip-sysctl.txt | 5 +++++
 include/net/netns/ipv4.h               | 2 ++
 net/ipv4/af_inet.c                     | 3 +++
 net/ipv4/inet_connection_sock.c        | 7 +++++++
 net/ipv4/sysctl_net_ipv4.c             | 7 +++++++
 net/ipv4/udp.c                         | 5 +++++
 6 files changed, 29 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 49e95f4..8a9d649 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -945,6 +945,11 @@ ip_unprivileged_port_start - INTEGER
 
 	Default: 1024
 
+reserved_port_bind - BOOLEAN
+	If set, allows explicit bind requests to applications requesting
+	any port within the range of ip_local_reserved_ports.
+	Default: 1
+
 ip_nonlocal_bind - BOOLEAN
 	If set, allows processes to bind() to non-local IP addresses,
 	which can be quite useful - but may break some applications.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index c0c0791..0941369 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -107,6 +107,8 @@ struct netns_ipv4 {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	int sysctl_raw_l3mdev_accept;
 #endif
+	int sysctl_reserved_port_bind;
+
 	int sysctl_tcp_early_demux;
 	int sysctl_udp_early_demux;
 
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
index f5c163d..6dda979 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -307,6 +307,13 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 	head = &hinfo->bhash[inet_bhashfn(net, port,
 					  hinfo->bhash_size)];
 	spin_lock_bh(&head->lock);
+
+	if (inet_is_local_reserved_port(net, snum) &&
+	    !net->ipv4.sysctl_reserved_port_bind) {
+		ret = 1;
+		goto fail_unlock;
+	}
+
 	inet_bind_bucket_for_each(tb, &head->chain)
 		if (net_eq(ib_net(tb), net) && tb->l3mdev == l3mdev &&
 		    tb->port == port)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 59ded25..557fdec 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -742,6 +742,13 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 		.proc_handler	= proc_do_large_bitmap,
 	},
 	{
+		.procname       = "reserved_port_bind",
+		.data           = &init_net.ipv4.sysctl_reserved_port_bind,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec
+	},
+	{
 		.procname	= "ip_no_pmtu_disc",
 		.data		= &init_net.ipv4.sysctl_ip_no_pmtu_disc,
 		.maxlen		= sizeof(int),
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d88821c..59a4274 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -274,6 +274,11 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 	} else {
 		hslot = udp_hashslot(udptable, net, snum);
 		spin_lock_bh(&hslot->lock);
+
+		if (inet_is_local_reserved_port(net, snum) &&
+		    !net->ipv4.sysctl_reserved_port_bind)
+			goto fail_unlock;
+
 		if (hslot->count > 10) {
 			int exist;
 			unsigned int slot2 = udp_sk(sk)->udp_portaddr_hash ^ snum;
-- 
1.9.1

