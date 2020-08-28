Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F36E25615E
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 21:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgH1Tg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 15:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgH1TgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 15:36:09 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD35C061233
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:08 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id e63so81275qkd.14
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YZ5LeBPQpyyJvO3Gz2DvdMpJFZa5a8BnHcIIYG0Iagw=;
        b=pY+Ggws5AtyVpGHz0EVJPQp2z9kcNcC/JTDgCH85LK0dpIfdHq+5UX0kgIDo4TBBmT
         KinRhgEdXFzq3C/OwXz70G/gctXv6nlyK0HCFkKj/RLNhrUH5h7rMHlY6IF0txRvHwti
         hpyN4s7d9eSgEBzquBDiwQTS4dw71miSo1z4aHNJwMC9WGFZZ2xoSrcGEsMO45H9MbFC
         tX25lba408V799PVIGDuF9jKxWdNDoSCFzNPp74IlRkpVRz79+h8yNI0Oax+bj8ZrhPO
         BhyU2ACeT+CJVUUD69cU+e5T8RwRguIyOv5sMISnBwnyEBUQq4X4DePOI8KkHZ+rI2LI
         ZKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YZ5LeBPQpyyJvO3Gz2DvdMpJFZa5a8BnHcIIYG0Iagw=;
        b=ZgxUr5RuDq0OV8AesrBXVrv1xLzBqUwC+6CzCcMVUw4h2dQV+i9rcrjvc38FK4Xn0B
         8fuqtqcogpBhlwxJ/IvvlkNDqjmQnfBirlK4thozq70fw8ed99oEEvwsr8m/aifbC0QZ
         cLiF8ryIWlL5GGhhltgIpNs/rU30FvGNgv/8lC3E6RVBtUJYf7whEBTni0MZ5DoNfzIl
         OLJx/DoLVKCPCsvHKP3HveNqXWPGShdJnfmobl+rCZGU4o6PD5DXbFASP3Ej2374+QCS
         iX/LoIjnWTs/NEJNe9vUOd4GhOS1cWEFfHlCq154uD1Ut6FE1AFH3TqdiONqEGaiJsiQ
         y2xw==
X-Gm-Message-State: AOAM531mjZ8CeY2zuFsNmc0HgwKB80wfGIlskwZJPQBKND5WzXjPPVXx
        aeEj7ZM/LlJEi4tKEwsiI2zQxAIZSuTLN96yPtmv9Cn42w7wjbWMJHXmwthv6drtuRUDZh6z2Aj
        mfpekVt+eG+DkX22dFFlp6/KdOrg2IcOFG1vayZU9AX4OHMke5T6jog==
X-Google-Smtp-Source: ABdhPJzGzVA7YrBKO8m6gcU3S2aTUjqbGTq3JUVU7hvPSIeIfkkU9HDAW9qeAtG3ICXvrbZZNeaT7rU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:b61c:: with SMTP id f28mr128057qve.92.1598643367280;
 Fri, 28 Aug 2020 12:36:07 -0700 (PDT)
Date:   Fri, 28 Aug 2020 12:35:56 -0700
In-Reply-To: <20200828193603.335512-1-sdf@google.com>
Message-Id: <20200828193603.335512-2-sdf@google.com>
Mime-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH bpf-next v3 1/8] bpf: Mutex protect used_maps array and count
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

To support modifying the used_maps array, we use a mutex to protect
the use of the counter and the array. The mutex is initialized right
after the prog aux is allocated, and destroyed right before prog
aux is freed. This way we guarantee it's initialized for both cBPF
and eBPF.

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../net/ethernet/netronome/nfp/bpf/offload.c   | 18 ++++++++++++------
 include/linux/bpf.h                            |  1 +
 kernel/bpf/core.c                              | 15 +++++++++++----
 kernel/bpf/syscall.c                           | 16 ++++++++++++----
 net/core/dev.c                                 | 11 ++++++++---
 5 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index ac02369174a9..53851853562c 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -111,7 +111,9 @@ static int
 nfp_map_ptrs_record(struct nfp_app_bpf *bpf, struct nfp_prog *nfp_prog,
 		    struct bpf_prog *prog)
 {
-	int i, cnt, err;
+	int i, cnt, err = 0;
+
+	mutex_lock(&prog->aux->used_maps_mutex);
 
 	/* Quickly count the maps we will have to remember */
 	cnt = 0;
@@ -119,13 +121,15 @@ nfp_map_ptrs_record(struct nfp_app_bpf *bpf, struct nfp_prog *nfp_prog,
 		if (bpf_map_offload_neutral(prog->aux->used_maps[i]))
 			cnt++;
 	if (!cnt)
-		return 0;
+		goto out;
 
 	nfp_prog->map_records = kmalloc_array(cnt,
 					      sizeof(nfp_prog->map_records[0]),
 					      GFP_KERNEL);
-	if (!nfp_prog->map_records)
-		return -ENOMEM;
+	if (!nfp_prog->map_records) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < prog->aux->used_map_cnt; i++)
 		if (bpf_map_offload_neutral(prog->aux->used_maps[i])) {
@@ -133,12 +137,14 @@ nfp_map_ptrs_record(struct nfp_app_bpf *bpf, struct nfp_prog *nfp_prog,
 						 prog->aux->used_maps[i]);
 			if (err) {
 				nfp_map_ptrs_forget(bpf, nfp_prog);
-				return err;
+				goto out;
 			}
 		}
 	WARN_ON(cnt != nfp_prog->map_records_cnt);
 
-	return 0;
+out:
+	mutex_unlock(&prog->aux->used_maps_mutex);
+	return err;
 }
 
 static int
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index dbba82a80087..1b404b034775 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -748,6 +748,7 @@ struct bpf_prog_aux {
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
 	struct bpf_map **used_maps;
+	struct mutex used_maps_mutex; /* mutex for used_maps and used_map_cnt */
 	struct bpf_prog *prog;
 	struct user_struct *user;
 	u64 load_time; /* ns since boottime */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ed0b3578867c..2a20c2833996 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -98,6 +98,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->jit_requested = ebpf_jit_enabled();
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
+	mutex_init(&fp->aux->used_maps_mutex);
 
 	return fp;
 }
