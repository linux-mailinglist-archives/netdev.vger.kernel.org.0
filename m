Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7282199C0
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 09:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgGIH3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 03:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgGIH25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 03:28:57 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.195])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4B6E2074B;
        Thu,  9 Jul 2020 07:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594279735;
        bh=OK13iXqg1uCDFJL023hA8If9CF8rTsbyhuzi9tNz3so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNJthvpvRCohXoOS1kdm0CEKPGtisO7807j6kPV5uxN9jmddYIke5GCRn3hhFLVvA
         j75Al+jlJtAsKDzNUC+I8rczfPMR9S31PaWOcaQg0wWKCrUqPQEuyPVTDeW7JkLJYB
         JKFxz/lr14BDvgEPwVBFdGSh+LRsl033JNcmZB60=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        linux-arch@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v3 1/4] iomap: Constify ioreadX() iomem argument (as in generic implementation)
Date:   Thu,  9 Jul 2020 09:28:34 +0200
Message-Id: <20200709072837.5869-2-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200709072837.5869-1-krzk@kernel.org>
References: <20200709072837.5869-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ioreadX() and ioreadX_rep() helpers have inconsistent interface.  On
some architectures void *__iomem address argument is a pointer to const,
on some not.

Implementations of ioreadX() do not modify the memory under the address
so they can be converted to a "const" version for const-safety and
consistency among architectures.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/core_apecs.h   |  6 +--
 arch/alpha/include/asm/core_cia.h     |  6 +--
 arch/alpha/include/asm/core_lca.h     |  6 +--
 arch/alpha/include/asm/core_marvel.h  |  4 +-
 arch/alpha/include/asm/core_mcpcia.h  |  6 +--
 arch/alpha/include/asm/core_t2.h      |  2 +-
 arch/alpha/include/asm/io.h           | 12 ++---
 arch/alpha/include/asm/io_trivial.h   | 16 +++---
 arch/alpha/include/asm/jensen.h       |  2 +-
 arch/alpha/include/asm/machvec.h      |  6 +--
 arch/alpha/kernel/core_marvel.c       |  2 +-
 arch/alpha/kernel/io.c                | 12 ++---
 arch/parisc/include/asm/io.h          |  4 +-
 arch/parisc/lib/iomap.c               | 72 +++++++++++++--------------
 arch/powerpc/kernel/iomap.c           | 28 +++++------
 arch/sh/kernel/iomap.c                | 22 ++++----
 drivers/sh/clk/cpg.c                  |  2 +-
 include/asm-generic/iomap.h           | 28 +++++------
 include/linux/io-64-nonatomic-hi-lo.h |  4 +-
 include/linux/io-64-nonatomic-lo-hi.h |  4 +-
 lib/iomap.c                           | 30 +++++------
 21 files changed, 137 insertions(+), 137 deletions(-)

diff --git a/arch/alpha/include/asm/core_apecs.h b/arch/alpha/include/asm/core_apecs.h
index 0a07055bc0fe..2d9726fc02ef 100644
--- a/arch/alpha/include/asm/core_apecs.h
+++ b/arch/alpha/include/asm/core_apecs.h
@@ -384,7 +384,7 @@ struct el_apecs_procdata
 		}						\
 	} while (0)
 
