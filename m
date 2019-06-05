Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE929365AA
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfFEUlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:41:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:43794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfFEUlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 16:41:11 -0400
Received: from [178.197.249.21] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYcia-0005Bg-D3; Wed, 05 Jun 2019 22:41:08 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     rdna@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martynas Pumputis <m@lambda.lt>
Subject: [PATCH bpf 1/2] bpf: fix unconnected udp hooks
Date:   Wed,  5 Jun 2019 22:40:49 +0200
Message-Id: <3d59d0458a8a3a050d24f81e660fcccde3479a05.1559767053.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25471/Wed Jun  5 10:12:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intention of cgroup bind/connect/sendmsg BPF hooks is to act transparently
to applications as also stated in original motivation in 7828f20e3779 ("Merge
branch 'bpf-cgroup-bind-connect'"). When recently integrating the latter
two hooks into Cilium to enable host based load-balancing with Kubernetes,
I ran into the issue that pods couldn't start up as DNS got broken. Kubernetes
typically sets up DNS as a service and is thus subject to load-balancing.

Upon further debugging, it turns out that the cgroupv2 sendmsg BPF hooks API
is currently insufficent and thus not usable as-is for standard applications
shipped with most distros. To break down the issue we ran into with a simple
example:

  # cat /etc/resolv.conf
  nameserver 147.75.207.207
  nameserver 147.75.207.208

For the purpose of a simple test, we set up above IPs as service IPs and
transparently redirect traffic to a different DNS backend server for that
node:

  # cilium service list
  ID   Frontend            Backend
  1    147.75.207.207:53   1 => 8.8.8.8:53
  2    147.75.207.208:53   1 => 8.8.8.8:53

The attached BPF program is basically selecting one of the backends if the
service IP/port matches on the cgroup hook. DNS breaks here, because the
hooks are not transparent enough to applications which have built-in msg_name
address checks:

  # nslookup 1.1.1.1
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.208#53
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
  [...]
  ;; connection timed out; no servers could be reached

  # dig 1.1.1.1
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.208#53
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
  [...]

  ; <<>> DiG 9.11.3-1ubuntu1.7-Ubuntu <<>> 1.1.1.1
  ;; global options: +cmd
  ;; connection timed out; no servers could be reached

For comparison, if none of the service IPs is used, and we tell nslookup
to use 8.8.8.8 directly it works just fine, of course:

  # nslookup 1.1.1.1 8.8.8.8
  1.1.1.1.in-addr.arpa	name = one.one.one.one.

In order to fix this and thus act more transparent to the application,
this needs reverse translation on recvmsg() side. A minimal fix for this
API is to add similar recvmsg() hooks behind the BPF cgroups static key
such that the program can track state and replace the current sockaddr_in{,6}
with the original service IP. From BPF side, this basically tracks the
service tuple plus socket cookie in an LRU map where the reverse NAT can
then be retrieved via map value as one example. Side-note: the BPF cgroups
static key should be converted to a per-hook static key in future.

Same example after this fix:

  # cilium service list
  ID   Frontend            Backend
  1    147.75.207.207:53   1 => 8.8.8.8:53
  2    147.75.207.208:53   1 => 8.8.8.8:53

Lookups work fine now:

  # nslookup 1.1.1.1
  1.1.1.1.in-addr.arpa    name = one.one.one.one.

  Authoritative answers can be found from:

  # dig 1.1.1.1

  ; <<>> DiG 9.11.3-1ubuntu1.7-Ubuntu <<>> 1.1.1.1
  ;; global options: +cmd
  ;; Got answer:
  ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 51550
  ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

  ;; OPT PSEUDOSECTION:
  ; EDNS: version: 0, flags:; udp: 512
  ;; QUESTION SECTION:
  ;1.1.1.1.                       IN      A

  ;; AUTHORITY SECTION:
  .                       23426   IN      SOA     a.root-servers.net. nstld.verisign-grs.com. 2019052001 1800 900 604800 86400

  ;; Query time: 17 msec
  ;; SERVER: 147.75.207.207#53(147.75.207.207)
  ;; WHEN: Tue May 21 12:59:38 UTC 2019
  ;; MSG SIZE  rcvd: 111

And from an actual packet level it shows that we're using the back end
server when talking via 147.75.207.20{7,8} front end:

  # tcpdump -i any udp
  [...]
  12:59:52.698732 IP foo.42011 > google-public-dns-a.google.com.domain: 18803+ PTR? 1.1.1.1.in-addr.arpa. (38)
  12:59:52.698735 IP foo.42011 > google-public-dns-a.google.com.domain: 18803+ PTR? 1.1.1.1.in-addr.arpa. (38)
  12:59:52.701208 IP google-public-dns-a.google.com.domain > foo.42011: 18803 1/0/0 PTR one.one.one.one. (67)
  12:59:52.701208 IP google-public-dns-a.google.com.domain > foo.42011: 18803 1/0/0 PTR one.one.one.one. (67)
  [...]

In order to be flexible and to have same semantics as in sendmsg BPF
programs, we only allow return codes in [1,1] range. In the sendmsg case
the program is called if msg->msg_name is present which can be the case
in both, connected and unconnected UDP.

The former only relies on the sockaddr_in{,6} passed via connect(2) if
passed msg->msg_name was NULL. Therefore, on recvmsg side, we act in similar
way to call into the BPF program whenever a non-NULL msg->msg_name was
passed independent of sk->sk_state being TCP_ESTABLISHED or not. Note
that for TCP case, the msg->msg_name is ignored in the regular recvmsg
path and therefore not relevant.

For the case of ip{,v6}_recv_error() paths, picked up via MSG_ERRQUEUE,
the hook is not called. This is intentional as it aligns with the same
semantics as in case of TCP cgroup BPF hooks right now. This might be
better addressed in future through a different bpf_attach_type such
that this case can be distinguished from the regular recvmsg paths,
for example.

Fixes: 1cedee13d25a ("bpf: Hooks for sys_sendmsg")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrey Ignatov <rdna@fb.com>
Cc: Martynas Pumputis <m@lambda.lt>
---
 include/linux/bpf-cgroup.h     |  8 ++++++++
 include/uapi/linux/bpf.h       |  2 ++
 kernel/bpf/syscall.c           |  8 ++++++++
 kernel/bpf/verifier.c          | 12 ++++++++----
 net/core/filter.c              |  2 ++
 net/ipv4/udp.c                 |  4 ++++
 net/ipv6/udp.c                 |  4 ++++
 tools/bpf/bpftool/cgroup.c     |  5 ++++-
 tools/include/uapi/linux/bpf.h |  2 ++
 9 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index cb3c6b3..a7f7a98 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -238,6 +238,12 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_UDP6_SENDMSG_LOCK(sk, uaddr, t_ctx)		       \
 	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_UDP6_SENDMSG, t_ctx)
 
