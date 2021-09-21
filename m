Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2796E413734
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbhIUQSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbhIUQSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:24 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CB9C061575;
        Tue, 21 Sep 2021 09:16:55 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id bx4so32130791edb.4;
        Tue, 21 Sep 2021 09:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TGD8Zo75Jqbv0QbP3e07tR+UA7kcSP/jAo1qSepcsg0=;
        b=o6Gnq8aO5EKMmhVC6JlNVFLIi38nSs4NO06S/ZR4FQaS5VC3ZobovlTvItuXPms6MF
         oBexTps/VF53ijhaDTf/5ILlr2d8KKohzgFnTPRsIqyk2NJ6x5errU+rGUGiuejrbGqx
         QA6ziZW5WIrZ4k7AhIWVvIFvS2llkkVFfVTMZCn8xuFBt3+hyX07TW4vmkLQun9PcWTM
         6fRY2QY3Egbk1iqDYM65CuXisOuq5t1fXQTrAdRCfJZiUUwGpjxwhl/aI5HepHB7TNUG
         3FJYdhZdxUwYI77p1Tp6vdTlCYOlBOrUadQO0H73nvA6lzptS6nWiigoP1R+XZNXzWyI
         +PIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TGD8Zo75Jqbv0QbP3e07tR+UA7kcSP/jAo1qSepcsg0=;
        b=Gg751N8Ua11NfXfjj24sfPx4p3WCQo05YRFCBQxAmG+E3I5dMnwOc3L5CJRp1327n3
         a3vCQeJQDZBf0gYr9gt6uSA9SEit/1Qvs1Csyvbe7yjYn7YZmxVZ57pwZ+WY57cQeJu3
         Tm2IqQILlbtaTvEO/NWdx5O38vltR6bz5vJ6GlNYyPgb12N1YveSY2nABapGHpT1ymGe
         r7shhVTfLCa1LlUMONvGeJuS3bT3zdEiCMDqWCBZpLMQ3x30LSZRn1BypbpNxoiwTIqX
         obc5odySezDV523bJ+qaZgPfOoIJdhCxfwjUeS7mO4dfrP04hpPTRtISx+lhRgQpogP+
         l+rw==
X-Gm-Message-State: AOAM533HD9HHHWaUggadlj+atXwOOIrAAWjnd+Fdxe4RnjnLlN7ctgQI
        CtqPxEeFocbzJyY6CGMaqfs=
X-Google-Smtp-Source: ABdhPJyjleb8Vgy1RwZzojdy2jTfZ1xXgVF64XtFZVGfGDAJh2MYf20nAa7qFABwIL/zai0UiFzWjg==
X-Received: by 2002:aa7:c80d:: with SMTP id a13mr35625949edt.71.1632240927906;
        Tue, 21 Sep 2021 09:15:27 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:27 -0700 (PDT)
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
Subject: [PATCH 07/19] tcp: authopt: Hook into tcp core
Date:   Tue, 21 Sep 2021 19:14:50 +0300
Message-Id: <fb5ebf0ca19f9d2dcc0aa3b8297118424d6cfcfb.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcp_authopt features exposes a minimal interface to the rest of the
TCP stack. Only a few functions are exposed and if the feature is
disabled they return neutral values, avoiding ifdefs in the rest of the
code.

