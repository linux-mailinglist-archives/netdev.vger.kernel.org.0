Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB7FD22D
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfKOBEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:04:31 -0500
Received: from www62.your-server.de ([213.133.104.62]:50742 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfKOBEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:04:22 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVQ28-000815-98; Fri, 15 Nov 2019 02:04:20 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH rfc bpf-next 5/8] bpf: add jit poke descriptor mock-up for jit images
Date:   Fri, 15 Nov 2019 02:03:59 +0100
Message-Id: <253496a26ac83e0fe7c830eb27e62ca441a38aff.1573779287.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573779287.git.daniel@iogearbox.net>
References: <cover.1573779287.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add initial poke table data structures and management to the BPF
prog that can later be used by JITs. Also add an instance of poke
specific data for tail call maps. Plan for later work is to extend
this also for BPF static keys.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h    | 20 ++++++++++++++++++++
 include/linux/filter.h | 10 ++++++++++
 kernel/bpf/core.c      | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 40337fa0e463..0ff06a0d0058 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -484,6 +484,24 @@ struct bpf_func_info_aux {
 	bool unreliable;
 };
 
+enum bpf_jit_poke_reason {
+	BPF_POKE_REASON_TAIL_CALL,
+};
+
+/* Descriptor of pokes pointing /into/ the JITed image. */
+struct bpf_jit_poke_descriptor {
+	void *ip;
+	union {
+		struct {
+			struct bpf_map *map;
+			u32 key;
+		} tc;
+	};
+	u8 ip_stable;
+	u8 adj_off;
+	u16 reason;
+};
+
 struct bpf_prog_aux {
 	atomic_t refcnt;
 	u32 used_map_cnt;
@@ -509,6 +527,8 @@ struct bpf_prog_aux {
 	const char *attach_func_name;
 	struct bpf_prog **func;
 	void *jit_data; /* JIT specific data. arch dependent */
+	struct bpf_jit_poke_descriptor *poke_tab;
+	u32 size_poke_tab;
 	struct latch_tree_node ksym_tnode;
 	struct list_head ksym_lnode;
 	const struct bpf_prog_ops *ops;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7a6f8f6f1da4..98dc2be7abc9 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -950,6 +950,9 @@ void *bpf_jit_alloc_exec(unsigned long size);
 void bpf_jit_free_exec(void *addr);
 void bpf_jit_free(struct bpf_prog *fp);
 
+int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
+				struct bpf_jit_poke_descriptor *poke);
+
 int bpf_jit_get_func_addr(const struct bpf_prog *prog,
 			  const struct bpf_insn *insn, bool extra_pass,
 			  u64 *func_addr, bool *func_addr_fixed);
@@ -1053,6 +1056,13 @@ static inline bool bpf_prog_ebpf_jited(const struct bpf_prog *fp)
 	return false;
 }
 
+static inline int
+bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
+			    struct bpf_jit_poke_descriptor *poke)
+{
+	return -ENOTSUPP;
+}
+
 static inline void bpf_jit_free(struct bpf_prog *fp)
 {
 	bpf_prog_unlock_free(fp);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c359d0a94896..853dc4538442 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -255,6 +255,7 @@ void __bpf_prog_free(struct bpf_prog *fp)
 {
 	if (fp->aux) {
 		free_percpu(fp->aux->stats);
+		kfree(fp->aux->poke_tab);
 		kfree(fp->aux);
 	}
 	vfree(fp);
@@ -755,6 +756,39 @@ int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 	return ret;
 }
 
+int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
+				struct bpf_jit_poke_descriptor *poke)
+{
+	struct bpf_jit_poke_descriptor *tab = prog->aux->poke_tab;
+	static const u32 poke_tab_max = 1024;
+	u32 slot = prog->aux->size_poke_tab;
+	u32 size = slot + 1;
+
+	if (size > poke_tab_max)
+		return -ENOSPC;
+	if (poke->ip || poke->ip_stable || poke->adj_off)
+		return -EINVAL;
+
+	switch (poke->reason) {
+	case BPF_POKE_REASON_TAIL_CALL:
+		if (!poke->tc.map)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tab = krealloc(tab, size * sizeof(*poke), GFP_KERNEL);
+	if (!tab)
+		return -ENOMEM;
+
+	memcpy(&tab[slot], poke, sizeof(*poke));
+	prog->aux->size_poke_tab = size;
+	prog->aux->poke_tab = tab;
+
+	return slot;
+}
+
 static atomic_long_t bpf_jit_current;
 
 /* Can be overridden by an arch's JIT compiler if it has a custom,
-- 
2.21.0

