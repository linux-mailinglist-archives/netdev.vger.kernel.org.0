Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C17D5671BC
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiGEPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiGEPBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:01:50 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D2B14D09;
        Tue,  5 Jul 2022 08:01:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b26so17991116wrc.2;
        Tue, 05 Jul 2022 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aRSWPFJdUal4sFDyAFcRSHQQ/M3F+xYGlhF06C7Lf5E=;
        b=RpkqCmLRhozjhYWzxW++3rhKUll3T+ICVb4zS6YNhNwRZX9MzhleXzAos7D7y6kN7u
         +UV2vsl1Z5EZERZbQvJyE3VJOnCtjjLRahsHgr9xK7mU80yNVtuUqgOtvtTciPFTajsg
         TFeMR9IH0vUqButRQDALFTzUA2iDaOG1wkPBMH//PWk6GmfoE3nUaScu8j/smM9roA8l
         Uo50it4z5qg84LP2UXE5bjUcv9BMTg01ohdcauUK+gYJi9snniD9Q2EEPbGHawE8RlJW
         RW1v63M00TSsMBchemmJq8dgMBu13Ww0ZjVcTYmaC9LHGy1CtIOnvtIFFDevIKmKd31e
         xQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRSWPFJdUal4sFDyAFcRSHQQ/M3F+xYGlhF06C7Lf5E=;
        b=cdEIXXrGO+ONaswF0Ono9GaOwXr+oAkmTzhEPsvECXG29ojQCD1kifsYkZZgd1I98F
         IcULMBfO1uXfYLK9Z93NnWPqvTqpXIFt/syoF5xsgzOj6ahT697O6xj+jOd7GwKdReld
         rciO3BTR5/eDgzjbPHlwPVzd3aBVAZYX7ybIxx3KqKLfmxbg1aLDjxAZiPBvk1w4/2Q7
         rx0JvSzL4AJOw1cGrnTQdAYJy6+5uYquATWOj4qAC20QH18O4m/QN6EBh0Yty40mpVbW
         vUoOiMWY+1QCuvZgcc8NvevFzp54Zj9C+954EsG7svG9cqdlxeWJTt4C1T+PGgC6m1y+
         to8Q==
X-Gm-Message-State: AJIora9ILoyrXj+q52vpy7up/Iluupdl6Gfg6joclLF52WKnd02PGEU9
        VXzoksfFmclC3pogVTXUoak99DuU2d/0Bg==
X-Google-Smtp-Source: AGRyM1u5PixJZ36vQLGgOdknikkAz8OeJE6qGe2mw2AmgLxXZNsqeQE4JXo11kUAjuPPYBIx6csFdw==
X-Received: by 2002:a5d:4cca:0:b0:21d:6786:fb6e with SMTP id c10-20020a5d4cca000000b0021d6786fb6emr12758028wrt.233.1657033308024;
        Tue, 05 Jul 2022 08:01:48 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 01/25] ipv4: avoid partial copy for zc
Date:   Tue,  5 Jul 2022 16:01:01 +0100
Message-Id: <b377b00ee6387da881ef6e1cbea1ded8bd8e8676.1656318994.git.asml.silence@gmail.com>
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

