Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E883D7FC7
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhG0U7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbhG0U7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:05 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF6BC06179E
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:03 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e14so17701433plh.8
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9/SLyzkm5b4YgLSzID8XtRK8GIPppWgZQKzDtYl0cY=;
        b=Q6r3JVenAALSlwAfyXn9c9rdA4TUAUv+3EIc2wTPETOe8m8gbk9+wqvXOiPL1oUvnH
         ghkLdmrKLyR4I8vbN9OzUB9eFxc3TXAFvoPqhq1nLVTJTeUO4JgZrxR7Jn6GTmnnQyus
         6EOqFEJs4cs2fjjy5HiOhsgCbIpL8hnk9RHbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9/SLyzkm5b4YgLSzID8XtRK8GIPppWgZQKzDtYl0cY=;
        b=hghOdXIrIP0iewZfr3cICiuuhiIp/pqWNaO20bXpGTl42lpy/2O9VzeGSPTvdjHfYa
         KkeQ715CgAFd4VXhnqZv3dnfR0nLAdPiK2RwRp9jRtLQGEpHIA7mCeYDXJRoEnR60TO2
         oxI6hnwDoMiTPV4vTe65ClCs4/jDgb72qmV+qguuDibOzJH4Kgo+phkdSMwUBxj2oAyd
         EUHTMiAYDI5JESIOuN+dN6uN0OhwecwWcrusPbzz9hsmfVaiK8HFCU5qEp2WliGgBOMd
         uv2koX4h9HNstFFzq+CHKdKT9VWVo87YB79Ww6Ollble4KU+tDN7y6oijqZT+1ITnCkp
         h2rg==
X-Gm-Message-State: AOAM531FGpb0PsflVjWcKnROt79qcq48KZqk6qVzk6DlA2bZ6epJloyu
        JyKYYIqLMX7j85roz1KtM0B7ag==
X-Google-Smtp-Source: ABdhPJyHLrx2rOyZ+72UCSjITxuxc5Fx4+n8MmagGGchue3NLbPGkODQaUC1y1IyFCIXLG8+7pEjjg==
X-Received: by 2002:a17:90a:aa92:: with SMTP id l18mr6315143pjq.20.1627419543327;
        Tue, 27 Jul 2021 13:59:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r10sm4606873pff.7.2021.07.27.13.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Keith Packard <keithpac@amazon.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 04/64] stddef: Introduce struct_group() helper macro
Date:   Tue, 27 Jul 2021 13:57:55 -0700
Message-Id: <20210727205855.411487-5-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6059; h=from:subject; bh=3LEAbTxg4aXTCBqMfEtpBsDoqguT4nwPgyzTbu35rzM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOB6fBnqoQEU0SOfpxJjjk2PGndGpdft7092EvT pn5C4GCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzgQAKCRCJcvTf3G3AJjaKD/ 9Hy5ufgc4XqQ2z3z9FPvEU6kxJGQmWPS7Xcj/+0+Tt0ThcqyqNxB3pfnhNZY5oFVzFQAasxaE+uUMy w8l50dffII86GVzwgMHpVSOHfyKxD0+bVjHS1hMO0YxtoyYtE05wk1gZb0O3VCFvNI8kbknhLy9Uck SYOfNHqSctMehBN0ekYquyX+Sxta/bDS1L6zhOi7GKz1zqmata8K3Ru/ejXddx/tfY4Od9cnavr31N xw2Thp2oXNUsvJOPNbEvrB9M+WNLj3Jkh79uKUxA2pScrBaJuJyDc0eb75fwJObkRIzkHNc5UF68RQ 3sm3i/QfPCS0rVeZ3hKhcTFLjC3MZufvXgQPFR7BfYuYWBJojZhnwQdeoicgqEYtr8XHy8GgHXRxFT pHAAkO2PCn68C5FfPyf8+UKcLaAMIm3YG+MYg5c8HZrCT92UTJKR8kNFF5UhnMDqJdNE0LLWwmqQjD pee4CTHVdCAU/kDqXg2TD7dmrqC2bgT4icDvzkqIMtb10+q6UqF4VahbBVQrDLI3Y8Zcj+H+cdlb2F 0D5duiiZ6PW+dqS/zKFRLxwzmSl45QsWX4lUz1Wqs23RyLSPhcYSYz1PQjMeqiAlmp/hRAs8uiSw0q nFEKGgK/WMDmBCTVW0TdgnP5Vt5h5HAjsZEr+BMIwSeSu+7fa8Z0zUCwBT+w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel code has a regular need to describe groups of members within a
structure usually when they need to be copied or initialized separately
from the rest of the surrounding structure. The generally accepted design
pattern in C is to use a named sub-struct:

	struct foo {
		int one;
		struct {
			int two;
			int three;
		} thing;
		int four;
	};

