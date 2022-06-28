Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A1C55ED2C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiF1TAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiF1TAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26341140AA;
        Tue, 28 Jun 2022 12:00:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id fd6so18898459edb.5;
        Tue, 28 Jun 2022 12:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+E9HBSea0QLQi12+8hra9Imm7sGSrMpugcSoqydPq9A=;
        b=dTWqNK98Gn4MmP59Z3IyWusFihnYIWy5+kLzy6LU7kO5oG8DE2jCQGGrI79EF8oQla
         5YDvsN7S0ilHpH5A636wABoV2x8mhtF4JcksaLm6bOMuOT7HDgVUyOaaKrkKlROzvfkG
         TsYlcgvrWbiFnl9gkdN3sUgFEaxr4IjrbDxCAU8FQ1+ukETiyPMK7n9Kiw4/657JIMIO
         D0nCY9l2t8vWDj04S23NUNbQKqx6aHiSOuGlSo1P05U1l/qewYgO/rVWnuPkEDPV1D04
         MGOE7t3OpvcyS2Qiul9PqzLf1GPcy9W32EBZxCmmZ5bN+2P9jmqIKdak4NCCGE0UD94X
         VlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+E9HBSea0QLQi12+8hra9Imm7sGSrMpugcSoqydPq9A=;
        b=P+bZZ6j04uFxj6q5kpyadzp2ozcXQFWHfzt8/c0qGm9NxNfmwTrImrslVJb/nBtFT4
         n49GY/SYG3/B9nMXZD/L/vap4kDu5JWgsZ33lhuKPTMzqZZs+sNSgyoIt1inFNWBH4q3
         dJXpG4slB7xQ6xPlkuLvVPmgJs3d2kKqJrVDYHQaInndq0IlBxENmxcckknoKANEY6sm
         DxOhNJ8lwL3i/6OeWFBg9PbzmepOdrnln5YxHmJ2tOvLE3j30TmXC2erM6Vx/E61VGKq
         cxTR7G7c5yaekOTsLHG+LOGLhvaWdkRHqR89tROtNyLAIYRuJtrTdHeOl1ogAetZQE/R
         sOPA==
X-Gm-Message-State: AJIora8bBV2fJvNAhu9Ikx/qhhPSgDn0Bqa6CE9eqECCYjdU41uNJ7Ck
        0B8EeX0pajLPHzn1xM1IhdJkaNvTmEtDWQ==
X-Google-Smtp-Source: AGRyM1u2+XY5XlbTpT1uHgGVfgjs7SYGIuDhO7cn7CWPNpq2P5wOt5KyPc0neCqLmzSZn9aIxfU4xQ==
X-Received: by 2002:aa7:c486:0:b0:435:5d50:ab39 with SMTP id m6-20020aa7c486000000b004355d50ab39mr25462247edq.104.1656442803398;
        Tue, 28 Jun 2022 12:00:03 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 09/29] ipv4/udp: support zc with managed data
Date:   Tue, 28 Jun 2022 19:56:31 +0100
Message-Id: <1904009c2af0197b922e413254ef2ff2c527f743.1653992701.git.asml.silence@gmail.com>
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

Teach ipv4/udp about managed data. Make it recognise and use
msg->msg_ubuf, and also set/propagate SKBFL_MANAGED_FRAG_REFS
down to skb_zerocopy_iter_dgram().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/ip_output.c | 57 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 581d1e233260..3fd1bf675598 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1017,18 +1017,35 @@ static int __ip_append_data(struct sock *sk,
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
 		csummode = CHECKSUM_PARTIAL;
 
-	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
-		if (!uarg)
-			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
-		    csummode == CHECKSUM_PARTIAL) {
-			paged = true;
-			zc = true;
-		} else {
-			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+	if ((flags & MSG_ZEROCOPY) && length) {
+		struct msghdr *msg = from;
+
+		if (getfrag == ip_generic_getfrag && msg->msg_ubuf) {
+			if (skb_zcopy(skb) && msg->msg_ubuf != skb_zcopy(skb))
+				return -EINVAL;
+
+			/* Leave uarg NULL if can't zerocopy, callers should
+			 * be able to handle it.
+			 */
+			if ((rt->dst.dev->features & NETIF_F_SG) &&
+			    csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+				uarg = msg->msg_ubuf;
+			}
+		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
+			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+			if (!uarg)
+				return -ENOBUFS;
+			extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
+			if (rt->dst.dev->features & NETIF_F_SG &&
+			    csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+			} else {
+				uarg->zerocopy = 0;
+				skb_zcopy_set(skb, uarg, &extra_uref);
+			}
 		}
 	}
 
@@ -1192,13 +1209,14 @@ static int __ip_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
-		} else if (!uarg || !uarg->zerocopy) {
+		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 
 			err = -ENOMEM;
 			if (!sk_page_frag_refill(sk, pfrag))
 				goto error;
 
+			skb_zcopy_downgrade_managed(skb);
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
 				err = -EMSGSIZE;
@@ -1223,7 +1241,18 @@ static int __ip_append_data(struct sock *sk,
 			skb->truesize += copy;
 			wmem_alloc_delta += copy;
 		} else {
-			err = skb_zerocopy_iter_dgram(skb, from, copy);
+			struct msghdr *msg = from;
+
+			if (!skb_shinfo(skb)->nr_frags) {
+				if (msg->msg_managed_data)
+					skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAG_REFS;
+			} else {
+				/* appending, don't mix managed and unmanaged */
+				if (!msg->msg_managed_data)
+					skb_zcopy_downgrade_managed(skb);
+			}
+
+			err = skb_zerocopy_iter_dgram(skb, msg, copy);
 			if (err < 0)
 				goto error;
 		}
-- 
2.36.1

