Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D218362D42
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbhDQDeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbhDQDdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0D3C06175F;
        Fri, 16 Apr 2021 20:32:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so7222320pjb.1;
        Fri, 16 Apr 2021 20:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nwc5XWdKz5jG+SAGsD0OMALB7sp2qsIR5lQRCTO9YJs=;
        b=kAOlO7PVg9v6Caj1r+JRsV/QD7BZ5r9x/IwzfavUUhIQvd8Dy49v6Q45xA7A2TF7G6
         UCXiIoMq+ZyGJYOQ/poqkGQE/mA0WSytsgUVTCCIF1VfiOSV7c/MeuyF7uFt3BxH/MjU
         1+a0VJ+Sq8JtmgBhFA2gIQdzHXkYTYC645P9kqIKIc+6z/h63GjUp58DRchtIpWw/6Gp
         /zU5aIiFdOBCfoARUQaYZR65BwD4Wnl1129XyMf9uscuwBbcio5tY72d0Hs/nCWRuIo2
         xGmW0D4R+nggzttcCq3QkLPBSCoyy00awRlXyJBxmeF/eD+BjsgwtrFzDOXtwBCH2Oc+
         FfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Nwc5XWdKz5jG+SAGsD0OMALB7sp2qsIR5lQRCTO9YJs=;
        b=rJHqZ0/wQ0y5zCMQYoa0QjMY1VZJBP7pymbWycu6FlWCuCphSx94dzX8Ac7uKbFU/n
         3BsXOxLD813SplcRoFkY5urG3zrcYNZssHrLrFQPEaZ0747atBMrPULYveTGLjoo/i2H
         gIABkhhkfiH10Jin4qjnDvVKTfFWtacxzrRRojcjqkOtYdkMjIZrGnDehIhpTZ8IUa1u
         +9ANKjntDarphI4cFj3OJt2oOcqTPmr3rX8QoZFX3LDfHRyVNpPiuFv9W2vxrW+lLEKX
         XrHfk+FjRfUa1wratQtFydoG3DwPIlo288dXavrGQlfUxNE4uEjnG9AZeYGEu4nmlYUR
         NtlA==
X-Gm-Message-State: AOAM5336SqlKGSaGAnqNHEXeE6ttC2DBohmaAZmI9snWpgFnZebY1kiC
        hKni8Vk2T7IkHFSeETEyeyw=
X-Google-Smtp-Source: ABdhPJxw9XEJ3Y0cdUhr0RLaYlMestsrY0EA+0p79H5k1pth1+IJqC11tDVc/XBHBfiBwmSjD/l5wQ==
X-Received: by 2002:a17:90a:730c:: with SMTP id m12mr12832209pjk.111.1618630349691;
        Fri, 16 Apr 2021 20:32:29 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:29 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 02/15] bpf: Introduce bpfptr_t user/kernel pointer.
Date:   Fri, 16 Apr 2021 20:32:11 -0700
Message-Id: <20210417033224.8063-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
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

