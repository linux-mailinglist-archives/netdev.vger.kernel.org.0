Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4411F107935
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKVUIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:08:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:37328 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVUIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 15:08:13 -0500
Received: from 30.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYFDv-0004YY-Ix; Fri, 22 Nov 2019 21:08:11 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 2/8] bpf: move bpf_free_used_maps into sleepable section
Date:   Fri, 22 Nov 2019 21:07:55 +0100
Message-Id: <09823b1d5262876e9b83a8e75df04cf0467357a4.1574452833.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1574452833.git.daniel@iogearbox.net>
References: <cover.1574452833.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We later on are going to need a sleepable context as opposed to plain
RCU callback in order to untrack programs we need to poke at runtime
and tracking as well as image update is performed under mutex.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h  |  4 ++++
 kernel/bpf/core.c    | 23 +++++++++++++++++++++++
 kernel/bpf/syscall.c | 20 --------------------
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7978b617caa8..561b920f0bf7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1031,6 +1031,10 @@ static inline int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 {
 	return -ENOTSUPP;
 }
+
+static inline void bpf_map_put(struct bpf_map *map)
+{
+}
 #endif /* CONFIG_BPF_SYSCALL */
 
 static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b5945c3aaa8e..0e825c164f1a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2003,12 +2003,35 @@ int bpf_prog_array_copy_info(struct bpf_prog_array *array,
 								     : 0;
 }
 
+static void bpf_free_cgroup_storage(struct bpf_prog_aux *aux)
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype) {
+		if (!aux->cgroup_storage[stype])
+			continue;
+		bpf_cgroup_storage_release(aux->prog,
+					   aux->cgroup_storage[stype]);
+	}
+}
+
+static void bpf_free_used_maps(struct bpf_prog_aux *aux)
+{
+	int i;
+
+	bpf_free_cgroup_storage(aux);
+	for (i = 0; i < aux->used_map_cnt; i++)
+		bpf_map_put(aux->used_maps[i]);
+	kfree(aux->used_maps);
+}
+
 static void bpf_prog_free_deferred(struct work_struct *work)
 {
 	struct bpf_prog_aux *aux;
 	int i;
 
 	aux = container_of(work, struct bpf_prog_aux, work);
+	bpf_free_used_maps(aux);
 	if (bpf_prog_is_dev_bound(aux))
 		bpf_prog_offload_destroy(aux->prog);
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b51ecb9644d0..8fcd4790bafd 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1303,25 +1303,6 @@ static int find_prog_type(enum bpf_prog_type type, struct bpf_prog *prog)
 	return 0;
 }
 
-/* drop refcnt on maps used by eBPF program and free auxilary data */
-static void free_used_maps(struct bpf_prog_aux *aux)
-{
-	enum bpf_cgroup_storage_type stype;
-	int i;
-
-	for_each_cgroup_storage_type(stype) {
-		if (!aux->cgroup_storage[stype])
-			continue;
-		bpf_cgroup_storage_release(aux->prog,
-					   aux->cgroup_storage[stype]);
-	}
-
-	for (i = 0; i < aux->used_map_cnt; i++)
-		bpf_map_put(aux->used_maps[i]);
-
-	kfree(aux->used_maps);
-}
-
 enum bpf_event {
 	BPF_EVENT_LOAD,
 	BPF_EVENT_UNLOAD,
@@ -1444,7 +1425,6 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
-	free_used_maps(aux);
 	bpf_prog_uncharge_memlock(aux->prog);
 	security_bpf_prog_free(aux);
 	bpf_prog_free(aux->prog);
-- 
2.21.0

