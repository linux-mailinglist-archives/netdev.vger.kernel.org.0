Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2147F580B5B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbiGZGTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbiGZGSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:18:24 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A648729CA9;
        Mon, 25 Jul 2022 23:16:13 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id f15so8053367edc.4;
        Mon, 25 Jul 2022 23:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Sejg5rnWoSqZYemGq6X63dpAg2Pf65H/zCZxfRF6IU=;
        b=iNZKC/oo9q2b4grKVBJx+BnDqQCNRqtb7SyymoVTjqJLx4ZrdL3baCUEX8k5ZftfA3
         DJUDbXeSE4cR2iHSDPRZsoSXCpzrX8pUBtyKdAoq3s92byvpxRShX3vnZutHFM8fnxrd
         6z7bWfuBLeSHLSkxGFFsduwcTp8UvT0puOB/v0wlm6VJXzY8GSCL+CQpF1NvdAU2wJ0x
         JAWr9/22tKDX/ileyJAkoJBJomuAYMZm8OkW7vPpV9usDExPK2aOWk1VYeQ/rvSW7/GN
         ziJD9Z+KBhVMTUyYOSuNkNywui7Pt3kfX7RMQZsRWDAx3DN3iX8IWU0AIH7ReCZLP5f4
         83UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Sejg5rnWoSqZYemGq6X63dpAg2Pf65H/zCZxfRF6IU=;
        b=QUWJMnMDObFxlOG49F7V/GZV/xY+wDvQ7PAj+WFXlq24ZUyEHpNQ6eXLzh2ctUSKVD
         jPZ1XEPPlzMJLyct2luVJ5uo59MikypqcizXFB5pVjHJgMp5Khjy383YFarSH3eJEEuK
         2ni9JNep4VvlYQE9cVPjvGQAf6LAeM6tIIppJF9sWD4WzcWobKmIP+pKqVfaGzAxhsAj
         RFxEAuFqs3OsvCxSmXeXSZ8RBpJdBo7WkCOWLrLmtnXsln0Dad6++CQzEPVN1ah0kA6D
         KG8RpJ1CvF0Wc0COt55t/8/GwofzDNJYzh2QIdKTp9wb63LxxKYGWkfKWWrtZMzHOrha
         /iWw==
X-Gm-Message-State: AJIora9kxdSo4oNfaSRNBDKrSR1qmfB4KKLcvTyrjVkl66GVp6E0FuHh
        VUtZex3MgJo3Ckk/jRChPpY=
X-Google-Smtp-Source: AGRyM1s0zbiMLrwf5pPgyPywgKtZBSeJCih+CeZ9M4NmfR7IAkd0Ugy+9w0OMbMqewD+AbhZyKp4KA==
X-Received: by 2002:a05:6402:448c:b0:435:9dcc:b8a5 with SMTP id er12-20020a056402448c00b004359dccb8a5mr16622284edb.287.1658816170655;
        Mon, 25 Jul 2022 23:16:10 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:10 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 17/26] tcp: authopt: Add prefixlen support
Date:   Tue, 26 Jul 2022 09:15:19 +0300
Message-Id: <0c36afeb53381961a222166d15b85cb75deab268.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows making a key apply to an addr/prefix instead of just the
full addr. This is enabled through a custom flag, default behavior is
still full address match.

This is equivalent to TCP_MD5SIG_FLAG_PREFIX from TCP_MD5SIG and has
the same use-cases.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst |  1 +
 include/net/tcp_authopt.h                |  2 +
 include/uapi/linux/tcp.h                 | 10 ++++
 net/ipv4/tcp_authopt.c                   | 63 ++++++++++++++++++++++--
 4 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
index f681d2221ce3..6520c6d02755 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -38,10 +38,11 @@ new flags.
 
  * Address binding is optional, by default keys match all addresses
  * Local address is ignored, matching is done by remote address
  * Ports are ignored
  * It is possible to match a specific VRF by l3index (default is to ignore)
