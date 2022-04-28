Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82115131CB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345028AbiD1LBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344971AbiD1LBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:01:06 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99709681B;
        Thu, 28 Apr 2022 03:57:46 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j15so6261158wrb.2;
        Thu, 28 Apr 2022 03:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e3JOSUJWrUPvCHFoWua5pWRqSGO0w+9yuqoonKqU/u4=;
        b=eL7q2mgdQJaJ0Esr+ePbHxQKz4HHk0UPt1Ns9c+WfO4/Ng6MXt+4EZlOZAxz8kDAWu
         Qz+HfYpd5ogfL2w8suSVRYsHaHtG5dJ3IyVG8l1UEN2mEtNruNj9OybcDD4YeB/VbBH0
         RtpzcEtw+zdgcGOIi0704alycyY0NOGrF4Fzt9TdE+ZcsCV9HaWH+8fe94fNrOayV0Uk
         NxRD8DJiqKkRcrVGYuzy37DWfUTzoqRQX1mPGPSDJPzKKb5dUGVbEuW89XciLenoaYgG
         P/JNkZ6EOPZanVvNsA8aGdQl1TEUJzAah//NqrVSlOPlwERJ4PzZ9ys/PNxZhclrr0oJ
         74iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e3JOSUJWrUPvCHFoWua5pWRqSGO0w+9yuqoonKqU/u4=;
        b=cS0qDSR3SmB19SLQ17B0VMpPrBNXskjv0nkqLvBkFspGjWVMEUbsZpfhvU9brgIHST
         aE2mLaiRaQpc3m+VPGKi5p7xNsSuZbqWpIcJsVIJTs3rU1RDvWYkGH7NjOwLm5+JTtna
         HZOg6gTHZ/lTHrdlQa7rz4QM90g66wCnR7YYInc8gsXzSquDnme3IKBR2HipakGmhFvS
         wuNb6VqQIMzGc9av9qQw+OpeRX/SjiKD20fjoUZcTtJ12nhLPjh78Yt/cXG0GKrKa56H
         XzGOvBd5n3TIiFhuADvSnp75TPw95AuWwQOTpe7OzhQ6oVpgIBIEF4c/oj0lGgZU4ERU
         meqA==
X-Gm-Message-State: AOAM533PE6Xeh8mW2x3cTmC9hz96hcxcnMUXb8o+W5Y+1OHPyIl6XcaB
        C1V5ELCUrcorsh1VqZPGWkrtoPpwGbY=
X-Google-Smtp-Source: ABdhPJy/s/SxzIbIuA2jyZR46ty8wmnnh6mU39KKWgrZuMlC3i3k475A5WXcTVfo8z6AT7dRweGX4w==
X-Received: by 2002:a5d:4e88:0:b0:20a:f4ff:9d20 with SMTP id e8-20020a5d4e88000000b0020af4ff9d20mr3105887wru.51.1651143465324;
        Thu, 28 Apr 2022 03:57:45 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 09/10] ipv6: improve opt-less __ip6_make_skb()
Date:   Thu, 28 Apr 2022 11:56:41 +0100
Message-Id: <ca972b2910239e1860fb476bfdf4750db1403717.1651071506.git.asml.silence@gmail.com>
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

