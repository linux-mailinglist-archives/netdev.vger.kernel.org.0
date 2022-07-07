Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FDB56A188
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbiGGLwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbiGGLwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19564564C0;
        Thu,  7 Jul 2022 04:52:01 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m6-20020a05600c3b0600b003a0489f412cso795450wms.1;
        Thu, 07 Jul 2022 04:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=530Kj9fyhb4BAaf8FxSCXZ47V34wdCD15bBkxNyM1cg=;
        b=Xf4aZke/gjdB271cikF+a8GkXtrb/Sa9rjGTmUxWDuPpGwXHnBkR17Nn9l4GWAAAvf
         yhw6X/L/dDh8xOXl80GBKjiPISyAW6J8Ez+9183rxiBqcFSezxJsFtMSNGR9q7UDfhq5
         vkCbXEtvCXrXVqc4EA0RHmr4Gp9vMacJ9KcL5BgoYAVWn6Pnqy3bPgCOIQNhSCfspnIU
         e5WAxf22gSS8xlg/dQHgsA5M/pjSXWZsivseN4AnlP1BCViNg/z5AiUlF3yjc61DQeQu
         RWGlg19lv/9wLkATHYj6wjhgF4W893Z1WeM2q6F6tOLPNDYvqgqGlb5b1fJVyrhAjgE2
         WoLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=530Kj9fyhb4BAaf8FxSCXZ47V34wdCD15bBkxNyM1cg=;
        b=8C8VsN4uRfrpgzt/w+pSf5j2qB06cjTYC+MWRIvETDKSAhpEFQR8uAXDPCg8vITscm
         Kw506kmMJtmMyeb75KrxMsz44tIBZrswQyu7I02GOAuwAdtt9AV5slim3muCPXpe74/v
         BgaBBG81yr151IFV7aW+Pnk0iTqbZZCBnmPCorJNipV9+Uy88fc5V8P+5rJiXu0TErgD
         o7pHcS/rmBKBpwGGjth+LP6DbsGVP8VNdN3dA5U/QJpbvQRkFZmqm9PA8j2d7iOmPNRR
         wL3GGj7AzNzODByCIpjyrNae6zil6pAZGv78DJyBqWjfVY0jdVgdvVcWcS7nigrGudXR
         Z1kQ==
X-Gm-Message-State: AJIora+Qs9Ue/ceG7yMMCMqTqWRwQ3TxNhWVg025yb7GnYUe+7iyoo/h
        lN2klfdn3Wg497onGNywIJ74LjN3IfUhAv1J74E=
X-Google-Smtp-Source: AGRyM1uxnz3sxBaRDQ+35wnzIv5JZeO0SprLs2j7hkwtj6mhvk4MLcZL9rMqeDsQfLfKrG73a/VP3g==
X-Received: by 2002:a05:600c:1ca9:b0:3a0:43a9:5e1a with SMTP id k41-20020a05600c1ca900b003a043a95e1amr3881477wms.155.1657194719419;
        Thu, 07 Jul 2022 04:51:59 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 11/27] tcp: support externally provided ubufs
Date:   Thu,  7 Jul 2022 12:49:42 +0100
Message-Id: <7ee05f644e3b3626b693973738364bcb23cf905d.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
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

Teach ipv4/udp how to use external ubuf_info provided in msghdr and
also prepare it for managed frags by sprinkling
skb_zcopy_downgrade_managed() when it could mix managed and not managed
frags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/tcp.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 390eb3dc53bd..a81f694af5e9 100644
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
-- 
2.36.1

