Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE046D29D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhLHLnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbhLHLm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:42:59 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B42C0698FC;
        Wed,  8 Dec 2021 03:38:22 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id e3so7429687edu.4;
        Wed, 08 Dec 2021 03:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ywzuVgCinydpcSFZ+BFaxNNm0V4GRalVjewG4V+xb2I=;
        b=Cjya0TklOanEJiGEi/9HAcP4LpZULT7jnXFL5DX8g8MrQ1RIScRovSRD2ZBcx8iSL0
         tteMRyn3VQfT7C97xpwoI4tKBEjTBXQfzKLodGmZEKRomhDJ0GzLF9qRDYZCGiVZU8NE
         vQLJQ/fZpysw3U1PbSZqKOpbhdbRBO8Cex8v8unUQcIouA6SLXxfMMCw0Q4G6MuJFTAU
         hoHfbY1abtESL/xl1giDpVLVQhtUvRV0gpvMRoAwBvCaomNqm3KgqFrFbh6vNu86hzuc
         FsuhUX91EYzQ4MEANXx2eHNnNTDqs4smQpa8BHfg15f1L+mkscy+sqSg11Ep0s2xIAtM
         y0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ywzuVgCinydpcSFZ+BFaxNNm0V4GRalVjewG4V+xb2I=;
        b=2QgL/gSNCCjawhlLCoLuXd5BCm3iuel4rsAyGloNWiKwMVZWE3quTHUODGKsFbiAih
         leegD3RgD8R9FRWn5+HEDaT3WFjVxh+e+++ncE32KZgGkZMeezlEiXNwaHG2IdoEB8yE
         Wf8Y1ChbebiZ7BkLNWvgCwljm2fpT1QwkBRq+OtyUp+2EjfeAgWSwgixZ7H0J24ccwu8
         thgaJXvqwHJTrXv16ZoDFkcWAXsJLRetIVivnxmqRB14meCcHGgK61bC1etinG3Lj3/L
         9YVWwZj7AwgAbDjJgRoqx449w4shnBtmB6GNb7MKDYuSMgfIHEn/aqZK0YQJIFnI083W
         9k4A==
X-Gm-Message-State: AOAM532KdjlcZUDE/MAQhu5/yx2jhhhqjcLLF5L41k3e+woG1U6wy2Jr
        h4UXh8pJOHEKkPKmBP3vXTk=
X-Google-Smtp-Source: ABdhPJzhAYVaiE5zHwUtPZ3UmzUs6kg3ZmF51kVe7s7qnnPBM9JsQm0H3j6PaJ+8GgicGFKtou8DwQ==
X-Received: by 2002:a05:6402:1d50:: with SMTP id dz16mr18563746edb.309.1638963501126;
        Wed, 08 Dec 2021 03:38:21 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:20 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 14/18] tcp: authopt: Add NOSEND/NORECV flags
Date:   Wed,  8 Dec 2021 13:37:29 +0200
Message-Id: <d2dad7788a2bc2ca730084e2ef45b17c761760e6.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index b3fd12fcb948..946d598258b1 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -311,10 +311,12 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_i
 	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
 		if (send_id >= 0 && key->send_id != send_id)
 			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
+			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
 		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
 			if (l3index < 0)
@@ -593,11 +595,13 @@ void tcp_authopt_clear(struct sock *sk)
 
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
@@ -1496,10 +1500,13 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 
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

