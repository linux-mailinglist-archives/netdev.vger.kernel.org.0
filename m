Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF9D116E47
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfLINz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:55:57 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42625 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLINz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:55:57 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so7268921pfz.9;
        Mon, 09 Dec 2019 05:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FPFa3OuM/TlaH8+z5XwoxIKhfhKN+wkPNx4ZwfD8Dao=;
        b=ZF1MprhLjHeSmlxAFL+Pda/kxcumTRAJNpXEfBNbjYkd/LDvrGhajfyUJ1jMwPlpHQ
         29tgbiCKHAOOBwf5klyh2qkHc2TS9Ur1op90nGBLdsZuYnAqYebDkBfpvhGOP65Cw07P
         PVZVdf9UiN76VQWA1BxlWHvvaI4vKbdTWI2e27X47gdwo4tamaqyBIrKgoHCr9z2evpk
         mbnRrQ5XDF3bmw61t3wS/95CHE4C+zwyFU/dOcy46cTZUGnya5NCNHwwPNMZucwggRIk
         G2KKUulC7TBKPKw7x4S4DuABoDyWV/j6acPPZi1AXBLeN5RuD5y+vl21UTHPhNNIb/4G
         aBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FPFa3OuM/TlaH8+z5XwoxIKhfhKN+wkPNx4ZwfD8Dao=;
        b=dtW+QI7cAjaIfX/+bXLq6yBSQKH5ne5/7wX/cno8mOoN0+Km+sVGew90CVyMchRpG7
         VLN713yAsNOFN7lqEXyo9u9K46cLszDCneKiKIQN43PFYciHUR6z43vAr0HPAJZ08FG1
         v6RkNVocPSe0uqCl0wqe0IlHELrpiX8U5wZ4mUxWuPBJj1NFVFk06yAtbljxhQBHwKZw
         vs1otUwA85V58yMkrNQsD3mr0G+uHqkWwe7Hpu2FeiLtHX+kRhfS7wWrQB/440Fooft7
         /mLXfyOEGK1H+hEJX82yIr21Q6PRNva8yhC+/xnZJ5dFvDCX/FGeLj4FxFfU3RXMSSfQ
         HRnw==
X-Gm-Message-State: APjAAAXDJLwq3H0jthLZvA0J7MEFLwsT2giRfsNshhx2TROAGoIvJhwl
        LlnKYUmuugAJopnxQh8Lc09omzbpBM98fA==
X-Google-Smtp-Source: APXvYqwFBF4FmtSNZFm9KTRcgXvOjZUPHMtl5qFN60bCpMuN8ZbwNOnuUD/4xKvqAkzhNaqFCwLhvA==
X-Received: by 2002:a63:e0f:: with SMTP id d15mr18651742pgl.255.1575899756140;
        Mon, 09 Dec 2019 05:55:56 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id h26sm19543403pfr.9.2019.12.09.05.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 05:55:55 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v3 6/6] bpf, x86: align dispatcher branch targets to 16B
Date:   Mon,  9 Dec 2019 14:55:22 +0100
Message-Id: <20191209135522.16576-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209135522.16576-1-bjorn.topel@gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
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
 kernel/bpf/dispatcher.c     |  2 +-
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
 
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index de6b1f20b920..5f8ce701bcad 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -25,7 +25,7 @@
  * allocated on first use, and never freed.
  */
 
-#define BPF_DISPATCHER_MAX 64 /* Fits in 2048B */
+#define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
 
 struct bpf_disp_prog {
 	struct bpf_prog *prog;
-- 
2.20.1

