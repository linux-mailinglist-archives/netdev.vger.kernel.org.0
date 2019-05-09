Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6688918D6B
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfEIPzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 11:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbfEIPzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 11:55:45 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A2B22175B;
        Thu,  9 May 2019 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557417343;
        bh=NOrAsql8acAxQJ2IkLB2utqv/DcLz1GeW+c8nirPTKM=;
        h=From:To:Cc:Subject:Date:From;
        b=ORIcO+gnPfLC01TfJ/1O90QCHNybXJgAnMhA1VUYIoymxqvB3V+ABMqu9STipa6z/
         NPFt+/Q+CT8GXzrnnxx8PTSBtDGUPNEkq3W2UkO9hO6JHC4JrOh+CyrqvafFJifeGG
         pzuOGZJ9YS0y0bwgkwUlSyUZUL/GWZVhmCBlV8v0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next] netlink: Add support for timestamping messages
Date:   Thu,  9 May 2019 08:55:42 -0700
Message-Id: <20190509155542.25494-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add support for timestamping netlink messages. If a socket wants a
timestamp, it is added when the skb clone is queued to the socket.

Allow userspace to know the actual time an event happened. In a
busy system there can be a long lag between when the event happened
and when the message is read from the socket. Further, this allows
separate netlink sockets for various RTNLGRP's where the timestamp
can be used to sort the messages if needed.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
one question I have is whether it would be better to add the timestamp
when the skb is created so it is the same for all sockets as opposed to
setting the time per socket.

 net/netlink/af_netlink.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 216ab915dd54..5e29ebfc701e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1343,6 +1343,8 @@ int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
 		return err;
 	}
 
+	if (sock_flag(sk, SOCK_RCVTSTAMP))
+		__net_timestamp(skb);
 	err = netlink_attachskb(sk, skb, &timeo, ssk);
 	if (err == 1)
 		goto retry;
@@ -1469,6 +1471,9 @@ static void do_one_broadcast(struct sock *sk,
 		p->skb2 = NULL;
 		goto out;
 	}
+
+	if (sock_flag(sk, SOCK_RCVTSTAMP))
+		__net_timestamp(p->skb2);
 	NETLINK_CB(p->skb2).nsid = peernet2id(sock_net(sk), p->net);
 	if (NETLINK_CB(p->skb2).nsid != NETNSA_NSID_NOT_ASSIGNED)
 		NETLINK_CB(p->skb2).nsid_is_set = true;
@@ -1848,6 +1853,47 @@ static void netlink_cmsg_listen_all_nsid(struct sock *sk, struct msghdr *msg,
 		 &NETLINK_CB(skb).nsid);
 }
 
+/* based on tcp_recv_timestamp */
+static void netlink_cmsg_timestamp(struct msghdr *msg, struct sk_buff *skb,
+				   struct sock *sk)
+{
+	int new_tstamp;
+
+	if (!skb_get_ktime(skb))
+		return;
+
+	new_tstamp = sock_flag(sk, SOCK_TSTAMP_NEW);
+	if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
+		if (new_tstamp) {
+			struct __kernel_timespec kts;
+
+			skb_get_new_timestampns(skb, &kts);
+			put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
+				 sizeof(kts), &kts);
+		} else {
+			struct timespec ts;
+
+			skb_get_timestampns(skb, &ts);
+			put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
+				 sizeof(ts), &ts);
+		}
+	} else {
+		if (new_tstamp) {
+			struct __kernel_sock_timeval stv;
+
+			skb_get_new_timestamp(skb, &stv);
+			put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_NEW,
+				 sizeof(stv), &stv);
+		} else {
+			struct __kernel_old_timeval tv;
+
+			skb_get_timestamp(skb, &tv);
+			put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
+				 sizeof(tv), &tv);
+		}
+	}
+}
+
 static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
@@ -1996,6 +2042,8 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		netlink_cmsg_recv_pktinfo(msg, skb);
 	if (nlk->flags & NETLINK_F_LISTEN_ALL_NSID)
 		netlink_cmsg_listen_all_nsid(sk, msg, skb);
+	if (sock_flag(sk, SOCK_RCVTSTAMP))
+		netlink_cmsg_timestamp(msg, skb, sk);
 
 	memset(&scm, 0, sizeof(scm));
 	scm.creds = *NETLINK_CREDS(skb);
-- 
2.11.0

