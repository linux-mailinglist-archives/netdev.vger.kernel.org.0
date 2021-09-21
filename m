Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6DC41371A
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbhIUQSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbhIUQSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:01 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE14C061766;
        Tue, 21 Sep 2021 09:16:31 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ee50so2722314edb.13;
        Tue, 21 Sep 2021 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n/Xa05kRuG74glxteHqIbQ8b5Hw5j8bG6ggHeI5rzFI=;
        b=mQHvijUdlJPH00GTCY5jaxpJzlFXojI+fhJ7Y1MJck3SK394FrXCFLTJHwxXc+mJAd
         17CphejyZnT5zuwqLaEILQJLY/GbzuYCnd95QZyLPFN4AgW8SVfKClXGauzHZMdwTFLD
         czHU43iwG1kQsAsDo/Rg+IrVJfrwI+BRtxFKeJsl5yAoF+Vbf7N+2QGa8kJAAkIjKgj9
         +de9TXTc2u4PrNg7+3xvrgomc5XeTKoYVMGd5DRg3qG8VZD0mcl2SihrpyZlsWK5tOoe
         Xvuxv0BzULAM0ZF837ornauMeXxp8EijjTy2W+yxQQQaDyAW3H7FgbBgst4uKqEZkTiX
         GDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n/Xa05kRuG74glxteHqIbQ8b5Hw5j8bG6ggHeI5rzFI=;
        b=ubEn1Q/LK984/FpL1KJ+0N5ybBn0rT9gs5SgLtcidG1ty+EQ8yyKGjPl66LQYkcKS6
         w4r9IJU/tRTrCr//cL1lyMmKG1ZSASLGLFl1iL1sDjtBKFo+kGj/Wd63xV4U39+jLNAY
         IENdasvkFlYDbNNkXRWgVylUG7Y+SMIZtUFEaR2uDt4oxXWiVqxEacoAWymZpEv8jqKW
         P+EFC+I9DTgu4RpujCDddq3sh9lQxnCarbu0uVIjof7B4xaSVveQFBRWu+GVaEELFmGi
         +q2rUW48mf4945XYxs2NzWhSfTv/s5uh5iTMWuPPx88QF5FkAekBe3JclQhfxgDhr+Oa
         KHyw==
X-Gm-Message-State: AOAM533DFDq/yul+fYu9ylnBT/vy3UDdAn13MRFTckUqyMShztXPmUZO
        4uKOUf4Prd7+c8LRe96n8mc=
X-Google-Smtp-Source: ABdhPJzv+PyrnK7gKDdmmP+vJpn9Y9/8WZlS8k4dWW1nuZjJ8uTiGMswV1ef5AfgQreaChLJxtVObA==
X-Received: by 2002:a17:906:6a0f:: with SMTP id qw15mr36020735ejc.406.1632240916912;
        Tue, 21 Sep 2021 09:15:16 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:16 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/19] tcp: authopt: Initial support and key management
Date:   Tue, 21 Sep 2021 19:14:44 +0300
Message-Id: <0c4fd7ec7a3a1d25078cb8acb64400a67fd57836.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support to add and remove keys but does not use them
further.

