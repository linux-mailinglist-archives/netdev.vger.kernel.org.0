Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94375131D5
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiD1LBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344966AbiD1LBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:01:02 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3196A95A3E;
        Thu, 28 Apr 2022 03:57:45 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i5so6196906wrc.13;
        Thu, 28 Apr 2022 03:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ul+t6uTHofyRjOEGXVcu4PlOdgwxB5M3MPuVkOzIQ1Y=;
        b=cZNzSUcmv+bYXCqMXlvHlmCao3TAKfZHR+cXCTOPk2meuPJBce0NtdnKSKUdN4ZWnm
         09VNe1iMqfCkrXJJfWUPBIp56YBIezb6yGscB49qDR4JuMXc4hEK/154pW/Hrfkks5ad
         6JrtsOHq9v1wuPZ7Z9Um8Ba1UWVyHD5EQ+Pru2lrrQDnKmw7SHpXMAN/gCJdVI1paVoM
         4z8XZsAj1W7k3Ow+sF4mR6DOc4wLFPTKMU0oRXTmxCWYY4Id/5qjtYCNwPG4U10UPMJL
         I9Lg3PaD85uWESe4Tu5HV4L92sFCIulFdOamKyhrf1fWInkMuY+wy+P52vlfatsd+XO+
         6Vrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ul+t6uTHofyRjOEGXVcu4PlOdgwxB5M3MPuVkOzIQ1Y=;
        b=2VkOY7wRbQqPHn8pQHIgsoPaUHMyaUrUbbGROQ/sjiJV2YMsZFJPLmTgtA1tfgnATQ
         RwV2lKI6kMI4NwGKjzc5zdzV8vEi5eT4rmtOl40/mla8ltmJ4wxPYB4Bq/xMPPGgFdk2
         oRgl6aCohi45kf21671u/WRmQcOJ1VF8t+miyMgOXd/TZzaj6z4VNt7seFHa8XA8b7/j
         bJrIwkXmk3EbtsUkfVl8NFLxWMkCX2+tRSHKxRW2DHHidw3mtq2cuUzQjXRv1kX9Stee
         EAzdyc6z9gXOw9lvQu+CwBU1Y6aGCFevfI4/EA+qmA/iRSGWiRwMHnLcG2So4UOFow2p
         s12A==
X-Gm-Message-State: AOAM530MX13ITWFunCgNKtNaD2YJ/WWnx77CzJJshXNDVmmCBIChycrJ
        QVu+y3UE84SgFpKDjNFnHXA9jHKuXjA=
X-Google-Smtp-Source: ABdhPJwck+eoUYcstYlxOr02IVXvb1NXBw5lVqFBRIXksd9+2gk9v8n1XSWqgBOB/56Rxty548l5Vg==
X-Received: by 2002:a05:6000:114d:b0:20a:d608:5e54 with SMTP id d13-20020a056000114d00b0020ad6085e54mr19754957wrx.539.1651143463594;
        Thu, 28 Apr 2022 03:57:43 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 08/10] ipv6: refactor opts push in __ip6_make_skb()
Date:   Thu, 28 Apr 2022 11:56:40 +0100
Message-Id: <3d72bc581954b5a9156661cf6957a72c5940a459.1651071506.git.asml.silence@gmail.com>
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

Don't preload v6_cork->opt before we actually need it, it likely to be
saved on the stack and read again for no good reason.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 976554d0fdec..43a541bbcf5f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1855,7 +1855,6 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
 	struct ipv6hdr *hdr;
-	struct ipv6_txoptions *opt = v6_cork->opt;
 	struct rt6_info *rt = (struct rt6_info *)cork->base.dst;
 	struct flowi6 *fl6 = &cork->fl.u.ip6;
 	unsigned char proto = fl6->flowi6_proto;
@@ -1884,10 +1883,14 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
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

