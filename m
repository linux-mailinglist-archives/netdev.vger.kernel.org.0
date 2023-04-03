Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0D86D53AE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbjDCVhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjDCVgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:36:08 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3A140C7
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:54 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v1so30784778wrv.1
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GapGtbq8LCwWTdXSvVvddAC2+eoRQyoHOTSSBXaDm2I=;
        b=EcwgihzYfSan7CDmOXRzkUNQGrsrE1BGgGRDgiA0EMlAURP3S4h7rU+9wXADvG48xw
         QD0MiTssXbgONMt4lKz07d67RvtnnI5gTy6FRm9AEDOGGWAfFzjaSj/sxaXkmZ6CvjfH
         eoSDpD2fmOi5O+ymMqkZi3BXiaW5ZGU25O1hd1yL6co2PjxBXPTQgRiTUNXBWhW/UGia
         nAOeiJX2Qh3yTxIrAWpHicB2mJy1GxnUM0BO1+iU899s3635JB24smpQFVHqvHzs02rZ
         Bmev5od6IoBqK+RmGIZC0wiS0nzoDCA36e98irPgvN6zMfBVfyS20XUleoVcOLFkD2uQ
         +QPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GapGtbq8LCwWTdXSvVvddAC2+eoRQyoHOTSSBXaDm2I=;
        b=FQBeLCHSU0e6A9u13rVVygsKMQCorM2yAyu0/xw80Z5O+COWc6WfTb8eBeZBc4iXku
         /Zr+z+qNcLChdBvz52A6TrBWtiKQAmUZT+QUTVaLeWRnELtehLy12BLO4eSBia/KEXeT
         ggVycn7PYTb83v2syw8vVbYKjCVqYi4JDQIdtenLV4lly9g5V6IWKD8a+aYufDIdLDol
         6rd7vgKSAPhitdpQWl1tkRWDtwozwJKO2pQwyShqicKvRaw2/iudXsqUi+kBkFWyaQZ+
         7xWaIQwF8uyn9Qcd6xMZXkF1qLfbOmJW0Xh4TS4GM+6aboqBsUYGqfkZCuM72oOhT4o4
         ozKw==
X-Gm-Message-State: AAQBX9fx3L8ZXPL2ml9z6Fuwn+3uuKP+oDzxisZwSw9PJw+YfM92TGKv
        n7cJW+hQg4hXtZ33J1pDwZsXUQ==
X-Google-Smtp-Source: AKy350YA6CitNtA3EAaq2Z2Tl0jNZYbNaAChAI99T8vjPRIPmUr6Md2bleWJ1X/p1hQN3b8qOUHyJg==
X-Received: by 2002:adf:ee05:0:b0:2e4:c0b5:fdcb with SMTP id y5-20020adfee05000000b002e4c0b5fdcbmr3308wrn.28.1680557692229;
        Mon, 03 Apr 2023 14:34:52 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:51 -0700 (PDT)
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
Subject: [PATCH v5 18/21] net/tcp: Add TCP-AO getsockopt()s
Date:   Mon,  3 Apr 2023 22:34:17 +0100
Message-Id: <20230403213420.1576559-19-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403213420.1576559-1-dima@arista.com>
References: <20230403213420.1576559-1-dima@arista.com>
MIME-Version: 1.0
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

Introduce getsockopt(TCP_AO_GET_KEYS) that lets a user get TCP-AO keys
and their properties from a socket. The user can provide a filter
to match the specific key to be dumped or ::get_all = 1 may be
used to dump all keys in one syscall.

Add another getsockopt(TCP_AO_INFO) for providing per-socket/per-ao_info
stats: packet counters, Current_key/RNext_key and flags like
::ao_required and ::accept_icmps.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h     |  12 ++
 include/uapi/linux/tcp.h |  63 +++++++--
 net/ipv4/tcp.c           |  13 ++
 net/ipv4/tcp_ao.c        | 276 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 350 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index a99521b78147..d1dcda8f81be 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -177,6 +177,8 @@ void tcp_ao_destroy_sock(struct sock *sk, bool twsk);
 u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code);
+int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen);
+int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
 			const struct request_sock *req,