Add calls into tcp authopt from send, receive and accept code.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h | 103 +++++++++++++++
 include/uapi/linux/snmp.h |   1 +
 net/ipv4/proc.c           |   1 +
 net/ipv4/tcp_authopt.c    | 263 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c      |  17 +++
 net/ipv4/tcp_ipv4.c       |  20 ++-
 net/ipv4/tcp_minisocks.c  |  12 ++
 net/ipv4/tcp_output.c     |  80 +++++++++++-
 net/ipv6/tcp_ipv6.c       |  21 ++-
 9 files changed, 512 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index f6d7d6fa50c0..263f98c3a1a8 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -51,28 +51,131 @@ struct tcp_authopt_info {
 	u32 src_isn;
 	u32 dst_isn;
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
+DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed);
+
+void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info);
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
+struct tcp_authopt_key_info *__tcp_authopt_select_key(
+		const struct sock *sk,
+		struct tcp_authopt_info *info,
+		const struct sock *addr_sk,
+		u8 *rnextkeyid);
+static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
+		const struct sock *sk,
+		const struct sock *addr_sk,
+		u8 *rnextkeyid)
+{
+	if (static_branch_unlikely(&tcp_authopt_needed)) {
+		struct tcp_authopt_info *info = rcu_dereference(tcp_sk(sk)->authopt_info);
+
+		if (info)
+			return __tcp_authopt_select_key(sk, info, addr_sk, rnextkeyid);
+	}
+	return NULL;
+}
+int tcp_authopt_hash(
+		char *hash_location,
+		struct tcp_authopt_key_info *key,
+		struct sock *sk, struct sk_buff *skb);
+int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req);
+static inline int tcp_authopt_openreq(
+		struct sock *newsk,
+		const struct sock *oldsk,
+		struct request_sock *req)
+{
+	if (!rcu_dereference(tcp_sk(oldsk)->authopt_info))
+		return 0;
+	else
+		return __tcp_authopt_openreq(newsk, oldsk, req);
+}
+static inline void tcp_authopt_time_wait(
+		struct tcp_timewait_sock *tcptw,
+		struct tcp_sock *tp)
+{
+	if (static_branch_unlikely(&tcp_authopt_needed)) {
+		/* Transfer ownership of authopt_info to the twsk
+		 * This requires no other users of the origin sock.
+		 */
+		sock_owned_by_me((struct sock *)tp);
+		tcptw->tw_authopt_info = tp->authopt_info;
+		tp->authopt_info = NULL;
+	} else {
+		tcptw->tw_authopt_info = NULL;
+	}
+}
+int __tcp_authopt_inbound_check(
+		struct sock *sk,
+		struct sk_buff *skb,
+		struct tcp_authopt_info *info);
+/** tcp_authopt_inbound_check - check for valid TCP-AO signature.
+ *
+ * Return negative ERRNO on error, 0 if not present and 1 if present and valid
+ * If both TCP-AO and MD5 signatures are found this is reported as an error.
+ */
+static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
+{
+	if (static_branch_unlikely(&tcp_authopt_needed)) {
+		struct tcp_authopt_info *info = rcu_dereference(tcp_sk(sk)->authopt_info);
+
+		if (info)
+			return __tcp_authopt_inbound_check(sk, skb, info);
+	}
+
+	return 0;
+}
 #else
 static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
 static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
 {
 	return -ENOPROTOOPT;
 }
+static inline void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info)
+{
+}
 static inline void tcp_authopt_clear(struct sock *sk)
 {
 }
 static inline int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
+static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
+		const struct sock *sk,
+		const struct sock *addr_sk,
+		u8 *rnextkeyid)
+{
+	return NULL;
+}
+static inline int tcp_authopt_hash(
+		char *hash_location,
+		struct tcp_authopt_key_info *key,
+		struct sock *sk, struct sk_buff *skb)
+{
+	return -EINVAL;
+}
+static inline int tcp_authopt_openreq(struct sock *newsk,
+				      const struct sock *oldsk,
+				      struct request_sock *req)
+{
+	return 0;
+}
+static inline void tcp_authopt_time_wait(
+		struct tcp_timewait_sock *tcptw,
+		struct tcp_sock *tp);
+{
+}
+static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
+{
+	return 0;
+}
 #endif
 
 #endif /* _LINUX_TCP_AUTHOPT_H */
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..1d96030889a1 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -290,10 +290,11 @@ enum
 	LINUX_MIB_TCPDUPLICATEDATAREHASH,	/* TCPDuplicateDataRehash */
 	LINUX_MIB_TCPDSACKRECVSEGS,		/* TCPDSACKRecvSegs */
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
+	LINUX_MIB_TCPAUTHOPTFAILURE,		/* TCPAuthOptFailure */
 	__LINUX_MIB_MAX
 };
 
 /* linux Xfrm mib definitions */
 enum
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index b0d3a09dc84e..61dd06f8389c 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -295,10 +295,11 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TcpDuplicateDataRehash", LINUX_MIB_TCPDUPLICATEDATAREHASH),
 	SNMP_MIB_ITEM("TCPDSACKRecvSegs", LINUX_MIB_TCPDSACKRECVSEGS),
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
+	SNMP_MIB_ITEM("TCPAuthOptFailure", LINUX_MIB_TCPAUTHOPTFAILURE),
 	SNMP_MIB_SENTINEL
 };
 
 static void icmpmsg_put_line(struct seq_file *seq, unsigned long *vals,
 			     unsigned short *type, int count)
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index e2fd851b687b..0c32b8fb1d41 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -3,10 +3,15 @@
 #include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/tcp_authopt.h>
 #include <crypto/hash.h>
 
