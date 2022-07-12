Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5715727E0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiGLUxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiGLUxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:44 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94023D038E;
        Tue, 12 Jul 2022 13:53:21 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bu1so11642111wrb.9;
        Tue, 12 Jul 2022 13:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OJ0hXZfV5Alrn5VQyEcS8Jj+bIgVFhTm5Bw+BZyTG0c=;
        b=gUEjS0b1uKrgeP8SV+ckYTtCLYwhpD7RrM77qL572lXDM/R9S/ant/W8YQXwWS8+zB
         hMd/GuIMiQbUiCN7T9Kz3mcSLcXXPvy9vWl1ZWFtznrlOFtDTcti6qS0TlFpvKxQjcoe
         sGsQI+eAGvIGcRv8p5WIswDXDQT6geiY3gmb/Iyu1uiVYWBblSdY/5QHUaYCZSJUNk+z
         bMz+59jAper6eKDw3Bjn9wB7nnW48inVy3bLJfehRAuErxPTdNfdbceGPdrHorQFpp1z
         S7P6PC/b6hYgj5N6zZc7mwIkmsnMkejqrK2p1ZhJBxUqR8cCFbSb2UbTdqJzEEbYqSmb
         6IQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OJ0hXZfV5Alrn5VQyEcS8Jj+bIgVFhTm5Bw+BZyTG0c=;
        b=ycoHrmkTrgrqOQx7ptenRImEfrrV8AX/qi+KMMulpeatYDLkPt/MLBUX/GQP7QA1Ct
         kiSLF4DY6FOGVcHqao8OcPKw3q5uUGHWK0dCEdB5xQbjcpF31EiDpssYknjHpbZ9sXR7
         umH322GpXEXPwwo4J78zBne1FJFDsjTPG6MOIduteQ6Ogzuya5ABc5EIUnTJwAWRTe/R
         gUXOZU6guav9DW05UKq7On8WhaFfDewA1f2mjbGpFamLXpBGB+JlKp2qoiOA10Ivymxp
         Bp2UKIRftR4tz84HdM/otT2RSrbKPGcW5csFKXOP/Wtlx42/Yyxof8kYI5YnuxzM4XUc
         eTPA==
X-Gm-Message-State: AJIora9V/l+jUhFod1AoylzdwGvK04hTs813+PgBw7GCd0e6Xz+TTP6f
        REkyfUgPNHYc7SgSqCv/rBYtOkEC9f0=
X-Google-Smtp-Source: AGRyM1vd7lHZ0K8ZfBC4o5wvmHxAWa3AvtgHBbjRQkWNlv/9DxoLb2w3ZwrpMYP+O6fyLAgn5NaSUg==
X-Received: by 2002:a5d:4892:0:b0:20c:d4eb:1886 with SMTP id g18-20020a5d4892000000b0020cd4eb1886mr24080604wrq.96.1657659200697;
        Tue, 12 Jul 2022 13:53:20 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 11/27] tcp: support externally provided ubufs
Date:   Tue, 12 Jul 2022 21:52:35 +0100
Message-Id: <ed55670c84dc1b0d442e33a0855429a3e5c780d2.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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

Teach tcp how to use external ubuf_info provided in msghdr and
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
2.37.0

