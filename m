Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DFC1D985E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgESNpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbgESNpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:45:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1F6C08C5C0;
        Tue, 19 May 2020 06:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=z84HF8MbiF+uWN8N63G2E43OTwbdeCsOdqVBGb9xrkM=; b=cxNIyYsYdXb8Q8KjQwOwlsf+BL
        7MRU0p5saxO3z1PrKuYd9WPPeIbTbJMbF1JwJdZm0Xt9R/eHZwBRqQqI007LKTx5WTiRetwbcnuvV
        tzdi4Ajhp40h0vK/H4wRYN5vfDgLhrMZuy+/Y2sV/dVHi8p9oROPJ8Jn4Kys2t8ktQyzcbka7dgA7
        Wl/rhvFpuC0b5T8snuJW6hHFfz7iJ3/oAMnilsCEMTSWAV4Iw1ziv33m2Hx6X+FPdOKtkmqo4pzfk
        ZO992lyCxWJxq8EfOOj7NbNchugOAReaCnLPiY/bXoPG+K5EaYEdxwoKcylrL7vng9I+UlkfErBq1
        67s/NN2w==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb2Yw-0003qK-Pw; Tue, 19 May 2020 13:45:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] x86: use non-set_fs based maccess routines
Date:   Tue, 19 May 2020 15:44:45 +0200
Message-Id: <20200519134449.1466624-17-hch@lst.de>
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

Provide arch_kernel_read and arch_kernel_write routines to implement the
maccess routines without messing with set_fs and without stac/clac that
opens up access to user space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/include/asm/uaccess.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index d8f283b9a569c..b3e0a56ae961a 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -523,5 +523,21 @@ do {									\
 	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
 } while (0)
 
+#define HAVE_GET_KERNEL_NOFAULT
+
+#define __get_kernel_nofault(dst, src, type, err_label)			\
+do {									\
+        int __kr_err;							\
+									\
+	__get_user_size(*((type *)dst), (__force type __user *)src,	\
+			sizeof(type), __kr_err);			\
+        if (unlikely(__kr_err))						\
+		goto err_label;						\
+} while (0)
+
+#define __put_kernel_nofault(dst, src, type, err_label)			\
+	__put_user_size(*((type *)(src)), (__force type __user *)(dst),	\
+			sizeof(type), err_label)
+
 #endif /* _ASM_X86_UACCESS_H */
 
-- 
2.26.2

