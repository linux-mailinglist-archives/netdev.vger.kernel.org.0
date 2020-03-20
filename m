Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC2218D984
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgCTUgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:36:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35928 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727362AbgCTUgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:36:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KKaMAO001718
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:36:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=TIP5YKzDJ8AN2ByqCGv0FhNrLUtimv+i+/tXVxcy3Dc=;
 b=el86rDt+W6eqQvlyNZjgpNHaZim1fyvNB0pdmNlNl+28dTGbMzF9Y8ZW+N1AbZBeZy2S
 +kskJ2k8L9ja8MoQICIZ7QxuCBjDclyUI8pkAoU7tVhL5/kX5kQ0BRDHzH45vs8WQqQn
 Hgl4ATckBLcj7XVaJxC0QR6eULCUiz5EpvQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yvu8yu2qs-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:36:34 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 13:36:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 95C912EC2E57; Fri, 20 Mar 2020 13:36:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/6] bpf: factor out cgroup storages operations
Date:   Fri, 20 Mar 2020 13:36:09 -0700
Message-ID: <20200320203615.1519013-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320203615.1519013-1-andriin@fb.com>
References: <20200320203615.1519013-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_07:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=819 suspectscore=25
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200082
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor cgroup attach/detach code to abstract away common operations
performed on all types of cgroup storages. This makes high-level logic more
apparent, plus allows to reuse more code across multiple functions.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/cgroup.c | 118 +++++++++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 46 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 9a500fadbef5..9c8472823a7f 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -28,6 +28,58 @@ void cgroup_bpf_offline(struct cgroup *cgrp)
 	percpu_ref_kill(&cgrp->bpf.refcnt);
 }
 
