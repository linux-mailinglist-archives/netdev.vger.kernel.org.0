Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272AE481120
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 09:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbhL2I4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 03:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239391AbhL2Iz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 03:55:59 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4163DC061574;
        Wed, 29 Dec 2021 00:55:59 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 200so18005681pgg.3;
        Wed, 29 Dec 2021 00:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CojBklWGILi2WOy9ZfbDG8WxJjzhbG74FmACP+7Zafc=;
        b=eWIGA/2CtG4tzY6AKN3WCSJ0utEcKoaSdY9eO+vsRiTTTZKDM4hqGribr+6y+kPS/3
         6XoJyFb+O3VcInk57WGoEedlPFqgdVkmyqSZwN8g603Vm1Vmyx3zUbt9p0VGoutCRk2j
         r7YhOAG5ZvNWzsxjvFBgInrr5B/er+VqWznWmuuaCB8rZ5qZP6rLpIGIhnXF6Manf5UP
         +OyhlYKw07+eMwaA6FsIyneE2Qm8ARW0o2fzjIe0pkcZ8Sy6PLO/2f/fqUOQZJsZmkpV
         dSFF+agcts7TxtGQTmm80qL1R3UfFmmjH7NglTCeIoN5IJnyfljowRlOwlTfWDphUlG7
         RD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CojBklWGILi2WOy9ZfbDG8WxJjzhbG74FmACP+7Zafc=;
        b=SuVDusZHB7gvag3uMYTtTjT1APM3D5qpwt3/MH8YEnz/aznoUJsu0ze5uzQV0vPqpS
         mo9s5UabJd/I/K11ExhExp1GAUsczenOWQsGjMkkoDDI9S5w0wmcTDLAcKNa793jBeF9
         Snj9N658d5oy8ZuuU/jQivj1BQsERPvGxtHOJkengMe3nIY6lACEOFuIw92CRbxBFlZZ
         E5mQBSbVqc0qZ3evTsq2wae/bxO7M6/15oxn3ShKk/RLLz9/v13rnTR49DGToz6A7jnd
         zkejx2gHV8uOKsBxA0WPO0zbg0dISLwSoYU5RD4Plev9PF5POKMrGclxzyJIy0Ws3AN1
         95Yw==
X-Gm-Message-State: AOAM5311AWR7nozQFTnFqgnQ5M7+QNCkcV6g289VR8aUqTDe8E8mkiDF
        69xWJN6eOJGgt0KuN7d8N/I=
X-Google-Smtp-Source: ABdhPJwLzoLFxo9VmOyeh9slcPq0pWe3W/z8qMM0AF96Cf1A0j/4GU4IUUWMNgx1kmDN8lMeqf7MQQ==
X-Received: by 2002:aa7:8d99:0:b0:4bb:8e5e:9ae4 with SMTP id i25-20020aa78d99000000b004bb8e5e9ae4mr23910474pfr.68.1640768158782;
        Wed, 29 Dec 2021 00:55:58 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id lk10sm26467714pjb.20.2021.12.29.00.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 00:55:58 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next] net: bpf: hook for inet port bind conflict check
Date:   Wed, 29 Dec 2021 16:55:47 +0800
Message-Id: <20211229085547.206008-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

This hook of cgroup is called while TCP/UDP local port bind conflict
check. This is different from the 'commit aac3fc320d94 ("bpf: Post-hooks
for sys_bind")', as it is also called in autobind case.

For TCP, this hook is called during sys_bind() and autobind. And it
is also called during tcp_v4_connect() before hash the sock to ehash,
during which src ip, src port, dst ip, and dst port is already
allocated, means that we have a chance to determine whether this
connect should continue.

This can be useful when we want some applications not to use some
port (include auto bind port). For autobind, the kernel has the chance
to choose another port.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/bpf-cgroup.h      |  5 +++++
 include/net/inet_sock.h         | 11 +++++++++++
 include/uapi/linux/bpf.h        |  1 +
 kernel/bpf/syscall.c            |  3 +++
 net/ipv4/inet_connection_sock.c | 10 ++++++++--
 net/ipv4/inet_hashtables.c      |  8 ++++++++
 net/ipv4/udp.c                  | 19 +++++++++++++++----
 7 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 11820a430d6c..c81180a2936e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -48,6 +48,7 @@ enum cgroup_bpf_attach_type {
 	CGROUP_INET4_GETSOCKNAME,
 	CGROUP_INET6_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
+	CGROUP_INET_LPORT_INUSE,
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
@@ -81,6 +82,7 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_type)
 	CGROUP_ATYPE(CGROUP_INET4_GETSOCKNAME);
 	CGROUP_ATYPE(CGROUP_INET6_GETSOCKNAME);
 	CGROUP_ATYPE(CGROUP_INET_SOCK_RELEASE);
+	CGROUP_ATYPE(CGROUP_INET_LPORT_INUSE);
 	default:
 		return CGROUP_BPF_ATTACH_TYPE_INVALID;
 	}
@@ -263,6 +265,9 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk)				       \
 	BPF_CGROUP_RUN_SK_PROG(sk, CGROUP_INET6_POST_BIND)
 
