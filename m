Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F235953A7
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiHPHYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiHPHY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:24:29 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90BA2BDADE;
        Mon, 15 Aug 2022 20:29:10 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w14so8060597plp.9;
        Mon, 15 Aug 2022 20:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=OjANN6U8pA8sv88uCgiJ2ZB40yWpGc8cpzibqLjqsTs=;
        b=JGv7upUA7KU3uEQOy/3IXnjKJWpHIR89MEJnKkwtTYXMI1tZzthQAOIG6Dpa6qAVdZ
         +EOVzBZ7jJYULdJfgYTFFBVrP+JWoqIfaOyJuq7xjKW9Rf3DSCyIZOm8RW0P3D4Pupd2
         jlhIQDU69adeFGdwIAFuESMAT5v+9Oe3tpnnAlcU6LUAi4ERlWrJ76FaSUTcRCh3uoY6
         AwSG28h6SLyhxy9ezQXyfGowFCZ3ZHeUNsr34AUvDW+NxaccGXyxSsDqTNxXvJikfCgB
         N6v9nQCJrr0GGZZ4xu+zOweOPA1N1lE8acMEaD/IBHEzRkPS+pJCCfiBI3FdUsJm5Ytx
         v+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=OjANN6U8pA8sv88uCgiJ2ZB40yWpGc8cpzibqLjqsTs=;
        b=v/DOtR472yc3HNRbj3MiXg2adRwPsB2v7lB6l7wTeA7W0SQMhak6CCVJEc6L33lvRT
         ljeIb/qo3IKRnpPp50u97PfjHG/jM66WFWPq9NzZK/V4CAashKoCIHMPSYYYJykof8Lv
         /i7G2fsQmQ47hBGQIo2vOSLwLl/QTFGKpn3z1LCENWglcy+6LGxIXfUPwI0zkyCbTfJo
         dGyOvwAP3fyTCBNmTicpexmDVI80NziPcUxbD+YNQd1Fd0T5cUaXFmW/CzBJhVf3XL5/
         9gixlktOB+Jl7/ixN68jfvLYGB/xtQT+T1KFAIduXcM80bSjYh8d9qzxsgpZV/quWr0X
         D21Q==
X-Gm-Message-State: ACgBeo0iUWscSrx8gCE1AuBHn6iXInI1NGKM16hCZcH99Oa5m+7ajchA
        +474ccE4Gx8suhrIQO8CxPU=
X-Google-Smtp-Source: AA6agR6Tx4qYm+YQ/HOdjF2Lj+IIWATa0PhcoyiB1folfWva+IA4ompclIEHgGDQg/1lqzxYeZpx4g==
X-Received: by 2002:a17:90a:fc2:b0:1f3:20d0:2e47 with SMTP id 60-20020a17090a0fc200b001f320d02e47mr21075881pjz.117.1660620549312;
        Mon, 15 Aug 2022 20:29:09 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.15])
        by smtp.gmail.com with ESMTPSA id f4-20020a623804000000b0052f20d70845sm7227227pfa.150.2022.08.15.20.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 20:29:08 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, miguel.ojeda.sandonis@gmail.com
Cc:     ojeda@kernel.org, ndesaulniers@google.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, asml.silence@gmail.com,
        imagedong@tencent.com, luiz.von.dentz@intel.com,
        vasily.averin@linux.dev, jk@codeconstruct.com.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v4] net: skb: prevent the split of kfree_skb_reason() by gcc
Date:   Tue, 16 Aug 2022 11:28:46 +0800
Message-Id: <20220816032846.2579217-1-imagedong@tencent.com>
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
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
v4:
- move the definition of __nofnsplit to compiler_attributes.h

v3:
- define __nofnsplit only for GCC
- add some document

v2:
- replace 'optimize' with '__optimize__' in __nofnsplit, as Miguel Ojeda
  advised.
---
 include/linux/compiler_attributes.h | 19 +++++++++++++++++++
 net/core/skbuff.c                   |  3 ++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 445e80517cab..968cbafa2421 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -270,6 +270,25 @@
  */
 #define __noreturn                      __attribute__((__noreturn__))
 
+/*
+ * Optional: not supported by clang.
+ * Optional: not supported by icc.
+ *
+ * Prevent function from being splited to multiple part. As what the
+ * document says in gcc/ipa-split.cc, single function will be splited
+ * when necessary:
+ *
+ *   https://github.com/gcc-mirror/gcc/blob/master/gcc/ipa-split.cc
+ *
+ * This optimization seems only take effect on O2 and O3 optimize level.
+ * Therefore, make the optimize level to O1 to prevent this optimization.
+ */
+#if __has_attribute(__optimize__)
+# define __nofnsplit			__attribute__((__optimize__("O1")))
+#else
+# define __nofnsplit
+#endif
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