@@ -286,6 +288,16 @@ static inline void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw,
 static inline void tcp_ao_connect_init(struct sock *sk)
 {
 }
+
+static int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	return -ENOPROTOOPT;
+}
+
+static int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	return -ENOPROTOOPT;
+}
 #endif
 
 #if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 3275ade3293a..1109093bbb24 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -131,7 +131,8 @@ enum {
 
 #define TCP_AO_ADD_KEY		38	/* Add/Set MKT */
 #define TCP_AO_DEL_KEY		39	/* Delete MKT */
-#define TCP_AO_INFO		40	/* Modify TCP-AO per-socket options */
+#define TCP_AO_INFO		40	/* Set/list TCP-AO per-socket options */
+#define TCP_AO_GET_KEYS		41	/* List MKT(s) */
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
@@ -392,21 +393,55 @@ struct tcp_ao_del { /* setsockopt(TCP_AO_DEL_KEY) */
 	__u8	keyflags;		/* see TCP_AO_KEYF_ */
 } __attribute__((aligned(8)));
 
-struct tcp_ao_info_opt { /* setsockopt(TCP_AO_INFO) */
-	__u32   set_current	:1,	/* corresponding ::current_key */
-		set_rnext	:1,	/* corresponding ::rnext */
-		ao_required	:1,	/* don't accept non-AO connects */
-		set_counters	:1,	/* set/clear ::pkt_* counters */
-		accept_icmps	:1,	/* accept incoming ICMPs */
+struct tcp_ao_info_opt { /* setsockopt(TCP_AO_INFO), getsockopt(TCP_AO_INFO) */
+	/* Here 'in' is for setsockopt(), 'out' is for getsockopt() */
+	__u32   set_current	:1,	/* in/out: corresponding ::current_key */
+		set_rnext	:1,	/* in/out: corresponding ::rnext */
+		ao_required	:1,	/* in/out: don't accept non-AO connects */
+		set_counters	:1,	/* in: set/clear ::pkt_* counters */
+		accept_icmps	:1,	/* in/out: accept incoming ICMPs */
 		reserved	:27;	/* must be 0 */
 	__u16	reserved2;		/* padding, must be 0 */
-	__u8	current_key;		/* KeyID to set as Current_key */
-	__u8	rnext;			/* KeyID to set as Rnext_key */
-	__u64	pkt_good;		/* verified segments */
-	__u64	pkt_bad;		/* failed verification */
-	__u64	pkt_key_not_found;	/* could not find a key to verify */
-	__u64	pkt_ao_required;	/* segments missing TCP-AO sign */
-	__u64	pkt_dropped_icmp;	/* ICMPs that were ignored */
+	__u8	current_key;		/* in/out: KeyID of Current_key */
+	__u8	rnext;			/* in/out: keyid of RNext_key */
+	__u64	pkt_good;		/* in/out: verified segments */
+	__u64	pkt_bad;		/* in/out: failed verification */
+	__u64	pkt_key_not_found;	/* in/out: could not find a key to verify */
+	__u64	pkt_ao_required;	/* in/out: segments missing TCP-AO sign */
+	__u64	pkt_dropped_icmp;	/* in/out: ICMPs that were ignored */
+} __attribute__((aligned(8)));
+
+struct tcp_ao_getsockopt { /* getsockopt(TCP_AO_GET_KEYS) */
+	struct __kernel_sockaddr_storage addr;	/* in/out: dump keys for peer
+						 * with this address/prefix
+						 */
+	char	alg_name[64];		/* out: crypto hash algorithm */
+	__u8	key[TCP_AO_MAXKEYLEN];
+	__u32	nkeys;			/* in: size of the userspace buffer
+					 * @optval, measured in @optlen - the
+					 * sizeof(struct tcp_ao_getsockopt)
+					 * out: number of keys that matched
+					 */
+	__u16   is_current	:1,	/* in: match and dump Current_key,
+					 * out: the dumped key is Current_key
+					 */
+
+		is_rnext	:1,	/* in: match and dump RNext_key,
+					 * out: the dumped key is RNext_key
+					 */
+		get_all		:1,	/* in: dump all keys */
+		reserved	:13;	/* padding, must be 0 */
+	__u8	sndid;			/* in/out: dump keys with SendID */
+	__u8	rcvid;			/* in/out: dump keys with RecvID */
+	__u8	prefix;			/* in/out: dump keys with address/prefix */
+	__u8	maclen;			/* out: key's length of authentication
+					 * code (hash)
+					 */
+	__u8	keyflags;		/* in/out: see TCP_AO_KEYF_ */
+	__u8	keylen;			/* out: length of ::key */
+	__s32	ifindex;		/* in/out: L3 dev index for VRF */
+	__u64	pkt_good;		/* out: verified segments */
+	__u64	pkt_bad;		/* out: segments that failed verification */
 } __attribute__((aligned(8)));
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6d892fd2abe3..3fee71356250 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4393,6 +4393,19 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 		return err;
 	}
 #endif
