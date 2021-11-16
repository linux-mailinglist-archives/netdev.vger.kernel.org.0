Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AE64537F1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhKPQp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbhKPQpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:45:25 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DDEC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:27 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id o63so7930674qkb.4
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sxz4D6uLOmqsmbyo2QO6wq5cXgoWWcc31npQo/Aiwtg=;
        b=jAq2hNFk8MaTn0aZHXzRrlb5ocwWptvh72PyzwxQqZZWMX+eqaGYZJouQSROdnUKWb
         yOHAJquGCUM3FX+hZDuMp2adj2tuW+jM75i7TeSYxFrUkbBFte9wfINyyQCuppRVfDeT
         JqkkGe63hepnhLlC0nKqzmCAqbv/jsYPevv0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sxz4D6uLOmqsmbyo2QO6wq5cXgoWWcc31npQo/Aiwtg=;
        b=xN3hbvLGxhZ2YrjoAbn1Ttlo2ytBdaCBEycyKE8DEhF6+e8dOgksYtpLb4YKuMi4h1
         diF52+gMbe1cDJ+qfif5/l1iuzNYqzI9oNCKRxfcBLqZclS5yzCYmAfmTxKw3RnOrmQn
         CFZDc1MZtxQOaoz/dOTb9RwVG4GgLjnvmzKHYeI2Qb66WUVdRuteE0BRnICVqE5tYmwf
         4V8DaCbCH1NW5BCiwVUCdYFpnC6IK2ty8Bu7mDB/uXzScvgQ/iJteeBEXOm8vWeUQ4Tb
         JSks+iwF11+9j3l8Hy0T5mxyj1/0fXcZUtJL4vdqx39OOeXylM+T0fkLvv04hgjkYG96
         2hnw==
X-Gm-Message-State: AOAM5339cpsGP/tgYHp/HGLOLZcC7qVmHiUh36pk6y67EfC0wYOQ2IYl
        jK6C+DPHZtIa0uccQOSaBhSM7H36bZ5azHLWCdAyXjF7PyuJsGEPfDkHtH9vOMICCn8s8FECDGj
        KulhJMekLYNLTIiS8PyWi9ehxHg44NC5N5rj3DLava0yb7qE7PSRwjE7h62n1fWB41ML2qH0F
X-Google-Smtp-Source: ABdhPJxQdlx5k20QPqy421Fx3yQW6Vxvr/3v+SmCGcLsjvKUmXKqbYIygSIn15UJkuVfQl7khR8o1A==
X-Received: by 2002:ae9:e30b:: with SMTP id v11mr7513837qkf.329.1637080945413;
        Tue, 16 Nov 2021 08:42:25 -0800 (PST)
Received: from localhost.localdomain ([191.91.82.96])
        by smtp.gmail.com with ESMTPSA id bk18sm7309121qkb.35.2021.11.16.08.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:42:25 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v2 1/4] libbpf: Implement btf__save_raw()
Date:   Tue, 16 Nov 2021 11:42:05 -0500
Message-Id: <20211116164208.164245-2-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116164208.164245-1-mauricio@kinvolk.io>
References: <20211116164208.164245-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement helper function to save the contents of a BTF object to a
file.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/lib/bpf/btf.c      | 30 ++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h      |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 33 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index fadf089ae8fe..96a242f91832 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1121,6 +1121,36 @@ struct btf *btf__parse_split(const char *path, struct btf *base_btf)
 	return libbpf_ptr(btf_parse(path, base_btf, NULL));
 }
 
+int btf__save_raw(const struct btf *btf, const char *path)
+{
+	const void *data;
+	FILE *f = NULL;
+	__u32 data_sz;
+	int err = 0;
+
+	data = btf__raw_data(btf, &data_sz);
+	if (!data) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	f = fopen(path, "wb");
+	if (!f) {
+		err = -errno;
+		goto out;
+	}
+
+	if (fwrite(data, 1, data_sz, f) != data_sz) {
+		err = -errno;
+		goto out;
+	}
+
+out:
+	if (f)
+		fclose(f);
+	return libbpf_err(err);
+}
+
 static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool swap_endian);
 
 int btf__load_into_kernel(struct btf *btf)
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 5c73a5b0a044..4f8d3f303aa6 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -114,6 +114,8 @@ LIBBPF_API struct btf *btf__parse_elf_split(const char *path, struct btf *base_b
 LIBBPF_API struct btf *btf__parse_raw(const char *path);
 LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf);
 
+LIBBPF_API int btf__save_raw(const struct btf *btf, const char *path);
+
 LIBBPF_API struct btf *btf__load_vmlinux_btf(void);
 LIBBPF_API struct btf *btf__load_module_btf(const char *module_name, struct btf *vmlinux_btf);
 LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 6a59514a48cf..c9555f8655af 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -414,4 +414,5 @@ LIBBPF_0.6.0 {
 		perf_buffer__new_deprecated;
 		perf_buffer__new_raw;
 		perf_buffer__new_raw_deprecated;
+		btf__save_raw;
 } LIBBPF_0.5.0;
-- 
2.25.1