+/* This is enabled when first struct tcp_authopt_info is allocated and never released */
+DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed);
+/* only for CONFIG_IPV6=m */
+EXPORT_SYMBOL(tcp_authopt_needed);
+
 /* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
 #define TCP_AUTHOPT_MAXMACBUF			20
 #define TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN		20
 #define TCP_AUTHOPT_MACLEN			12
 
@@ -190,10 +195,57 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
 			return false;
 
 	return true;
 }
 
+static bool tcp_authopt_key_match_skb_addr(
+		struct tcp_authopt_key_info *key,
+		struct sk_buff *skb)
+{
+	u16 keyaf = key->addr.ss_family;
+	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+
+	if (keyaf == AF_INET && iph->version == 4) {
+		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+
+		return iph->saddr == key_addr->sin_addr.s_addr;
+	} else if (keyaf == AF_INET6 && iph->version == 6) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
+
+		return ipv6_addr_equal(&ip6h->saddr, &key_addr->sin6_addr);
+	} else {
+		/* This actually happens with ipv6-mapped-ipv4-addresses
+		 * IPv6 listen sockets will be asked to validate ipv4 packets.
+		 */
+		return false;
+	}
+}
+
+static bool tcp_authopt_key_match_sk_addr(
+		struct tcp_authopt_key_info *key,
+		const struct sock *addr_sk)
+{
+	u16 keyaf = key->addr.ss_family;
+
+	/* This probably can't happen even with ipv4-mapped-ipv6 */
+	if (keyaf != addr_sk->sk_family)
+		return false;
+
+	if (keyaf == AF_INET) {
+		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+
+		return addr_sk->sk_daddr == key_addr->sin_addr.s_addr;
+	} else if (keyaf == AF_INET6) {
+		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
+
+		return ipv6_addr_equal(&addr_sk->sk_v6_daddr, &key_addr->sin6_addr);
+	}
+
+	return false;
+}
+
 static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct sock *sk,
 								 struct tcp_authopt_info *info,
 								 struct tcp_authopt_key *ukey)
 {
 	struct tcp_authopt_key_info *key_info;
@@ -203,10 +255,49 @@ static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct so
 			return key_info;
 
 	return NULL;
 }
 
+static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_info *info,
+							    const struct sock *addr_sk,
+							    int send_id)
+{
+	struct tcp_authopt_key_info *result = NULL;
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
+		if (send_id >= 0 && key->send_id != send_id)
+			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
+			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
+				continue;
+		if (result && net_ratelimit())
+			pr_warn("ambiguous tcp authentication keys configured for send\n");
+		result = key;
+	}
+
+	return result;
+}
+
+/**
+ * tcp_authopt_select_key - select key for sending
+ *
+ * addr_sk is the sock used for comparing daddr, it is only different from sk in
+ * the synack case.
+ *
+ * Result is protected by RCU and can't be stored, it may only be passed to
+ * tcp_authopt_hash and only under a single rcu_read_lock.
+ */
+struct tcp_authopt_key_info *__tcp_authopt_select_key(
+		const struct sock *sk,
+		struct tcp_authopt_info *info,
+		const struct sock *addr_sk,
+		u8 *rnextkeyid)
+{
+	return tcp_authopt_lookup_send(info, addr_sk, -1);
+}
+
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
 
@@ -216,10 +307,12 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
+	/* Never released: */
+	static_branch_inc(&tcp_authopt_needed);
 	sk_nocaps_add(sk, NETIF_F_GSO_MASK);
 	INIT_HLIST_HEAD(&info->head);
 	rcu_assign_pointer(tp->authopt_info, info);
 
 	return info;
