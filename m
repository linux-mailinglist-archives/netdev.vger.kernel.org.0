Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CC221A57
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 17:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbfEQPLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 11:11:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbfEQPLb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 11:11:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C0D2E3DBC2
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 15:11:30 +0000 (UTC)
Received: from ocho.redhat.com (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BB435D9C4;
        Fri, 17 May 2019 15:11:28 +0000 (UTC)
From:   Patrick Talbert <ptalbert@redhat.com>
To:     netdev@vger.kernel.org
Cc:     ptalbert@redhat.com
Subject: [PATCH] net: Treat sock->sk_drops as an unsigned int when printing
Date:   Fri, 17 May 2019 17:11:28 +0200
Message-Id: <20190517151128.14444-1-ptalbert@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 17 May 2019 15:11:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, procfs socket stats format sk_drops as a signed int (%d). For large
values this will cause a negative number to be printed.

We know the drop count can never be a negative so change the format specifier to
%u.

Signed-off-by: Patrick Talbert <ptalbert@redhat.com>
---
 net/ipv4/ping.c          | 2 +-
 net/ipv4/raw.c           | 2 +-
 net/ipv4/udp.c           | 2 +-
 net/ipv6/datagram.c      | 2 +-
 net/netlink/af_netlink.c | 2 +-
 net/phonet/socket.c      | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 7ccb5f87f70b..834be7daeb32 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1113,7 +1113,7 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
 	__u16 srcp = ntohs(inet->inet_sport);
 
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %u",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index dc91c27bb788..0e482f07b37f 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -1076,7 +1076,7 @@ static void raw_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
 	      srcp  = inet->inet_num;
 
 	seq_printf(seq, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d\n",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %u\n",
 		i, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 3c58ba02af7d..8fb250ed53d4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2883,7 +2883,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 	__u16 srcp	  = ntohs(inet->inet_sport);
 
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %u",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		udp_rqueue_get(sp),
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index ee4a4e54d016..f07fb24f4ba1 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -1034,7 +1034,7 @@ void __ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp,
 	src   = &sp->sk_v6_rcv_saddr;
 	seq_printf(seq,
 		   "%5d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %u\n",
 		   bucket,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 216ab915dd54..718a97d5f1fd 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2642,7 +2642,7 @@ static int netlink_seq_show(struct seq_file *seq, void *v)
 		struct sock *s = v;
 		struct netlink_sock *nlk = nlk_sk(s);
 
-		seq_printf(seq, "%pK %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8d %-8lu\n",
+		seq_printf(seq, "%pK %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8u %-8lu\n",
 			   s,
 			   s->sk_protocol,
 			   nlk->portid,
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 30187990257f..2567af2fbd6f 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -607,7 +607,7 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
 		struct pn_sock *pn = pn_sk(sk);
 
 		seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %lu "
-			"%d %pK %d",
+			"%d %pK %u",
 			sk->sk_protocol, pn->sobject, pn->dobject,
 			pn->resource, sk->sk_state,
 			sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
-- 
2.18.1

