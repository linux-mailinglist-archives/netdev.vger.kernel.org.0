Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C5C55ED46
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiF1TBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbiF1TA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:28 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582BF17A9C;
        Tue, 28 Jun 2022 12:00:07 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id eq6so18872171edb.6;
        Tue, 28 Jun 2022 12:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5DskBu6zK/vS94aIx3bV1D04eBSiML1zSrR0iXhmDVw=;
        b=Xi3HjuCqDt5f5v6qFcqs8wBXNipUK5e1yBMsksvYLbz4Yug+qWtGS70p/lM1XWmFrK
         7wi8pHMzynNaVaQ10q++3oSpKFsIK6cdPWxdfYPisyahGnut51iQaYt9w2NSNFyWjsWB
         FUrh93nvW4mmO63XAlPT/S7cWsjjmQDntNIMoYqiNWQ5POCjwfC/tUfCZAYi62XBKZry
         gsCkWhBrf+FFHLOUWoyb8+csdgi0iv8Di1l8YxG+OfGP/m6RLMnyRMh/M0nporHK7Lib
         EkxrK4EadrtTk5GYbigaAttggzGWoBxlAkn4IYG6XTWCutmV+rnq1i2GBLbKOVIxXoWa
         Ef5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5DskBu6zK/vS94aIx3bV1D04eBSiML1zSrR0iXhmDVw=;
        b=HcylnpzhgE8tDe7Oxs8BcCJiJtrRnETlmNP4PwML2zlFNt6JfZl+TwwBDw6/GxEVdn
         i7xrN/KIEaN49hZS5oYLurLcgbzJ7PXBfMqCXLon6gViZaMuRqRUY4LbRbcIzfzrZiNo
         A9usV9alcH+HbY1aCGrHi3uZaG9J4gSwXCjmTs6huomAEhioPHcLh5qvA7Xbzq3MJj8S
         mtBEt14tgVnLU2bt7zZkGTWokDYllV3f17xszFSpp5GaNCJJgQfYddANpCmeeEcF74Kp
         P0SdvSKZlS26dgJj39ik8PIO52auNInFe/IlpGXcEs/oYd+IVfZ8d1fMbOe9ew2AkWoI
         GpYg==
X-Gm-Message-State: AJIora8iILo1StO+fJDuJRoRkVoQ9AfOZmTvLkqootUCWHh2a0743LQ0
        ggiCxRWVdGs++JqK07+X06KFamYfZ0AagQ==
X-Google-Smtp-Source: AGRyM1s7lwC8AO+svb+wrB69arjJr8HZojfDGncuroRBaSog16ZdmPUj3VX+v7AWqBS9n4T5TMrQQA==
X-Received: by 2002:a05:6402:538d:b0:435:7ca6:a136 with SMTP id ew13-20020a056402538d00b004357ca6a136mr25601657edb.268.1656442805664;
        Tue, 28 Jun 2022 12:00:05 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 11/29] tcp: support zc with managed data
Date:   Tue, 28 Jun 2022 19:56:33 +0100
Message-Id: <2d0c627c125cf1019096e1db04264e1cb6149dec.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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
 net/ipv4/tcp.c | 51 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9984d23a7f3e..832c1afcdbe7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1202,17 +1202,23 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
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
@@ -1335,8 +1341,13 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
-			if (tcp_downgrade_zcopy_pure(sk, skb) ||
-			    !sk_wmem_schedule(sk, copy))
+			if (unlikely(skb_zcopy_pure(skb) || skb_zcopy_managed(skb))) {
+				if (tcp_downgrade_zcopy_pure(sk, skb))
+					goto wait_for_space;
+				skb_zcopy_downgrade_managed(skb);
+			}
+
+			if (!sk_wmem_schedule(sk, copy))
 				goto wait_for_space;
 
 			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
@@ -1357,14 +1368,20 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
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
-				if (!sk_wmem_schedule(sk, copy))
-					goto wait_for_space;
+			} else {
+				/* appending, don't mix managed and unmanaged */
+				if (!msg->msg_managed_data)
+					skb_zcopy_downgrade_managed(skb);
+				if (!skb_zcopy_pure(skb)) {
+					if (!sk_wmem_schedule(sk, copy))
+						goto wait_for_space;
+				}
 			}
 
 			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
-- 
2.36.1

