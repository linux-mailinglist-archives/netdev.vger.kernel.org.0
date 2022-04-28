Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B64E5135FB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347958AbiD1OCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347905AbiD1OCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:15 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09C8B6447;
        Thu, 28 Apr 2022 06:58:58 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gh6so9839825ejb.0;
        Thu, 28 Apr 2022 06:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ul+t6uTHofyRjOEGXVcu4PlOdgwxB5M3MPuVkOzIQ1Y=;
        b=lHba1uLAwlEqeDX0O18Zy79If8Dbj7fnO680n35KyJfb1TKelYJ/nLf0g+m0ab8qjO
         ri3zNmYRInXinUjVYLoDjax7bk91SCtscPtpwQ6VVIq1ZOtFo+53YOo5xi6qu80B4NPQ
         m3rQ+OLm5qi1wgDizKcHHVkhohPAdxwh6Jt8PeDKGTyOwHLlmnIaozDohee1OWi8Ml0j
         PFGsw+yyQZZlLLUe/sMMdJnvnHgXlAR0jwKjC/smtOk5dYQMHgpX8hPnSYCWzVX01k+2
         cfkRcMbTOYpodZoGgQlWWoYtAua8k0qEkAhx0K7BfHCo7rnPXlphGiEqDIANkxdbp6ct
         dFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ul+t6uTHofyRjOEGXVcu4PlOdgwxB5M3MPuVkOzIQ1Y=;
        b=KU0zpFvs+YQi2EuW70seABBmR3IoV1Hr0tMh29M6gS4hDvkJ4BFnNvdvD9al8QFoTh
         dsVQfvzUm8StcD1LU80HhgIPXJqva1hEMavPwYLc3UaC7Ln9qFK4rY6hTqudVjP+45Zw
         MbtCMBO5ZT/cIiEiAyPbqVD1jh4DWdqN/ktC7JzEIsoR97G/6bFtmiLYM58FnaqAF7Gq
         tNQ6Z2wJUkt6HZZ4n1V2tPGLBAu0YSOm9mssJc32lwumXSDF4ZLgBnth2186GrINNER/
         l05fiFfKYq72vSwCROwuL0tZvtGJ6Zpjfu+Jc/SRTPbMsnx/p/MKPg8kVulooPixDxm8
         2FdA==
X-Gm-Message-State: AOAM531VBCwGDqiyEJsnzzeoCxqu703kCxGUalqcluB8I0nAiTNK8r1V
        fFnrqUOLt2JANcN4DuYLiGC7PyC2E64=
X-Google-Smtp-Source: ABdhPJxtJm7d9+qlR3zeTV28IucfFTW4EzoAs5iOpC4iOUxIdQJjfnrHKXavxaA57z4/qGxZOhcozg==
X-Received: by 2002:a17:906:3ad3:b0:6cd:382b:86e5 with SMTP id z19-20020a1709063ad300b006cd382b86e5mr30032084ejd.145.1651154337065;
        Thu, 28 Apr 2022 06:58:57 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 09/11] ipv6: refactor opts push in __ip6_make_skb()
Date:   Thu, 28 Apr 2022 14:58:04 +0100
Message-Id: <c212894e96eebdee39f3ef8a75fc6c1d6b0c1e10.1651153920.git.asml.silence@gmail.com>
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