@@ -506,10 +599,65 @@ static int tcp_authopt_get_isn(struct sock *sk,
 	} else {
 		*sisn = htonl(authopt_info->src_isn);
 		*disn = htonl(authopt_info->dst_isn);
 	}
 	rcu_read_unlock();
+
+	return 0;
+}
+
+static int tcp_authopt_clone_keys(struct sock *newsk,
+				  const struct sock *oldsk,
+				  struct tcp_authopt_info *new_info,
+				  struct tcp_authopt_info *old_info)
+{
+	struct tcp_authopt_key_info *old_key;
+	struct tcp_authopt_key_info *new_key;
+
+	hlist_for_each_entry_rcu(old_key, &old_info->head, node, lockdep_sock_is_held(oldsk)) {
+		new_key = sock_kmalloc(newsk, sizeof(*new_key), GFP_ATOMIC);
+		if (!new_key)
+			return -ENOMEM;
+		memcpy(new_key, old_key, sizeof(*new_key));
+		hlist_add_head_rcu(&new_key->node, &new_info->head);
+	}
+
+	return 0;
+}
+
+/** Called to create accepted sockets.
+ *
+ *  Need to copy authopt info from listen socket.
+ */
+int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req)
+{
+	struct tcp_authopt_info *old_info;
+	struct tcp_authopt_info *new_info;
+	int err;
+
+	old_info = rcu_dereference(tcp_sk(oldsk)->authopt_info);
+	if (!old_info)
+		return 0;
+
+	/* Clear value copies from oldsk: */
+	rcu_assign_pointer(tcp_sk(newsk)->authopt_info, NULL);
+
+	new_info = kzalloc(sizeof(*new_info), GFP_ATOMIC);
+	if (!new_info)
+		return -ENOMEM;
+
+	new_info->src_isn = tcp_rsk(req)->snt_isn;
+	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
+	INIT_HLIST_HEAD(&new_info->head);
+	err = tcp_authopt_clone_keys(newsk, oldsk, new_info, old_info);
+	if (err) {
+		tcp_authopt_free(newsk, new_info);
+		return err;
+	}
+	sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
+	rcu_assign_pointer(tcp_sk(newsk)->authopt_info, new_info);
+
 	return 0;
 }
 
 /* feed traffic key into shash */
 static int tcp_authopt_shash_traffic_key(struct shash_desc *desc,
@@ -933,5 +1081,120 @@ static int __tcp_authopt_calc_mac(struct sock *sk,
 
 out:
 	tcp_authopt_put_mac_shash(key, mac_tfm);
 	return err;
 }
+
+/**
+ * tcp_authopt_hash - fill in the mac
+ *
+ * The key must come from tcp_authopt_select_key.
+ */
+int tcp_authopt_hash(char *hash_location,
+		     struct tcp_authopt_key_info *key,
+		     struct sock *sk,
+		     struct sk_buff *skb)
+{
+	/* MAC inside option is truncated to 12 bytes but crypto API needs output
+	 * buffer to be large enough so we use a buffer on the stack.
+	 */
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	int err;
+
+	err = __tcp_authopt_calc_mac(sk, skb, key, false, macbuf);
+	if (err) {
+		/* If mac calculation fails and caller doesn't handle the error
+		 * try to make it obvious inside the packet.
+		 */
+		memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
+		return err;
+	}
+	memcpy(hash_location, macbuf, TCP_AUTHOPT_MACLEN);
+
+	return 0;
+}
+
+static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
+							    struct sk_buff *skb,
+							    struct tcp_authopt_info *info,
+							    int recv_id)
+{
+	struct tcp_authopt_key_info *result = NULL;
+	struct tcp_authopt_key_info *key;
+
+	/* multiple matches will cause occasional failures */
+	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
+		if (recv_id >= 0 && key->recv_id != recv_id)
+			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND &&
+				!tcp_authopt_key_match_skb_addr(key, skb))
+			continue;
+		if (result && net_ratelimit())
+			pr_warn("ambiguous tcp authentication keys configured for receive\n");
+		result = key;
+	}
+
+	return result;
+}
+
+int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp_authopt_info *info)
+{
+	struct tcphdr *th = (struct tcphdr *)skb_transport_header(skb);
+	struct tcphdr_authopt *opt;
+	struct tcp_authopt_key_info *key;
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	int err;
+
+	opt = (struct tcphdr_authopt *)tcp_authopt_find_option(th);
+	/* RFC5925 2.2: An endpoint MUST NOT use TCP-AO for the same connection
+	 * in which TCP MD5 is used. When both options appear, TCP MUST silently
+	 * discard the segment.
+	 */
+	if (tcp_parse_md5sig_option(th)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		return -EINVAL;
+	}
+	key = tcp_authopt_lookup_recv(sk, skb, info, opt ? opt->keyid : -1);
+
+	/* nothing found or expected */
+	if (!opt && !key)
+		return 0;
+	if (!opt && key) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		net_info_ratelimited("TCP Authentication Missing\n");
+		return -EINVAL;
+	}
+	if (opt && !key) {
+		/* RFC5925 Section 7.3:
+		 * A TCP-AO implementation MUST allow for configuration of the behavior
+		 * of segments with TCP-AO but that do not match an MKT. The initial
+		 * default of this configuration SHOULD be to silently accept such
+		 * connections.
+		 */
+		if (info->flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED) {
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+			net_info_ratelimited("TCP Authentication Unexpected: Rejected\n");
+			return -EINVAL;
+		} else {
+			net_info_ratelimited("TCP Authentication Unexpected: Accepted\n");
+			return 0;
+		}
+	}
+
+	/* bad inbound key len */
+	if (TCPOLEN_AUTHOPT_OUTPUT != opt->len)
+		return -EINVAL;
+
+	err = __tcp_authopt_calc_mac(sk, skb, key, true, macbuf);
+	if (err)
+		return err;
+
+	if (memcmp(macbuf, opt->mac, TCP_AUTHOPT_MACLEN)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		net_info_ratelimited("TCP Authentication Failed\n");
+		return -EINVAL;
+	}
+
+	return 1;
+}
+/* only for CONFIG_IPV6=m */
+EXPORT_SYMBOL(__tcp_authopt_inbound_check);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 141e85e6422b..7691eac93051 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -70,10 +70,11 @@
 #include <linux/sysctl.h>
 #include <linux/kernel.h>
 #include <linux/prefetch.h>
 #include <net/dst.h>
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/inet_common.h>
 #include <linux/ipsec.h>
 #include <asm/unaligned.h>
 #include <linux/errqueue.h>
 #include <trace/events/tcp.h>
