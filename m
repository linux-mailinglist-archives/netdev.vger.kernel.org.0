Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541A436EB91
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 15:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbhD2NsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 09:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238485AbhD2NsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 09:48:00 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1F7C06138E
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 06:47:13 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a4so67050861wrr.2
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 06:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cclXdLP22V8eZQOTypKMrwFQ0CzgP0dJouQ4GLcb3wg=;
        b=baizyMXjXngHFguaCs3eYVLB3u2xkTKFDKS05vlop/A1N3z1adqRQNJ0LGpYG31DxV
         5jYrypkkz4FmEYC5zISvh5Yo9CAg7kjZvaGoi5V9dzHsmW6bCKvfrmrgBc7xa/3ACZN8
         TsldlkbjunGZVUh4eHkkU4YKmvKupQFWgSmTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cclXdLP22V8eZQOTypKMrwFQ0CzgP0dJouQ4GLcb3wg=;
        b=bfvvS+M2EM+vcwEcg4/6zkVdvVAyKylSW9R/+pwf+4ZwAQOoRgv4/QR/NEq6J0r8u4
         ogyowDf7TKAbZY29XfIeMlhStVT1m3Zt4vf125gnmrp+sVPkrFn4rhTF/ugsVCBYfzXx
         x3maHe383ESPLpe2+k0r9EEErO8/+5T/uqS5wL/HT0Hn22sJYuAOBIUWhTHGCu47OxB7
         zbt2HP+sHKLn9o5N5XKo8tKPglzwCtJlM9mtjlJNLBc9erIR+/KTSWfutOfvcQXY1JSq
         sRQYWnt+QW13WLpswMiM4R8tLYrtOpy6lwN6uQuISyr0WUV8hpu1fGv7l1k/KRo9KsW/
         Ckjw==
X-Gm-Message-State: AOAM532cQX3/6dsKDVz7sJK/VSGIZ6k78iHqE4uQtzF73tGo74j5JfoJ
        +jw0YAzY9xgPHFO1DM/kxUgeJKzuGF5qcw==
X-Google-Smtp-Source: ABdhPJz7MqotNNcA3lHfLygXy0+EcQm+B1R0UoNPYWx4zmd/ZOlzbR2xy1qN/cyJL/TQ92dRp+u2ug==
X-Received: by 2002:a5d:45cb:: with SMTP id b11mr16892767wrs.343.1619704032199;
        Thu, 29 Apr 2021 06:47:12 -0700 (PDT)
Received: from localhost.localdomain (8.7.1.e.3.2.9.3.e.a.2.1.c.2.e.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4e2c:12ae:3923:e178])
        by smtp.gmail.com with ESMTPSA id x8sm5105592wru.70.2021.04.29.06.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 06:47:11 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 3/3] bpf: verifier: allocate idmap scratch in verifier env
Date:   Thu, 29 Apr 2021 14:46:56 +0100
Message-Id: <20210429134656.122225-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210429134656.122225-1-lmb@cloudflare.com>
References: <20210429134656.122225-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

func_states_equal makes a very short lived allocation for idmap,
probably because it's too large to fit on the stack. However the
function is called quite often, leading to a lot of alloc / free
churn. Replace the temporary allocation with dedicated scratch
space in struct bpf_verifier_env.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/bpf_verifier.h |  8 +++++++
 kernel/bpf/verifier.c        | 46 ++++++++++++------------------------
 2 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 6023a1367853..9e794f8b1df9 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -215,6 +215,13 @@ struct bpf_idx_pair {
 	u32 idx;
 };
 
