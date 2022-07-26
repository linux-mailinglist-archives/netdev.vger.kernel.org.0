Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118A8580B67
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbiGZGT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237846AbiGZGS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:18:26 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9825C1F2DC;
        Mon, 25 Jul 2022 23:16:22 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id z23so24092934eju.8;
        Mon, 25 Jul 2022 23:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wdFII6qQU+Iin/k1IIhKoYA48TRM0jxAhX1ua5DXTCg=;
        b=Vqr7nIRStGrO4sPzXhcl6qm2ImkLeVg3Gq0uz7tQEpNAJXf3PImOMGU0t/3Z2H2WHu
         VyV9a9xtR1XYqWNajqWo2ei4xw6sf6SM9MwXVFGwDfsaPum7adoIjFmjohKBxBgEIueU
         qfvZvFFO6j+w1y3hYFCzigcAhKdFyBlxbYbAo90Tv4KUwAnY2OPpxpQYQGJ8A4lyL9wa
         IlP4d0SDtTQEoMu2MerhPGIO9l6TbLuJndTrsIOSekAs1qA1w7zwmC0gMkf+J81Xq5Jy
         6z1jgt+iqYXd1oLPzI3bqnvihMb4roD9JWLXq+q/2pXDWZg9w0X6E6mT7vEdVYXDaCdU
         pgag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wdFII6qQU+Iin/k1IIhKoYA48TRM0jxAhX1ua5DXTCg=;
        b=Gb11JjJ5fET/Hhx2bpazpXj0OIRZ5RAqEXKypzUL6+N+L7z+0WFTVrlEeRPGvD3rFE
         C+pyLELKvhtaiZW1KYDwk27+KPDbJfcoSAyHG93W85/49RJwg7kAH7HN8f7swdVF3pOu
         byBLIl1OxJAdd2P8LLvN/gODDxocPQWI47hgJHLkwgVi9T+OghgPq8ZsTrDHY/CIySAd
         DCLPMgiiI8/vFUoOXscS1E2Q0ldNzQPo/I5+5zZC7DrW/1lKU7I5tJDExdnhfCgEKWxc
         OJJECmzQZ12zprgx4YI7Kt3BM3cMPGsswujLc8yvAMkuW+wbgGur9npunJsgsEkEsaKS
         DAWw==
X-Gm-Message-State: AJIora8pS6jWpnoBPHIJvYvybjXJtlIkg5d4KqnuXVjujUe0baJG3+n1
        IrEayKo1l2FhrJZlzsbyzFs=
X-Google-Smtp-Source: AGRyM1veDO4vn8qMtJQNY8TzAamTM5znuWySD2rqzTqi0T1F5phAcOvCS+VoBakx5DvN5zCmvMP7HA==
X-Received: by 2002:a17:906:846d:b0:72f:3901:de1c with SMTP id hx13-20020a170906846d00b0072f3901de1cmr12670979ejc.199.1658816181765;
        Mon, 25 Jul 2022 23:16:21 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:21 -0700 (PDT)
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
Subject: [PATCH v6 23/26] tcp: authopt: tcp_authopt_lookup_send: Add anykey output param
Date:   Tue, 26 Jul 2022 09:15:25 +0300
Message-Id: <41bf8fc3faad75a520cd786af14f6924625dcc3e.1658815925.git.cdleonard@gmail.com>
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

The anykey param can be used to distinguish between "no keys configured"
and "no keys valid". The former case should result in unsigned traffic
while the latter should result in an error.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 3596fc1fb770..1fd665c43b5d 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -378,38 +378,42 @@ static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authop
  * tcp_authopt_lookup_send - lookup key for sending
  *
  * @net: Per-namespace information containing keys
  * @addr_sk: Socket used for destination address lookup
  * @send_id: Optional send_id. If >= 0 then only return keys that match
+ * @anykey: Set to true if any keys are present for the peer
  *
  * If anykey is false then authentication is not required for peer.
  *
  * If anykey is true but no key was found then all our keys must be expired and sending should fail.
  */
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_authopt *net,
 							    const struct sock *addr_sk,
-							    int send_id)
+							    int send_id,
+							    bool *anykey)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
 	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
-		if (send_id >= 0 && key->send_id != send_id)
-			continue;
-		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
-			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
 		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
 			if (l3index < 0)
 				l3index = l3mdev_master_ifindex_by_index(sock_net(addr_sk),
 									 addr_sk->sk_bound_dev_if);
 			if (l3index != key->l3index)
 				continue;
 		}
+		if (anykey)
+			*anykey = true;
+		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
+			continue;
+		if (send_id >= 0 && key->send_id != send_id)
+			continue;
 		if (better_key_match(result, key))
 			result = key;
 		else if (result)
 			net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
 	}
@@ -454,14 +458,14 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 		 */
 		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
 			send_id = info->send_keyid;
 		else
 			send_id = rsk->recv_rnextkeyid;
-		key = tcp_authopt_lookup_send(net, addr_sk, send_id);
+		key = tcp_authopt_lookup_send(net, addr_sk, send_id, NULL);
 		/* If no key found with specific send_id try anything else. */
 		if (!key)
-			key = tcp_authopt_lookup_send(net, addr_sk, -1);
+			key = tcp_authopt_lookup_send(net, addr_sk, -1, NULL);
 		if (key)
 			*rnextkeyid = key->recv_id;
 		return key;
 	}
 
@@ -482,18 +486,22 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 	 */
 	if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID) {
 		int send_keyid = info->send_keyid;
 
 		if (!key || key->send_id != send_keyid)
-			new_key = tcp_authopt_lookup_send(net, addr_sk, send_keyid);
+			new_key = tcp_authopt_lookup_send(net, addr_sk,
+							  send_keyid,
+							  NULL);
 	} else {
 		if (!key || key->send_id != info->recv_rnextkeyid)
-			new_key = tcp_authopt_lookup_send(net, addr_sk, info->recv_rnextkeyid);
+			new_key = tcp_authopt_lookup_send(net, addr_sk,
+							  info->recv_rnextkeyid,
+							  NULL);
 	}
 	/* If no key found with specific send_id try anything else. */
 	if (!key && !new_key)
-		new_key = tcp_authopt_lookup_send(net, addr_sk, -1);
+		new_key = tcp_authopt_lookup_send(net, addr_sk, -1, NULL);
 
 	/* Update current key only if we hold the socket lock. */
 	if (new_key && key != new_key) {
 		if (locked) {
 			if (kref_get_unless_zero(&new_key->ref)) {
-- 
2.25.1

