Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2348F59B20E
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 07:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiHUFTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 01:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiHUFTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 01:19:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836732613B;
        Sat, 20 Aug 2022 22:19:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo10998224pjd.3;
        Sat, 20 Aug 2022 22:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=VmvfnrPYEzpPF6Y856AkXDQVdZ3jpl0MX74dw35va6Y=;
        b=SFmaQ7MhV0Ourt4nihEsp7fI+0YdZipTcumKkQPDvje+27hlHATxqeYgaQmaZBKLZ/
         N6cLQRcVNPeeLfZPdrEKWFxUH0/4nnspgkQ/7EsmjIGH5VAZ1vjprZQftaj6tJ3vpW8U
         Ela+0uTNvpxyTsulEkdV03eeyJjWS3Q4KV0CoUj0vo00YDCebPAkkpNbD+mvWtKbwwto
         NOKC+SZQpdAsYTyfvCAhyO2OsGbWgIM6O/DegUEgmi1qEEcug3Q/FV9IOEVU/ZG+w8XK
         VP3ESICQwE3FEUuqRWgQV+KOW/lRFd1Xm8WyTt7MiL79puAK4gZRAHpzgiRnXWGYvSW4
         Dyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=VmvfnrPYEzpPF6Y856AkXDQVdZ3jpl0MX74dw35va6Y=;
        b=JFV+Nudzt047TnhQFsZydJ1ijN4tI18byqcDNP3Mh7XpAbFQQUDStH3cs3Vbbn8955
         XDKOUGimPzeRTBOjh9anTzSJ923Ge8PVjOR9Gs4ZEpHwROanON2hUwF6Sk8NesXaDR9M
         LSF96jr6TGWHWcmvMf18IDirf6wVkHA8h2VjSKDevv20T0/8Dx0iUD0fsQwX2niMW8YS
         8v97fOeqJGnJ8fcJXm+c6WRrBR3cIPJ9PR9ic0YOLlDJLgOnlUw4YOclPtyZ/HZO9GWa
         xBlcB/gL+Paojit2bZzz1TOOk9o3o80chnMVMd9+rSHpLQO3guikrFnXnvPDauCN7lI3
         cduQ==
X-Gm-Message-State: ACgBeo3yfjxp8Xw1MFcxSgyvVmhpK6kNf1H+aUBpuT4nSC0Wcp9M41aK
        sFrCJOmHWFhhFB72NtvzUyg=
X-Google-Smtp-Source: AA6agR4He35V2+kx8jmQy0IG67a9AQlM2FSh8o+vxIOERuJCva4fczrQ9cCiqNjoRhVBB5TJc4oWDQ==
X-Received: by 2002:a17:90b:1c89:b0:1f8:42dd:5ebb with SMTP id oo9-20020a17090b1c8900b001f842dd5ebbmr16325760pjb.246.1661059145959;
        Sat, 20 Aug 2022 22:19:05 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b0016c57657977sm5809913plk.41.2022.08.20.22.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 22:19:05 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, miguel.ojeda.sandonis@gmail.com,
        segher@kernel.crashing.org, ndesaulniers@google.com
Cc:     ojeda@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v5] net: skb: prevent the split of kfree_skb_reason() by gcc
Date:   Sun, 21 Aug 2022 13:18:58 +0800
Message-Id: <20220821051858.228284-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
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

Therefore, introduce '__fix_address', which is the combination of
'__noclone' and 'noinline', and apply it to kfree_skb_reason() to
prevent to from being splited or made inline.

(Is it better to simply apply '__noclone oninline' to kfree_skb_reason?
I'm thinking maybe other functions have the same problems)

Meanwhile, wrap 'skb_unref()' with 'unlikely()', as the compiler thinks
it is likely return true and splits kfree_skb_reason().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v5:
- replace optimize("O1") with '__noclone noinline', thanks for
  Segher Boessenkool and Nick Desaulniers's advice.
- wrap 'skb_unref()' with 'unlikely()', as Jakub Kicinski advise

v4:
- move the definition of __nofnsplit to compiler_attributes.h

v3:
- define __nofnsplit only for GCC
- add some document

v2:
- replace 'optimize' with '__optimize__' in __nofnsplit, as Miguel Ojeda
  advised.
---
 include/linux/compiler_attributes.h | 7 +++++++
 include/linux/skbuff.h              | 3 ++-
 net/core/skbuff.c                   | 5 +++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 445e80517cab..fc93c9488c76 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -371,4 +371,11 @@
  */
 #define __weak                          __attribute__((__weak__))
 
+/*
+ * Used by functions that use '__builtin_return_address'. These function
+ * don't want to be splited or made inline, which can make
+ * the '__builtin_return_address' get unexpected address.
+ */
+#define __fix_address noinline __noclone
+
 #endif /* __LINUX_COMPILER_ATTRIBUTES_H */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5d7ff8850eb2..4d0d3b4f0867 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1195,7 +1195,8 @@ static inline bool skb_unref(struct sk_buff *skb)
 	return true;
 }
 
-void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason);
+void __fix_address
+kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason);
 
 /**
  *	kfree_skb - free an sk_buff with 'NOT_SPECIFIED' reason
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 974bbbbe7138..35d9d5958dc6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -777,9 +777,10 @@ EXPORT_SYMBOL(__kfree_skb);
  *	hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
  *	tracepoint.
  */
-void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
+void __fix_address
+kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
-	if (!skb_unref(skb))
+	if (unlikely(!skb_unref(skb)))
 		return;
 
 	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
-- 
2.37.2

