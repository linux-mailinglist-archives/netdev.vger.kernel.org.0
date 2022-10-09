Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116C75F9070
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiJIWYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiJIWXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:23:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F08E28721;
        Sun,  9 Oct 2022 15:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ACAAB80DE3;
        Sun,  9 Oct 2022 22:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E1BC433C1;
        Sun,  9 Oct 2022 22:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353640;
        bh=5ZwiKBpt66QQzKYWNPKO+qqLmMbhb/Jt6M0bY8B6cNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6eHsrgU16pz1VFV/mvW9238tcKzw5/9rfPFWHYTrWELYOq9ZtblF1LWBo+tnBOOd
         EvCYpMC8LFp4mRxY7JYvxvVvlQFcoCasJTGVg6H0hn4FHOxSQ7tsmtxk69iq4xGYMg
         9g1EFl6Are/1V0wFPM3F6kjTjd56vK4PCqMo/lzsjD9F6QZ7Q95boTg2jH4QbeumBw
         nGNhlE8kGg0G2r+RBqLOKboX+9f8puDCJe3DgBDoj9mRhaZTxwgq3uzV9W94oSjFXa
         kb7qba5OvhYu1y/nlfJFVMQoKoDjZM98MVuwRHDes6JRDt/brqSRAkBWL1DBMnXQWl
         fiDCXLxGZYQjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 70/77] bpf: use bpf_prog_pack for bpf_dispatcher
Date:   Sun,  9 Oct 2022 18:07:47 -0400
Message-Id: <20221009220754.1214186-70-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Song Liu <song@kernel.org>

[ Upstream commit 19c02415da2345d0dda2b5c4495bc17cc14b18b5 ]

Allocate bpf_dispatcher with bpf_prog_pack_alloc so that bpf_dispatcher
can share pages with bpf programs.

arch_prepare_bpf_dispatcher() is updated to provide a RW buffer as working
area for arch code to write to.

This also fixes CPA W^X warnning like:

CPA refuse W^X violation: 8000000000000163 -> 0000000000000163 range: ...

Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20220926184739.3512547-2-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 16 ++++++++--------
 include/linux/bpf.h         |  3 ++-
 include/linux/filter.h      |  5 +++++
 kernel/bpf/core.c           |  9 +++++++--
 kernel/bpf/dispatcher.c     | 27 +++++++++++++++++++++------
 5 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index c1f6c1c51d99..362562c832e6 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2209,7 +2209,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	return ret;
 }
 
-static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
+static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs, u8 *image, u8 *buf)
 {
 	u8 *jg_reloc, *prog = *pprog;
 	int pivot, err, jg_bytes = 1;
@@ -2225,12 +2225,12 @@ static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 		EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3),
 			    progs[a]);
 		err = emit_cond_near_jump(&prog,	/* je func */
-					  (void *)progs[a], prog,
+					  (void *)progs[a], image + (prog - buf),
 					  X86_JE);
 		if (err)
 			return err;
 
-		emit_indirect_jump(&prog, 2 /* rdx */, prog);
+		emit_indirect_jump(&prog, 2 /* rdx */, image + (prog - buf));
 
 		*pprog = prog;
 		return 0;
@@ -2255,7 +2255,7 @@ static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 	jg_reloc = prog;
 
 	err = emit_bpf_dispatcher(&prog, a, a + pivot,	/* emit lower_part */
-				  progs);
+				  progs, image, buf);
 	if (err)
 		return err;
 
@@ -2269,7 +2269,7 @@ static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 	emit_code(jg_reloc - jg_bytes, jg_offset, jg_bytes);
 
 	err = emit_bpf_dispatcher(&prog, a + pivot + 1,	/* emit upper_part */
-				  b, progs);
+				  b, progs, image, buf);
 	if (err)
 		return err;
 
@@ -2289,12 +2289,12 @@ static int cmp_ips(const void *a, const void *b)
 	return 0;
 }
 
