Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A411DD157
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgEUPXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730092AbgEUPXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEFEC061A0E;
        Thu, 21 May 2020 08:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yadtTKbWc/15+vOx4rf6FZGFQ9tpi7eEb5UkyN0sySQ=; b=GP3b70h9FxeoeTseRgQCwrWfcR
        3hpIHJ3sYuG3mFWJ406Rryd8s/og55XYTArlkKieAUScUqLnaTiUUc1+7lxdL1c+nmBy/0Ubk5g6m
        v64ED14g46PC3vCKuZB4t67FmLIueuMQnof+Ly2sdfbhUpzxCawaiSVAHB9fipyXnbJkQE5dyEzy8
        WsIWlasB3BNWFpGo1Az3nLWOGQdNwzV+I3xjwHhEqJa66AzMTpOoxlYji3/s41IdzKZf2gOMOdioG
        lmkAzvviYBbqPpruEcteC44nmnld/Bj2Ji0uxYQO7mBfoMlwnFKsuHiF9rzR4XKESJlLTsXSopjcU
        90T7+7pw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn2h-0004NA-0e; Thu, 21 May 2020 15:23:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/23] maccess: remove probe_read_common and probe_write_common
Date:   Thu, 21 May 2020 17:22:47 +0200
Message-Id: <20200521152301.2587579-10-hch@lst.de>
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

Each of the helpers has just two callers, which also different in
dealing with kernel or userspace pointers.  Just open code the logic
in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/maccess.c | 63 ++++++++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index e783ebfccd542..31cf6604e7fff 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -6,30 +6,6 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
-static __always_inline long
-probe_read_common(void *dst, const void __user *src, size_t size)
-{
-	long ret;
-
-	pagefault_disable();
-	ret = __copy_from_user_inatomic(dst, src, size);
-	pagefault_enable();
-
-	return ret ? -EFAULT : 0;
-}
-
-static __always_inline long
-probe_write_common(void __user *dst, const void *src, size_t size)
-{
-	long ret;
-
-	pagefault_disable();
-	ret = __copy_to_user_inatomic(dst, src, size);
-	pagefault_enable();
-
-	return ret ? -EFAULT : 0;
-}
-
 /**
  * probe_kernel_read(): safely attempt to read from any location
  * @dst: pointer to the buffer that shall take the data
@@ -69,10 +45,15 @@ long __probe_kernel_read(void *dst, const void *src, size_t size)
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	ret = probe_read_common(dst, (__force const void __user *)src, size);
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(dst, (__force const void __user *)src,
+			size);
+	pagefault_enable();
 	set_fs(old_fs);
 
-	return ret;
+	if (ret)
+		return -EFAULT;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(probe_kernel_read);
 
@@ -91,11 +72,16 @@ long probe_user_read(void *dst, const void __user *src, size_t size)
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(USER_DS);
-	if (access_ok(src, size))
-		ret = probe_read_common(dst, src, size);
+	if (access_ok(src, size)) {
+		pagefault_disable();
+		ret = __copy_from_user_inatomic(dst, src, size);
+		pagefault_enable();
+	}
 	set_fs(old_fs);
 
-	return ret;
+	if (ret)
+		return -EFAULT;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(probe_user_read);
 
@@ -114,10 +100,14 @@ long probe_kernel_write(void *dst, const void *src, size_t size)
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	ret = probe_write_common((__force void __user *)dst, src, size);
+	pagefault_disable();
+	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
+	pagefault_enable();
 	set_fs(old_fs);
 
-	return ret;
+	if (ret)
+		return -EFAULT;
+	return 0;
 }
 
 /**
@@ -135,11 +125,16 @@ long probe_user_write(void __user *dst, const void *src, size_t size)
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(USER_DS);
-	if (access_ok(dst, size))
-		ret = probe_write_common(dst, src, size);
+	if (access_ok(dst, size)) {
+		pagefault_disable();
+		ret = __copy_to_user_inatomic(dst, src, size);
+		pagefault_enable();
+	}
 	set_fs(old_fs);
 
-	return ret;
+	if (ret)
+		return -EFAULT;
+	return 0;
 }
 
 /**
-- 
2.26.2

