Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD381D9843
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgESNpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729233AbgESNpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:45:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE66C08C5C0;
        Tue, 19 May 2020 06:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NqKwnVuM+JCYvPMnduPnSZpCSsvoPNTJ43a5XVzYQIw=; b=XbJTswWCzkAXGLQ95/cQr/6Q4i
        W0gCQcwIFtJVqHHjAPAo6Q1Y78rA+STqsqOUR5Pc+UBC8n+/DQ0xCbTd6hzoVosEAiW8AznHnSsRV
        2F+GUoZ87pEYbj0Q+I+Aw1ClGsIsGMrcrpFEYcuLGBvBks84GwlwJ/Oj347APhGtn7teZDVkYM9If
        X8bQeOwPU0HJ0SmONZrw1XZXljVSVmusb0yT5T0XjV5UKu2sPL4MAgCm1GmlXT5yRTE5lL9iltoGC
        2axdIFQ4loLEeDctgl3OwGzljluQ1Ho6ImoPv3+h5pwqh65nh1D+rDz3kevCcBN9B4lKdq/Z7C01V
        /M8IB2Uw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb2Yt-0003p8-Nh; Tue, 19 May 2020 13:45:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/20] maccess: allow architectures to provide kernel probing directly
Date:   Tue, 19 May 2020 15:44:44 +0200
Message-Id: <20200519134449.1466624-16-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519134449.1466624-1-hch@lst.de>
References: <20200519134449.1466624-1-hch@lst.de>
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
index 9773e2253b495..01129cbdf4484 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -12,6 +12,81 @@ bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
 	return true;
 }
 
+#ifdef HAVE_GET_KERNEL_NOFAULT
+
+#define probe_kernel_read_loop(dst, src, len, type, err_label)		\
+	while (len >= sizeof(type)) {					\
+		__get_kernel_nofault(dst, src, type, err_label);		\
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
+		__put_kernel_nofault(dst, src, type, err_label);		\
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
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
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
+		__get_kernel_nofault(dst, src, u8, Efault);
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
+#else /* HAVE_GET_KERNEL_NOFAULT */
 /**
  * probe_kernel_read(): safely attempt to read from kernel-space
  * @dst: pointer to the buffer that shall take the data
@@ -114,6 +189,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 
 	return ret ? -EFAULT : src - unsafe_addr;
 }
+#endif /* HAVE_GET_KERNEL_NOFAULT */
 
 /**
  * probe_user_read(): safely attempt to read from a user-space location
-- 
2.26.2