-int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs)
+int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs)
 {
-	u8 *prog = image;
+	u8 *prog = buf;
 
 	sort(funcs, num_funcs, sizeof(funcs[0]), cmp_ips, NULL);
-	return emit_bpf_dispatcher(&prog, 0, num_funcs - 1, funcs);
+	return emit_bpf_dispatcher(&prog, 0, num_funcs - 1, funcs, image, buf);
 }
 
 struct x64_jit_data {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 20c26aed7896..80fc8a88c610 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -891,6 +891,7 @@ struct bpf_dispatcher {
 	struct bpf_dispatcher_prog progs[BPF_DISPATCHER_MAX];
 	int num_progs;
 	void *image;
+	void *rw_image;
 	u32 image_off;
 	struct bpf_ksym ksym;
 };
@@ -909,7 +910,7 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
-int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
+int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\
diff --git a/include/linux/filter.h b/include/linux/filter.h
index a5f21dc3c432..f2c47df5ad2a 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1018,6 +1018,8 @@ extern long bpf_jit_limit_max;
 
 typedef void (*bpf_jit_fill_hole_t)(void *area, unsigned int size);
 
+void bpf_jit_fill_hole_with_zero(void *area, unsigned int size);
+
 struct bpf_binary_header *
 bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 		     unsigned int alignment,
@@ -1030,6 +1032,9 @@ void bpf_jit_free(struct bpf_prog *fp);
 struct bpf_binary_header *
 bpf_jit_binary_pack_hdr(const struct bpf_prog *fp);
 
+void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns);
+void bpf_prog_pack_free(struct bpf_binary_header *hdr);
+
 static inline bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
 {
 	return list_empty(&fp->aux->ksym.lnode) ||
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3d9eb3ae334c..c4600a5781de 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -825,6 +825,11 @@ struct bpf_prog_pack {
 	unsigned long bitmap[];
 };
 
+void bpf_jit_fill_hole_with_zero(void *area, unsigned int size)
+{
+	memset(area, 0, size);
+}
+
 #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
 
 static DEFINE_MUTEX(pack_mutex);
@@ -864,7 +869,7 @@ static struct bpf_prog_pack *alloc_new_pack(bpf_jit_fill_hole_t bpf_fill_ill_ins
 	return pack;
 }
 
-static void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns)
+void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns)
 {
 	unsigned int nbits = BPF_PROG_SIZE_TO_NBITS(size);
 	struct bpf_prog_pack *pack;
@@ -905,7 +910,7 @@ static void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insn
 	return ptr;
 }
 
-static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
+void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 {
 	struct bpf_prog_pack *pack = NULL, *tmp;
 	unsigned int nbits;
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index 2444bd15cc2d..fa64b80b8bca 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -85,12 +85,12 @@ static bool bpf_dispatcher_remove_prog(struct bpf_dispatcher *d,
 	return false;
 }
 
-int __weak arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs)
+int __weak arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs)
 {
 	return -ENOTSUPP;
 }
 
-static int bpf_dispatcher_prepare(struct bpf_dispatcher *d, void *image)
+static int bpf_dispatcher_prepare(struct bpf_dispatcher *d, void *image, void *buf)
 {
 	s64 ips[BPF_DISPATCHER_MAX] = {}, *ipsp = &ips[0];
 	int i;
@@ -99,12 +99,12 @@ static int bpf_dispatcher_prepare(struct bpf_dispatcher *d, void *image)
 		if (d->progs[i].prog)
 			*ipsp++ = (s64)(uintptr_t)d->progs[i].prog->bpf_func;
 	}
-	return arch_prepare_bpf_dispatcher(image, &ips[0], d->num_progs);
+	return arch_prepare_bpf_dispatcher(image, buf, &ips[0], d->num_progs);
 }
 
 static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 {
-	void *old, *new;
+	void *old, *new, *tmp;
 	u32 noff;
 	int err;
 
@@ -117,8 +117,14 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 	}
 
 	new = d->num_progs ? d->image + noff : NULL;
+	tmp = d->num_progs ? d->rw_image + noff : NULL;
 	if (new) {
-		if (bpf_dispatcher_prepare(d, new))
+		/* Prepare the dispatcher in d->rw_image. Then use
+		 * bpf_arch_text_copy to update d->image, which is RO+X.
+		 */
+		if (bpf_dispatcher_prepare(d, new, tmp))
+			return;
+		if (IS_ERR(bpf_arch_text_copy(new, tmp, PAGE_SIZE / 2)))
 			return;
 	}
 
@@ -140,9 +146,18 @@ void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 
 	mutex_lock(&d->mutex);
 	if (!d->image) {
-		d->image = bpf_jit_alloc_exec_page();
+		d->image = bpf_prog_pack_alloc(PAGE_SIZE, bpf_jit_fill_hole_with_zero);
 		if (!d->image)
 			goto out;
+		d->rw_image = bpf_jit_alloc_exec(PAGE_SIZE);
+		if (!d->rw_image) {
+			u32 size = PAGE_SIZE;
+
+			bpf_arch_text_copy(d->image, &size, sizeof(size));
+			bpf_prog_pack_free((struct bpf_binary_header *)d->image);
+			d->image = NULL;
+			goto out;
+		}
 		bpf_image_ksym_add(d->image, &d->ksym);
 	}
 
-- 
2.35.1

