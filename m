Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5699FF376
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbfKPQZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:25:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbfKPPmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:02 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DE642075E;
        Sat, 16 Nov 2019 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918921;
        bh=qtEvDNQ1hGh5OvtIarObqpS47qN5mS+O16aIP/RsG7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiLOFB6iRTN1ThVwrQTes/BobsGmd+kQVfG5jtB05Bv9WXOhdrSD596YJPz5WxqJU
         20pPqHnKSSHouwK96raUtZMIBiYP/1ydbNQiEaymOPEhuEFD5jAuckexim7npuAtj2
         lnt9v+X5xphK8RL5JNhOlLxNRqMws9rS78HvJhow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Beckett <david.beckett@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com
Subject: [PATCH AUTOSEL 4.19 046/237] nfp: bpf: protect against mis-initializing atomic counters
Date:   Sat, 16 Nov 2019 10:38:01 -0500
Message-Id: <20191116154113.7417-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 527db74b71ee5a279f818aae51f2c26b4e5c7648 ]

Atomic operations on the NFP are currently always in big endian.
The driver keeps track of regions of memory storing atomic values
and byte swaps them accordingly.  There are corner cases where
the map values may be initialized before the driver knows they
are used as atomic counters.  This can happen either when the
datapath is performing the update and the stack contents are
unknown or when map is updated before the program which will
use it for atomic values is loaded.

To avoid situation where user initializes the value to 0 1 2 3
and then after loading a program which uses the word as an atomic
counter starts reading 3 2 1 0 - only allow atomic counters to be
initialized to endian-neutral values.

For updates from the datapath the stack information may not be
as precise, so just allow initializing such values to 0.

Example code which would break:
struct bpf_map_def SEC("maps") rxcnt = {
       .type = BPF_MAP_TYPE_HASH,
       .key_size = sizeof(__u32),
       .value_size = sizeof(__u64),
       .max_entries = 1,
};

int xdp_prog1()
{
      	__u64 nonzeroval = 3;
	__u32 key = 0;
	__u64 *value;

	value = bpf_map_lookup_elem(&rxcnt, &key);
	if (!value)
		bpf_map_update_elem(&rxcnt, &key, &nonzeroval, BPF_ANY);
	else
		__sync_fetch_and_add(value, 1);

	return XDP_PASS;
}

$ offload bpftool map dump
key: 00 00 00 00 value: 00 00 00 03 00 00 00 00

should be:

$ offload bpftool map dump
key: 00 00 00 00 value: 03 00 00 00 00 00 00 00

Reported-by: David Beckett <david.beckett@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/bpf/main.h |  7 ++-
 .../net/ethernet/netronome/nfp/bpf/offload.c  | 18 +++++-
 .../net/ethernet/netronome/nfp/bpf/verifier.c | 58 +++++++++++++++++--
 3 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
index dbd00982fd2b6..2134045e14c36 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
@@ -206,6 +206,11 @@ enum nfp_bpf_map_use {
 	NFP_MAP_USE_ATOMIC_CNT,
 };
 
+struct nfp_bpf_map_word {
+	unsigned char type		:4;
+	unsigned char non_zero_update	:1;
+};
+
 /**
  * struct nfp_bpf_map - private per-map data attached to BPF maps for offload
  * @offmap:	pointer to the offloaded BPF map
@@ -219,7 +224,7 @@ struct nfp_bpf_map {
 	struct nfp_app_bpf *bpf;
 	u32 tid;
 	struct list_head l;
-	enum nfp_bpf_map_use use_map[];
+	struct nfp_bpf_map_word use_map[];
 };
 
 struct nfp_bpf_neutral_map {
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 1ccd6371a15b5..6140e4650b71c 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -299,10 +299,25 @@ static void nfp_map_bpf_byte_swap(struct nfp_bpf_map *nfp_map, void *value)
 	unsigned int i;
 
 	for (i = 0; i < DIV_ROUND_UP(nfp_map->offmap->map.value_size, 4); i++)
-		if (nfp_map->use_map[i] == NFP_MAP_USE_ATOMIC_CNT)
+		if (nfp_map->use_map[i].type == NFP_MAP_USE_ATOMIC_CNT)
 			word[i] = (__force u32)cpu_to_be32(word[i]);
 }
 
+/* Mark value as unsafely initialized in case it becomes atomic later
+ * and we didn't byte swap something non-byte swap neutral.
+ */
+static void
+nfp_map_bpf_byte_swap_record(struct nfp_bpf_map *nfp_map, void *value)
+{
+	u32 *word = value;
+	unsigned int i;
+
+	for (i = 0; i < DIV_ROUND_UP(nfp_map->offmap->map.value_size, 4); i++)
+		if (nfp_map->use_map[i].type == NFP_MAP_UNUSED &&
+		    word[i] != (__force u32)cpu_to_be32(word[i]))
+			nfp_map->use_map[i].non_zero_update = 1;
+}
+
 static int
 nfp_bpf_map_lookup_entry(struct bpf_offloaded_map *offmap,
 			 void *key, void *value)
