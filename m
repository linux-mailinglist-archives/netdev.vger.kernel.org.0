Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6A56D538F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbjDCVfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjDCVev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:34:51 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D4B2738
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:33 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j24so30832227wrd.0
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3wZbNUk9VZhzjkPKOaAe1hkPMVHX+JdeKJhBkOMC5A=;
        b=RjqD292Q2kGD8Ta6tv2HYnUkPDhVuH7sW+sE0nNwHgcPZhKpQ5AwY93x35MwvGuWAU
         7BVZL4pepX8gB1LEGMTuaB9r+3OnX9VQ1q7ZJHxwyObEAo90xXqY9izRUKUl25cPVpBN
         LjRB5H5yXw2vOkb2/yz4SxfIScrUO+mKoJQsZ1xU6BK8uJI2n/L8F98iWPHt5a9yMvYI
         6PmrJxNiMmGwPYwCUqgSP982+bxEdSuYPa91qJUhev5MgH9f/FYIH9Z9xxM5Jp8ZYyWF
         yNdp00EwHVjXqNjxu/9n7GvU1tiT8aAozkVsASkO9cKKI4m+RX4DNCIZPztPVzCo6Juo
         rUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3wZbNUk9VZhzjkPKOaAe1hkPMVHX+JdeKJhBkOMC5A=;
        b=nkT9ItASsn8XRChlqQRUdOhdDqNe+YQy5okEeRSj1AdmeDLHblCP/M91Oz7kxYAEJI
         nJrdW12UXJwqZBXHvsKKziK/or1ryKlr6MTxHtkWVz/7mcWBIf3pxDvLY8GQraLY6EW+
         k0Lmwxcd2P1yzUCR85gRwu3b6SxdebXsoN4tcOSHZSiYU0xLC4kyOa3lpckbugA+ot8Y
         TQguiAFk75zUGSIJNZCc7JAYQeJtxgdmsGVWhEYYzBWoMDuDgDGT4ag+qFzoGk44hYFG
         aXMDzzCAnzbYvHn5Hva1CKILVli5ipbbaY9NOIyF2XB+LbfaDCNlneAjv58fO4616zmM
         pL9g==
X-Gm-Message-State: AAQBX9ejaz6ejvjhWAPyUMLR6ukdWRVhuSEfGx6Dotoh3FiNPrw1DLE1
        l0LA4hL/veKIzx2qg34y6Bs/kg==
X-Google-Smtp-Source: AKy350ZDkdBy4YDh6mUBDCMsdaVeYIfKWJ7ggBB5V16Z67U4zvuRyY7LzrEtI0hZnPOUA3JmL+TIRg==
X-Received: by 2002:a5d:500a:0:b0:2cb:29eb:a35e with SMTP id e10-20020a5d500a000000b002cb29eba35emr14740379wrt.11.1680557671522;
        Mon, 03 Apr 2023 14:34:31 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:31 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v5 03/21] net/tcp: Introduce TCP_AO setsockopt()s
Date:   Mon,  3 Apr 2023 22:34:02 +0100
Message-Id: <20230403213420.1576559-4-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403213420.1576559-1-dima@arista.com>
References: <20230403213420.1576559-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 3 setsockopt()s:
1. TCP_AO_ADD_KEY to add a new Master Key Tuple (MKT) on a socket
2. TCP_AO_DEL_KEY to delete present MKT from a socket
3. TCP_AO_INFO to change flags, Current_key/RNext_key on a TCP-AO sk

Userspace has to introduce keys on every socket it wants to use TCP-AO
option on, similarly to TCP_MD5SIG/TCP_MD5SIG_EXT.
RFC5925 prohibits definition of MKTs that would match the same peer,
so do sanity checks on the data provided by userspace. Be as
conservative as possible, including refusal of defining MKT on
an established connection with no AO, removing the key in-use and etc.

(1) and (2) are to be used by userspace key manager to add/remove keys.
(3) main purpose is to set RNext_key, which (as prescribed by RFC5925)
is the KeyID that will be requested in TCP-AO header from the peer to
sign their segments with.

At this moment the life of ao_info ends in tcp_v4_destroy_sock().

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/sockptr.h  |  23 ++
 include/net/tcp.h        |   6 +
 include/net/tcp_ao.h     |  18 +-
 include/uapi/linux/tcp.h |  46 +++
 net/ipv4/Makefile        |   1 +
 net/ipv4/tcp.c           |  17 +
 net/ipv4/tcp_ao.c        | 777 +++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      |  10 +-
 net/ipv6/Makefile        |   1 +
 net/ipv6/tcp_ao.c        |  20 +
 net/ipv6/tcp_ipv6.c      |  39 +-
 11 files changed, 940 insertions(+), 18 deletions(-)
 create mode 100644 net/ipv4/tcp_ao.c
 create mode 100644 net/ipv6/tcp_ao.c

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index bae5e2369b4f..307961b41541 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -55,6 +55,29 @@ static inline int copy_from_sockptr(void *dst, sockptr_t src, size_t size)
 	return copy_from_sockptr_offset(dst, src, 0, size);
 }
 
+static inline int copy_struct_from_sockptr(void *dst, size_t ksize,
+		sockptr_t src, size_t usize)
+{
+	size_t size = min(ksize, usize);
+	size_t rest = max(ksize, usize) - size;
+
+	if (!sockptr_is_kernel(src))
+		return copy_struct_from_user(dst, ksize, src.user, size);
+
+	if (usize < ksize) {
+		memset(dst + size, 0, rest);
+	} else if (usize > ksize) {
+		char *p = src.kernel;
+
+		while (rest--) {
+			if (*p++)
+				return -E2BIG;
+		}
+	}
+	memcpy(dst, src.kernel, size);
+	return 0;
+}
+
 static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,
 		const void *src, size_t size)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 8f6c0b7c8678..4846de329045 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2093,6 +2093,12 @@ struct tcp_sock_af_ops {
 				     sockptr_t optval,
 				     int optlen);
 #endif
