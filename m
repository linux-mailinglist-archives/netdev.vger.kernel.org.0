Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85A1DD1A4
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgEUPZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730190AbgEUPXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D23C061A0E;
        Thu, 21 May 2020 08:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1npcDTOJ/7f3HiPL67/bMBXtdt053nBQX247zae/UWo=; b=pqGd6S81tSKZa336lIookYkwk8
        Iy7VC6laC7HEryoG9Y4rYXwbstInrQedaaFzCUC8OrHO/f8k7/NMQ1/Y2vZQ8MPkVh2IlZ6oLjN1x
        68bFPrnotirGbFoTEDL0BnY9UKdYACt45BXZHJIRgTBJJF0mho2HZVIr6oVxAn1hUTwzXCpz/ud81
        EeEwgbWaYHVFglAhosG/cx46HMBf1S/GMBUqlHsKHWAFFzQ77uoy3KwfUKdvOZxgJC87GqlLIOdIY
        atTBlvcODkkFq0v2WbjNtrOOLU8Q5cgMczOu+eopuxHLz+ub8YX5N4EXnmJizcSoizXjBOtM5tsmf
        7D78Z82Q==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn2y-0004YO-Qn; Thu, 21 May 2020 15:23:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/23] maccess: remove strncpy_from_unsafe
Date:   Thu, 21 May 2020 17:22:53 +0200
Message-Id: <20200521152301.2587579-16-hch@lst.de>
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

All users are gone now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uaccess.h |  1 -
 mm/maccess.c            | 39 +--------------------------------------
 2 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 65a37ae3b8871..d7d98ff345b3d 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -311,7 +311,6 @@ extern long probe_user_read(void *dst, const void __user *src, size_t size);
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
 
-extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
 		long count);
 
diff --git a/mm/maccess.c b/mm/maccess.c
index 6116742608217..df82fde34307f 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -8,8 +8,6 @@
 
 static long __probe_kernel_read(void *dst, const void *src, size_t size,
 		bool strict);
-static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
-		long count, bool strict);
 
 bool __weak probe_kernel_read_allowed(const void *unsafe_src, size_t size,
 		bool strict)
@@ -156,35 +154,6 @@ long probe_user_write(void __user *dst, const void *src, size_t size)
 	return 0;
 }
 
-/**
- * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
- * @dst:   Destination address, in kernel space.  This buffer must be at
- *         least @count bytes long.
- * @unsafe_addr: Unsafe address.
- * @count: Maximum number of bytes to copy, including the trailing NUL.
- *
- * Copies a NUL-terminated string from unsafe address to kernel buffer.
- *
- * On success, returns the length of the string INCLUDING the trailing NUL.
- *
- * If access fails, returns -EFAULT (some data may have been copied
- * and the trailing NUL added).
- *
- * If @count is smaller than the length of the string, copies @count-1 bytes,
- * sets the last byte of @dst buffer to NUL and returns @count.
- *
- * Same as strncpy_from_kernel_nofault() except that for architectures with
- * not fully separated user and kernel address spaces this function also works
- * for user address tanges.
- *
- * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
- * separate kernel and user address spaces, and also a bad idea otherwise.
- */
-long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
-{
-	return __strncpy_from_unsafe(dst, unsafe_addr, count, false);
-}
-
 /**
  * strncpy_from_kernel_nofault: - Copy a NUL terminated string from unsafe
  *				 address.
@@ -204,12 +173,6 @@ long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
-{
-	return __strncpy_from_unsafe(dst, unsafe_addr, count, true);
-}
-
-static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
-		long count, bool strict)
 {
 	mm_segment_t old_fs = get_fs();
 	const void *src = unsafe_addr;
@@ -217,7 +180,7 @@ static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
 
 	if (unlikely(count <= 0))
 		return 0;
-	if (!probe_kernel_read_allowed(unsafe_addr, count, strict))
+	if (!probe_kernel_read_allowed(unsafe_addr, count, true))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-- 
2.26.2

