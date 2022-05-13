Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A568B52660F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382033AbiEMP1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381994AbiEMP1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:27:03 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C803D20F59;
        Fri, 13 May 2022 08:26:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id n10so16958500ejk.5;
        Fri, 13 May 2022 08:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BE2B7uKhNXQyg8J2kv6NnIFx4l6JsKDKmGAV5Q3AWIU=;
        b=cSQzIJFGbs6YjIOnMw/vwXKddJ7ZQRnMY3HOlTGeyOgYwaeP8PlznsbOtrgI8dloJq
         QvLoZ8TgMyZPXZt9QeGR1c/q5OTkR5O5XLH0hBXDeLNj37xzjNRhA3H7uQCAp5DJIBxf
         SwGJHOtiI/ZcffHh16aOc9y9UMFqMM19FH6fmFimBntm7CImnBckGAQYDV2puE6m1iOQ
         5oAAEWwT7FLn9jPjrUunHslgHt1TgVk9QnHaSDhd+tWC3xdkNdFmg5huaSyd9aaHaiul
         4CINtSms8YWv4IAyQXN2EhcL73PC8xw51OpBZftwvltgHkME0Wh+bGnV9nWXRi98X7LI
         tmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BE2B7uKhNXQyg8J2kv6NnIFx4l6JsKDKmGAV5Q3AWIU=;
        b=TDWmjvBdAC8shZlTzoktj3j5GD+YZHGXH11d76MhTzUkoS92TWq0Ku7r5DnpeYBrdu
         DaR5BRTOhSeQlRLx4ISJIYbQGLX/aUahaKiunv434fmduz1C+cwKGSO+88gjhfqDnT2P
         wMVEQ9o90phh7UxAlfeeF+Esxz37V7FH4OihABjfbqXqje/FaoJpDEDcit9pQru8KaKX
         o3D7QP2kG0Ivrjx3FTC/HWLy+KdXe0Gm1JP5goOHHeaKOzlnZpAMMD4SnK9Q5DeEC+/G
         7LA0n/6bGZSqFegReI/yrMSht6YZARuC/fjdDUP0zyuTs8YHFUo+zu7r0DIZfkJm7+n2
         jtDA==
X-Gm-Message-State: AOAM530IszcohDu2ECavduJKyFynbA69DtJ+V9O8OTXgG91K1kpWCscf
        vAZ6SbQRMXRce2MvbysqrTgSkBtqXrY=
X-Google-Smtp-Source: ABdhPJzeHzP56uLb9ZBQ+E5L/mcOfpQjQ0kh9CSyHC+1ERuzQLdRpzCN+rVBNGUeFgJVudUNWHKu8w==
X-Received: by 2002:a17:906:fca:b0:6f3:e2d8:7c57 with SMTP id c10-20020a1709060fca00b006f3e2d87c57mr4802766ejk.320.1652455615584;
        Fri, 13 May 2022 08:26:55 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 08/10] ipv6: refactor opts push in __ip6_make_skb()
Date:   Fri, 13 May 2022 16:26:13 +0100
Message-Id: <27c44aad28badebcaef184bd993b8f6c719ce1f8.1652368648.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
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

Don't preload v6_cork->opt before we actually need it, it likely to be
saved on the stack and read again for no good reason.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 53c0e33e3899..e2a6b9bdf79c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1856,7 +1856,6 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
 	struct ipv6hdr *hdr;
-	struct ipv6_txoptions *opt = v6_cork->opt;
 	struct rt6_info *rt = (struct rt6_info *)cork->base.dst;
 	struct flowi6 *fl6 = &cork->fl.u.ip6;
 	unsigned char proto = fl6->flowi6_proto;
@@ -1885,10 +1884,14 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	__skb_pull(skb, skb_network_header_len(skb));
 
 	final_dst = &fl6->daddr;
-	if (opt && opt->opt_flen)
-		ipv6_push_frag_opts(skb, opt, &proto);
-	if (opt && opt->opt_nflen)
-		ipv6_push_nfrag_opts(skb, opt, &proto, &final_dst, &fl6->saddr);
+	if (v6_cork->opt) {
+		struct ipv6_txoptions *opt = v6_cork->opt;
+
+		if (opt->opt_flen)
+			ipv6_push_frag_opts(skb, opt, &proto);
+		if (opt->opt_nflen)
+			ipv6_push_nfrag_opts(skb, opt, &proto, &final_dst, &fl6->saddr);
+	}
 
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
-- 
2.36.0

