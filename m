Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D130B5671EE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiGEPCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiGEPCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:04 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129D61572F;
        Tue,  5 Jul 2022 08:01:59 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso9891323wma.2;
        Tue, 05 Jul 2022 08:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+E9HBSea0QLQi12+8hra9Imm7sGSrMpugcSoqydPq9A=;
        b=Utu6Up9oHePrJ9TGWq9tGqID2WUD4EUiHe8B6aGw6FR86OOrkeX/VRHCltmuY0Q4kD
         4k5gH4ghw1J8FKkvsiWSpsHsWSn6WpjZ3M1X/7VpAkvp5CumDUSh8Sv6Dw7JpvTCnPNa
         Z2yzPproSeTdUZWgPJQgQxI/TuY+zGjKJBflgZPp9Pwm25CrQ+rfauF3JSKOXczv2Kxc
         2fM+vEKM0DNb8LuxhXAM5FkyNZbNBb9sJNxfYMAJ1MeUuVuSQAMp81uBO0c2wgNHYPmJ
         wOOqlEfUMTjFtuAvv49qTVGaQpNvLh7V5PiFHwhlC9Y9fXnnHi26Ooa5DHr9BhJ5S9cc
         Mffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+E9HBSea0QLQi12+8hra9Imm7sGSrMpugcSoqydPq9A=;
        b=H43bVEFfzBJrm3mBNEGYqY8ymgRlON7osh9TGl8HdaR+XvCN/MtoEnKpEXjFb9Fwpy
         Grn80+a+U7wH9euZLxTdy8QRFnoUrhJipLbqJw6uUhscDV4XoWhE+LfMTtBhV8fPoK40
         xk+oPuzkvxwswUdhAK4VHEgfiGy/arGppXlbSL/rc49mY+yKIZx0uMgugrov3//msukS
         S92mBKBvGRUakl06NUgejihMmTe5X9HXmwgm88Q1dhwXsP6EKoXGNFR+Cz3NpTZfnteT
         CKo3zZL7LL3XNWOo1FMy2nDbjG9VvnDqYRl4lvjlQDcBWPs6dql7SMpRjPhy2sUFqnxa
         tylw==
X-Gm-Message-State: AJIora8ss68Y5choTUvF9H1PhP3aWn2kXRukTLbDhT1HIv8nCAjb9bWE
        i/JncKmT3H8f44kFnbAAqMGeC7FVl4IM8A==
X-Google-Smtp-Source: AGRyM1sVB6IM/YBuOlaNi9NmHKjqagwpO6IOclnO9H3x3nV4J4wLpsBSdF59jxp8dZjAVeQMhGXMwQ==
X-Received: by 2002:a05:600c:4282:b0:3a0:2ddf:4df2 with SMTP id v2-20020a05600c428200b003a02ddf4df2mr39083450wmc.119.1657033318344;
        Tue, 05 Jul 2022 08:01:58 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 09/25] ipv4/udp: support zc with managed data
Date:   Tue,  5 Jul 2022 16:01:09 +0100
Message-Id: <bf422eaa053b981ecf525e3c6d6c939f8d5a5a1d.1656318994.git.asml.silence@gmail.com>
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