+ * It is possible to match with a fixed prefixlen (default is full address)
 
 RFC5925 requires that key ids do not overlap when tcp identifiers (addr/port)
 overlap. This is not enforced by linux, configuring ambiguous keys will result
 in packet drops and lost connections.
 
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 1630fc2aa082..4f83d8e54fef 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -47,10 +47,12 @@ struct tcp_authopt_key_info {
 	u8 keylen;
 	/** @key: Same as &tcp_authopt_key.key */
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
 	/** @l3index: Same as &tcp_authopt_key.ifindex */
 	int l3index;
+	/** @prefixlen: Length of addr match (default full) */
+	int prefixlen;
 	/** @addr: Same as &tcp_authopt_key.addr */
 	struct sockaddr_storage addr;
 	/** @alg: Algorithm implementation matching alg_id */
 	struct tcp_authopt_alg_imp *alg;
 };
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index ed27feb93b0e..b1063e1e1b9f 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -403,18 +403,21 @@ struct tcp_authopt {
  * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
  * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
  * @TCP_AUTHOPT_KEY_NOSEND: Key invalid for send (expired)
  * @TCP_AUTHOPT_KEY_NORECV: Key invalid for recv (expired)
+ * @TCP_AUTHOPT_KEY_PREFIXLEN: Valid value in `tcp_authopt.prefixlen`, otherwise
+ * match full address length
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
 	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
 	TCP_AUTHOPT_KEY_NOSEND = (1 << 4),
 	TCP_AUTHOPT_KEY_NORECV = (1 << 5),
+	TCP_AUTHOPT_KEY_PREFIXLEN = (1 << 6),
 };
 
 /**
  * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
  */
@@ -465,10 +468,17 @@ struct tcp_authopt_key {
 	 * connections through this interface. Interface must be an vrf master.
 	 *
 	 * This is similar to `tcp_msg5sig.tcpm_ifindex`
 	 */
 	int	ifindex;
+	/**
+	 * @prefixlen: length of prefix to match
+	 *
+	 * Without the TCP_AUTHOPT_KEY_PREFIXLEN flag this is ignored and a full
+	 * address match is performed.
+	 */
+	int	prefixlen;
 };
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 0ead961fcfe0..e4aecd35ffda 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -4,10 +4,11 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
+#include <linux/inetdevice.h>
 
 /* This is mainly intended to protect against local privilege escalations through
  * a rarely used feature so it is deliberately not namespaced.
  */
 int sysctl_tcp_authopt;
@@ -269,10 +270,14 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
 		return false;
 	if ((info->flags & TCP_AUTHOPT_KEY_IFINDEX) != (key->flags & TCP_AUTHOPT_KEY_IFINDEX))
 		return false;
 	if ((info->flags & TCP_AUTHOPT_KEY_IFINDEX) && info->l3index != key->ifindex)
 		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_PREFIXLEN) != (key->flags & TCP_AUTHOPT_KEY_PREFIXLEN))
