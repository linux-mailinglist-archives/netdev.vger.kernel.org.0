Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF061AB1CC
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632916AbgDOTcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:32:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58822 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2411729AbgDOT2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:15 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03FJSCn0007656
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZbsCGaCv9Gsm85mgP5XUnKAzAoNTMbL2upv04wMKm5c=;
 b=AK5/ZCib4aeceMToaf33Wc8U1jlmW6QSEgEDrP789kAV/IiOSJS1T08f8PVvv1G/v5uA
 ee65iu9/tcpgRaRY79N9kaGQhyox27x0zeQRQCi+mBrQIWb58txKWPb93npwoHtEx4wH
 tD7n5drhueisJoveFwEd+wvokbESuEJtgTQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30dn7fymkx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:14 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:42 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 07AF43700AF5; Wed, 15 Apr 2020 12:27:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 02/17] bpf: create /sys/kernel/bpfdump mount file system
Date:   Wed, 15 Apr 2020 12:27:41 -0700
Message-ID: <20200415192741.4082788-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=2 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch creates a mount point "bpfdump" under
/sys/kernel. The file system has a single user
mode, i.e., all mount points will be identical.

The magic number I picked for the new file system
is "dump".

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/magic.h |  1 +
 kernel/bpf/Makefile        |  1 +
 kernel/bpf/dump.c          | 79 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)
 create mode 100644 kernel/bpf/dump.c

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index d78064007b17..4ce3d8882315 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -88,6 +88,7 @@
 #define BPF_FS_MAGIC		0xcafe4a11
 #define AAFS_MAGIC		0x5a3c69f0
 #define ZONEFS_MAGIC		0x5a4f4653
+#define DUMPFS_MAGIC		0x64756d70
=20
 /* Since UDF 2.01 is ISO 13346 based... */
 #define UDF_SUPER_MAGIC		0x15013346
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index f2d7be596966..4a1376ab2bea 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_BPF_SYSCALL) +=3D reuseport_array.o
 endif
 ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_DEBUG_INFO_BTF) +=3D sysfs_btf.o
+obj-$(CONFIG_BPF_SYSCALL) +=3D dump.o
 endif
 ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) +=3D bpf_struct_ops.o
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
new file mode 100644
index 000000000000..e0c33486e0e7
--- /dev/null
+++ b/kernel/bpf/dump.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+
+#include <linux/init.h>
+#include <linux/magic.h>
+#include <linux/mount.h>
+#include <linux/anon_inodes.h>
+#include <linux/namei.h>
+#include <linux/fs.h>
+#include <linux/fs_context.h>
+#include <linux/fs_parser.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
+
+static void bpfdump_free_inode(struct inode *inode)
+{
+	kfree(inode->i_private);
+	free_inode_nonrcu(inode);
+}
+
+static const struct super_operations bpfdump_super_operations =3D {
+	.statfs		=3D simple_statfs,
+	.free_inode	=3D bpfdump_free_inode,
+};
+
+static int bpfdump_fill_super(struct super_block *sb, struct fs_context =
*fc)
+{
+	static const struct tree_descr files[] =3D { { "" } };
+	int err;
+
+	err =3D simple_fill_super(sb, DUMPFS_MAGIC, files);
+	if (err)
+		return err;
+
+	sb->s_op =3D &bpfdump_super_operations;
+	return 0;
+}
+
+static int bpfdump_get_tree(struct fs_context *fc)
+{
+	return get_tree_single(fc, bpfdump_fill_super);
+}
+
+static const struct fs_context_operations bpfdump_context_ops =3D {
+	.get_tree	=3D bpfdump_get_tree,
+};
+
+static int bpfdump_init_fs_context(struct fs_context *fc)
+{
+	fc->ops =3D &bpfdump_context_ops;
+	return 0;
+}
+
+static struct file_system_type fs_type =3D {
+	.owner			=3D THIS_MODULE,
+	.name			=3D "bpfdump",
+	.init_fs_context	=3D bpfdump_init_fs_context,
+	.kill_sb		=3D kill_litter_super,
+};
+
+static int __init bpfdump_init(void)
+{
+	int ret;
+
+	ret =3D sysfs_create_mount_point(kernel_kobj, "bpfdump");
+	if (ret)
+		return ret;
+
+	ret =3D register_filesystem(&fs_type);
+	if (ret)
+		goto remove_mount;
+
+	return 0;
+
+remove_mount:
+	sysfs_remove_mount_point(kernel_kobj, "bpfdump");
+	return ret;
+}
+core_initcall(bpfdump_init);
--=20
2.24.1

