Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3EF1C32BB
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 08:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgEDGZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 02:25:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26070 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727103AbgEDGZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 02:25:53 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0446PQWi003653
        for <netdev@vger.kernel.org>; Sun, 3 May 2020 23:25:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Nt21H0ywfeWQz0BLf5EibD/4l3ucyLE/pb4B1Wonzkc=;
 b=rG+vKwQqh5wojFYmg6/qT5ail2jrjVMbqQPaERGA1mZ7B6ugJoy2uj/62XwFEk+70NWt
 4T8HLHn3THaJjMWij4+xsMgq/l6O3ppl8DY1cJU28ArGTRjAALo5Igo2vz68xSsMMYv2
 IKh2YkFzaD9bIPK9XH/zSqoUgSGZI3ynq5o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30srvpucc4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 23:25:52 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 3 May 2020 23:25:51 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 608AA3702303; Sun,  3 May 2020 23:25:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 01/20] bpf: implement an interface to register bpf_iter targets
Date:   Sun, 3 May 2020 23:25:47 -0700
Message-ID: <20200504062547.2047362-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200504062547.2047304-1-yhs@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_03:2020-05-01,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The target can call bpf_iter_reg_target() to register itself.
The needed information:
  target:           target name
  seq_ops:          the seq_file operations for the target
  init_seq_private  target callback to initialize seq_priv during file op=
en
  fini_seq_private  target callback to clean up seq_priv during file rele=
ase
  seq_priv_size:    the private_data size needed by the seq_file
                    operations

The target name represents a target which provides a seq_ops
for iterating objects.

The target can provide two callback functions, init_seq_private
and fini_seq_private, called during file open/release time.
For example, /proc/net/{tcp6, ipv6_route, netlink, ...}, net
name space needs to be setup properly during file open and
released properly during file release.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   | 14 ++++++++++++++
 kernel/bpf/Makefile   |  2 +-
 kernel/bpf/bpf_iter.c | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/bpf_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1262ec460ab3..597b37c4e1c6 100644
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
@@ -1126,6 +1127,19 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
+typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
+typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
+
+struct bpf_iter_reg {
+	const char *target;
+	const struct seq_operations *seq_ops;
+	bpf_iter_init_seq_priv_t init_seq_private;
+	bpf_iter_fini_seq_priv_t fini_seq_private;
+	u32 seq_priv_size;
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
index 000000000000..ed930a0470e9
--- /dev/null
+++ b/kernel/bpf/bpf_iter.c
@@ -0,0 +1,40 @@
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
+	const struct seq_operations *seq_ops;
+	bpf_iter_init_seq_priv_t init_seq_private;
+	bpf_iter_fini_seq_priv_t fini_seq_private;
+	u32 seq_priv_size;
+};
+
+static struct list_head targets =3D LIST_HEAD_INIT(targets);
+static DEFINE_MUTEX(targets_mutex);
+
+int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
+{
+	struct bpf_iter_target_info *tinfo;
+
+	tinfo =3D kmalloc(sizeof(*tinfo), GFP_KERNEL);
+	if (!tinfo)
+		return -ENOMEM;
+
+	tinfo->target =3D reg_info->target;
+	tinfo->seq_ops =3D reg_info->seq_ops;
+	tinfo->init_seq_private =3D reg_info->init_seq_private;
+	tinfo->fini_seq_private =3D reg_info->fini_seq_private;
+	tinfo->seq_priv_size =3D reg_info->seq_priv_size;
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

