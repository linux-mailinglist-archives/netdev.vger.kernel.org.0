Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15125131D2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345016AbiD1LB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344983AbiD1LBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:01:09 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26092972C0;
        Thu, 28 Apr 2022 03:57:53 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so2801673wmn.1;
        Thu, 28 Apr 2022 03:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHrgbwGuKsi0qBohJI6HWm6IXg77xQmft6cGgAr+KkM=;
        b=geUv/xTB1yFlcqVhQ60GzWNNsG614lPO6/6WQ3DoVYqwbcGCewWErkE+ItiL8s7/6K
         Y0hz8OYfLZ++20kqDQybviBa6UMxi2i9Dhsfi66cWtpM33lKF1PJh/jTKRe/UTvv2UUt
         WLC8RqXNQ+OdlYOsNwX93WbIaVQS+VtVBi2q7e17IgClmTDWzwNA58FfL6z6bW8OAAoI
         XjZHIeqANnZH/2VvzzuoWzCdR09LTBSSw0dkaEl2NkVRW09GxelFWnLV8nN5CUVaIYTg
         xnuc+R/MZSFtl501LtAYGPpsa3paf8GEsFNZPckcr05S2r21xN2VafXUAZgg/M8bPEqe
         eYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHrgbwGuKsi0qBohJI6HWm6IXg77xQmft6cGgAr+KkM=;
        b=XlFKFd/rhxKgL1KF/dkxP1GNkfpXQ6uWvq+iXTuSrlmiXyBjGRsbDot3qPwwX/ffVL
         1MohPgXk9L6XeTjO9Y0uxMWzsdJSNsOm2KpMoaKgtA2blKQIXkRvFksEGxDU2tZ94Q/A
         cVCwqqNIj2NFCvAn2JY6P7l5d0xJ86Ra9tog2ohbf4qjl9MCtVXp6h7dRlSgorO8v/E6
         we9kxksxVfxlDgWk1txECfRgy0tYh0syG8kbfhW3A2uMq03h5ZCE9HmlaPJHLEZE+9cG
         ttgJ6NzpPDyUIBmk0hX7YYxeP8mVHSQSps2d6y/L2HcHlUwU1I5oevIy0BrkPAAHpGvh
         gG8Q==
X-Gm-Message-State: AOAM531uEIWml06VyEPjvUk6hoiwSv32Gt4LIXlZRDcp5N8C3Q63RMxF
        o1FpmhvpkXZ05UJFwLwrQ6B3T51ZTLs=
X-Google-Smtp-Source: ABdhPJwqKexuoFcmDd5VUkrdgO/u39Kb2z+ybEnox+4E3+l/os8x31qvpzppMSlGlpdKWjQE98Oafg==
X-Received: by 2002:a05:600c:3b26:b0:393:ec10:26fb with SMTP id m38-20020a05600c3b2600b00393ec1026fbmr17924924wms.69.1651143472044;
        Thu, 28 Apr 2022 03:57:52 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 11/11] ipv6: clean up ip6_setup_cork
Date:   Thu, 28 Apr 2022 11:56:45 +0100
Message-Id: <683aab669ffa7db48416137c904a406a37e9a0c9.1651071843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651071843.git.asml.silence@gmail.com>
References: <cover.1651071843.git.asml.silence@gmail.com>
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