@@ -5967,18 +5968,34 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 	if (!icsk->icsk_ca_initialized)
 		tcp_init_congestion_control(sk);
 	tcp_init_buffer_space(sk);
 }
 
+static void tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb)
+{
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *info;
+
+	info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return;
+
+	info->src_isn = ntohl(tcp_hdr(skb)->ack_seq) - 1;
+	info->dst_isn = ntohl(tcp_hdr(skb)->seq);
+#endif
+}
+
 void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	tcp_set_state(sk, TCP_ESTABLISHED);
 	icsk->icsk_ack.lrcvtime = tcp_jiffies32;
 
+	tcp_authopt_finish_connect(sk, skb);
+
 	if (skb) {
 		icsk->icsk_af_ops->sk_rx_dst_set(sk, skb);
 		security_inet_conn_established(sk, skb);
 		sk_mark_napi_id(sk, skb);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1348615c7576..e5c790795662 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1933,10 +1933,26 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
 	TCP_SKB_CB(skb)->sacked	 = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
 			skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
 }
 
+static int tcp_v4_auth_inbound_check(
+		struct sock *sk,
+		struct sk_buff *skb,
+		int dif, int sdif)
+{
+	int aoret;
+
+	aoret = tcp_authopt_inbound_check(sk, skb);
+	if (aoret < 0)
+		return aoret;
+	if (aoret > 0)
+		return 0;
+
+	return tcp_v4_inbound_md5_hash(sk, skb, dif, sdif);
+}
+
 /*
  *	From tcp_input.c
  */
 
 int tcp_v4_rcv(struct sk_buff *skb)
