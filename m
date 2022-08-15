Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C5F592993
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 08:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiHOG1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 02:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiHOG1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 02:27:48 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F15E1A070;
        Sun, 14 Aug 2022 23:27:47 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 130so5693231pfy.6;
        Sun, 14 Aug 2022 23:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=8z9OmR/P+0PwN2paLh7tMPMVHLJ1jfO+/ke1w/8NdDE=;
        b=enMPW8VczhA6ttHVXxxZfCpaI4v2lKIjKJCOjfagLf+dEajtA8hTOvpvPsJeYYVicJ
         kIZtscPbBNIaPb1J9mQdCC8TXp01/G0p9GWzkXJRrzr5Oj5bm0Ftp2NSwFrne72/Hk2u
         9wyxNQCHdIDZwynUnUN28gqN20bnn2cYyRZTpGQkDwKJj79YqI/sPOLHpCyV9OmDbvh+
         jbDGJhFxsKmrLJqzzVd+Kci9LdVKZsz7PKPiTpuREAvMtEpCGdd5z4EtQBh+0XWE1OFJ
         YAJL4y3yaja/IzycvpfKuO3EyDheCA6Y3XR2yP38O+8EYebU4c5y5ylwQ6P/VuLbFLxh
         44xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=8z9OmR/P+0PwN2paLh7tMPMVHLJ1jfO+/ke1w/8NdDE=;
        b=AYS0Qe+2PN73WSc4+hw2vBpywFlwxBzCWfzV1tx2HUKEu5hXA8/sFM31WeB/bIlwJM
         SgcWUiK8VNPJAhinjS9AccF3746j6g7ianRbCR8C2F0JUeEZJBLiImpUyPhP9TkzsDim
         IAWzkO4lJJdZ5KFlschYRa4tLdEnPCdRee2/anAGvOBF0WAYnts4U9WzduwHhZig0aSc
         8XRO4tpBt0KujI77iJRPMf5sXnno5T7TOzmAYDxdLRrSvHbv41Zy31lxAmjX3rHs0iBl
         GK/HwcVNJ+W7WUu7JDez9gXsuiS/7pgquFN96iaaDeqc1k7NW6kY2sl464hxp9GgCdqa
         JHhA==
X-Gm-Message-State: ACgBeo1mB4aEu/QP+7tEkUSZHlEEvKi8k9kHd5+klw9FH89CO1VHZNT6
        +j1Vo6qVioL2zEGqu7/YLTZMf2nX7b4=
X-Google-Smtp-Source: AA6agR4x+qdgLq16MFs0HDoY02j6FL24Ei6hLsC9/c72kyRUmBUVn5DeHXa3F/ABZayP0CfwBpfTRA==
X-Received: by 2002:a62:5f06:0:b0:52e:f3a3:ffee with SMTP id t6-20020a625f06000000b0052ef3a3ffeemr15245319pfb.79.1660544866881;
        Sun, 14 Aug 2022 23:27:46 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id s65-20020a625e44000000b0052c87380aebsm5998023pfb.1.2022.08.14.23.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 23:27:46 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, miguel.ojeda.sandonis@gmail.com
Cc:     ojeda@kernel.org, ndesaulniers@google.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, asml.silence@gmail.com,
        imagedong@tencent.com, luiz.von.dentz@intel.com,
        vasily.averin@linux.dev, jk@codeconstruct.com.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v3] net: skb: prevent the split of kfree_skb_reason() by gcc
Date:   Mon, 15 Aug 2022 14:27:27 +0800
Message-Id: <20220815062727.1203589-1-imagedong@tencent.com>
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
v3:
- define __nofnsplit only for GCC
- add some document

v2:
- replace 'optimize' with '__optimize__' in __nofnsplit, as Miguel Ojeda
  advised.
---
 include/linux/compiler-gcc.h   | 12 ++++++++++++
 include/linux/compiler_types.h |  4 ++++
 net/core/skbuff.c              |  3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index a0c55eeaeaf1..8d6d4d7b21a4 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -157,3 +157,15 @@
 #if GCC_VERSION < 90100
 #undef __alloc_size__
 #endif
+
+/*
+ * Prevent function from being splited to multiple part. As what the
+ * document says in gcc/ipa-split.cc, single function will be splited
+ * when necessary:
+ *
+ *   https://github.com/gcc-mirror/gcc/blob/master/gcc/ipa-split.cc
+ *
+ * This optimization seems only take effect on O2 and O3 optimize level.
+ * Therefore, make the optimize level to O1 to prevent this optimization.
+ */
+#define __nofnsplit		__attribute__((__optimize__("O1")))
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 4f2a819fd60a..e76cfff36491 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -380,4 +380,8 @@ struct ftrace_likely_data {
 #define __diag_ignore_all(option, comment)
 #endif
 
+#ifndef __nofnsplit
+#define __nofnsplit
+#endif
+
 #endif /* __LINUX_COMPILER_TYPES_H */
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

