Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92E497EF0
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241633AbiAXMOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbiAXMOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:14:05 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845DDC06173D;
        Mon, 24 Jan 2022 04:13:46 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jx6so20858206ejb.0;
        Mon, 24 Jan 2022 04:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZQgU6EFgHGf71GuYIqNhPbHJCpg6Q1Wvwo7Uooatlo=;
        b=Q91r2O8Z18GmFv6X0D0d1CTGdZlQGmOHq8Fvmo6kX8TYC+9rN9TZ5EvzUHhqwO1fi0
         LQ7TnLjHWyWw9cWRHMWuh/ozEq17bTPOpPNEnQ8bnDBnUL1ZXBUuWyo//czj8U1GixOA
         SHfHPTXqVF9Ul9YqnIdZ6HF68y0H2kwU88Xhqf302b0YWCJf20QkbyqZyvvFaOjfUXHy
         YIZyF/dfPilXCgyUyEJOyZYXMvN8+/Pl0WyLeDkyP9Z3QhJdR6jGXCLxgeRZ1BU1PGSQ
         nhi4xsbj0cAr5EhIcdh2t6uXE+1yObXLb+UYI5CslfEX1mJWNzRzY2sAuXrKY3CoJy6I
         zLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZQgU6EFgHGf71GuYIqNhPbHJCpg6Q1Wvwo7Uooatlo=;
        b=qo5rksce4Vwe1rKbzNX0J1Y+FdRa59oGUazxSsj/0nGPdB+MIBF8TU+QAIKaRQCgvV
         NwadkYX4AhbVhNO5YsQYOPcHt2gQfsic3w9A3jxfySpxMDR0qB0iKZHtDs53C7jklqUw
         clM6GIqWuzC1d1jD/fOmQlUo9OnvROX868LjGvvq1Y+kgZEtCQdbDOOKCkeP8QurtYql
         Q6yDfCXLF9L5H5gZdTQOmeLBTJkItMpuXVN1eWCMg2VqQfXMzXNPj091NRRvmcCtR9q4
         3fv6cYyAoVrhFmhBWJlJcBp8dEnS/eRU4fUteeWfuUUpEpX33chiEKFUbHxFEcTpY4Ok
         3F0A==
X-Gm-Message-State: AOAM532xYUwCfMw4Hy7FspYcF03NMzmmneXNs/Ysqp4FDtwVGP2sgPzd
        iAv01uAz2PUQ1BpAwYUi5kU=
X-Google-Smtp-Source: ABdhPJx7kTgTpLvqxN7raZAesKTnlGXD7UtoI7pkwSZhCAKnR9L6Y6AKeLd9WTJIkRoi5Wj9fNu5iw==
X-Received: by 2002:a17:906:a091:: with SMTP id q17mr12116698ejy.669.1643026425041;
        Mon, 24 Jan 2022 04:13:45 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:44 -0800 (PST)
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
Subject: [PATCH v5 13/20] tcp: authopt: Add initial l3index support
Date:   Mon, 24 Jan 2022 14:12:59 +0200
Message-Id: <3ccf3359bb5fadf6e76edf3cdc87fc04024fc827.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a parallel feature to tcp_md5sig.tcpm_ifindex support and allows
applications to server multiple VRFs with a single socket.

The ifindex argument must be the ifindex of a VRF device and must match
exactly, keys with ifindex == 0 (outside of VRF) will not match for
connections inside a VRF.

Keys without the TCP_AUTHOPT_KEY_IFINDEX will ignore ifindex and match
both inside and outside VRF.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst |  1 +
 include/net/tcp_authopt.h                |  2 +
 include/uapi/linux/tcp.h                 | 11 ++++
 net/ipv4/tcp_authopt.c                   | 71 ++++++++++++++++++++++--
 4 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
index f29fdea7769f..f681d2221ce3 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -37,10 +37,11 @@ expand over time by increasing the size of `struct tcp_authopt_key` and adding
 new flags.
 
  * Address binding is optional, by default keys match all addresses
  * Local address is ignored, matching is done by remote address
  * Ports are ignored
+ * It is possible to match a specific VRF by l3index (default is to ignore)
 
 RFC5925 requires that key ids do not overlap when tcp identifiers (addr/port)
 overlap. This is not enforced by linux, configuring ambiguous keys will result
 in packet drops and lost connections.
 
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 3d03fbb186ef..800fde277239 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -45,10 +45,12 @@ struct tcp_authopt_key_info {
 	u8 alg_id;
 	/** @keylen: Same as &tcp_authopt_key.keylen */
 	u8 keylen;
 	/** @key: Same as &tcp_authopt_key.key */
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
+	/** @l3index: Same as &tcp_authopt_key.ifindex */
+	int l3index;
 	/** @addr: Same as &tcp_authopt_key.addr */
 	struct sockaddr_storage addr;
 	/** @alg: Algorithm implementation matching alg_id */
 	struct tcp_authopt_alg_imp *alg;
 };
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index e02176390519..a7f5f918ed5a 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -400,15 +400,17 @@ struct tcp_authopt {
  * enum tcp_authopt_key_flag - flags for `tcp_authopt.flags`
  *
  * @TCP_AUTHOPT_KEY_DEL: Delete the key and ignore non-id fields
  * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
+ * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
+	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
 };
 
 /**
  * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
  */
