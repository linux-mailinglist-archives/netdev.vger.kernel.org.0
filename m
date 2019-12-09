Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9151172CC
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLIRcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:32:03 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38446 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIRcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:32:02 -0500
Received: by mail-pj1-f68.google.com with SMTP id l4so6186587pjt.5;
        Mon, 09 Dec 2019 09:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BNCw8ZLuRZFhPijRpMqXTUSJYcWT9YK5uJt+c/1wpxE=;
        b=b7syrMdQLRdmJqKeslHa0OrbiFCOHk5VEYemE7weyZnuuaYVznuyKpmWFBR8lyo6kP
         yGmjhggOh9emFV8hukxxUpWO1eii90aRClJVfM7b+bwsZBAxhOekqV+ukncrnYvhLtXM
         pCvumWBiO2ELk58wvN8WvIMTYRvRWOvF7GZyuRDYJ5Clqxuyyn1B3JCD4t6XxmJHrR1r
         Fz26XQj+ini66Hogzfc9faAaols2T66ku7hzmKlr4OHhgfu714PHeP2dFh6e5wlblZ3r
         3e+yAs/fr3GQ5T0blwgwCAXTcETIIN3AHfPAqNQSVNCEk1FuZIk1YwLFzYD8KyLz7EEY
         9xQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BNCw8ZLuRZFhPijRpMqXTUSJYcWT9YK5uJt+c/1wpxE=;
        b=sEy2uHllDHRuyz8X8trZwVCfgEAv1SMYmmT6Yk0Fapw6gPR8c9r2L4+7FiZYfP8oKp
         pixP9V23v8NMb4xVpmDaxdMH7AFMd3+XqWJNdVCIAkjge6jyxwjsCH4Me7jsdkKftD+G
         EiXujTNmPqz8n2p7878TCgB3tj1NxMbomKuU0MCKMnZtgzayuagGlIc4b/ROlJRGce7N
         7UGAvtjYRAI4InbD5TqPUOwgRY/b592Y4YFxlHpG6Ctwdw60obz4sBjuq+VfWQWngWgx
         SE769G4ohm3JbpAWNYnMb+9FgyER7sx42EE6rSvAox47Y3h3OsZ0OK5yJd/FrsUP5PUv
         sQ2A==
X-Gm-Message-State: APjAAAWMLmC16Vr1IX9OmEnamIOTNeNGru8SxYw1CvJ6TfCGUUSEvvfa
        vGUhKhWa2yEbpso9Qj5ckS4=
X-Google-Smtp-Source: APXvYqy9HFzdcebDinK4pQ1i8ARP6HChfcwpNNcw7Sjeo3SRHNx3mFUKRIy77RI0aIokZfEt2wuL+w==
X-Received: by 2002:a17:902:8a97:: with SMTP id p23mr30685730plo.233.1575912721683;
        Mon, 09 Dec 2019 09:32:01 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id d23sm54943pfo.176.2019.12.09.09.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:32:01 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 5/8] riscv, bpf: provide RISC-V specific JIT image alloc/free
Date:   Mon,  9 Dec 2019 18:31:33 +0100
Message-Id: <20191209173136.29615-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209173136.29615-1-bjorn.topel@gmail.com>
References: <20191209173136.29615-1-bjorn.topel@gmail.com>
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
index cbcb33613d1d..f7b1ae3a968f 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -1672,3 +1672,16 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
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

