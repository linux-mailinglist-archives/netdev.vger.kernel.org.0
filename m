Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221DD3689C2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhDWA1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239954AbhDWA12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:28 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3A6C06174A;
        Thu, 22 Apr 2021 17:26:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c3so14132388pfo.3;
        Thu, 22 Apr 2021 17:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nwc5XWdKz5jG+SAGsD0OMALB7sp2qsIR5lQRCTO9YJs=;
        b=isAwycRgk+Hy469zW1dv20mU0O3rTcHdpRuI3A2ey0B3iCk+Dy854CwXV4X3BEfciz
         +0Q8Af3Cl1O3mPyKGgOTMHKOZKZF8PeeupocoqhBO6hDXleVaZmB9B6KLUj7LZV/IcjQ
         Yu8tCcpUrDima0R16bWJfNu51bLm2vLlXwVhVqF2mPKxcLqeSZB02d7/RUDH/c98Jx9Z
         yEyjG86GG2mCrX9xW0zywq3tkdHY+hRMbCdtXizYp6mXv/96APJFOM7EnQWg4a2tWzX0
         Wf3mLm5ITs5iZw1+mzHO6xKfZMXXUEOec3c5YUOGlwpyGFaAbz1ItjqvKl0y/jNuBuR3
         5CUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Nwc5XWdKz5jG+SAGsD0OMALB7sp2qsIR5lQRCTO9YJs=;
        b=DJUjvgIx/gtELAOzbtMaGGlg6SLfE0VLdGuHp9qVKD89iP2MJji2upzialkvzkCKgc
         E33SxgENB9W3McD9yCqcB5REuog+XhLvcuSTh+o/I0CYAslHM13BiKY/0refdQ0NWucf
         txXZauAcu91ElKEyEs15KCG6B6gZUVjDmAloWCUq75TUQ3cYT5z2ZpzxuzR1+q8ZMBYs
         FiZyZbVdawvwZ5CmPSz7WSrz7AD0sDzZiaBZDcpKY0qPR/gC6ay10WxV2wuXPNm/6zgq
         FULdndnbZ+j9p9xo2Lv49+kK1tvKltgEIVaroAe/wTwamln4PtWAM2MMkgyD91hZ15vz
         Blgw==
X-Gm-Message-State: AOAM533i5Qlc3gBEa4QJ05JShlvIg2sFqZHDyYFF8SmUQbEiShyyttGb
        KMGSvq0VQtNrAOJeYql9AsM=
X-Google-Smtp-Source: ABdhPJwnOfbih1xX+yZbZKN7CS/v6L+GtZJ7Ix2jgLtcCLK+zlx49KFOfzfBUMz34//AmhJSF3svYQ==
X-Received: by 2002:a63:6ec5:: with SMTP id j188mr1209278pgc.394.1619137611424;
        Thu, 22 Apr 2021 17:26:51 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:50 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 02/16] bpf: Introduce bpfptr_t user/kernel pointer.
Date:   Thu, 22 Apr 2021 17:26:32 -0700
Message-Id: <20210423002646.35043-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Similar to sockptr_t introduce bpfptr_t with few additions:
make_bpfptr() creates new user/kernel pointer in the same address space as
existing user/kernel pointer.
bpfptr_add() advances the user/kernel pointer.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpfptr.h | 81 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 include/linux/bpfptr.h

diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
new file mode 100644
index 000000000000..e370acb04977
--- /dev/null
+++ b/include/linux/bpfptr.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* A pointer that can point to either kernel or userspace memory. */
+#ifndef _LINUX_BPFPTR_H
+#define _LINUX_BPFPTR_H
+
+#include <linux/sockptr.h>
+
+typedef sockptr_t bpfptr_t;
+
+static inline bool bpfptr_is_kernel(bpfptr_t bpfptr)
+{
+	return bpfptr.is_kernel;
+}
+
+static inline bpfptr_t KERNEL_BPFPTR(void *p)
+{
+	return (bpfptr_t) { .kernel = p, .is_kernel = true };
+}
+
+static inline bpfptr_t USER_BPFPTR(void __user *p)
+{
+	return (bpfptr_t) { .user = p };
+}
+
+static inline bpfptr_t make_bpfptr(u64 addr, bool is_kernel)
+{
+	if (is_kernel)
+		return (bpfptr_t) {
+			.kernel = (void*) (uintptr_t) addr,
+			.is_kernel = true,
+		};
+	else
+		return (bpfptr_t) {
+			.user = u64_to_user_ptr(addr),
+			.is_kernel = false,
+		};
+}
+
+static inline bool bpfptr_is_null(bpfptr_t bpfptr)
+{
+	if (bpfptr_is_kernel(bpfptr))
+		return !bpfptr.kernel;
+	return !bpfptr.user;
+}
+
+static inline void bpfptr_add(bpfptr_t *bpfptr, size_t val)
+{
+	if (bpfptr_is_kernel(*bpfptr))
+		bpfptr->kernel += val;
+	else
+		bpfptr->user += val;
+}
+
+static inline int copy_from_bpfptr_offset(void *dst, bpfptr_t src,
+					  size_t offset, size_t size)
+{
+	return copy_from_sockptr_offset(dst, (sockptr_t) src, offset, size);
+}
+
+static inline int copy_from_bpfptr(void *dst, bpfptr_t src, size_t size)
+{
+	return copy_from_bpfptr_offset(dst, src, 0, size);
+}
+
+static inline int copy_to_bpfptr_offset(bpfptr_t dst, size_t offset,
+					const void *src, size_t size)
+{
+	return copy_to_sockptr_offset((sockptr_t) dst, offset, src, size);
+}
+
+static inline void *memdup_bpfptr(bpfptr_t src, size_t len)
+{
+	return memdup_sockptr((sockptr_t) src, len);
+}
+
+static inline long strncpy_from_bpfptr(char *dst, bpfptr_t src, size_t count)
+{
+	return strncpy_from_sockptr(dst, (sockptr_t) src, count);
+}
+
+#endif /* _LINUX_BPFPTR_H */
-- 
2.30.2

