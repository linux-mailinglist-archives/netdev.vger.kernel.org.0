Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFBE5131FE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345160AbiD1LEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345117AbiD1LES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:04:18 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC449F3B0;
        Thu, 28 Apr 2022 03:59:41 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v12so6218201wrv.10;
        Thu, 28 Apr 2022 03:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UWdt6/kj6CQanUvb/1U/JT2tCIyxFlbvE9RBa6NuQ9Y=;
        b=dxUoBWHq8/G/mTCjR4X/SBOP9c8cxgWUNkvq3di1dlDQujxsZtaLvTz5CUsxvYvD0C
         gzMVdBZj2AOBVzSkJ6CEnD9WsxuoDgTtsJ0k/uJCD9d+6lwOp0IKBR22I9LWHaXU911O
         JfaPqxh1AJhfQExmaQ1t1Wwc75im5LL4blvUjG2kPvn5FkBBB/3zlp1zKz7nE/38lg7Z
         xYr9y1/E9BYbnmBv6vX0AR3z3IAXL88wa1n4dDjDylARW73WySqFP33LCjBnSnzLwpKl
         IYTQa5a9oxihWpY/3vPNdnoKgh2SEyZ+lw01FJuwCoh6GGoQkdjPsTu2aRMaE6Rd2USy
         ksRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UWdt6/kj6CQanUvb/1U/JT2tCIyxFlbvE9RBa6NuQ9Y=;
        b=RG+eJRH1yinrLfnwQV0KeRuYrNCGmvMs7Hdexc6sBFrQM1DZ6RFkR7Q7D6kex9RdOG
         fGA/qsU/a0XTRIlhlFoiVaVBVBAJtydVRDZr8rZ57upV09EklOTfFXnW/V6RvkahXWxi
         CnwRcDEY6gUPuYISyHct+7WcxVNwhGJQxH+JCa4vPiT4VZdrZi20yXfGpUIKe9otE5OS
         Yd+0KPtLcIfAHg3+bs/8BFyHtbbysU16L8akIzZxz6+Kiiwz89NK6xBDd+GaIz0J1ozD
         9TE0NDQv6vb5nUML/tT3KDVYefrwpFcbnykmokb9N9odcrYdlMitZL5ziGe/Bdd3LR4+
         6fUw==
X-Gm-Message-State: AOAM532WvpFtMhQMCJ4fQjwRD4BD3d6j9YhR31khnN6iwQVd1I/mm238
        CyKwmQgJUriK1VZnGlVM8XpjnQRo2iE=
X-Google-Smtp-Source: ABdhPJwr7woSd2tVSZNGvcoKJW0Dug9oeN9orkvRFgM+O+58DLb5M1dyB3AGd1nKHUeIM0Q3Pz2mxw==
X-Received: by 2002:a05:6000:718:b0:20a:e310:664f with SMTP id bs24-20020a056000071800b0020ae310664fmr11335462wrb.22.1651143579272;
        Thu, 28 Apr 2022 03:59:39 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm16028895wrf.80.2022.04.28.03.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:59:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 4/5] ipv6: help __ip6_finish_output() inlining
Date:   Thu, 28 Apr 2022 11:58:47 +0100
Message-Id: <eb2534ea720b757065bf20bb2378924cb37035c7.1651141755.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651141755.git.asml.silence@gmail.com>
References: <cover.1651141755.git.asml.silence@gmail.com>
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

There are two callers of __ip6_finish_output(), both are in
ip6_finish_output(). We can combine the call sites into one and handle
return code after, that will inline __ip6_finish_output().

Note, error handling under NET_XMIT_CN will only return 0 if
__ip6_finish_output() succeded, and in this case it return 0.
Considering that NET_XMIT_SUCCESS is 0, it'll be returning exactly the
same result for it as before.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 1f3d777e7694..bda1d9f76f7e 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -198,7 +198,6 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	ret = BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
 	switch (ret) {
 	case NET_XMIT_SUCCESS:
-		return __ip6_finish_output(net, sk, skb);
 	case NET_XMIT_CN:
 		return __ip6_finish_output(net, sk, skb) ? : ret;
 	default:
-- 
2.36.0

