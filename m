Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906CB11AAD5
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfLKMa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:30:58 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45898 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728991AbfLKMa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:30:57 -0500
Received: by mail-pg1-f193.google.com with SMTP id b9so10311553pgk.12;
        Wed, 11 Dec 2019 04:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zbup76ODHdaIhD5xrLZjw/rVJwXfbmf+21M8/XO3+Es=;
        b=fD67hPojb2zTJL1rY+YE6NmqWxjaC0xe+V6Az6p+CM6F+L+SafvEWqhgvRyfnAvPF/
         Gh1CQyxfrzviKD3TwUrJgpqw/xkwTZkhlxZ3cjfCqhyhZRhSESjEeraUC+GQeLX7U9ad
         T1J8RbpAwcAMEp2e6iSQPvfCh4w9ZeQY/67TAfEnjdBKYvlWxvmx1PWaqr/RPrDV6WPc
         2WV8lQsLg3I7Cf+wlibP927zT+wlKOwkBef9u+vwZ+CEulK36Ybtbxb2CQiy9HLLh9P6
         s6+EVDQczWEhEzYR9RrMNaV2cAEeoV/fTAk/Epkc2AQpfC93vCmsBBNf+Sdck6ygLQIm
         umbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zbup76ODHdaIhD5xrLZjw/rVJwXfbmf+21M8/XO3+Es=;
        b=VIhTV3gKEda9McOx90QJxZEvwkG/vBiek/K0IaiQ4VKk2xz6HL9Wj/DInAPZW3FUD7
         //SVTY7s5buruXh+i/a9/hELlDuLILa+7fxqaJp9XSp3L6524HRIi/kfKNuqQOWDnFzN
         M9u0bOMV485Q+UIqv0XZsI85D2cM5CM9Zz0NVNFVBNDuNkAmcyq6Npgc8oZ7W+HlYyAd
         /CnBqFDWYS8eZKhYW2L4uzZq6PgFS3VI9O/WnZtBi5ZQnuTdvf3kdD3vfDbSEbwG15mn
         Mho6aCSp7TSke9UFHhnR3DH/YvUfXzcqBu94Z2utaZr/zVkNV+7cW0SSxeWIkKeiW+7P
         SDOQ==
X-Gm-Message-State: APjAAAVQ49ocN5+ROoQvQP8T+icGJvZTcGLE+t1CkXx60rTm72UPcqJr
        cAEADBoTVWlBCcUJwB0Z2Hgs7nDZ3m6Eiw==
X-Google-Smtp-Source: APXvYqwVdzYQGUMuTXq2BzaKkEb6tt8FxJTpr1NKTi4aSABxAhiDn0ue3iIkjfM0JehY0Bxcxf88sQ==
X-Received: by 2002:aa7:9465:: with SMTP id t5mr3343525pfq.67.1576067456803;
        Wed, 11 Dec 2019 04:30:56 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id 24sm3097132pfn.101.2019.12.11.04.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 04:30:56 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v4 6/6] bpf, x86: align dispatcher branch targets to 16B
Date:   Wed, 11 Dec 2019 13:30:17 +0100
Message-Id: <20191211123017.13212-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211123017.13212-1-bjorn.topel@gmail.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
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
index ed32b5d901a1..026892e55ca2 100644
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

