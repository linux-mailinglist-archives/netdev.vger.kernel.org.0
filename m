Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7B51200B5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfLPJOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:14:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44653 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbfLPJOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:14:09 -0500
Received: by mail-pf1-f193.google.com with SMTP id d199so5230109pfd.11;
        Mon, 16 Dec 2019 01:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QO2XYproH0t5I47F5mhtBi9AMEJLuvvc53hQXLZNLWQ=;
        b=AoKOXKO/1ir4bT+D1DlgUf1isDtUDWHygosuKaYk74JMk0vJNwzkDiuuwuQ9fngA1n
         oYb73MSGF+jaWJ0xNyXkE3jFt6O6avV/NLsFX5CLRbXiXupSyDFL8eEjKRdY6tNTBZXp
         WYawDjkXM9XmDchvoTvdFZh9lgNhR5sHnoqZT/02LTG5dszcvAlzWP6dKegVdNbF+9NX
         yORcbNJ30Z9aWZLfWCleQxTYiGtFnBeJPQnNcpnFvi/zfjB11qmMKay7tQBLZ7C2ZDCZ
         kZ8WRsNgPuAH7N723ElFNiM5b8rNYxcLlOdf39fvw7um1NXRXMrzqtcdIH6p8kY6RNbE
         nYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QO2XYproH0t5I47F5mhtBi9AMEJLuvvc53hQXLZNLWQ=;
        b=H6vjoUlWqbSxlUN1AQ85+HMq9iSxytWSMtdKWjUhaf3iFNYx2MmleOWNilteX4PGE8
         qU6zMkibIqROoYeFy0aWML5sCvecscZWtwjBQiYeo7Kp/p/RU+pm7gvynGs+pMsqG6Ee
         60O6uoyRRzgktgmnxgLAROVSri+6be0gjmDEKAEljN5m/y3LHNC4AE6u9FVtf6JYlnBn
         gKlSxhsscIKx1zGM75tI6ZY9G8IC33q4eHCj1PTiM3v18b7tgR2fKrVNCfj0a2v4pSbi
         81EQ79TCcrBQXfQB5ymDfb+2jJ7eX2TGWRsfaMjg7XqLl1quQAFSfeTvBcIfiDrcbCSw
         eYvw==
X-Gm-Message-State: APjAAAXhkdcGGsD/BCcQ/IIwbePt6A2XRW5jPMgwlq1qcpDaL6D1ABM+
        KH41lgyP4GyR/Es8WDCQxOA=
X-Google-Smtp-Source: APXvYqxUgfQ3E9jefxz8vWiRidBaCpHKdCxu+LuYaqveP9Nh/uP6bKmQCD9Iwj5dJoI/m61t7uUpKg==
X-Received: by 2002:a63:4d4c:: with SMTP id n12mr17283981pgl.212.1576487648452;
        Mon, 16 Dec 2019 01:14:08 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:14:08 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 6/9] riscv, bpf: provide RISC-V specific JIT image alloc/free
Date:   Mon, 16 Dec 2019 10:13:40 +0100
Message-Id: <20191216091343.23260-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191216091343.23260-1-bjorn.topel@gmail.com>
References: <20191216091343.23260-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit makes sure that the JIT images is kept close to the kernel
text, so BPF calls can use relative calling with auipc/jalr or jal
instead of loading the full 64-bit address and jalr.

The BPF JIT image region is 128 MB before the kernel text.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/include/asm/pgtable.h |  4 ++++
 arch/riscv/net/bpf_jit_comp.c    | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 7ff0ed4f292e..cc3f49415620 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -404,6 +404,10 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 #define VMALLOC_END      (PAGE_OFFSET - 1)
 #define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
 
+#define BPF_JIT_REGION_SIZE	(SZ_128M)
+#define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
+#define BPF_JIT_REGION_END	(VMALLOC_END)
+
 /*
  * Roughly size the vmemmap space to be large enough to fit enough
  * struct pages to map half the virtual address space. Then
diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 8aa19c846881..46cff093f526 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -1656,3 +1656,16 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 					   tmp : orig_prog);
 	return prog;
 }
+
+void *bpf_jit_alloc_exec(unsigned long size)
+{
+	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
+				    BPF_JIT_REGION_END, GFP_KERNEL,
+				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				    __builtin_return_address(0));
+}
+
+void bpf_jit_free_exec(void *addr)
+{
+	return vfree(addr);
+}
-- 
2.20.1

