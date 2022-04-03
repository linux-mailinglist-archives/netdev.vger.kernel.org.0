Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C664F09AD
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358806AbiDCNL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358749AbiDCNLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:11:11 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6072A26AD4
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:43 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d29so4585482wra.10
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JSmEvATg3WA4os4xJY73VvZ9JZfZo2VfV1MEBUfftts=;
        b=eG5JfJsG7lB74ixtQefMRFk8g2WVqGrim5q70OGHklTdz9nLpF7e5BIOKf7/+FWiDv
         qtuEL8wmfDl6PF/GVgLv3tDsWCcju7qLcKrStoEaVBlVmUnDejxRYz0rY+AdpyqPCaqE
         ZlEe9daAJQ/UK53rEjASbKTSZricheWc+Qaln4bXmCOR0B62Cm+E96wyNaAP6Qv6lqMy
         lT16kL3VmH7esX97GSunziYZhJeOZDHTFiAX2lpO7Bz/sjT4qNkXTfxJwiuKEKEpeMvc
         1enDzs0bIUEt4YYhU9qaHf+Katjql2YXZBhwCGIsTJqL1SOE1RTK1fJu17JBYjO7l82G
         lK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JSmEvATg3WA4os4xJY73VvZ9JZfZo2VfV1MEBUfftts=;
        b=bU/r0fL3zA2KSaKWNqF2beMqqCVsoem0Z2QC9TOtHNbs6F9x3LqfdJW5n9WvD24cwt
         ruXicAq2NuGn7JXOHXRTp2PU0xVahj2vzFTse6NORKOty/1nMFLBi4TL3o0KBPGYsQhw
         Iw5yM5fQXG5C1xS+nuVSnFRSFlAjdWumpQPIpPr9+UwLY1QajxuH5q0srZnE+/Al7r3H
         1lBk6HZ2ZYvDufoIkemNgER/q+mpBi03JEer7VK871UTmx/Fc5lRnjM+5xBaGDhnn9WQ
         KHb+O06P+QOoVsl8rv3siMR5kVGrD7NkFBGp9TDN+HULmMl9scoJKDM/eLYOw3lV2xIv
         +4hQ==
X-Gm-Message-State: AOAM531U4PgKKxmDGJOOh8boTvOBinVwla81SsvbPW10ITCvGlfQORNp
        d8a2rD3aLQijsPSfMiVXbAKGyzvCjtA=
X-Google-Smtp-Source: ABdhPJyEnZ1WMKCWflAe3G/UYe1/rB+bPHZ4yMk+tdnYYzf4S60yzm45aXoklzdotc7CO5nwWWZA4g==
X-Received: by 2002:adf:d1eb:0:b0:205:a502:d2ff with SMTP id g11-20020adfd1eb000000b00205a502d2ffmr14000893wrd.125.1648991322258;
        Sun, 03 Apr 2022 06:08:42 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 25/27] ipv6: refactor opts push in __ip6_make_skb()
Date:   Sun,  3 Apr 2022 14:06:37 +0100
Message-Id: <3bfe4b8198720c5538b228fb82706d3f25f8a6b7.1648981571.git.asml.silence@gmail.com>
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

Don't preload v6_cork->opt before we actually need it, it likely to be
saved on the stack and read again for no good reason.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index bd5de7a5aa8c..3c37b07cbfae 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1857,7 +1857,6 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
 	struct ipv6hdr *hdr;
-	struct ipv6_txoptions *opt = v6_cork->opt;
 	struct rt6_info *rt = (struct rt6_info *)cork->base.dst;
 	struct flowi6 *fl6 = &cork->fl.u.ip6;
 	unsigned char proto = fl6->flowi6_proto;
@@ -1886,10 +1885,14 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
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
2.35.1

