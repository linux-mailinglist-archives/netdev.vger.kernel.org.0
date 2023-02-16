Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4015269935E
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjBPLmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBPLmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:42:06 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AF772BF;
        Thu, 16 Feb 2023 03:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676547725; x=1708083725;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DZtMdMHG1rZUSnjA3M8Y0P2RY5raVZxMdIWzLiuWreo=;
  b=ghMQ64ki6Qsk2e+IPb+eDDR6i6L53vute/EnDq+/6AE6lin+yMSYsedx
   IBFLCsM3/qF29uId/xQfkv46Co3dZYOK5tH5L6KzkHlmrqDn97OIkn/D4
   KaRKCQVSXIa40Y3qbgC6iMRyj21jWfkXGqMfFk3pmUjJXTfvLkcMrnMWq
   xCjroer8Cz3EBZSCN/IMiEaxX/oxRqPpfQNQgNGc9mK07apGDdTb7uxu8
   ot0vIM6CCWnQzew8Wghf4Au3eTbY3JkHBwquiWN5VjV1PU0iHlDrex4XU
   G8vvm/dbUJh1l0SvwgveuL/ho0rqehB8pe/UYuD1bI5bIx3p7Vtcws7AT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="359124735"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="359124735"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 03:42:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="999003906"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="999003906"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 16 Feb 2023 03:42:00 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 780BE1A6; Thu, 16 Feb 2023 13:42:40 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Shevchenko <andy@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v1 1/2] string: Make memscan() to take const
Date:   Thu, 16 Feb 2023 13:42:33 +0200
Message-Id: <20230216114234.36343-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make memscan() to take const so it will be easier replace
some memchr() cases with it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/s390/include/asm/string.h          | 4 ++--
 arch/s390/lib/string.c                  | 2 +-
 arch/sparc/include/asm/asm-prototypes.h | 4 ++--
 arch/sparc/include/asm/string.h         | 7 ++++---
 arch/x86/include/asm/string_32.h        | 2 +-
 arch/x86/lib/string_32.c                | 2 +-
 include/linux/string.h                  | 2 +-
 lib/string.c                            | 2 +-
 8 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/s390/include/asm/string.h b/arch/s390/include/asm/string.h
index 3fae93ddb322..0196fd466a39 100644
--- a/arch/s390/include/asm/string.h
+++ b/arch/s390/include/asm/string.h
@@ -120,7 +120,7 @@ static inline void *memchr(const void * s, int c, size_t n)
 #endif
 
 #ifdef __HAVE_ARCH_MEMSCAN
-static inline void *memscan(void *s, int c, size_t n)
+static inline void *memscan(const void *s, int c, size_t n)
 {
 	const void *ret = s + n;
 
@@ -205,7 +205,7 @@ static inline size_t strnlen(const char * s, size_t n)
 #endif
 #else /* IN_ARCH_STRING_C */
 void *memchr(const void * s, int c, size_t n);
-void *memscan(void *s, int c, size_t n);
+void *memscan(const void *s, int c, size_t n);
 char *strcat(char *dst, const char *src);
 char *strcpy(char *dst, const char *src);
 size_t strlen(const char *s);
diff --git a/arch/s390/lib/string.c b/arch/s390/lib/string.c
index 7d8741818239..ec9786fde1dd 100644
--- a/arch/s390/lib/string.c
+++ b/arch/s390/lib/string.c
@@ -331,7 +331,7 @@ EXPORT_SYMBOL(memcmp);
  * the area if @c is not found
  */
 #ifdef __HAVE_ARCH_MEMSCAN
-void *memscan(void *s, int c, size_t n)
+void *memscan(const void *s, int c, size_t n)
 {
 	const void *ret = s + n;
 
diff --git a/arch/sparc/include/asm/asm-prototypes.h b/arch/sparc/include/asm/asm-prototypes.h
index 4987c735ff56..3a82a86a27a6 100644
--- a/arch/sparc/include/asm/asm-prototypes.h
+++ b/arch/sparc/include/asm/asm-prototypes.h
@@ -13,8 +13,8 @@
 #include <asm/oplib.h>
 #include <linux/atomic.h>
 
-void *__memscan_zero(void *, size_t);
-void *__memscan_generic(void *, int, size_t);
+void *__memscan_zero(const void *, size_t);
+void *__memscan_generic(const void *, int, size_t);
 void *__bzero(void *, size_t);
 void VISenter(void); /* Dummy prototype to supress warning */
 #undef memcpy
diff --git a/arch/sparc/include/asm/string.h b/arch/sparc/include/asm/string.h
index 001a17baf2d5..7761a037b377 100644
--- a/arch/sparc/include/asm/string.h
+++ b/arch/sparc/include/asm/string.h
@@ -21,10 +21,11 @@ void *memmove(void *, const void *, __kernel_size_t);
 
 #define memscan(__arg0, __char, __arg2)						\
 ({										\
-	void *__memscan_zero(void *, size_t);					\
-	void *__memscan_generic(void *, int, size_t);				\
-	void *__retval, *__addr = (__arg0);					\
+	void *__memscan_zero(const void *, size_t);				\
+	void *__memscan_generic(const void *, int, size_t);			\
+	const void *__addr = (__arg0);						\
 	size_t __size = (__arg2);						\
+	void *__retval;								\
 										\
 	if(__builtin_constant_p(__char) && !(__char))				\
 		__retval = __memscan_zero(__addr, __size);			\
diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 32c0d981a82a..30245f7707e7 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -223,7 +223,7 @@ static inline void *memset32(uint32_t *s, uint32_t v, size_t n)
  * find the first occurrence of byte 'c', or 1 past the area if none
  */
 #define __HAVE_ARCH_MEMSCAN
-extern void *memscan(void *addr, int c, size_t size);
+extern void *memscan(const void *addr, int c, size_t size);
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/lib/string_32.c b/arch/x86/lib/string_32.c
index 53b3f202267c..4124d6678f72 100644
--- a/arch/x86/lib/string_32.c
+++ b/arch/x86/lib/string_32.c
@@ -198,7 +198,7 @@ EXPORT_SYMBOL(memchr);
 #endif
 
 #ifdef __HAVE_ARCH_MEMSCAN
-void *memscan(void *addr, int c, size_t size)
+void *memscan(const void *addr, int c, size_t size)
 {
 	if (!size)
 		return addr;
diff --git a/include/linux/string.h b/include/linux/string.h
index c062c581a98b..a7bff7ed3cb0 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -150,7 +150,7 @@ extern void * memcpy(void *,const void *,__kernel_size_t);
 extern void * memmove(void *,const void *,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_MEMSCAN
-extern void * memscan(void *,int,__kernel_size_t);
+extern void * memscan(const void *,int,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_MEMCMP
 extern int memcmp(const void *,const void *,__kernel_size_t);
diff --git a/lib/string.c b/lib/string.c
index 3d55ef890106..30a63048d4cc 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -725,7 +725,7 @@ EXPORT_SYMBOL(bcmp);
  * returns the address of the first occurrence of @c, or 1 byte past
  * the area if @c is not found
  */
-void *memscan(void *addr, int c, size_t size)
+void *memscan(const void *addr, int c, size_t size)
 {
 	unsigned char *p = addr;
 
-- 
2.39.1

