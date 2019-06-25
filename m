Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CCC55ACC
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfFYWN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:13:58 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:53472 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:13:57 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrLve019831
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:21 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrLhB038785;
        Tue, 25 Jun 2019 23:53:21 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v9 05/10] bpf,landlock: Add a new map type: inode
Date:   Tue, 25 Jun 2019 23:52:34 +0200
Message-Id: <20190625215239.11136-6-mic@digikod.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625215239.11136-1-mic@digikod.net>
References: <20190625215239.11136-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new map store arbitrary 64-bits values referenced by inode keys.
The map can be updated from user space with file descriptor pointing to
inodes tied to a file system.  From an eBPF (Landlock) program point of
view, such a map is read-only and can only be used to retrieved a
64-bits value tied to a given inode.  This is useful to recognize an
inode tagged by user space, without access right to this inode (i.e. no
need to have a write access to this inode).

Add dedicated BPF functions to handle this type of map:
* bpf_inode_map_update_elem()
* bpf_inode_map_lookup_elem()
* bpf_inode_map_delete_elem()

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Jann Horn <jann@thejh.net>
---

Changes since v8:
* remove prog chaining and object tagging to ease review
* use bpf_map_init_from_attr()

Changes since v7:
* new design with a dedicated map and a BPF function to tie a value to
  an inode
* add the ability to set or get a tag on an inode from a Landlock
  program

Changes since v6:
* remove WARN_ON() for missing dentry->d_inode
* refactor bpf_landlock_func_proto() (suggested by Kees Cook)

Changes since v5:
* cosmetic fixes and rebase

Changes since v4:
* use a file abstraction (handle) to wrap inode, dentry, path and file
  structs
* remove bpf_landlock_cmp_fs_beneath()
* rename the BPF helper and move it to kernel/bpf/
* tighten helpers accessible by a Landlock rule

Changes since v3:
* remove bpf_landlock_cmp_fs_prop() (suggested by Alexei Starovoitov)
* add hooks dealing with struct inode and struct path pointers:
  inode_permission and inode_getattr
* add abstraction over eBPF helper arguments thanks to wrapping structs
* add bpf_landlock_get_fs_mode() helper to check file type and mode
* merge WARN_ON() (suggested by Kees Cook)
* fix and update bpf_helpers.h
* use BPF_CALL_* for eBPF helpers (suggested by Alexei Starovoitov)
* make handle arraymap safe (RCU) and remove buggy synchronize_rcu()
* factor out the arraymay walk
* use size_t to index array (suggested by Jann Horn)

Changes since v2:
* add MNT_INTERNAL check to only add file handle from user-visible FS
  (e.g. no anonymous inode)
* replace struct file* with struct path* in map_landlock_handle
* add BPF protos
* fix bpf_landlock_cmp_fs_prop_with_struct_file()
---
 include/linux/bpf.h            |   9 +
 include/linux/bpf_types.h      |   3 +
 include/uapi/linux/bpf.h       |  12 +-
 kernel/bpf/Makefile            |   3 +
 kernel/bpf/core.c              |   2 +
 kernel/bpf/inodemap.c          | 315 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  27 ++-
 kernel/bpf/verifier.c          |  14 ++
 tools/include/uapi/linux/bpf.h |  12 +-
 tools/lib/bpf/libbpf_probes.c  |   1 +
 10 files changed, 395 insertions(+), 3 deletions(-)
 create mode 100644 kernel/bpf/inodemap.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index da167d3afecc..cc72ec18f0f6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -208,6 +208,8 @@ enum bpf_arg_type {
 	ARG_PTR_TO_INT,		/* pointer to int */
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
+
+	ARG_PTR_TO_INODE,	/* pointer to a struct inode */
 };
 
 /* type of values returned from helper functions */
@@ -278,6 +280,7 @@ enum bpf_reg_type {
 	PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
+	PTR_TO_INODE,		 /* reg points to struct inode */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -485,6 +488,7 @@ struct bpf_event_entry {
 	struct rcu_head rcu;
 };
 
+
 bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
 int bpf_prog_calc_tag(struct bpf_prog *fp);
 
@@ -689,6 +693,10 @@ int bpf_fd_array_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
 int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 				void *key, void *value, u64 map_flags);
 int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
