Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4817756A1AC
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiGGLvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiGGLvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:51:51 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037D153D0E;
        Thu,  7 Jul 2022 04:51:51 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bk26so10878971wrb.11;
        Thu, 07 Jul 2022 04:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dYMbDXosaDJGTx1SMZg80SJyMd9PTOfSaObug9b0vzk=;
        b=oJVIkX7+2mHbvLuNu/u98vd92tZ0pCmSw7ZvJvTU9TV8S6d0b9S/g6p0Hr00d8LSJO
         xTpNllKVbC7MX6MbuQMH22+lwJnJuULFSgEyW2NCw1sfB37xvvlzt0DUPtGV6o6sAxpy
         +41wY3VkiUbDZwk+zqZZIyBHNVjSsOI66Ad3b+F1kP90AyawnhxxyniaquEKCKqvpI1G
         8J5wreGKmpG7LTYH4vbFzkiG0JNmSkvL0w0q8alKNEqxBH0kvXyAhrQ+Nk6Qc5tF36qY
         9HlNHoe/ACqJ1gVbYmLFngSjQSI0j9kUtcHjoH6d8PilwoeFJG4nx+Mv20fvfcEIvpbP
         oTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dYMbDXosaDJGTx1SMZg80SJyMd9PTOfSaObug9b0vzk=;
        b=comJHATdJBpL69hdyJ+Edti2MXL4iN607EZeSSaWcAV5b/wknYYkTWQKEQTLsFV/ub
         +76LsqJGM2Xis3FdiKq32hXu+sauAe6ZodNHeAuKuGEycLosNIUaOOnRPNNbz+PRnjfX
         GSql0bBEaytsugvMxa+1rXGbg+eA41qjWR2dRo3i8wcXscCKt4X1n1U+Kgeb+XyaA5Ns
         iP95b4fVL3CMF9B5LEst+q5RKT55kz4tcYCG0CaFNYOAYZLpDa81DhfGLKl/J8aAoSPw
         2FCYwfHZy9qOx0M0RYVM5JwBX1hKBXurttEE0dIMxxh6GY9OxQIbeczp/fnI13wYSZdk
         9wLw==
X-Gm-Message-State: AJIora9c6cyvgz6g4Oj8dlJcSxkr6jT8deoGnvb2Ra4wZsOvqe1Lqzoj
        sOHqENlkglnWK1d27RHwKga/mXDJwX7/vo8fP0g=
X-Google-Smtp-Source: AGRyM1vZHEBOHDdz9yTiW95DrD6gYc81aykfV7vdaykM8BiB+5wBQ6iEn87XZZItiVC5P9HI84WrSw==
X-Received: by 2002:a05:6000:2cb:b0:21d:7760:778c with SMTP id o11-20020a05600002cb00b0021d7760778cmr11450539wry.329.1657194709350;
        Thu, 07 Jul 2022 04:51:49 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 02/27] ipv6: avoid partial copy for zc
Date:   Thu,  7 Jul 2022 12:49:33 +0100
Message-Id: <899f19034c94ce4ce75464df132edf1b3a192ebd.1657194434.git.asml.silence@gmail.com>
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
2.36.1

