Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B752F6F5C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731213AbhAOASI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731141AbhAOASH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 19:18:07 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E38DC0613C1
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 16:17:27 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id q3so6123292qkq.21
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 16:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=ODdspgtKYpLTbgnDdHD8QPVxqFSTF0BpW/GtqLdWnJM=;
        b=phPmEPnH+o1wpe9w2yI4yEpLM5yOKDWNQCZRecEk4hbDK4CBO3aU0AEoN4TDsnhGeS
         jfNUcuvjAcbNaYFhdS11U6ftG11bNppGZXGmANzJaeovZXtcz2MAQJQRiuC0VYFDf1Ez
         nsdiPLRSU6Q6Q1e/TCEWgDG5NYCx05uaN6HxdptrIo94AJbm2JCWGSJSNPgw9JALHXdR
         g8jH+T3o3jJzrnhuvbGQanvIMr01UDj+uFsZdUAUHSNrhugvAUT8mA4a5XWWmbuqRpOm
         NvSeZ8zHYgzD55GbMnhapNIF9EdNYF72hr26or/YYyCkOFdz+6V3OKBQa62xpUepeoHP
         GPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=ODdspgtKYpLTbgnDdHD8QPVxqFSTF0BpW/GtqLdWnJM=;
        b=hLsrqvwQKGsQXy7jEmRxC9+HWduLT5GIxNZCRIriNktWAFsM1L/O5Ik8bMq+ZbTufy
         uY7tRY29y352oghnMvfSpGbHlpTLP2Y6cQkYztbWfIJQFoKZMU3GXmV0GZ92YJwvgcWh
         93B0tgqtBdthPMpBD6kvj7v+LUU0C50+7unmXphyzpSAkH5UJ44JD6Kp+QftXH+aHHPO
         AtqFN2aSMDLs26LcTsU1Q9X6njFw7teOZBamYn16dyKlhJ582CiCnF2q7gpFD+oCl/gE
         7eCPVXJuVplQ5+ENgX9JA7jUg9UbOikT6PQEq3Hj2GEnilvE5VCyDlvflfhHml5XEYk5
         4RXQ==
X-Gm-Message-State: AOAM532qszxyfqYws5teJGZfeRxtAgfqXFrnpMvqhe+ihIMmizwIQcvw
        CLPDO0DmBBBRP4kZe0S9xfHDEPiieDtEtbM+8b9N98tbSxDzMVMfXkLEzZKKfLNZtJRzpajj1cX
        dlBa4jTvp4X1wz1UfcRVj10ZjGiYQYGP+2mcmbCQY8GLPr9yYk4uLRQ==
X-Google-Smtp-Source: ABdhPJz0K8dPcBjfApyvsdDxqqthfAJGWIe5OmafvebVlTexZ+pePn+BjmIB6Q+gdGIaMVKpUw5ClBI=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:fe47:: with SMTP id u7mr9697474qvs.4.1610669846124;
 Thu, 14 Jan 2021 16:17:26 -0800 (PST)
Date:   Thu, 14 Jan 2021 16:17:24 -0800
Message-Id: <1627e0f688c7de7fe291b09c524c7fbb55cfe367.1610669653.git.sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RPC PATCH bpf-next] bpf: implement new BPF_CGROUP_INET_SOCK_POST_CONNECT
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are playing with doing hybrid conntrack where BPF generates
connect/disconnect/etc events and puts them into perfbuf (or, later,
new ringbuf). We can get most of the functionality out of
existing hooks:
- BPF_CGROUP_SOCK_OPS fully covers TCP
- BPF_CGROUP_UDP4_SENDMSG covers unconnected UDP (with sampling, etc)

The only missing bit is connected UDP where we can get some
information from the existing BPF_CGROUP_INET{4,6}_CONNECT if the caller
did explicit bind(); otherwise, in an autobind case, we get
only destination addr/port and no source port because this hook
triggers prior to that.

We'd really like to avoid the cost of BPF_CGROUP_INET_EGRESS
and filtering UDP (which covers both connected and unconnected UDP,
but loses that connect/disconnect pseudo signal).

The proposal is to add a new BPF_CGROUP_INET_SOCK_POST_CONNECT which
triggers right before sys_connect exits in the AF_INET{,6} case.
The context is bpf_sock which lets BPF examine the socket state.
There is really no reason for it to trigger for all inet socks,
I've considered adding BPF_CGROUP_UDP_POST_CONNECT, but decided
that it might be better to have a generic inet case.

New hook triggers right before sys_connect() returns and gives
BPF an opportunity to explore source & destination addresses
as well as ability to return EPERM to the user.

This is somewhat analogous to the existing BPF_CGROUP_INET{4,6}_POST_BIND
hooks with the intention to log the connection addresses (after autobind).

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Change-Id: I46d0122f93c58b17bfae5ba5040b0b0343908c19
---
 include/linux/bpf-cgroup.h | 17 +++++++++++++++++
 include/uapi/linux/bpf.h   |  1 +
 kernel/bpf/syscall.c       |  3 +++
 net/core/filter.c          |  4 ++++
 net/ipv4/af_inet.c         |  7 ++++++-
 5 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 72e69a0e1e8c..f110935258b9 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -213,12 +213,29 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	__ret;								       \
 })
 
