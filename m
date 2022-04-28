Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAB45131D0
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbiD1LBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344975AbiD1LBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:01:08 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB899728B;
        Thu, 28 Apr 2022 03:57:50 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p7-20020a05600c358700b00393e80c59daso3821699wmq.0;
        Thu, 28 Apr 2022 03:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHrgbwGuKsi0qBohJI6HWm6IXg77xQmft6cGgAr+KkM=;
        b=G08PfzWMMNczVdgm19wLhWwXkL0bjiazN2I6VAZLCQodi6Vb+C0Ia1UxSEIcuugs7Y
         Cc+n2Rtvk6yDrG/5nOM9cuDxyWaFgzzw5r+IxcVHlE7qcLeIoU2rsDae1x/zckgflrQ7
         iAkSz1mC7rz6t7OwL0y/uHH9tSCQVD47Ixt2w/y+Fhio/pisp51ckJ4T8DE5yB7EC6P8
         75c6Sw8vIHNXU1h3H7f+W+Md4AavCTscw7yY4vDcEhJlMsQWjyv0rHIUGhogdvt2qc8G
         hNcUaxATzp4h0NR4DKUY8ZBvl4HOt8LZYRMu9XWlczNx4YLm9CET5MCkMBVw355GOSuG
         z7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHrgbwGuKsi0qBohJI6HWm6IXg77xQmft6cGgAr+KkM=;
        b=pEKjOzOV9X2KB4ducBiMYfBNxMK/LAqyRUBKCEhrGUvONqpxkgnLMhaEb24mNAuy9U
         0gpK7M/ZTKO1jnHFyLLXxeNsOL7K8V+Q59REkYZH4uNhK1Gu1jwTHP6VrVWPpyvbObi7
         Ndwkg1vbuOipv6w8ZTM0KhiTbHXx9dCi2dZODoziXM7BxvSVXiVliMFS/prgHd9eTkF9
         3SUARfvG/NGqWFqQxCVMjbPNx1bnnYnhKXhjZ5rEC0XDD4T6usInX+ALE0TcYVhTy0wm
         K2Xl2E8JBqdDh2Wd6qgmLra2dhzsGmxvokE8LlkTeXb5wZIw3C9LzCCtpdo3h9B7MeTe
         U8hw==
X-Gm-Message-State: AOAM533ypdlPwCMrm+vNBag8VnAKz1TBnuKJUydmm7tjFA/YXlprIlpe
        +2pePQQLRegyl5xMLKYrl+JZ1o3bQ7E=
X-Google-Smtp-Source: ABdhPJwNB3CIXpmBVqQuNvVTeogjYXy4OSUnrAq0pSj4BB/n0N/SyvnNTi7eUWnXrYvPvLrMaAl/PA==
X-Received: by 2002:a1c:4e0b:0:b0:393:fd8f:e340 with SMTP id g11-20020a1c4e0b000000b00393fd8fe340mr8685091wmh.136.1651143468417;
        Thu, 28 Apr 2022 03:57:48 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 10/10] ipv6: clean up ip6_setup_cork
Date:   Thu, 28 Apr 2022 11:56:43 +0100
Message-Id: <f6eaf38144ac3feb915a594ba476e03563768f8c.1651071506.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651071506.git.asml.silence@gmail.com>
References: <cover.1651071506.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do a bit of refactoring for ip6_setup_cork(). Cache a xfrm_dst_path()
result to not call it twice, reshuffle ifs to not repeat some parts
twice and so.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 416d14299242..a17b26d5f34d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1358,15 +1358,13 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	unsigned int mtu;
 	struct ipv6_txoptions *nopt, *opt = ipc6->opt;
+	struct dst_entry *xrfm_dst;
 
 	/* callers pass dst together with a reference, set it first so
 	 * ip6_cork_release() can put it down even in case of an error.
 	 */
 	cork->base.dst = &rt->dst;
 
-	/*
-	 * setup for corking
-	 */
 	if (opt) {
 		if (WARN_ON(v6_cork->opt))
 			return -EINVAL;
@@ -1399,28 +1397,26 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	}
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
-	if (rt->dst.flags & DST_XFRM_TUNNEL)
-		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
-		      READ_ONCE(rt->dst.dev->mtu) : dst_mtu(&rt->dst);
+
+	xrfm_dst = xfrm_dst_path(&rt->dst);
+	if (dst_allfrag(xrfm_dst))
+		cork->base.flags |= IPCORK_ALLFRAG;
+
+	if (np->pmtudisc < IPV6_PMTUDISC_PROBE)
+		mtu = dst_mtu(rt->dst.flags & DST_XFRM_TUNNEL ? &rt->dst : xrfm_dst);
 	else
-		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
-			READ_ONCE(rt->dst.dev->mtu) : dst_mtu(xfrm_dst_path(&rt->dst));
-	if (np->frag_size < mtu) {
-		if (np->frag_size)
-			mtu = np->frag_size;
-	}
+		mtu = READ_ONCE(rt->dst.dev->mtu);
+
+	if (np->frag_size < mtu && np->frag_size)
+		mtu = np->frag_size;
+
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
 	cork->base.mark = ipc6->sockc.mark;
 	sock_tx_timestamp(sk, ipc6->sockc.tsflags, &cork->base.tx_flags);
-
-	if (dst_allfrag(xfrm_dst_path(&rt->dst)))
-		cork->base.flags |= IPCORK_ALLFRAG;
 	cork->base.length = 0;
-
 	cork->base.transmit_time = ipc6->sockc.transmit_time;
-
 	return 0;
 }
 
-- 
2.36.0

