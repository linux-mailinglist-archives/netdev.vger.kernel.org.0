Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B68F5671EA
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGEPCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiGEPCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:14 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DDA1658F;
        Tue,  5 Jul 2022 08:02:02 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f2so12595841wrr.6;
        Tue, 05 Jul 2022 08:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KyZlpO7Pd5tjNLef1myTjtIJ1vG1utvjduqSD0G6BDE=;
        b=qDCXHyX0/GU1ecBvFYBgl07k5ftG2Ecskq8qGKtifzxRmMahW/Q5VNvkwghgmidkkR
         gC6Vl8ulu63jd2OSnkblREktX+Cjn4Tdb7OatTrJPpg+OZQuxnoOQ2dZBta5aNMYddgx
         QIBy6G0dLw4K/2+lurCNdrQRp33JeeStMwQDlq67K4JfjoM6/k2WTWCHvfRCuIM/qu0B
         JXmKLka8WxD4rYQlggNsZm3Fdfjny4NpVn2msZmyX40dHr8KkuSiFNhCIZ6IFf0DoRt8
         MYJKhPmyZbW9naxi4P4SkOVbsPZhIBTfxKQNfi5nc3bB9JHuo5D8Z/JKfoWb0/440EfY
         1QEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KyZlpO7Pd5tjNLef1myTjtIJ1vG1utvjduqSD0G6BDE=;
        b=4Si7/0ZwGNDirTAlvwljiBzlsNHnr9dNu1DU3l39tH8l8gboFufkdpI6tRnQ4g5dm8
         fSyjmyQgcvq+8SIlR6rTWN5jSOkTkSTVSsiCeHabxe7w214f+v9/bKg5WpPU2OE9XbKR
         zHzuAuerozaVJfYokr/MJunSGSaCCsGEwOatRv7jER2505UuKqUOaQjpE26Dv4G+2M9o
         a6qRPW/2bHjJpS9dwJabsXnv9EkDjfEBFKtWbfrwcN5kzYfvf5Ga5JgzI9FtyaasSKsk
         lHGLKDFupIJXmJwTSDafoFlCZnbB5zjA4tJeTMUFRJUY+24oX6HlLSRkyn0sztbd8uZE
         8pTw==
X-Gm-Message-State: AJIora9pbhCv1rLea0ddF25hd5kxda2Olegqk+rxHfrbWq7hSjXqdGUt
        ri3feQlBhNZQSiH5mC9ZBpZ23SGfCmBhXA==
X-Google-Smtp-Source: AGRyM1scKLU7fIPXkhO1wvSVCPabhAo79LVIcQRSXC72+Jeu8w/lurbhdvnNPesG8wmwAZosjzWoFA==
X-Received: by 2002:adf:e182:0:b0:21b:92c8:b045 with SMTP id az2-20020adfe182000000b0021b92c8b045mr32314764wrb.219.1657033321067;
        Tue, 05 Jul 2022 08:02:01 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 11/25] tcp: support zc with managed data
Date:   Tue,  5 Jul 2022 16:01:11 +0100
Message-Id: <cd46ef115fb6ee38b2b5e873777c26b0332138e9.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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

Also make tcp to use managed data and propagate SKBFL_MANAGED_FRAG_REFS
to optimise frag pages referencing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/tcp.c | 52 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 390eb3dc53bd..05e2f6271f65 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1223,17 +1223,23 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 	flags = msg->msg_flags;
 
-	if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {
+	if ((flags & MSG_ZEROCOPY) && size) {
 		skb = tcp_write_queue_tail(sk);
-		uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
-		if (!uarg) {
-			err = -ENOBUFS;
-			goto out_err;
-		}
 
-		zc = sk->sk_route_caps & NETIF_F_SG;
-		if (!zc)
-			uarg->zerocopy = 0;
+		if (msg->msg_ubuf) {
+			uarg = msg->msg_ubuf;
+			net_zcopy_get(uarg);
+			zc = sk->sk_route_caps & NETIF_F_SG;
+		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
+			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
+			if (!uarg) {
+				err = -ENOBUFS;
+				goto out_err;
+			}
+			zc = sk->sk_route_caps & NETIF_F_SG;
+			if (!zc)
+				uarg->zerocopy = 0;
+		}
 	}
 
 	if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) &&
@@ -1356,9 +1362,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
-			if (tcp_downgrade_zcopy_pure(sk, skb))
-				goto wait_for_space;
-
+			if (unlikely(skb_zcopy_pure(skb) || skb_zcopy_managed(skb))) {
+				if (tcp_downgrade_zcopy_pure(sk, skb))
+					goto wait_for_space;
+				skb_zcopy_downgrade_managed(skb);
+			}
 			copy = tcp_wmem_schedule(sk, copy);
 			if (!copy)
 				goto wait_for_space;
@@ -1381,15 +1389,21 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			pfrag->offset += copy;
 		} else {
 			/* First append to a fragless skb builds initial
-			 * pure zerocopy skb
+			 * zerocopy skb
 			 */
-			if (!skb->len)
+			if (!skb->len) {
+				if (msg->msg_managed_data)
+					skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAG_REFS;
 				skb_shinfo(skb)->flags |= SKBFL_PURE_ZEROCOPY;
-
-			if (!skb_zcopy_pure(skb)) {
-				copy = tcp_wmem_schedule(sk, copy);
-				if (!copy)
-					goto wait_for_space;
+			} else {
+				/* appending, don't mix managed and unmanaged */
+				if (!msg->msg_managed_data)
+					skb_zcopy_downgrade_managed(skb);
+				if (!skb_zcopy_pure(skb)) {
+					copy = tcp_wmem_schedule(sk, copy);
+					if (!copy)
+						goto wait_for_space;
+				}
 			}
 
 			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
-- 
2.36.1

