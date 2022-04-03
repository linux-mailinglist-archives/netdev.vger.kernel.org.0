Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6F94F099F
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358542AbiDCNK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358421AbiDCNKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9E72717D
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:18 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d7so10623976wrb.7
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L1VtlVNeW0B4aRj8TAPTIudNNvRffgx/xr8HTpKXaaw=;
        b=Z4s1dCHD1hvK9Sd6pD3i0LprmTCayrEFXW3HZU/mXPqtQ6SVOSyfVeyKm1WWgTnUaK
         51a1RM+JVZQtg6Mj/wvGzLazNC/KqkzMDw5PSdxIZRy1387JRIY1KqL+HbYdqo245+1H
         ou/SwpIaMuz5dz6JhHzMGua+hMKeKuMh7GABpeXAGqqJC6jIw4EhiSgrMOauOeSeFJdE
         EcVX+NOlCJIQeycddwwfgS3T5nWE9cXARsoGgKBROHz3PyHNhN0QyUwUSvk+uij84AXD
         2fdk66GmlfroSg219pIGVjkNN7Anx4T/r48bRkN/3rUZ/laPI3NEP9L3nivxRc5HgAyJ
         IfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L1VtlVNeW0B4aRj8TAPTIudNNvRffgx/xr8HTpKXaaw=;
        b=wuuPHgjSVbrHlsXbCbKrQ26RHW1I48fAm2EkmslGrQth1WV66WEI91rBRGreW8I7QY
         UUoCqqVOpbLCz7/9EofwxBE70+lGEZk2Nv43Iy0KHjIHgpHITGuhceWk2X0MxnRsfklE
         RA2l3IlKQlL1z4nddF9YrLaXd8Hq5BbRBZSVQcY7SYjyZSHrpIZckBWh7R5BM/dYJlEP
         oOYnUSR+qg/fWTHbnxz5VovQ+VpncDXvCjSacnxPQTU+7GwcYh086TbJWUBR3wLOEKKk
         19MIjxpXE0ad6cVCurvg4dLimLTZDv35vz0IuKNRM1tZFOEFXylDaQOs3vP3Kzfs8Zsb
         vIHw==
X-Gm-Message-State: AOAM5332X9WTT2aiVAUQ6cx4k4Vib/Zsc44VKKt0oWQ5YVz8v+Kccc2T
        bSdmodbSFMWFWhPORRwzs9jOZKqMF6A=
X-Google-Smtp-Source: ABdhPJy+5Z3aXlocAGQzHFLIjaxgUfMehYWi5J6671yK/q85NUAUAGGebtln9schsjaBw+LIa6dYmw==
X-Received: by 2002:a05:6000:508:b0:1e4:a027:d147 with SMTP id a8-20020a056000050800b001e4a027d147mr13876685wrf.315.1648991296598;
        Sun, 03 Apr 2022 06:08:16 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 05/27] skbuff: drop null check from skb_zcopy
Date:   Sun,  3 Apr 2022 14:06:17 +0100
Message-Id: <62db530f5b9875c820c97d4b6b2f30b511d94468.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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

skb_zcopy() is used all around the networkong code including generic
paths. Many callers pass only a non-null skb, so we can remove it from
there and fix up several callers that would be affected. It removes
extra checks from zerocopy paths but also sheds some bytes from the
binary.

   text    data     bss     dec     hex filename
8521472       0       0 8521472  820700 arch/x86/boot/bzImage
8521056       0       0 8521056  820560 arch/x86/boot/bzImage
delta=416B

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 2 +-
 net/core/dev.c         | 2 +-
 net/core/skbuff.c      | 3 ++-
 net/ipv4/ip_output.c   | 7 +++++--
 net/ipv4/tcp.c         | 5 ++++-
 net/ipv6/ip6_output.c  | 7 +++++--
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f5de5c9cc3da..10f94b1909da 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1649,7 +1649,7 @@ static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
 
 static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 {
-	bool is_zcopy = skb && skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
+	bool is_zcopy = skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
 
 	return is_zcopy ? skb_uarg(skb) : NULL;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 8a5109479dbe..4842a398f08d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2286,7 +2286,7 @@ void dev_queue_xmit_nit(struct sk_buff *skb, struct net_device *dev)
 	}
 out_unlock:
 	if (pt_prev) {
-		if (!skb_orphan_frags_rx(skb2, GFP_ATOMIC))
+		if (!skb2 || !skb_orphan_frags_rx(skb2, GFP_ATOMIC))
 			pt_prev->func(skb2, skb->dev, pt_prev, skb->dev);
 		else
 			kfree_skb(skb2);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 10bde7c6db44..7680314038b4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -893,7 +893,8 @@ EXPORT_SYMBOL(skb_dump);
  */
 void skb_tx_error(struct sk_buff *skb)
 {
-	skb_zcopy_clear(skb, true);
+	if (skb)
+		skb_zcopy_clear(skb, true);
 }
 EXPORT_SYMBOL(skb_tx_error);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index f864b8c48e42..ab10b1f94669 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1018,10 +1018,13 @@ static int __ip_append_data(struct sock *sk,
 		csummode = CHECKSUM_PARTIAL;
 
 	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+		if (skb)
+			uarg = skb_zcopy(skb);
+		extra_uref = !uarg; /* only ref on new uarg */
+
+		uarg = msg_zerocopy_realloc(sk, length, uarg);
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cf18fbcbf123..add71b703520 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1205,7 +1205,10 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 	if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {
 		skb = tcp_write_queue_tail(sk);
-		uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
+		if (skb)
+			uarg = skb_zcopy(skb);
+
+		uarg = msg_zerocopy_realloc(sk, size, uarg);
 		if (!uarg) {
 			err = -ENOBUFS;
 			goto out_err;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e9b039f56637..f1ada6f2af7d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1520,10 +1520,13 @@ static int __ip6_append_data(struct sock *sk,
 		csummode = CHECKSUM_PARTIAL;
 
 	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+		if (skb)
+			uarg = skb_zcopy(skb);
+		extra_uref = !uarg; /* only ref on new uarg */
+
+		uarg = msg_zerocopy_realloc(sk, length, uarg);
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
-- 
2.35.1

