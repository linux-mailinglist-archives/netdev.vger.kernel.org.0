Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A6658FBE2
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbiHKMH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiHKMHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:07:18 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F06C923E8;
        Thu, 11 Aug 2022 05:07:17 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d16so16730048pll.11;
        Thu, 11 Aug 2022 05:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=cYf61f7Lmz1suGaCzsPM3u8O35u5a+gB6S244m47580=;
        b=I/GbyQ9gVJDRzlLzIfzBvHaqmeWyeHkKVHR/tZi7ZdL8gXbcGZM2vfPuAacyAcZHFA
         82mrYgWKfSPJXy7aN1N42cHVFammRrYL8j87JaF0tTAJHcgOSOUx2T0jp84EZbCQkeSR
         EqbpdStnlhJQMycQaluSVzMLzy8O0aUvcJEABtCG/uxDNXrXURe5Su1gidMzL8NX9fJG
         2FEGRtxI9jHs0+WuN+/EeE87MuPSaTAMU+GSmucUqJA1ZaElGKhs5MjSAluFPI81b7JG
         ykGTGvQFYn7PQZeISw1TylQfxm6+Kj6KXZf9vqxqbDnupZyMpprWT9Dh6h1p95co59mW
         qwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=cYf61f7Lmz1suGaCzsPM3u8O35u5a+gB6S244m47580=;
        b=6MFHWH1uH9toTjb+42t7ltSYTf7VksYW8s3fs8FOsG/WPI8jc0kRr/R8O7p8FYWybX
         bURQ+ldUjcPqx00Yo8Q5n1qmFpGJY8HKItw3xvUnnXLdHeVxwWLL20qHedV769u4duRD
         wlVmMnR+gWtdye7WBN4kEB8q1RlkXNWsji24XIeIMvFpTqtFA9MhwDUCy8DK0iWJl4S2
         xIzuI6As40E1O90dyAbhSsI4sTnU4ntXyVBqZVV7kfOaTPWQMizVDPNCb9HO07dxDKZP
         UhPsTisZd8U/lVorIGelaxZ5jmwamorEeLSqkDQHpkWTelm1E9bZ8jIoN6dPWSwyLAPb
         dC/w==
X-Gm-Message-State: ACgBeo0pA7YXWml4JJne652XkzuOsdqMo0jSDk1hknSFP/mjHkax2Anx
        4d/rFZv7KVqeBvPHxn49gjQ=
X-Google-Smtp-Source: AA6agR6rrKYgPSyDwj6ac4qQasBectwV98v8pErZbxYuoGuDS/HSXX/Vw+SN1SRlSW3xr5S770ISYA==
X-Received: by 2002:a17:90b:1389:b0:1f3:a782:ab28 with SMTP id hr9-20020a17090b138900b001f3a782ab28mr8299442pjb.181.1660219636818;
        Thu, 11 Aug 2022 05:07:16 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.85])
        by smtp.gmail.com with ESMTPSA id l6-20020a17090a72c600b001f56315f9efsm3522953pjk.32.2022.08.11.05.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 05:07:16 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     ojeda@kernel.org, ndesaulniers@google.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, asml.silence@gmail.com,
        imagedong@tencent.com, luiz.von.dentz@intel.com,
        vasily.averin@linux.dev, jk@codeconstruct.com.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: skb: prevent the split of kfree_skb_reason() by gcc
Date:   Thu, 11 Aug 2022 20:07:08 +0800
Message-Id: <20220811120708.34912-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 include/linux/compiler_attributes.h | 2 ++
 net/core/skbuff.c                   | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 445e80517cab..51f7c13bca98 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -371,4 +371,6 @@
  */
 #define __weak                          __attribute__((__weak__))
 
+#define __nofnsplit                     __attribute__((optimize("O1")))
+
 #endif /* __LINUX_COMPILER_ATTRIBUTES_H */
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

