Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA49202012
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbgFTDOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732360AbgFTDOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:14:37 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17564C0613EE
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:14:36 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id y25so8589617qtb.6
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zl+PzJjccgQ/z2IEdEeYMiws9NGR4cJmTEy3MFLmC3o=;
        b=IVa4+NlsGbh2tuCONpmMignMX3tymio3t6JWrNzc5iXWlb7vOmjhAzN6NlhnjFhlfR
         SLJ2gRLA6EgVpy6YonZqFX54AkwoQvKBOlkFwCsmWTooE2Q423aBY278CNa0BX7Yzzi5
         lTmaofUZR7JB+xlA674HFVZ73jz5U7+ADJceLARAnFz+bA6LH/zrWy5QWqoeEotTqvOF
         UmYtSmZeHun0CDabkfnTMDnFWZTfWR7TUYD5al6woWbY0Ul7IMyeEFTFpl6EedRllncg
         SdzScVXpPGEAjKrWBCofUBL7hAbyMc2DncnGuAHznS6G6/EVpgXDGIDc1Q78yWZ0I/xm
         5QTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zl+PzJjccgQ/z2IEdEeYMiws9NGR4cJmTEy3MFLmC3o=;
        b=bmQqmUkOJANLoiojtjmvI5yKNgPWA9yuXdM8863LM5j4q5WJ8280lkAKtHRETeiUZr
         RzyjlPNg6EZ9yNf3N7hyz9V/nBIPBSSmPZ0RsPTkshTlmsYmZqXqaR0kWlOk7RoP9O5z
         sx5ZmaJ043ysWkEN19kA9ixoyX8VUL8acoUb7Na7JInvEsRuGk8M5OKUBRkXtW+5Oite
         pv3jIJusGudP0cvn/vTVH6uCPKJ5jhUfWguuTcQuuEnLlBXYM4698W2XtcsOWPWfJ6wl
         hO4faVVxQrtuX3ivkRJHrqg5c6Jf3pxOoOdNjrEb6JCZZaoMroXzxdgr91KOzHrAs+cS
         tkCg==
X-Gm-Message-State: AOAM533bRqRw0O4q0s4xH2iKb9iUF/oVs09QJtZUzWNLHIx+CQVDFdnE
        eqoL/VxhzpqPnci3Gu4S2Unfn063tIuy
X-Google-Smtp-Source: ABdhPJx7Zb5WZN9Kyj9M9t0YipMDGf9555Hb9vWxW3rsrq8ChDSsTnnDsP2VsrGgbZFEcrS6B5seAkyx5hxN
X-Received: by 2002:a05:6214:11b3:: with SMTP id u19mr11113254qvv.99.1592622875130;
 Fri, 19 Jun 2020 20:14:35 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:14:18 -0700
Message-Id: <20200620031419.219106-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 1/2] indirect_call_wrapper: extend indirect wrapper
 to support up to 4 calls
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many places where 2 annotations are not enough. This patch
adds INDIRECT_CALL_3 and INDIRECT_CALL_4 to cover such cases.

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/linux/indirect_call_wrapper.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
index 00d7e8e919c6..54c02c84906a 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -23,6 +23,16 @@
 		likely(f == f2) ? f2(__VA_ARGS__) :			\
 				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	\
 	})
+#define INDIRECT_CALL_3(f, f3, f2, f1, ...)					\
+	({									\
+		likely(f == f3) ? f3(__VA_ARGS__) :				\
+				  INDIRECT_CALL_2(f, f2, f1, __VA_ARGS__);	\
+	})
+#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...)					\
+	({									\
+		likely(f == f4) ? f4(__VA_ARGS__) :				\
+				  INDIRECT_CALL_3(f, f3, f2, f1, __VA_ARGS__);	\
+	})
 
 #define INDIRECT_CALLABLE_DECLARE(f)	f
 #define INDIRECT_CALLABLE_SCOPE
@@ -30,6 +40,8 @@
 #else
 #define INDIRECT_CALL_1(f, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALL_2(f, f2, f1, ...) f(__VA_ARGS__)
+#define INDIRECT_CALL_3(f, f3, f2, f1, ...) f(__VA_ARGS__)
+#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALLABLE_DECLARE(f)
 #define INDIRECT_CALLABLE_SCOPE		static
 #endif
-- 
2.27.0.111.gc72c7da667-goog

