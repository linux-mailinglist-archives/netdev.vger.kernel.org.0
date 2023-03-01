Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3096A6699
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 04:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCADn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 22:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCADny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 22:43:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605312CC5A
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 19:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677642187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvld3gbtJ1BE6x3nj+J2K9CX8W70047HmTxzv/gpds8=;
        b=Z+GDQqwAYAHFxi3mnf7Q/GdJVFicQvuZGBNr/Wk3/po3/Mohat3e+lrNiJ7Dlee2QSW0Z8
        wQEaLpzrJ+Zw6jIojKzHRcGx1ivnUIcUtdXmbN/oB73VeovvxIG7ZF8ZIH6EDxk0I6wB+w
        iqUXhlO7lDErgFueFH5o5NSIJb5roeA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-m7PYgUh5M7mj4QuzIlwzKg-1; Tue, 28 Feb 2023 22:43:04 -0500
X-MC-Unique: m7PYgUh5M7mj4QuzIlwzKg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C5B2864765;
        Wed,  1 Mar 2023 03:43:03 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-13-180.pek2.redhat.com [10.72.13.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44E9BC15BAD;
        Wed,  1 Mar 2023 03:42:55 +0000 (UTC)
From:   Baoquan He <bhe@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org, linux-mm@kvack.org, arnd@arndb.de,
        christophe.leroy@csgroup.eu, hch@infradead.org,
        agordeev@linux.ibm.com, wangkefeng.wang@huawei.com,
        schnelle@linux.ibm.com, David.Laight@ACULAB.COM, shorne@gmail.com,
        willy@infradead.org, Baoquan He <bhe@redhat.com>,
        loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 01/17] asm-generic/iomap.h: remove ARCH_HAS_IOREMAP_xx macros
Date:   Wed,  1 Mar 2023 11:42:31 +0800
Message-Id: <20230301034247.136007-2-bhe@redhat.com>
In-Reply-To: <20230301034247.136007-1-bhe@redhat.com>
References: <20230301034247.136007-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's use '#define ioremap_xx' and "#ifdef ioremap_xx" instead.

For architectures defined ARCH_HAS_IOREMAP_xx macros in <asm/io.h>,
the relevant adjustments are made to avoid compiling error:

  loongarch:
  - doesn't include <asm-generic/iomap.h>, defining ARCH_HAS_IOREMAP_WC
    is redundant, so simply remove it.

  m68k:
  - selected GENERIC_IOMAP, so <asm-generic/iomap.h> has been added in
    <asm-generic/io.h>, and <asm/kmap.h> is included above
    <asm-generic/iomap.h>, so simply remove ARCH_HAS_IOREMAP_WT defining.

  mips:
  - move "#include <asm-generic/iomap.h>" below ioremap_wc definition
    in <asm/io.h>

  powerpc:
  - remove "#include <asm-generic/iomap.h>" in <asm/io.h> because it's
    duplicated with the one in <asm-generic/io.h>, let's rely on the
    latter.

  x86:
  - selected GENERIC_IOMAP, remove #include <asm-generic/iomap.h> at
    the middle of <asm/io.h>. Let's rely on <asm-generic/io.h>.

This is a preparation patch so that  Later patch don't need to add
ARCH_HAS_IOREMAP_xx macro.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: loongarch@lists.linux.dev
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-mips@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: x86@kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
---
 arch/loongarch/include/asm/io.h     | 2 --
 arch/m68k/include/asm/io_mm.h       | 2 --
 arch/m68k/include/asm/kmap.h        | 2 --
 arch/mips/include/asm/io.h          | 5 ++---
 arch/powerpc/include/asm/io.h       | 9 +--------
 arch/x86/include/asm/io.h           | 5 -----
 drivers/net/ethernet/sfc/io.h       | 2 +-
 drivers/net/ethernet/sfc/siena/io.h | 2 +-
 include/asm-generic/iomap.h         | 6 +++---
 9 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/arch/loongarch/include/asm/io.h b/arch/loongarch/include/asm/io.h
index 402a7d9e3a53..505e3b583463 100644
--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -5,8 +5,6 @@
 #ifndef _ASM_IO_H
 #define _ASM_IO_H
 
-#define ARCH_HAS_IOREMAP_WC
-
 #include <linux/kernel.h>
 #include <linux/types.h>
 
diff --git a/arch/m68k/include/asm/io_mm.h b/arch/m68k/include/asm/io_mm.h
index d41fa488453b..6a0abd4846c6 100644
--- a/arch/m68k/include/asm/io_mm.h
+++ b/arch/m68k/include/asm/io_mm.h
@@ -26,8 +26,6 @@
 #include <asm/virtconvert.h>
 #include <asm/kmap.h>
 
-#include <asm-generic/iomap.h>
-
 #ifdef CONFIG_ATARI
 #define atari_readb   raw_inb
 #define atari_writeb  raw_outb