@@ -1991,11 +2007,11 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct request_sock *req = inet_reqsk(sk);
 		bool req_stolen = false;
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
+		if (unlikely(tcp_v4_auth_inbound_check(sk, skb, dif, sdif))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
 		}
 		if (tcp_checksum_complete(skb)) {
@@ -2057,11 +2073,11 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	}
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
+	if (tcp_v4_auth_inbound_check(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
 	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb))
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cf913a66df17..d4828cf3d6d1 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -18,10 +18,11 @@
  *		Arnt Gulbrandsen, <agulbra@nvg.unit.no>
  *		Jorge Cwik, <jorge@laser.satlink.net>
  */
 
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/xfrm.h>
 #include <net/busy_poll.h>
 
 static bool tcp_in_window(u32 seq, u32 end_seq, u32 s_win, u32 e_win)
 {
@@ -300,10 +301,11 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
 				}
 			}
 		} while (0);
 #endif
+		tcp_authopt_time_wait(tcptw, tcp_sk(sk));
 
 		/* Get the TIME_WAIT timeout firing. */
 		if (timeo < rto)
 			timeo = rto;
 
@@ -342,10 +344,19 @@ void tcp_twsk_destructor(struct sock *sk)
 
 		if (twsk->tw_md5_key)
 			kfree_rcu(twsk->tw_md5_key, rcu);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	if (static_branch_unlikely(&tcp_authopt_needed)) {
+		struct tcp_timewait_sock *twsk = tcp_twsk(sk);
+
+		/* twsk only contains sock_common so pass NULL as sk. */
+		if (twsk->tw_authopt_info)
+			tcp_authopt_free(NULL, twsk->tw_authopt_info);
+	}
+#endif
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
 /* Warning : This function is called without sk_listener being locked.
  * Be sure to read socket fields once, as their value could change under us.
@@ -532,10 +543,11 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 #ifdef CONFIG_TCP_MD5SIG
 	newtp->md5sig_info = NULL;	/*XXX*/
 	if (newtp->af_specific->md5_lookup(sk, newsk))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+	tcp_authopt_openreq(newsk, sk, req);
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
 		newicsk->icsk_ack.last_seg_size = skb->len - newtp->tcp_header_len;
 	newtp->rx_opt.mss_clamp = req->mss;
 	tcp_ecn_openreq_child(newtp, req);
 	newtp->fastopen_req = NULL;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6d72f3ea48c4..fe5be506edb2 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -37,10 +37,11 @@
 
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <net/tcp.h>
 #include <net/mptcp.h>
+#include <net/tcp_authopt.h>
 
 #include <linux/compiler.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
 #include <linux/static_key.h>
@@ -411,10 +412,11 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 
 #define OPTION_SACK_ADVERTISE	(1 << 0)
 #define OPTION_TS		(1 << 1)
 #define OPTION_MD5		(1 << 2)
 #define OPTION_WSCALE		(1 << 3)
+#define OPTION_AUTHOPT		(1 << 4)
 #define OPTION_FAST_OPEN_COOKIE	(1 << 8)
 #define OPTION_SMC		(1 << 9)
 #define OPTION_MPTCP		(1 << 10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
@@ -435,16 +437,21 @@ static void smc_options_write(__be32 *ptr, u16 *options)
 struct tcp_out_options {
 	u16 options;		/* bit field of OPTION_* */
 	u16 mss;		/* 0 to disable */
 	u8 ws;			/* window scale, 0 to disable */
 	u8 num_sack_blocks;	/* number of SACK blocks to include */
-	u8 hash_size;		/* bytes in hash_location */
 	u8 bpf_opt_len;		/* length of BPF hdr option */
+#ifdef CONFIG_TCP_AUTHOPT
+	u8 authopt_rnextkeyid;	/* rnextkey */
+#endif
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
 	struct mptcp_out_options mptcp;
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_key_info *authopt_key;
+#endif
 };
 
 static void mptcp_options_write(__be32 *ptr, const struct tcp_sock *tp,
 				struct tcp_out_options *opts)
 {
@@ -617,10 +624,25 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 		/* overload cookie hash location */
 		opts->hash_location = (__u8 *)ptr;
 		ptr += 4;
 	}
 