@@ -253,6 +254,7 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 void __bpf_prog_free(struct bpf_prog *fp)
 {
 	if (fp->aux) {
+		mutex_destroy(&fp->aux->used_maps_mutex);
 		free_percpu(fp->aux->stats);
 		kfree(fp->aux->poke_tab);
 		kfree(fp->aux);
@@ -1747,8 +1749,9 @@ bool bpf_prog_array_compatible(struct bpf_array *array,
 static int bpf_check_tail_call(const struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
-	int i;
+	int i, ret = 0;
 
+	mutex_lock(&aux->used_maps_mutex);
 	for (i = 0; i < aux->used_map_cnt; i++) {
 		struct bpf_map *map = aux->used_maps[i];
 		struct bpf_array *array;
@@ -1757,11 +1760,15 @@ static int bpf_check_tail_call(const struct bpf_prog *fp)
 			continue;
 
 		array = container_of(map, struct bpf_array, map);
-		if (!bpf_prog_array_compatible(array, fp))
-			return -EINVAL;
+		if (!bpf_prog_array_compatible(array, fp)) {
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
-	return 0;
+out:
+	mutex_unlock(&aux->used_maps_mutex);
+	return ret;
 }
 
 static void bpf_prog_select_func(struct bpf_prog *fp)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b86b1155b748..c9b8a97fbbdf 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3155,21 +3155,25 @@ static const struct bpf_map *bpf_map_from_imm(const struct bpf_prog *prog,
 	const struct bpf_map *map;
 	int i;
 
+	mutex_lock(&prog->aux->used_maps_mutex);
 	for (i = 0, *off = 0; i < prog->aux->used_map_cnt; i++) {
 		map = prog->aux->used_maps[i];
 		if (map == (void *)addr) {
 			*type = BPF_PSEUDO_MAP_FD;
-			return map;
+			goto out;
 		}
 		if (!map->ops->map_direct_value_meta)
 			continue;
 		if (!map->ops->map_direct_value_meta(map, addr, off)) {
 			*type = BPF_PSEUDO_MAP_VALUE;
-			return map;
+			goto out;
 		}
 	}
+	map = NULL;
 
-	return NULL;
+out:
+	mutex_unlock(&prog->aux->used_maps_mutex);
+	return map;
 }
 
 static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog,
@@ -3287,6 +3291,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	memcpy(info.tag, prog->tag, sizeof(prog->tag));
 	memcpy(info.name, prog->aux->name, sizeof(prog->aux->name));
 
+	mutex_lock(&prog->aux->used_maps_mutex);
 	ulen = info.nr_map_ids;
 	info.nr_map_ids = prog->aux->used_map_cnt;
 	ulen = min_t(u32, info.nr_map_ids, ulen);
@@ -3296,9 +3301,12 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 
 		for (i = 0; i < ulen; i++)
 			if (put_user(prog->aux->used_maps[i]->id,
-				     &user_map_ids[i]))
+				     &user_map_ids[i])) {
+				mutex_unlock(&prog->aux->used_maps_mutex);
 				return -EFAULT;
+			}
 	}
+	mutex_unlock(&prog->aux->used_maps_mutex);
 
 	err = set_info_rec_size(&info);
 	if (err)
diff --git a/net/core/dev.c b/net/core/dev.c
index b5d1129d8310..6957b31127d9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5441,15 +5441,20 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 	if (new) {
 		u32 i;
 
+		mutex_lock(&new->aux->used_maps_mutex);
+
 		/* generic XDP does not work with DEVMAPs that can
 		 * have a bpf_prog installed on an entry
 		 */
 		for (i = 0; i < new->aux->used_map_cnt; i++) {
-			if (dev_map_can_have_prog(new->aux->used_maps[i]))
-				return -EINVAL;
-			if (cpu_map_prog_allowed(new->aux->used_maps[i]))
+			if (dev_map_can_have_prog(new->aux->used_maps[i]) ||
+			    cpu_map_prog_allowed(new->aux->used_maps[i])) {
+				mutex_unlock(&new->aux->used_maps_mutex);
 				return -EINVAL;
+			}
 		}
+
+		mutex_unlock(&new->aux->used_maps_mutex);
 	}
 
 	switch (xdp->command) {
-- 
2.28.0.402.g5ffc5be6b7-goog

