Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01AC1BAEF4
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgD0UMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43100 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD0UMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:42 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03RK9Q4A024693
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PcMezHQbjKfu4buGJw3eLnPSkVpwW44/IYWu/gI+Si0=;
 b=lY/x/yp0AxkHvM2WZ1+g5hK17ET3VA2zlHwNu8+IwuivUKHXWFd7yuit99VLU8Zj37+c
 /SjdbkJ4fE1UABiyOzuMEWiX39Pa/uzUOCjTUhfUexPyho1uUIgnOEK2ayjoIdZms/no
 H1nUob6AizsS65vK1sObcRBvThM2GGIzhEI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30ntjvm1sn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:41 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:39 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id A967D3700871; Mon, 27 Apr 2020 13:12:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 02/19] bpf: implement an interface to register bpf_iter targets
Date:   Mon, 27 Apr 2020 13:12:36 -0700
Message-ID: <20200427201236.2994722-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004270164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The target can call bpf_iter_reg_target() to register itself.
The needed information:
  target:           target name, reprsented as a directory hierarchy
  target_func_name: the kernel func name used by verifier to
                    verify bpf programs
  seq_ops:          the seq_file operations for the target
  seq_priv_size:    the private_data size needed by the seq_file
                    operations
  target_feature:   certain feature requested by the target for
                    bpf_iter to prepare for seq_file operations.

A little bit more explanations on the target name and target_feature.
For example, the target name can be "bpf_map", "task", "task/file",
which represents iterating all bpf_map's, all tasks, or all files
of all tasks.

The target feature is mostly for reusing existing seq_file operations.
For example, /proc/net/{tcp6, ipv6_route, netlink, ...} seq_file private
data contains a reference to net namespace. When bpf_iter tries to
reuse the same seq_ops, its seq_file private data need the net namespace
setup properly too. In this case, the bpf_iter infrastructure can help
set up properly before doing seq_file operations.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   | 11 ++++++++++
 kernel/bpf/Makefile   |  2 +-
 kernel/bpf/bpf_iter.c | 50 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/bpf_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 10960cfabea4..5e56abc1e2f1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -31,6 +31,7 @@ struct seq_file;
 struct btf;
 struct btf_type;
 struct exception_table_entry;
+struct seq_operations;
=20
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1109,6 +1110,16 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
+struct bpf_iter_reg {
+	const char *target;
+	const char *target_func_name;
+	const struct seq_operations *seq_ops;
+	u32 seq_priv_size;
+	u32 target_feature;
+};
+
+int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
+
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index f2d7be596966..6a8b0febd3f6 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -2,7 +2,7 @@
 obj-y :=3D core.o
 CFLAGS_core.o +=3D $(call cc-disable-warning, override-init)
=20
-obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o
+obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D hashtab.o arraymap.o percpu_freelist.o bp=
f_lru_list.o lpm_trie.o map_in_map.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
new file mode 100644
index 000000000000..1115b978607a
--- /dev/null
+++ b/kernel/bpf/bpf_iter.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+
+#include <linux/fs.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
+
+struct bpf_iter_target_info {
+	struct list_head list;
+	const char *target;
+	const char *target_func_name;
+	const struct seq_operations *seq_ops;
+	u32 seq_priv_size;
+	u32 target_feature;
+};
+
+static struct list_head targets;
+static struct mutex targets_mutex;
+static bool bpf_iter_inited =3D false;
+
+int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
+{
+	struct bpf_iter_target_info *tinfo;
+
+	/* The earliest bpf_iter_reg_target() is called at init time
+	 * where the bpf_iter registration is serialized.
+	 */
+	if (!bpf_iter_inited) {
+		INIT_LIST_HEAD(&targets);
+		mutex_init(&targets_mutex);
+		bpf_iter_inited =3D true;
+	}
+
+	tinfo =3D kmalloc(sizeof(*tinfo), GFP_KERNEL);
+	if (!tinfo)
+		return -ENOMEM;
+
+	tinfo->target =3D reg_info->target;
+	tinfo->target_func_name =3D reg_info->target_func_name;
+	tinfo->seq_ops =3D reg_info->seq_ops;
+	tinfo->seq_priv_size =3D reg_info->seq_priv_size;
+	tinfo->target_feature =3D reg_info->target_feature;
+	INIT_LIST_HEAD(&tinfo->list);
+
+	mutex_lock(&targets_mutex);
+	list_add(&tinfo->list, &targets);
+	mutex_unlock(&targets_mutex);
+
+	return 0;
+}
--=20
2.24.1