+#define BPF_CGROUP_RUN_PROG_INET_LPORT_INUSE(sk)			       \
+	BPF_CGROUP_RUN_SK_PROG(sk, CGROUP_INET_LPORT_INUSE)
+
 #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)				       \
 ({									       \
 	u32 __unused_flags;						       \
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 234d70ae5f4c..3a2a8784bffb 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -298,6 +298,17 @@ static inline void __inet_sk_copy_descendant(struct sock *sk_to,
 
 int inet_sk_rebuild_header(struct sock *sk);
 
+static inline int inet_bind_conflict(struct sock *sk, int port)
+{
+	int res;
+	int old = sk->sk_num;
+
+	sk->sk_num = port;
+	res = BPF_CGROUP_RUN_PROG_INET_LPORT_INUSE(sk);
+	sk->sk_num = old;
+	return res;
+}
+
 /**
  * inet_sk_state_load - read sk->sk_state for lockless contexts
  * @sk: socket pointer
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c26871263f1f..849b37bfa3b2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -995,6 +995,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_CGROUP_INET_LPORT_INUSE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ddd81d543203..bec7f49eb0a9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2088,6 +2088,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		case BPF_CGROUP_INET_SOCK_RELEASE:
 		case BPF_CGROUP_INET4_POST_BIND:
 		case BPF_CGROUP_INET6_POST_BIND:
+		case BPF_CGROUP_INET_LPORT_INUSE:
 			return 0;
 		default:
 			return -EINVAL;
@@ -3140,6 +3141,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_INET_SOCK_RELEASE:
 	case BPF_CGROUP_INET4_POST_BIND:
 	case BPF_CGROUP_INET6_POST_BIND:
+	case BPF_CGROUP_INET_LPORT_INUSE:
 		return BPF_PROG_TYPE_CGROUP_SOCK;
 	case BPF_CGROUP_INET4_BIND:
 	case BPF_CGROUP_INET6_BIND:
@@ -3311,6 +3313,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SYSCTL:
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
+	case BPF_CGROUP_INET_LPORT_INUSE:
 		return cgroup_bpf_prog_query(attr, uattr);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fc2a985f6064..1cf4f374e7e4 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -130,10 +130,11 @@ void inet_get_local_port_range(struct net *net, int *low, int *high)
 }
 EXPORT_SYMBOL(inet_get_local_port_range);
 
-static int inet_csk_bind_conflict(const struct sock *sk,
+static int inet_csk_bind_conflict(struct sock *sk,
 				  const struct inet_bind_bucket *tb,
 				  bool relax, bool reuseport_ok)
 {
+	int res;
 	struct sock *sk2;
 	bool reuseport_cb_ok;
 	bool reuse = sk->sk_reuse;
@@ -179,7 +180,10 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 			}
 		}
 	}
-	return sk2 != NULL;
+	res = !!sk2;
+	if (!res)
+		res = inet_bind_conflict(sk, tb->port);
+	return res;
 }
 
 /*
@@ -401,6 +405,8 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 			goto success;
 		if (inet_csk_bind_conflict(sk, tb, true, true))
 			goto fail_unlock;
+	} else if (inet_bind_conflict(sk, port)) {
+		goto fail_unlock;
 	}
 success:
 	inet_csk_update_fastreuse(tb, sk);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 30ab717ff1b8..9cf3efe7be48 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -476,6 +476,9 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 		}
 	}
 
+	if (inet_bind_conflict(sk, lport))
+		goto not_unique;
+
 	/* Must record num and sport now. Otherwise we will see
 	 * in hash table socket with a funny identity.
 	 */
@@ -744,6 +747,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		tb = inet_csk(sk)->icsk_bind_hash;
 		spin_lock_bh(&head->lock);
 		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
+			if (inet_bind_conflict(sk, port))
+				return -EPERM;
 			inet_ehash_nolisten(sk, NULL, NULL);
 			spin_unlock_bh(&head->lock);
 			return 0;
@@ -799,6 +804,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 			}
 		}
 
+		if (inet_bind_conflict(sk, port))
+			goto next_port;
+
 		tb = inet_bind_bucket_create(hinfo->bind_bucket_cachep,
 					     net, head, port, l3mdev);
 		if (!tb) {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index f376c777e8fc..95ef1b47386d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -134,6 +134,7 @@ static int udp_lib_lport_inuse(struct net *net, __u16 num,
 			       struct sock *sk, unsigned int log)
 {
 	struct sock *sk2;
+	int res = 0;
 	kuid_t uid = sock_i_uid(sk);
 
 	sk_for_each(sk2, &hslot->head) {
@@ -148,16 +149,21 @@ static int udp_lib_lport_inuse(struct net *net, __u16 num,
 			    !rcu_access_pointer(sk->sk_reuseport_cb) &&
 			    uid_eq(uid, sock_i_uid(sk2))) {
 				if (!bitmap)
-					return 0;
+					break;
 			} else {
-				if (!bitmap)
-					return 1;
+				if (!bitmap) {
+					res = 1;
+					break;
+				}
 				__set_bit(udp_sk(sk2)->udp_port_hash >> log,
 					  bitmap);
 			}
 		}
 	}
-	return 0;
+
+	if (!res)
+		res = inet_bind_conflict(sk, num);
+	return res;
 }
 
 /*
@@ -192,6 +198,11 @@ static int udp_lib_lport_inuse2(struct net *net, __u16 num,
 		}
 	}
 	spin_unlock(&hslot2->lock);
+	if (!res) {
+		sk->sk_num = num;
+		res = BPF_CGROUP_RUN_PROG_INET_LPORT_INUSE(sk);
+		sk->sk_num = 0;
+	}
 	return res;
 }
 
-- 
2.30.2