@@ -322,6 +337,7 @@ nfp_bpf_map_update_entry(struct bpf_offloaded_map *offmap,
 			 void *key, void *value, u64 flags)
 {
 	nfp_map_bpf_byte_swap(offmap->dev_priv, value);
+	nfp_map_bpf_byte_swap_record(offmap->dev_priv, value);
 	return nfp_bpf_ctrl_update_entry(offmap, key, value, flags);
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/verifier.c b/drivers/net/ethernet/netronome/nfp/bpf/verifier.c
index a6e9248669e14..db7e186dae56d 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/verifier.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/verifier.c
@@ -108,6 +108,46 @@ nfp_record_adjust_head(struct nfp_app_bpf *bpf, struct nfp_prog *nfp_prog,
 	nfp_prog->adjust_head_location = location;
 }
 
+static bool nfp_bpf_map_update_value_ok(struct bpf_verifier_env *env)
+{
+	const struct bpf_reg_state *reg1 = cur_regs(env) + BPF_REG_1;
+	const struct bpf_reg_state *reg3 = cur_regs(env) + BPF_REG_3;
+	struct bpf_offloaded_map *offmap;
+	struct bpf_func_state *state;
+	struct nfp_bpf_map *nfp_map;
+	int off, i;
+
+	state = env->cur_state->frame[reg3->frameno];
+
+	/* We need to record each time update happens with non-zero words,
+	 * in case such word is used in atomic operations.
+	 * Implicitly depend on nfp_bpf_stack_arg_ok(reg3) being run before.
+	 */
+
+	offmap = map_to_offmap(reg1->map_ptr);
+	nfp_map = offmap->dev_priv;
+	off = reg3->off + reg3->var_off.value;
+
+	for (i = 0; i < offmap->map.value_size; i++) {
+		struct bpf_stack_state *stack_entry;
+		unsigned int soff;
+
+		soff = -(off + i) - 1;
+		stack_entry = &state->stack[soff / BPF_REG_SIZE];
+		if (stack_entry->slot_type[soff % BPF_REG_SIZE] == STACK_ZERO)
+			continue;
+
+		if (nfp_map->use_map[i / 4].type == NFP_MAP_USE_ATOMIC_CNT) {
+			pr_vlog(env, "value at offset %d/%d may be non-zero, bpf_map_update_elem() is required to initialize atomic counters to zero to avoid offload endian issues\n",
+				i, soff);
+			return false;
+		}
+		nfp_map->use_map[i / 4].non_zero_update = 1;
+	}
+
+	return true;
+}
+
 static int
 nfp_bpf_stack_arg_ok(const char *fname, struct bpf_verifier_env *env,
 		     const struct bpf_reg_state *reg,
@@ -198,7 +238,8 @@ nfp_bpf_check_call(struct nfp_prog *nfp_prog, struct bpf_verifier_env *env,
 					 bpf->helpers.map_update, reg1) ||
 		    !nfp_bpf_stack_arg_ok("map_update", env, reg2,
 					  meta->func_id ? &meta->arg2 : NULL) ||
-		    !nfp_bpf_stack_arg_ok("map_update", env, reg3, NULL))
+		    !nfp_bpf_stack_arg_ok("map_update", env, reg3, NULL) ||
+		    !nfp_bpf_map_update_value_ok(env))
 			return -EOPNOTSUPP;
 		break;
 
@@ -376,15 +417,22 @@ nfp_bpf_map_mark_used_one(struct bpf_verifier_env *env,
 			  struct nfp_bpf_map *nfp_map,
 			  unsigned int off, enum nfp_bpf_map_use use)
 {
-	if (nfp_map->use_map[off / 4] != NFP_MAP_UNUSED &&
-	    nfp_map->use_map[off / 4] != use) {
+	if (nfp_map->use_map[off / 4].type != NFP_MAP_UNUSED &&
+	    nfp_map->use_map[off / 4].type != use) {
 		pr_vlog(env, "map value use type conflict %s vs %s off: %u\n",
-			nfp_bpf_map_use_name(nfp_map->use_map[off / 4]),
+			nfp_bpf_map_use_name(nfp_map->use_map[off / 4].type),
 			nfp_bpf_map_use_name(use), off);
 		return -EOPNOTSUPP;
 	}
 
-	nfp_map->use_map[off / 4] = use;
+	if (nfp_map->use_map[off / 4].non_zero_update &&
+	    use == NFP_MAP_USE_ATOMIC_CNT) {
+		pr_vlog(env, "atomic counter in map value may already be initialized to non-zero value off: %u\n",
+			off);
+		return -EOPNOTSUPP;
+	}
+
+	nfp_map->use_map[off / 4].type = use;
 
 	return 0;
 }
-- 
2.20.1

