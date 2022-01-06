Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC28485E4B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 02:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344491AbiAFB5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 20:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344496AbiAFB5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 20:57:43 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC561C0611FD;
        Wed,  5 Jan 2022 17:57:43 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c2so1278393pfc.1;
        Wed, 05 Jan 2022 17:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E2ecUMplQVNC6A29lLi9+Ao3qvZ6ZTpS/L9NYSl/HFs=;
        b=Ylu780cmdIT7XS6RIesWXr4bcMY95FwYaSvL/5mAqAirR+oq31jfbQZYmB6pmXxGjU
         0T33yNATsDANC0dG6NJqQDJGBGSeCnUrmyuhKIKmXncxnoTpJ4NeLB1B+b8PmoaefS/d
         YyZdwaXvTOtYUa8MMWvzR7kafyRRFjSbD7UYt4zodcPjHTKyyIHAipVK3eFbVypzq8Ck
         keGNO3cYxnahdI6SN/ZMqFxAtYX8o2vUE4hgcKsGPLytu7RiNodaJ70RrItRZlQec3ne
         qgDpd9W/jcOnWLYpMe5IM/yr1xZNTIYp7hQkiLjj29bfq7eDlIB6hWNU+tehKkw2nQkU
         ID4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E2ecUMplQVNC6A29lLi9+Ao3qvZ6ZTpS/L9NYSl/HFs=;
        b=tu5PWJMxI6/DrMsRniEgh/MQVHCdJJtAGmfN3Jwdw0bDhx/PzvY5dk6eynSIyaXFMu
         kHad0PoWRzavp7lJnyO+QkuXGOpDIn5OihRh3lv2L5zTxf7UrxzlTY/2idJOgqiCHVN/
         XYu6zH/d7QM82WzRcq58S8SRnNapsI9lu4i+kx8BzE+ICvKodcDOm2YtYb2CLOz7aOmq
         mbUBIeZf75zMSjQYsqaZtQKBxFsiqornacZGpcbOb8HVV6QfaE1L0w//bd4rvMh1yP1F
         fLmEzgEybtD9LFXfFpQNm7Lcc/Ri/bgomP9P4Mj8Bv4YxIxz3sX5t+mg2t8b3cP9U4gU
         wthQ==
X-Gm-Message-State: AOAM532msL15649M4gFL/yizILjoUJLma7I3ABo8bt0kNXP9GTRv/Osv
        kP5HxoWNngrK/8wrK8X1YxI=
X-Google-Smtp-Source: ABdhPJxipNYYyY4vTr2nrq8dEa3Pg6oFrd6SuL3iGcMvcARJTxZy37OJOGycs6oYxeqT/aLrkCBgQw==
X-Received: by 2002:a05:6a00:1485:b0:4bb:317a:a909 with SMTP id v5-20020a056a00148500b004bb317aa909mr58752559pfu.29.1641434263261;
        Wed, 05 Jan 2022 17:57:43 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id g21sm330910pfc.75.2022.01.05.17.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 17:57:42 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, edumazet@google.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v4 net-next 1/3] net: bpf: handle return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
Date:   Thu,  6 Jan 2022 09:57:19 +0800
Message-Id: <20220106015721.3038819-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220106015721.3038819-1-imagedong@tencent.com>
References: <20220106015721.3038819-1-imagedong@tencent.com>
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
v3:
- NULL check for sk->sk_prot->put_port

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
index 7b4b4237e6e0..ff9b508d9c5f 100644
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
index f53184767ee7..9c465bac1eb0 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -531,6 +531,8 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 			err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
 			if (err) {
 				inet->inet_saddr = inet->inet_rcv_saddr = 0;
+				if (sk->sk_prot->put_port)
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
index ac10e4cdd8d0..9861786b8336 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3076,6 +3076,7 @@ struct proto tcp_prot = {
 	.hash			= inet_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
+	.put_port		= inet_put_port,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= tcp_bpf_update_proto,
 #endif
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7b18a6f42f18..c2a4411d2b04 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2927,6 +2927,7 @@ struct proto udp_prot = {
 	.unhash			= udp_lib_unhash,
 	.rehash			= udp_v4_rehash,
 	.get_port		= udp_v4_get_port,
+	.put_port		= udp_lib_unhash,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= udp_bpf_update_proto,
 #endif
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d1636425654e..8fe7900f1949 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -413,6 +413,8 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 			if (err) {
 				sk->sk_ipv6only = saved_ipv6only;
 				inet_reset_saddr(sk);
+				if (sk->sk_prot->put_port)
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
index 1accc06abc54..90718a924ca8 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1732,6 +1732,7 @@ struct proto udpv6_prot = {
 	.unhash			= udp_lib_unhash,
 	.rehash			= udp_v6_rehash,
 	.get_port		= udp_v6_get_port,
+	.put_port		= udp_lib_unhash,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= udp_bpf_update_proto,
 #endif
-- 
2.30.2

