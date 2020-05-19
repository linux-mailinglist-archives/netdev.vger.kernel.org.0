Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA301D986B
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgESNqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729327AbgESNp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:45:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DE0C08C5C1;
        Tue, 19 May 2020 06:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qCsBvrh+KJD94OzZIg2wzK8eCwrltTUzrmGt8F6Hn0Y=; b=etRLBJXUk51bBqKHOncqZVvZyI
        vQtqk4TEib0NYj8DZbaJYTWVbFti0S1FOQTd8OOvMAOvvG0eS2z886Ra8KdtsaBczmwJT/lYKIa/q
        kPbCLDNzaKZGTVer4rnsbXu/5PQUPlqefb96nX8OiUKS3OzpI5MRZsEbjFpAp9JFwupLVwCSfFMHu
        O/RNnLpEedx5Un+x3Exl18c0pjdk1wEN197kzQh2dzmpruxazCfrkrQCb7pLl19MmtTUEoxexHmud
        ejW4iRE3Hxs5MV+slCZgYSzYLpYgDBm5mDmm10BLqkixlob6lKEkc0PntbPpD71QC5GQzubFsF2Vn
        Np5UHAWA==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb2ZA-0003wy-0R; Tue, 19 May 2020 13:45:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] maccess: return -ERANGE when copy_from_kernel_nofault_allowed fails
Date:   Tue, 19 May 2020 15:44:49 +0200
Message-Id: <20200519134449.1466624-21-hch@lst.de>
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

Allow the callers to distinguish a real unmapped address vs a range
that can't be probed.

Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/maccess.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index 1e7d77656c596..4010d64189d21 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -25,7 +25,7 @@ bool __weak copy_from_kernel_nofault_allowed(void *dst, const void *unsafe_src,
 long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 {
 	if (!copy_from_kernel_nofault_allowed(dst, src, size))
-		return -EFAULT;
+		return -ERANGE;
 
 	pagefault_disable();
 	copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
@@ -69,7 +69,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	if (unlikely(count <= 0))
 		return 0;
 	if (!copy_from_kernel_nofault_allowed(dst, unsafe_addr, count))
-		return -EFAULT;
+		return -ERANGE;
 
 	pagefault_disable();
 	do {
@@ -107,7 +107,7 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 	mm_segment_t old_fs = get_fs();
 
 	if (!copy_from_kernel_nofault_allowed(dst, src, size))
-		return -EFAULT;
+		return -ERANGE;
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
@@ -174,7 +174,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	if (unlikely(count <= 0))
 		return 0;
 	if (!copy_from_kernel_nofault_allowed(dst, unsafe_addr, count))
-		return -EFAULT;
+		return -ERANGE;
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
-- 
2.26.2

