Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79311D9838
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgESNpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729137AbgESNpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:45:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D78EC08C5C0;
        Tue, 19 May 2020 06:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RIAP7mULj+tEdJwrt73n5QoKYntidLFm6Z2T1lFQPpk=; b=ZgWpW4RZXz1lIbgjPJcmWURUQ7
        7lh7LZsQM8Mp2UQ09IPoaejqI16CooDai3omRvlpSksxkWBmx4HulvVJ/v5CBxcZ1nlz+oR2x/ZRq
        8YFqnU1ODPDDilTehvaQO3YKXkHv87Kcqww+cNcBbUGn9jgBrqNeZl5WN3BOif2dKi+93tqF7KfC8
        HcxGvNpDRas+KVf3FXPFWEVV+oiNFPNl/uCD89l0zbHa1J6pZa9/4KgkjmZS8MJnftUryB408QSQz
        b7IbXg/cl4jPicydMuOoa/Vt8jPqNiFjnhxKceKJzYuZ4qR5leA6vyWpZKDJ7i65O5/KRQO2KYjw/
        1wDj/TzA==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb2YR-0002c6-4O; Tue, 19 May 2020 13:45:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/20] maccess: rename strncpy_from_unsafe_user to strncpy_from_user_nofault
Date:   Tue, 19 May 2020 15:44:35 +0200
Message-Id: <20200519134449.1466624-7-hch@lst.de>
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

This matches the naming of strncpy_from_user, and also makes it more
clear what the function is supposed to do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uaccess.h     | 4 ++--
 kernel/trace/bpf_trace.c    | 4 ++--
 kernel/trace/trace_kprobe.c | 2 +-
 mm/maccess.c                | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 5a36a298a85f8..b983cb1c1216a 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -313,8 +313,8 @@ extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
 				       long count);
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
-				     long count);
+long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
+		long count);
 extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
 
 /**
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a010edc37ee02..4e20bf1d95832 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -159,7 +159,7 @@ static const struct bpf_func_proto bpf_probe_read_user_proto = {
 BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
 	   const void __user *, unsafe_ptr)
 {
-	int ret = strncpy_from_unsafe_user(dst, unsafe_ptr, size);
+	int ret = strncpy_from_user_nofault(dst, unsafe_ptr, size);
 
 	if (unlikely(ret < 0))
 		memset(dst, 0, size);
@@ -416,7 +416,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 							   sizeof(buf));
 				break;
 			case 'u':
-				strncpy_from_unsafe_user(buf,
+				strncpy_from_user_nofault(buf,
 					(__force void __user *)unsafe_ptr,
 							 sizeof(buf));
 				break;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 35989383ae113..d600f41fda1ca 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1268,7 +1268,7 @@ fetch_store_string_user(unsigned long addr, void *dest, void *base)
 
 	__dest = get_loc_data(dest, base);
 
-	ret = strncpy_from_unsafe_user(__dest, uaddr, maxlen);
+	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
diff --git a/mm/maccess.c b/mm/maccess.c
index 65880ba2ca376..457d8f9bf714f 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -215,7 +215,7 @@ long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 }
 
 /**
- * strncpy_from_unsafe_user: - Copy a NUL terminated string from unsafe user
+ * strncpy_from_user_nofault: - Copy a NUL terminated string from unsafe user
  *				address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
@@ -232,7 +232,7 @@ long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
+long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 			      long count)
 {
 	mm_segment_t old_fs = get_fs();
-- 
2.26.2

