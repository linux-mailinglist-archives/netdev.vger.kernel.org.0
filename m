Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C79C6A2EDD
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 09:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBZIwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 03:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBZIwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 03:52:10 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C828611665;
        Sun, 26 Feb 2023 00:52:06 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id u10so3162870pjc.5;
        Sun, 26 Feb 2023 00:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4DPxaA2KI42WAf76J1TanSD7CSM/V5DVF96yv7d/wc=;
        b=PC3wWSXji3vHKoI700y7qX3wzD5w99OjEiqnCW7njziy/uBcwtrx+ahMmyGrAjxG/T
         W08aTdMtRq+ZRCT41KR0KAGKgJnoEn6+3jWgmmjNb45tJBiIfcM43xxf4P4WFH0kw5m/
         jYs28v0NiQ52bXkq7UHMEKNKWzuLXNMgNX/2I2v0/4/8kE7Sd9r+pW7jSZ2/Qd+UGBZU
         5Q41u9CqveHCwUOwFAj1XrIvMfAC3Z+EZsg8Yc0f95IHJogQGEYZtzrmH2Hjy/D41ap5
         jVHHz3VU1OVx+desJb1hXX34Io3g9QnsnnqBBdRPNuHzSwSukc98BxIUuzrO+sAfIMLx
         iSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4DPxaA2KI42WAf76J1TanSD7CSM/V5DVF96yv7d/wc=;
        b=hbnGC8J96QzthSXH5YYrjTZ9TlOm0pz+6ug7hQ/nNhQZK9zpvGlzSen2IGcMZ+9u1k
         hn1x66ow6JeqdgIEMmAiVEsCvUjF3F/K5no5AOIYjoijli+J1FpBL5nELHh0yhv8sVLM
         fbLFK7zi5qRaEClsgaYD2ewVqBAFBDhUt2asbvN2RblQj5Jwml3H9vhx5BGnH+5RHWfx
         gl0xgk3H1DscdwD0mI6g1ZAaETTyAEf9uYb6iVbZ6Uaysk7B1NZ+NoXjUTYoM+XHulJ9
         O3jR2UqSLL1rvOEcB35QAhMUGVPYnCZWTLh7MdNAGlb7lUQaj/LLGXK8QlxDx2hl8Wyf
         cWeQ==
X-Gm-Message-State: AO0yUKW5e2/djcqsBB5+IB1fNbjXwzfAA6kQB5TPnSMbOZXhav4sF15I
        qxj6HI5z82y65NvLzpgWt9B1dN/IMFE=
X-Google-Smtp-Source: AK7set9j5RvnmvyC9b7uiZmSEVofrVWY2pwxDayUI12artA1DXaGwlezSBRnfybxsayqet68Tw9Piw==
X-Received: by 2002:a05:6a20:32aa:b0:cc:1014:1fb4 with SMTP id g42-20020a056a2032aa00b000cc10141fb4mr9062053pzd.22.1677401525974;
        Sun, 26 Feb 2023 00:52:05 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id s10-20020a62e70a000000b00592591d1634sm2227299pfh.97.2023.02.26.00.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 00:52:05 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v12 bpf-next 04/10] bpf: Define no-ops for externally called bpf dynptr functions
Date:   Sun, 26 Feb 2023 00:51:14 -0800
Message-Id: <20230226085120.3907863-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226085120.3907863-1-joannelkoong@gmail.com>
References: <20230226085120.3907863-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some bpf dynptr functions will be called from places where
if CONFIG_BPF_SYSCALL is not set, then the dynptr function is
undefined. For example, when skb type dynptrs are added in the
next commit, dynptr functions are called from net/core/filter.c

This patch defines no-op implementations of these dynptr functions
so that they do not break compilation by being an undefined reference.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h | 75 +++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 520b238abd5a..296841a31749 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1124,6 +1124,33 @@ static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
 	return bpf_func(ctx, insnsi);
 }
 
+/* the implementation of the opaque uapi struct bpf_dynptr */
+struct bpf_dynptr_kern {
+	void *data;
+	/* Size represents the number of usable bytes of dynptr data.
+	 * If for example the offset is at 4 for a local dynptr whose data is
+	 * of type u64, the number of usable bytes is 4.
+	 *
+	 * The upper 8 bits are reserved. It is as follows:
+	 * Bits 0 - 23 = size
+	 * Bits 24 - 30 = dynptr type
+	 * Bit 31 = whether dynptr is read-only
+	 */
+	u32 size;
+	u32 offset;
+} __aligned(8);
+
+enum bpf_dynptr_type {
+	BPF_DYNPTR_TYPE_INVALID,
+	/* Points to memory that is local to the bpf program */
+	BPF_DYNPTR_TYPE_LOCAL,
+	/* Underlying data is a ringbuf record */
+	BPF_DYNPTR_TYPE_RINGBUF,
+};
+
+int bpf_dynptr_check_size(u32 size);
+u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr);
+
 #ifdef CONFIG_BPF_JIT
 int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
 int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
@@ -2266,6 +2293,11 @@ static inline bool has_current_bpf_ctx(void)
 }
 
 void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
+
+void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
+		     enum bpf_dynptr_type type, u32 offset, u32 size);
+void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
+void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr);
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -2495,6 +2527,19 @@ static inline void bpf_prog_inc_misses_counter(struct bpf_prog *prog)
 static inline void bpf_cgrp_storage_free(struct cgroup *cgroup)
 {
 }
+
+static inline void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
+				   enum bpf_dynptr_type type, u32 offset, u32 size)
+{
+}
+
+static inline void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr)
+{
+}
+
+static inline void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
+{
+}
 #endif /* CONFIG_BPF_SYSCALL */
 
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
@@ -2913,36 +2958,6 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 num_args, struct bpf_bprintf_data *data);
 void bpf_bprintf_cleanup(struct bpf_bprintf_data *data);
 
-/* the implementation of the opaque uapi struct bpf_dynptr */
-struct bpf_dynptr_kern {
-	void *data;
-	/* Size represents the number of usable bytes of dynptr data.
-	 * If for example the offset is at 4 for a local dynptr whose data is
-	 * of type u64, the number of usable bytes is 4.
-	 *
-	 * The upper 8 bits are reserved. It is as follows:
-	 * Bits 0 - 23 = size
-	 * Bits 24 - 30 = dynptr type
-	 * Bit 31 = whether dynptr is read-only
-	 */
-	u32 size;
-	u32 offset;
-} __aligned(8);
-
-enum bpf_dynptr_type {
-	BPF_DYNPTR_TYPE_INVALID,
-	/* Points to memory that is local to the bpf program */
-	BPF_DYNPTR_TYPE_LOCAL,
-	/* Underlying data is a kernel-produced ringbuf record */
-	BPF_DYNPTR_TYPE_RINGBUF,
-};
-
-void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
-		     enum bpf_dynptr_type type, u32 offset, u32 size);
-void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
-int bpf_dynptr_check_size(u32 size);
-u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr);
-
 #ifdef CONFIG_BPF_LSM
 void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype);
 void bpf_cgroup_atype_put(int cgroup_atype);
-- 
2.34.1

