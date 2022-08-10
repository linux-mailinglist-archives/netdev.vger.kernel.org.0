Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3FE58EFC7
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiHJPw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbiHJPwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:52:09 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF85C9E7;
        Wed, 10 Aug 2022 08:51:49 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id i128-20020a1c3b86000000b003a536d58f73so1212098wma.4;
        Wed, 10 Aug 2022 08:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=itYGv2JZK8WBFRrJm44D9H1rA7HcrDCnR5GlKfK0jhs=;
        b=g4eoVr1fu36ewbAmfG/t6UJBFOF1oHPXDiKrqdGSPIInTe4GhXxac8aY/xl6qj4Ry6
         hjJIrOjXgd6Yh8flP1MMruBaz19LaJGjliJaVdqyUgKhS5Iv3yZ5EXnaluD0BcKphXnA
         a5VMobfClu6mDyYL8AgAxvtUKvP55/JPpMBJHMu3wEu4WaWTzPCZhMYmHWz8b0MVDXhx
         GJ1Mj+/b/tEIWLH+pz8xBbXVEHEgTx42XMs5iv3QJxf8DSyr0HdmFD+Q1l3bx4FME1BL
         RC5BlkaAdauVJCjSBnJ19eyaQPimR9ZGZKGI4e8RTaSx6XcGE3jjRf3+QIMjbpvGpNmL
         Nr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=itYGv2JZK8WBFRrJm44D9H1rA7HcrDCnR5GlKfK0jhs=;
        b=SAstj7p49yuUTPY70/jB0k7C8YHoEWu1Mg2ea6ACYeDa3nXmArMRkeNQEuA3k4rGKV
         MdyCAXyDk+xVpkzYYMc5Ou1YnRpQH54kjkXVqcJMyvYwsYkEs4NdLE0hTl+qjLlft1Fw
         pJ4BkeKnDnuBUsFgCKgN83Pd/+PsTK03GtVlSdpg/zkxGsGliZvxslRUdbMv1y04rM1q
         G/M7qhOLLQvkIbLO7aykmsjWWQ0fkggkWaqUDil61VK03B2+jrIQOe23VQ+9kzC1qkmC
         dWqEX1eGkFtAc/JBAJdFZNo/7JiAQM+kTamNbOnRL3xdtT5LJxTPFs545uiy/0i9fqGM
         /kpA==
X-Gm-Message-State: ACgBeo2QsgzYzYGh799JV0RxiVAuM3yZwpDvLmSeiDlv9wDsTt3aMybs
        l8v/dMgQ22BolbXvyXHzgdW/+1gX/1U=
X-Google-Smtp-Source: AA6agR5tWoJNmIKULSv6qED4kYicFbD6aj95a2kTMgyfbOltADMEJMZMCY4KEhAPbmXEqnmelWqLpA==
X-Received: by 2002:a05:600c:6009:b0:3a5:b069:5d34 with SMTP id az9-20020a05600c600900b003a5b0695d34mr2478342wmb.115.1660146707842;
        Wed, 10 Aug 2022 08:51:47 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 08/11] net: let callers provide ->msg_ubuf refs
Date:   Wed, 10 Aug 2022 16:49:16 +0100
Message-Id: <526fe4cb9cda287bedfc92b3888b48a4f3b0250b.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660124059.git.asml.silence@gmail.com>
References: <cover.1660124059.git.asml.silence@gmail.com>
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

Some msg_ubuf providers like io_uring can keep elaborated ubuf_info
reference batching and caching, so it will be of benefit to let the
network layer to optionally steal some of the cached refs.

Add UARGFL_GIFT_REF, if set the caller has at least one extra reference
that it can gift away. If the network decides to take the ref it should
clear the flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 14 ++++++++++++++
 net/ipv4/ip_output.c   |  1 +
 net/ipv6/ip6_output.c  |  1 +
 3 files changed, 16 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 45fe7f0648d0..972ec676e222 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -527,6 +527,11 @@ enum {
 	 * be freed until we return.
 	 */
 	UARGFL_CALLER_PINNED = BIT(0),
+
+	/* The caller can gift one ubuf reference. The flag should be cleared
+	 * when the reference is taken.
+	 */
+	UARGFL_GIFT_REF = BIT(1),
 };
 
 /*
@@ -1709,6 +1714,15 @@ static inline void net_zcopy_put(struct ubuf_info *uarg)
 		uarg->callback(NULL, uarg, true);
 }
 
+static inline bool net_zcopy_get_gift_ref(struct ubuf_info *uarg)
+{
+	bool has_ref;
+
+	has_ref = uarg->flags & UARGFL_GIFT_REF;
+	uarg->flags &= ~UARGFL_GIFT_REF;
+	return has_ref;
+}
+
 static inline void net_zcopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
 	if (uarg) {
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 546897a4b4fa..9d42b6dd6b78 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1032,6 +1032,7 @@ static int __ip_append_data(struct sock *sk,
 				paged = true;
 				zc = true;
 				uarg = msg->msg_ubuf;
+				extra_uref = net_zcopy_get_gift_ref(uarg);
 			}
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 6d4f01a0cf6e..8d8a8bbdb8df 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1557,6 +1557,7 @@ static int __ip6_append_data(struct sock *sk,
 				paged = true;
 				zc = true;
 				uarg = msg->msg_ubuf;
+				extra_uref = net_zcopy_get_gift_ref(uarg);
 			}
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
-- 
2.37.0

