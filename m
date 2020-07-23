Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEDF22A876
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgGWGNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgGWGJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CABC0619DC;
        Wed, 22 Jul 2020 23:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=4ol6++ZHLzLW7TDwHlZddqUginEv5bBRSa0jVjvGkxw=; b=LQ4n46+A9hpfp8zwc4fmkS7cJo
        d5IqR7Kl4e0TO036FT8xWuGybCPl2s2InAIro23/53LCinHbTKiq/Tnub5/sgbeB8OvtVn2Fb8T3x
        cy//cs6JjumkNHaZgsjWuneXbSE3bV91ZNenOTCXKvvKVo3iMbNIfcuHEHy0jL/1haCANgajZtHlM
        OmyzXP8bHeIwV24m5r6zEtVXEFNxvWUQym3x+LwR2wkRgHMMnIbpuUfNlwS4BNr+jYwxsADZ+QZcp
        nqi2JyfZ3TNmf2p6KSTQP4wHWgQxfvy5ytYsalHed/VoVuESlHAkZj1jRhA4Bsr7iHZTdGZ+FlzSQ
        Hvfa7s1g==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUPq-0003k4-Pf; Thu, 23 Jul 2020 06:09:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 04/26] net: add a new sockptr_t type
Date:   Thu, 23 Jul 2020 08:08:46 +0200
Message-Id: <20200723060908.50081-5-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a uptr_t type that can hold a pointer to either a user or kernel
memory region, and simply helpers to copy to and from it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/sockptr.h | 104 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 include/linux/sockptr.h

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
new file mode 100644
index 00000000000000..700856e13ea0c4
--- /dev/null
+++ b/include/linux/sockptr.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2020 Christoph Hellwig.
+ *
+ * Support for "universal" pointers that can point to either kernel or userspace
+ * memory.
+ */
+#ifndef _LINUX_SOCKPTR_H
+#define _LINUX_SOCKPTR_H
+
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+typedef struct {
+	union {
+		void		*kernel;
+		void __user	*user;
+	};
+	bool		is_kernel : 1;
+} sockptr_t;
+
+static inline bool sockptr_is_kernel(sockptr_t sockptr)
+{
+	return sockptr.is_kernel;
+}
+
+static inline sockptr_t KERNEL_SOCKPTR(void *p)
+{
+	return (sockptr_t) { .kernel = p, .is_kernel = true };
+}
+
+static inline sockptr_t USER_SOCKPTR(void __user *p)
+{
+	return (sockptr_t) { .user = p };
+}
+
+static inline bool sockptr_is_null(sockptr_t sockptr)
+{
+	return !sockptr.user && !sockptr.kernel;
+}
+
+static inline int copy_from_sockptr(void *dst, sockptr_t src, size_t size)
+{
+	if (!sockptr_is_kernel(src))
+		return copy_from_user(dst, src.user, size);
+	memcpy(dst, src.kernel, size);
+	return 0;
+}
+
+static inline int copy_to_sockptr(sockptr_t dst, const void *src, size_t size)
+{
+	if (!sockptr_is_kernel(dst))
+		return copy_to_user(dst.user, src, size);
+	memcpy(dst.kernel, src, size);
+	return 0;
+}
+
+static inline void *memdup_sockptr(sockptr_t src, size_t len)
+{
+	void *p = kmalloc_track_caller(len, GFP_USER | __GFP_NOWARN);
+
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+	if (copy_from_sockptr(p, src, len)) {
+		kfree(p);
+		return ERR_PTR(-EFAULT);
+	}
+	return p;
+}
+
+static inline void *memdup_sockptr_nul(sockptr_t src, size_t len)
+{
+	char *p = kmalloc_track_caller(len + 1, GFP_KERNEL);
+
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+	if (copy_from_sockptr(p, src, len)) {
+		kfree(p);
+		return ERR_PTR(-EFAULT);
+	}
+	p[len] = '\0';
+	return p;
+}
+
+static inline void sockptr_advance(sockptr_t sockptr, size_t len)
+{
+	if (sockptr_is_kernel(sockptr))
+		sockptr.kernel += len;
+	else
+		sockptr.user += len;
+}
+
+static inline long strncpy_from_sockptr(char *dst, sockptr_t src, size_t count)
+{
+	if (sockptr_is_kernel(src)) {
+		size_t len = min(strnlen(src.kernel, count - 1) + 1, count);
+
+		memcpy(dst, src.kernel, len);
+		return len;
+	}
+	return strncpy_from_user(dst, src.user, count);
+}
+
+#endif /* _LINUX_SOCKPTR_H */
-- 
2.27.0

