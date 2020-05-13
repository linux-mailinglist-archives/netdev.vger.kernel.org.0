Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE91D1A5F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389452AbgEMQBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389421AbgEMQBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:01:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF77C061A0E;
        Wed, 13 May 2020 09:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yadtTKbWc/15+vOx4rf6FZGFQ9tpi7eEb5UkyN0sySQ=; b=n83Jlhlq7VChaqupUdqt+gBhX7
        OcJrYjdbip8e8Zxa1Fi65f3i3XVVl95+rUzNQWgeZYF1FATnOOF2fnUiZmkDma2GCbeAqQXyp6Bls
        ojHiyEeX38xD6PiXqorsZWC/Wb7Laq9R+8rBqiVPRyRRyFhFigNiJ2T54RdghGYRgyu/qthIVnIRk
        oKKJSJ+qkc9jz6EOCgSRLl8EELFH31ImfPJ8wPZd11/08sZlpgwuOB7glqi99WI2DZjx2AtgmNh/c
        Nvos/wtzUV+XExtE6W6/4LVF9/xnCdEueYvxfrk0Ia//G5lgovOmy4EHLym0ahZWBSbfW0mkm9eYW
        d1+GD+fA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYtoe-0004rO-6Y; Wed, 13 May 2020 16:01:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] maccess: remove probe_read_common and probe_write_common
Date:   Wed, 13 May 2020 18:00:29 +0200
Message-Id: <20200513160038.2482415-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513160038.2482415-1-hch@lst.de>
References: <20200513160038.2482415-1-hch@lst.de>
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