+#ifdef CONFIG_TCP_AO
+	int			(*ao_parse)(struct sock *sk,
+					    int optname,
+					    sockptr_t optval,
+					    int optlen);
+#endif
 };
 
 struct tcp_request_sock_ops {
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 234ae371043b..916df79450e0 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -83,7 +83,8 @@ struct tcp_ao_info {
 	 */
 	struct tcp_ao_key	*current_key;
 	struct tcp_ao_key	*rnext_key;
-	u32			flags;
+	u32			ao_required	:1,
+				__unused	:31;
 	__be32			lisn;
 	__be32			risn;
 	u32			snd_sne;
@@ -93,4 +94,19 @@ struct tcp_ao_info {
 	struct rcu_head		rcu;
 };
 
+#ifdef CONFIG_TCP_AO
+int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
+		 sockptr_t optval, int optlen);
+void tcp_ao_destroy_sock(struct sock *sk);
+/* ipv4 specific functions */
+int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
+/* ipv6 specific functions */
+int tcp_v6_parse_ao(struct sock *sk, int cmd,
+		    sockptr_t optval, int optlen);
+#else
+static inline void tcp_ao_destroy_sock(struct sock *sk)
+{
+}
+#endif
+
 #endif /* _TCP_AO_H */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 5655bfe28b8d..250e0ce2cc38 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -129,6 +129,9 @@ enum {
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
 
+#define TCP_AO_ADD_KEY		38	/* Add/Set MKT */
+#define TCP_AO_DEL_KEY		39	/* Delete MKT */
+#define TCP_AO_INFO		40	/* Modify TCP-AO per-socket options */
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
@@ -350,6 +353,49 @@ struct tcp_diag_md5sig {
 
 #define TCP_AO_MAXKEYLEN	80
 
+#define TCP_AO_KEYF_IFINDEX	(1 << 0)	/* L3 ifindex for VRF */
+
+struct tcp_ao_add { /* setsockopt(TCP_AO_ADD_KEY) */
+	struct __kernel_sockaddr_storage addr;	/* peer's address for the key */
+	char	alg_name[64];		/* crypto hash algorithm to use */
+	__s32	ifindex;		/* L3 dev index for VRF */
+	__u32   set_current	:1,	/* set key as Current_key at once */
+		set_rnext	:1,	/* request it from peer with RNext_key */
+		reserved	:30;	/* must be 0 */
+	__u16	reserved2;		/* padding, must be 0 */
+	__u8	prefix;			/* peer's address prefix */
+	__u8	sndid;			/* SendID for outgoing segments */
+	__u8	rcvid;			/* RecvID to match for incoming seg */
+	__u8	maclen;			/* length of authentication code (hash) */
+	__u8	keyflags;		/* see TCP_AO_KEYF_ */
+	__u8	keylen;			/* length of ::key */
+	__u8	key[TCP_AO_MAXKEYLEN];
+} __attribute__((aligned(8)));
+
+struct tcp_ao_del { /* setsockopt(TCP_AO_DEL_KEY) */
+	struct __kernel_sockaddr_storage addr;	/* peer's address for the key */
+	__s32	ifindex;		/* L3 dev index for VRF */
+	__u32   set_current	:1,	/* corresponding ::current_key */
+		set_rnext	:1,	/* corresponding ::rnext */
+		reserved	:30;	/* must be 0 */
+	__u16	reserved2;		/* padding, must be 0 */
+	__u8	prefix;			/* peer's address prefix */
+	__u8	sndid;			/* SendID for outgoing segments */
+	__u8	rcvid;			/* RecvID to match for incoming seg */
+	__u8	current_key;		/* KeyID to set as Current_key */
+	__u8	rnext;			/* KeyID to set as Rnext_key */
+	__u8	keyflags;		/* see TCP_AO_KEYF_ */
+} __attribute__((aligned(8)));
+
+struct tcp_ao_info_opt { /* setsockopt(TCP_AO_INFO) */
+	__u32   set_current	:1,	/* corresponding ::current_key */
+		set_rnext	:1,	/* corresponding ::rnext */
+		ao_required	:1,	/* don't accept non-AO connects */
+		reserved	:29;	/* must be 0 */
+	__u8	current_key;		/* KeyID to set as Current_key */
+	__u8	rnext;			/* KeyID to set as Rnext_key */
+} __attribute__((aligned(8)));
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 035f3ad733c0..f43c470fd0de 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o xfrm4_protocol.o
+obj-$(CONFIG_TCP_AO) += tcp_ao.o
 
 ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) += bpf_tcp_ca.o
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 055ce5fbc425..62484cff7089 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3714,6 +3714,23 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		__tcp_sock_set_quickack(sk, val);
 		break;
 
+#ifdef CONFIG_TCP_AO
+	case TCP_AO_ADD_KEY:
+	case TCP_AO_DEL_KEY:
+	case TCP_AO_INFO: {
+		/* If this is the first TCP-AO setsockopt() on the socket,
+		 * sk_state has to be LISTEN or CLOSE
+		 */
+		if (((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) ||
+		    rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					      lockdep_sock_is_held(sk)))
+			err = tp->af_specific->ao_parse(sk, optname, optval,
+							optlen);
+		else
+			err = -EISCONN;
+		break;
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	case TCP_MD5SIG:
 	case TCP_MD5SIG_EXT:
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
new file mode 100644
index 000000000000..4e311885dbe1
--- /dev/null
+++ b/net/ipv4/tcp_ao.c
@@ -0,0 +1,777 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * INET		An implementation of the TCP Authentication Option (TCP-AO).
+ *		See RFC5925.
+ *
+ * Authors:	Dmitry Safonov <dima@arista.com>
+ *		Francesco Ruggeri <fruggeri@arista.com>
+ *		Salam Noureddine <noureddine@arista.com>
+ */
+#define pr_fmt(fmt) "TCP: " fmt
+
+#include <crypto/hash.h>
+#include <linux/inetdevice.h>
+#include <linux/tcp.h>
+
+#include <net/tcp.h>
+#include <net/ipv6.h>
+
+/* Optimized version of tcp_ao_do_lookup(): only for sockets for which
+ * it's known that the keys in ao_info are matching peer's
+ * family/address/port/VRF/etc.
+ */
+static struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
+						 int sndid, int rcvid)
+{
+	struct tcp_ao_key *key;
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		if ((sndid >= 0 && key->sndid != sndid) ||
+		    (rcvid >= 0 && key->rcvid != rcvid))
+			continue;
+		return key;
+	}
+
+	return NULL;
+}
+
+static inline int ipv4_prefix_cmp(const struct in_addr *addr1,
+				  const struct in_addr *addr2,
+				  unsigned int prefixlen)
+{
+	__be32 mask = inet_make_mask(prefixlen);
+
+	if ((addr1->s_addr & mask) == (addr2->s_addr & mask))
+		return 0;
+	return ((addr1->s_addr & mask) > (addr2->s_addr & mask)) ? 1 : -1;
+}
+
+static int __tcp_ao_key_cmp(const struct tcp_ao_key *key,
+			    const union tcp_ao_addr *addr, u8 prefixlen,
+			    int family, int sndid, int rcvid, u16 port)
+{
+	if (sndid >= 0 && key->sndid != sndid)
+		return (key->sndid > sndid) ? 1 : -1;
+	if (rcvid >= 0 && key->rcvid != rcvid)
+		return (key->rcvid > rcvid) ? 1 : -1;
+	if (port != 0 && key->port != 0 && port != key->port)
+		return (key->port > port) ? 1 : -1;
+
+	if (family == AF_UNSPEC)
+		return 0;
+	if (key->family != family)
+		return (key->family > family) ? 1 : -1;
+
+	if (family == AF_INET) {
+		if (key->addr.a4.s_addr == INADDR_ANY)
+			return 0;
+		if (addr->a4.s_addr == INADDR_ANY)
+			return 0;
+		return ipv4_prefix_cmp(&key->addr.a4, &addr->a4, prefixlen);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		if (ipv6_addr_any(&key->addr.a6) || ipv6_addr_any(&addr->a6))
+			return 0;
+		if (ipv6_prefix_equal(&key->addr.a6, &addr->a6, prefixlen))
+			return 0;
+		return memcmp(&key->addr.a6, &addr->a6, prefixlen);
+#endif
+	}
+	return -1;
+}
+
+static int tcp_ao_key_cmp(const struct tcp_ao_key *key,
+			  const union tcp_ao_addr *addr, u8 prefixlen,
+			  int family, int sndid, int rcvid, u16 port)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (family == AF_INET6 && ipv6_addr_v4mapped(&addr->a6)) {
+		__be32 addr4 = addr->a6.s6_addr32[3];
+
+		return __tcp_ao_key_cmp(key, (union tcp_ao_addr *)&addr4,
+					prefixlen, AF_INET, sndid, rcvid, port);
+	}
+#endif
+	return __tcp_ao_key_cmp(key, addr, prefixlen, family, sndid, rcvid, port);
+}
+
+static struct tcp_ao_key *__tcp_ao_do_lookup(const struct sock *sk,
+		const union tcp_ao_addr *addr, int family, u8 prefix,
+		int sndid, int rcvid, u16 port)
+{
+	struct tcp_ao_key *key;
+	struct tcp_ao_info *ao;
+
+	ao = rcu_dereference_check(tcp_sk(sk)->ao_info,
+				   lockdep_sock_is_held(sk));
+	if (!ao)
+		return NULL;
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		u8 prefixlen = min(prefix, key->prefixlen);
+
+		if (!tcp_ao_key_cmp(key, addr, prefixlen,
+				    family, sndid, rcvid, port))
+			return key;
+	}
+	return NULL;
+}
+
+struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+				    const union tcp_ao_addr *addr,
+				    int family, int sndid, int rcvid, u16 port)
+{
+	return __tcp_ao_do_lookup(sk, addr, family, U8_MAX,
+				  sndid, rcvid, port);
+}
+EXPORT_SYMBOL_GPL(tcp_ao_do_lookup);
+
+static struct tcp_ao_info *tcp_ao_alloc_info(gfp_t flags)
+{
+	struct tcp_ao_info *ao;
+
+	ao = kzalloc(sizeof(*ao), flags);
+	if (!ao)
+		return NULL;
+	INIT_HLIST_HEAD(&ao->head);
+
+	return ao;
+}
+
+static void tcp_ao_link_mkt(struct tcp_ao_info *ao, struct tcp_ao_key *mkt)
+{
+	hlist_add_head_rcu(&mkt->node, &ao->head);
+}
+
+static void tcp_ao_key_free_rcu(struct rcu_head *head)
+{
+	struct tcp_ao_key *key = container_of(head, struct tcp_ao_key, rcu);
+
+	tcp_sigpool_release(key->tcp_sigpool_id);
+	kfree(key);
+}
+
+void tcp_ao_destroy_sock(struct sock *sk)
+{
+	struct tcp_ao_info *ao;
+	struct tcp_ao_key *key;
+	struct hlist_node *n;
+
+	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info, 1);
+	tcp_sk(sk)->ao_info = NULL;
+
+	if (!ao)
+		return;
+
+	hlist_for_each_entry_safe(key, n, &ao->head, node) {
+		hlist_del_rcu(&key->node);
+		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
+	}
+
+	kfree_rcu(ao, rcu);
+}
+
+static bool tcp_ao_can_set_current_rnext(struct sock *sk)
+{
+	struct tcp_ao_info *ao_info;
+
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return false;
+	/* There aren't current/rnext keys on TCP_LISTEN sockets */
+	if (sk->sk_state == TCP_LISTEN)
+		return false;
+	return true;
+}
+
+static int tcp_ao_verify_port(struct sock *sk, u16 port)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	if (port != 0) /* FIXME */
+		return -EINVAL;
+
+	/* Check that MKT port is consistent with socket */
+	if (port != 0 && inet->inet_dport != 0 && port != inet->inet_dport)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int tcp_ao_verify_ipv4(struct sock *sk, struct tcp_ao_add *cmd,
+			      union tcp_ao_addr **addr, u16 *port)
+{
+	struct sockaddr_in *sin = (struct sockaddr_in *)&cmd->addr;
+	struct inet_sock *inet = inet_sk(sk);
+
+	if (sin->sin_family != AF_INET)
+		return -EINVAL;
+
+	if (tcp_ao_verify_port(sk, ntohs(sin->sin_port)))
+		return -EINVAL;
+
+	/* Check prefix and trailing 0's in addr */
+	if (cmd->prefix != 0) {
+		__be32 mask;
+
+		if (sin->sin_addr.s_addr == INADDR_ANY)
+			return -EINVAL;
+		if (cmd->prefix > 32)
+			return -EINVAL;
+
+		mask = inet_make_mask(cmd->prefix);
+		if (sin->sin_addr.s_addr & ~mask)
+			return -EINVAL;
+
+		/* Check that MKT address is consistent with socket */
+		if (inet->inet_daddr != INADDR_ANY &&
+		    (inet->inet_daddr & mask) != sin->sin_addr.s_addr)
+			return -EINVAL;
+	} else {
+		if (sin->sin_addr.s_addr != INADDR_ANY)
+			return -EINVAL;
+	}
+
+	*addr = (union tcp_ao_addr *)&sin->sin_addr;
+	*port = ntohs(sin->sin_port);
+	return 0;
+}
+
+static int tcp_ao_parse_crypto(struct tcp_ao_add *cmd, struct tcp_ao_key *key)
+{
+	unsigned int syn_tcp_option_space;
+	bool is_kdf_aes_128_cmac = false;
+	struct tcp_sigpool hp;
+	struct crypto_ahash *tfm;
+	int err, pool_id;
+
+	/* Force null-termination of alg_name */
+	cmd->alg_name[ARRAY_SIZE(cmd->alg_name) - 1] = '\0';
+
+	/* RFC5926, 3.1.1.2. KDF_AES_128_CMAC */
+	if (!strcmp("cmac(aes128)", cmd->alg_name)) {
+		strcpy(cmd->alg_name, "cmac(aes)");
+		is_kdf_aes_128_cmac = (cmd->keylen != 16);
+	}
+
+	key->maclen = cmd->maclen ?: 12; /* 12 is the default in RFC5925 */
+
+	/* Check: maclen + tcp-ao header <= (MAX_TCP_OPTION_SPACE - mss
+	 *					- tstamp - wscale - sackperm),
+	 * see tcp_syn_options(), tcp_synack_options(), commit 33ad798c924b.
+	 *
+	 * In order to allow D-SACK with TCP-AO, the header size should be:
+	 * (MAX_TCP_OPTION_SPACE - TCPOLEN_TSTAMP_ALIGNED
+	 *			- TCPOLEN_SACK_BASE_ALIGNED
+	 *			- 2 * TCPOLEN_SACK_PERBLOCK) = 8 (maclen = 4),
+	 * see tcp_established_options().
+	 *
+	 * RFC5925, 2.2:
+	 * Typical MACs are 96-128 bits (12-16 bytes), but any length
+	 * that fits in the header of the segment being authenticated
+	 * is allowed.
+	 *
+	 * RFC5925, 7.6:
+	 * TCP-AO continues to consume 16 bytes in non-SYN segments,
+	 * leaving a total of 24 bytes for other options, of which
+	 * the timestamp consumes 10.  This leaves 14 bytes, of which 10
+	 * are used for a single SACK block. When two SACK blocks are used,
+	 * such as to handle D-SACK, a smaller TCP-AO MAC would be required
+	 * to make room for the additional SACK block (i.e., to leave 18
+	 * bytes for the D-SACK variant of the SACK option) [RFC2883].
+	 * Note that D-SACK is not supportable in TCP MD5 in the presence
+	 * of timestamps, because TCP MD5’s MAC length is fixed and too
+	 * large to leave sufficient option space.
+	 */
+	syn_tcp_option_space = MAX_TCP_OPTION_SPACE;
+	syn_tcp_option_space -= TCPOLEN_TSTAMP_ALIGNED;
+	syn_tcp_option_space -= TCPOLEN_WSCALE_ALIGNED;
+	syn_tcp_option_space -= TCPOLEN_SACKPERM_ALIGNED;
+	if (tcp_ao_len(key) > syn_tcp_option_space)
+		return -EMSGSIZE;
+
+	key->keylen = cmd->keylen;
+	memcpy(key->key, cmd->key, cmd->keylen);
+
+	/* Full TCP header (th->doff << 2) should fit into scratch area,
+	 * see tcp_ao_hash_header().
+	 */
+	pool_id = tcp_sigpool_alloc_ahash(cmd->alg_name, 60);
+	if (pool_id < 0)
+		return pool_id;
+
+	err = tcp_sigpool_start(pool_id, &hp);
+	if (err)
+		goto err_free_pool;
+
+	tfm = crypto_ahash_reqtfm(hp.req);
+	if (crypto_ahash_alignmask(tfm) > TCP_AO_KEY_ALIGN) {
+		err = -EOPNOTSUPP;
+		goto err_pool_end;
+	}
+
+	if (is_kdf_aes_128_cmac) {
+		void *scratch = hp.scratch;
+		struct scatterlist sg;
+
+		/* Using zero-key of 16 bytes as described in RFC5926 */
+		memset(scratch, 0, 16);
+		sg_init_one(&sg, cmd->key, cmd->keylen);
+
+		err = crypto_ahash_setkey(tfm, scratch, 16);
+		if (err)
+			goto err_pool_end;
+
+		err = crypto_ahash_init(hp.req);
+		if (err)
+			goto err_pool_end;
+
+		ahash_request_set_crypt(hp.req, &sg, key->key, cmd->keylen);
+		err = crypto_ahash_update(hp.req);
+		if (err)
+			goto err_pool_end;
+
+		err |= crypto_ahash_final(hp.req);
+		if (err)
+			goto err_pool_end;
+		key->keylen = 16;
+	}
+
+	err = crypto_ahash_setkey(tfm, key->key, key->keylen);
+	if (err)
+		goto err_pool_end;
+
+	key->digest_size = crypto_ahash_digestsize(tfm);
+	tcp_sigpool_end();
+
+	/* TODO: remove TCP_AO_MAX_HASH_SIZE in favor of dynamically
+	 * allocated buffer.
+	 */
+	if (key->digest_size > TCP_AO_MAX_HASH_SIZE) {
+		err = -ENOBUFS;
+		goto err_free_pool;
+	}
+	if (tcp_ao_maclen(key) > key->digest_size) {
+		err = -EINVAL;
+		goto err_free_pool;
+	}
+
+	key->tcp_sigpool_id = pool_id;
+	return 0;
+
+err_pool_end:
+	tcp_sigpool_end();
+err_free_pool:
+	tcp_sigpool_release(pool_id);
+	return err;
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static int tcp_ao_verify_ipv6(struct sock *sk, struct tcp_ao_add *cmd,
+			      union tcp_ao_addr **paddr, u16 *port,
+			      unsigned short int *family)
+{
+	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd->addr;
+	struct in6_addr *addr = &sin6->sin6_addr;
+	u8 prefix = cmd->prefix;
+
+	if (sin6->sin6_family != AF_INET6)
+		return -EINVAL;
+	/* Not supposed to happen: here from af-specific callback */
+	if (WARN_ON_ONCE(!sk_fullsock(sk)))
+		return -EINVAL;
+
+	if (tcp_ao_verify_port(sk, ntohs(sin6->sin6_port)))
+		return -EINVAL;
+
+	/* Check prefix and trailing 0's in addr */
+	if (cmd->prefix != 0 && ipv6_addr_v4mapped(addr)) {
+		__be32 addr4 = addr->s6_addr32[3];
+		__be32 mask;
+
+		if (prefix > 32 || addr4 == INADDR_ANY)
+			return -EINVAL;
+
+		mask = inet_make_mask(prefix);
+		if (addr4 & ~mask)
+			return -EINVAL;
+
+		/* Check that MKT address is consistent with socket */
+		if (!ipv6_addr_any(&sk->sk_v6_daddr)) {
+			__be32 daddr4 = sk->sk_v6_daddr.s6_addr32[3];
+
+			if (!ipv6_addr_v4mapped(&sk->sk_v6_daddr))
+				return -EINVAL;
+			if ((daddr4 & mask) != addr4)
+				return -EINVAL;
+		}
+
+		*paddr = (union tcp_ao_addr *)&addr->s6_addr32[3];
+		*family = AF_INET;
+		*port = ntohs(sin6->sin6_port);
+		return 0;
+	} else if (cmd->prefix != 0) {
+		struct in6_addr pfx;
+
+		if (ipv6_addr_any(addr) || prefix > 128)
+			return -EINVAL;
+
+		ipv6_addr_prefix(&pfx, addr, prefix);
+		if (ipv6_addr_cmp(&pfx, addr))
+			return -EINVAL;
+
+		/* Check that MKT address is consistent with socket */
+		if (!ipv6_addr_any(&sk->sk_v6_daddr) &&
+		    !ipv6_prefix_equal(&sk->sk_v6_daddr, addr, prefix))
+
+			return -EINVAL;
+	} else {
+		if (!ipv6_addr_any(addr))
+			return -EINVAL;
+	}
+
+	*paddr = (union tcp_ao_addr *)addr;
+	*port = ntohs(sin6->sin6_port);
+	return 0;
+}
+#else
+static inline int tcp_ao_verify_ipv6(struct sock *sk, struct tcp_ao_add *cmd,
+				     union tcp_ao_addr **paddr, u16 *port,
+				     unsigned short int *family)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#define TCP_AO_KEYF_ALL		(0)
+
+static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
+			  sockptr_t optval, int optlen)
+{
+	struct tcp_ao_info *ao_info;
+	union tcp_ao_addr *addr;
+	struct tcp_ao_key *key;
+	struct tcp_ao_add cmd;
+	bool first = false;
+	int ret, size;
+	u16 port;
+
+	if (optlen < sizeof(cmd))
+		return -EINVAL;
+
+	ret = copy_struct_from_sockptr(&cmd, sizeof(cmd), optval, optlen);
+	if (ret)
+		return ret;
+
+	if (cmd.keylen > TCP_AO_MAXKEYLEN)
+		return -EINVAL;
+
+	if (cmd.reserved != 0 || cmd.reserved2 != 0)
+		return -EINVAL;
+
+	if (family == AF_INET)
+		ret = tcp_ao_verify_ipv4(sk, &cmd, &addr, &port);
+	else
+		ret = tcp_ao_verify_ipv6(sk, &cmd, &addr, &port, &family);
+	if (ret)
+		return ret;
+
+	if (cmd.keyflags & ~TCP_AO_KEYF_ALL)
+		return -EINVAL;
+
+	if (cmd.set_current || cmd.set_rnext) {
+		if (!tcp_ao_can_set_current_rnext(sk))
+			return -EINVAL;
+	}
+
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+
+	if (!ao_info) {
+		ao_info = tcp_ao_alloc_info(GFP_KERNEL);
+		if (!ao_info)
+			return -ENOMEM;
+		first = true;
+	} else {
+		/* RFC5925 3.1 The IDs of MKTs MUST NOT overlap where
+		 * their TCP connection identifiers overlap.
+		 */
+		if (__tcp_ao_do_lookup(sk, addr, family,
+				       cmd.prefix, cmd.sndid, cmd.rcvid, port))
+			return -EEXIST;
+	}
+
+	/* TODO: We should add twice the key->diget_size instead of the max
+	 * so rework this in a way to know the digest_size before allocating
+	 * the tcp_ao_key struct.
+	 */
+	size = sizeof(struct tcp_ao_key) + (TCP_AO_MAX_HASH_SIZE << 1);
+	key = sock_kmalloc(sk, size, GFP_KERNEL);
+	if (!key) {
+		ret = -ENOMEM;
+		goto err_free_ao;
+	}
+
+	INIT_HLIST_NODE(&key->node);
+	memcpy(&key->addr, addr, (family == AF_INET) ? sizeof(struct in_addr) :
+						       sizeof(struct in6_addr));
+	key->port	= port;
+	key->prefixlen	= cmd.prefix;
+	key->family	= family;
+	key->keyflags	= cmd.keyflags;
+	key->sndid	= cmd.sndid;
+	key->rcvid	= cmd.rcvid;
+
+	ret = tcp_ao_parse_crypto(&cmd, key);
+	if (ret < 0)
+		goto err_free_sock;
+
+	tcp_ao_link_mkt(ao_info, key);
+	if (first) {
+		sk_gso_disable(sk);
+		rcu_assign_pointer(tcp_sk(sk)->ao_info, ao_info);
+	}
+
+	if (cmd.set_current)
+		WRITE_ONCE(ao_info->current_key, key);
+	if (cmd.set_rnext)
+		WRITE_ONCE(ao_info->rnext_key, key);
+	return 0;
+
+err_free_sock:
+	atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+	kfree(key);
+err_free_ao:
+	if (first)
+		kfree(ao_info);
+	return ret;
+}
+
+static int tcp_ao_delete_key(struct sock *sk, struct tcp_ao_info *ao_info,
+			     struct tcp_ao_key *key,
+			     struct tcp_ao_key *new_current,
+			     struct tcp_ao_key *new_rnext)
+{
+	int err;
+
+	hlist_del_rcu(&key->node);
+
+	/* At this moment another CPU could have looked this key up
+	 * while it was unlinked from the list. Wait for RCU grace period,
+	 * after which the key is off-list and can't be looked up again;
+	 * the rx path [just before RCU came] might have used it and set it
+	 * as current_key (very unlikely).
+	 */
+	synchronize_rcu();
+	if (new_current)
+		WRITE_ONCE(ao_info->current_key, new_current);
+	if (new_rnext)
+		WRITE_ONCE(ao_info->current_key, new_rnext);
+
+	if (unlikely(READ_ONCE(ao_info->current_key) == key ||
+		     READ_ONCE(ao_info->rnext_key) == key)) {
+		err = -EBUSY;
+		goto add_key;
+	}
+
+	atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+	call_rcu(&key->rcu, tcp_ao_key_free_rcu);
+
+	return 0;
+add_key:
+	hlist_add_head_rcu(&key->node, &ao_info->head);
+	return err;
+}
+
+static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
+			  sockptr_t optval, int optlen)
+{
+	struct tcp_ao_key *key, *new_current = NULL, *new_rnext = NULL;
+	struct tcp_ao_info *ao_info;
+	union tcp_ao_addr *addr;
+	struct tcp_ao_del cmd;
+	int err;
+	__u8 prefix;
+	__be16 port;
+	int addr_len;
+
+	if (optlen < sizeof(cmd))
+		return -EINVAL;
+
+	err = copy_struct_from_sockptr(&cmd, sizeof(cmd), optval, optlen);
+	if (err)
+		return err;
+
+	if (cmd.reserved != 0 || cmd.reserved2 != 0)
+		return -EINVAL;
+
+	if (cmd.set_current || cmd.set_rnext) {
+		if (!tcp_ao_can_set_current_rnext(sk))
+			return -EINVAL;
+	}
+
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return -ENOENT;
+
+	/* For sockets in TCP_CLOSED it's possible set keys that aren't
+	 * matching the future peer (address/port/VRF/etc),
+	 * tcp_ao_connect_init() will choose a correct matching MKT
+	 * if there's any.
+	 */
+	if (cmd.set_current) {
+		new_current = tcp_ao_established_key(ao_info, cmd.current_key, -1);
+		if (!new_current)
+			return -ENOENT;
+	}
+	if (cmd.set_rnext) {
+		new_rnext = tcp_ao_established_key(ao_info, -1, cmd.rnext);
+		if (!new_rnext)
+			return -ENOENT;
+	}
+
+	if (family == AF_INET) {
+		struct sockaddr_in *sin = (struct sockaddr_in *)&cmd.addr;
+
+		addr = (union tcp_ao_addr *)&sin->sin_addr;
+		addr_len = sizeof(struct in_addr);
+		port = ntohs(sin->sin_port);
+	} else {
+		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.addr;
+		struct in6_addr *addr6 = &sin6->sin6_addr;
+
+		if (ipv6_addr_v4mapped(addr6)) {
+			addr = (union tcp_ao_addr *)&addr6->s6_addr32[3];
+			addr_len = sizeof(struct in_addr);
+			family = AF_INET;
+		} else {
+			addr = (union tcp_ao_addr *)addr6;
+			addr_len = sizeof(struct in6_addr);
+		}
+		port = ntohs(sin6->sin6_port);
+	}
+	prefix = cmd.prefix;
+
+	/* We could choose random present key here for current/rnext
+	 * but that's less predictable. Let's be strict and don't
+	 * allow removing a key that's in use. RFC5925 doesn't
+	 * specify how-to coordinate key removal, but says:
+	 * "It is presumed that an MKT affecting a particular
+	 * connection cannot be destroyed during an active connection"
+	 */
+	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+		if (cmd.sndid != key->sndid ||
+		    cmd.rcvid != key->rcvid)
+			continue;
+
+		if (family != key->family ||
+		    prefix != key->prefixlen ||
+		    port != key->port ||
+		    memcmp(addr, &key->addr, addr_len))
+			continue;
+
+		if (key == new_current || key == new_rnext)
+			continue;
+
+		return tcp_ao_delete_key(sk, ao_info, key,
+					  new_current, new_rnext);
+	}
+	return -ENOENT;
+}
+
+static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
+			   sockptr_t optval, int optlen)
+{
+	struct tcp_ao_info *ao_info;
+	struct tcp_ao_key *new_current = NULL, *new_rnext = NULL;
+	struct tcp_ao_info_opt cmd;
+	bool first = false;
+	int err;
+
+	if (optlen < sizeof(cmd))
+		return -EINVAL;
+
+	err = copy_struct_from_sockptr(&cmd, sizeof(cmd), optval, optlen);
+	if (err)
+		return err;
+
+	if (cmd.set_current || cmd.set_rnext) {
+		if (!tcp_ao_can_set_current_rnext(sk))
+			return -EINVAL;
+	}
+
+	if (cmd.reserved != 0)
+		return -EINVAL;
+
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao_info) {
+		ao_info = tcp_ao_alloc_info(GFP_KERNEL);
+		if (!ao_info)
+			return -ENOMEM;
+		first = true;
+	}
+
+	/* For sockets in TCP_CLOSED it's possible set keys that aren't
+	 * matching the future peer (address/port/VRF/etc),
+	 * tcp_ao_connect_init() will choose a correct matching MKT
+	 * if there's any.
+	 */
+	if (cmd.set_current) {
+		new_current = tcp_ao_established_key(ao_info, cmd.current_key, -1);
+		if (!new_current) {
+			err = -ENOENT;
+			goto out;
+		}
+	}
+	if (cmd.set_rnext) {
+		new_rnext = tcp_ao_established_key(ao_info, -1, cmd.rnext);
+		if (!new_rnext) {
+			err = -ENOENT;
+			goto out;
+		}
+	}
+
+	ao_info->ao_required = cmd.ao_required;
+	if (new_current)
+		WRITE_ONCE(ao_info->current_key, new_current);
+	if (new_rnext)
+		WRITE_ONCE(ao_info->current_key, new_rnext);
+	if (first) {
+		sk_gso_disable(sk);
+		rcu_assign_pointer(tcp_sk(sk)->ao_info, ao_info);
+	}
+	return 0;
+out:
+	if (first)
+		kfree(ao_info);
+	return err;
+}
+
+int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
+		 sockptr_t optval, int optlen)
+{
+	if (WARN_ON_ONCE(family != AF_INET && family != AF_INET6))
+		return -EAFNOSUPPORT;
+
+	switch (cmd) {
+	case TCP_AO_ADD_KEY:
+		return tcp_ao_add_cmd(sk, family, optval, optlen);
+	case TCP_AO_DEL_KEY:
+		return tcp_ao_del_cmd(sk, family, optval, optlen);
+	case TCP_AO_INFO:
+		return tcp_ao_info_cmd(sk, family, optval, optlen);
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+}
+
+int tcp_v4_parse_ao(struct sock *sk, int cmd, sockptr_t optval, int optlen)
+{
+	return tcp_parse_ao(sk, cmd, AF_INET, optval, optlen);
+}
+
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b6ac2cd77ee4..17c2504c6b14 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2261,11 +2261,16 @@ const struct inet_connection_sock_af_ops ipv4_specific = {
 };
 EXPORT_SYMBOL(ipv4_specific);
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
+#ifdef CONFIG_TCP_MD5SIG
 	.md5_lookup		= tcp_v4_md5_lookup,
 	.calc_md5_hash		= tcp_v4_md5_hash_skb,
 	.md5_parse		= tcp_v4_parse_md5_keys,
+#endif
+#ifdef CONFIG_TCP_AO
+	.ao_parse		= tcp_v4_parse_ao,
+#endif
 };
 #endif
 
