Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6635727C4
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiGLUxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiGLUxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:12 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E30CC782;
        Tue, 12 Jul 2022 13:53:11 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bu1so11641570wrb.9;
        Tue, 12 Jul 2022 13:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SL5QCbmxRVN2Iu3K+3SZdBj/leE9bYZIxrF5QeizLlc=;
        b=n2thYeKr1uORHjbkNzteTnpKgpMfvug7+zTbObHML5qGqLzY/C76gISJd97CDl9Mkn
         scpOuGyeZ85AjsqLKzk+4x3fde+ddmn67ONyKs1lX6ng9dieMxDnO6Jlmj68hP5nkG/D
         UX6x1xewtQz1GheammHBKTR53Gr8Sp48DR4ldG2anG0RGTKEshpyA9eHatOTlLMv2QSJ
         qVDaYNzhDU1ck6qRHPjyn+UyS2h9JfKFoS9yGNeMzZuOYJoGX6WG7xGV9Avc/BelRW3e
         v5HXg6EPFzTTznI94rawQuANyEYRZHQz8D491zACb3GcjV25F7wdC2pOWM6Mmm8g83PK
         aPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SL5QCbmxRVN2Iu3K+3SZdBj/leE9bYZIxrF5QeizLlc=;
        b=FVtr4g4mEtmjRapYaoIDb/PoofCVsRsKbOOJWd79a+ne4vQbswxVUPC+a7iw7Cl1kJ
         Pg/j9fGlKH3F9Bgp2YgN/TUBuOdPpZqWItmzAR2xy1VcEeGq87pxSz0tRyG2RI6cjz87
         feiT57JUaYUF1bdRqze7PBnRrhy4SvKrP8apD6FRrYs4pqjuzZ89bMen12pheSTmMVCO
         M0PC2fwtIpB/QDE6m4rOsDhbtGVu9EugkCNUezObp0/Ed2m17gBa6Dfd1MhAPwKZK8fc
         A0bgMPWTyP1lS0P/M7+PDwd30cE8a/V9ejHbzXQweqTeqvVPS7vbxJ4p+n//hdO/XFgM
         mEHw==
X-Gm-Message-State: AJIora9WK2nCAh2J7giquJMoh+i7yo4fPQ4eBGTMg+kJ5edGzzHhdxOu
        3JSvzgI4zl0nqNr8roON/EqyDQwyfSw=
X-Google-Smtp-Source: AGRyM1v5hj1bXBu/gKqNE7Gnj+j+mM/0mepgtXvGc0RMujzfF+eMeQfJNyizw0zNBg1PWLKXYRRQMg==
X-Received: by 2002:a5d:588b:0:b0:21d:a918:65a5 with SMTP id n11-20020a5d588b000000b0021da91865a5mr10606510wrf.210.1657659189643;
        Tue, 12 Jul 2022 13:53:09 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 02/27] ipv6: avoid partial copy for zc
Date:   Tue, 12 Jul 2022 21:52:26 +0100
Message-Id: <899f19034c94ce4ce75464df132edf1b3a192ebd.1657643355.git.asml.silence@gmail.com>
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

Even when zerocopy transmission is requested and possible,
__ip_append_data() will still copy a small chunk of data just because it
allocated some extra linear space (e.g. 128 bytes). It wastes CPU cycles
on copy and iter manipulations and also misalignes potentially aligned
data. Avoid such coies. And as a bonus we can allocate smaller skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 77e3f5970ce4..fc74ce3ed8cc 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1464,6 +1464,7 @@ static int __ip6_append_data(struct sock *sk,
 	int copy;
 	int err;
 	int offset = 0;
+	bool zc = false;
 	u32 tskey = 0;
 	struct rt6_info *rt = (struct rt6_info *)cork->dst;
 	struct ipv6_txoptions *opt = v6_cork->opt;
@@ -1549,6 +1550,7 @@ static int __ip6_append_data(struct sock *sk,
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
+			zc = true;
 		} else {
 			uarg->zerocopy = 0;
 			skb_zcopy_set(skb, uarg, &extra_uref);
@@ -1630,9 +1632,12 @@ static int __ip6_append_data(struct sock *sk,
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
-			else {
+			else if (!zc) {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
 				pagedlen = fraglen - alloclen;
+			} else {
+				alloclen = fragheaderlen + transhdrlen;
+				pagedlen = datalen - transhdrlen;
 			}
 			alloclen += alloc_extra;
 
-- 
2.37.0

