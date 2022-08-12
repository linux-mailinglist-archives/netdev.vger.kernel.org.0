Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F229B590A67
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 04:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiHLCu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 22:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbiHLCuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 22:50:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE161900C;
        Thu, 11 Aug 2022 19:50:24 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so6423938pjz.1;
        Thu, 11 Aug 2022 19:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=AIZvVMlGU+8xrlIg+scbeMLPAQHdI3AkHz0T/txqtNA=;
        b=DGf6fG+qqPqdY+ER0VAY7JrdJJRDfmzwHKOLYJoRKubxbKQ6HNu13Q0qgR2hGZYsNV
         bmhnQ7yZzJHH3t0O0s2JXrlqrepr3ipj3b98IIj4z6ANN9LWm8ST7qfaKqNT4zEpOLrU
         TP63WqhM2NYGAW4vYPktRa60REziaI1tAYGierATVok4Cd3HWgvPucknxuWi5EA7Pba+
         RYGBWwXWjZO5EC3lu2pBdfFFQtusYvUTaAtpgqtyTvOmVrDmOkY3g6PCNLwu1jMJ+Dk7
         g1sUyQpuTqkRMdjVMWCw/orRqdQ4zkyjULeoEIjVoiyHfsXBTEicWn33lUtX/1dEBX5H
         0IXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=AIZvVMlGU+8xrlIg+scbeMLPAQHdI3AkHz0T/txqtNA=;
        b=nA7i5NF9sL2rLqPqcRlHYV4XEj3QZ0e+vqHqdPkav5EFHcX4e5FKAe7tHaf5id7bgJ
         uhRXMQbPJtKpb6WVCCu2i8n/jOBFtB88aELz5/YFzBlTEBM3KqXPD1yriKjm+bFpxUjH
         7RCALBnulMYZ1CAbueMM995NQ/j3ka+X0uqvf8r61NWtSpMpRXULPi728x4EFk856O8I
         PAZBtlhaRm+NgAuX5flw19XIBQiCM/bF79LiXWO/4srYdG432OF632mcapJ9gSDD7ydc
         GPrhwXzc95fCfwUHaKGyGX72NaxKxQYuqVrucgmDyKTJpsRJSlicBYV6NjoZUq6NixVX
         G+MQ==
X-Gm-Message-State: ACgBeo0YKOBvBHOGxKOedmLEzCk3NboIS85BTfro1j13m6fZPp/q0hJO
        mOgp2zlJjV/1YTlFzb6qSRA=
X-Google-Smtp-Source: AA6agR51hCmeIyVEXVanfRYhNzx8TGQC5AudmRgTc4ZXlTynvqd8tV4xXPuaRPTDW+m1wi0zVQaLvw==
X-Received: by 2002:a17:902:d502:b0:171:47c7:a62b with SMTP id b2-20020a170902d50200b0017147c7a62bmr2070614plg.117.1660272623878;
        Thu, 11 Aug 2022 19:50:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.25])
        by smtp.gmail.com with ESMTPSA id u186-20020a6260c3000000b0052ab42ea0c5sm422460pfb.147.2022.08.11.19.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 19:50:23 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, miguel.ojeda.sandonis@gmail.com
Cc:     ojeda@kernel.org, ndesaulniers@google.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, asml.silence@gmail.com,
        imagedong@tencent.com, luiz.von.dentz@intel.com,
        vasily.averin@linux.dev, jk@codeconstruct.com.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2] net: skb: prevent the split of kfree_skb_reason() by gcc
Date:   Fri, 12 Aug 2022 10:50:15 +0800
Message-Id: <20220812025015.316609-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
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

From: Menglong Dong <imagedong@tencent.com>

Sometimes, gcc will optimize the function by spliting it to two or
more functions. In this case, kfree_skb_reason() is splited to
kfree_skb_reason and kfree_skb_reason.part.0. However, the
function/tracepoint trace_kfree_skb() in it needs the return address
of kfree_skb_reason().

This split makes the call chains becomes:
  kfree_skb_reason() -> kfree_skb_reason.part.0 -> trace_kfree_skb()

which makes the return address that passed to trace_kfree_skb() be
kfree_skb().

Therefore, prevent this kind of optimization to kfree_skb_reason() by
making the optimize level to "O1". I think these should be better
method instead of this "O1", but I can't figure it out......

This optimization CAN happen, which depend on the behavior of gcc.
I'm not able to reproduce it in the latest kernel code, but it happens
in my kernel of version 5.4.119. Maybe the latest code already do someting
that prevent this happen?

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- replace 'optimize' with '__optimize__' in __nofnsplit, as Miguel Ojeda
  advised.
---
 include/linux/compiler_attributes.h | 2 ++
 net/core/skbuff.c                   | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 445e80517cab..b910b5775fc7 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -270,6 +270,8 @@
  */
 #define __noreturn                      __attribute__((__noreturn__))
 
+#define __nofnsplit                     __attribute__((__optimize__("O1")))
+
 /*
  * Optional: not supported by gcc.
  * Optional: not supported by icc.
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 974bbbbe7138..ff9ccbc032b9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -777,7 +777,8 @@ EXPORT_SYMBOL(__kfree_skb);
  *	hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
  *	tracepoint.
  */
-void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
+void __nofnsplit
+kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	if (!skb_unref(skb))
 		return;
-- 
2.36.1