-__EXTERN_INLINE unsigned int apecs_ioread8(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int apecs_ioread8(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long result, base_and_type;
@@ -420,7 +420,7 @@ __EXTERN_INLINE void apecs_iowrite8(u8 b, void __iomem *xaddr)
 	*(vuip) ((addr << 5) + base_and_type) = w;
 }
 
-__EXTERN_INLINE unsigned int apecs_ioread16(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int apecs_ioread16(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long result, base_and_type;
@@ -456,7 +456,7 @@ __EXTERN_INLINE void apecs_iowrite16(u16 b, void __iomem *xaddr)
 	*(vuip) ((addr << 5) + base_and_type) = w;
 }
 
-__EXTERN_INLINE unsigned int apecs_ioread32(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int apecs_ioread32(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	if (addr < APECS_DENSE_MEM)
diff --git a/arch/alpha/include/asm/core_cia.h b/arch/alpha/include/asm/core_cia.h
index c706a7f2b061..cb22991f6761 100644
--- a/arch/alpha/include/asm/core_cia.h
+++ b/arch/alpha/include/asm/core_cia.h
@@ -342,7 +342,7 @@ struct el_CIA_sysdata_mcheck {
 #define vuip	volatile unsigned int __force *
 #define vulp	volatile unsigned long __force *
 
-__EXTERN_INLINE unsigned int cia_ioread8(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int cia_ioread8(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long result, base_and_type;
@@ -374,7 +374,7 @@ __EXTERN_INLINE void cia_iowrite8(u8 b, void __iomem *xaddr)
 	*(vuip) ((addr << 5) + base_and_type) = w;
 }
 
-__EXTERN_INLINE unsigned int cia_ioread16(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int cia_ioread16(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long result, base_and_type;
@@ -404,7 +404,7 @@ __EXTERN_INLINE void cia_iowrite16(u16 b, void __iomem *xaddr)
 	*(vuip) ((addr << 5) + base_and_type) = w;
 }
 
-__EXTERN_INLINE unsigned int cia_ioread32(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int cia_ioread32(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	if (addr < CIA_DENSE_MEM)
diff --git a/arch/alpha/include/asm/core_lca.h b/arch/alpha/include/asm/core_lca.h
index 84d5e5b84f4f..ec86314418cb 100644
--- a/arch/alpha/include/asm/core_lca.h
+++ b/arch/alpha/include/asm/core_lca.h
@@ -230,7 +230,7 @@ union el_lca {
 	} while (0)
 
 
-__EXTERN_INLINE unsigned int lca_ioread8(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int lca_ioread8(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long result, base_and_type;
@@ -266,7 +266,7 @@ __EXTERN_INLINE void lca_iowrite8(u8 b, void __iomem *xaddr)
 	*(vuip) ((addr << 5) + base_and_type) = w;
 }
 
-__EXTERN_INLINE unsigned int lca_ioread16(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int lca_ioread16(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long result, base_and_type;
@@ -302,7 +302,7 @@ __EXTERN_INLINE void lca_iowrite16(u16 b, void __iomem *xaddr)
 	*(vuip) ((addr << 5) + base_and_type) = w;
 }
 
-__EXTERN_INLINE unsigned int lca_ioread32(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int lca_ioread32(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	if (addr < LCA_DENSE_MEM)
diff --git a/arch/alpha/include/asm/core_marvel.h b/arch/alpha/include/asm/core_marvel.h
index cc6fd92d5fa9..b266e02e284b 100644
--- a/arch/alpha/include/asm/core_marvel.h
+++ b/arch/alpha/include/asm/core_marvel.h
@@ -332,10 +332,10 @@ struct io7 {
 #define vucp	volatile unsigned char __force *
 #define vusp	volatile unsigned short __force *
 
-extern unsigned int marvel_ioread8(void __iomem *);
+extern unsigned int marvel_ioread8(const void __iomem *);
 extern void marvel_iowrite8(u8 b, void __iomem *);
 
-__EXTERN_INLINE unsigned int marvel_ioread16(void __iomem *addr)
+__EXTERN_INLINE unsigned int marvel_ioread16(const void __iomem *addr)
 {
 	return __kernel_ldwu(*(vusp)addr);
 }
diff --git a/arch/alpha/include/asm/core_mcpcia.h b/arch/alpha/include/asm/core_mcpcia.h
index b30dc128210d..cb24d1bd6141 100644
--- a/arch/alpha/include/asm/core_mcpcia.h
+++ b/arch/alpha/include/asm/core_mcpcia.h
@@ -267,7 +267,7 @@ extern inline int __mcpcia_is_mmio(unsigned long addr)
 	return (addr & 0x80000000UL) == 0;
 }
 
-__EXTERN_INLINE unsigned int mcpcia_ioread8(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int mcpcia_ioread8(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long)xaddr & MCPCIA_MEM_MASK;
 	unsigned long hose = (unsigned long)xaddr & ~MCPCIA_MEM_MASK;
@@ -291,7 +291,7 @@ __EXTERN_INLINE void mcpcia_iowrite8(u8 b, void __iomem *xaddr)
 	*(vuip) ((addr << 5) + hose + 0x00) = w;
 }
 
-__EXTERN_INLINE unsigned int mcpcia_ioread16(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int mcpcia_ioread16(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long)xaddr & MCPCIA_MEM_MASK;
 	unsigned long hose = (unsigned long)xaddr & ~MCPCIA_MEM_MASK;
@@ -315,7 +315,7 @@ __EXTERN_INLINE void mcpcia_iowrite16(u16 b, void __iomem *xaddr)
 	*(vuip) ((addr << 5) + hose + 0x08) = w;
 }
 
-__EXTERN_INLINE unsigned int mcpcia_ioread32(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int mcpcia_ioread32(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long)xaddr;
 
diff --git a/arch/alpha/include/asm/core_t2.h b/arch/alpha/include/asm/core_t2.h
index e0b33d09e93a..12bb7addc789 100644
--- a/arch/alpha/include/asm/core_t2.h
+++ b/arch/alpha/include/asm/core_t2.h
@@ -572,7 +572,7 @@ __EXTERN_INLINE int t2_is_mmio(const volatile void __iomem *addr)
    it doesn't make sense to merge the pio and mmio routines.  */
 
 #define IOPORT(OS, NS)							\
-__EXTERN_INLINE unsigned int t2_ioread##NS(void __iomem *xaddr)		\
+__EXTERN_INLINE unsigned int t2_ioread##NS(const void __iomem *xaddr)		\
 {									\
 	if (t2_is_mmio(xaddr))						\
 		return t2_read##OS(xaddr);				\
diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 640e1a2f57b4..1f6a909d1fa5 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -150,9 +150,9 @@ static inline void generic_##NAME(TYPE b, QUAL void __iomem *addr)	\
 	alpha_mv.mv_##NAME(b, addr);					\
 }
 
-REMAP1(unsigned int, ioread8, /**/)
-REMAP1(unsigned int, ioread16, /**/)
-REMAP1(unsigned int, ioread32, /**/)
+REMAP1(unsigned int, ioread8, const)
+REMAP1(unsigned int, ioread16, const)
+REMAP1(unsigned int, ioread32, const)
 REMAP1(u8, readb, const volatile)
 REMAP1(u16, readw, const volatile)
 REMAP1(u32, readl, const volatile)
@@ -307,7 +307,7 @@ static inline int __is_mmio(const volatile void __iomem *addr)
  */
 
 #if IO_CONCAT(__IO_PREFIX,trivial_io_bw)
-extern inline unsigned int ioread8(void __iomem *addr)
+extern inline unsigned int ioread8(const void __iomem *addr)
 {
 	unsigned int ret;
 	mb();
@@ -316,7 +316,7 @@ extern inline unsigned int ioread8(void __iomem *addr)
 	return ret;
 }
 
-extern inline unsigned int ioread16(void __iomem *addr)
+extern inline unsigned int ioread16(const void __iomem *addr)
 {
 	unsigned int ret;
 	mb();
@@ -359,7 +359,7 @@ extern inline void outw(u16 b, unsigned long port)
 #endif
 
 #if IO_CONCAT(__IO_PREFIX,trivial_io_lq)
-extern inline unsigned int ioread32(void __iomem *addr)
+extern inline unsigned int ioread32(const void __iomem *addr)
 {
 	unsigned int ret;
 	mb();
diff --git a/arch/alpha/include/asm/io_trivial.h b/arch/alpha/include/asm/io_trivial.h
index ba3d8f0cfe0c..a1a29cbe02fa 100644
--- a/arch/alpha/include/asm/io_trivial.h
+++ b/arch/alpha/include/asm/io_trivial.h
@@ -7,15 +7,15 @@
 
 #if IO_CONCAT(__IO_PREFIX,trivial_io_bw)
 __EXTERN_INLINE unsigned int
-IO_CONCAT(__IO_PREFIX,ioread8)(void __iomem *a)
+IO_CONCAT(__IO_PREFIX,ioread8)(const void __iomem *a)
 {
-	return __kernel_ldbu(*(volatile u8 __force *)a);
+	return __kernel_ldbu(*(const volatile u8 __force *)a);
 }
 
 __EXTERN_INLINE unsigned int
-IO_CONCAT(__IO_PREFIX,ioread16)(void __iomem *a)
+IO_CONCAT(__IO_PREFIX,ioread16)(const void __iomem *a)
 {
-	return __kernel_ldwu(*(volatile u16 __force *)a);
+	return __kernel_ldwu(*(const volatile u16 __force *)a);
 }
 
 __EXTERN_INLINE void
@@ -33,9 +33,9 @@ IO_CONCAT(__IO_PREFIX,iowrite16)(u16 b, void __iomem *a)
 
 #if IO_CONCAT(__IO_PREFIX,trivial_io_lq)
 __EXTERN_INLINE unsigned int
-IO_CONCAT(__IO_PREFIX,ioread32)(void __iomem *a)
+IO_CONCAT(__IO_PREFIX,ioread32)(const void __iomem *a)
 {
-	return *(volatile u32 __force *)a;
+	return *(const volatile u32 __force *)a;
 }
 
 __EXTERN_INLINE void
@@ -73,14 +73,14 @@ IO_CONCAT(__IO_PREFIX,writew)(u16 b, volatile void __iomem *a)
 __EXTERN_INLINE u8
 IO_CONCAT(__IO_PREFIX,readb)(const volatile void __iomem *a)
 {
-	void __iomem *addr = (void __iomem *)a;
+	const void __iomem *addr = (const void __iomem *)a;
 	return IO_CONCAT(__IO_PREFIX,ioread8)(addr);
 }
 
 __EXTERN_INLINE u16
 IO_CONCAT(__IO_PREFIX,readw)(const volatile void __iomem *a)
 {
-	void __iomem *addr = (void __iomem *)a;
+	const void __iomem *addr = (const void __iomem *)a;
 	return IO_CONCAT(__IO_PREFIX,ioread16)(addr);
 }
 
diff --git a/arch/alpha/include/asm/jensen.h b/arch/alpha/include/asm/jensen.h
index 436dc905b6ad..916895155a88 100644
--- a/arch/alpha/include/asm/jensen.h
+++ b/arch/alpha/include/asm/jensen.h
@@ -305,7 +305,7 @@ __EXTERN_INLINE int jensen_is_mmio(const volatile void __iomem *addr)
    that it doesn't make sense to merge them.  */
 
 #define IOPORT(OS, NS)							\
-__EXTERN_INLINE unsigned int jensen_ioread##NS(void __iomem *xaddr)	\
+__EXTERN_INLINE unsigned int jensen_ioread##NS(const void __iomem *xaddr)	\
 {									\
 	if (jensen_is_mmio(xaddr))					\
 		return jensen_read##OS(xaddr - 0x100000000ul);		\
diff --git a/arch/alpha/include/asm/machvec.h b/arch/alpha/include/asm/machvec.h
index a6b73c6d10ee..a4e96e2bec74 100644
--- a/arch/alpha/include/asm/machvec.h
+++ b/arch/alpha/include/asm/machvec.h
@@ -46,9 +46,9 @@ struct alpha_machine_vector
 	void (*mv_pci_tbi)(struct pci_controller *hose,
 			   dma_addr_t start, dma_addr_t end);
 
-	unsigned int (*mv_ioread8)(void __iomem *);
-	unsigned int (*mv_ioread16)(void __iomem *);
-	unsigned int (*mv_ioread32)(void __iomem *);
+	unsigned int (*mv_ioread8)(const void __iomem *);
+	unsigned int (*mv_ioread16)(const void __iomem *);
+	unsigned int (*mv_ioread32)(const void __iomem *);
 
 	void (*mv_iowrite8)(u8, void __iomem *);
 	void (*mv_iowrite16)(u16, void __iomem *);
diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index 4c80d992a659..4485b77f8658 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -806,7 +806,7 @@ void __iomem *marvel_ioportmap (unsigned long addr)
 }
 
 unsigned int
-marvel_ioread8(void __iomem *xaddr)
+marvel_ioread8(const void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	if (__marvel_is_port_kbd(addr))
diff --git a/arch/alpha/kernel/io.c b/arch/alpha/kernel/io.c
index 938de13adfbf..838586abb1e0 100644
--- a/arch/alpha/kernel/io.c
+++ b/arch/alpha/kernel/io.c
@@ -14,7 +14,7 @@
    "generic", which bumps through the machine vector.  */
 
 unsigned int
-ioread8(void __iomem *addr)
+ioread8(const void __iomem *addr)
 {
 	unsigned int ret;
 	mb();
@@ -23,7 +23,7 @@ ioread8(void __iomem *addr)
 	return ret;
 }
 
-unsigned int ioread16(void __iomem *addr)
+unsigned int ioread16(const void __iomem *addr)
 {
 	unsigned int ret;
 	mb();
@@ -32,7 +32,7 @@ unsigned int ioread16(void __iomem *addr)
 	return ret;
 }
 
-unsigned int ioread32(void __iomem *addr)
+unsigned int ioread32(const void __iomem *addr)
 {
 	unsigned int ret;
 	mb();
@@ -257,7 +257,7 @@ EXPORT_SYMBOL(readq_relaxed);
 /*
  * Read COUNT 8-bit bytes from port PORT into memory starting at SRC.
  */
-void ioread8_rep(void __iomem *port, void *dst, unsigned long count)
+void ioread8_rep(const void __iomem *port, void *dst, unsigned long count)
 {
 	while ((unsigned long)dst & 0x3) {
 		if (!count)
@@ -300,7 +300,7 @@ EXPORT_SYMBOL(insb);
  * the interfaces seems to be slow: just using the inlined version
  * of the inw() breaks things.
  */
-void ioread16_rep(void __iomem *port, void *dst, unsigned long count)
+void ioread16_rep(const void __iomem *port, void *dst, unsigned long count)
 {
 	if (unlikely((unsigned long)dst & 0x3)) {
 		if (!count)
@@ -340,7 +340,7 @@ EXPORT_SYMBOL(insw);
  * but the interfaces seems to be slow: just using the inlined version
  * of the inl() breaks things.
  */
-void ioread32_rep(void __iomem *port, void *dst, unsigned long count)
+void ioread32_rep(const void __iomem *port, void *dst, unsigned long count)
 {
 	if (unlikely((unsigned long)dst & 0x3)) {
 		while (count--) {
diff --git a/arch/parisc/include/asm/io.h b/arch/parisc/include/asm/io.h
index 116effe26143..45e20d38dc59 100644
--- a/arch/parisc/include/asm/io.h
+++ b/arch/parisc/include/asm/io.h
@@ -303,8 +303,8 @@ extern void outsl (unsigned long port, const void *src, unsigned long count);
 #define ioread64be ioread64be
 #define iowrite64 iowrite64
 #define iowrite64be iowrite64be
-extern u64 ioread64(void __iomem *addr);
-extern u64 ioread64be(void __iomem *addr);
+extern u64 ioread64(const void __iomem *addr);
+extern u64 ioread64be(const void __iomem *addr);
 extern void iowrite64(u64 val, void __iomem *addr);
 extern void iowrite64be(u64 val, void __iomem *addr);
 
diff --git a/arch/parisc/lib/iomap.c b/arch/parisc/lib/iomap.c
index 0195aec657e2..ce400417d54e 100644
--- a/arch/parisc/lib/iomap.c
+++ b/arch/parisc/lib/iomap.c
@@ -43,13 +43,13 @@
 #endif
 
 struct iomap_ops {
-	unsigned int (*read8)(void __iomem *);
-	unsigned int (*read16)(void __iomem *);
-	unsigned int (*read16be)(void __iomem *);
-	unsigned int (*read32)(void __iomem *);
-	unsigned int (*read32be)(void __iomem *);
-	u64 (*read64)(void __iomem *);
-	u64 (*read64be)(void __iomem *);
+	unsigned int (*read8)(const void __iomem *);
+	unsigned int (*read16)(const void __iomem *);
+	unsigned int (*read16be)(const void __iomem *);
+	unsigned int (*read32)(const void __iomem *);
+	unsigned int (*read32be)(const void __iomem *);
+	u64 (*read64)(const void __iomem *);
+	u64 (*read64be)(const void __iomem *);
 	void (*write8)(u8, void __iomem *);
 	void (*write16)(u16, void __iomem *);
 	void (*write16be)(u16, void __iomem *);
@@ -57,9 +57,9 @@ struct iomap_ops {
 	void (*write32be)(u32, void __iomem *);
 	void (*write64)(u64, void __iomem *);
 	void (*write64be)(u64, void __iomem *);
-	void (*read8r)(void __iomem *, void *, unsigned long);
-	void (*read16r)(void __iomem *, void *, unsigned long);
-	void (*read32r)(void __iomem *, void *, unsigned long);
+	void (*read8r)(const void __iomem *, void *, unsigned long);
+	void (*read16r)(const void __iomem *, void *, unsigned long);
+	void (*read32r)(const void __iomem *, void *, unsigned long);
 	void (*write8r)(void __iomem *, const void *, unsigned long);
 	void (*write16r)(void __iomem *, const void *, unsigned long);
 	void (*write32r)(void __iomem *, const void *, unsigned long);
@@ -69,17 +69,17 @@ struct iomap_ops {
 
 #define ADDR2PORT(addr) ((unsigned long __force)(addr) & 0xffffff)
 
-static unsigned int ioport_read8(void __iomem *addr)
+static unsigned int ioport_read8(const void __iomem *addr)
 {
 	return inb(ADDR2PORT(addr));
 }
 
-static unsigned int ioport_read16(void __iomem *addr)
+static unsigned int ioport_read16(const void __iomem *addr)
 {
 	return inw(ADDR2PORT(addr));
 }
 
-static unsigned int ioport_read32(void __iomem *addr)
+static unsigned int ioport_read32(const void __iomem *addr)
 {
 	return inl(ADDR2PORT(addr));
 }
@@ -99,17 +99,17 @@ static void ioport_write32(u32 datum, void __iomem *addr)
 	outl(datum, ADDR2PORT(addr));
 }
 
-static void ioport_read8r(void __iomem *addr, void *dst, unsigned long count)
+static void ioport_read8r(const void __iomem *addr, void *dst, unsigned long count)
 {
 	insb(ADDR2PORT(addr), dst, count);
 }
 
-static void ioport_read16r(void __iomem *addr, void *dst, unsigned long count)
+static void ioport_read16r(const void __iomem *addr, void *dst, unsigned long count)
 {
 	insw(ADDR2PORT(addr), dst, count);
 }
 
-static void ioport_read32r(void __iomem *addr, void *dst, unsigned long count)
+static void ioport_read32r(const void __iomem *addr, void *dst, unsigned long count)
 {
 	insl(ADDR2PORT(addr), dst, count);
 }
@@ -150,37 +150,37 @@ static const struct iomap_ops ioport_ops = {
 
 /* Legacy I/O memory ops */
 
-static unsigned int iomem_read8(void __iomem *addr)
+static unsigned int iomem_read8(const void __iomem *addr)
 {
 	return readb(addr);
 }
 
-static unsigned int iomem_read16(void __iomem *addr)
+static unsigned int iomem_read16(const void __iomem *addr)
 {
 	return readw(addr);
 }
 
-static unsigned int iomem_read16be(void __iomem *addr)
+static unsigned int iomem_read16be(const void __iomem *addr)
 {
 	return __raw_readw(addr);
 }
 
-static unsigned int iomem_read32(void __iomem *addr)
+static unsigned int iomem_read32(const void __iomem *addr)
 {
 	return readl(addr);
 }
 
-static unsigned int iomem_read32be(void __iomem *addr)
+static unsigned int iomem_read32be(const void __iomem *addr)
 {
 	return __raw_readl(addr);
 }
 
-static u64 iomem_read64(void __iomem *addr)
+static u64 iomem_read64(const void __iomem *addr)
 {
 	return readq(addr);
 }
 
-static u64 iomem_read64be(void __iomem *addr)
+static u64 iomem_read64be(const void __iomem *addr)
 {
 	return __raw_readq(addr);
 }
@@ -220,7 +220,7 @@ static void iomem_write64be(u64 datum, void __iomem *addr)
 	__raw_writel(datum, addr);
 }
 
-static void iomem_read8r(void __iomem *addr, void *dst, unsigned long count)
+static void iomem_read8r(const void __iomem *addr, void *dst, unsigned long count)
 {
 	while (count--) {
 		*(u8 *)dst = __raw_readb(addr);
@@ -228,7 +228,7 @@ static void iomem_read8r(void __iomem *addr, void *dst, unsigned long count)
 	}
 }
 
-static void iomem_read16r(void __iomem *addr, void *dst, unsigned long count)
+static void iomem_read16r(const void __iomem *addr, void *dst, unsigned long count)
 {
 	while (count--) {
 		*(u16 *)dst = __raw_readw(addr);
@@ -236,7 +236,7 @@ static void iomem_read16r(void __iomem *addr, void *dst, unsigned long count)
 	}
 }
 
-static void iomem_read32r(void __iomem *addr, void *dst, unsigned long count)
+static void iomem_read32r(const void __iomem *addr, void *dst, unsigned long count)
 {
 	while (count--) {
 		*(u32 *)dst = __raw_readl(addr);
@@ -297,49 +297,49 @@ static const struct iomap_ops *iomap_ops[8] = {
 };
 
 
-unsigned int ioread8(void __iomem *addr)
+unsigned int ioread8(const void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read8(addr);
 	return *((u8 *)addr);
 }
 
-unsigned int ioread16(void __iomem *addr)
+unsigned int ioread16(const void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read16(addr);
 	return le16_to_cpup((u16 *)addr);
 }
 
-unsigned int ioread16be(void __iomem *addr)
+unsigned int ioread16be(const void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read16be(addr);
 	return *((u16 *)addr);
 }
 
-unsigned int ioread32(void __iomem *addr)
+unsigned int ioread32(const void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read32(addr);
 	return le32_to_cpup((u32 *)addr);
 }
 
-unsigned int ioread32be(void __iomem *addr)
+unsigned int ioread32be(const void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read32be(addr);
 	return *((u32 *)addr);
 }
 
-u64 ioread64(void __iomem *addr)
+u64 ioread64(const void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read64(addr);
 	return le64_to_cpup((u64 *)addr);
 }
 
-u64 ioread64be(void __iomem *addr)
+u64 ioread64be(const void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read64be(addr);
@@ -411,7 +411,7 @@ void iowrite64be(u64 datum, void __iomem *addr)
 
 /* Repeating interfaces */
 
-void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread8_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	if (unlikely(INDIRECT_ADDR(addr))) {
 		iomap_ops[ADDR_TO_REGION(addr)]->read8r(addr, dst, count);
@@ -423,7 +423,7 @@ void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
 	}
 }
 
-void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread16_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	if (unlikely(INDIRECT_ADDR(addr))) {
 		iomap_ops[ADDR_TO_REGION(addr)]->read16r(addr, dst, count);
@@ -435,7 +435,7 @@ void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
 	}
 }
 
-void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread32_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	if (unlikely(INDIRECT_ADDR(addr))) {
 		iomap_ops[ADDR_TO_REGION(addr)]->read32r(addr, dst, count);
diff --git a/arch/powerpc/kernel/iomap.c b/arch/powerpc/kernel/iomap.c
index 5ac84efc6ede..9fe4fb3b08aa 100644
--- a/arch/powerpc/kernel/iomap.c
+++ b/arch/powerpc/kernel/iomap.c
@@ -15,23 +15,23 @@
  * Here comes the ppc64 implementation of the IOMAP 
  * interfaces.
  */
-unsigned int ioread8(void __iomem *addr)
+unsigned int ioread8(const void __iomem *addr)
 {
 	return readb(addr);
 }
-unsigned int ioread16(void __iomem *addr)
+unsigned int ioread16(const void __iomem *addr)
 {
 	return readw(addr);
 }
-unsigned int ioread16be(void __iomem *addr)
+unsigned int ioread16be(const void __iomem *addr)
 {
 	return readw_be(addr);
 }
-unsigned int ioread32(void __iomem *addr)
+unsigned int ioread32(const void __iomem *addr)
 {
 	return readl(addr);
 }
-unsigned int ioread32be(void __iomem *addr)
+unsigned int ioread32be(const void __iomem *addr)
 {
 	return readl_be(addr);
 }
@@ -41,27 +41,27 @@ EXPORT_SYMBOL(ioread16be);
 EXPORT_SYMBOL(ioread32);
 EXPORT_SYMBOL(ioread32be);
 #ifdef __powerpc64__
-u64 ioread64(void __iomem *addr)
+u64 ioread64(const void __iomem *addr)
 {
 	return readq(addr);
 }
-u64 ioread64_lo_hi(void __iomem *addr)
+u64 ioread64_lo_hi(const void __iomem *addr)
 {
 	return readq(addr);
 }
-u64 ioread64_hi_lo(void __iomem *addr)
+u64 ioread64_hi_lo(const void __iomem *addr)
 {
 	return readq(addr);
 }
-u64 ioread64be(void __iomem *addr)
+u64 ioread64be(const void __iomem *addr)
 {
 	return readq_be(addr);
 }
-u64 ioread64be_lo_hi(void __iomem *addr)
+u64 ioread64be_lo_hi(const void __iomem *addr)
 {
 	return readq_be(addr);
 }
-u64 ioread64be_hi_lo(void __iomem *addr)
+u64 ioread64be_hi_lo(const void __iomem *addr)
 {
 	return readq_be(addr);
 }
@@ -139,15 +139,15 @@ EXPORT_SYMBOL(iowrite64be_hi_lo);
  * FIXME! We could make these do EEH handling if we really
  * wanted. Not clear if we do.
  */
-void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread8_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	readsb(addr, dst, count);
 }
-void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread16_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	readsw(addr, dst, count);
 }
-void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread32_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	readsl(addr, dst, count);
 }
diff --git a/arch/sh/kernel/iomap.c b/arch/sh/kernel/iomap.c
index ef9e2c97cbb7..0a0dff4e66de 100644
--- a/arch/sh/kernel/iomap.c
+++ b/arch/sh/kernel/iomap.c
@@ -8,31 +8,31 @@
 #include <linux/module.h>
 #include <linux/io.h>
 
-unsigned int ioread8(void __iomem *addr)
+unsigned int ioread8(const void __iomem *addr)
 {
 	return readb(addr);
 }
 EXPORT_SYMBOL(ioread8);
 
-unsigned int ioread16(void __iomem *addr)
+unsigned int ioread16(const void __iomem *addr)
 {
 	return readw(addr);
 }
 EXPORT_SYMBOL(ioread16);
 
-unsigned int ioread16be(void __iomem *addr)
+unsigned int ioread16be(const void __iomem *addr)
 {
 	return be16_to_cpu(__raw_readw(addr));
 }
 EXPORT_SYMBOL(ioread16be);
 
-unsigned int ioread32(void __iomem *addr)
+unsigned int ioread32(const void __iomem *addr)
 {
 	return readl(addr);
 }
 EXPORT_SYMBOL(ioread32);
 
-unsigned int ioread32be(void __iomem *addr)
+unsigned int ioread32be(const void __iomem *addr)
 {
 	return be32_to_cpu(__raw_readl(addr));
 }
@@ -74,7 +74,7 @@ EXPORT_SYMBOL(iowrite32be);
  * convert to CPU byte order. We write in "IO byte
  * order" (we also don't have IO barriers).
  */
-static inline void mmio_insb(void __iomem *addr, u8 *dst, int count)
+static inline void mmio_insb(const void __iomem *addr, u8 *dst, int count)
 {
 	while (--count >= 0) {
 		u8 data = __raw_readb(addr);
@@ -83,7 +83,7 @@ static inline void mmio_insb(void __iomem *addr, u8 *dst, int count)
 	}
 }
 
-static inline void mmio_insw(void __iomem *addr, u16 *dst, int count)
+static inline void mmio_insw(const void __iomem *addr, u16 *dst, int count)
 {
 	while (--count >= 0) {
 		u16 data = __raw_readw(addr);
@@ -92,7 +92,7 @@ static inline void mmio_insw(void __iomem *addr, u16 *dst, int count)
 	}
 }
 
-static inline void mmio_insl(void __iomem *addr, u32 *dst, int count)
+static inline void mmio_insl(const void __iomem *addr, u32 *dst, int count)
 {
 	while (--count >= 0) {
 		u32 data = __raw_readl(addr);
@@ -125,19 +125,19 @@ static inline void mmio_outsl(void __iomem *addr, const u32 *src, int count)
 	}
 }
 
-void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread8_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	mmio_insb(addr, dst, count);
 }
 EXPORT_SYMBOL(ioread8_rep);
 
-void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread16_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	mmio_insw(addr, dst, count);
 }
 EXPORT_SYMBOL(ioread16_rep);
 
-void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread32_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	mmio_insl(addr, dst, count);
 }
diff --git a/drivers/sh/clk/cpg.c b/drivers/sh/clk/cpg.c
index a5cacfe24a42..fd72d9088bdc 100644
--- a/drivers/sh/clk/cpg.c
+++ b/drivers/sh/clk/cpg.c
@@ -40,7 +40,7 @@ static int sh_clk_mstp_enable(struct clk *clk)
 {
 	sh_clk_write(sh_clk_read(clk) & ~(1 << clk->enable_bit), clk);
 	if (clk->status_reg) {
-		unsigned int (*read)(void __iomem *addr);
+		unsigned int (*read)(const void __iomem *addr);
 		int i;
 		void __iomem *mapped_status = (phys_addr_t)clk->status_reg -
 			(phys_addr_t)clk->enable_reg + clk->mapped_reg;
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 9d28a5e82f73..649224664969 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -26,14 +26,14 @@
  * in the low address range. Architectures for which this is not
  * true can't use this generic implementation.
  */
-extern unsigned int ioread8(void __iomem *);
-extern unsigned int ioread16(void __iomem *);
-extern unsigned int ioread16be(void __iomem *);
-extern unsigned int ioread32(void __iomem *);
-extern unsigned int ioread32be(void __iomem *);
+extern unsigned int ioread8(const void __iomem *);
+extern unsigned int ioread16(const void __iomem *);
+extern unsigned int ioread16be(const void __iomem *);
+extern unsigned int ioread32(const void __iomem *);
+extern unsigned int ioread32be(const void __iomem *);
 #ifdef CONFIG_64BIT
-extern u64 ioread64(void __iomem *);
-extern u64 ioread64be(void __iomem *);
+extern u64 ioread64(const void __iomem *);
+extern u64 ioread64be(const void __iomem *);
 #endif
 
 #ifdef readq
@@ -41,10 +41,10 @@ extern u64 ioread64be(void __iomem *);
 #define ioread64_hi_lo ioread64_hi_lo
 #define ioread64be_lo_hi ioread64be_lo_hi
 #define ioread64be_hi_lo ioread64be_hi_lo
-extern u64 ioread64_lo_hi(void __iomem *addr);
-extern u64 ioread64_hi_lo(void __iomem *addr);
-extern u64 ioread64be_lo_hi(void __iomem *addr);
-extern u64 ioread64be_hi_lo(void __iomem *addr);
+extern u64 ioread64_lo_hi(const void __iomem *addr);
+extern u64 ioread64_hi_lo(const void __iomem *addr);
+extern u64 ioread64be_lo_hi(const void __iomem *addr);
+extern u64 ioread64be_hi_lo(const void __iomem *addr);
 #endif
 
 extern void iowrite8(u8, void __iomem *);
@@ -79,9 +79,9 @@ extern void iowrite64be_hi_lo(u64 val, void __iomem *addr);
  * memory across multiple ports, use "memcpy_toio()"
  * and friends.
  */
-extern void ioread8_rep(void __iomem *port, void *buf, unsigned long count);
-extern void ioread16_rep(void __iomem *port, void *buf, unsigned long count);
-extern void ioread32_rep(void __iomem *port, void *buf, unsigned long count);
+extern void ioread8_rep(const void __iomem *port, void *buf, unsigned long count);
+extern void ioread16_rep(const void __iomem *port, void *buf, unsigned long count);
+extern void ioread32_rep(const void __iomem *port, void *buf, unsigned long count);
 
 extern void iowrite8_rep(void __iomem *port, const void *buf, unsigned long count);
 extern void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
diff --git a/include/linux/io-64-nonatomic-hi-lo.h b/include/linux/io-64-nonatomic-hi-lo.h
index ae21b72cce85..f32522bb3aa5 100644
--- a/include/linux/io-64-nonatomic-hi-lo.h
+++ b/include/linux/io-64-nonatomic-hi-lo.h
@@ -57,7 +57,7 @@ static inline void hi_lo_writeq_relaxed(__u64 val, volatile void __iomem *addr)
 
 #ifndef ioread64_hi_lo
 #define ioread64_hi_lo ioread64_hi_lo
-static inline u64 ioread64_hi_lo(void __iomem *addr)
+static inline u64 ioread64_hi_lo(const void __iomem *addr)
 {
 	u32 low, high;
 
@@ -79,7 +79,7 @@ static inline void iowrite64_hi_lo(u64 val, void __iomem *addr)
 
 #ifndef ioread64be_hi_lo
 #define ioread64be_hi_lo ioread64be_hi_lo
-static inline u64 ioread64be_hi_lo(void __iomem *addr)
+static inline u64 ioread64be_hi_lo(const void __iomem *addr)
 {
 	u32 low, high;
 
diff --git a/include/linux/io-64-nonatomic-lo-hi.h b/include/linux/io-64-nonatomic-lo-hi.h
index faaa842dbdb9..448a21435dba 100644
--- a/include/linux/io-64-nonatomic-lo-hi.h
+++ b/include/linux/io-64-nonatomic-lo-hi.h
@@ -57,7 +57,7 @@ static inline void lo_hi_writeq_relaxed(__u64 val, volatile void __iomem *addr)
 
 #ifndef ioread64_lo_hi
 #define ioread64_lo_hi ioread64_lo_hi
-static inline u64 ioread64_lo_hi(void __iomem *addr)
+static inline u64 ioread64_lo_hi(const void __iomem *addr)
 {
 	u32 low, high;
 
@@ -79,7 +79,7 @@ static inline void iowrite64_lo_hi(u64 val, void __iomem *addr)
 
 #ifndef ioread64be_lo_hi
 #define ioread64be_lo_hi ioread64be_lo_hi
-static inline u64 ioread64be_lo_hi(void __iomem *addr)
+static inline u64 ioread64be_lo_hi(const void __iomem *addr)
 {
 	u32 low, high;
 
diff --git a/lib/iomap.c b/lib/iomap.c
index e909ab71e995..fbaa3e8f19d6 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -70,27 +70,27 @@ static void bad_io_access(unsigned long port, const char *access)
 #define mmio_read64be(addr) swab64(readq(addr))
 #endif
 
-unsigned int ioread8(void __iomem *addr)
+unsigned int ioread8(const void __iomem *addr)
 {
 	IO_COND(addr, return inb(port), return readb(addr));
 	return 0xff;
 }
-unsigned int ioread16(void __iomem *addr)
+unsigned int ioread16(const void __iomem *addr)
 {
 	IO_COND(addr, return inw(port), return readw(addr));
 	return 0xffff;
 }
-unsigned int ioread16be(void __iomem *addr)
+unsigned int ioread16be(const void __iomem *addr)
 {
 	IO_COND(addr, return pio_read16be(port), return mmio_read16be(addr));
 	return 0xffff;
 }
-unsigned int ioread32(void __iomem *addr)
+unsigned int ioread32(const void __iomem *addr)
 {
 	IO_COND(addr, return inl(port), return readl(addr));
 	return 0xffffffff;
 }
-unsigned int ioread32be(void __iomem *addr)
+unsigned int ioread32be(const void __iomem *addr)
 {
 	IO_COND(addr, return pio_read32be(port), return mmio_read32be(addr));
 	return 0xffffffff;
@@ -142,26 +142,26 @@ static u64 pio_read64be_hi_lo(unsigned long port)
 	return lo | (hi << 32);
 }
 
-u64 ioread64_lo_hi(void __iomem *addr)
+u64 ioread64_lo_hi(const void __iomem *addr)
 {
 	IO_COND(addr, return pio_read64_lo_hi(port), return readq(addr));
 	return 0xffffffffffffffffULL;
 }
 
-u64 ioread64_hi_lo(void __iomem *addr)
+u64 ioread64_hi_lo(const void __iomem *addr)
 {
 	IO_COND(addr, return pio_read64_hi_lo(port), return readq(addr));
 	return 0xffffffffffffffffULL;
 }
 
-u64 ioread64be_lo_hi(void __iomem *addr)
+u64 ioread64be_lo_hi(const void __iomem *addr)
 {
 	IO_COND(addr, return pio_read64be_lo_hi(port),
 		return mmio_read64be(addr));
 	return 0xffffffffffffffffULL;
 }
 
-u64 ioread64be_hi_lo(void __iomem *addr)
+u64 ioread64be_hi_lo(const void __iomem *addr)
 {
 	IO_COND(addr, return pio_read64be_hi_lo(port),
 		return mmio_read64be(addr));
@@ -275,7 +275,7 @@ EXPORT_SYMBOL(iowrite64be_hi_lo);
  * order" (we also don't have IO barriers).
  */
 #ifndef mmio_insb
-static inline void mmio_insb(void __iomem *addr, u8 *dst, int count)
+static inline void mmio_insb(const void __iomem *addr, u8 *dst, int count)
 {
 	while (--count >= 0) {
 		u8 data = __raw_readb(addr);
@@ -283,7 +283,7 @@ static inline void mmio_insb(void __iomem *addr, u8 *dst, int count)
 		dst++;
 	}
 }
-static inline void mmio_insw(void __iomem *addr, u16 *dst, int count)
+static inline void mmio_insw(const void __iomem *addr, u16 *dst, int count)
 {
 	while (--count >= 0) {
 		u16 data = __raw_readw(addr);
@@ -291,7 +291,7 @@ static inline void mmio_insw(void __iomem *addr, u16 *dst, int count)
 		dst++;
 	}
 }
-static inline void mmio_insl(void __iomem *addr, u32 *dst, int count)
+static inline void mmio_insl(const void __iomem *addr, u32 *dst, int count)
 {
 	while (--count >= 0) {
 		u32 data = __raw_readl(addr);
@@ -325,15 +325,15 @@ static inline void mmio_outsl(void __iomem *addr, const u32 *src, int count)
 }
 #endif
 
-void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread8_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insb(port,dst,count), mmio_insb(addr, dst, count));
 }
-void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread16_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insw(port,dst,count), mmio_insw(addr, dst, count));
 }
-void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread32_rep(const void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insl(port,dst,count), mmio_insl(addr, dst, count));
 }
-- 
2.17.1

