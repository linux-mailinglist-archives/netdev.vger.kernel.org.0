Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B914D481AA1
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 09:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbhL3IDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 03:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbhL3IDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 03:03:33 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D90C061574;
        Thu, 30 Dec 2021 00:03:33 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q3so16453347pfs.7;
        Thu, 30 Dec 2021 00:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SZI6ien2bl1CEWV7vLSkGMBBhpKf63/++avMZM/X2R4=;
        b=ZWxIe8cHKRnH+huENnIeuj1Jo9fMNwLYapboeqpvbfq4uysoOjYQWW+tOMrdBra7dT
         qLEEePl3q7dpGO/grxaPc6MkensyeQt3SVNjK9OFsJqVyit9VnusQDE5vzd5p6Psip5f
         +AeABpeUpKE+o/2FLqlcml1hMlqxc85Gcn2s/akq/pJSTNjB7luxwwfsOBCPteuHmJ0L
         axbO3vYyERw4QuHJlrhbM6tlSzPa5O0Ju3z3hd1acfd7wk5B1QQkUXnSD4XPdNW5/Wr/
         9MFiKjP43LqkkqzXJ3VH6qpl3ZsJlQDk1cjQllrj0FVZQZw+qPIdfdbJHMQQHhxE1tWZ
         dzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SZI6ien2bl1CEWV7vLSkGMBBhpKf63/++avMZM/X2R4=;
        b=p0Mb5StPsoFjvdAG1FwoO1JOlRZTDlOtQU7QGe8PhvhxAF1ER5NB+dkJpWmmU3pvNW
         UQPZouKYJPOQUbFkr8o5bt4JCec5ijn53C4dgQJA2nuesSHBfwTElm8tqmckvd5eZYOM
         7lcP7SrGr5JtGExoJ+of8I9Gd8mjSUxB1wvWku/lwZpN+tKhvHaY0Ai1YOWXvlRXk6E+
         N8RFYogS14Eo6CouwFI0KqGH3FdluFzWF1ZPQnicFZw1KVXMHcgahRr32ZFBprEfA7sr
         6B7y45dmzdS5cp3gUni5HXN+u87apLb8mx5G1cHSNfv2xHkGN//xp0KAc5yJLSK4foVn
         eyqQ==
X-Gm-Message-State: AOAM532lHcrpuiZkKp8doTEDDraR26jlwcRhAyMsdssGxe63oqNlugu7
        5M4UvfzQ6+e6yjM2mrj7Jnk=
X-Google-Smtp-Source: ABdhPJyZWxA+fDw/JDltbChlls9y7wASGLbJtOYQfpaBc0DYjDl3qkbn0Rwv0nGrt9z9IydibAB3Zg==
X-Received: by 2002:a63:ff4f:: with SMTP id s15mr26307083pgk.215.1640851413120;
        Thu, 30 Dec 2021 00:03:33 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id 13sm26606987pfm.161.2021.12.30.00.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 00:03:32 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v2 net-next 1/2] net: bpf: handle return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
Date:   Thu, 30 Dec 2021 16:03:04 +0800
Message-Id: <20211230080305.1068950-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211230080305.1068950-1-imagedong@tencent.com>
References: <20211230080305.1068950-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND() in
__inet_bind() is not handled properly. While the return value
is non-zero, it will set inet_saddr and inet_rcv_saddr to 0 and
exit:

	err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
	if (err) {
		inet->inet_saddr = inet->inet_rcv_saddr = 0;
		goto out_release_sock;
	}

Let's take UDP for example and see what will happen. For UDP
socket, it will be added to 'udp_prot.h.udp_table->hash' and
'udp_prot.h.udp_table->hash2' after the sk->sk_prot->get_port()
called success. If 'inet->inet_rcv_saddr' is specified here,
then 'sk' will be in the 'hslot2' of 'hash2' that it don't belong
to (because inet_saddr is changed to 0), and UDP packet received
will not be passed to this sock. If 'inet->inet_rcv_saddr' is not
specified here, the sock will work fine, as it can receive packet
properly, which is wired, as the 'bind()' is already failed.

