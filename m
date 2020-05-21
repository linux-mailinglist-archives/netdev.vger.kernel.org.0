Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFFA1DD18E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgEUPYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730311AbgEUPYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:24:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17D0C061A0E;
        Thu, 21 May 2020 08:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kv7va3JnJ1SeELpjhZcyLBCa20krrM3Xn4ju295jtGk=; b=rUdy0Gqzh3C4nJ6TIdAzKeaoif
        wcO+pkmQg4oh+RaTJSGjuKJXdWDDJUYMIicegaPFbD3QMndGAgCdBjZh1eLyE/wqaocovxx+mGLyi
        RlEMRo4KWxKjsECuFNapixznaS98/x20tWLfwVzyQQGMpVDlktZOHWqxxteKQyx3Eant2Ou6sVWT1
        FDeAz0UFxKBHg0u2Qw9BwNLcec2AzoQa4PjCr/deKqjkOm7+ph3GVN0NQ+PU7PAKvqInr5q8DWlrn
        L5OJO06mNjWLrStuLSvcAmQJVAu1CwXpApFO5RGzG1T1lSsG6M6h2aBM2rEhOzv3ekUiixNL/AXHa
        326OosUA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn3K-0004wA-Sz; Thu, 21 May 2020 15:24:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/23] maccess: return -ERANGE when copy_from_kernel_nofault_allowed fails
Date:   Thu, 21 May 2020 17:23:01 +0200
Message-Id: <20200521152301.2587579-24-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521152301.2587579-1-hch@lst.de>
References: <20200521152301.2587579-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the callers to distinguish a real unmapped address vs a range
that can't be probed.

Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 mm/maccess.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index 349b6cb14426c..d317f8b8095ca 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -25,7 +25,7 @@ bool __weak copy_from_kernel_nofault_allowed(const void *unsafe_src,
 long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 {
 	if (!copy_from_kernel_nofault_allowed(src, size))
-		return -EFAULT;
+		return -ERANGE;
 
 	pagefault_disable();
 	copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
@@ -69,7 +69,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	if (unlikely(count <= 0))
 		return 0;
 	if (!copy_from_kernel_nofault_allowed(unsafe_addr, count))
-		return -EFAULT;
+		return -ERANGE;
 
 	pagefault_disable();
 	do {
@@ -94,7 +94,8 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
  * @size: size of the data chunk
  *
  * Safely read from kernel address @src to the buffer at @dst.  If a kernel
- * fault happens, handle that and return -EFAULT.
+ * fault happens, handle that and return -EFAULT.  If @src is not a valid kernel
+ * address, return -ERANGE.
  *
  * We ensure that the copy_from_user is executed in atomic context so that
  * do_page_fault() doesn't attempt to take mmap_sem.  This makes
@@ -107,7 +108,7 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 	mm_segment_t old_fs = get_fs();
 
 	if (!copy_from_kernel_nofault_allowed(src, size))
-		return -EFAULT;
+		return -ERANGE;
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
@@ -159,8 +160,9 @@ long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
  *
  * On success, returns the length of the string INCLUDING the trailing NUL.
  *
- * If access fails, returns -EFAULT (some data may have been copied
- * and the trailing NUL added).
+ * If access fails, returns -EFAULT (some data may have been copied and the
+ * trailing NUL added).  If @unsafe_addr is not a valid kernel address, return
+ * -ERANGE.
  *
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
@@ -174,7 +176,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	if (unlikely(count <= 0))
 		return 0;
 	if (!copy_from_kernel_nofault_allowed(unsafe_addr, count))
-		return -EFAULT;
+		return -ERANGE;
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
-- 
2.26.2

