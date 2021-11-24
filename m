Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5B845B2D1
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 04:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240896AbhKXDxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 22:53:35 -0500
Received: from mail.loongson.cn ([114.242.206.163]:58056 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240891AbhKXDxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 22:53:33 -0500
Received: from localhost.localdomain (unknown [111.9.175.10])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxeNJ3tp1hx9oAAA--.1299S3;
        Wed, 24 Nov 2021 11:50:21 +0800 (CST)
From:   Huang Pei <huangpei@loongson.cn>
To:     netdev@vger.kernel.org, ambrosehua@gmail.com
Cc:     linux-arch@vger.kernel.org
Subject: [PATCH 1/4] MIPS: rework local_t operation on MIPS64
Date:   Wed, 24 Nov 2021 11:50:01 +0800
Message-Id: <20211124035004.7871-2-huangpei@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211124035004.7871-1-huangpei@loongson.cn>
References: <20211124035004.7871-1-huangpei@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxeNJ3tp1hx9oAAA--.1299S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1ktrW5Ww4UArWrCFW7Arb_yoWrurWrpF
        srCan7KrWqvF4fA3Z7ZF4Svr13Wr4fGrWYkF1qvrWvy3W8t3W8ZrZ3KanYyrykZFZ8X3W8
        XFW7ur15X3ZrA3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBFb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv
        6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
        Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
        6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF04k20xvY0x
        0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
        7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcV
        C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
        CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07brkucUUUUU=
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+. use "daddu/dsubu" for long int on MIPS64 instead of "addu/subu"

+. remove "asm/war.h" since R10000_LLSC_WAR became a config option

+. clean up

Suggested-by:  "Maciej W. Rozycki" <macro@orcam.me.uk>
Signed-off-by: Huang Pei <huangpei@loongson.cn>
---
 arch/mips/include/asm/asm.h   | 18 ++++++++++
 arch/mips/include/asm/local.h | 62 +++++++++--------------------------
 2 files changed, 33 insertions(+), 47 deletions(-)

diff --git a/arch/mips/include/asm/asm.h b/arch/mips/include/asm/asm.h
index 2f8ce94ebaaf..f3302b13d3e0 100644
--- a/arch/mips/include/asm/asm.h
+++ b/arch/mips/include/asm/asm.h
@@ -19,6 +19,7 @@
 
 #include <asm/sgidefs.h>
 #include <asm/asm-eva.h>
+#include <asm/isa-rev.h>
 
 #ifndef __VDSO__
 /*
@@ -211,6 +212,8 @@ symbol		=	value
 #define LONG_SUB	sub
 #define LONG_SUBU	subu
 #define LONG_L		lw
+#define LONG_LL		ll
+#define LONG_SC		sc
 #define LONG_S		sw
 #define LONG_SP		swp
 #define LONG_SLL	sll
@@ -236,6 +239,8 @@ symbol		=	value
 #define LONG_SUB	dsub
 #define LONG_SUBU	dsubu
 #define LONG_L		ld
+#define LONG_LL		lld
+#define LONG_SC		scd
 #define LONG_S		sd
 #define LONG_SP		sdp
 #define LONG_SLL	dsll
@@ -320,6 +325,19 @@ symbol		=	value
 
 #define SSNOP		sll zero, zero, 1
 
+/*
+ * Using a branch-likely instruction to check the result of an sc instruction
+ * works around a bug present in R10000 CPUs prior to revision 3.0 that could
+ * cause ll-sc sequences to execute non-atomically.
+ */
+#ifdef CONFIG_WAR_R10000_LLSC
+# define SC_BEQZ	beqzl
+#elif MIPS_ISA_REV >= 6
+# define SC_BEQZ	beqzc
+#else
+# define SC_BEQZ	beqz
+#endif
+
 #ifdef CONFIG_SGI_IP28
 /* Inhibit speculative stores to volatile (e.g.DMA) or invalid addresses. */
 #include <asm/cacheops.h>
diff --git a/arch/mips/include/asm/local.h b/arch/mips/include/asm/local.h
index ecda7295ddcd..c1e109357110 100644
--- a/arch/mips/include/asm/local.h
+++ b/arch/mips/include/asm/local.h
@@ -7,7 +7,7 @@
 #include <linux/atomic.h>
 #include <asm/cmpxchg.h>
 #include <asm/compiler.h>
-#include <asm/war.h>
+#include <asm/asm.h>
 
 typedef struct
 {
@@ -31,34 +31,18 @@ static __inline__ long local_add_return(long i, local_t * l)
 {
 	unsigned long result;
 
-	if (kernel_uses_llsc && IS_ENABLED(CONFIG_WAR_R10000_LLSC)) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	push					\n"
-		"	.set	arch=r4000				\n"
-			__SYNC(full, loongson3_war) "			\n"
-		"1:"	__LL	"%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
-			__SC	"%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	addu	%0, %1, %3				\n"
-		"	.set	pop					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else if (kernel_uses_llsc) {
+	if (kernel_uses_llsc) {
 		unsigned long temp;
 
 		__asm__ __volatile__(
 		"	.set	push					\n"
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
-			__SYNC(full, loongson3_war) "			\n"
-		"1:"	__LL	"%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
-			__SC	"%0, %2					\n"
-		"	beqz	%0, 1b					\n"
-		"	addu	%0, %1, %3				\n"
+			__SYNC(full, loongson3_war) "                   \n"
+		"1:"	__stringify(LONG_LL)	"	%1, %2		\n"
+		"	"__stringify(LONG_ADDU)	"	%0, %1, %3	\n"
+		"	"__stringify(LONG_SC)	"	%0, %2		\n"
+		"	"__stringify(SC_BEQZ)	"	%0, 1b		\n"
+		"	"__stringify(LONG_ADDU)	"	%0, %1, %3	\n"
 		"	.set	pop					\n"
 		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
 		: "Ir" (i), "m" (l->a.counter)
@@ -80,34 +64,18 @@ static __inline__ long local_sub_return(long i, local_t * l)
 {
 	unsigned long result;
 
-	if (kernel_uses_llsc && IS_ENABLED(CONFIG_WAR_R10000_LLSC)) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	push					\n"
-		"	.set	arch=r4000				\n"
-			__SYNC(full, loongson3_war) "			\n"
-		"1:"	__LL	"%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
-			__SC	"%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	subu	%0, %1, %3				\n"
-		"	.set	pop					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else if (kernel_uses_llsc) {
+	if (kernel_uses_llsc) {
 		unsigned long temp;
 
 		__asm__ __volatile__(
 		"	.set	push					\n"
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
-			__SYNC(full, loongson3_war) "			\n"
-		"1:"	__LL	"%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
-			__SC	"%0, %2					\n"
-		"	beqz	%0, 1b					\n"
-		"	subu	%0, %1, %3				\n"
+			__SYNC(full, loongson3_war) "                   \n"
+		"1:"	__stringify(LONG_LL)	"	%1, %2		\n"
+		"	"__stringify(LONG_SUBU)	"	%0, %1, %3	\n"
+		"	"__stringify(LONG_SC)	"	%0, %2		\n"
+		"	"__stringify(SC_BEQZ)	"	%0, 1b		\n"
+		"	"__stringify(LONG_SUBU)	"	%0, %1, %3	\n"
 		"	.set	pop					\n"
 		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
 		: "Ir" (i), "m" (l->a.counter)
-- 
2.20.1

