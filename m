Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE3D1DD159
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgEUPXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730109AbgEUPXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBB4C061A0F;
        Thu, 21 May 2020 08:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VuuC8gyhNLA98gHlF+iVYdqtkGo70vYEfnfHJViFpYs=; b=iVZS+pnvwRY99YET9+TtOjM1Mc
        Ad74dTvgf4tvHq1OTbOcq9fzBq20e1k5jiuPmWJVCREB/mZTB7Jk40ZlxXCP9i2v4lY+vga0NWCNB
        zJj+zdsIlDaTwxnPAbfzegn5PFCHFPRduB68HSNyeUP2Cn0wfdFRwInPxSKkt5mBpQn+jldA/u866
        KhCvoefEy03GvbVMZodkSypE++hOmezIy6M/+KsAahoNYxjBvtha8sH4JFHLd5MWpzOFGah43QK8l
        X4lrlr13S3GiidEpQ+Kw0b90SrWTuAApTaaIpODGY4j+XtKqEBUQ6uYbL0C9MFCC2PCozSaKJkYU3
        JMk3r1mg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn2e-0004Jj-1M; Thu, 21 May 2020 15:23:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/23] maccess: rename strnlen_unsafe_user to strnlen_user_nofault
Date:   Thu, 21 May 2020 17:22:46 +0200
Message-Id: <20200521152301.2587579-9-hch@lst.de>
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

This matches the naming of strnlen_user, and also makes it more clear
what the function is supposed to do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uaccess.h     | 2 +-
 kernel/trace/trace_kprobe.c | 2 +-
 mm/maccess.c                | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 134ff9c1c151b..d8366f8468664 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -315,7 +315,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 		long count);
-extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
+long strnlen_user_nofault(const void __user *unsafe_addr, long count);
 
 /**
  * probe_kernel_address(): safely attempt to read from a location
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d600f41fda1ca..4325f9e7fadaa 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1221,7 +1221,7 @@ fetch_store_strlen_user(unsigned long addr)
 {
 	const void __user *uaddr =  (__force const void __user *)addr;
 
-	return strnlen_unsafe_user(uaddr, MAX_STRING_SIZE);
+	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
 }
 
 /*
diff --git a/mm/maccess.c b/mm/maccess.c
index c8748c2809096..e783ebfccd542 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -258,7 +258,7 @@ long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 }
 
 /**
- * strnlen_unsafe_user: - Get the size of a user string INCLUDING final NUL.
+ * strnlen_user_nofault: - Get the size of a user string INCLUDING final NUL.
  * @unsafe_addr: The string to measure.
  * @count: Maximum count (including NUL)
  *
@@ -273,7 +273,7 @@ long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
  * Unlike strnlen_user, this can be used from IRQ handler etc. because
  * it disables pagefaults.
  */
-long strnlen_unsafe_user(const void __user *unsafe_addr, long count)
+long strnlen_user_nofault(const void __user *unsafe_addr, long count)
 {
 	mm_segment_t old_fs = get_fs();
 	int ret;
-- 
2.26.2