+#ifdef CONFIG_TCP_AUTHOPT
+	if (unlikely(OPTION_AUTHOPT & options)) {
+		struct tcp_authopt_key_info *key = opts->authopt_key;
+
+		WARN_ON(!key);
+		*ptr = htonl((TCPOPT_AUTHOPT << 24) |
+			     (TCPOLEN_AUTHOPT_OUTPUT << 16) |
+			     (key->send_id << 8) |
+			     opts->authopt_rnextkeyid);
+		/* overload cookie hash location */
+		opts->hash_location = (__u8 *)(ptr + 1);
+		ptr += TCPOLEN_AUTHOPT_OUTPUT / 4;
+	}
+#endif
+
 	if (unlikely(opts->mss)) {
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
 			       (TCPOLEN_MSS << 16) |
 			       opts->mss);
 	}
@@ -752,10 +774,28 @@ static void mptcp_set_option_cond(const struct request_sock *req,
 			}
 		}
 	}
 }
 
+static int tcp_authopt_init_options(const struct sock *sk,
+				    const struct sock *addr_sk,
+				    struct tcp_out_options *opts)
+{
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_key_info *key;
+
+	key = tcp_authopt_select_key(sk, addr_sk, &opts->authopt_rnextkeyid);
+	if (key) {
+		opts->options |= OPTION_AUTHOPT;
+		opts->authopt_key = key;
+		return TCPOLEN_AUTHOPT_OUTPUT;
+	}
+#endif
+
+	return 0;
+}
+
 /* Compute TCP options for SYN packets. This is not the final
  * network wire format yet.
  */
 static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 				struct tcp_out_options *opts,
@@ -764,12 +804,15 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
 	struct tcp_fastopen_request *fastopen = tp->fastopen_req;
 
 	*md5 = NULL;
