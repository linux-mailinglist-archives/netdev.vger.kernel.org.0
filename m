Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71131F1BF7
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 17:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgFHPVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 11:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbgFHPVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 11:21:42 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE93C08C5C2
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 08:21:42 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id mb16so18776082ejb.4
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 08:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1wKcFfthsPqwbKK9c90AHCmaqhxnPW68MnZMY30RSmI=;
        b=gdVBIIP3KRauhgTmeco1+X1vpvlwrzo+CgyE9zccPkn7s1/7F7WcfgNpwrTSA0wkQD
         FhYi/1r5KSYyXAnjDKsKkasK1+eRhJ2JG47jPbJD4lBcw7Nz+Ni1ucBW6+joPKWPhHCg
         qr8vZDkj4gWuT5mDrhfdQ1yrkjODizwX6zVNb0WQjqy1ZRRxVHzcTPlqMwQYG9G/AEzn
         cGpuozdWlXZe8NhxEbwZxmKcTGxAzw6b9opYxNRyXA2WxhKs8xeiev7JRSKpSGRxmrUH
         4HlR1hgVTedtVjLjy3u54VnaInMVK0eAxKSdnZG35Te4KRm+fMlCWaf9/KcAe4g54SIx
         qJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1wKcFfthsPqwbKK9c90AHCmaqhxnPW68MnZMY30RSmI=;
        b=XxqDvfH+EG+C3y02q0Tis3gN15sqRXIHQjLqOpehfblACAvDQzlsgUfxbEYNYI5wgG
         QC79Lk1XpwN654efogTHRwFP94zdcg6/G8EfYY71CDe6knFhXokfdQj9mmfzjaLIib6u
         UDfuUobnod4b/asu8lmb6wLA/77T2mmrFBMYF5PINsns5HZX07QJ1eonXQ7NEfjHD+2b
         valHEvPuQIfqLk1QqmOnXHQwWw8xMCrPyYKnV8GuzJA5h33roXh67otBMdhDs7/BFQSj
         3YQjLmG6iD51C43rpePjlFTz+6A5wz7oUPwmFOHTg+fdZDRcc0HOeGvWxrk6DfKtWEkt
         3+aQ==
X-Gm-Message-State: AOAM530xt5FuWC0LQH7qZRFPk2Nxzo0rdL9IxM0ZTrgBMU+eP5BsMB+T
        DVIrCRoe8lZWezEpGNfNSvbmcQ==
X-Google-Smtp-Source: ABdhPJwf7/Zwgv0hJfLXZH4kWvhvbE6c03JML7wnE4KckpsFGt8IlQ/zCeTNqomVaU5zrdKcf50dEw==
X-Received: by 2002:a17:906:c831:: with SMTP id dd17mr17374912ejb.40.1591629701408;
        Mon, 08 Jun 2020 08:21:41 -0700 (PDT)
Received: from localhost.localdomain ([2001:171b:226e:c200:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id bo26sm13105667edb.67.2020.06.08.08.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 08:21:40 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     bpf@vger.kernel.org, andriin@fb.com
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, netdev@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH bpf] libbpf: Fix BTF-to-C conversion of noreturn function pointers
Date:   Mon,  8 Jun 2020 17:20:52 +0200
Message-Id: <20200608152052.898491-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When trying to convert the BTF for a function pointer marked "noreturn"
to C code, bpftool currently generates a syntax error. This happens with
the exit() pointer in drivers/firmware/efi/libstub/efistub.h, in an
arm64 vmlinux. When dealing with this declaration:

	efi_status_t __noreturn (__efiapi *exit)(...);

bpftool produces the following output:

	efi_status_tvolatile  (*exit)(...);

Fix the error by inserting the space before the function modifier.

Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 tools/lib/bpf/btf_dump.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 0c28ee82834b7..003f305fc2342 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1111,9 +1111,11 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 	d->decl_stack_cnt = stack_start;
 }
 
-static void btf_dump_emit_mods(struct btf_dump *d, struct id_stack *decl_stack)
+static void btf__dump_emit_mods(struct btf_dump *d, struct id_stack *decl_stack,
+				const char *prefix, const char *suffix)
 {
 	const struct btf_type *t;
+	const char *mod;
 	__u32 id;
 
 	while (decl_stack->cnt) {
@@ -1122,21 +1124,27 @@ static void btf_dump_emit_mods(struct btf_dump *d, struct id_stack *decl_stack)
 
 		switch (btf_kind(t)) {
 		case BTF_KIND_VOLATILE:
-			btf_dump_printf(d, "volatile ");
+			mod = "volatile";
 			break;
 		case BTF_KIND_CONST:
-			btf_dump_printf(d, "const ");
+			mod = "const";
 			break;
 		case BTF_KIND_RESTRICT:
-			btf_dump_printf(d, "restrict ");
+			mod = "restrict";
 			break;
 		default:
 			return;
 		}
+		btf_dump_printf(d, "%s%s%s", prefix, mod, suffix);
 		decl_stack->cnt--;
 	}
 }
 
+static void btf_dump_emit_mods(struct btf_dump *d, struct id_stack *decl_stack)
+{
+	btf__dump_emit_mods(d, decl_stack, "", " ");
+}
+
 static void btf_dump_emit_name(const struct btf_dump *d,
 			       const char *name, bool last_was_ptr)
 {
@@ -1270,7 +1278,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 			__u16 vlen = btf_vlen(t);
 			int i;
 
-			btf_dump_emit_mods(d, decls);
+			btf__dump_emit_mods(d, decls, " ", "");
 			if (decls->cnt) {
 				btf_dump_printf(d, " (");
 				btf_dump_emit_type_chain(d, decls, fname, lvl);
-- 
2.27.0

