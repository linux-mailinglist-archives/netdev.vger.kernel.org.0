Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D5F5727C9
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiGLUxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiGLUxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:11 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DD2CC7B5;
        Tue, 12 Jul 2022 13:53:10 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d16so12795966wrv.10;
        Tue, 12 Jul 2022 13:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CSpyPINBLSakL+f4XH07kdAC7ZTTg0Q5TWmfGDE72to=;
        b=Y+wrjysnIf+pzI8B8xqNCUTh14dN/zlIPcJ9UW8YNJmtoUAx2ezf1sOfSZm3vkH7Bc
         p0s1vTjKonmXX7nhumEl54Im9VOHHFSp4J1VApk/GSGpMayalkfRL6Q1tIV9h9vapNrU
         8UKiAVaPZGQq17kwJG4nVe5L0hpUBYfrof8qAjJJIrypYAmuhWKZYwC/F/ROAUEOS0mY
         cxenRqLT3vH/XAw8KoR90Ug/5vMqffQN/K+D5Amd9ON5WtrVEE0eiAxgPjDbqxI/Tv+f
         UFyEyIi7XIRLpJxxdtzd43tCYjNzxMUGcWguncj0satuwtITbE7TPrPywEdl3uwC4lMD
         ksVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CSpyPINBLSakL+f4XH07kdAC7ZTTg0Q5TWmfGDE72to=;
        b=a+l5m4RKm5x4V/+Eg3smWin0HoR46rJPjwCt2L16yDQQDmCxlH/Ga6Jfh5IdscCf7X
         am18aEVOC4WX/Xjh32ZQ72MoA0oPYC9M4fepthXAai4mgM1WS75R4vHnQkg5QbcvA82h
         r5XBsHnbKtXczhki8tAb8KTsLSnLo3UbgIq2ganom7dV/eODjdAAgxMZMYVujLg6QZxx
         KaF5ChNZyWKBIEqb0CWRTY70dHWZRWzDXojTqkGWtwLvXSdvknCD3CzivWaCa8KFBdI0
         VTzFHDpiJM+pdNvaEPjGRckuoV5+7drl3a4dZjpfk6iQA5kK0IG8+95B+bqPHQ9vW9qR
         fOKw==
X-Gm-Message-State: AJIora+qTgL+vlqIOSsTepeY0FC4JR+iO1VU+mo330NJFcfAwBW7XwcV
        x6pFXsRQSo3CqrqpJHmU7GRddOVc/nk=
X-Google-Smtp-Source: AGRyM1v58aBWnzFvNd+rChFlVZWSBCMw8glPdGEKMpixHueVz/rQD156fzx7NkGato8LvPxTefQCIQ==
X-Received: by 2002:a05:6000:1545:b0:21d:8f3e:a0bd with SMTP id 5-20020a056000154500b0021d8f3ea0bdmr24536599wry.697.1657659188411;
        Tue, 12 Jul 2022 13:53:08 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 01/27] ipv4: avoid partial copy for zc
Date:   Tue, 12 Jul 2022 21:52:25 +0100
Message-Id: <0eb1cb5746e9ac938a7ba7848b33ccf680d30030.1657643355.git.asml.silence@gmail.com>
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
allocated some extra linear space (e.g. 148 bytes). It wastes CPU cycles
on copy and iter manipulations and also misalignes potentially aligned
data. Avoid such coies. And as a bonus we can allocate smaller skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/ip_output.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf26fd93..581d1e233260 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -969,7 +969,6 @@ static int __ip_append_data(struct sock *sk,
 	struct inet_sock *inet = inet_sk(sk);
 	struct ubuf_info *uarg = NULL;
 	struct sk_buff *skb;
-
 	struct ip_options *opt = cork->opt;
 	int hh_len;
 	int exthdrlen;
@@ -977,6 +976,7 @@ static int __ip_append_data(struct sock *sk,
 	int copy;
 	int err;
 	int offset = 0;
+	bool zc = false;
 	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
@@ -1025,6 +1025,7 @@ static int __ip_append_data(struct sock *sk,
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
+			zc = true;
 		} else {
 			uarg->zerocopy = 0;
 			skb_zcopy_set(skb, uarg, &extra_uref);
@@ -1091,9 +1092,12 @@ static int __ip_append_data(struct sock *sk,
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