+
+	remaining -= tcp_authopt_init_options(sk, sk, opts);
 #ifdef CONFIG_TCP_MD5SIG
 	if (static_branch_unlikely(&tcp_md5_needed) &&
+	    !(opts->options & OPTION_AUTHOPT) &&
 	    rcu_access_pointer(tp->md5sig_info)) {
 		*md5 = tp->af_specific->md5_lookup(sk, sk);
 		if (*md5) {
 			opts->options |= OPTION_MD5;
 			remaining -= TCPOLEN_MD5SIG_ALIGNED;
@@ -848,12 +891,13 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 				       struct sk_buff *syn_skb)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
 
+	remaining -= tcp_authopt_init_options(sk, req_to_sk(req), opts);
 #ifdef CONFIG_TCP_MD5SIG
-	if (md5) {
+	if (md5 && !(opts->options & OPTION_AUTHOPT)) {
 		opts->options |= OPTION_MD5;
 		remaining -= TCPOLEN_MD5SIG_ALIGNED;
 
 		/* We can't fit any SACK blocks in a packet with MD5 + TS
 		 * options. There was discussion about disabling SACK
@@ -919,13 +963,15 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 	unsigned int size = 0;
 	unsigned int eff_sacks;
 
 	opts->options = 0;
 
+	size += tcp_authopt_init_options(sk, sk, opts);
 	*md5 = NULL;
 #ifdef CONFIG_TCP_MD5SIG
 	if (static_branch_unlikely(&tcp_md5_needed) &&
+	    !(opts->options & OPTION_AUTHOPT) &&
 	    rcu_access_pointer(tp->md5sig_info)) {
 		*md5 = tp->af_specific->md5_lookup(sk, sk);
 		if (*md5) {
 			opts->options |= OPTION_MD5;
 			size += TCPOLEN_MD5SIG_ALIGNED;
@@ -1277,10 +1323,14 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 
 	inet = inet_sk(sk);
 	tcb = TCP_SKB_CB(skb);
 	memset(&opts, 0, sizeof(opts));
 
+#ifdef CONFIG_TCP_AUTHOPT
+	/* for tcp_authopt_init_options inside tcp_syn_options or tcp_established_options */
+	rcu_read_lock();
+#endif
 	if (unlikely(tcb->tcp_flags & TCPHDR_SYN)) {
 		tcp_options_size = tcp_syn_options(sk, skb, &opts, &md5);
 	} else {
 		tcp_options_size = tcp_established_options(sk, skb, &opts,
 							   &md5);
@@ -1365,10 +1415,17 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
 		tp->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, sk, skb);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	if (opts.authopt_key) {
+		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+		tcp_authopt_hash(opts.hash_location, opts.authopt_key, sk, skb);
+	}
+	rcu_read_unlock();
+#endif
 
 	/* BPF prog is the last one writing header option */
 	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
 
 	INDIRECT_CALL_INET(icsk->icsk_af_ops->send_check,
@@ -1836,12 +1893,21 @@ unsigned int tcp_current_mss(struct sock *sk)
 		u32 mtu = dst_mtu(dst);
 		if (mtu != inet_csk(sk)->icsk_pmtu_cookie)
 			mss_now = tcp_sync_mss(sk, mtu);
 	}
 
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Even if the result is not used rcu_read_lock is required when scanning for
+	 * tcp authentication keys. Otherwise lockdep will complain.
+	 */
+	rcu_read_lock();
+#endif
 	header_len = tcp_established_options(sk, NULL, &opts, &md5) +
 		     sizeof(struct tcphdr);
+#ifdef CONFIG_TCP_AUTHOPT
+	rcu_read_unlock();
+#endif
 	/* The mss_cache is sized based on tp->tcp_header_len, which assumes
 	 * some common options. If this is an odd packet (because we have SACK
 	 * blocks etc) then our calculated header_len will be different, and
 	 * we have to adjust mss_now correspondingly */
 	if (header_len != tp->tcp_header_len) {
@@ -3566,10 +3632,14 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	}
 
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	md5 = tcp_rsk(req)->af_specific->req_md5_lookup(sk, req_to_sk(req));
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* for tcp_authopt_init_options inside tcp_synack_options */
+	rcu_read_lock();
 #endif
 	skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
 	/* bpf program will be interested in the tcp_flags */
 	TCP_SKB_CB(skb)->tcp_flags = TCPHDR_SYN | TCPHDR_ACK;
 	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
@@ -3603,10 +3673,16 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	if (md5)
 		tcp_rsk(req)->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, req_to_sk(req), skb);
 	rcu_read_unlock();
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* If signature fails we do nothing */
+	if (opts.authopt_key)
+		tcp_authopt_hash(opts.hash_location, opts.authopt_key, req_to_sk(req), skb);
+	rcu_read_unlock();
+#endif
 
 	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
 				synack_type, &opts);
 
 	skb->skb_mstamp_ns = now;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0ce52d46e4f8..724145ddf122 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -40,10 +40,11 @@
 #include <linux/icmpv6.h>
 #include <linux/random.h>
 #include <linux/indirect_call_wrapper.h>
 
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/ndisc.h>
 #include <net/inet6_hashtables.h>
 #include <net/inet6_connection_sock.h>
 #include <net/ipv6.h>
 #include <net/transp_v6.h>
@@ -1614,10 +1615,26 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 	TCP_SKB_CB(skb)->sacked = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
 			skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
 }
 
+static int tcp_v6_auth_inbound_check(
+		struct sock *sk,
+		struct sk_buff *skb,
+		int dif, int sdif)
+{
+	int aoret;
+
+	aoret = tcp_authopt_inbound_check(sk, skb);
+	if (aoret < 0)
+		return aoret;
+	if (aoret > 0)
+		return 0;
+
+	return tcp_v6_inbound_md5_hash(sk, skb, dif, sdif);
+}
+
 INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 {
 	struct sk_buff *skb_to_free;
 	int sdif = inet6_sdif(skb);
 	int dif = inet6_iif(skb);
@@ -1667,11 +1684,11 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct request_sock *req = inet_reqsk(sk);
 		bool req_stolen = false;
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif)) {
+		if (tcp_v6_auth_inbound_check(sk, skb, dif, sdif)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
 		}
 		if (tcp_checksum_complete(skb)) {
@@ -1730,11 +1747,11 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	}
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif))
+	if (tcp_v6_auth_inbound_check(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
-- 
2.25.1

