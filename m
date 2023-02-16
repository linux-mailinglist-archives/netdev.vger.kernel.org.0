Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9136F69A01C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBPW4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBPW4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:56:19 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB504B53A
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:56:18 -0800 (PST)
Received: by devvm15675.prn0.facebook.com (Postfix, from userid 115148)
        id 126A46A5C83E; Thu, 16 Feb 2023 14:56:08 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, memxor@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v10 bpf-next 4/9] bpf: Define no-ops for externally called bpf dynptr functions
Date:   Thu, 16 Feb 2023 14:55:19 -0800
Message-Id: <20230216225524.1192789-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230216225524.1192789-1-joannelkoong@gmail.com>
References: <20230216225524.1192789-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,HELO_MISC_IP,NML_ADSP_CUSTOM_MED,
        RDNS_DYNAMIC,SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
@@ -1124,6 +1124,33 @@ static __always_inline __nocfi unsigned int bpf_di=
spatcher_nop_func(
 	return bpf_func(ctx, insnsi);
 }
=20
+/* the implementation of the opaque uapi struct bpf_dynptr */
+struct bpf_dynptr_kern {
+	void *data;
+	/* Size represents the number of usable bytes of dynptr data.
+	 * If for example the offset is at 4 for a local dynptr whose data is
+	 * of type u64, the number of usable bytes is 4.
+	 *
+	 * The upper 8 bits are reserved. It is as follows:
+	 * Bits 0 - 23 =3D size
+	 * Bits 24 - 30 =3D dynptr type
+	 * Bit 31 =3D whether dynptr is read-only
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
 int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_tra=
mpoline *tr);
 int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_t=
rampoline *tr);
@@ -2266,6 +2293,11 @@ static inline bool has_current_bpf_ctx(void)
 }
=20
 void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
+
+void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
+		     enum bpf_dynptr_type type, u32 offset, u32 size);
+void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
+void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr);
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -2495,6 +2527,19 @@ static inline void bpf_prog_inc_misses_counter(str=
uct bpf_prog *prog)
 static inline void bpf_cgrp_storage_free(struct cgroup *cgroup)
 {
 }
+
+static inline void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *da=
ta,
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
=20
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
@@ -2913,36 +2958,6 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, c=
onst u64 *raw_args,
 			u32 num_args, struct bpf_bprintf_data *data);
 void bpf_bprintf_cleanup(struct bpf_bprintf_data *data);
=20
-/* the implementation of the opaque uapi struct bpf_dynptr */
-struct bpf_dynptr_kern {
-	void *data;
-	/* Size represents the number of usable bytes of dynptr data.
-	 * If for example the offset is at 4 for a local dynptr whose data is
-	 * of type u64, the number of usable bytes is 4.
-	 *
-	 * The upper 8 bits are reserved. It is as follows:
-	 * Bits 0 - 23 =3D size
-	 * Bits 24 - 30 =3D dynptr type
-	 * Bit 31 =3D whether dynptr is read-only
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
--=20
2.30.2