+int bpf_inode_map_update_elem(struct bpf_map *map, int *key, u64 *value,
+			      u64 flags);
+int bpf_inode_map_lookup_elem(struct bpf_map *map, int *key, u64 *value);
+int bpf_inode_map_delete_elem(struct bpf_map *map, int *key);
 
 int bpf_get_file_flag(int flags);
 int bpf_check_uarg_tail_zero(void __user *uaddr, size_t expected_size,
@@ -1059,6 +1067,7 @@ extern const struct bpf_func_proto bpf_spin_unlock_proto;
 extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
+extern const struct bpf_func_proto bpf_inode_map_lookup_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index dee8b82e31b1..9e385473b57a 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -79,3 +79,6 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
+#ifdef CONFIG_SECURITY_LANDLOCK
+BPF_MAP_TYPE(BPF_MAP_TYPE_INODE, inode_ops)
+#endif
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 50145d448bc3..08ff720835ba 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_INODE,
 };
 
 /* Note that tracing related programs such as
@@ -2716,6 +2717,14 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * u64 bpf_inode_map_lookup(map, key)
+ * 	Description
+ * 		Perform a lookup in *map* for an entry associated to an inode
+ * 		*key*.
+ * 	Return
+ * 		Map value associated to *key*, or **NULL** if no entry was
+ * 		found.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2827,7 +2836,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(inode_map_lookup),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 29d781061cd5..e6fe613b3105 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -22,3 +22,6 @@ obj-$(CONFIG_CGROUP_BPF) += cgroup.o
 ifeq ($(CONFIG_INET),y)
 obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
 endif
+ifeq ($(CONFIG_SECURITY_LANDLOCK),y)
+obj-$(CONFIG_BPF_SYSCALL) += inodemap.o
+endif
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8ad392e52328..3cf5d16a8496 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2032,6 +2032,8 @@ const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
 
+const struct bpf_func_proto bpf_inode_map_update_proto __weak;
+
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
 	return NULL;
diff --git a/kernel/bpf/inodemap.c b/kernel/bpf/inodemap.c
new file mode 100644
index 000000000000..fcad0de51557
--- /dev/null
+++ b/kernel/bpf/inodemap.c
@@ -0,0 +1,315 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * inode map for Landlock
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2019 ANSSI
+ */
+
+#include <asm/resource.h> /* RLIMIT_NOFILE */
+#include <linux/bpf.h>
+#include <linux/err.h>
+#include <linux/file.h> /* fput() */
+#include <linux/filter.h> /* BPF_CALL_2() */
+#include <linux/fs.h> /* struct file */
+#include <linux/mm.h>
+#include <linux/mount.h> /* MNT_INTERNAL */
+#include <linux/path.h> /* struct path */
+#include <linux/sched/signal.h> /* rlimit() */
+#include <linux/security.h>
+#include <linux/slab.h>
+
+struct inode_elem {
+	struct inode *inode;
+	u64 value;
+};
+
+struct inode_array {
+	struct bpf_map map;
+	size_t nb_entries;
+	struct inode_elem elems[0];
+};
+
+/* must call iput(inode) after this call */
+static struct inode *inode_from_fd(int ufd, bool check_access)
+{
+	struct inode *ret;
+	struct fd f;
+	int deny;
+
+	f = fdget(ufd);
+	if (unlikely(!f.file || !file_inode(f.file))) {
+		ret = ERR_PTR(-EBADF);
+		goto put_fd;
+	}
+	/* TODO: add this check when called from an eBPF program too (already
+	 * checked by the LSM parent hooks anyway) */
+	if (unlikely(IS_PRIVATE(file_inode(f.file)))) {
+		ret = ERR_PTR(-EINVAL);
+		goto put_fd;
+	}
+	/* check if the FD is tied to a mount point */
+	/* TODO: add this check when called from an eBPF program too */
+	if (unlikely(!f.file->f_path.mnt || f.file->f_path.mnt->mnt_flags &
+				MNT_INTERNAL)) {
+		ret = ERR_PTR(-EINVAL);
+		goto put_fd;
+	}
+	if (check_access) {
+		/*
+		 * need to be allowed to access attributes from this file to
+		 * then be able to compare an inode to this entry
+		 */
+		deny = security_inode_getattr(&f.file->f_path);
+		if (deny) {
+			ret = ERR_PTR(deny);
+			goto put_fd;
+		}
+	}
+	ret = file_inode(f.file);
+	ihold(ret);
+
+put_fd:
+	fdput(f);
+	return ret;
+}
+
+/* (never) called from eBPF program */
+static int fake_map_delete_elem(struct bpf_map *map, void *key)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+/* called from syscall */
+static int sys_inode_map_delete_elem(struct bpf_map *map, struct inode *key)
+{
+	struct inode_array *array = container_of(map, struct inode_array, map);
+	struct inode *inode;
+	int i;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	for (i = 0; i < array->map.max_entries; i++) {
+		if (array->elems[i].inode == key) {
+			inode = xchg(&array->elems[i].inode, NULL);
+			array->nb_entries--;
+			iput(inode);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+/* called from syscall */
+int bpf_inode_map_delete_elem(struct bpf_map *map, int *key)
+{
+	struct inode *inode;
+	int err;
+
+	inode = inode_from_fd(*key, false);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	err = sys_inode_map_delete_elem(map, inode);
+	iput(inode);
+	return err;
+}
+
+static void inode_map_free(struct bpf_map *map)
+{
+	struct inode_array *array = container_of(map, struct inode_array, map);
+	int i;
+
+	synchronize_rcu();
+	for (i = 0; i < array->map.max_entries; i++)
+		iput(array->elems[i].inode);
+	bpf_map_area_free(array);
+}
+
+static struct bpf_map *inode_map_alloc(union bpf_attr *attr)
+{
+	int numa_node = bpf_map_attr_numa_node(attr);
+	struct inode_array *array;
+	u64 array_size;
+
+	/* only allow root to create this type of map (for now), should be
+	 * removed when Landlock will be usable by unprivileged users */
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	/* the key is a file descriptor and the value must be 64-bits (for
+	 * now) */
+	if (attr->max_entries == 0 || attr->key_size != sizeof(u32) ||
+	    attr->value_size != FIELD_SIZEOF(struct inode_elem, value) ||
+	    attr->map_flags & ~(BPF_F_RDONLY | BPF_F_WRONLY) ||
+	    numa_node != NUMA_NO_NODE)
+		return ERR_PTR(-EINVAL);
+
+	if (attr->value_size > KMALLOC_MAX_SIZE)
+		/* if value_size is bigger, the user space won't be able to
+		 * access the elements.
+		 */
+		return ERR_PTR(-E2BIG);
+
+	/*
+	 * Limit number of entries in an inode map to the maximum number of
+	 * open files for the current process. The maximum number of file
+	 * references (including all inode maps) for a process is then
+	 * (RLIMIT_NOFILE - 1) * RLIMIT_NOFILE. If the process' RLIMIT_NOFILE
+	 * is 0, then any entry update is forbidden.
+	 *
+	 * An eBPF program can inherit all the inode map FD. The worse case is
+	 * to fill a bunch of arraymaps, create an eBPF program, close the
+	 * inode map FDs, and start again. The maximum number of inode map
+	 * entries can then be close to RLIMIT_NOFILE^3.
+	 */
+	if (attr->max_entries > rlimit(RLIMIT_NOFILE))
+		return ERR_PTR(-EMFILE);
+
+	array_size = sizeof(*array);
+	array_size += (u64) attr->max_entries * sizeof(struct inode_elem);
+
+	/* make sure there is no u32 overflow later in round_up() */
+	if (array_size >= U32_MAX - PAGE_SIZE)
+		return ERR_PTR(-ENOMEM);
+
+	/* allocate all map elements and zero-initialize them */
+	array = bpf_map_area_alloc(array_size, numa_node);
+	if (!array)
+		return ERR_PTR(-ENOMEM);
+
+	/* copy mandatory map attributes */
+	bpf_map_init_from_attr(&array->map, attr);
+	array->map.memory.pages = round_up(array_size, PAGE_SIZE) >> PAGE_SHIFT;
+
+	return &array->map;
+}
+
+/* (never) called from eBPF program */
+static void *fake_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	WARN_ON(1);
+	return ERR_PTR(-EINVAL);
+}
+
+/* called from syscall (wrapped) and eBPF program */
+static u64 inode_map_lookup_elem(struct bpf_map *map, struct inode *key)
+{
+	struct inode_array *array = container_of(map, struct inode_array, map);
+	size_t i;
+	u64 ret = 0;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	/* TODO: use rbtree to switch to O(log n) */
+	for (i = 0; i < array->map.max_entries; i++) {
+		if (array->elems[i].inode == key) {
+			ret = array->elems[i].value;
+			break;
+		}
+	}
+	return ret;
+}
+
+/*
+ * The key is a FD when called from a syscall, but an inode pointer when called
+ * from an eBPF program.
+ */
+
+/* called from syscall */
+int bpf_inode_map_lookup_elem(struct bpf_map *map, int *key, u64 *value)
+{
+	struct inode *inode;
+
+	inode = inode_from_fd(*key, false);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	*value = inode_map_lookup_elem(map, inode);
+	iput(inode);
+	if (!value)
+		return -ENOENT;
+	return 0;
+}
+
+/* (never) called from eBPF program */
+static int fake_map_update_elem(struct bpf_map *map, void *key, void *value,
+				u64 flags)
+{
+	WARN_ON(1);
+	/* do not leak an inode accessed by a Landlock program */
+	return -EINVAL;
+}
+
+/* called from syscall */
+static int sys_inode_map_update_elem(struct bpf_map *map, struct inode *key,
+		u64 *value, u64 flags)
+{
+	struct inode_array *array = container_of(map, struct inode_array, map);
+	size_t i;
+
+	if (unlikely(flags != BPF_ANY))
+		return -EINVAL;
+
+	if (unlikely(array->nb_entries >= array->map.max_entries))
+		/* all elements were pre-allocated, cannot insert a new one */
+		return -E2BIG;
+
+	for (i = 0; i < array->map.max_entries; i++) {
+		if (!array->elems[i].inode) {
+			/* the inode (key) is already grabbed by the caller */
+			ihold(key);
+			array->elems[i].inode = key;
+			array->elems[i].value = *value;
+			array->nb_entries++;
+			return 0;
+		}
+	}
+	WARN_ON(1);
+	return -ENOENT;
+}
+
+/* called from syscall */
+int bpf_inode_map_update_elem(struct bpf_map *map, int *key, u64 *value,
+			      u64 flags)
+{
+	struct inode *inode;
+	int err;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	inode = inode_from_fd(*key, true);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	err = sys_inode_map_update_elem(map, inode, value, flags);
+	iput(inode);
+	return err;
+}
+
+/* called from syscall or (never) from eBPF program */
+static int fake_map_get_next_key(struct bpf_map *map, void *key,
+				 void *next_key)
+{
+	/* do not leak a file descriptor */
+	return -EINVAL;
+}
+
+/* void map for eBPF program */
+const struct bpf_map_ops inode_ops = {
+	.map_alloc = inode_map_alloc,
+	.map_free = inode_map_free,
+	.map_get_next_key = fake_map_get_next_key,
+	.map_lookup_elem = fake_map_lookup_elem,
+	.map_delete_elem = fake_map_delete_elem,
+	.map_update_elem = fake_map_update_elem,
+};
+
+BPF_CALL_2(bpf_inode_map_lookup, struct bpf_map *, map, void *, key)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return inode_map_lookup_elem(map, key);
+}
+
+const struct bpf_func_proto bpf_inode_map_lookup_proto = {
+	.func		= bpf_inode_map_lookup,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_INODE,
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7dd3376904d4..ba2a09a7f813 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -720,6 +720,22 @@ static void *__bpf_copy_key(void __user *ukey, u64 key_size)
 	return NULL;
 }
 
+int __weak bpf_inode_map_update_elem(struct bpf_map *map, int *key,
+				     u64 *value, u64 flags)
+{
+	return -ENOTSUPP;
+}
+
+int __weak bpf_inode_map_lookup_elem(struct bpf_map *map, int *key, u64 *value)
+{
+	return -ENOTSUPP;
+}
+
+int __weak bpf_inode_map_delete_elem(struct bpf_map *map, int *key)
+{
+	return -ENOTSUPP;
+}
+
 /* last field in 'union bpf_attr' used by this command */
 #define BPF_MAP_LOOKUP_ELEM_LAST_FIELD flags
 
@@ -801,6 +817,8 @@ static int map_lookup_elem(union bpf_attr *attr)
 	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
 		   map->map_type == BPF_MAP_TYPE_STACK) {
 		err = map->ops->map_peek_elem(map, value);
+	} else if (map->map_type == BPF_MAP_TYPE_INODE) {
+		err = bpf_inode_map_lookup_elem(map, key, value);
 	} else {
 		rcu_read_lock();
 		if (map->ops->map_lookup_elem_sys_only)
@@ -951,6 +969,10 @@ static int map_update_elem(union bpf_attr *attr)
 	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
 		   map->map_type == BPF_MAP_TYPE_STACK) {
 		err = map->ops->map_push_elem(map, value, attr->flags);
+	} else if (map->map_type == BPF_MAP_TYPE_INODE) {
+		rcu_read_lock();
+		err = bpf_inode_map_update_elem(map, key, value, attr->flags);
+		rcu_read_unlock();
 	} else {
 		rcu_read_lock();
 		err = map->ops->map_update_elem(map, key, value, attr->flags);
@@ -1006,7 +1028,10 @@ static int map_delete_elem(union bpf_attr *attr)
 	preempt_disable();
 	__this_cpu_inc(bpf_prog_active);
 	rcu_read_lock();
-	err = map->ops->map_delete_elem(map, key);
+	if (map->map_type == BPF_MAP_TYPE_INODE)
+		err = bpf_inode_map_delete_elem(map, key);
+	else
+		err = map->ops->map_delete_elem(map, key);
 	rcu_read_unlock();
 	__this_cpu_dec(bpf_prog_active);
 	preempt_enable();
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 930260683d0a..ce3cd7fd8882 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -400,6 +400,7 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
+	[PTR_TO_INODE]		= "inode",
 };
 
 static char slot_type_char[] = {
@@ -1801,6 +1802,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_INODE:
 		return true;
 	default:
 		return false;
@@ -3254,6 +3256,10 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 			verbose(env, "verifier internal error\n");
 			return -EFAULT;
 		}