+static void bpf_cgroup_storages_free(struct bpf_cgroup_storage *storages[])
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype)
+		bpf_cgroup_storage_free(storages[stype]);
+}
+
+static int bpf_cgroup_storages_alloc(struct bpf_cgroup_storage *storages[],
+				     struct bpf_prog *prog)
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype) {
+		storages[stype] = bpf_cgroup_storage_alloc(prog, stype);
+		if (IS_ERR(storages[stype])) {
+			storages[stype] = NULL;
+			bpf_cgroup_storages_free(storages);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static void bpf_cgroup_storages_assign(struct bpf_cgroup_storage *dst[],
+				       struct bpf_cgroup_storage *src[])
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype)
+		dst[stype] = src[stype];
+}
+
+static void bpf_cgroup_storages_link(struct bpf_cgroup_storage *storages[],
+				     struct cgroup* cgrp,
+				     enum bpf_attach_type attach_type)
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype)
+		bpf_cgroup_storage_link(storages[stype], cgrp, attach_type);
+}
+
+static void bpf_cgroup_storages_unlink(struct bpf_cgroup_storage *storages[])
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype)
+		bpf_cgroup_storage_unlink(storages[stype]);
+}
+
 /**
  * cgroup_bpf_release() - put references of all bpf programs and
  *                        release all cgroup bpf data
@@ -37,7 +89,6 @@ static void cgroup_bpf_release(struct work_struct *work)
 {
 	struct cgroup *p, *cgrp = container_of(work, struct cgroup,
 					       bpf.release_work);
-	enum bpf_cgroup_storage_type stype;
 	struct bpf_prog_array *old_array;
 	unsigned int type;
 
@@ -50,10 +101,8 @@ static void cgroup_bpf_release(struct work_struct *work)
 		list_for_each_entry_safe(pl, tmp, progs, node) {
 			list_del(&pl->node);
 			bpf_prog_put(pl->prog);
-			for_each_cgroup_storage_type(stype) {
-				bpf_cgroup_storage_unlink(pl->storage[stype]);
-				bpf_cgroup_storage_free(pl->storage[stype]);
-			}
+			bpf_cgroup_storages_unlink(pl->storage);
+			bpf_cgroup_storages_free(pl->storage);
 			kfree(pl);
 			static_branch_dec(&cgroup_bpf_enabled_key);
 		}
@@ -138,7 +187,7 @@ static int compute_effective_progs(struct cgroup *cgrp,
 				   enum bpf_attach_type type,
 				   struct bpf_prog_array **array)
 {
-	enum bpf_cgroup_storage_type stype;
+	struct bpf_prog_array_item *item;
 	struct bpf_prog_array *progs;
 	struct bpf_prog_list *pl;
 	struct cgroup *p = cgrp;
@@ -166,10 +215,10 @@ static int compute_effective_progs(struct cgroup *cgrp,
 			if (!pl->prog)
 				continue;
 
-			progs->items[cnt].prog = pl->prog;
-			for_each_cgroup_storage_type(stype)
-				progs->items[cnt].cgroup_storage[stype] =
-					pl->storage[stype];
+			item = &progs->items[cnt];
+			item->prog = pl->prog;
+			bpf_cgroup_storages_assign(item->cgroup_storage,
+						   pl->storage);
 			cnt++;
 		}
 	} while ((p = cgroup_parent(p)));
@@ -305,7 +354,6 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
 		*old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {NULL};
 	struct bpf_prog_list *pl, *replace_pl = NULL;
-	enum bpf_cgroup_storage_type stype;
 	int err;
 
 	if (((flags & BPF_F_ALLOW_OVERRIDE) && (flags & BPF_F_ALLOW_MULTI)) ||
@@ -341,37 +389,25 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
 		replace_pl = list_first_entry(progs, typeof(*pl), node);
 	}
 
-	for_each_cgroup_storage_type(stype) {
-		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
-		if (IS_ERR(storage[stype])) {
-			storage[stype] = NULL;
-			for_each_cgroup_storage_type(stype)
-				bpf_cgroup_storage_free(storage[stype]);
-			return -ENOMEM;
-		}
-	}
+	if (bpf_cgroup_storages_alloc(storage, prog))
+		return -ENOMEM;
 
 	if (replace_pl) {
 		pl = replace_pl;
 		old_prog = pl->prog;
-		for_each_cgroup_storage_type(stype) {
-			old_storage[stype] = pl->storage[stype];
-			bpf_cgroup_storage_unlink(old_storage[stype]);
-		}
+		bpf_cgroup_storages_unlink(pl->storage);
+		bpf_cgroup_storages_assign(old_storage, pl->storage);
 	} else {
 		pl = kmalloc(sizeof(*pl), GFP_KERNEL);
 		if (!pl) {
-			for_each_cgroup_storage_type(stype)
-				bpf_cgroup_storage_free(storage[stype]);
+			bpf_cgroup_storages_free(storage);
 			return -ENOMEM;
 		}
 		list_add_tail(&pl->node, progs);
 	}
 
 	pl->prog = prog;
-	for_each_cgroup_storage_type(stype)
-		pl->storage[stype] = storage[stype];
-
+	bpf_cgroup_storages_assign(pl->storage, storage);
 	cgrp->bpf.flags[type] = saved_flags;
 
 	err = update_effective_progs(cgrp, type);
@@ -379,27 +415,20 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
 		goto cleanup;
 
 	static_branch_inc(&cgroup_bpf_enabled_key);
-	for_each_cgroup_storage_type(stype) {
-		if (!old_storage[stype])
-			continue;
-		bpf_cgroup_storage_free(old_storage[stype]);
-	}
+	bpf_cgroup_storages_free(old_storage);
 	if (old_prog) {
 		bpf_prog_put(old_prog);
 		static_branch_dec(&cgroup_bpf_enabled_key);
 	}
-	for_each_cgroup_storage_type(stype)
-		bpf_cgroup_storage_link(storage[stype], cgrp, type);
+	bpf_cgroup_storages_link(storage, cgrp, type);
 	return 0;
 
 cleanup:
 	/* and cleanup the prog list */
 	pl->prog = old_prog;
-	for_each_cgroup_storage_type(stype) {
-		bpf_cgroup_storage_free(pl->storage[stype]);
-		pl->storage[stype] = old_storage[stype];
-		bpf_cgroup_storage_link(old_storage[stype], cgrp, type);
-	}
+	bpf_cgroup_storages_free(pl->storage);
+	bpf_cgroup_storages_assign(pl->storage, old_storage);
+	bpf_cgroup_storages_link(pl->storage, cgrp, type);
 	if (!replace_pl) {
 		list_del(&pl->node);
 		kfree(pl);
@@ -420,7 +449,6 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 			enum bpf_attach_type type)
 {
 	struct list_head *progs = &cgrp->bpf.progs[type];
-	enum bpf_cgroup_storage_type stype;
 	u32 flags = cgrp->bpf.flags[type];
 	struct bpf_prog *old_prog = NULL;
 	struct bpf_prog_list *pl;
@@ -467,10 +495,8 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 
 	/* now can actually delete it from this cgroup list */
 	list_del(&pl->node);
-	for_each_cgroup_storage_type(stype) {
-		bpf_cgroup_storage_unlink(pl->storage[stype]);
-		bpf_cgroup_storage_free(pl->storage[stype]);
-	}
+	bpf_cgroup_storages_unlink(pl->storage);
+	bpf_cgroup_storages_free(pl->storage);
 	kfree(pl);
 	if (list_empty(progs))
 		/* last program was detached, reset flags to zero */
-- 
2.17.1

