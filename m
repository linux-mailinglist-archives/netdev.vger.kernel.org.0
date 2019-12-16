Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B5C12100F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfLPQtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:49:07 -0500
Received: from www62.your-server.de ([213.133.104.62]:50678 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfLPQtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:49:07 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igtYP-0004nd-2W; Mon, 16 Dec 2019 17:49:05 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf] bpf: fix missing prog untrack in release_maps
Date:   Mon, 16 Dec 2019 17:49:00 +0100
Message-Id: <1c2909484ca524ae9f55109b06f22b6213e76376.1576514756.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit da765a2f5993 ("bpf: Add poke dependency tracking for prog array
maps") wrongly assumed that in case of prog load errors, we're cleaning
up all program tracking via bpf_free_used_maps().

However, it can happen that we're still at the point where we didn't copy
map pointers into the prog's aux section such that env->prog->aux->used_maps
is still zero, running into a UAF. In such case, the verifier has similar
release_maps() helper that drops references to used maps from its env.

Consolidate the release code into __bpf_free_used_maps() and call it from
all sides to fix it.

Fixes: da765a2f5993 ("bpf: Add poke dependency tracking for prog array maps")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/core.c     | 14 ++++++++++----
 kernel/bpf/verifier.c | 14 ++------------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ac7de5291509..085a59afba85 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -818,6 +818,8 @@ struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
 int __bpf_prog_charge(struct user_struct *user, u32 pages);
 void __bpf_prog_uncharge(struct user_struct *user, u32 pages);
+void __bpf_free_used_maps(struct bpf_prog_aux *aux,
+			  struct bpf_map **used_maps, u32 len);
 
 void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
 void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 49e32acad7d8..6231858df723 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2048,18 +2048,24 @@ static void bpf_free_cgroup_storage(struct bpf_prog_aux *aux)
 	}
 }
 
-static void bpf_free_used_maps(struct bpf_prog_aux *aux)
+void __bpf_free_used_maps(struct bpf_prog_aux *aux,
+			  struct bpf_map **used_maps, u32 len)
 {
 	struct bpf_map *map;
-	int i;
+	u32 i;
 
 	bpf_free_cgroup_storage(aux);
-	for (i = 0; i < aux->used_map_cnt; i++) {
-		map = aux->used_maps[i];
+	for (i = 0; i < len; i++) {
+		map = used_maps[i];
 		if (map->ops->map_poke_untrack)
 			map->ops->map_poke_untrack(map, aux);
 		bpf_map_put(map);
 	}
+}
+
+static void bpf_free_used_maps(struct bpf_prog_aux *aux)
+{
+	__bpf_free_used_maps(aux, aux->used_maps, aux->used_map_cnt);
 	kfree(aux->used_maps);
 }
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 034ef81f935b..a1acdce77070 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8298,18 +8298,8 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
 /* drop refcnt of maps used by the rejected program */
 static void release_maps(struct bpf_verifier_env *env)
 {
-	enum bpf_cgroup_storage_type stype;
-	int i;
-
-	for_each_cgroup_storage_type(stype) {
-		if (!env->prog->aux->cgroup_storage[stype])
-			continue;
-		bpf_cgroup_storage_release(env->prog,
-			env->prog->aux->cgroup_storage[stype]);
-	}
-
-	for (i = 0; i < env->used_map_cnt; i++)
-		bpf_map_put(env->used_maps[i]);
+	__bpf_free_used_maps(env->prog->aux, env->used_maps,
+			     env->used_map_cnt);
 }
 
 /* convert pseudo BPF_LD_IMM64 into generic BPF_LD_IMM64 */
-- 
2.21.0