This would allow for traditional references and sizing:

	memcpy(&dst.thing, &src.thing, sizeof(dst.thing));

However, doing this would mean that referencing struct members enclosed
by such named structs would always require including the sub-struct name
in identifiers:

	do_something(dst.thing.three);

This has tended to be quite inflexible, especially when such groupings
need to be added to established code which causes huge naming churn.
Three workarounds exist in the kernel for this problem, and each have
other negative properties.

To avoid the naming churn, there is a design pattern of adding macro
aliases for the named struct:

	#define f_three thing.three

This ends up polluting the global namespace, and makes it difficult to
search for identifiers.

Another common work-around in kernel code avoids the pollution by avoiding
the named struct entirely, instead identifying the group's boundaries using
either a pair of empty anonymous structs of a pair of zero-element arrays:

	struct foo {
		int one;
		struct { } start;
		int two;
		int three;
		struct { } finish;
		int four;
	};

	struct foo {
		int one;
		int start[0];
		int two;
		int three;
		int finish[0];
		int four;
	};

This allows code to avoid needing to use a sub-struct name for member
references within the surrounding structure, but loses the benefits of
being able to actually use such a struct, making it rather fragile. Using
these requires open-coded calculation of sizes and offsets. The efforts
made to avoid common mistakes include lots of comments, or adding various
BUILD_BUG_ON()s. Such code is left with no way for the compiler to reason
about the boundaries (e.g. the "start" object looks like it's 0 bytes
in length and is not structurally associated with "finish"), making bounds
checking depend on open-coded calculations:

	if (length > offsetof(struct foo, finish) -
		     offsetof(struct foo, start))
		return -EINVAL;
	memcpy(&dst.start, &src.start, length);

However, the vast majority of places in the kernel that operate on
groups of members do so without any identification of the grouping,
relying either on comments or implicit knowledge of the struct contents,
which is even harder for the compiler to reason about, and results in
even more fragile manual sizing, usually depending on member locations
outside of the region (e.g. to copy "two" and "three", use the start of
"four" to find the size):

	BUILD_BUG_ON((offsetof(struct foo, four) <
		      offsetof(struct foo, two)) ||
		     (offsetof(struct foo, four) <
		      offsetof(struct foo, three));
	if (length > offsetof(struct foo, four) -
		     offsetof(struct foo, two))
		return -EINVAL;
	memcpy(&dst.two, &src.two, length);

And both of the prior two idioms additionally appear to write beyond the
end of the referenced struct member, forcing the compiler to ignore any
attempt to perform bounds checking.

In order to have a regular programmatic way to describe a struct
region that can be used for references and sizing, can be examined for
bounds checking, avoids forcing the use of intermediate identifiers,
and avoids polluting the global namespace, introduce the struct_group()
macro. This macro wraps the member declarations to create an anonymous
union of an anonymous struct (no intermediate name) and a named struct
(for references and sizing):

	struct foo {
		int one;
		struct_group(thing,
			int two,
			int three,
		);
		int four;
	};

	if (length > sizeof(src.thing))
		return -EINVAL;
	memcpy(&dst.thing, &src.thing, length);
	do_something(dst.three);

There are some rare cases where the resulting struct_group() needs
attributes added, so struct_group_attr() is also introduced to allow
for specifying struct attributes (e.g. __align(x) or __packed).

Co-developed-by: Keith Packard <keithpac@amazon.com>
Signed-off-by: Keith Packard <keithpac@amazon.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/stddef.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 998a4ba28eba..cf7f866944f9 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -36,4 +36,38 @@ enum {
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
 
+/**
+ * struct_group_attr(NAME, ATTRS, MEMBERS)
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members. Includes structure attributes argument.
+ *
+ * @NAME: The name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes (normally empty)
+ * @MEMBERS: The member declarations for the mirrored structs
+ */
+#define struct_group_attr(NAME, ATTRS, MEMBERS) \
+	union { \
+		struct { MEMBERS } ATTRS; \
+		struct { MEMBERS } ATTRS NAME; \
+	}
+
+/**
+ * struct_group(NAME, MEMBERS)
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members.
+ *
+ * @NAME: The name of the mirrored sub-struct
+ * @MEMBERS: The member declarations for the mirrored structs
+ */
+#define struct_group(NAME, MEMBERS)	\
+	struct_group_attr(NAME, /* no attrs */, MEMBERS)
+
 #endif
-- 
2.30.2

