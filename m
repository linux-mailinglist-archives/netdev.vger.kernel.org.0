Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490BE1D1A50
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389619AbgEMQB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389529AbgEMQBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:01:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F710C061A0E;
        Wed, 13 May 2020 09:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1V9FXGwvoUyADOJtECmZzXrzilRy7l0jj6styYqt0KU=; b=tKor3Cj8X0w448ldbecYKjcLcO
        rEBZiIwDb8iBHi+e8Zj3GmAVgJ4eAPYD7OkxnNk7ExjrIO/MQHCGpj8UqyYoe3GC50VfbTOwfflHH
        OJVv1O2Q5GBa1SMeS/mocauWeVDCuR5Zo/vBfbV4CWMeodUXAn1y4NUM0PfDY7RF/I/SxR7DgcnA2
        HRpIzKQux8h7EOGjHQewnkQkeSiHNy/sFfYXB+svuF9eDP4FdjQbJLg1P1mZXWSkEefQlwdi5R7u2
        k+gy4VBHXHqnD/qRwkaOMESyDqX4cFkkpZU5y3kQrjY90A/HJ7pTuAtgIcHXzqbZx9d7McA3ikcFk
        R9jLdIuA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYtou-00050Z-AS; Wed, 13 May 2020 16:01:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] x86: use non-set_fs based maccess routines
Date:   Wed, 13 May 2020 18:00:35 +0200
Message-Id: <20200513160038.2482415-16-hch@lst.de>
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