+		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_PREFIXLEN) && info->prefixlen != key->prefixlen)
+		return false;
 	if ((info->flags & TCP_AUTHOPT_KEY_ADDR_BIND) != (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND))
 		return false;
 	if (info->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 		if (!ipvx_addr_match(&info->addr, &key->addr))
 			return false;
@@ -286,17 +291,20 @@ static bool tcp_authopt_key_match_skb_addr(struct tcp_authopt_key_info *key,
 	u16 keyaf = key->addr.ss_family;
 	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
 
 	if (keyaf == AF_INET && iph->version == 4) {
 		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+		__be32 mask = inet_make_mask(key->prefixlen);
 
-		return iph->saddr == key_addr->sin_addr.s_addr;
+		return (iph->saddr & mask) == key_addr->sin_addr.s_addr;
 	} else if (keyaf == AF_INET6 && iph->version == 6) {
 		struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
 		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
 
-		return ipv6_addr_equal(&ip6h->saddr, &key_addr->sin6_addr);
+		return ipv6_prefix_equal(&ip6h->saddr,
+					 &key_addr->sin6_addr,
+					 key->prefixlen);
 	}
 
 	/* This actually happens with ipv6-mapped-ipv4-addresses
 	 * IPv6 listen sockets will be asked to validate ipv4 packets.
 	 */
@@ -312,17 +320,20 @@ static bool tcp_authopt_key_match_sk_addr(struct tcp_authopt_key_info *key,
 	if (keyaf != addr_sk->sk_family)
 		return false;
 
 	if (keyaf == AF_INET) {
 		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+		__be32 mask = inet_make_mask(key->prefixlen);
 
-		return addr_sk->sk_daddr == key_addr->sin_addr.s_addr;
+		return (addr_sk->sk_daddr & mask) == key_addr->sin_addr.s_addr;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (keyaf == AF_INET6) {
 		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
 
-		return ipv6_addr_equal(&addr_sk->sk_v6_daddr, &key_addr->sin6_addr);
+		return ipv6_prefix_equal(&addr_sk->sk_v6_daddr,
+					 &key_addr->sin6_addr,
+					 key->prefixlen);
 #endif
 	}
 
 	return false;
 }
@@ -348,10 +359,16 @@ static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authop
 	/* l3index always overrides non-l3index */
 	if (old->l3index && new->l3index == 0)
 		return false;
 	if (old->l3index == 0 && new->l3index)
 		return true;
+	/* Full address match overrides match by prefixlen */
+	if (!(new->flags & TCP_AUTHOPT_KEY_PREFIXLEN) && (old->flags & TCP_AUTHOPT_KEY_PREFIXLEN))
+		return false;
+	/* Longer prefixes are better matches */
+	if (new->prefixlen > old->prefixlen)
+		return true;
 
 	return false;
 }
 
 /**
@@ -626,21 +643,32 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
 	TCP_AUTHOPT_KEY_ADDR_BIND | \
 	TCP_AUTHOPT_KEY_IFINDEX | \
+	TCP_AUTHOPT_KEY_PREFIXLEN | \
 	TCP_AUTHOPT_KEY_NOSEND | \
 	TCP_AUTHOPT_KEY_NORECV)
 
+static bool ipv6_addr_is_prefix(struct in6_addr *addr, int plen)
+{
+	struct in6_addr copy;
+
+	ipv6_addr_prefix_copy(&copy, addr, plen);
+
+	return !!memcmp(&copy, addr, sizeof(*addr));
+}
+
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 	struct tcp_authopt_alg_imp *alg;
 	int l3index = 0;
+	int prefixlen;
 	int err;
 
 	sock_owned_by_me(sk);
 	err = check_sysctl_tcp_authopt();
 	if (err)
@@ -676,10 +704,36 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
 		if (sk->sk_family != opt.addr.ss_family)
 			return -EINVAL;
 	}
 
+	/* check prefixlen */
+	if (opt.flags & TCP_AUTHOPT_KEY_PREFIXLEN) {
+		prefixlen = opt.prefixlen;
+		if (sk->sk_family == AF_INET) {
+			if (prefixlen < 0 || prefixlen > 32)
+				return -EINVAL;
+			if (((struct sockaddr_in *)&opt.addr)->sin_addr.s_addr &
+			    ~inet_make_mask(prefixlen))
+				return -EINVAL;
+		}
+		if (sk->sk_family == AF_INET6) {
+			if (prefixlen < 0 || prefixlen > 128)
+				return -EINVAL;
+			if (!ipv6_addr_is_prefix(&((struct sockaddr_in6 *)&opt.addr)->sin6_addr,
+						 prefixlen))
+				return -EINVAL;
+		}
+	} else {
+		if (sk->sk_family == AF_INET)
+			prefixlen = 32;
+		else if (sk->sk_family == AF_INET6)
+			prefixlen = 128;
+		else
+			return -EINVAL;
+	}
+
 	/* Initialize tcp_authopt_info if not already set */
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
@@ -725,10 +779,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	key_info->l3index = l3index;
+	key_info->prefixlen = prefixlen;
 	hlist_add_head_rcu(&key_info->node, &net->head);
 	mutex_unlock(&net->mutex);
 
 	return 0;
 }
-- 
2.25.1

