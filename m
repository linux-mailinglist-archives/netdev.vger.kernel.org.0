Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6E1D8B36
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgERWqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:46:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:57858 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgERWqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 18:46:02 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jaoWD-0000c6-Gg; Tue, 19 May 2020 00:45:57 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, rdna@fb.com,
        sdf@google.com, andrii.nakryiko@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 1/4] bpf: add get{peer,sock}name attach types for sock_addr
Date:   Tue, 19 May 2020 00:45:45 +0200
Message-Id: <61a479d759b2482ae3efb45546490bacd796a220.1589841594.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1589841594.git.daniel@iogearbox.net>
References: <cover.1589841594.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25816/Mon May 18 14:17:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in 983695fa6765 ("bpf: fix unconnected udp hooks"), the objective
for the existing cgroup connect/sendmsg/recvmsg/bind BPF hooks is to be
transparent to applications. In Cilium we make use of these hooks [0] in
order to enable E-W load balancing for existing Kubernetes service types
for all Cilium managed nodes in the cluster. Those backends can be local
or remote. The main advantage of this approach is that it operates as close
as possible to the socket, and therefore allows to avoid packet-based NAT
given in connect/sendmsg/recvmsg hooks we only need to xlate sock addresses.

This also allows to expose NodePort services on loopback addresses in the
host namespace, for example. As another advantage, this also efficiently
blocks bind requests for applications in the host namespace for exposed
ports. However, one missing item is that we also need to perform reverse
xlation for inet{,6}_getname() hooks such that we can return the service
IP/port tuple back to the application instead of the remote peer address.

The vast majority of applications does not bother about getpeername(), but
in a few occasions we've seen breakage when validating the peer's address
since it returns unexpectedly the backend tuple instead of the service one.
Therefore, this trivial patch allows to customise and adds a getpeername()
as well as getsockname() BPF cgroup hook for both IPv4 and IPv6 in order
to address this situation.

Simple example:

  # ./cilium/cilium service list
  ID   Frontend     Service Type   Backend
  1    1.2.3.4:80   ClusterIP      1 => 10.0.0.10:80

Before; curl's verbose output example, no getpeername() reverse xlation:

  # curl --verbose 1.2.3.4
  * Rebuilt URL to: 1.2.3.4/
  *   Trying 1.2.3.4...
  * TCP_NODELAY set
  * Connected to 1.2.3.4 (10.0.0.10) port 80 (#0)
  > GET / HTTP/1.1
  > Host: 1.2.3.4
  > User-Agent: curl/7.58.0
  > Accept: */*
  [...]

After; with getpeername() reverse xlation:

  # curl --verbose 1.2.3.4
  * Rebuilt URL to: 1.2.3.4/
  *   Trying 1.2.3.4...
  * TCP_NODELAY set
  * Connected to 1.2.3.4 (1.2.3.4) port 80 (#0)
  > GET / HTTP/1.1
  >  Host: 1.2.3.4
  > User-Agent: curl/7.58.0
  > Accept: */*
  [...]

Originally, I had both under a BPF_CGROUP_INET{4,6}_GETNAME type and exposed
peer to the context similar as in inet{,6}_getname() fashion, but API-wise
this is suboptimal as it always enforces programs having to test for ctx->peer
which can easily be missed, hence BPF_CGROUP_INET{4,6}_GET{PEER,SOCK}NAME split.
Similarly, the checked return code is on tnum_range(1, 1), but if a use case
comes up in future, it can easily be changed to return an error code instead.
Helper and ctx member access is the same as with connect/sendmsg/etc hooks.

  [0] https://github.com/cilium/cilium/blob/master/bpf/bpf_sock.c

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Andrey Ignatov <rdna@fb.com>
---
 include/linux/bpf-cgroup.h     |  1 +
 include/uapi/linux/bpf.h       |  4 ++++
 kernel/bpf/syscall.c           | 12 ++++++++++++
 kernel/bpf/verifier.c          |  6 +++++-
 net/core/filter.c              |  4 ++++
 net/ipv4/af_inet.c             |  8 ++++++--
 net/ipv6/af_inet6.c            |  9 ++++++---
 tools/include/uapi/linux/bpf.h |  4 ++++
 8 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 272626cc3fc9..c66c545e161a 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -396,6 +396,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 }
 
 #define cgroup_bpf_enabled (0)
+#define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, type, t_ctx) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b9b8a0f63b91..97e1fd19ff58 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -220,6 +220,10 @@ enum bpf_attach_type {
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
 	BPF_TRACE_ITER,
+	BPF_CGROUP_INET4_GETPEERNAME,
+	BPF_CGROUP_INET6_GETPEERNAME,
+	BPF_CGROUP_INET4_GETSOCKNAME,
+	BPF_CGROUP_INET6_GETSOCKNAME,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 57dfc98289d5..431241c74614 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1978,6 +1978,10 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_INET6_CONNECT:
+		case BPF_CGROUP_INET4_GETPEERNAME:
+		case BPF_CGROUP_INET6_GETPEERNAME:
+		case BPF_CGROUP_INET4_GETSOCKNAME:
+		case BPF_CGROUP_INET6_GETSOCKNAME:
 		case BPF_CGROUP_UDP4_SENDMSG:
 		case BPF_CGROUP_UDP6_SENDMSG:
 		case BPF_CGROUP_UDP4_RECVMSG:
@@ -2767,6 +2771,10 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_INET6_BIND:
 	case BPF_CGROUP_INET4_CONNECT:
 	case BPF_CGROUP_INET6_CONNECT:
+	case BPF_CGROUP_INET4_GETPEERNAME:
+	case BPF_CGROUP_INET6_GETPEERNAME:
+	case BPF_CGROUP_INET4_GETSOCKNAME:
+	case BPF_CGROUP_INET6_GETSOCKNAME:
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
 	case BPF_CGROUP_UDP4_RECVMSG:
@@ -2912,6 +2920,10 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_INET6_POST_BIND:
 	case BPF_CGROUP_INET4_CONNECT:
 	case BPF_CGROUP_INET6_CONNECT:
+	case BPF_CGROUP_INET4_GETPEERNAME:
+	case BPF_CGROUP_INET6_GETPEERNAME:
+	case BPF_CGROUP_INET4_GETSOCKNAME:
+	case BPF_CGROUP_INET6_GETSOCKNAME:
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
 	case BPF_CGROUP_UDP4_RECVMSG:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9c7d67d65d8c..2ed8351f47a4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7094,7 +7094,11 @@ static int check_return_code(struct bpf_verifier_env *env)
 	switch (env->prog->type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 		if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
-		    env->prog->expected_attach_type == BPF_CGROUP_UDP6_RECVMSG)
+		    env->prog->expected_attach_type == BPF_CGROUP_UDP6_RECVMSG ||
+		    env->prog->expected_attach_type == BPF_CGROUP_INET4_GETPEERNAME ||
+		    env->prog->expected_attach_type == BPF_CGROUP_INET6_GETPEERNAME ||
+		    env->prog->expected_attach_type == BPF_CGROUP_INET4_GETSOCKNAME ||
+		    env->prog->expected_attach_type == BPF_CGROUP_INET6_GETSOCKNAME)
 			range = tnum_range(1, 1);
 		break;
 	case BPF_PROG_TYPE_CGROUP_SKB:
diff --git a/net/core/filter.c b/net/core/filter.c
index 822d662f97ef..bd2853d23b50 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7049,6 +7049,8 @@ static bool sock_addr_is_valid_access(int off, int size,
 		switch (prog->expected_attach_type) {
 		case BPF_CGROUP_INET4_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
+		case BPF_CGROUP_INET4_GETPEERNAME:
+		case BPF_CGROUP_INET4_GETSOCKNAME:
 		case BPF_CGROUP_UDP4_SENDMSG:
 		case BPF_CGROUP_UDP4_RECVMSG:
 			break;
@@ -7060,6 +7062,8 @@ static bool sock_addr_is_valid_access(int off, int size,
 		switch (prog->expected_attach_type) {
 		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET6_CONNECT:
+		case BPF_CGROUP_INET6_GETPEERNAME:
+		case BPF_CGROUP_INET6_GETSOCKNAME:
 		case BPF_CGROUP_UDP6_SENDMSG:
 		case BPF_CGROUP_UDP6_RECVMSG:
 			break;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index fcf0d12a407a..8f5c8c9409d3 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -755,12 +755,11 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 }
 EXPORT_SYMBOL(inet_accept);
 
-
 /*
  *	This does both peername and sockname.
  */
 int inet_getname(struct socket *sock, struct sockaddr *uaddr,
-			int peer)
+		 int peer)
 {
 	struct sock *sk		= sock->sk;
 	struct inet_sock *inet	= inet_sk(sk);
@@ -781,6 +780,11 @@ int inet_getname(struct socket *sock, struct sockaddr *uaddr,
 		sin->sin_port = inet->inet_sport;
 		sin->sin_addr.s_addr = addr;
 	}
+	if (cgroup_bpf_enabled)
+		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
+					    peer ? BPF_CGROUP_INET4_GETPEERNAME :
+						   BPF_CGROUP_INET4_GETSOCKNAME,
+					    NULL);
 	memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
 	return sizeof(*sin);
 }
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 771a462a8322..3b6fcc0c321a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -504,9 +504,8 @@ EXPORT_SYMBOL_GPL(inet6_destroy_sock);
 /*
  *	This does both peername and sockname.
  */
-
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
-		 int peer)
+		  int peer)
 {
 	struct sockaddr_in6 *sin = (struct sockaddr_in6 *)uaddr;
 	struct sock *sk = sock->sk;
@@ -531,9 +530,13 @@ int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
 			sin->sin6_addr = np->saddr;
 		else
 			sin->sin6_addr = sk->sk_v6_rcv_saddr;
-
 		sin->sin6_port = inet->inet_sport;
 	}
+	if (cgroup_bpf_enabled)
+		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
+					    peer ? BPF_CGROUP_INET6_GETPEERNAME :
+						   BPF_CGROUP_INET6_GETSOCKNAME,
+					    NULL);
 	sin->sin6_scope_id = ipv6_iface_scope_id(&sin->sin6_addr,
 						 sk->sk_bound_dev_if);
 	return sizeof(*sin);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 146c742f1d49..1cddc398404a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -220,6 +220,10 @@ enum bpf_attach_type {
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
 	BPF_TRACE_ITER,
+	BPF_CGROUP_INET4_GETPEERNAME,
+	BPF_CGROUP_INET6_GETPEERNAME,
+	BPF_CGROUP_INET4_GETSOCKNAME,
+	BPF_CGROUP_INET6_GETSOCKNAME,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.21.0

