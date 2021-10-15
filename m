Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B794442EA10
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhJOH3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbhJOH3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:29:00 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C276BC061570;
        Fri, 15 Oct 2021 00:26:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z20so34568707edc.13;
        Fri, 15 Oct 2021 00:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3b1OMdSUKflX4oZao36kMMzRJWDmrPvgJ1eHyV20vsA=;
        b=gfmyn8G5Mjp8DrSTFuswPKUVCuhWwTc/FtmzJpE9ymkgTWWcPazUeBfIjFRbg2itnm
         TKkyODGWNjIMn8eu0PbbouCqnMQKMqP3Iv8iqd+IYOcGiausgk348gZmgOt8vMxdthlP
         56TRGzZOc2a0Cb0EMp2Vitt3cvqNg3tX8t64buRYDX+qT4N7EPK0NT7MaEg3dILnTMW2
         atO6I05N8opedZr3NPbTiM74+DJtpTjs4Yy4EtfEbdPfjWIHldqmmYnPsXruw0Wt14vZ
         ctVthN4e7oCyyEnXyg+NHAdWB1zLBlYMRW/bwk9f3ZfgGBC4mmwEBSw0Myc6pOctBeZB
         IWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3b1OMdSUKflX4oZao36kMMzRJWDmrPvgJ1eHyV20vsA=;
        b=W/LolORTrIU1L1Oz0RPk2L1ZLphdNgdcGBheWBgGImBx5R24VdbK8PPTK4YqxNh4Md
         hc3B0GhWsJ6u4PNLnjGd6hI5Zlcxz/BnTyaE5LWg3VsQzH7uCOU3+IhmUZhj4iV8ri0Q
         FPTL0LGbXez74YgfDD5vUMijvPOfuXrOGKxsRE9PoxjpciPshfDar5zmSr7EkHP3P4OQ
         4M6CTrTV4WfhyvbFvrJyZ7rKQkt/89CZmjuSS8GfzPswVvOmCMPM9RzS/BSYC5H8GOfW
         veI9CVpUp0dz0yTh1Lape8gdlJC64bg2gXj2LvXj1t7U3R4dTRzSDXyiSrDAbOdsYToH
         UAJQ==
X-Gm-Message-State: AOAM5300mlk25V5VfvcjjrucLlAA+hvDE1BmACiMM/KrcO2PhYP82vqn
        Rlc28XRSNzL62s27TLNZiDE=
X-Google-Smtp-Source: ABdhPJx+DOqZ/iphPFdt/Y6z5ZlD01YP/CAEjcD29po5JpeWX4oHFenVljwH6k+PALpsD5F/j7aYOg==
X-Received: by 2002:a17:906:884:: with SMTP id n4mr4571539eje.54.1634282813351;
        Fri, 15 Oct 2021 00:26:53 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:bac1:743:3859:80df])
        by smtp.gmail.com with ESMTPSA id l25sm3873107edc.31.2021.10.15.00.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 00:26:52 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] tcp: md5: Allow MD5SIG_FLAG_IFINDEX with ifindex=0
Date:   Fri, 15 Oct 2021 10:26:05 +0300
Message-Id: <ccc83d4ddaca59bed328b0e5b57274a8182e7b43.1634282515.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634282515.git.cdleonard@gmail.com>
References: <cover.1634282515.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple VRFs are generally meant to be "separate" but right now md5
keys for the default VRF also affect connections inside VRFs if the IP
addresses happen to overlap.

