Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6321CC38C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 20:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgEIR74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:59:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728588AbgEIR7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:59:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049Hwuet007592
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 10:59:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7LfUxTXm5eVGWabUzU56UrV6UR9Br3Of4yXZL2a+7Bo=;
 b=GgUepiCLT/GlR3sZcrl5gmNpcu5QVc+MorslBE2i9LP+lpjrzKVJDnhT1F4wdPr7leHn
 u0g90qR8plUHOwSy9CuFKDv7NWjiiwPaYexNk8PdzWew4KSoIorRGtMFT6MZjDkBIF8w
 OcxthtaRqN97IFwWe1y8p+7P9pAYhCJvKC4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wutt12qw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:59:13 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:59:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 3599837008E2; Sat,  9 May 2020 10:59:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 09/21] bpf: add bpf_map iterator
Date:   Sat, 9 May 2020 10:59:09 -0700
Message-ID: <20200509175909.2476096-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200509175859.2474608-1-yhs@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement seq_file operations to traverse all bpf_maps.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/Makefile   |  2 +-
 kernel/bpf/map_iter.c | 97 +++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c  | 19 +++++++++
 4 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/map_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ffe0b9b669bf..363ab0751967 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1082,6 +1082,7 @@ int  generic_map_update_batch(struct bpf_map *map,
 int  generic_map_delete_batch(struct bpf_map *map,
 			      const union bpf_attr *attr,
 			      union bpf_attr __user *uattr);
+struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
=20
 extern int sysctl_unprivileged_bpf_disabled;
=20
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 6a8b0febd3f6..b2b5eefc5254 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -2,7 +2,7 @@
 obj-y :=3D core.o
 CFLAGS_core.o +=3D $(call cc-disable-warning, override-init)
=20
-obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o
+obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o map_iter.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D hashtab.o arraymap.o percpu_freelist.o bp=
f_lru_list.o lpm_trie.o map_in_map.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
new file mode 100644
index 000000000000..8162e0c00b9f
--- /dev/null
+++ b/kernel/bpf/map_iter.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <linux/bpf.h>
+#include <linux/fs.h>
+#include <linux/filter.h>
+#include <linux/kernel.h>
+
+struct bpf_iter_seq_map_info {
+	u32 mid;
+};
+
+static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_map_info *info =3D seq->private;
+	struct bpf_map *map;
+
+	map =3D bpf_map_get_curr_or_next(&info->mid);
+	if (!map)
+		return NULL;
+
+	++*pos;
+	return map;
+}
+
+static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos=
)
+{
+	struct bpf_iter_seq_map_info *info =3D seq->private;
+	struct bpf_map *map;
+
+	++*pos;
+	++info->mid;
+	bpf_map_put((struct bpf_map *)v);
+	map =3D bpf_map_get_curr_or_next(&info->mid);
+	if (!map)
+		return NULL;
+
+	return map;
+}
+
+struct bpf_iter__bpf_map {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct bpf_map *, map);
+};
+
+DEFINE_BPF_ITER_FUNC(bpf_map, struct bpf_iter_meta *meta, struct bpf_map=
 *map)
+
+static int __bpf_map_seq_show(struct seq_file *seq, void *v, bool in_sto=
p)
+{
+	struct bpf_iter__bpf_map ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret =3D 0;
+
+	ctx.meta =3D &meta;
+	ctx.map =3D v;
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, in_stop);
+	if (prog)
+		ret =3D bpf_iter_run_prog(prog, &ctx);
+
+	return ret;
+}
+
+static int bpf_map_seq_show(struct seq_file *seq, void *v)
+{
+	return __bpf_map_seq_show(seq, v, false);
+}
+
+static void bpf_map_seq_stop(struct seq_file *seq, void *v)
+{
+	if (!v)
+		(void)__bpf_map_seq_show(seq, v, true);
+	else
+		bpf_map_put((struct bpf_map *)v);
+}
+
+static const struct seq_operations bpf_map_seq_ops =3D {
+	.start	=3D bpf_map_seq_start,
+	.next	=3D bpf_map_seq_next,
+	.stop	=3D bpf_map_seq_stop,
+	.show	=3D bpf_map_seq_show,
+};
+
+static int __init bpf_map_iter_init(void)
+{
+	struct bpf_iter_reg reg_info =3D {
+		.target			=3D "bpf_map",
+		.seq_ops		=3D &bpf_map_seq_ops,
+		.init_seq_private	=3D NULL,
+		.fini_seq_private	=3D NULL,
+		.seq_priv_size		=3D sizeof(struct bpf_iter_seq_map_info),
+	};
+
+	return bpf_iter_reg_target(&reg_info);
+}
+
+late_initcall(bpf_map_iter_init);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a293e88ee01a..de2a75500233 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2934,6 +2934,25 @@ static int bpf_obj_get_next_id(const union bpf_att=
r *attr,
 	return err;
 }
=20
+struct bpf_map *bpf_map_get_curr_or_next(u32 *id)
+{
+	struct bpf_map *map;
+
+	spin_lock_bh(&map_idr_lock);
+again:
+	map =3D idr_get_next(&map_idr, id);
+	if (map) {
+		map =3D __bpf_map_inc_not_zero(map, false);
+		if (IS_ERR(map)) {
+			(*id)++;
+			goto again;
+		}
+	}
+	spin_unlock_bh(&map_idr_lock);
+
+	return map;
+}
+
 #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
=20
 struct bpf_prog *bpf_prog_by_id(u32 id)
--=20
2.24.1

