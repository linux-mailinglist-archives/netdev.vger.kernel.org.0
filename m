Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60FD47E5BA
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349270AbhLWPl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349102AbhLWPlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:41:05 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CB1C06175C;
        Thu, 23 Dec 2021 07:41:04 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id bm14so22946861edb.5;
        Thu, 23 Dec 2021 07:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TeRKucehsWGRQRB4QdxreoInCb5o1eayi99lDN4kmfs=;
        b=ShoE4C3BJ2bZ1XkL3fDxB+GL2U8hd0mO0ooTgg3Hkdpb0HcHc3m7a88VcLOsaknqTH
         KExbihYLxc37V09/DGE6ZlhwzSFFPrQOPlB+qDWfrJahudS9tLR9luxxeEzZTqVx2m0q
         /vkX5S/A2HaEAlfLg6Fi7OKOgvH1AZzTh1EXH/4skVewkxi+r25+PSwqqItTIYaK+moL
         14+qCEQpp1brPQ2BneuZ7KzGt9hnO84W2KgDjnAglQsFW2JvaDvVBDgi7piRq07UKUgE
         jE70/w3M9BukYfA3v/TtV+R0IU/yD7tEYHLF2hV1b1Ecvnh5+5HHhv8ibObIKzKBYmbM
         ZZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TeRKucehsWGRQRB4QdxreoInCb5o1eayi99lDN4kmfs=;
        b=tj4dzwB8rZTKByzkbC9x9IBd8h2U0qKqp9gaFz5rFtZ0su9Tb7s0XIHXg8nS7tHSRg
         sWWPCk7InGVUuzptxsS3NJiSxS25Qr8dyM6rAHA0futjZJF8Gy1ItZIV/1bcqqJmW+F6
         SKeTOzaqjLEmT6Xlfe/hulW+ZwqZTnso4TtihasihaC/6mx+j9HgBmWuuas1jmw58p5p
         f+Ba4G13GlSLd3st4z5Y1lmk/DUs/NttO6xj4/kf6wiCgvcQtGMJLIx0HhqNc4IajI+b
         l09XTilmWaqR+jqbuuVfs/S+nkuuIv/zeKhqgET76joUKHH3g/hmLxblVpLFDhX6NJIE
         mcbw==
X-Gm-Message-State: AOAM5336ZUrkrI/nSSpoF69CaZp0dtMCscUGbTFjGcntfbyTj4S7JrLj
        FZ7AYGWSWm6406L7OBHMoTM=
X-Google-Smtp-Source: ABdhPJxthFan6y+KWhGlhqflHHV2+HpQOtwMFkGMq2yw6m+ZqatCst3ceYdpwSNFB/STsWgeG0N/6Q==
X-Received: by 2002:a17:907:a406:: with SMTP id sg6mr2352872ejc.171.1640274063520;
        Thu, 23 Dec 2021 07:41:03 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:41:03 -0800 (PST)
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
Subject: [PATCH v4 14/19] tcp: authopt: Add NOSEND/NORECV flags
Date:   Thu, 23 Dec 2021 17:40:09 +0200
Message-Id: <4e3efe908b6c56bbb80f931333c3c32f6a68733a.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
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
index f3e244d036c3..c598f3cf72d5 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -358,10 +358,12 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_aut
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
@@ -607,11 +609,13 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 
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
@@ -1492,10 +1496,13 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 
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