+#define BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk, uaddr)			\
+	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_UDP4_RECVMSG, NULL)
+
+#define BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk, uaddr)			\
+	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_UDP6_RECVMSG, NULL)
+
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops)				       \
 ({									       \
 	int __ret = 0;							       \
@@ -339,6 +345,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_INET6_CONNECT_LOCK(sk, uaddr) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK(sk, uaddr, t_ctx) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_UDP6_SENDMSG_LOCK(sk, uaddr, t_ctx) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk, uaddr) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk, uaddr) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(type,major,minor,access) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_SYSCTL(head,table,write,buf,count,pos,nbuf) ({ 0; })
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 63e0cf6..e4114a7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -192,6 +192,8 @@ enum bpf_attach_type {
 	BPF_LIRC_MODE2,
 	BPF_FLOW_DISSECTOR,
 	BPF_CGROUP_SYSCTL,
+	BPF_CGROUP_UDP4_RECVMSG,
+	BPF_CGROUP_UDP6_RECVMSG,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cb5440b..e8ba3a15 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1581,6 +1581,8 @@ bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
 		case BPF_CGROUP_INET6_CONNECT:
 		case BPF_CGROUP_UDP4_SENDMSG:
 		case BPF_CGROUP_UDP6_SENDMSG:
+		case BPF_CGROUP_UDP4_RECVMSG:
+		case BPF_CGROUP_UDP6_RECVMSG:
 			return 0;
 		default:
 			return -EINVAL;
@@ -1875,6 +1877,8 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_CGROUP_INET6_CONNECT:
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
+	case BPF_CGROUP_UDP4_RECVMSG:
+	case BPF_CGROUP_UDP6_RECVMSG:
 		ptype = BPF_PROG_TYPE_CGROUP_SOCK_ADDR;
 		break;
 	case BPF_CGROUP_SOCK_OPS:
@@ -1960,6 +1964,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_CGROUP_INET6_CONNECT:
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
+	case BPF_CGROUP_UDP4_RECVMSG:
+	case BPF_CGROUP_UDP6_RECVMSG:
 		ptype = BPF_PROG_TYPE_CGROUP_SOCK_ADDR;
 		break;
 	case BPF_CGROUP_SOCK_OPS:
@@ -2011,6 +2017,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_INET6_CONNECT:
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
+	case BPF_CGROUP_UDP4_RECVMSG:
+	case BPF_CGROUP_UDP6_RECVMSG:
 	case BPF_CGROUP_SOCK_OPS:
 	case BPF_CGROUP_DEVICE:
 	case BPF_CGROUP_SYSCTL:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 95f93544..d2c8a66 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5361,9 +5361,12 @@ static int check_return_code(struct bpf_verifier_env *env)
 	struct tnum range = tnum_range(0, 1);
 
 	switch (env->prog->type) {
+	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+		if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
+		    env->prog->expected_attach_type == BPF_CGROUP_UDP6_RECVMSG)
+			range = tnum_range(1, 1);
 	case BPF_PROG_TYPE_CGROUP_SKB:
 	case BPF_PROG_TYPE_CGROUP_SOCK:
-	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_SOCK_OPS:
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
@@ -5380,16 +5383,17 @@ static int check_return_code(struct bpf_verifier_env *env)
 	}
 
 	if (!tnum_in(range, reg->var_off)) {
+		char tn_buf[48];
+
 		verbose(env, "At program exit the register R0 ");
 		if (!tnum_is_unknown(reg->var_off)) {
-			char tn_buf[48];
-
 			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
 			verbose(env, "has value %s", tn_buf);
 		} else {
 			verbose(env, "has unknown scalar value");
 		}
-		verbose(env, " should have been 0 or 1\n");
+		tnum_strn(tn_buf, sizeof(tn_buf), range);
+		verbose(env, " should have been in %s\n", tn_buf);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/core/filter.c b/net/core/filter.c
index fdcc504..2814d78 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6748,6 +6748,7 @@ static bool sock_addr_is_valid_access(int off, int size,
 		case BPF_CGROUP_INET4_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_UDP4_SENDMSG:
+		case BPF_CGROUP_UDP4_RECVMSG:
 			break;
 		default:
 			return false;
@@ -6758,6 +6759,7 @@ static bool sock_addr_is_valid_access(int off, int size,
 		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET6_CONNECT:
 		case BPF_CGROUP_UDP6_SENDMSG:
+		case BPF_CGROUP_UDP6_RECVMSG:
 			break;
 		default:
 			return false;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 85db0e3..2d862823 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1783,6 +1783,10 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
 		*addr_len = sizeof(*sin);
+
+		if (cgroup_bpf_enabled)
+			BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
+							(struct sockaddr *)sin);
 	}
 
 	if (udp_sk(sk)->gro_enabled)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4e52c37..15570d7 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -369,6 +369,10 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 						    inet6_iif(skb));
 		}
 		*addr_len = sizeof(*sin6);