+struct bpf_id_pair {
+	u32 old;
+	u32 cur;
+};
+
+/* Maximum number of register states that can exist at once */
+#define BPF_ID_MAP_SIZE (MAX_BPF_REG + MAX_BPF_STACK / BPF_REG_SIZE)
 #define MAX_CALL_FRAMES 8
 struct bpf_verifier_state {
 	/* call stack tracking */
@@ -417,6 +424,7 @@ struct bpf_verifier_env {
 	const struct bpf_line_info *prev_linfo;
 	struct bpf_verifier_log log;
 	struct bpf_subprog_info subprog_info[BPF_MAX_SUBPROGS + 1];
+	struct bpf_id_pair idmap_scratch[BPF_ID_MAP_SIZE];
 	struct {
 		int *insn_state;
 		int *insn_stack;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2b9623ac9288..fbcfdae05c39 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9746,13 +9746,6 @@ static bool range_within(struct bpf_reg_state *old,
 	       old->s32_max_value >= cur->s32_max_value;
 }
 
-/* Maximum number of register states that can exist at once */
-#define ID_MAP_SIZE	(MAX_BPF_REG + MAX_BPF_STACK / BPF_REG_SIZE)
-struct idpair {
-	u32 old;
-	u32 cur;
-};
-
 /* If in the old state two registers had the same id, then they need to have
  * the same id in the new state as well.  But that id could be different from
  * the old state, so we need to track the mapping from old to new ids.
@@ -9763,11 +9756,11 @@ struct idpair {
  * So we look through our idmap to see if this old id has been seen before.  If
  * so, we require the new id to match; otherwise, we add the id pair to the map.
  */
-static bool check_ids(u32 old_id, u32 cur_id, struct idpair *idmap)
+static bool check_ids(u32 old_id, u32 cur_id, struct bpf_id_pair *idmap)
 {
 	unsigned int i;
 
-	for (i = 0; i < ID_MAP_SIZE; i++) {
+	for (i = 0; i < BPF_ID_MAP_SIZE; i++) {
 		if (!idmap[i].old) {
 			/* Reached an empty slot; haven't seen this id before */
 			idmap[i].old = old_id;
@@ -9880,7 +9873,7 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
 
 /* Returns true if (rold safe implies rcur safe) */
 static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct idpair *idmap)
+		    struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -9998,7 +9991,7 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 
 static bool stacksafe(struct bpf_func_state *old,
 		      struct bpf_func_state *cur,
-		      struct idpair *idmap)
+		      struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -10095,32 +10088,23 @@ static bool refsafe(struct bpf_func_state *old, struct bpf_func_state *cur)
  * whereas register type in current state is meaningful, it means that
  * the current state will reach 'bpf_exit' instruction safely
  */
-static bool func_states_equal(struct bpf_func_state *old,
+static bool func_states_equal(struct bpf_verifier_env *env, struct bpf_func_state *old,
 			      struct bpf_func_state *cur)
 {
-	struct idpair *idmap;
-	bool ret = false;
 	int i;
 
-	idmap = kcalloc(ID_MAP_SIZE, sizeof(struct idpair), GFP_KERNEL);
-	/* If we failed to allocate the idmap, just say it's not safe */
-	if (!idmap)
+	memset(env->idmap_scratch, 0, sizeof(env->idmap_scratch));
+	for (i = 0; i < MAX_BPF_REG; i++)
+		if (!regsafe(&old->regs[i], &cur->regs[i], env->idmap_scratch))
+			return false;
+
+	if (!stacksafe(old, cur, env->idmap_scratch))
 		return false;
 
-	for (i = 0; i < MAX_BPF_REG; i++) {
-		if (!regsafe(&old->regs[i], &cur->regs[i], idmap))
-			goto out_free;
-	}
-
-	if (!stacksafe(old, cur, idmap))
-		goto out_free;
-
 	if (!refsafe(old, cur))
-		goto out_free;
-	ret = true;
-out_free:
-	kfree(idmap);
-	return ret;
+		return false;
+
+	return true;
 }
 
 static bool states_equal(struct bpf_verifier_env *env,
@@ -10147,7 +10131,7 @@ static bool states_equal(struct bpf_verifier_env *env,
 	for (i = 0; i <= old->curframe; i++) {
 		if (old->frame[i]->callsite != cur->frame[i]->callsite)
 			return false;
-		if (!func_states_equal(old->frame[i], cur->frame[i]))
+		if (!func_states_equal(env, old->frame[i], cur->frame[i]))
 			return false;
 	}
 	return true;
-- 
2.27.0

