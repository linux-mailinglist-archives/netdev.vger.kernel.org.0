Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE0635DE79
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbhDMMQW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 08:16:22 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:46072 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243990AbhDMMQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:16:15 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-DhlZXKJDM-epo_dJNf3p0Q-1; Tue, 13 Apr 2021 08:15:51 -0400
X-MC-Unique: DhlZXKJDM-epo_dJNf3p0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBFE279EF6;
        Tue, 13 Apr 2021 12:15:27 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6D22104C412;
        Tue, 13 Apr 2021 12:15:24 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCHv2 RFC bpf-next 2/7] bpf: Add bpf_functions object
Date:   Tue, 13 Apr 2021 14:15:11 +0200
Message-Id: <20210413121516.1467989-3-jolsa@kernel.org>
In-Reply-To: <20210413121516.1467989-1-jolsa@kernel.org>
References: <20210413121516.1467989-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_functions object to gather and carry functions
based on their BTF id. It will be used in following patch
to attach multiple functions to bpf ftrace probe program.

With bpf_functions object we can do such attachment at one
single moment, so it will speed up tools that need this.

New struct is added to union bpf_attr, that is used for
new command BPF_FUNCTIONS_ADD:

  struct { /* BPF_FUNCTIONS_ADD */
          __u32           fd;
          __u32           btf_id;
  } functions_add;

When fd == -1 new bpf_functions object is created with one
function (specified by btf_id) and its fd is returned.
For fd >= 0 the function (specified by btf_id) is added
to the existing object for the given fd.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/bpf.h       |   5 ++
 kernel/bpf/syscall.c           | 137 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |   5 ++
 3 files changed, 147 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e1ee1be7e49b..5d616735fe1b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -862,6 +862,7 @@ enum bpf_cmd {
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
 	BPF_PROG_BIND_MAP,
+	BPF_FUNCTIONS_ADD,
 };
 
 enum bpf_map_type {
@@ -1458,6 +1459,10 @@ union bpf_attr {
 		__u32		flags;		/* extra flags */
 	} prog_bind_map;
 
+	struct { /* BPF_FUNCTIONS_ADD */
+		__u32		fd;
+		__u32		btf_id;
+	} functions_add;
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 90cd58520bd4..b240a500cae5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2265,6 +2265,140 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	return err;
 }
 
+#define BPF_FUNCTIONS_ALLOC 100
+#define BPF_FUNCTIONS_MAX   (BPF_FUNCTIONS_ALLOC*10)
+
+struct bpf_functions {
+	struct mutex mutex;
+	unsigned long *addrs;
+	int cnt;
+	int alloc;
+};
+
+static int bpf_functions_release(struct inode *inode, struct file *file)
+{
+	struct bpf_functions *funcs = file->private_data;
+
+	kfree(funcs->addrs);
+	kfree(funcs);
+	return 0;
+}
+
+static const struct file_operations bpf_functions_fops = {
+	.release = bpf_functions_release,
+};
+
+static struct bpf_functions *bpf_functions_get_from_fd(u32 ufd, struct fd *p)
+{
+	struct fd f = fdget(ufd);
+
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+	if (f.file->f_op != &bpf_functions_fops) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
+	}
+	*p = f;
+	return f.file->private_data;
+}
+
+static unsigned long bpf_get_kernel_func_addr(u32 btf_id, struct btf *btf)
+{
+	const struct btf_type *t;
+	const char *tname;
+
+	t = btf_type_by_id(btf, btf_id);
+	if (!t)
+		return 0;
+	tname = btf_name_by_offset(btf, t->name_off);
+	if (!tname)
+		return 0;
+	if (!btf_type_is_func(t))
+		return 0;
+	t = btf_type_by_id(btf, t->type);
+	if (!btf_type_is_func_proto(t))
+		return 0;
+
+	return kallsyms_lookup_name(tname);
+}
+
+#define BPF_FUNCTIONS_ADD_LAST_FIELD functions_add.btf_id
+
+static int bpf_functions_add(union bpf_attr *attr)
+{
+	struct bpf_functions *funcs;
+	unsigned long addr, *p;
+	struct fd orig = { };
+	int ret = 0, fd;
+	struct btf *btf;
+
+	if (CHECK_ATTR(BPF_FUNCTIONS_ADD))
+		return -EINVAL;
+
+	if (!attr->functions_add.btf_id)
+		return -EINVAL;
+
+	/* fd >=  0  use existing bpf_functions object
+	 * fd == -1  create new bpf_functions object
+	 */
+	fd = attr->functions_add.fd;
+	if (fd < -1)
+		return -EINVAL;
+
+	btf = bpf_get_btf_vmlinux();
+	if (!btf)
+		return -EINVAL;
+
+	addr = bpf_get_kernel_func_addr(attr->functions_add.btf_id, btf);
+	if (!addr)
+		return -EINVAL;
+
+	if (!ftrace_location(addr))
+		return -EINVAL;
+
+	if (fd >= 0) {
+		funcs = bpf_functions_get_from_fd(fd, &orig);
+		if (IS_ERR(funcs))
+			return PTR_ERR(funcs);
+	} else {
+		funcs = kzalloc(sizeof(*funcs), GFP_USER);
+		if (!funcs)
+			return -ENOMEM;
+
+		mutex_init(&funcs->mutex);
+		fd = anon_inode_getfd("bpf-functions", &bpf_functions_fops,
+				      funcs, O_CLOEXEC);
+		if (fd < 0) {
+			kfree(funcs);
+			return fd;
+		}
+		ret = fd;
+	}
+
+	mutex_lock(&funcs->mutex);
+
+	if (funcs->cnt == BPF_FUNCTIONS_MAX) {
+		ret = -EINVAL;
+		goto out_put;
+	}
+	if (funcs->cnt == funcs->alloc) {
+		funcs->alloc += BPF_FUNCTIONS_ALLOC;
+		p = krealloc(funcs->addrs, funcs->alloc * sizeof(p[0]), GFP_USER);
+		if (!p) {
+			ret = -ENOMEM;
+			goto out_put;
+		}
+		funcs->addrs = p;
+	}
+
+	funcs->addrs[funcs->cnt++] = addr;
+
+out_put:
+	mutex_unlock(&funcs->mutex);
+	fdput(orig);
+	return ret;
+}
+
 #define BPF_OBJ_LAST_FIELD file_flags
 
 static int bpf_obj_pin(const union bpf_attr *attr)
@@ -4487,6 +4621,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_PROG_BIND_MAP:
 		err = bpf_prog_bind_map(&attr);
 		break;
+	case BPF_FUNCTIONS_ADD:
+		err = bpf_functions_add(&attr);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e1ee1be7e49b..5d616735fe1b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -862,6 +862,7 @@ enum bpf_cmd {
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
 	BPF_PROG_BIND_MAP,
+	BPF_FUNCTIONS_ADD,
 };
 
 enum bpf_map_type {
@@ -1458,6 +1459,10 @@ union bpf_attr {
 		__u32		flags;		/* extra flags */
 	} prog_bind_map;
 
+	struct { /* BPF_FUNCTIONS_ADD */
+		__u32		fd;
+		__u32		btf_id;
+	} functions_add;
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
-- 
2.30.2

