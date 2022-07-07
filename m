Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D718B56A1AE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbiGGLwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbiGGLwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:03 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0389153D33;
        Thu,  7 Jul 2022 04:51:59 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d16so19626743wrv.10;
        Thu, 07 Jul 2022 04:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=++tIUpQtGSkeKjCS0jHLC0PODcc+eo2SODOf2a2LF1M=;
        b=A53V5STeaTnol4pMhOzEPuKv2y4iLeid1sqRq9e6jYzGWfsZiwJtnmmGunpPNAPt0b
         b9EC5W1t8FKIqAPiP+d8XwpQi/YZANO+ub6l9RcBUc2nC57FR1GNIEj0Lj/2deNwT6wJ
         frGuC/DjVxbLgLhaL96tlf8vCdxb6UjG1tBKDIhKY/YqBmK4PfAz1XSUJaEf0DiSbBh8
         NPvQ6zY3wRMlXENkhiqBFD6cbAnvnTRm6YynGZ/8z1tt9s+16clnAgjNmxWFB5+bhJE+
         IVUqcAM93zbHmGY5DmmjrMHCkLq44q6r/OY0qMrgQBC3I3DX0w0MQUugQ2pZVXViGjus
         0IOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=++tIUpQtGSkeKjCS0jHLC0PODcc+eo2SODOf2a2LF1M=;
        b=PEpQPEFcUQp4c/wZvYYWBxB2w1IGhXbisFSyZY2KovgfU/GME0tjPNmiabkHxMZw+B
         p9D+akHxgLK+N4JAInuj4LR9Uke3Qf/YT789UENcwt/65KfaqIkGYoKNf/r9/8ZCyOZo
         99KTCqsfM3QDzmo0yMZ8qHErYcDNKGNKqCZyBnQdax4OSwJwPZLqGglZaiU/VASxZ+0C
         bqZFWtiZZpDsGufe1yotXYTNtiEPYMSVl55miihB/lboYzKYudMs0BRQDnr3+yZmamRQ
         v7RUB4rqMwCz3KdxuF4MutuJfoxhGEef24/Et9xmnzWxAqiJZrlsHl0hZYcoeI5ETE+e
         DrhA==
X-Gm-Message-State: AJIora9yWDC4GmhR+Q8Pej1INgmwJD51WGo/5s6vPoRSZu1oK+PuNo9B
        P/Nsirg9S5gLnOSZaZzChu1Rf2vSWV0KSnfUz/c=
X-Google-Smtp-Source: AGRyM1vCf9z1ZEc+5Tas7+SnDucHB8uJjo8JUvx3cZcEQ7zLw6Adl7taSXYxtdIyIbaz1p+seuKcKw==
X-Received: by 2002:adf:dd87:0:b0:21d:6ec4:26b0 with SMTP id x7-20020adfdd87000000b0021d6ec426b0mr15484890wrl.182.1657194718343;
        Thu, 07 Jul 2022 04:51:58 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 10/27] ipv6/udp: support externally provided ubufs
Date:   Thu,  7 Jul 2022 12:49:41 +0100
Message-Id: <6d56b7c5ddf8add5b2a887dbd734c060e29ca6b2.1657194434.git.asml.silence@gmail.com>
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

Teach ipv6/udp how to use external ubuf_info provided in msghdr and
also prepare it for managed frags by sprinkling
skb_zcopy_downgrade_managed() when it could mix managed and not managed
frags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 44 ++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index fc74ce3ed8cc..897ca4f9b791 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1542,18 +1542,35 @@ static int __ip6_append_data(struct sock *sk,
 	    rt->dst.dev->features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
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
 
@@ -1747,13 +1764,14 @@ static int __ip6_append_data(struct sock *sk,
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
-- 
2.36.1