@@ -450,10 +452,19 @@ struct tcp_authopt_key {
 	 * @addr: Key is only valid for this address
 	 *
 	 * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
 	 */
 	struct __kernel_sockaddr_storage addr;
+	/**
+	 * @ifindex: ifindex of vrf (l3mdev_master) interface
+	 *
+	 * If the TCP_AUTHOPT_KEY_IFINDEX flag is set then key only applies for
+	 * connections through this interface. Interface must be an vrf master.
+	 *
+	 * This is similar to `tcp_msg5sig.tcpm_ifindex`
+	 */
+	int	ifindex;
 };
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index c00b23f1e5af..3d2c4283923f 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 #include <net/tcp_authopt.h>
+#include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
 
@@ -264,10 +265,14 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
 {
 	if (info->send_id != key->send_id)
 		return false;
 	if (info->recv_id != key->recv_id)
 		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_IFINDEX) != (key->flags & TCP_AUTHOPT_KEY_IFINDEX))
+		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_IFINDEX) && info->l3index != key->ifindex)
+		return false;
 	if ((info->flags & TCP_AUTHOPT_KEY_ADDR_BIND) != (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND))
 		return false;
 	if (info->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 		if (!ipvx_addr_match(&info->addr, &key->addr))
 			return false;
@@ -333,26 +338,49 @@ static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct so
 			return key_info;
 
 	return NULL;
 }
 
+static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authopt_key_info *new)
+{
+	if (!old)
+		return true;
+
+	/* l3index always overrides non-l3index */
+	if (old->l3index && new->l3index == 0)
+		return false;
+	if (old->l3index == 0 && new->l3index)
+		return true;
+
+	return false;
+}
+
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_authopt *net,
 							    const struct sock *addr_sk,
 							    int send_id)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
+	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (send_id >= 0 && key->send_id != send_id)
 			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
-		if (result && net_ratelimit())
-			pr_warn("ambiguous tcp authentication keys configured for send\n");
-		result = key;
+		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
+			if (l3index < 0)
+				l3index = l3mdev_master_ifindex_by_index(sock_net(addr_sk),
+									 addr_sk->sk_bound_dev_if);
+			if (l3index != key->l3index)
+				continue;
+		}
+		if (better_key_match(result, key))
+			result = key;
+		else if (result)
+			net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
 	}
 
 	return result;
 }
 
@@ -583,19 +611,21 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 }
 
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
-	TCP_AUTHOPT_KEY_ADDR_BIND)
+	TCP_AUTHOPT_KEY_ADDR_BIND | \
+	TCP_AUTHOPT_KEY_IFINDEX)
 
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 	struct tcp_authopt_alg_imp *alg;
+	int l3index = 0;
 	int err;
 
 	sock_owned_by_me(sk);
 	err = check_sysctl_tcp_authopt();
 	if (err)
@@ -646,10 +676,24 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 		return -EINVAL;
 	err = tcp_authopt_alg_require(alg);
 	if (err)
 		return err;
 
+	/* check ifindex is valid (zero is always valid) */
+	if (opt.flags & TCP_AUTHOPT_KEY_IFINDEX && opt.ifindex) {
+		struct net_device *dev;
+
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), opt.ifindex);
+		if (dev && netif_is_l3_master(dev))
+			l3index = dev->ifindex;
+		rcu_read_unlock();
+
+		if (!l3index)
+			return -EINVAL;
+	}
+
 	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
 	if (!key_info)
 		return -ENOMEM;
 	mutex_lock(&net->mutex);
 	kref_init(&key_info->ref);
@@ -665,10 +709,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	key_info->alg_id = opt.alg;
 	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
+	key_info->l3index = l3index;
 	hlist_add_head_rcu(&key_info->node, &net->head);
 	mutex_unlock(&net->mutex);
 
 	return 0;
 }
@@ -1455,21 +1500,37 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    int recv_id,
 							    bool *anykey)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
+	int l3index = -1;
 
 	*anykey = false;
 	/* multiple matches will cause occasional failures */
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND &&
 		    !tcp_authopt_key_match_skb_addr(key, skb))
 			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
+			if (l3index < 0) {
+				if (skb->protocol == htons(ETH_P_IP)) {
+					l3index = inet_sdif(skb) ? inet_iif(skb) : 0;
+				} else if (skb->protocol == htons(ETH_P_IPV6)) {
+					l3index = inet6_sdif(skb) ? inet6_iif(skb) : 0;
+				} else {
+					WARN_ONCE(1, "unexpected skb->protocol=%x", skb->protocol);
+					continue;
+				}
+			}
+
+			if (l3index != key->l3index)
+				continue;
+		}
 		*anykey = true;
 		if (recv_id >= 0 && key->recv_id != recv_id)
 			continue;
-		if (!result)
+		if (better_key_match(result, key))
 			result = key;
 		else if (result)
 			net_warn_ratelimited("ambiguous tcp authentication keys configured for recv\n");
 	}
 
-- 
2.25.1

