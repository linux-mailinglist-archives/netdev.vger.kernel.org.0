Return-Path: <netdev+bounces-7062-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5342719944
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48A1E1C21069
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86FE40795;
	Thu,  1 Jun 2023 10:14:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CDC40785;
	Thu,  1 Jun 2023 10:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2E8C433A0;
	Thu,  1 Jun 2023 10:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685614487;
	bh=Hrx9VtVZyq4uWMBfRCekQXUO/IA4A1XOafQormtZTuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpP21c/RwAJYJm+U25a1tWi/38F4mEWtcst293zmlG6D0PKkBX6d3h9ATwIa7uumf
	 xA2hJJdQXNiMtmOQ7k+n+4Eh/tb5q0l+ZhSYKzMYnVQJJBECXK0Boas7FeJCclB+qU
	 YcYICH1vai6DP7rq0TDqg3DTbnaTA2lnglkoOvwlhDm1fQ7nyhjt7rdP88kQv/EuQI
	 aAPjl78FETn69M4Prx6Edwv1H7cz2NpKwM5xe4vWf7aC2SYCcxtbSZA9vK0QR4+ALQ
	 VYyMUVtF0JdrmF3hiV5k4Z6ygm8TjniyOkfbF+4LCBKjd7eHTl1itn2XLvK6KpbTcp
	 yOKt8OfWFYJOQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Russell King <linux@armlinux.org.uk>,
	Song Liu <song@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-modules@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	netdev@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 10/13] modules, jitalloc: prepare to allocate executable memory as ROX
Date: Thu,  1 Jun 2023 13:12:54 +0300
Message-Id: <20230601101257.530867-11-rppt@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230601101257.530867-1-rppt@kernel.org>
References: <20230601101257.530867-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (IBM)" <rppt@kernel.org>

When executable memory will be allocated as ROX it won't be possible to
update it using memset() and memcpy().

Introduce jit_update_copy() and jit_update_set() APIs and use them in
modules loading code instead of memcpy() and memset().

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 include/linux/jitalloc.h |  2 ++
 kernel/module/main.c     | 19 ++++++++++++++-----
 mm/jitalloc.c            | 20 ++++++++++++++++++++
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/linux/jitalloc.h b/include/linux/jitalloc.h
index 7f8cafb3cfe9..0ba5ef785a85 100644
--- a/include/linux/jitalloc.h
+++ b/include/linux/jitalloc.h
@@ -55,6 +55,8 @@ struct jit_alloc_params *jit_alloc_arch_params(void);
 void jit_free(void *buf);
 void *jit_text_alloc(size_t len);
 void *jit_data_alloc(size_t len);
+void jit_update_copy(void *buf, void *new_buf, size_t len);
+void jit_update_set(void *buf, int c, size_t len);
 
 #ifdef CONFIG_JIT_ALLOC
 void jit_alloc_init(void);
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 91477aa5f671..9f0711c42aa2 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1197,9 +1197,19 @@ void __weak module_arch_freeing_init(struct module *mod)
 
 static void *module_memory_alloc(unsigned int size, enum mod_mem_type type)
 {
-	if (mod_mem_type_is_data(type))
-		return jit_data_alloc(size);
-	return jit_text_alloc(size);
+	void *p;
+
+	if (mod_mem_type_is_data(type)) {
+		p = jit_data_alloc(size);
+		if (p)
+			memset(p, 0, size);
+	} else {
+		p = jit_text_alloc(size);
+		if (p)
+			jit_update_set(p, 0, size);
+	}
+
+	return p;
 }
 
 static void module_memory_free(void *ptr, enum mod_mem_type type)
@@ -2223,7 +2233,6 @@ static int move_module(struct module *mod, struct load_info *info)
 			t = type;
 			goto out_enomem;
 		}
-		memset(ptr, 0, mod->mem[type].size);
 		mod->mem[type].base = ptr;
 	}
 
@@ -2251,7 +2260,7 @@ static int move_module(struct module *mod, struct load_info *info)
 				ret = -ENOEXEC;
 				goto out_enomem;
 			}
-			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
+			jit_update_copy(dest, (void *)shdr->sh_addr, shdr->sh_size);
 		}
 		/*
 		 * Update the userspace copy's ELF section address to point to
diff --git a/mm/jitalloc.c b/mm/jitalloc.c
index 16fd715d501a..a8ae64364d56 100644
--- a/mm/jitalloc.c
+++ b/mm/jitalloc.c
@@ -7,6 +7,16 @@
 
 static struct jit_alloc_params jit_alloc_params;
 
+static inline void jit_text_poke_copy(void *dst, const void *src, size_t len)
+{
+	memcpy(dst, src, len);
+}
+
+static inline void jit_text_poke_set(void *addr, int c, size_t len)
+{
+	memset(addr, c, len);
+}
+
 static void *jit_alloc(size_t len, unsigned int alignment, pgprot_t pgprot,
 		       unsigned long start, unsigned long end,
 		       unsigned long fallback_start, unsigned long fallback_end,
@@ -86,6 +96,16 @@ void *jit_data_alloc(size_t len)
 			 fallback_start, fallback_end, kasan);
 }
 
+void jit_update_copy(void *buf, void *new_buf, size_t len)
+{
+	jit_text_poke_copy(buf, new_buf, len);
+}
+
+void jit_update_set(void *addr, int c, size_t len)
+{
+	jit_text_poke_set(addr, c, len);
+}
+
 struct jit_alloc_params * __weak jit_alloc_arch_params(void)
 {
 	return NULL;
-- 
2.35.1