@@ -2280,7 +2285,7 @@ static int tcp_v4_init_sock(struct sock *sk)
 
 	icsk->icsk_af_ops = &ipv4_specific;
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	tcp_sk(sk)->af_specific = &tcp_sock_ipv4_specific;
 #endif
 
@@ -2331,6 +2336,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		rcu_assign_pointer(tp->md5sig_info, NULL);
 	}
 #endif
+	tcp_ao_destroy_sock(sk);
 
 	/* Clean up a referenced TCP bind bucket. */
 	if (inet_csk(sk)->icsk_bind_hash)
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 3036a45e8a1e..d283c59df4c1 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -52,4 +52,5 @@ obj-$(subst m,y,$(CONFIG_IPV6)) += inet6_hashtables.o
 ifneq ($(CONFIG_IPV6),)
 obj-$(CONFIG_NET_UDP_TUNNEL) += ip6_udp_tunnel.o
 obj-y += mcast_snoop.o
+obj-$(CONFIG_TCP_AO) += tcp_ao.o
 endif
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
new file mode 100644
index 000000000000..d0aa6414b7d9
--- /dev/null
+++ b/net/ipv6/tcp_ao.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * INET		An implementation of the TCP Authentication Option (TCP-AO).
+ *		See RFC5925.
+ *
+ * Authors:	Dmitry Safonov <dima@arista.com>
+ *		Francesco Ruggeri <fruggeri@arista.com>
+ *		Salam Noureddine <noureddine@arista.com>
+ */
+#include <linux/tcp.h>
+
+#include <net/tcp.h>
+#include <net/ipv6.h>
+
+int tcp_v6_parse_ao(struct sock *sk, int cmd,
+		    sockptr_t optval, int optlen)
+{
+	return tcp_parse_ao(sk, cmd, AF_INET6, optval, optlen);
+}
+EXPORT_SYMBOL_GPL(tcp_v6_parse_ao);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 60fe9ade2e61..e49e76756090 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -76,16 +76,9 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb);
 
 static const struct inet_connection_sock_af_ops ipv6_mapped;
 const struct inet_connection_sock_af_ops ipv6_specific;
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 static const struct tcp_sock_af_ops tcp_sock_ipv6_specific;
 static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific;