diff --git a/arch/m68k/include/asm/kmap.h b/arch/m68k/include/asm/kmap.h
index dec05743d426..4efb3efa593a 100644
--- a/arch/m68k/include/asm/kmap.h
+++ b/arch/m68k/include/asm/kmap.h
@@ -4,8 +4,6 @@
 
 #ifdef CONFIG_MMU
 
-#define ARCH_HAS_IOREMAP_WT
-
 /* Values for nocacheflag and cmode */
 #define IOMAP_FULL_CACHING		0
 #define IOMAP_NOCACHE_SER		1
diff --git a/arch/mips/include/asm/io.h b/arch/mips/include/asm/io.h
index e6d5ccaa309e..cec8347f0b85 100644
--- a/arch/mips/include/asm/io.h
+++ b/arch/mips/include/asm/io.h
@@ -12,8 +12,6 @@
 #ifndef _ASM_IO_H
 #define _ASM_IO_H
 
-#define ARCH_HAS_IOREMAP_WC
-
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -25,7 +23,6 @@
 #include <asm/byteorder.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
-#include <asm-generic/iomap.h>
 #include <asm/page.h>
 #include <asm/pgtable-bits.h>
 #include <asm/processor.h>
@@ -210,6 +207,8 @@ void iounmap(const volatile void __iomem *addr);
 #define ioremap_wc(offset, size)					\
 	ioremap_prot((offset), (size), boot_cpu_data.writecombine)
 
+#include <asm-generic/iomap.h>
+
 #if defined(CONFIG_CPU_CAVIUM_OCTEON) || defined(CONFIG_CPU_LOONGSON64)
 #define war_io_reorder_wmb()		wmb()
 #else
diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index fc112a91d0c2..7a82e6f70ced 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -3,11 +3,6 @@
 #define _ASM_POWERPC_IO_H
 #ifdef __KERNEL__
 
-#define ARCH_HAS_IOREMAP_WC
-#ifdef CONFIG_PPC32
-#define ARCH_HAS_IOREMAP_WT
-#endif
-
 /*
  */
 
@@ -695,9 +690,7 @@ static inline void name at					\
 #define writel_relaxed(v, addr)	writel(v, addr)
 #define writeq_relaxed(v, addr)	writeq(v, addr)
 
-#ifdef CONFIG_GENERIC_IOMAP
-#include <asm-generic/iomap.h>
-#else
+#ifndef CONFIG_GENERIC_IOMAP
 /*
  * Here comes the implementation of the IOMAP interfaces.
  */
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index e9025640f634..76238842406a 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -35,9 +35,6 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define ARCH_HAS_IOREMAP_WC
-#define ARCH_HAS_IOREMAP_WT
-
 #include <linux/string.h>
 #include <linux/compiler.h>
 #include <linux/cc_platform.h>
@@ -212,8 +209,6 @@ void memset_io(volatile void __iomem *, int, size_t);
 #define memcpy_toio memcpy_toio
 #define memset_io memset_io
 
-#include <asm-generic/iomap.h>
-
 /*
  * ISA space is 'always mapped' on a typical x86 system, no need to
  * explicitly ioremap() it. The fact that the ISA IO space is mapped
diff --git a/drivers/net/ethernet/sfc/io.h b/drivers/net/ethernet/sfc/io.h
index 30439cc83a89..07f99ad14bf3 100644
--- a/drivers/net/ethernet/sfc/io.h
+++ b/drivers/net/ethernet/sfc/io.h
@@ -70,7 +70,7 @@
  */
 #ifdef CONFIG_X86_64
 /* PIO is a win only if write-combining is possible */
-#ifdef ARCH_HAS_IOREMAP_WC
+#ifdef ioremap_wc
 #define EFX_USE_PIO 1
 #endif
 #endif
diff --git a/drivers/net/ethernet/sfc/siena/io.h b/drivers/net/ethernet/sfc/siena/io.h
index 30439cc83a89..07f99ad14bf3 100644
--- a/drivers/net/ethernet/sfc/siena/io.h
+++ b/drivers/net/ethernet/sfc/siena/io.h
@@ -70,7 +70,7 @@
  */
 #ifdef CONFIG_X86_64
 /* PIO is a win only if write-combining is possible */
-#ifdef ARCH_HAS_IOREMAP_WC
+#ifdef ioremap_wc
 #define EFX_USE_PIO 1
 #endif
 #endif
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 08237ae8b840..196087a8126e 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -93,15 +93,15 @@ extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *);
 #endif
 
-#ifndef ARCH_HAS_IOREMAP_WC
+#ifndef ioremap_wc
 #define ioremap_wc ioremap
 #endif
 
-#ifndef ARCH_HAS_IOREMAP_WT
+#ifndef ioremap_wt
 #define ioremap_wt ioremap
 #endif
 
-#ifndef ARCH_HAS_IOREMAP_NP
+#ifndef ioremap_np
 /* See the comment in asm-generic/io.h about ioremap_np(). */
 #define ioremap_np ioremap_np
 static inline void __iomem *ioremap_np(phys_addr_t offset, size_t size)
-- 
2.34.1

