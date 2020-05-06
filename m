Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ABD1C68AA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgEFGXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728379AbgEFGXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:23:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E07C061A0F;
        Tue,  5 May 2020 23:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=73xwWdERJOWUidTf3k9x6ajdY4gu8lH6d9hC6e9Kw30=; b=Oyixt2C6FuXCADF1Z+bzaBBZEJ
        7tisz3mAxiH6My9gPYayi+8kQ0EDYfM7Fbww+XIZZaZxILzafqEE0OP3nRspxSPy9NbA/AAiYQa1Q
        B2+IJamBj3lig3cxkULH/b83CXpuMXvUPGt/yMfttVFhQOPvp9XtIh6j0JYcQ8a+iWNULMkP+ofni
        MKyeTyxPqBoBp/rIdfm/PUJ3LQKbN/u9JT+3y5dC5eWulRhVg4fq9zF2m4M7ixp71P0XOMKEFD/b7
        ykJq5/awg9XkD1SwTBiY8MZ2NNd2qO5Bxzr4svUU8/UDdRP++K9rAJXDPxGkRGzdP6Bl3HcwWyHRA
        qgaJ27hw==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDSV-0006q8-ME; Wed, 06 May 2020 06:23:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] maccess: allow architectures to provide kernel probing directly
Date:   Wed,  6 May 2020 08:22:22 +0200
Message-Id: <20200506062223.30032-15-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200506062223.30032-1-hch@lst.de>
References: <20200506062223.30032-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide alternative versions of probe_kernel_read, probe_kernel_write
and strncpy_from_kernel_unsafe that don't need set_fs magic, but instead
use arch hooks that are modelled after unsafe_{get,put}_user to access
kernel memory in an exception safe way.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/maccess.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/mm/maccess.c b/mm/maccess.c
index aa59967d9b658..d99a5a67fa9b3 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -12,6 +12,81 @@ bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
 	return true;
 }
 
+#ifdef HAVE_ARCH_PROBE_KERNEL
+
+#define probe_kernel_read_loop(dst, src, len, type, err_label)		\
+	while (len >= sizeof(type)) {					\
+		arch_kernel_read(dst, src, type, err_label);		\
+		dst += sizeof(type);					\
+		src += sizeof(type);					\
+		len -= sizeof(type);					\
+	}
+
+long probe_kernel_read(void *dst, const void *src, size_t size)
+{
+	if (!probe_kernel_read_allowed(dst, src, size))
+		return -EFAULT;
+
+	pagefault_disable();
+	probe_kernel_read_loop(dst, src, size, u64, Efault);
+	probe_kernel_read_loop(dst, src, size, u32, Efault);
+	probe_kernel_read_loop(dst, src, size, u16, Efault);
+	probe_kernel_read_loop(dst, src, size, u8, Efault);
+	pagefault_enable();
+	return 0;
+Efault:
+	pagefault_enable();
+	return -EFAULT;
+}
+EXPORT_SYMBOL_GPL(probe_kernel_read);
+
+#define probe_kernel_write_loop(dst, src, len, type, err_label)		\
+	while (len >= sizeof(type)) {					\
+		arch_kernel_write(dst, src, type, err_label);		\
+		dst += sizeof(type);					\
+		src += sizeof(type);					\
+		len -= sizeof(type);					\
+	}
+
+long probe_kernel_write(void *dst, const void *src, size_t size)
+{
+	pagefault_disable();
+	probe_kernel_write_loop(dst, src, size, u64, Efault);
+	probe_kernel_write_loop(dst, src, size, u32, Efault);
+	probe_kernel_write_loop(dst, src, size, u16, Efault);
+	probe_kernel_write_loop(dst, src, size, u8, Efault);
+	pagefault_enable();
+	return 0;
+Efault:
+	pagefault_enable();
+	return -EFAULT;
+}
+
+long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr, long count)
+{
+	const void *src = unsafe_addr;
+
+	if (unlikely(count <= 0))
+		return 0;
+	if (!probe_kernel_read_allowed(dst, unsafe_addr, count))
+		return -EFAULT;
+
+	pagefault_disable();
+	do {
+		arch_kernel_read(dst, src, u8, Efault);
+		dst++;
+		src++;
+	} while (dst[-1] && src - unsafe_addr < count);
+	pagefault_enable();
+
+	dst[-1] = '\0';
+	return src - unsafe_addr;
+Efault:
+	pagefault_enable();
+	dst[-1] = '\0';
+	return -EFAULT;
+}
+#else /* HAVE_ARCH_PROBE_KERNEL */
 /**
  * probe_kernel_read(): safely attempt to read from kernel-space
  * @dst: pointer to the buffer that shall take the data
@@ -114,6 +189,7 @@ long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr, long count)
 
 	return ret ? -EFAULT : src - unsafe_addr;
 }
+#endif /* HAVE_ARCH_PROBE_KERNEL */
 
 /**
  * probe_user_read(): safely attempt to read from a user-space location
-- 
2.26.2