-#else
-static struct tcp_md5sig_key *tcp_v6_md5_do_lookup(const struct sock *sk,
-						   const struct in6_addr *addr,
-						   int l3index)
-{
-	return NULL;
-}
 #endif
 
 /* Helper returning the inet6 address from a given tcp socket.
@@ -243,7 +236,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 		if (sk_is_mptcp(sk))
 			mptcpv6_handle_mapped(sk, true);
 		sk->sk_backlog_rcv = tcp_v4_do_rcv;
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 		tp->af_specific = &tcp_sock_ipv6_mapped_specific;
 #endif
 
@@ -256,7 +249,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 			if (sk_is_mptcp(sk))
 				mptcpv6_handle_mapped(sk, false);
 			sk->sk_backlog_rcv = tcp_v6_do_rcv;
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 			tp->af_specific = &tcp_sock_ipv6_specific;
 #endif
 			goto failure;
@@ -771,7 +764,13 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 	memset(md5_hash, 0, 16);
 	return 1;
 }
-
+#else /* CONFIG_TCP_MD5SIG */
+static struct tcp_md5sig_key *tcp_v6_md5_do_lookup(const struct sock *sk,
+						   const struct in6_addr *addr,
+						   int l3index)
+{
+	return NULL;
+}
 #endif
 
 static void tcp_v6_init_req(struct request_sock *req,
@@ -1231,7 +1230,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		if (sk_is_mptcp(newsk))
 			mptcpv6_handle_mapped(newsk, true);
 		newsk->sk_backlog_rcv = tcp_v4_do_rcv;
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 		newtp->af_specific = &tcp_sock_ipv6_mapped_specific;
 #endif
 
@@ -1893,11 +1892,16 @@ const struct inet_connection_sock_af_ops ipv6_specific = {
 	.mtu_reduced	   = tcp_v6_mtu_reduced,
 };
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
+#ifdef CONFIG_TCP_MD5SIG
 	.md5_lookup	=	tcp_v6_md5_lookup,
 	.calc_md5_hash	=	tcp_v6_md5_hash_skb,
 	.md5_parse	=	tcp_v6_parse_md5_keys,
+#endif
+#ifdef CONFIG_TCP_AO
+	.ao_parse	=	tcp_v6_parse_ao,
+#endif
 };
 #endif
 
@@ -1919,11 +1923,16 @@ static const struct inet_connection_sock_af_ops ipv6_mapped = {
 	.mtu_reduced	   = tcp_v4_mtu_reduced,
 };
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
+#ifdef CONFIG_TCP_MD5SIG
 	.md5_lookup	=	tcp_v4_md5_lookup,
 	.calc_md5_hash	=	tcp_v4_md5_hash_skb,
 	.md5_parse	=	tcp_v6_parse_md5_keys,
+#endif
+#ifdef CONFIG_TCP_AO
+	.ao_parse	=	tcp_v6_parse_ao,
+#endif
 };
 #endif
 
@@ -1938,7 +1947,7 @@ static int tcp_v6_init_sock(struct sock *sk)
 
 	icsk->icsk_af_ops = &ipv6_specific;
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	tcp_sk(sk)->af_specific = &tcp_sock_ipv6_specific;
 #endif
 
-- 
2.40.0

