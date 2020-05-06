Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F5F1C68B6
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgEFGXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727051AbgEFGXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:23:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D52C061A10;
        Tue,  5 May 2020 23:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1V9FXGwvoUyADOJtECmZzXrzilRy7l0jj6styYqt0KU=; b=WRFvLxLA/MEdLMrePczuELjuEW
        72WQod2YCGoc0J7XuWxFW5Y83J/ykdaW/Fvtk4rs7oIQKRnkopymKyz3EwOuypFcUXYqHVjttqChT
        ZWZNpoWAW9huIiQ+2137fhpck8Jvk/OBURKnP8nGMpNXmGD2pqVc7U+++Rpk2a2Bk7XJ02fZnKKsU
        IEroVJ/nwQQ94XE+aNULG0kXWN5Eggp6JsjK1mQHpJq/Xtrfl5qzt8d1FvzbHRkBpEs4Bug8AGZs1
        Sj9Fq+m0wtnluKjoULPl+k1peWL6urmnAGcvGAut03L8y2xEcPesIPXq+cvi5XhfJas+TJjKchnlZ
        cprmKauQ==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDSY-0006rv-M1; Wed, 06 May 2020 06:23:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] x86: use non-set_fs based maccess routines
Date:   Wed,  6 May 2020 08:22:23 +0200
Message-Id: <20200506062223.30032-16-hch@lst.de>
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

Provide arch_kernel_read and arch_kernel_write routines to implement the
maccess routines without messing with set_fs and without stac/clac that
opens up access to user space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/include/asm/uaccess.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index d8f283b9a569c..765e18417b3ba 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -523,5 +523,21 @@ do {									\
 	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
 } while (0)
 
+#define HAVE_ARCH_PROBE_KERNEL
+
+#define arch_kernel_read(dst, src, type, err_label)			\
+do {									\
+        int __kr_err;							\
+									\
+	__get_user_size(*((type *)dst), (__force type __user *)src,	\
+			sizeof(type), __kr_err);			\
+        if (unlikely(__kr_err))						\
+		goto err_label;						\
+} while (0)
+
+#define arch_kernel_write(dst, src, type, err_label)			\
+	__put_user_size(*((type *)(src)), (__force type __user *)(dst),	\
+			sizeof(type), err_label)
+
 #endif /* _ASM_X86_UACCESS_H */
 
-- 
2.26.2

