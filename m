Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BEB47E5C2
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349316AbhLWPle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349103AbhLWPlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:41:07 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDD4C061792;
        Thu, 23 Dec 2021 07:41:06 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m21so24214737edc.0;
        Thu, 23 Dec 2021 07:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rEhPZkA/AwOo/pza/2HZJSP1cTNQTQZNl+J27uwUZ7g=;
        b=WsIW1hysqf398eRsPZ+fFAL7c2qABZUk5IrbaaLan7cwW15pw18ouzu7uqnBan4axr
         BW6BT2AIvwnHGYoJ2rrjYdOHuYQ6NmHuQLu7iOXzrC6mrLgd8aYBuBW7bPEV682oxa+n
         /BOBR3rORac6KTEGDlROhrO4yWoKWCtJsMif4965W+xm5Rt2DLiYb6NawPs+4p2ALBX1
         ChuIhrhNz4oYsP5EKUJtYVmocoty5mA+f1d/3HefI3acOCBlaRhy10Z+fZnJhHMD+hYL
         gth1QQ/nQCygcDqfoG/kPj45anp0EEj62K4YG9/B6QFIEfa4Y6cPw0mwQkGl1bSXGxSx
         pFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rEhPZkA/AwOo/pza/2HZJSP1cTNQTQZNl+J27uwUZ7g=;
        b=sI7YQ4N6OiEdw5258m8zWQJrWPPDeGE+zWXhFwYs9bmuGA55VyEGzADE2I7/tVx9I1
         WeRnWzsw1b/BnuXuZRl4mBiooYxmeUgqSnfB6ALlpUAC72+WxV7lLmhHWyw7dvAl8423
         ZQZDKQbCxnAH6H1undlODwZSyVYkCd6kb7S62B+CY2cLzghLkNUmQqUIpixgpPODOHee
         V0hchPnDPvqZWuAW6hcayvhgSdowKg5KVetN3SOAnQMdkjUDDURSJVavTRkbpxmJnbiw
         FNgloUlammKjSk5vVOSd92vMl+L07mlrJacD1Z+Fy+qJHXK2hFpEwlqDdZEu6tl7F2Hz
         ZNVA==
X-Gm-Message-State: AOAM532BOs1oP2GfUhI4U1dffD9qQpUViKSr+5sS5TZ1JxYzyqKjBJjI
        OmGzktL/m9IwkZS12B3Z9XA=
X-Google-Smtp-Source: ABdhPJysF1sO2gThsWcUfiaskTEUc/nRXerkqu/ktvs+bqvLrAbTBDZ6aQDpX2yWVuH9b2/FNr7S9g==
X-Received: by 2002:a17:906:4790:: with SMTP id cw16mr2299544ejc.493.1640274065280;
        Thu, 23 Dec 2021 07:41:05 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:41:04 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 15/19] tcp: authopt: Add prefixlen support
Date:   Thu, 23 Dec 2021 17:40:10 +0200
Message-Id: <1d918bde7fdb13a05c899e519e833671cb5fbe5a.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 800fde277239..743248904552 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -47,10 +47,12 @@ struct tcp_authopt_key_info {
 	u8 keylen;
 	/** @key: Same as &tcp_authopt_key.key */
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
 	/** @l3index: Same as &tcp_authopt_key.ifindex */
 	int l3index;
+	/** @prefix: Length of addr match (default full) */
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
index c598f3cf72d5..64bcb2a38472 100644
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
@@ -266,10 +267,14 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
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
@@ -283,17 +288,20 @@ static bool tcp_authopt_key_match_skb_addr(struct tcp_authopt_key_info *key,
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
@@ -309,16 +317,19 @@ static bool tcp_authopt_key_match_sk_addr(struct tcp_authopt_key_info *key,
 	if (keyaf != addr_sk->sk_family)
 		return false;
 
 	if (keyaf == AF_INET) {
 		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+		__be32 mask = inet_make_mask(key->prefixlen);
 
-		return addr_sk->sk_daddr == key_addr->sin_addr.s_addr;
+		return (addr_sk->sk_daddr & mask) == key_addr->sin_addr.s_addr;
 	} else if (keyaf == AF_INET6) {
 		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
 
-		return ipv6_addr_equal(&addr_sk->sk_v6_daddr, &key_addr->sin6_addr);
+		return ipv6_prefix_equal(&addr_sk->sk_v6_daddr,
+					 &key_addr->sin6_addr,
+					 key->prefixlen);
 	}
 
 	return false;
 }
 
@@ -343,10 +354,16 @@ static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authop
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
 
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_authopt *net,
@@ -610,21 +627,32 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
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
@@ -660,10 +688,36 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
 
@@ -709,10 +763,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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

