Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD33155ED24
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiF1TAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiF1TAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:17 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB0ACE14;
        Tue, 28 Jun 2022 11:59:55 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e40so18931024eda.2;
        Tue, 28 Jun 2022 11:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aRSWPFJdUal4sFDyAFcRSHQQ/M3F+xYGlhF06C7Lf5E=;
        b=c1gbKgTS6cKh2Bf15wZewy0H9ONm8eU1XuQZp35JrwslHKC/enp7Fqh1o+b3dVMqJO
         g8mNWxOUfXm9EzyE4CGD7Tu58aamFaSBoz+Dpggx9IPu2T33m+lYeIOoOUBYi93iKdYb
         Tt8NC8PczuHidHiuqk3MQjiasZYSDorKQ6Ju6SbIUJnB/iamqNqjbSz7RVHvpgblCFoz
         5f0rOwxzw5HTyUxrdkQ3AB2qE7uf5lYaonHVWTYk3x7NBcx3Ou2QX2kfka4+zUQ8f41I
         6zgP/4Tf1PW22XB27CPSTBP9J+WnuFYjVsaFhZgiEny1DatirxVUECUv8FGvlLLz7Vks
         zu/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRSWPFJdUal4sFDyAFcRSHQQ/M3F+xYGlhF06C7Lf5E=;
        b=tJB0e9YbkUpfGEGWrLZwhVKpYiME4iJ2nGKDSC0PmZwHsIXT/GLfMGhQpVswWNAJN7
         E4XYCdznZcb7KzxH9M+zPT6rI0wKrxIJZT41Edf45e9GToGR/qLUVBkyKuPzg4qQCX/R
         zcnqbfHcEbEZrh5X3AZfPID3YcXl9bNmy/nBI53fd1me+onluFwV9SqLBaB8AJWey/WW
         VBM4eEIJ80ZQhbNGhspG18hmUf41yMf/FrImre5GaWIsR29RQppLoaZN9N8EXPZjWS+P
         zlJNDAKoL8qJzUDGTH6kSL029bGThoWmmny1GvvqBecrSk2mXo7hRC4iqYj2tddlcaWo
         /uYw==
X-Gm-Message-State: AJIora8jp60i/8Ixl2exD593NQnE0DlzSq3nhJd7hWfaa/8xqCJmHvbl
        ZoM7fG8ZqRTCZRUt0Ph5EJeUkLjSJGZWFw==
X-Google-Smtp-Source: AGRyM1uN0ZDn0lfTV06501LE/F3LZzgOFSGDVTUHnkOaY2bAL6wEd8O0aAawYXPuzgKrq8b9D/cO1g==
X-Received: by 2002:a05:6402:492:b0:437:4b50:d616 with SMTP id k18-20020a056402049200b004374b50d616mr19550368edv.43.1656442793703;
        Tue, 28 Jun 2022 11:59:53 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.11.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:59:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 01/29] ipv4: avoid partial copy for zc
Date:   Tue, 28 Jun 2022 19:56:23 +0100
Message-Id: <31cdb30c440efc9d4cebe196f4dc78d0c1484210.1653992701.git.asml.silence@gmail.com>
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
2.36.1