+#define BPF_CGROUP_RUN_SK_PROG_LOCKED(sk, type)				       \
+({									       \
+	int __ret = 0;							       \
+	if (cgroup_bpf_enabled) {					       \
+		lock_sock(sk);						       \
+		__ret = __cgroup_bpf_run_filter_sk(sk, type);		       \
+		release_sock(sk);					       \
+	}								       \
+	__ret;								       \
+})
+
 #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk)				       \
 	BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_CREATE)
 
 #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk)			       \
 	BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_RELEASE)
 
+#define BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT(sk)			       \
+	BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_POST_CONNECT)
+
+#define BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT_LOCKED(sk)		       \
+	BPF_CGROUP_RUN_SK_PROG_LOCKED(sk, BPF_CGROUP_INET_SOCK_POST_CONNECT)
+
 #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk)				       \
 	BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET4_POST_BIND)
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a1ad32456f89..3235f7bd131f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -241,6 +241,7 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_CGROUP_INET_SOCK_POST_CONNECT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c3bb03c8371f..7d6fd1e32d22 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1958,6 +1958,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		switch (expected_attach_type) {
 		case BPF_CGROUP_INET_SOCK_CREATE:
 		case BPF_CGROUP_INET_SOCK_RELEASE:
+		case BPF_CGROUP_INET_SOCK_POST_CONNECT:
 		case BPF_CGROUP_INET4_POST_BIND:
 		case BPF_CGROUP_INET6_POST_BIND:
 			return 0;
@@ -2910,6 +2911,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_CGROUP_SKB;
 	case BPF_CGROUP_INET_SOCK_CREATE:
 	case BPF_CGROUP_INET_SOCK_RELEASE:
+	case BPF_CGROUP_INET_SOCK_POST_CONNECT:
 	case BPF_CGROUP_INET4_POST_BIND:
 	case BPF_CGROUP_INET6_POST_BIND:
 		return BPF_PROG_TYPE_CGROUP_SOCK;
@@ -3063,6 +3065,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_INET_EGRESS:
 	case BPF_CGROUP_INET_SOCK_CREATE:
 	case BPF_CGROUP_INET_SOCK_RELEASE:
+	case BPF_CGROUP_INET_SOCK_POST_CONNECT:
 	case BPF_CGROUP_INET4_BIND:
 	case BPF_CGROUP_INET6_BIND:
 	case BPF_CGROUP_INET4_POST_BIND:
diff --git a/net/core/filter.c b/net/core/filter.c
index 9ab94e90d660..d955321d3415 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7683,12 +7683,14 @@ static bool __sock_filter_check_attach_type(int off,
 		switch (attach_type) {
 		case BPF_CGROUP_INET_SOCK_CREATE:
 		case BPF_CGROUP_INET_SOCK_RELEASE:
+		case BPF_CGROUP_INET_SOCK_POST_CONNECT:
 			goto full_access;
 		default:
 			return false;
 		}
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
 		switch (attach_type) {
+		case BPF_CGROUP_INET_SOCK_POST_CONNECT:
 		case BPF_CGROUP_INET4_POST_BIND:
 			goto read_only;
 		default:
@@ -7696,6 +7698,7 @@ static bool __sock_filter_check_attach_type(int off,
 		}
 	case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
 		switch (attach_type) {
+		case BPF_CGROUP_INET_SOCK_POST_CONNECT:
 		case BPF_CGROUP_INET6_POST_BIND:
 			goto read_only;
 		default:
@@ -7703,6 +7706,7 @@ static bool __sock_filter_check_attach_type(int off,
 		}
 	case bpf_ctx_range(struct bpf_sock, src_port):
 		switch (attach_type) {
+		case BPF_CGROUP_INET_SOCK_POST_CONNECT:
 		case BPF_CGROUP_INET4_POST_BIND:
 		case BPF_CGROUP_INET6_POST_BIND:
 			goto read_only;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b94fa8eb831b..568654cafa48 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -574,7 +574,10 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	if (!inet_sk(sk)->inet_num && inet_autobind(sk))
 		return -EAGAIN;
-	return sk->sk_prot->connect(sk, uaddr, addr_len);
+	err = sk->sk_prot->connect(sk, uaddr, addr_len);
+	if (!err)
+		err = BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT_LOCKED(sk);
+	return err;
 }
 EXPORT_SYMBOL(inet_dgram_connect);
 
@@ -723,6 +726,8 @@ int inet_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	lock_sock(sock->sk);
 	err = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);
+	if (!err)
+		err = BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT(sock->sk);
 	release_sock(sock->sk);
 	return err;
 }
-- 
2.30.0.284.gd98b1dd5eaa7-goog