+	} else if (arg_type == ARG_PTR_TO_INODE) {
+		expected_type = PTR_TO_INODE;
+		if (type != expected_type)
+			goto err_type;
 	} else if (arg_type_is_mem_ptr(arg_type)) {
 		expected_type = PTR_TO_STACK;
 		/* One exception here. In case function allows for NULL to be
@@ -3462,6 +3468,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_sk_storage_delete)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_INODE:
+		if (func_id != BPF_FUNC_inode_map_lookup)
+			goto error;
+		break;
 	default:
 		break;
 	}
@@ -3530,6 +3540,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
 			goto error;
 		break;
+	case BPF_FUNC_inode_map_lookup:
+		if (map->map_type != BPF_MAP_TYPE_INODE)
+			goto error;
+		break;
 	default:
 		break;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 50145d448bc3..08ff720835ba 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_INODE,
 };
 
 /* Note that tracing related programs such as
@@ -2716,6 +2717,14 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * u64 bpf_inode_map_lookup(map, key)
+ * 	Description
+ * 		Perform a lookup in *map* for an entry associated to an inode
+ * 		*key*.
+ * 	Return
+ * 		Map value associated to *key*, or **NULL** if no entry was
+ * 		found.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2827,7 +2836,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(inode_map_lookup),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index f4f34cb8869a..000319a95bfb 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -249,6 +249,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 	case BPF_MAP_TYPE_XSKMAP:
 	case BPF_MAP_TYPE_SOCKHASH:
 	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
+	case BPF_MAP_TYPE_INODE:
 	default:
 		break;
 	}
-- 
2.20.1