So far the combination of TCP_MD5SIG_FLAG_IFINDEX with tcpm_ifindex == 0
was an error, accept this to mean "key only applies to default VRF".
This is what applications using VRFs for traffic separation want.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/net/tcp.h   |  5 +++--
 net/ipv4/tcp_ipv4.c | 26 ++++++++++++++++----------
 net/ipv6/tcp_ipv6.c | 15 +++++++++------
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4c2898ac6569..10f3a37eceb2 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1588,10 +1588,11 @@ union tcp_md5_addr {
 struct tcp_md5sig_key {
 	struct hlist_node	node;
 	u8			keylen;
 	u8			family; /* AF_INET or AF_INET6 */
 	u8			prefixlen;
+	u8			flags;
 	union tcp_md5_addr	addr;
 	int			l3index; /* set if key added with L3 scope */
 	u8			key[TCP_MD5SIG_MAXKEYLEN];
 	struct rcu_head		rcu;
 };
@@ -1633,14 +1634,14 @@ struct tcp_md5sig_pool {
 
 /* - functions */
 int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
-		   int family, u8 prefixlen, int l3index,
+		   int family, u8 prefixlen, int l3index, u8 flags,
 		   const u8 *newkey, u8 newkeylen, gfp_t gfp);
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr,
-		   int family, u8 prefixlen, int l3index);
+		   int family, u8 prefixlen, int l3index, u8 flags);
 struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 					 const struct sock *addr_sk);
 
 #ifdef CONFIG_TCP_MD5SIG
 #include <linux/jump_label.h>
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a9a6a6d598c6..5e6d8cb82ce5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1071,11 +1071,11 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 
 	hlist_for_each_entry_rcu(key, &md5sig->head, node,
 				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
-		if (key->l3index && key->l3index != l3index)
+		if (key->flags & TCP_MD5SIG_FLAG_IFINDEX && key->l3index != l3index)
 			continue;
 		if (family == AF_INET) {
 			mask = inet_make_mask(key->prefixlen);
 			match = (key->addr.a4.s_addr & mask) ==
 				(addr->a4.s_addr & mask);
@@ -1096,11 +1096,11 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 EXPORT_SYMBOL(__tcp_md5_do_lookup);
 
 static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
 						      const union tcp_md5_addr *addr,
 						      int family, u8 prefixlen,
-						      int l3index)
+						      int l3index, u8 flags)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
 	unsigned int size = sizeof(struct in_addr);
 	const struct tcp_md5sig_info *md5sig;
