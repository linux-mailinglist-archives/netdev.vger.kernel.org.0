Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63B43B0DE9
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhFVT7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbhFVT73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:59:29 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2628C061756;
        Tue, 22 Jun 2021 12:57:12 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id a2so671703pgi.6;
        Tue, 22 Jun 2021 12:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jivxYGcJYbE7eSkXipGR1sWBMuZY0V3FzEQSe7d96iA=;
        b=A75ck4VPX7rTv9NjGMspsJ0S593UQnVRZ4sKsdQXfjYPLIeNS8593s8IM47v4zaTh0
         0YMRqfYrc5+lZpasb2BPdeKSMzhtB4zBt/88hdtI30wu+q4BXqQIxLQLJpwWqxI042JS
         R2Fc3x/x1SwQdCkLlTLa2HRWToG/aVxevPgEcgchwIC2XKoKK+tVxKopWQ8IcH+JVlWq
         WWEBy3AOIwL4eqjcJnB4jyfrZvHKO5n4Lucs3qEPQ0o1sJI0qu6HWc6jbce4diJou6ca
         wFlCKquq0qZOawAlYuUpM3EYic5jwzWGpcFztZjD6pJd533pUVcaoMa659yW73tHrHnE
         PTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jivxYGcJYbE7eSkXipGR1sWBMuZY0V3FzEQSe7d96iA=;
        b=Q4uHpmmQz1AlZuzOdxRRUTQMSvlpf35FFn9xm4ICt9mErzBlF1HQpzlw8ORo38baCi
         Xom3MES1f6YUPH3VItaM2N0F0sWREjOpI72pVVEhI5VpC1CSxtNSVS3rRqNOkFsOt7/c
         D+dRa/kZsd3YT1wYb2sD6ed7GispZBlB+jpDeLvrNLABamY7q4hyV2JzlL83XKd5c6jg
         lfdCtxl1MGTmxXu25miI0MCNzSV2+ozYou+8gi7A6IBnasMkF94T8ki+CjeDMF2i8olL
         lDDGFnGR3RSf7Nk4HcbiWCLddjf7oj/DS97O4g33ElcI+9+1OD3gLA7ylXQUJ4YyXfmp
         vq/A==
X-Gm-Message-State: AOAM532r+ijpjSV+UIQaXw2ljJr5yyrgIuYkspgs0wGGhHfCw7JrOKCc
        G9Uo9pv5H/uTzZjpbfDpIADpUnvh+Y0=
X-Google-Smtp-Source: ABdhPJy5j9g+S5puLLOhpPjSWLlolaeh0UWmsPV2Gyc5MLLREOEK9tyNHsO4/63m1pYaPyYVeJK97A==
X-Received: by 2002:a63:1460:: with SMTP id 32mr304427pgu.163.1624391832073;
        Tue, 22 Jun 2021 12:57:12 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id t14sm158820pfe.45.2021.06.22.12.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:57:11 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v2 2/5] bitops: add non-atomic bitops for pointers
Date:   Wed, 23 Jun 2021 01:25:24 +0530
Message-Id: <20210622195527.1110497-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622195527.1110497-1-memxor@gmail.com>
References: <20210622195527.1110497-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpumap needs to set, clear, and test the lowest bit in skb pointer in
various places. To make these checks less noisy, add pointer friendly
bitop macros that also do some typechecking to sanitize the argument.

These wrap the non-atomic bitops __set_bit, __clear_bit, and test_bit
but for pointer arguments. Pointer's address has to be passed in and it
is treated as an unsigned long *, since width and representation of
pointer and unsigned long match on targets Linux supports. They are
prefixed with double underscore to indicate lack of atomicity.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bitops.h    | 19 +++++++++++++++++++
 include/linux/typecheck.h | 10 ++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 26bf15e6cd35..a9e336b9fa4d 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -4,6 +4,7 @@
 
 #include <asm/types.h>
 #include <linux/bits.h>
+#include <linux/typecheck.h>
 
 #include <uapi/linux/kernel.h>
 
@@ -253,6 +254,24 @@ static __always_inline void __assign_bit(long nr, volatile unsigned long *addr,
 		__clear_bit(nr, addr);
 }
 
+#define __ptr_set_bit(nr, addr)                         \
+	({                                              \
+		typecheck_pointer(*(addr));             \
+		__set_bit(nr, (unsigned long *)(addr)); \
+	})
+
+#define __ptr_clear_bit(nr, addr)                         \
+	({                                                \
+		typecheck_pointer(*(addr));               \
+		__clear_bit(nr, (unsigned long *)(addr)); \
+	})
+
+#define __ptr_test_bit(nr, addr)                       \
+	({                                             \
+		typecheck_pointer(*(addr));            \
+		test_bit(nr, (unsigned long *)(addr)); \
+	})
+
 #ifdef __KERNEL__
 
 #ifndef set_mask_bits
diff --git a/include/linux/typecheck.h b/include/linux/typecheck.h
index 20d310331eb5..33c78f27147a 100644
--- a/include/linux/typecheck.h
+++ b/include/linux/typecheck.h
@@ -22,4 +22,14 @@
 	(void)__tmp; \
 })
 
+/*
+ * Check at compile that something is a pointer type.
+ * Always evaluates to 1 so you may use it easily in comparisons.
+ */
+#define typecheck_pointer(x) \
+({	typeof(x) __dummy; \
+	(void)sizeof(*__dummy); \
+	1; \
+})
+
 #endif		/* TYPECHECK_H_INCLUDED */
-- 
2.31.1

