Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78356A11F2
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfH2GpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727035AbfH2GpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:12 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6jB6E002509
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=hQIzsHayAyex0TK2IjHU272wj4yUeThc332xjAs5G4U=;
 b=M6/dO0n9dyZlStqP/gsqCEq7OVAoQw4DREsSw6CD63LBApRIgxaVjh7mQDYjc62i2KE0
 a60hgcgKMCB1DKlXLZiEie7aRTGLszn9PF6IEPJYSQY/GlnILUtCsKMh1m3zMZJn2C9/
 LnsCJj7zyjkSshilpphiPaEo7AQa+j4KqcI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2up8cqr83w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:11 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 23:45:10 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 2D8C93702BA3; Wed, 28 Aug 2019 23:45:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 02/13] bpf: refactor map_update_elem()
Date:   Wed, 28 Aug 2019 23:45:04 -0700
Message-ID: <20190829064504.2750444-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=756
 adultscore=0 suspectscore=25 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290073
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor function map_update_elem() by creating a
helper function bpf_map_update_elem() which will be
used later by batched map update operation.

Also reuse function bpf_map_value_size()
in map_update_elem().

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/syscall.c | 113 ++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 56 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 211e0bc667bd..3caa0ab3d30d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -878,6 +878,61 @@ static void maybe_wait_bpf_programs(struct bpf_map *map)
 		synchronize_rcu();
 }
 
+static int bpf_map_update_elem(struct bpf_map *map, void *key, void *value,
+			       struct fd *f, __u64 flags) {
+	int err;
+
+	/* Need to create a kthread, thus must support schedule */
+	if (bpf_map_is_dev_bound(map)) {
+		return bpf_map_offload_update_elem(map, key, value, flags);
+	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
+		   map->map_type == BPF_MAP_TYPE_SOCKHASH ||
+		   map->map_type == BPF_MAP_TYPE_SOCKMAP) {
+		return map->ops->map_update_elem(map, key, value, flags);
+	}
+
+	/* must increment bpf_prog_active to avoid kprobe+bpf triggering from
+	 * inside bpf map update or delete otherwise deadlocks are possible
+	 */
+	preempt_disable();
+	__this_cpu_inc(bpf_prog_active);
+	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
+		err = bpf_percpu_hash_update(map, key, value, flags);
+	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
+		err = bpf_percpu_array_update(map, key, value, flags);
+	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
+		err = bpf_percpu_cgroup_storage_update(map, key, value,
+						       flags);
+	} else if (IS_FD_ARRAY(map)) {
+		rcu_read_lock();
+		err = bpf_fd_array_map_update_elem(map, f->file, key, value,
+						   flags);
+		rcu_read_unlock();
+	} else if (map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
+		rcu_read_lock();
+		err = bpf_fd_htab_map_update_elem(map, f->file, key, value,
+						  flags);
+		rcu_read_unlock();
+	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
+		/* rcu_read_lock() is not needed */
+		err = bpf_fd_reuseport_array_update_elem(map, key, value,
+							 flags);
+	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
+		   map->map_type == BPF_MAP_TYPE_STACK) {
+		err = map->ops->map_push_elem(map, value, flags);
+	} else {
+		rcu_read_lock();
+		err = map->ops->map_update_elem(map, key, value, flags);
+		rcu_read_unlock();
+	}
+	__this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+	maybe_wait_bpf_programs(map);
+
+	return err;
+}
+
 #define BPF_MAP_UPDATE_ELEM_LAST_FIELD flags
 
 static int map_update_elem(union bpf_attr *attr)
@@ -915,13 +970,7 @@ static int map_update_elem(union bpf_attr *attr)
 		goto err_put;
 	}
 
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
-		value_size = round_up(map->value_size, 8) * num_possible_cpus();
-	else
-		value_size = map->value_size;
+	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
 	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
@@ -932,56 +981,8 @@ static int map_update_elem(union bpf_attr *attr)
 	if (copy_from_user(value, uvalue, value_size) != 0)
 		goto free_value;
 
-	/* Need to create a kthread, thus must support schedule */
-	if (bpf_map_is_dev_bound(map)) {
-		err = bpf_map_offload_update_elem(map, key, value, attr->flags);
-		goto out;
-	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
-		   map->map_type == BPF_MAP_TYPE_SOCKHASH ||
-		   map->map_type == BPF_MAP_TYPE_SOCKMAP) {
-		err = map->ops->map_update_elem(map, key, value, attr->flags);
-		goto out;
-	}
+	err = bpf_map_update_elem(map, key, value, &f, attr->flags);
 
-	/* must increment bpf_prog_active to avoid kprobe+bpf triggering from
-	 * inside bpf map update or delete otherwise deadlocks are possible
-	 */
-	preempt_disable();
-	__this_cpu_inc(bpf_prog_active);
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
-		err = bpf_percpu_hash_update(map, key, value, attr->flags);
-	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
-		err = bpf_percpu_array_update(map, key, value, attr->flags);
-	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
-		err = bpf_percpu_cgroup_storage_update(map, key, value,
-						       attr->flags);
-	} else if (IS_FD_ARRAY(map)) {
-		rcu_read_lock();
-		err = bpf_fd_array_map_update_elem(map, f.file, key, value,
-						   attr->flags);
-		rcu_read_unlock();
-	} else if (map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
-		rcu_read_lock();
-		err = bpf_fd_htab_map_update_elem(map, f.file, key, value,
-						  attr->flags);
-		rcu_read_unlock();
-	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
-		/* rcu_read_lock() is not needed */
-		err = bpf_fd_reuseport_array_update_elem(map, key, value,
-							 attr->flags);
-	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
-		   map->map_type == BPF_MAP_TYPE_STACK) {
-		err = map->ops->map_push_elem(map, value, attr->flags);
-	} else {
-		rcu_read_lock();
-		err = map->ops->map_update_elem(map, key, value, attr->flags);
-		rcu_read_unlock();
-	}
-	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
-	maybe_wait_bpf_programs(map);
-out:
 free_value:
 	kfree(value);
 free_key:
-- 
2.17.1

