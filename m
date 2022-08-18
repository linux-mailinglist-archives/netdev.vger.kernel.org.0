Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1017598D12
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345756AbiHRUB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345660AbiHRUAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:47 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B24D11D8;
        Thu, 18 Aug 2022 13:00:45 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id o22so3188000edc.10;
        Thu, 18 Aug 2022 13:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=e7myX/ND+nnIiOt3LqG3ckuwVwkBkqrIptHUR/Mrndk=;
        b=WVavmcDqa5JmqnC6gdXmqv8HI/orgoJQWcID3pt1S9bFMe2NAcu8/Gox8Sy7S/LUvO
         9JnSJpQAPk0YsK7O0AIOIjT3Z2fmkMkrE3IwULiJHyqX/ZsR1TEq0DoqlTqq45qxRdmW
         /gYaT/JTB6cPJEWvr14W2M4v2vQ1jcK5ApxgppvIJOFdzROr0Zr4dTPzlrhPIzYkg17b
         852Gqlkf52v0t88nEX2bey3u7JryN/18Ngr3UHgb62ucRYVMp5YvrO4vAYZF9R5DMoFD
         yEC5QWRppPgyylVtdjtooKj10W7QRg6hNyopbnncZoXATdpqwgnTTVkLU8f8G0Ep9Mb0
         omZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=e7myX/ND+nnIiOt3LqG3ckuwVwkBkqrIptHUR/Mrndk=;
        b=GIuw3eU7kWp9GhuzaMYJj28E5wWAnbao63IuH00L0h6nQTJxR40qkmlfpaK1BlsdQe
         MN1r0oYVQZQOHpHynpYiElTeq5L7ZboN8hH8USUkT0YPTsg756vHve8IiGe2PReV3kUS
         d27ElrCI8ZWVgjClZ8ql7WBtVNcd1IfvIVpQ57ugHsik1wiy5tVFlABKMFuIyO03Oa8F
         eiv6qT4/59exAHhnOmDDRtxHdxqTxApnX+bP/L65pkH30rODuDmDS2uLnYRNrEDsSxWt
         CSHehR+cuimPgdKZX6CrKILRQiEOfcHdZ89xFQYXrw6kkRGbblap5PB2p2p+5QqEfFCn
         t6vw==
X-Gm-Message-State: ACgBeo3L4oNMVbkjE8LUVJyFypcAkekb5xeUD1W5Qh9WMqyRN7zKvzTI
        it9MRmuLxCJJZnBITBO4ebs=
X-Google-Smtp-Source: AA6agR5ARHTZR1nGY8gbxIAeHQxGPuUjylheOU62AlIXzg+1eRstARycn9+O4biq50Ot+c7/NKqZQg==
X-Received: by 2002:a05:6402:42d3:b0:435:2c49:313d with SMTP id i19-20020a05640242d300b004352c49313dmr3436835edc.86.1660852844709;
        Thu, 18 Aug 2022 13:00:44 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:44 -0700 (PDT)
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
Subject: [PATCH v7 15/26] tcp: authopt: Add NOSEND/NORECV flags
Date:   Thu, 18 Aug 2022 22:59:49 +0300
Message-Id: <747981be06c06a5415d22cbd29a9b7c03706a913.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flags to allow marking individual keys and invalid for send or recv.
Making keys assymetric this way is not mentioned in RFC5925 but RFC8177
requires that keys inside a keychain have independent "accept" and
"send" lifetimes.

Flag names are negative so that the default behavior is for keys to be
valid for both send and recv.

Setting both NOSEND and NORECV for a certain peer address can be used on
a listen socket can be used to mean "TCP-AO is required from this peer
but no keys are currently valid".

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/uapi/linux/tcp.h | 4 ++++
 net/ipv4/tcp_authopt.c   | 9 ++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index a7f5f918ed5a..ed27feb93b0e 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -401,16 +401,20 @@ struct tcp_authopt {
  *
  * @TCP_AUTHOPT_KEY_DEL: Delete the key and ignore non-id fields
  * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
  * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
+ * @TCP_AUTHOPT_KEY_NOSEND: Key invalid for send (expired)
+ * @TCP_AUTHOPT_KEY_NORECV: Key invalid for recv (expired)
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
 	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
+	TCP_AUTHOPT_KEY_NOSEND = (1 << 4),
+	TCP_AUTHOPT_KEY_NORECV = (1 << 5),
 };
 
 /**
  * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
  */
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index bb26fb1c8af2..0ead961fcfe0 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -374,10 +374,12 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_aut
 	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (send_id >= 0 && key->send_id != send_id)
 			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
+			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
 		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
 			if (l3index < 0)
@@ -623,11 +625,13 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
 	TCP_AUTHOPT_KEY_ADDR_BIND | \
-	TCP_AUTHOPT_KEY_IFINDEX)
+	TCP_AUTHOPT_KEY_IFINDEX | \
+	TCP_AUTHOPT_KEY_NOSEND | \
+	TCP_AUTHOPT_KEY_NORECV)
 
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
@@ -1534,10 +1538,13 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 
 			if (l3index != key->l3index)
 				continue;
 		}
 		*anykey = true;
+		// If only keys with norecv flag are present still consider that
+		if (key->flags & TCP_AUTHOPT_KEY_NORECV)
+			continue;
 		if (recv_id >= 0 && key->recv_id != recv_id)
 			continue;
 		if (better_key_match(result, key))
 			result = key;
 		else if (result)
-- 
2.25.1

