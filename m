Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8628E48C60D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354134AbiALO1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241370AbiALO1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:48 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9E1C061201
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:29 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id v7so3123678qtw.13
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bkVbs8uT5Ctuaiowu8lVqiJhSs13tORuX7GTDXkA+TY=;
        b=e/15RtiW+YG58c8uqxLa3ml/iHtW3jar4FK87LXeIlxa3BXw55mSNuS+EXYQdv/YVc
         m9NqOx3AcIuGdGbfAdeEffgNm+lkYc3jd6Pl9AeyR1hbBVxAIX5J30raGxagOpaYxn9k
         lKYXGcRd5p3p256RDy312pukmxkpX+WYhxw3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bkVbs8uT5Ctuaiowu8lVqiJhSs13tORuX7GTDXkA+TY=;
        b=NtxxjsrIpcc0rz2fcv2oMSWBJ6g+ckUX1oy4ztp7Gleuc4ki2BUtFNUy0IXJsH1k5D
         TNam5Sr7JsL1OmNGy/1OFmpVKDHWG5mnTbEPnw5t8xdoEVxzxWAOv+M8MAhzmEJPUhDG
         NCZMmrRluNAGdAW9bvyw0ssKi/Yt/64wCbPpI4o1+sqPmS2/TK5w3Cx3jr8gCRiX8OOj
         aiZXTFvnXFnC649x0VVXPM/MgupW9e4UPxlbfbr4u4sRLSiuAO9K+HpAf9lMF59ZfbXk
         aEvETb08viB5kOupAQUEXyWygqcPeZhuBdDjxIoukl37C6jVCYSOKyrHqR5GlI/UlqYZ
         HUrg==
X-Gm-Message-State: AOAM532y4CI+KhnGWUmIc65WO7Q1jA8GA3b+2rYyToGLPfpebIj7KaAz
        Y+4gT5aWUxLNMV+wGyGKfmQr0uwn+vHr40ejly+PYUwWdGxaOW+eUBEvGo8qoHKRec1UxJ8ivPC
        0ulc057nMdCx3Tp4beSkqGdqfcFeHiCJHpFMqOBOcPzUGs9DmEggWvrL4LWRx5RZtq/8pZmAv
X-Google-Smtp-Source: ABdhPJxTzNvz3aNirTTenmj7MYOvBdxPTuE+ObXIzGFbVOuY/OpgprgLMgAToJ7IdrttDThlhZV8dg==
X-Received: by 2002:ac8:7fc1:: with SMTP id b1mr7720985qtk.3.1641997646379;
        Wed, 12 Jan 2022 06:27:26 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h11sm8776690qko.59.2022.01.12.06.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 06:27:26 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v4 5/8] bpftool: Add struct definitions and helpers for BTFGen
Date:   Wed, 12 Jan 2022 09:27:06 -0500
Message-Id: <20220112142709.102423-6-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112142709.102423-1-mauricio@kinvolk.io>
References: <20220112142709.102423-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some structs and helpers that will be used by BTFGen in the next
commits.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/gen.c | 75 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 5a74fb68dc84..905ab0ee6542 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1126,6 +1126,81 @@ static int btf_save_raw(const struct btf *btf, const char *path)
 	return err;
 }
 
+struct btfgen_type {
+	struct btf_type *type;
+	unsigned int id;
+};
+
+struct btfgen_info {
+	struct hashmap *types;
+	struct btf *src_btf;
+};
+
+static size_t btfgen_hash_fn(const void *key, void *ctx)
+{
+	return (size_t)key;
+}
+
+static bool btfgen_equal_fn(const void *k1, const void *k2, void *ctx)
+{
+	return k1 == k2;
+}
+
+static void *uint_as_hash_key(int x)
+{
+	return (void *)(uintptr_t)x;
+}
+
+static void btfgen_free_type(struct btfgen_type *type)
+{
+	free(type);
+}
+
+static void btfgen_free_info(struct btfgen_info *info)
+{
+	struct hashmap_entry *entry;
+	size_t bkt;
+
+	if (!info)
+		return;
+
+	if (!IS_ERR_OR_NULL(info->types)) {
+		hashmap__for_each_entry(info->types, entry, bkt) {
+			btfgen_free_type(entry->value);
+		}
+		hashmap__free(info->types);
+	}
+
+	btf__free(info->src_btf);
+
+	free(info);
+}
+
+static struct btfgen_info *
+btfgen_new_info(const char *targ_btf_path)
+{
+	struct btfgen_info *info;
+
+	info = calloc(1, sizeof(*info));
+	if (!info)
+		return NULL;
+
+	info->src_btf = btf__parse(targ_btf_path, NULL);
+	if (libbpf_get_error(info->src_btf)) {
+		btfgen_free_info(info);
+		return NULL;
+	}
+
+	info->types = hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
+	if (IS_ERR(info->types)) {
+		errno = -PTR_ERR(info->types);
+		btfgen_free_info(info);
+		return NULL;
+	}
+
+	return info;
+}
+
 /* Create BTF file for a set of BPF objects */
 static int btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
 {
-- 
2.25.1

