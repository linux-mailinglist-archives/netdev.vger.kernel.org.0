Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055045131CF
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344979AbiD1LBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344973AbiD1LBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:01:07 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73F19682C;
        Thu, 28 Apr 2022 03:57:48 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l16-20020a05600c1d1000b00394011013e8so2147183wms.1;
        Thu, 28 Apr 2022 03:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ul+t6uTHofyRjOEGXVcu4PlOdgwxB5M3MPuVkOzIQ1Y=;
        b=lgcr47LYHuUcL5xQnY6UqV7tiEtYMcg9xL6rPM6qQ5/1kMIpy8uzthRkZYEntaidTQ
         YTiKzGUDpNJBCvcbaz3sEdAQ/E5kTjL/Tr3PplQZeYeeJP5Rsk+O2UxwGi3myRBQdyuv
         SWfei+fWGf/UavE/7Djr+3F0SgypLR1JfpYi5Df8m5UU6Wv7MueGkUAJr8G06XxoI6/4
         HnoagrX3bSUKfsvoXLenuNrZS0akIBHs3XQ+/5FuynJFOMFLiGi6GhDVnjnOZhY3mRHm
         mmPTWBPRspM7maLEoUAWUHbpu+zbwLgRFtnVASvmNkWWCuylKyxfjZvINkaJQxS3hVvF
         kMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ul+t6uTHofyRjOEGXVcu4PlOdgwxB5M3MPuVkOzIQ1Y=;
        b=RoJQkn30t1S00L9WMpMxiaLInEX5Z33q0yDr20eEQ2sAvWhnaijTcN71ozfwOkGSLy
         +iOsipfhkA+B8Lcscr2+YHD0v/OqkasLlGDGiyoZ9PkJbJtqWlAZZi5V/Z/qdH7vBlwR
         bkPTTRB2IKksEsSSzTGRX5SE5hTnxzARNui4BnTwFv4Xst0C9KDMEgznTxWxRps+B75d
         6lXBlYM2mjNS0baHQrRy+0N4wDLdeQOWXaP0sKx924DmATzzUaj/ru6bwfBIh0pIVaHS
         8uNJLSlUsa6xtLzsSXagvb0Qu5UCF5olEB35IUrorp30XQ9mpcYueWwzeyGWRIpp7TBU
         uREw==
X-Gm-Message-State: AOAM530tu9b5AsAJGnspFLuBOkOXmQvTUeSaFJsV4p53R9iysIbhrXUb
        q/FEmPQCNO5Ry3L9TGNekvOk7X1VRg4=
X-Google-Smtp-Source: ABdhPJx8Y2D2f/Xi/57abAfzd0IbqV4YPktjPWzO4FNV+bxENgJIR1hwPXMrm9C3A9oPLx3JIacvKw==
X-Received: by 2002:a05:600c:240a:b0:394:18b:d722 with SMTP id 10-20020a05600c240a00b00394018bd722mr7736718wmp.177.1651143466987;
        Thu, 28 Apr 2022 03:57:46 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 09/11] ipv6: refactor opts push in __ip6_make_skb()
Date:   Thu, 28 Apr 2022 11:56:42 +0100
Message-Id: <c212894e96eebdee39f3ef8a75fc6c1d6b0c1e10.1651071843.git.asml.silence@gmail.com>
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