+
+		if (cgroup_bpf_enabled)
+			BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk,
+						(struct sockaddr *)sin6);
 	}
 
 	if (udp_sk(sk)->gro_enabled)
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 7e22f11..f3047d1 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -25,7 +25,8 @@
 	"       ATTACH_TYPE := { ingress | egress | sock_create |\n"	       \
 	"                        sock_ops | device | bind4 | bind6 |\n"	       \
 	"                        post_bind4 | post_bind6 | connect4 |\n"       \
-	"                        connect6 | sendmsg4 | sendmsg6 | sysctl }"
+	"                        connect6 | sendmsg4 | sendmsg6 |\n"           \
+	"                        sysctl | recvmsg4 | recvmsg6 }"
 
 static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_INET_INGRESS] = "ingress",
@@ -42,6 +43,8 @@ static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_UDP4_SENDMSG] = "sendmsg4",
 	[BPF_CGROUP_UDP6_SENDMSG] = "sendmsg6",
 	[BPF_CGROUP_SYSCTL] = "sysctl",
+	[BPF_CGROUP_UDP4_RECVMSG] = "recvmsg4",
+	[BPF_CGROUP_UDP6_RECVMSG] = "recvmsg6",
 	[__MAX_BPF_ATTACH_TYPE] = NULL,
 };
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 63e0cf6..e4114a7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -192,6 +192,8 @@ enum bpf_attach_type {
 	BPF_LIRC_MODE2,
 	BPF_FLOW_DISSECTOR,
 	BPF_CGROUP_SYSCTL,
+	BPF_CGROUP_UDP4_RECVMSG,
+	BPF_CGROUP_UDP6_RECVMSG,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.9.5