Similar to tcp md5 a single pointer to a struct tcp_authopt_info* struct
is added to struct tcp_sock, this avoids increasing memory usage. The
data structures related to tcp_authopt are initialized on setsockopt and
only freed on socket close.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/linux/tcp.h       |   9 ++
 include/net/tcp.h         |   1 +
 include/net/tcp_authopt.h |  63 +++++++++
 include/uapi/linux/tcp.h  |  79 ++++++++++++
 net/ipv4/Kconfig          |  14 ++
 net/ipv4/Makefile         |   1 +
 net/ipv4/tcp.c            |  30 +++++
 net/ipv4/tcp_authopt.c    | 260 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c       |   2 +
 9 files changed, 459 insertions(+)
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 48d8a363319e..50038f35ba51 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -140,10 +140,12 @@ struct tcp_request_sock {
 static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
 {
 	return (struct tcp_request_sock *)req;
 }
 
+struct tcp_authopt_info;
+
 struct tcp_sock {
 	/* inet_connection_sock has to be the first member of tcp_sock */
 	struct inet_connection_sock	inet_conn;
 	u16	tcp_header_len;	/* Bytes of tcp header to send		*/
 	u16	gso_segs;	/* Max number of segs per GSO packet	*/
@@ -403,10 +405,14 @@ struct tcp_sock {
 
 /* TCP MD5 Signature Option information */
 	struct tcp_md5sig_info	__rcu *md5sig_info;
 #endif
 
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info	__rcu *authopt_info;
+#endif
+
 /* TCP fastopen related information */
 	struct tcp_fastopen_request *fastopen_req;
 	/* fastopen_rsk points to request_sock that resulted in this big
 	 * socket. Used to retransmit SYNACKs etc.
 	 */
@@ -453,10 +459,13 @@ struct tcp_timewait_sock {
 	int			  tw_ts_recent_stamp;
 	u32			  tw_tx_delay;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key	  *tw_md5_key;
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info	  *tw_authopt_info;
+#endif
 };
 
 static inline struct tcp_timewait_sock *tcp_twsk(const struct sock *sk)
 {
 	return (struct tcp_timewait_sock *)sk;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3166dc15d7d6..bb76554e8fe5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -182,10 +182,11 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCPOPT_WINDOW		3	/* Window scaling */
 #define TCPOPT_SACK_PERM        4       /* SACK Permitted */
 #define TCPOPT_SACK             5       /* SACK Block */
 #define TCPOPT_TIMESTAMP	8	/* Better RTT estimations/PAWS */
 #define TCPOPT_MD5SIG		19	/* MD5 Signature (RFC2385) */
+#define TCPOPT_AUTHOPT		29	/* Auth Option (RFC5925) */
 #define TCPOPT_MPTCP		30	/* Multipath TCP (RFC6824) */
 #define TCPOPT_FASTOPEN		34	/* Fast open (RFC7413) */
 #define TCPOPT_EXP		254	/* Experimental */
 /* Magic number to be after the option value for sharing TCP
  * experimental options. See draft-ietf-tcpm-experimental-options-00.txt
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
new file mode 100644
index 000000000000..19d304de18f8
--- /dev/null
+++ b/include/net/tcp_authopt.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_TCP_AUTHOPT_H
+#define _LINUX_TCP_AUTHOPT_H
+
+#include <uapi/linux/tcp.h>
+
+/**
+ * struct tcp_authopt_key_info - Representation of a Master Key Tuple as per RFC5925
+ *
+ * Key structure lifetime is only protected by RCU so readers needs to hold a
+ * single rcu_read_lock until they're done with the key.
+ */
+struct tcp_authopt_key_info {
+	struct hlist_node node;
+	struct rcu_head rcu;
+	u32 flags;
+	/* Wire identifiers */
+	u8 send_id, recv_id;
+	u8 alg_id;
+	u8 keylen;
+	u8 key[TCP_AUTHOPT_MAXKEYLEN];
+	struct sockaddr_storage addr;
+};
+
+/**
+ * struct tcp_authopt_info - Per-socket information regarding tcp_authopt
+ *
+ * This is lazy-initialized in order to avoid increasing memory usage for
+ * regular TCP sockets. Once created it is only destroyed on socket close.
+ */
+struct tcp_authopt_info {
+	/** @head: List of tcp_authopt_key_info */
+	struct hlist_head head;
+	struct rcu_head rcu;
+	u32 flags;
+	u32 src_isn;
+	u32 dst_isn;
+};
+
+#ifdef CONFIG_TCP_AUTHOPT
+void tcp_authopt_clear(struct sock *sk);
+int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
+int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
+int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
+#else
+static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	return -ENOPROTOOPT;
+}
+static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
+{
+	return -ENOPROTOOPT;
+}
+static inline void tcp_authopt_clear(struct sock *sk)
+{
+}
+static inline int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	return -ENOPROTOOPT;
+}
+#endif
+
+#endif /* _LINUX_TCP_AUTHOPT_H */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 8fc09e8638b3..c68ecd617774 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -126,10 +126,12 @@ enum {
 #define TCP_INQ			36	/* Notify bytes available to read as a cmsg on read */
 
 #define TCP_CM_INQ		TCP_INQ
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
+#define TCP_AUTHOPT		38	/* TCP Authentication Option (RFC5925) */
+#define TCP_AUTHOPT_KEY		39	/* TCP Authentication Option Key (RFC5925) */
 
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
 #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
@@ -340,10 +342,87 @@ struct tcp_diag_md5sig {
 	__u16	tcpm_keylen;
 	__be32	tcpm_addr[4];
 	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];
 };
 
+/**
+ * enum tcp_authopt_flag - flags for `tcp_authopt.flags`
+ */
+enum tcp_authopt_flag {
+	/**
+	 * @TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED:
+	 *	Configure behavior of segments with TCP-AO coming from hosts for which no
+	 *	key is configured. The default recommended by RFC is to silently accept
+	 *	such connections.
+	 */
+	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED = (1 << 2),
+};
+
+/**
+ * struct tcp_authopt - Per-socket options related to TCP Authentication Option
+ */
+struct tcp_authopt {
+	/** @flags: Combination of &enum tcp_authopt_flag */
+	__u32	flags;
+};
+
+/**
+ * enum tcp_authopt_key_flag - flags for `tcp_authopt.flags`
+ *
+ * @TCP_AUTHOPT_KEY_DEL: Delete the key and ignore non-id fields
+ * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
+ * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
+ */
+enum tcp_authopt_key_flag {
+	TCP_AUTHOPT_KEY_DEL = (1 << 0),
+	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
+	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
+};
+
+/**
+ * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
+ */
+enum tcp_authopt_alg {
+	TCP_AUTHOPT_ALG_HMAC_SHA_1_96 = 1,
+	TCP_AUTHOPT_ALG_AES_128_CMAC_96 = 2,
+};
+
+/* for TCP_AUTHOPT_KEY socket option */
+#define TCP_AUTHOPT_MAXKEYLEN	80
+
+/**
+ * struct tcp_authopt_key - TCP Authentication KEY
+ *
+ * Key are identified by the combination of:
+ * - send_id
+ * - recv_id
+ * - addr (iff TCP_AUTHOPT_KEY_ADDR_BIND)
+ *
+ * RFC5925 requires that key ids must not overlap for the same TCP connection.
+ * This is not enforced by linux.
+ */
+struct tcp_authopt_key {
+	/** @flags: Combination of &enum tcp_authopt_key_flag */
+	__u32	flags;
+	/** @send_id: keyid value for send */
+	__u8	send_id;
+	/** @recv_id: keyid value for receive */
+	__u8	recv_id;
+	/** @alg: One of &enum tcp_authopt_alg */
+	__u8	alg;
+	/** @keylen: Length of the key buffer */
+	__u8	keylen;
+	/** @key: Secret key */
+	__u8	key[TCP_AUTHOPT_MAXKEYLEN];
+	/**
+	 * @addr: Key is only valid for this address
+	 *
+	 * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
+	 */
+	struct __kernel_sockaddr_storage addr;
+};
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
 struct tcp_zerocopy_receive {
 	__u64 address;		/* in: address of mapping */
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 87983e70f03f..6459f4ea6f1d 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -740,5 +740,19 @@ config TCP_MD5SIG
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
 	  Its main (only?) use is to protect BGP sessions between core routers
 	  on the Internet.
 
 	  If unsure, say N.
+
+config TCP_AUTHOPT
+	bool "TCP: Authentication Option support (RFC5925)"
+	select CRYPTO
+	select CRYPTO_SHA1
+	select CRYPTO_HMAC
+	select CRYPTO_AES
+	select CRYPTO_CMAC
+	help
+	  RFC5925 specifies a new method of giving protection to TCP sessions.
+	  Its intended use is to protect BGP sessions between core routers
+	  on the Internet. It obsoletes TCP MD5 (RFC2385) but is incompatible.
+
+	  If unsure, say N.
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index bbdd9c44f14e..d336f32ce177 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -59,10 +59,11 @@ obj-$(CONFIG_TCP_CONG_NV) += tcp_nv.o
 obj-$(CONFIG_TCP_CONG_VENO) += tcp_veno.o
 obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_scalable.o
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
+obj-$(CONFIG_TCP_AUTHOPT) += tcp_authopt.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
 obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df73c85..9966acf259e2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -271,10 +271,11 @@
 
 #include <net/icmp.h>
 #include <net/inet_common.h>
 #include <net/tcp.h>
 #include <net/mptcp.h>
+#include <net/tcp_authopt.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/sock.h>
 
 #include <linux/uaccess.h>
@@ -3574,10 +3575,16 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_MD5SIG:
 	case TCP_MD5SIG_EXT:
 		err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
 		break;
 #endif
+	case TCP_AUTHOPT:
+		err = tcp_set_authopt(sk, optval, optlen);
+		break;
+	case TCP_AUTHOPT_KEY:
+		err = tcp_set_authopt_key(sk, optval, optlen);
+		break;
 	case TCP_USER_TIMEOUT:
 		/* Cap the max time in ms TCP will retry or probe the window
 		 * before giving up and aborting (ETIMEDOUT) a connection.
 		 */
 		if (val < 0)
@@ -4220,10 +4227,33 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		if (!err && copy_to_user(optval, &zc, len))
 			err = -EFAULT;
 		return err;
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	case TCP_AUTHOPT: {
+		struct tcp_authopt info;
+		int err;
+
+		if (get_user(len, optlen))
+			return -EFAULT;
+
+		lock_sock(sk);
+		err = tcp_get_authopt_val(sk, &info);
+		release_sock(sk);
+
+		if (err)
+			return err;
+		len = min_t(unsigned int, len, sizeof(info));
+		if (put_user(len, optlen))
+			return -EFAULT;
+		if (copy_to_user(optval, &info, len))
+			return -EFAULT;
+		return 0;
+	}
+#endif
+
 	default:
 		return -ENOPROTOOPT;
 	}
 
 	if (put_user(len, optlen))
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
new file mode 100644
index 000000000000..a771e5754c8a
--- /dev/null
+++ b/net/ipv4/tcp_authopt.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <net/tcp.h>
+#include <net/tcp_authopt.h>
+#include <crypto/hash.h>
+
+/* checks that ipv4 or ipv6 addr matches. */
+static bool ipvx_addr_match(struct sockaddr_storage *a1,
+			    struct sockaddr_storage *a2)
+{
+	if (a1->ss_family != a2->ss_family)
+		return false;
+	if (a1->ss_family == AF_INET && (
+			((struct sockaddr_in *)a1)->sin_addr.s_addr !=
+			((struct sockaddr_in *)a2)->sin_addr.s_addr))
+		return false;
+	if (a1->ss_family == AF_INET6 && !ipv6_addr_equal(
+			&((struct sockaddr_in6 *)a1)->sin6_addr,
+			&((struct sockaddr_in6 *)a2)->sin6_addr))
+		return false;
+	return true;
+}
+
+static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
+					struct tcp_authopt_key *key)
+{
+	if (info->send_id != key->send_id)
+		return false;
+	if (info->recv_id != key->recv_id)
+		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_ADDR_BIND) != (key->recv_id & TCP_AUTHOPT_KEY_ADDR_BIND))
+		return false;
+	if (info->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
+		if (!ipvx_addr_match(&info->addr, &key->addr))
+			return false;
+
+	return true;
+}
+
+static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct sock *sk,
+								 struct tcp_authopt_info *info,
+								 struct tcp_authopt_key *ukey)
+{
+	struct tcp_authopt_key_info *key_info;
+
+	hlist_for_each_entry_rcu(key_info, &info->head, node, lockdep_sock_is_held(sk))
+		if (tcp_authopt_key_match_exact(key_info, ukey))
+			return key_info;
+
+	return NULL;
+}
+
+static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt_info *info;
+
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (info)
+		return info;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+	INIT_HLIST_HEAD(&info->head);
+	rcu_assign_pointer(tp->authopt_info, info);
+
+	return info;
+}
+
+#define TCP_AUTHOPT_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
+
+/* Like copy_from_sockopt except tolerate different optlen for compatibility reasons
+ *
+ * If the src is shorter then it's from an old userspace and the rest of dst is
+ * filled with zeros.
+ *
+ * If the dst is shorter then src is from a newer userspace and we only accept
+ * if the rest of the option is all zeros.
+ *
+ * This allows sockopts to grow as long as for new fields zeros has no effect.
+ */
+static int _copy_from_sockptr_tolerant(
+		u8* dst, unsigned int dstlen,
+		sockptr_t src, unsigned int srclen)
+{
+	int err;
+
+	/* If userspace optlen is too short fill the rest with zeros */
+	if (srclen > dstlen) {
+		if (sockptr_is_kernel(src))
+			return -EINVAL;
+		err = check_zeroed_user(src.user + dstlen, srclen - dstlen);
+		if (err < 0)
+			return err;
+		if (err == 0)
+			return -EINVAL;
+	}
+	err = copy_from_sockptr(dst, src, min(srclen, dstlen));
+	if (err)
+		return err;
+	if (srclen < dstlen)
+		memset(dst + dstlen, 0, dstlen - srclen);
+
+	return err;
+}
+
+int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_authopt opt;
+	struct tcp_authopt_info *info;
+	int err;
+
+	sock_owned_by_me(sk);
+
+	err = _copy_from_sockptr_tolerant((u8*)&opt, sizeof(opt), optval, optlen);
+	if (err)
+		return err;
+
+	if (opt.flags & ~TCP_AUTHOPT_KNOWN_FLAGS)
+		return -EINVAL;
+
+	info = __tcp_authopt_info_get_or_create(sk);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
+
+	return 0;
+}
+
+int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt_info *info;
+
+	sock_owned_by_me(sk);
+
+	memset(opt, 0, sizeof(*opt));
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -ENOENT;
+
+	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
+
+	return 0;
+}
+
+/* Free key nicely, for living sockets */
+static void tcp_authopt_key_del(struct sock *sk,
+				struct tcp_authopt_info *info,
+				struct tcp_authopt_key_info *key)
+{
+	sock_owned_by_me(sk);
+	hlist_del_rcu(&key->node);
+	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
+	kfree_rcu(key, rcu);
+}
+
+/* Free info and keys.
+ * Don't touch tp->authopt_info, it might not even be assigned yes.
+ */
+void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info)
+{
+	struct hlist_node *n;
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry_safe(key, n, &info->head, node) {
+		/* sk is NULL for timewait case
+		 * struct timewait_sock doesn't track sk_omem_alloc
+		 */
+		if (sk)
+			atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
+		hlist_del_rcu(&key->node);
+		kfree_rcu(key, rcu);
+	}
+	kfree_rcu(info, rcu);
+}
+
+/* free everything and clear tcp_sock.authopt_info to NULL */
+void tcp_authopt_clear(struct sock *sk)
+{
+	struct tcp_authopt_info *info;
+
+	info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (info) {
+		tcp_authopt_free(sk, info);
+		tcp_sk(sk)->authopt_info = NULL;
+	}
+}
+
+#define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_KEY_DEL | \
+	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
+	TCP_AUTHOPT_KEY_ADDR_BIND)
+
+int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_authopt_key opt;
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key_info, *old_key_info;
+
+	sock_owned_by_me(sk);
+
+	err = _copy_from_sockptr_tolerant((u8*)&opt, sizeof(opt), optval, optlen);
+	if (err)
+		return err;
+
+	if (opt.flags & ~TCP_AUTHOPT_KEY_KNOWN_FLAGS)
+		return -EINVAL;
+
+	if (opt.keylen > TCP_AUTHOPT_MAXKEYLEN)
+		return -EINVAL;
+
+	/* Delete is a special case: */
+	if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
+		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+		if (!info)
+			return -ENOENT;
+		key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
+		if (!key_info)
+			return -ENOENT;
+		tcp_authopt_key_del(sk, info, key_info);
+		return 0;
+	}
+
+	/* check key family */
+	if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
+		if (sk->sk_family != opt.addr.ss_family)
+			return -EINVAL;
+	}
+
+	/* Initialize tcp_authopt_info if not already set */
+	info = __tcp_authopt_info_get_or_create(sk);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
+	if (!key_info)
+		return -ENOMEM;
+	/* If an old key exists with exact ID then remove and replace.
+	 * RCU-protected readers might observe both and pick any.
+	 */
+	if ((old_key_info = tcp_authopt_key_lookup_exact(sk, info, &opt)))
+		tcp_authopt_key_del(sk, info, old_key_info);
+	key_info->flags = opt.flags & TCP_AUTHOPT_KEY_KNOWN_FLAGS;
+	key_info->send_id = opt.send_id;
+	key_info->recv_id = opt.recv_id;
+	key_info->alg_id = opt.alg;
+	key_info->keylen = opt.keylen;
+	memcpy(key_info->key, opt.key, opt.keylen);
+	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
+	hlist_add_head_rcu(&key_info->node, &info->head);
+
+	return 0;
+}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2e62e0d6373a..1348615c7576 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -60,10 +60,11 @@
 
 #include <net/net_namespace.h>
 #include <net/icmp.h>
 #include <net/inet_hashtables.h>
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/transp_v6.h>
 #include <net/ipv6.h>
 #include <net/inet_common.h>
 #include <net/timewait_sock.h>
 #include <net/xfrm.h>
@@ -2256,10 +2257,11 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		tcp_clear_md5_list(sk);
 		kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
 		tp->md5sig_info = NULL;
 	}
 #endif
+	tcp_authopt_clear(sk);
 
 	/* Clean up a referenced TCP bind bucket. */
 	if (inet_csk(sk)->icsk_bind_hash)
 		inet_put_port(sk);
 
-- 
2.25.1

