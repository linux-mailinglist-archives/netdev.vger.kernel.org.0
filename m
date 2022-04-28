Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7EE5135F2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347963AbiD1OC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347888AbiD1OCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA2CB644E;
        Thu, 28 Apr 2022 06:58:59 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i19so9714486eja.11;
        Thu, 28 Apr 2022 06:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e3JOSUJWrUPvCHFoWua5pWRqSGO0w+9yuqoonKqU/u4=;
        b=bu9hJGnpENGbvrQtkrbIXAPf4Sw3vEjeYxCmfzAqOM7GCOnajGxM78ci9ALZmaZAKr
         AcFhx8L+I2FlkTJl1uQvGfTOb0iR/IzfO7ovCL5TV+IFBQbheCjHPrNTJkVB6jrIUZaG
         p265sruCfLBHpPBB0FvJmwsuuphASy2KV1M8O4mBwkHaike/R7d8VSAKAfnEzbTqpRfU
         Bi+AmFh/aYYTJ90E8VCgyfdPnqaBMFvA/w0U0ufeNfzMNasb5+bgPpAnxOmLq16C+VM5
         eVyxs/5vlw4w4QRS4P9SFK0hl5uge3V14UBfcCGb+8P6j1oaG95G3HvNAzIXGS5g34pZ
         p1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e3JOSUJWrUPvCHFoWua5pWRqSGO0w+9yuqoonKqU/u4=;
        b=apWxoviwwRe6eeet8oe/FRWruDaXL8mCAsLNtmmmqFvJVdpeSSZMgBP+a/rmoi6x9L
         zsZLS44etYBEcHxOEzoXUg8MOgl6pMY5uu0zICoCMrO51aL91y522KPueHQiyaWvXADx
         7AovxXWQlWsmTJykyNYBaYnfn1H/prsjgGFSgOOTfwx4t5poMyQqm0lKS4vHMQMkMIqt
         GTcbdiE/GOFMDHVif7Ser8Z+4yUw3RjHOCMAEmb8+ud8U8Xd6nXD57NiNkgXYImlbAb1
         NnudSTTWYVKGOc2GQqmkLOSal80zcPpaiKYp20O6xoiImNc+gLMvLnxgJjTJvfboVyIQ
         qDVA==
X-Gm-Message-State: AOAM530eBH30mQ0ONTRXLpdaVrPEuNNfkVz/TA9zi8BNzPuk1OhcOWbx
        +LOr6fUXswPp0V/SnU47AAuIp3zdFas=
X-Google-Smtp-Source: ABdhPJzKCmlMsd5GcW/oVPQuRZeT1nKL2uqXvvyhw7YvkiV74YNikUr5s4g2YZz+8dM/RgLU3Z63ww==
X-Received: by 2002:a17:907:3f91:b0:6d7:16c0:ae1b with SMTP id hr17-20020a1709073f9100b006d716c0ae1bmr31513700ejc.74.1651154338239;
        Thu, 28 Apr 2022 06:58:58 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 10/11] ipv6: improve opt-less __ip6_make_skb()
Date:   Thu, 28 Apr 2022 14:58:05 +0100
Message-Id: <2313cc1d1cdf89c58f327c1be02bd04834824551.1651153920.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651153920.git.asml.silence@gmail.com>
References: <cover.1651153920.git.asml.silence@gmail.com>
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

We do a bit of a network header pointer shuffling in __ip6_make_skb()
expecting that ipv6_push_*frag_opts() might change the layout. Avoid it
with associated overhead when there are no opts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 43a541bbcf5f..416d14299242 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1880,22 +1880,20 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	/* Allow local fragmentation. */
 	skb->ignore_df = ip6_sk_ignore_df(sk);
-	__skb_pull(skb, skb_network_header_len(skb));
-
 	final_dst = &fl6->daddr;
 	if (v6_cork->opt) {
 		struct ipv6_txoptions *opt = v6_cork->opt;
 
+		__skb_pull(skb, skb_network_header_len(skb));
 		if (opt->opt_flen)
 			ipv6_push_frag_opts(skb, opt, &proto);
 		if (opt->opt_nflen)
 			ipv6_push_nfrag_opts(skb, opt, &proto, &final_dst, &fl6->saddr);
+		skb_push(skb, sizeof(struct ipv6hdr));
+		skb_reset_network_header(skb);
 	}
 
-	skb_push(skb, sizeof(struct ipv6hdr));
-	skb_reset_network_header(skb);
 	hdr = ipv6_hdr(skb);
-
 	ip6_flow_hdr(hdr, v6_cork->tclass,
 		     ip6_make_flowlabel(net, skb, fl6->flowlabel,
 					ip6_autoflowlabel(net, np), fl6));
-- 
2.36.0