+	case TCP_AO_GET_KEYS:
+	case TCP_AO_INFO: {
+		int err;
+
+		sockopt_lock_sock(sk);
+		if (optname == TCP_AO_GET_KEYS)
+			err = tcp_ao_get_mkts(sk, optval, optlen);
+		else
+			err = tcp_ao_get_sock_info(sk, optval, optlen);
+		sockopt_release_sock(sk);
+
+		return err;
+	}
 	default:
 		return -ENOPROTOOPT;
 	}
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 0550bc0fe09d..21242ba2d237 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1725,3 +1725,279 @@ int tcp_v4_parse_ao(struct sock *sk, int cmd, sockptr_t optval, int optlen)
 	return tcp_parse_ao(sk, cmd, AF_INET, optval, optlen);
 }
 
+/* tcp_ao_copy_mkts_to_user(ao_info, optval, optlen)
+ *
+ * @ao_info:	struct tcp_ao_info on the socket that
+ *		socket getsockopt(TCP_AO_GET) is executed on
+ * @optval:	pointer to array of tcp_ao_getsockopt structures in user space.
+ *		Must be != NULL.
+ * @optlen:	pointer to size of tcp_ao_getsockopt structure.
+ *		Must be != NULL.
+ *
+ * Return value: 0 on success, a negative error number otherwise.
+ *
+ * optval points to an array of tcp_ao_getsockopt structures in user space.
+ * optval[0] is used as both input and output to getsockopt. It determines
+ * which keys are returned by the kernel.
+ * optval[0].nkeys is the size of the array in user space. On return it contains
+ * the number of keys matching the search criteria.
+ * If tcp_ao_getsockopt::get_all is set, then all keys in the socket are
+ * returned, otherwise only keys matching <addr, prefix, sndid, rcvid>
+ * in optval[0] are returned.
+ * optlen is also used as both input and output. The user provides the size
+ * of struct tcp_ao_getsockopt in user space, and the kernel returns the size
+ * of the structure in kernel space.
+ * The size of struct tcp_ao_getsockopt may differ between user and kernel.
+ * There are three cases to consider:
+ *  * If usize == ksize, then keys are copied verbatim.
+ *  * If usize < ksize, then the userspace has passed an old struct to a
+ *    newer kernel. The rest of the trailing bytes in optval[0]
+ *    (ksize - usize) are interpreted as 0 by the kernel.
+ *  * If usize > ksize, then the userspace has passed a new struct to an
+ *    older kernel. The trailing bytes unknown to the kernel (usize - ksize)
+ *    are checked to ensure they are zeroed, otherwise -E2BIG is returned.
+ * On return the kernel fills in min(usize, ksize) in each entry of the array.
+ * The layout of the fields in the user and kernel structures is expected to
+ * be the same (including in the 32bit vs 64bit case).
+ */
+static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
+				    sockptr_t optval, sockptr_t optlen)
+{
+	struct tcp_ao_getsockopt opt_in;
+	struct tcp_ao_getsockopt opt_out;
+	int user_len;
+	unsigned int max_keys;	/* maximum number of keys to copy to user */
+	u32 copied_keys;	/* keys copied to user so far */
+	int matched_keys;	/* keys from ao_info matched so far */
+	int bytes_to_write;	/* number of bytes to write to user level */
+	struct tcp_ao_key *key, *current_key;
+	struct sockaddr_in *sin;   /* (struct sockaddr_in *)&opt_in.addr */
+	struct sockaddr_in6 *sin6; /* (struct sockaddr_in6 *)&opt_in.addr */
+	struct in6_addr *addr6;    /* &sin6->sin6_addr */
+	__kernel_sa_family_t ss_family;
+	union tcp_ao_addr *addr;
+	size_t out_offset = 0;
+	int optlen_out;
+	u8 prefix_in;
+	u16 port = 0;
+	int err;
+
+	if (copy_from_sockptr(&user_len, optlen, sizeof(int)))
+		return -EFAULT;
+
+	if (user_len <= 0)
+		return -EINVAL;
+
+	memset(&opt_in, 0, sizeof(struct tcp_ao_getsockopt));
+	err = copy_struct_from_sockptr(&opt_in, sizeof(opt_in),
+				       optval, user_len);
+	if (err < 0)
+		return err;
+
+	ss_family = opt_in.addr.ss_family;
+
+	if (opt_in.pkt_good || opt_in.pkt_bad)
+		return -EINVAL;
+
+	if (opt_in.reserved != 0)
+		return -EINVAL;
+
+	max_keys = opt_in.nkeys;
+
+	if (!(opt_in.get_all || opt_in.is_current || opt_in.is_rnext)) {
+		prefix_in = opt_in.prefix;
+
+		switch (ss_family) {
+		case AF_INET: {
+			sin = (struct sockaddr_in *)&opt_in.addr;
+			port = sin->sin_port;
+			addr = (union tcp_ao_addr *)&sin->sin_addr;
+
+			if (prefix_in > 32)
+				return -EINVAL;
+
+			if (sin->sin_addr.s_addr == INADDR_ANY &&
+			    prefix_in != 0)
+				return -EINVAL;
+
+			break;
+		}
+		case AF_INET6: {
+			sin6 = (struct sockaddr_in6 *)&opt_in.addr;
+			addr = (union tcp_ao_addr *)&sin6->sin6_addr;
+			addr6 = &sin6->sin6_addr;
+			port = sin6->sin6_port;
+
+			if (prefix_in != 0) {
+				if (ipv6_addr_v4mapped(addr6)) {
+					__be32 addr4 = addr6->s6_addr32[3];
+
+					if (prefix_in > 32 ||
+					    addr4 == INADDR_ANY)
+						return -EINVAL;
+				} else {
+					if (ipv6_addr_any(addr6) ||
+					    prefix_in > 128)
+						return -EINVAL;
+				}
+			} else if (!ipv6_addr_any(addr6)) {
+				return -EINVAL;
+			}
+
+			break;
+		}
+		default:
+			return -EAFNOSUPPORT;
+		}
+	}
+
+	bytes_to_write = min(user_len, (int)sizeof(struct tcp_ao_getsockopt));
+	copied_keys = 0;
+	matched_keys = 0;
+	/* May change in RX, while we're dumping, pre-fetch it */
+	current_key = READ_ONCE(ao_info->current_key);
+
+	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+		if (opt_in.get_all)
+			goto match;
+
+		if (opt_in.is_current || opt_in.is_rnext) {
+			if (opt_in.is_current && key == current_key)
+				goto match;
+			if (opt_in.is_rnext && key == ao_info->rnext_key)
+				goto match;
+			continue;
+		}
+
+		if (tcp_ao_key_cmp(key, addr, opt_in.prefix,
+				   opt_in.addr.ss_family,
+				   opt_in.sndid, opt_in.rcvid, port) != 0)
+			continue;
+match:
+		matched_keys++;
+		if (copied_keys >= max_keys)
+			continue;
+
+		memset(&opt_out, 0, sizeof(struct tcp_ao_getsockopt));
+
+		if (key->family == AF_INET) {
+			struct sockaddr_in *sin_out = (struct sockaddr_in *)&opt_out.addr;
+
+			sin_out->sin_family = key->family;
+			sin_out->sin_port = ntohs(key->port);
+			memcpy(&sin_out->sin_addr, &key->addr, sizeof(struct in_addr));
+		} else {
+			struct sockaddr_in6 *sin6_out = (struct sockaddr_in6 *)&opt_out.addr;
+
+			sin6_out->sin6_family = key->family;
+			sin6_out->sin6_port = ntohs(key->port);
+			memcpy(&sin6_out->sin6_addr, &key->addr, sizeof(struct in6_addr));
+		}
+		opt_out.sndid = key->sndid;
+		opt_out.rcvid = key->rcvid;
+		opt_out.prefix = key->prefixlen;
+		opt_out.keyflags = key->keyflags;
+		opt_out.is_current = (key == current_key);
+		opt_out.is_rnext = (key == ao_info->rnext_key);
+		opt_out.nkeys = 0;
+		opt_out.maclen = key->maclen;
+		opt_out.keylen = key->keylen;
+		opt_out.pkt_good = atomic64_read(&key->pkt_good);
+		opt_out.pkt_bad = atomic64_read(&key->pkt_bad);
+		memcpy(&opt_out.key, key->key, key->keylen);
+		tcp_sigpool_algo(key->tcp_sigpool_id, opt_out.alg_name, 64);
+
+		/* Copy key to user */
+		if (copy_to_sockptr_offset(optval, out_offset,
+					   &opt_out, bytes_to_write))
+			return -EFAULT;
+		out_offset += user_len;
+		copied_keys++;
+	}
+
+	optlen_out = (int)sizeof(struct tcp_ao_getsockopt);
+	if (copy_to_sockptr(optlen, &optlen_out, sizeof(int)))
+		return -EFAULT;
+
+	out_offset = offsetof(struct tcp_ao_getsockopt, nkeys);
+	if (copy_to_sockptr_offset(optval, out_offset,
+				   &matched_keys, sizeof(u32)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	struct tcp_ao_info *ao_info;
+	u32 state;
+
+	/* Check socket state */
+	state = (1 << sk->sk_state) &
+		(TCPF_CLOSE | TCPF_ESTABLISHED | TCPF_LISTEN);
+	if (!state)
+		return -ESOCKTNOSUPPORT;
+
+	/* Check ao_info */
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return -ENOENT;
+
+	return tcp_ao_copy_mkts_to_user(ao_info, optval, optlen);
+}
+
+int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	struct tcp_ao_info_opt out, in = {};
+	struct tcp_ao_key *current_key;
+	struct tcp_ao_info *ao;
+	int err, len;
+
+	if (copy_from_sockptr(&len, optlen, sizeof(int)))
+		return -EFAULT;
+
+	if (len <= 0)
+		return -EINVAL;
+
+	/* Copying this "in" only to check ::reserved, ::reserved2,
+	 * that may be needed to extend (struct tcp_ao_info_opt) and
+	 * what getsockopt() provides in future.
+	 */
+	err = copy_struct_from_sockptr(&in, sizeof(in), optval, len);
+	if (err)
+		return err;
+
+	if (in.reserved != 0 || in.reserved2 != 0)
+		return -EINVAL;
+
+	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao)
+		return -ENOENT;
+
+	memset(&out, 0, sizeof(out));
+	out.ao_required		= ao->ao_required;
+	out.accept_icmps	= ao->accept_icmps;
+	out.pkt_good		= atomic64_read(&ao->counters.pkt_good);
+	out.pkt_bad		= atomic64_read(&ao->counters.pkt_bad);
+	out.pkt_key_not_found	= atomic64_read(&ao->counters.key_not_found);
+	out.pkt_ao_required	= atomic64_read(&ao->counters.ao_required);
+	out.pkt_dropped_icmp	= atomic64_read(&ao->counters.dropped_icmp);
+
+	current_key = READ_ONCE(ao->current_key);
+	if (current_key) {
+		out.set_current = 1;
+		out.current_key = current_key->sndid;
+	}
+	if (ao->rnext_key) {
+		out.set_rnext = 1;
+		out.rnext = ao->rnext_key->rcvid;
+	}
+
+	if (copy_to_sockptr(optval, &out, min_t(int, len, sizeof(out))))
+		return -EFAULT;
+
+	return 0;
+}
+
-- 
2.40.0