@@ -1116,10 +1116,12 @@ static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
 #endif
 	hlist_for_each_entry_rcu(key, &md5sig->head, node,
 				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
+		if ((key->flags & TCP_MD5SIG_FLAG_IFINDEX) != (flags & TCP_MD5SIG_FLAG_IFINDEX))
+			continue;
 		if (key->l3index != l3index)
 			continue;
 		if (!memcmp(&key->addr, addr, size) &&
 		    key->prefixlen == prefixlen)
 			return key;
@@ -1140,19 +1142,19 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 }
 EXPORT_SYMBOL(tcp_v4_md5_lookup);
 
 /* This can be called on a newly created socket, from other files */
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
-		   int family, u8 prefixlen, int l3index,
+		   int family, u8 prefixlen, int l3index, u8 flags,
 		   const u8 *newkey, u8 newkeylen, gfp_t gfp)
 {
 	/* Add Key to the list */
 	struct tcp_md5sig_key *key;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_info *md5sig;
 
-	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
+	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index, flags);
 	if (key) {
 		/* Pre-existing entry - just update that one.
 		 * Note that the key might be used concurrently.
 		 * data_race() is telling kcsan that we do not care of
 		 * key mismatches, since changing MD5 key on live flows
@@ -1193,24 +1195,25 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	memcpy(key->key, newkey, newkeylen);
 	key->keylen = newkeylen;
 	key->family = family;
 	key->prefixlen = prefixlen;
 	key->l3index = l3index;
+	key->flags = flags;
 	memcpy(&key->addr, addr,
 	       (family == AF_INET6) ? sizeof(struct in6_addr) :
 				      sizeof(struct in_addr));
 	hlist_add_head_rcu(&key->node, &md5sig->head);
 	return 0;
 }
 EXPORT_SYMBOL(tcp_md5_do_add);
 
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family,
-		   u8 prefixlen, int l3index)
+		   u8 prefixlen, int l3index, u8 flags)
 {
 	struct tcp_md5sig_key *key;
 
-	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
+	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index, flags);
 	if (!key)
 		return -ENOENT;
 	hlist_del_rcu(&key->node);
 	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
 	kfree_rcu(key, rcu);
@@ -1240,28 +1243,31 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	struct tcp_md5sig cmd;
 	struct sockaddr_in *sin = (struct sockaddr_in *)&cmd.tcpm_addr;
 	const union tcp_md5_addr *addr;
 	u8 prefixlen = 32;
 	int l3index = 0;
+	u8 flags;
 
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
 
 	if (copy_from_sockptr(&cmd, optval, sizeof(cmd)))
 		return -EFAULT;
 
 	if (sin->sin_family != AF_INET)
 		return -EINVAL;
 
+	flags = cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX;
+
 	if (optname == TCP_MD5SIG_EXT &&
 	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_PREFIX) {
 		prefixlen = cmd.tcpm_prefixlen;
 		if (prefixlen > 32)
 			return -EINVAL;
 	}
 
-	if (optname == TCP_MD5SIG_EXT &&
+	if (optname == TCP_MD5SIG_EXT && cmd.tcpm_ifindex &&
 	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX) {
 		struct net_device *dev;
 
 		rcu_read_lock();
 		dev = dev_get_by_index_rcu(sock_net(sk), cmd.tcpm_ifindex);
@@ -1278,16 +1284,16 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	}
 
 	addr = (union tcp_md5_addr *)&sin->sin_addr.s_addr;
 
 	if (!cmd.tcpm_keylen)
-		return tcp_md5_do_del(sk, addr, AF_INET, prefixlen, l3index);
+		return tcp_md5_do_del(sk, addr, AF_INET, prefixlen, l3index, flags);
 
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index,
+	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
 }
 
 static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
 				   __be32 daddr, __be32 saddr,
@@ -1607,11 +1613,11 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		 * We're using one, so create a matching key
 		 * on the newsk structure. If we fail to get
 		 * memory, then we end up not copying the key
 		 * across. Shucks.
 		 */
-		tcp_md5_do_add(newsk, addr, AF_INET, 32, l3index,
+		tcp_md5_do_add(newsk, addr, AF_INET, 32, l3index, key->flags,
 			       key->key, key->keylen, GFP_ATOMIC);
 		sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
 	}
 #endif
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8cf5ff2e9504..1ef27cd7dbff 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -597,31 +597,34 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 {
 	struct tcp_md5sig cmd;
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.tcpm_addr;
 	int l3index = 0;
 	u8 prefixlen;
+	u8 flags;
 
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
 
 	if (copy_from_sockptr(&cmd, optval, sizeof(cmd)))
 		return -EFAULT;
 
 	if (sin6->sin6_family != AF_INET6)
 		return -EINVAL;
 
+	flags = cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX;
+
 	if (optname == TCP_MD5SIG_EXT &&
 	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_PREFIX) {
 		prefixlen = cmd.tcpm_prefixlen;
 		if (prefixlen > 128 || (ipv6_addr_v4mapped(&sin6->sin6_addr) &&
 					prefixlen > 32))
 			return -EINVAL;
 	} else {
 		prefixlen = ipv6_addr_v4mapped(&sin6->sin6_addr) ? 32 : 128;
 	}
 
-	if (optname == TCP_MD5SIG_EXT &&
+	if (optname == TCP_MD5SIG_EXT && cmd.tcpm_ifindex &&
 	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX) {
 		struct net_device *dev;
 
 		rcu_read_lock();
 		dev = dev_get_by_index_rcu(sock_net(sk), cmd.tcpm_ifindex);
@@ -638,26 +641,26 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 
 	if (!cmd.tcpm_keylen) {
 		if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 			return tcp_md5_do_del(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
 					      AF_INET, prefixlen,
-					      l3index);
+					      l3index, flags);
 		return tcp_md5_do_del(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
-				      AF_INET6, prefixlen, l3index);
+				      AF_INET6, prefixlen, l3index, flags);
 	}
 
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
 	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
-				      AF_INET, prefixlen, l3index,
+				      AF_INET, prefixlen, l3index, flags,
 				      cmd.tcpm_key, cmd.tcpm_keylen,
 				      GFP_KERNEL);
 
 	return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
-			      AF_INET6, prefixlen, l3index,
+			      AF_INET6, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
 }
 
 static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
 				   const struct in6_addr *daddr,
@@ -1402,11 +1405,11 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		 * on the newsk structure. If we fail to get
 		 * memory, then we end up not copying the key
 		 * across. Shucks.
 		 */
 		tcp_md5_do_add(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
-			       AF_INET6, 128, l3index, key->key, key->keylen,
+			       AF_INET6, 128, l3index, key->flags, key->key, key->keylen,
 			       sk_gfp_mask(sk, GFP_ATOMIC));
 	}
 #endif
 
 	if (__inet_inherit_port(sk, newsk) < 0) {
-- 
2.25.1

