Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC624537F2
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbhKPQp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbhKPQp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:45:26 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88373C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:29 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id o63so7930734qkb.4
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vJaZyE4cWklZpcj1EXpkF5GSkXswhgzeKTA29r6DnZ4=;
        b=XwNJGEs32xP+j98M3sP5f9czORdq9M64m4iTKS7w1jFwHldc/4KuuoTUHfftJyBoTi
         wwjY7E6eFcP3GAFpgjg70Bbs89wpH0UAclL8PgqwSr//CSjb5fsetLf1720Qx+lkeB+y
         WzDDPJDyZwoFnSPikk0T4vok0CUEIUC8GdKZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vJaZyE4cWklZpcj1EXpkF5GSkXswhgzeKTA29r6DnZ4=;
        b=LdkeFQBphD1ivE9qvfHHbdBXll0I73VYbxB3s2wNxl7jCfAuzs8DF24da6pAiN3PC+
         6Hef2CFkbgrhY/nk/ULwjY59nve0keDOKsPRkAVC1la860a7Fw0CnfIVqjNFQq1LSrBC
         4rHlvEe8afuqjUP03trfa8TeNtIv8e+aSpDzY102LUmeKvdKnjdM/qwmCkIN0IXCO2NX
         D9Nx7YnucG7TNCdPqMa5/AkAJH8SosG3SbgFPkBr6RV14maXCubGCDgZWluSHMQThyqa
         B6R41dUJGp77crC6qcYb8OQpjOfnnoKiPbaphyw/H4U56rKl928HJGf+bQQNeDOAdMcD
         37Yg==
X-Gm-Message-State: AOAM532GiH531Tib3zd15cYEswnFshCq98VAdED8a+9wPya/aqkupD/T
        vv+yyNkDEu2BYzzPCmD5t4xk3FXeerURgGFRzubXpbgxe6mt/s86MK3dKJnRyDWPU5behLHcWPd
        7WP9Wgqd4FiBTcXoilwuhOUvfrQcSkPM+C9L/pUUISRIKFb6IRAsKWv3MCSZY14bXY6OA4QvB
X-Google-Smtp-Source: ABdhPJy9tHkPY0oAP+i9/wOl0KoT83M+cF4tvBOvj4ooWOkJnmFIt2hnvfc3sBH62lBeWSyfVsCHBw==
X-Received: by 2002:a05:620a:16b9:: with SMTP id s25mr7353292qkj.409.1637080947012;
        Tue, 16 Nov 2021 08:42:27 -0800 (PST)
Received: from localhost.localdomain ([191.91.82.96])
        by smtp.gmail.com with ESMTPSA id bk18sm7309121qkb.35.2021.11.16.08.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:42:26 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v2 2/4] libbpf: Introduce 'btf_custom' to 'bpf_obj_open_opts'
Date:   Tue, 16 Nov 2021 11:42:06 -0500
Message-Id: <20211116164208.164245-3-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116164208.164245-1-mauricio@kinvolk.io>
References: <20211116164208.164245-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1373ff599556 ("libbpf: Introduce 'btf_custom_path' to
'bpf_obj_open_opts'") introduced btf_custom_path which allows developers
to specify a BTF file path to be used for CO-RE relocations. This
implementation parses and releases the BTF file for each bpf object.

This commit introduces a new 'btf_custom' option to allow users to
specify directly the btf object instead of the path. This avoids
parsing/releasing the same BTF file multiple times when the application
loads multiple bpf objects.

Our specific use case is BTFGen[0], where we want to reuse the same BTF
file with multiple bpf objects. In this case passing btf_custom_path is
not only inefficient but it also complicates the implementation as we
want to save pointers of BTF types but they are invalidated after the
bpf object is closed with bpf_object__close().

[0]: https://github.com/kinvolk/btfgen/

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/lib/bpf/libbpf.c | 20 ++++++++++++++++----
 tools/lib/bpf/libbpf.h |  9 ++++++++-
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index de7e09a6b5ec..6ca76365c6da 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -542,6 +542,8 @@ struct bpf_object {
 	char *btf_custom_path;
 	/* vmlinux BTF override for CO-RE relocations */
 	struct btf *btf_vmlinux_override;
+	/* true when the user provided the btf structure with the btf_custom opt */
+	bool user_provided_btf_vmlinux;
 	/* Lazily initialized kernel module BTFs */
 	struct module_btf *btf_modules;
 	bool btf_modules_loaded;
@@ -2886,7 +2888,7 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
 	int err;
 
 	/* btf_vmlinux could be loaded earlier */
-	if (obj->btf_vmlinux || obj->gen_loader)
+	if (obj->btf_vmlinux || obj->btf_vmlinux_override || obj->gen_loader)
 		return 0;
 
 	if (!force && !obj_needs_vmlinux_btf(obj))
@@ -5474,7 +5476,7 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 	if (obj->btf_ext->core_relo_info.len == 0)
 		return 0;
 
-	if (targ_btf_path) {
+	if (!obj->user_provided_btf_vmlinux && targ_btf_path) {
 		obj->btf_vmlinux_override = btf__parse(targ_btf_path, NULL);
 		err = libbpf_get_error(obj->btf_vmlinux_override);
 		if (err) {
@@ -5543,8 +5545,10 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 
 out:
 	/* obj->btf_vmlinux and module BTFs are freed after object load */
-	btf__free(obj->btf_vmlinux_override);
-	obj->btf_vmlinux_override = NULL;
+	if (!obj->user_provided_btf_vmlinux) {
+		btf__free(obj->btf_vmlinux_override);
+		obj->btf_vmlinux_override = NULL;
+	}
 
 	if (!IS_ERR_OR_NULL(cand_cache)) {
 		hashmap__for_each_entry(cand_cache, entry, i) {
@@ -6767,6 +6771,10 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	if (!OPTS_VALID(opts, bpf_object_open_opts))
 		return ERR_PTR(-EINVAL);
 
+	/* btf_custom_path and btf_custom can't be used together */
+	if (OPTS_GET(opts, btf_custom_path, NULL) && OPTS_GET(opts, btf_custom, NULL))
+		return ERR_PTR(-EINVAL);
+
 	obj_name = OPTS_GET(opts, object_name, NULL);
 	if (obj_buf) {
 		if (!obj_name) {
@@ -6796,6 +6804,10 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		}
 	}
 
+	obj->btf_vmlinux_override = OPTS_GET(opts, btf_custom, NULL);
+	if (obj->btf_vmlinux_override)
+		obj->user_provided_btf_vmlinux = true;
+
 	kconfig = OPTS_GET(opts, kconfig, NULL);
 	if (kconfig) {
 		obj->kconfig = strdup(kconfig);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 4ec69f224342..908ab04dc9bd 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -104,8 +104,15 @@ struct bpf_object_open_opts {
 	 * struct_ops, etc) will need actual kernel BTF at /sys/kernel/btf/vmlinux.
 	 */
 	const char *btf_custom_path;
+	/* Pointer to the custom BTF object to be used for BPF CO-RE relocations.
+	 * This custom BTF completely replaces the use of vmlinux BTF
+	 * for the purpose of CO-RE relocations.
+	 * NOTE: any other BPF feature (e.g., fentry/fexit programs,
+	 * struct_ops, etc) will need actual kernel BTF at /sys/kernel/btf/vmlinux.
+	 */
+	struct btf *btf_custom;
 };
-#define bpf_object_open_opts__last_field btf_custom_path
+#define bpf_object_open_opts__last_field btf_custom
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
-- 
2.25.1

