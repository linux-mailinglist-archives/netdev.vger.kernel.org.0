Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE523E367C
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhHGRVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 13:21:09 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:51811 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229464AbhHGRVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 13:21:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UiEXaLV_1628356842;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UiEXaLV_1628356842)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 08 Aug 2021 01:20:47 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     davem@davemloft.net, David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Baoyou Xie <baoyou.xie@alibaba-inc.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv4: return early for possible invalid uaddr
Date:   Sun,  8 Aug 2021 01:19:38 +0800
Message-Id: <20210807171938.38501-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The inet_dgram_connect() first calls inet_autobind() to select an
ephemeral port, then checks uaddr in udp_pre_connect() or
__ip4_datagram_connect(), but the port is not released until the socket
is closed.

We should return early for invalid uaddr to improve performance and
simplify the code a bit, and also switch from a mix of tabs and spaces
to just tabs.

Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Baoyou Xie <baoyou.xie@alibaba-inc.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/ipv4/af_inet.c  | 27 ++++++++++++++++-----------
 net/ipv4/datagram.c |  7 -------
 net/ipv4/udp.c      |  7 -------
 3 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 5464818..97b6fc4 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -569,6 +569,11 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 	if (uaddr->sa_family == AF_UNSPEC)
 		return sk->sk_prot->disconnect(sk, flags);
 
+	if (uaddr->sa_family != AF_INET)
+		return -EAFNOSUPPORT;
+	if (addr_len < sizeof(struct sockaddr_in))
+		return -EINVAL;
+
 	if (BPF_CGROUP_PRE_CONNECT_ENABLED(sk)) {
 		err = sk->sk_prot->pre_connect(sk, uaddr, addr_len);
 		if (err)
@@ -1136,23 +1141,23 @@ static int inet_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 		.prot =       &udp_prot,
 		.ops =        &inet_dgram_ops,
 		.flags =      INET_PROTOSW_PERMANENT,
-       },
+	},
 
-       {
+	{
 		.type =       SOCK_DGRAM,
 		.protocol =   IPPROTO_ICMP,
 		.prot =       &ping_prot,
 		.ops =        &inet_sockraw_ops,
 		.flags =      INET_PROTOSW_REUSE,
-       },
-
-       {
-	       .type =       SOCK_RAW,
-	       .protocol =   IPPROTO_IP,	/* wild card */
-	       .prot =       &raw_prot,
-	       .ops =        &inet_sockraw_ops,
-	       .flags =      INET_PROTOSW_REUSE,
-       }
+	},
+
+	{
+		.type =       SOCK_RAW,
+		.protocol =   IPPROTO_IP,	/* wild card */
+		.prot =       &raw_prot,
+		.ops =        &inet_sockraw_ops,
+		.flags =      INET_PROTOSW_REUSE,
+	}
 };
 
 #define INETSW_ARRAY_LEN ARRAY_SIZE(inetsw_array)
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 4a8550c..81aae1d 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -27,13 +27,6 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	int oif;
 	int err;
 
-
-	if (addr_len < sizeof(*usin))
-		return -EINVAL;
-
-	if (usin->sin_family != AF_INET)
-		return -EAFNOSUPPORT;
-
 	sk_dst_reset(sk);
 
 	oif = sk->sk_bound_dev_if;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 62cd4cd..1ef0770 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1928,13 +1928,6 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
-	/* This check is replicated from __ip4_datagram_connect() and
-	 * intended to prevent BPF program called below from accessing bytes
-	 * that are out of the bound specified by user in addr_len.
-	 */
-	if (addr_len < sizeof(struct sockaddr_in))
-		return -EINVAL;
-
 	return BPF_CGROUP_RUN_PROG_INET4_CONNECT_LOCK(sk, uaddr);
 }
 EXPORT_SYMBOL(udp_pre_connect);
-- 
1.8.3.1

