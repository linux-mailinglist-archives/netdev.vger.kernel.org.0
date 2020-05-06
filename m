Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050421C68D2
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgEFGWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728213AbgEFGWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:22:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813AEC061A0F;
        Tue,  5 May 2020 23:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uu5+p1IElYcCoqcRQhr2s0X0BQJM+h23Zjg2TeFbD1w=; b=ed8D62ETyvVJqvLsHu+XTquwMX
        HFhMQtrqDJdWSGppVm1JzYBycT/2TLeZthstJw69AnfAfYWYivqGe24slo74isHoG1IHkyG7IoAgs
        1ENpgp0Y9Jxsdth5mPAo4cCaINFQZ+LaMbpWiinYlYRky2nCe1OOfb5BRjIvVJVe2zZN5B6nRipEM
        CwFym/arEUqvXljIhq6UkacBJkrNekH6NzsZ7oerThvVXPO32z4bIMOh+jr7Wn2giGd6a7wasqsJ0
        EfqoI9NYlKQrLeddEXpCXpR6pc0BrNuBGcC1ejXhZurvAsNdgfZEf6pSWgfnz5rh+n1sbcNJbd+NF
        YBm3IXsw==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDS7-0006c4-L4; Wed, 06 May 2020 06:22:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/15] maccess: rename strncpy_from_unsafe_user to strncpy_from_user_unsafe
Date:   Wed,  6 May 2020 08:22:14 +0200
Message-Id: <20200506062223.30032-7-hch@lst.de>
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
well as match the naming of strncpy_from_user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uaccess.h     | 2 +-
 kernel/trace/bpf_trace.c    | 2 +-
 kernel/trace/trace_kprobe.c | 2 +-
 mm/maccess.c                | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 5a36a298a85f8..74db16fac2a04 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -313,7 +313,7 @@ extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
 				       long count);
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
+extern long strncpy_from_user_unsafe(char *dst, const void __user *unsafe_addr,
 				     long count);
 extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1796747a773..d3989384e515d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -159,7 +159,7 @@ static const struct bpf_func_proto bpf_probe_read_user_proto = {
 BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
 	   const void __user *, unsafe_ptr)
 {
-	int ret = strncpy_from_unsafe_user(dst, unsafe_ptr, size);
+	int ret = strncpy_from_user_unsafe(dst, unsafe_ptr, size);
 
 	if (unlikely(ret < 0))
 		memset(dst, 0, size);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d0568af4a0ef6..67ed9655afc51 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1262,7 +1262,7 @@ fetch_store_string_user(unsigned long addr, void *dest, void *base)
 
 	__dest = get_loc_data(dest, base);
 
-	ret = strncpy_from_unsafe_user(__dest, uaddr, maxlen);
+	ret = strncpy_from_user_unsafe(__dest, uaddr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
diff --git a/mm/maccess.c b/mm/maccess.c
index 65880ba2ca376..76f9d4dd51300 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -215,7 +215,7 @@ long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 }
 
 /**
- * strncpy_from_unsafe_user: - Copy a NUL terminated string from unsafe user
+ * strncpy_from_user_unsafe: - Copy a NUL terminated string from unsafe user
  *				address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
@@ -232,7 +232,7 @@ long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
+long strncpy_from_user_unsafe(char *dst, const void __user *unsafe_addr,
 			      long count)
 {
 	mm_segment_t old_fs = get_fs();
-- 
2.26.2

