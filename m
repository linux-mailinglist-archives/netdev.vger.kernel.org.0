Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F42955ED25
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiF1TAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiF1TAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:20 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79746CE1A;
        Tue, 28 Jun 2022 11:59:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id fd6so18898459edb.5;
        Tue, 28 Jun 2022 11:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5dH/7z5ivFVO5BHaFYr7Z/XbdA3PCvYtaqkIcRmZ+ew=;
        b=J3VMvjRE2aCmN5CovG1k5i/yJ77M0VMkQTyWYUV1xWfdD4M+GSgjHsTZEO3QayIdGP
         lAIaosJGVCaArl4kZy6ut6NvQWWD36X8UkgW3nniv6YbmwT/L93lY9DvPhrFarzh+/oN
         oTpQJi405WBnmM2UXaKszXT3sMfxkXwh0El8sPfRk9rGVIXAOlytuSr5vPNNwiJvg/Fj
         UTqmi2guHL9oDdsxKq1+cVVN8Yc33fLp1WtA0CN/sIvz0FqO2yZeWZ0qBrzyAQfakFua
         2m1HmBtZ7oHX//Jcmst2HVWUReS8QRpm+HoXDKAIyySHWrEFRAdMWH99zYlyL0ZB2t7M
         PyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5dH/7z5ivFVO5BHaFYr7Z/XbdA3PCvYtaqkIcRmZ+ew=;
        b=W8cSDoiFl9BpeVsPuViBg9FuIOCFteea1QYnvlPQC16B56qm6nHhMzTTW6NKxe5tm/
         MnKfukFgbVbxshRYXEqaM+zLRwHWoWCEZOQHp5+3W/CojNj47f7QH/UWZpAOVx9Fqcmk
         cFGMJrPedxEAcvqxTw2xij14iafzbKZsByQ/hXUY7j1WRPFpp8QPsUwdqwco6QLEgZpB
         ELzHMEhZi7PSim0LEUX1OJpN5VqDgdRDw/f8YnDXXay6wexOy5IpzdxfSg+aUm58gjeE
         9c4+mgflBt/QD0lT8J0EFv5dMfBPtBpM7Qr3A7HdRmTZcbC+Yh3iu12Z8BV5KAfU7Xrd
         dF+w==
X-Gm-Message-State: AJIora8CBBkfudOT7usC06vZeBFPutPk6Zoms+5aFCz2IwmhfHg2NRO0
        iUNMwmsIv2OTY3ZP9wDtCj6XcM8Uisos7g==
X-Google-Smtp-Source: AGRyM1tzidqJtkS9GbJ51EKbq3+QT82smcW2dq9tUHG5uXnX/7jnNszUnu93omlW5c0CoMGFi7Z/HA==
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id ew8-20020a056402538800b00435071b5d44mr24524607edb.364.1656442794760;
        Tue, 28 Jun 2022 11:59:54 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.11.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:59:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 02/29] ipv6: avoid partial copy for zc
Date:   Tue, 28 Jun 2022 19:56:24 +0100
Message-Id: <9806f2103d0c0512155957ee57ead379a11d93bd.1653992701.git.asml.silence@gmail.com>
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
allocated some extra linear space (e.g. 128 bytes). It wastes CPU cycles
on copy and iter manipulations and also misalignes potentially aligned
data. Avoid such coies. And as a bonus we can allocate smaller skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4081b12a01ff..6103cd9066ff 100644
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

