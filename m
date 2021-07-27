Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E483D8122
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhG0VQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbhG0VQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:16:51 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77368C061799
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:51 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c16so45541plh.7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4Fdwl9HiFMZ+llOdhUBfZSYAz9VTvRZ/zqP2rqnbdI=;
        b=OubzHKZ8rQkxISQj3tvDfVhvRaRW388it7d5HkY7TCu/bBaa8Pr8HfYZFrPrOiunFF
         6bCQMEiL+lVzAM6jCwQcLzTiImmq8ntJYj7aynk5kXTfEehuycCEDZIeJcO5eJpfZQKn
         hq2FyEBWz+GBZM7N+a3OD/2asYrrsHtNzmSN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4Fdwl9HiFMZ+llOdhUBfZSYAz9VTvRZ/zqP2rqnbdI=;
        b=p2XUlRhHlSe3+N/HxX/iyrHYMK+m81nJ37OCDgIWS1TgHcDBOUoqmAv1qHVREaLzR8
         ZFYDT5IJwcp9Xf+74gurUnbCbH3CG2u3itFDtRqYl8pNvb+LEwLrbTBkbYdrkiXaj1W/
         2jMXecwQkkFpjQIuJ2UsziB6NKgX82fbu5u93mft9l2EtkXLU1yo2ccr5bzoRVqzXcZB
         R14jS+YJpAx84z4cSsYYFL8vVwNTYq//gXyAkB/mi+qWUiyO5OV2Vd/B3jANOGH4APAX
         F9SQU5uUG3cpt5teZyLXLl3jqtO+HdQiRdLVgWnLnkpv3YK81Sp5GSxaDA8c9Xp4l4Ok
         dfVQ==
X-Gm-Message-State: AOAM530yuv7T7YoJqFzPwD6xkg2VnC2tWChxOa+0cWe/ATnrfW+XvkXo
        YyggDSHxtthgXd7NSNfRBvzCUg==
X-Google-Smtp-Source: ABdhPJzBdsmV+2iswoqD8g+SAJNwVreAx8UwnGfV68SrU1eBmBrhzMiv9tA9zD/XN/ReoAPLtd1HsQ==
X-Received: by 2002:aa7:9a07:0:b029:329:46d2:c6e4 with SMTP id w7-20020aa79a070000b029032946d2c6e4mr25255299pfj.81.1627420610912;
        Tue, 27 Jul 2021 14:16:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m11sm1742495pgn.56.2021.07.27.14.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:16:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 37/64] string.h: Introduce memset_after() for wiping trailing members/padding
Date:   Tue, 27 Jul 2021 13:58:28 -0700
Message-Id: <20210727205855.411487-38-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2359; h=from:subject; bh=b9cZC+rDD66z1p4TxzACgUY06GpnBkPGzRd2vUJnnzo=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOIfqyzMaVVJ7fOFmkjuM928F3ZrP6Vj5vJQu9j TGA+E1GJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBziAAKCRCJcvTf3G3AJvL4D/ 432CWZcCqOkVhZ6rWzVtqmSaSBdcUlSVZvNTubv+qk3MAjGXh0WePvQ/w470x2ODfGCERhFWEDFlQj 68DffRJeemD9mQNtxja/G+yKlfKQtqj2GsW7tkAYMYGdzk44ucXmoA6jnRW6vcayOBno0Ak7JtF4lG m7CwO3b7xHmECqmbPERBBHV/EFy/4S7JgLqoPni03PW1KgZDyCWqbwmB04HSW1ssZRyLMd4s3QMY1T +9uiq7oHu8jR42VT7YaiZc18izUh7AQddCZBlvqcHK6sPbsh+klX5zZS9n02ODAklfDkBGB2gb1tzk qTxXC88avclTCkPd2GBEUQEctsttYoNcK4xZ3zRj+wlfk6n2j/Aj/ysxug7cILnKKFV1GD6Yf8nsLg 2k2xEUpWUhhQ6fcZqBd7cBs5gIDYK2zreDrTKcqVFSQ0lX6w9ZyGULXQjv3ILYDHDHvd1PewBgByhA 8aurJtfihL4zDAjHyVugkZ+nfaAmQVaovogYrWCCXoxbMKSIxExx4nWszpvOPpR1mX+l7gYP24rMp1 l768YtsiX/jU5xOMRn5iJGLFogebnye0HYfk45A60bKdiGZmynlnz5gGZL9zYD/aSJOhSfF3kz5hcE XG0Q1qnKtvYm975U6RI0dZPUWK34kAgIzA9fINgzTL6Q+FxQr5sF43MKxRyQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A common idiom in kernel code is to wipe the contents of a structure
after a given member. This includes places where there is trailing
struct padding. These open-coded cases are usually difficult to read and
very sensitive to struct layout changes. Introduce a new helper,
memset_after() that takes the target struct instance, the byte to
write, and the member name after which the zeroing should start.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/string.h | 12 ++++++++++++
 lib/test_memcpy.c      | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index cbe889e404e2..4f9f67505f70 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -272,6 +272,18 @@ static __always_inline void memcpy_and_pad(void *dest, size_t dest_len,
 		memcpy(dest, src, dest_len);
 }
 
+/**
+ * memset_after - Set a value after a struct member to the end of a struct
+ *
+ * @obj: Address of target struct instance
+ * @v: Byte value to repeatedly write
+ * @member: after which struct member to start writing bytes
+ */
+#define memset_after(obj, v, member) do {				\
+	memset((u8 *)(obj) + offsetofend(typeof(*(obj)), member), v,	\
+	       sizeof(*(obj)) - offsetofend(typeof(*(obj)), member));	\
+} while (0)
+
 /**
  * str_has_prefix - Test if a string has a given prefix
  * @str: The string to test
diff --git a/lib/test_memcpy.c b/lib/test_memcpy.c
index 7c64120a68a9..f52b284f4410 100644
--- a/lib/test_memcpy.c
+++ b/lib/test_memcpy.c
@@ -223,6 +223,13 @@ static int __init test_memset(void)
 			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
 			},
 	};
+	struct some_bytes after = {
+		.data = { 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x72,
+			  0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,
+			  0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,
+			  0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,
+			},
+	};
 	struct some_bytes dest = { };
 	int count, value;
 	u8 *ptr;
@@ -254,6 +261,11 @@ static int __init test_memset(void)
 	memset(ptr++, value++, count++);
 	compare("argument side-effects", dest, three);
 
+	/* Verify memset_after() */
+	dest = control;
+	memset_after(&dest, 0x72, three);
+	compare("memset_after()", dest, after);
+
 	return 0;
 #undef TEST_OP
 }
-- 
2.30.2

