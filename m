Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8149A11F1
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfH2GpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59114 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbfH2GpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:11 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6ihWc006244
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=AiK/pFo/XwBZUzHWGjOFjAqApFtHw2017A6SjuqfLNw=;
 b=TvidOxQBOYXwcJvcQiaLJvEgjHxq0QuCJEkP5i1ksDnAk9HuWp6b5FPaNPrJl6xxVnBV
 hcvIVyS4o2UOK34u811my3OFqEvn/FgP2+J56+2X2hVBqXTzZFRW9OLRBQkkb5Tc/nCr
 6f56BneTfcqBR4zP4lJtHPI2VOZOyzZYdW0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2unvfykbrq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:09 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 23:45:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id EEC513702CAF; Wed, 28 Aug 2019 23:45:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 01/13] bpf: add bpf_map_value_size and bp_map_copy_value helper functions
Date:   Wed, 28 Aug 2019 23:45:02 -0700
Message-ID: <20190829064502.2750359-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=606 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0
 suspectscore=25 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290073
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Vazquez <brianvv@google.com>

Move reusable code from map_lookup_elem to helper functions to avoid code
duplication in kernel/bpf/syscall.c

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 kernel/bpf/syscall.c | 134 +++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 61 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ca60eafa6922..211e0bc667bd 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -126,6 +126,76 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 	return map;
 }
 
+static u32 bpf_map_value_size(struct bpf_map *map)
+{
+	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
+	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
+		return round_up(map->value_size, 8) * num_possible_cpus();
+	else if (IS_FD_MAP(map))
+		return sizeof(u32);
+	else
+		return  map->value_size;
+}
+
+static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
+			      __u64 flags)
+{
+	void *ptr;
+	int err;
+
+	if (bpf_map_is_dev_bound(map))
+		return  bpf_map_offload_lookup_elem(map, key, value);
+
+	preempt_disable();
+	this_cpu_inc(bpf_prog_active);
+	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
+		err = bpf_percpu_hash_copy(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
+		err = bpf_percpu_array_copy(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
+		err = bpf_percpu_cgroup_storage_copy(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_STACK_TRACE) {
+		err = bpf_stackmap_copy(map, key, value);
+	} else if (IS_FD_ARRAY(map)) {
+		err = bpf_fd_array_map_lookup_elem(map, key, value);
+	} else if (IS_FD_HASH(map)) {
+		err = bpf_fd_htab_map_lookup_elem(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
+		err = bpf_fd_reuseport_array_lookup_elem(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
+		   map->map_type == BPF_MAP_TYPE_STACK) {
+		err = map->ops->map_peek_elem(map, value);
+	} else {
+		rcu_read_lock();
+		if (map->ops->map_lookup_elem_sys_only)
+			ptr = map->ops->map_lookup_elem_sys_only(map, key);
+		else
+			ptr = map->ops->map_lookup_elem(map, key);
+		if (IS_ERR(ptr)) {
+			err = PTR_ERR(ptr);
+		} else if (!ptr) {
+			err = -ENOENT;
+		} else {
+			err = 0;
+			if (flags & BPF_F_LOCK)
+				/* lock 'ptr' and copy everything but lock */
+				copy_map_value_locked(map, value, ptr, true);
+			else
+				copy_map_value(map, value, ptr);
+			/* mask lock, since value wasn't zero inited */
+			check_and_init_map_lock(map, value);
+		}
+		rcu_read_unlock();
+	}
+	this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+
+	return err;
+}
+
 void *bpf_map_area_alloc(size_t size, int numa_node)
 {
 	/* We really just want to fail instead of triggering OOM killer
@@ -739,7 +809,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	void __user *uvalue = u64_to_user_ptr(attr->value);
 	int ufd = attr->map_fd;
 	struct bpf_map *map;
-	void *key, *value, *ptr;
+	void *key, *value;
 	u32 value_size;
 	struct fd f;
 	int err;
@@ -771,72 +841,14 @@ static int map_lookup_elem(union bpf_attr *attr)
 		goto err_put;
 	}
 
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
-		value_size = round_up(map->value_size, 8) * num_possible_cpus();
-	else if (IS_FD_MAP(map))
-		value_size = sizeof(u32);
-	else
-		value_size = map->value_size;
+	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
 	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
-	if (bpf_map_is_dev_bound(map)) {
-		err = bpf_map_offload_lookup_elem(map, key, value);
-		goto done;
-	}
-
-	preempt_disable();
-	this_cpu_inc(bpf_prog_active);
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
-		err = bpf_percpu_hash_copy(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
-		err = bpf_percpu_array_copy(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
-		err = bpf_percpu_cgroup_storage_copy(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_STACK_TRACE) {
-		err = bpf_stackmap_copy(map, key, value);
-	} else if (IS_FD_ARRAY(map)) {
-		err = bpf_fd_array_map_lookup_elem(map, key, value);
-	} else if (IS_FD_HASH(map)) {
-		err = bpf_fd_htab_map_lookup_elem(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
-		err = bpf_fd_reuseport_array_lookup_elem(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
-		   map->map_type == BPF_MAP_TYPE_STACK) {
-		err = map->ops->map_peek_elem(map, value);
-	} else {
-		rcu_read_lock();
-		if (map->ops->map_lookup_elem_sys_only)
-			ptr = map->ops->map_lookup_elem_sys_only(map, key);
-		else
-			ptr = map->ops->map_lookup_elem(map, key);
-		if (IS_ERR(ptr)) {
-			err = PTR_ERR(ptr);
-		} else if (!ptr) {
-			err = -ENOENT;
-		} else {
-			err = 0;
-			if (attr->flags & BPF_F_LOCK)
-				/* lock 'ptr' and copy everything but lock */
-				copy_map_value_locked(map, value, ptr, true);
-			else
-				copy_map_value(map, value, ptr);
-			/* mask lock, since value wasn't zero inited */
-			check_and_init_map_lock(map, value);
-		}
-		rcu_read_unlock();
-	}
-	this_cpu_dec(bpf_prog_active);
-	preempt_enable();
-
-done:
+	err = bpf_map_copy_value(map, key, value, attr->flags);
 	if (err)
 		goto free_value;
 
-- 
2.17.1

