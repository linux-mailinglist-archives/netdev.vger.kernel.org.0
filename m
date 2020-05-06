Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2DF1C6897
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgEFGWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728278AbgEFGWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:22:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDF4C061A0F;
        Tue,  5 May 2020 23:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ism2pGSU5WX+kUcuOyuDphkif76JmaDpJJbD5Qn0Unw=; b=oWvEfbUnPltf7xRcMQ+nlweVoI
        KSmHiWsNNboxH9dPYh3gGa2Egw9v08GsiPpXlrGB8RymBTSvySy8WxrHhxnSz5t31KbJllBL93Zb+
        ROXyRz3m8oLC7Dv3OfUu4D6B56P+PkLP8ZwySHDeJ4GqJMyiRCo4gMO+8RDp4gn7zZjyhXga02ORb
        6gg3Be7cUNmoulvxSPoQQ42CdKj3fL0qxit+XPp3pbkNx0g1nu2lJIm9S55MEo5eJ5yR0Tjl6oLM7
        vycTG08U42Vrl9XGU9mQQT/hUUps4khRpDi8MjK0NzwsAkyqXBFVwGXxsmPBUGHZHolZlNUAAxFyu
        Q/afGyyQ==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDSD-0006g6-MF; Wed, 06 May 2020 06:22:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] maccess: rename strnlen_unsafe_user to strnlen_user_unsafe
Date:   Wed,  6 May 2020 08:22:16 +0200
Message-Id: <20200506062223.30032-9-hch@lst.de>
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

This matches the convention of always having _unsafe as a suffix, as
well as match the naming of strncpy_from_user_unsafe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uaccess.h     | 2 +-
 kernel/trace/trace_kprobe.c | 2 +-
 mm/maccess.c                | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 221d703480b6e..77909cafde5a8 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -315,7 +315,7 @@ extern long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr,
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_user_unsafe(char *dst, const void __user *unsafe_addr,
 				     long count);
-extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
+extern long strnlen_user_unsafe(const void __user *unsafe_addr, long count);
 
 /**
  * probe_kernel_address(): safely attempt to read from a location
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 67ed9655afc51..a7f43c7ec9880 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1215,7 +1215,7 @@ fetch_store_strlen_user(unsigned long addr)
 {
 	const void __user *uaddr =  (__force const void __user *)addr;
 
-	return strnlen_unsafe_user(uaddr, MAX_STRING_SIZE);
+	return strnlen_user_unsafe(uaddr, MAX_STRING_SIZE);
 }
 
 /*
diff --git a/mm/maccess.c b/mm/maccess.c
index 683b70518a896..95f2bf97e5ad7 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -258,7 +258,7 @@ long strncpy_from_user_unsafe(char *dst, const void __user *unsafe_addr,
 }
 
 /**
- * strnlen_unsafe_user: - Get the size of a user string INCLUDING final NUL.
+ * strnlen_user_unsafe: - Get the size of a user string INCLUDING final NUL.
  * @unsafe_addr: The string to measure.
  * @count: Maximum count (including NUL)
  *
@@ -273,7 +273,7 @@ long strncpy_from_user_unsafe(char *dst, const void __user *unsafe_addr,
  * Unlike strnlen_user, this can be used from IRQ handler etc. because
  * it disables pagefaults.
  */
-long strnlen_unsafe_user(const void __user *unsafe_addr, long count)
+long strnlen_user_unsafe(const void __user *unsafe_addr, long count)
 {
 	mm_segment_t old_fs = get_fs();
 	int ret;
-- 
2.26.2

