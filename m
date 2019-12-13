Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB07411E984
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbfLMRvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:51:49 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:43886 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbfLMRvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:51:49 -0500
Received: by mail-pj1-f65.google.com with SMTP id g4so25821pjs.10;
        Fri, 13 Dec 2019 09:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2sBHsJVMY166rfdIn0fGvi6O+eqOEU7mv+MChsrjlGg=;
        b=lliQF5xUEABoLPby+KKtu8XfvcPL8ePVBUcV9AoSpy1mueNoksPaNdUiDC8hTpm0xJ
         qlZXLKfZifRA+DodMIOkqTBg298bVhY5yys4Et2UMuXCiIrN8OLpPX5ESpeHnE6bq5d8
         ETByiz+2e6ZK0LUCJRggdV/+sAQzaA/R9h7XWhcMAI9eth7wklZnSSxBn4ngyQ90Auzn
         wdMOz0RX2y6aOEa4jAswHzzEOgDywaG0PIyJ9h8/qeANOORUVjs4/nFHA490X3qpb03T
         LP9r3OXTqqIgrkr6cxhV2EzUpUvf4s1r2In5SHV5G9WNXhFTztVGRECulmBj+yczI+z0
         a1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2sBHsJVMY166rfdIn0fGvi6O+eqOEU7mv+MChsrjlGg=;
        b=PL1ces9BsSLlooNqLz9m6ihPa0G8BhupWqZdtaMDGGwuQP/IGVDtlXJbaY/19xg9+d
         j8ftESTfDJInjPEnVl/zCKSjZRgw1MC9XJCto04arzlc93eLx8zhrkzSe+f2FpgSyRmV
         LSXBCOzdCVirvUCD2BYopnXuEIo8TbithOATL47rZAq8Tosu8Gku5WpWmj8DiUktlV1M
         Ku8zl81gcaCqduLfLX1uPbv8lV7KoNCnAeWxE0OWdAppSH1jToivAGMJ/WdKbDzOws3l
         jDg7lG+fYT2pPg5yI6Q4H2TOYEZFdfmer9GIXCIJFhfQ3Lsf3lot6kam7vaSS4kH7Qq+
         IX7A==
X-Gm-Message-State: APjAAAX/I8viGOw+wwy+87uz/CrdE3fZ5jMZ/zeXnI8l5BXf+LddEUWr
        kh+73BrMqZM1wPoV6SAXconAyIcUXfI9nQ==
X-Google-Smtp-Source: APXvYqxwXKp936czHNeXx7XcL96DUruaM9r6EVaj1DIaEDrE3YAmyrKkJFXPs+yBL3xIBqBIaqylgg==
X-Received: by 2002:a17:902:7c15:: with SMTP id x21mr565192pll.59.1576259508671;
        Fri, 13 Dec 2019 09:51:48 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id q12sm12166366pfh.158.2019.12.13.09.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 09:51:48 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v5 6/6] bpf, x86: align dispatcher branch targets to 16B
Date:   Fri, 13 Dec 2019 18:51:12 +0100
Message-Id: <20191213175112.30208-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213175112.30208-1-bjorn.topel@gmail.com>
References: <20191213175112.30208-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

From Intel 64 and IA-32 Architectures Optimization Reference Manual,
3.4.1.4 Code Alignment, Assembly/Compiler Coding Rule 11: All branch
targets should be 16-byte aligned.

This commits aligns branch targets according to the Intel manual.

The nops used to align branch targets make the dispatcher larger, and
therefore the number of supported dispatch points/programs are
descreased from 64 to 48.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 30 +++++++++++++++++++++++++++++-
 include/linux/bpf.h         |  2 +-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 3ce7ad41bd6f..4c8a2d1f8470 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1548,6 +1548,26 @@ static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
 	return 0;
 }
 
+static void emit_nops(u8 **pprog, unsigned int len)
+{
+	unsigned int i, noplen;
+	u8 *prog = *pprog;
+	int cnt = 0;
+
+	while (len > 0) {
+		noplen = len;
+
+		if (noplen > ASM_NOP_MAX)
+			noplen = ASM_NOP_MAX;
+
+		for (i = 0; i < noplen; i++)
+			EMIT1(ideal_nops[noplen][i]);
+		len -= noplen;
+	}
+
+	*pprog = prog;
+}
+
 static int emit_fallback_jump(u8 **pprog)
 {
 	u8 *prog = *pprog;
@@ -1570,8 +1590,8 @@ static int emit_fallback_jump(u8 **pprog)
 
 static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 {
+	u8 *jg_reloc, *jg_target, *prog = *pprog;
 	int pivot, err, jg_bytes = 1, cnt = 0;
-	u8 *jg_reloc, *prog = *pprog;
 	s64 jg_offset;
 
 	if (a == b) {
@@ -1620,6 +1640,14 @@ static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 	if (err)
 		return err;
 
+	/* From Intel 64 and IA-32 Architectures Optimization
+	 * Reference Manual, 3.4.1.4 Code Alignment, Assembly/Compiler
+	 * Coding Rule 11: All branch targets should be 16-byte
+	 * aligned.
+	 */
+	jg_target = PTR_ALIGN(prog, 16);
+	if (jg_target != prog)
+		emit_nops(&prog, jg_target - prog);
 	jg_offset = prog - jg_reloc;
 	emit_code(jg_reloc - jg_bytes, jg_offset, jg_bytes);
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5970989b99d1..d467983e61bb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -471,7 +471,7 @@ struct bpf_trampoline {
 	u64 selector;
 };
 
-#define BPF_DISPATCHER_MAX 64 /* Fits in 2048B */
+#define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
 
 struct bpf_dispatcher_prog {
 	struct bpf_prog *prog;
-- 
2.20.1