To undo the get_port() operation, introduce the 'put_port' field
for 'struct proto'. For TCP proto, it is inet_put_port(); For UDP
proto, it is udp_lib_unhash(); For icmp proto, it is
ping_unhash().

Therefore, after sys_bind() fail caused by
BPF_CGROUP_RUN_PROG_INET4_POST_BIND(), it will be unbinded, which
means that it can try to be binded to another port.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- introduce 'put_port' field for 'struct proto'
---
 include/net/sock.h  | 1 +
 net/ipv4/af_inet.c  | 2 ++
 net/ipv4/ping.c     | 1 +
 net/ipv4/tcp_ipv4.c | 1 +
 net/ipv4/udp.c      | 1 +
 net/ipv6/af_inet6.c | 2 ++
 net/ipv6/ping.c     | 1 +
 net/ipv6/tcp_ipv6.c | 1 +
 net/ipv6/udp.c      | 1 +
 9 files changed, 11 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 44cc25f0bae7..f5fc0432374e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1209,6 +1209,7 @@ struct proto {
 	void			(*unhash)(struct sock *sk);
 	void			(*rehash)(struct sock *sk);
 	int			(*get_port)(struct sock *sk, unsigned short snum);
+	void			(*put_port)(struct sock *sk);
 #ifdef CONFIG_BPF_SYSCALL
 	int			(*psock_update_sk_prot)(struct sock *sk,
 							struct sk_psock *psock,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 5d18d32557d2..8784e72d4b8b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -531,6 +531,8 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 			err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
 			if (err) {
 				inet->inet_saddr = inet->inet_rcv_saddr = 0;
+				if (sk->sk_prot->get_port)
+					sk->sk_prot->put_port(sk);
 				goto out_release_sock;
 			}
 		}
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index e540b0dcf085..0e56df3a45e2 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -994,6 +994,7 @@ struct proto ping_prot = {
 	.hash =		ping_hash,
 	.unhash =	ping_unhash,
 	.get_port =	ping_get_port,
+	.put_port =	ping_unhash,
 	.obj_size =	sizeof(struct inet_sock),
 };
 EXPORT_SYMBOL(ping_prot);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 03dc4c79b84b..0ffb5b5779c0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3082,6 +3082,7 @@ struct proto tcp_prot = {
 	.hash			= inet_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
+	.put_port		= inet_put_port,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= tcp_bpf_update_proto,
 #endif
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index f376c777e8fc..c87e3888c8f8 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2926,6 +2926,7 @@ struct proto udp_prot = {
 	.unhash			= udp_lib_unhash,
 	.rehash			= udp_v4_rehash,
 	.get_port		= udp_v4_get_port,
+	.put_port		= udp_lib_unhash,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= udp_bpf_update_proto,
 #endif
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d1636425654e..ddfc6821e682 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -413,6 +413,8 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 			if (err) {
 				sk->sk_ipv6only = saved_ipv6only;
 				inet_reset_saddr(sk);
+				if (sk->sk_prot->get_port)
+					sk->sk_prot->put_port(sk);
 				goto out;
 			}
 		}
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 6ac88fe24a8e..9256f6ba87ef 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -177,6 +177,7 @@ struct proto pingv6_prot = {
 	.hash =		ping_hash,
 	.unhash =	ping_unhash,
 	.get_port =	ping_get_port,
+	.put_port =	ping_unhash,
 	.obj_size =	sizeof(struct raw6_sock),
 };
 EXPORT_SYMBOL_GPL(pingv6_prot);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1ac243d18c2b..075ee8a2df3b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2181,6 +2181,7 @@ struct proto tcpv6_prot = {
 	.hash			= inet6_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
+	.put_port		= inet_put_port,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= tcp_bpf_update_proto,
 #endif
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 01e53eb4875a..cd402bdf9eed 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1731,6 +1731,7 @@ struct proto udpv6_prot = {
 	.unhash			= udp_lib_unhash,
 	.rehash			= udp_v6_rehash,
 	.get_port		= udp_v6_get_port,
+	.put_port		= udp_lib_unhash,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= udp_bpf_update_proto,
 #endif
-- 
2.30.2

