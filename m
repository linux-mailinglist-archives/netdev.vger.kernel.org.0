Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AC26F61D
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 23:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfGUVgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 17:36:47 -0400
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:50689 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfGUVgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 17:36:47 -0400
Received: from smtp7.infomaniak.ch (smtp7.infomaniak.ch [83.166.132.30])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id x6LLVmUI000354
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 23:31:48 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp7.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x6LLVjXN070520;
        Sun, 21 Jul 2019 23:31:46 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
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
Subject: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type: inode
Date:   Sun, 21 Jul 2019 23:31:12 +0200
Message-Id: <20190721213116.23476-7-mic@digikod.net>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190721213116.23476-1-mic@digikod.net>
References: <20190721213116.23476-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FIXME: 64-bits in the doc

This new map store arbitrary values referenced by inode keys.  The map
can be updated from user space with file descriptor pointing to inodes
tied to a file system.  From an eBPF (Landlock) program point of view,
such a map is read-only and can only be used to retrieved a value tied
to a given inode.  This is useful to recognize an inode tagged by user
space, without access right to this inode (i.e. no need to have a write
access to this inode).

Add dedicated BPF functions to handle this type of map:
* bpf_inode_htab_map_update_elem()
* bpf_inode_htab_map_lookup_elem()
* bpf_inode_htab_map_delete_elem()

This new map require a dedicated helper inode_map_lookup_elem() because
of the key which is a pointer to an opaque data (only provided by the
kernel).  This act like a (physical or cryptographic) key, which is why
it is also not allowed to get the next key.

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

Changes since v9:
* use a hash map for the inode map: integrate inodemap.c into hashtab.c
  * add map_put_key() to struct bpf_map_ops to enable to put an inode
    reference used as key
  * allow arbitrary value size instead of 64-bits
* handle inode and map lifetime with LSM hooks
* check access for inode lookup via syscall: similar to adding xattr,
  except it does not touch the file system (which is handy for read-only
  ones)
* force read-only inode map for Landlock programs
* rename inode_map_lookup() into inode_map_lookup_elem()
* fix inode and mnt checks (suggested by Al Viro)

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
 include/linux/bpf.h            |  16 +++
 include/linux/bpf_types.h      |   3 +
 include/linux/landlock.h       |   4 +
 include/uapi/linux/bpf.h       |  12 +-
 kernel/bpf/core.c              |   2 +
 kernel/bpf/hashtab.c           | 253 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  27 +++-
 kernel/bpf/verifier.c          |  14 ++
 security/landlock/common.h     |  14 ++
 security/landlock/hooks_fs.c   |  85 +++++++++++
 security/landlock/init.c       |  13 ++
 tools/include/uapi/linux/bpf.h |  12 +-
 tools/lib/bpf/libbpf_probes.c  |   1 +
 13 files changed, 453 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6d9c7a08713e..c507438e56b5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -47,6 +47,7 @@ struct bpf_map_ops {
 	void *(*map_fd_get_ptr)(struct bpf_map *map, struct file *map_file,
 				int fd);
 	void (*map_fd_put_ptr)(void *ptr);
+	void (*map_put_key)(void *key);
 	u32 (*map_gen_lookup)(struct bpf_map *map, struct bpf_insn *insn_buf);
 	u32 (*map_fd_sys_lookup_elem)(void *ptr);
 	void (*map_seq_show_elem)(struct bpf_map *map, void *key,
@@ -208,6 +209,8 @@ enum bpf_arg_type {
 	ARG_PTR_TO_INT,		/* pointer to int */
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
+
+	ARG_PTR_TO_INODE,	/* pointer to a struct inode */
 };
 
 /* type of values returned from helper functions */
@@ -278,6 +281,7 @@ enum bpf_reg_type {
 	PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
+	PTR_TO_INODE,		 /* reg points to struct inode */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -479,6 +483,7 @@ struct bpf_event_entry {
 	struct rcu_head rcu;
 };
 
+
 bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
 int bpf_prog_calc_tag(struct bpf_prog *fp);
 
@@ -684,6 +689,16 @@ int bpf_fd_array_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
 int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 				void *key, void *value, u64 map_flags);
 int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
+int bpf_inode_fd_htab_map_lookup_elem(struct bpf_map *map, int *key, void *value);
+int bpf_inode_fd_htab_map_delete_elem(struct bpf_map *map, int *key);
+int bpf_inode_ptr_unlocked_htab_map_delete_elem(struct bpf_map *map,
+						struct inode **key,
+						bool remove_in_inode);
+int bpf_inode_ptr_locked_htab_map_delete_elem(struct bpf_map *map,
+					      struct inode **key,
+					      bool remove_in_inode);
+int bpf_inode_fd_htab_map_update_elem(struct bpf_map *map, int *key,
+				      void *value, u64 map_flags);
 
 int bpf_get_file_flag(int flags);
 int bpf_check_uarg_tail_zero(void __user *uaddr, size_t expected_size,
@@ -1055,6 +1070,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_inode_map_lookup_elem_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 2ab647323f3a..ea177818d67e 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -80,3 +80,6 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
+#ifdef CONFIG_SECURITY_LANDLOCK
+BPF_MAP_TYPE(BPF_MAP_TYPE_INODE, htab_inode_ops)
+#endif
diff --git a/include/linux/landlock.h b/include/linux/landlock.h
index 8ac7942f50fc..731b89cdf977 100644
--- a/include/linux/landlock.h
+++ b/include/linux/landlock.h
@@ -9,6 +9,7 @@
 #ifndef _LINUX_LANDLOCK_H
 #define _LINUX_LANDLOCK_H
 
+#include <linux/bpf.h>
 #include <linux/errno.h>
 #include <linux/sched.h> /* task_struct */
 
@@ -31,4 +32,7 @@ static inline void get_seccomp_landlock(struct task_struct *tsk)
 }
 #endif /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
 
+int landlock_inode_add_map(struct inode *inode, struct bpf_map *map);
+void landlock_inode_remove_map(struct inode *inode, const struct bpf_map *map);
+
 #endif /* _LINUX_LANDLOCK_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d68613f737f3..2da054ca9c8b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_INODE,
 };
 
 /* Note that tracing related programs such as
@@ -2717,6 +2718,14 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * void *bpf_inode_map_lookup_elem(struct bpf_map *map, const void *key)
+ *	Description
+ *		Perform a lookup in *map* for an entry associated to an inode
+ *		*key*.
+ *	Return
+ *		Map value associated to *key*, or **NULL** if no entry was
+ *		found.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2828,7 +2837,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(inode_map_lookup_elem),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 16079550db6d..4177c818e5cd 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2040,6 +2040,8 @@ const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
 
+const struct bpf_func_proto bpf_inode_map_update_proto __weak;
+
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
 	return NULL;
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a62c8c9..4fc7755042f0 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1,13 +1,21 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2011-2014 PLUMgrid, http://plumgrid.com
  * Copyright (c) 2016 Facebook
+ * Copyright (c) 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright (c) 2019 ANSSI
  */
+#include <asm/resource.h> /* RLIMIT_NOFILE */
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/err.h>
 #include <linux/jhash.h>
+#include <linux/fs.h> /* iput() */
 #include <linux/filter.h>
+#include <linux/landlock.h>
+#include <linux/mount.h> /* MNT_INTERNAL */
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
+#include <linux/sched/signal.h> /* rlimit() */
 #include <uapi/linux/btf.h>
 #include "percpu_freelist.h"
 #include "bpf_lru_list.h"
@@ -684,6 +692,8 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 
 		map->ops->map_fd_put_ptr(ptr);
 	}
+	if (map->ops->map_put_key)
+		map->ops->map_put_key(l->key);
 
 	if (htab_is_prealloc(htab)) {
 		__pcpu_freelist_push(&htab->freelist, &l->fnode);
@@ -1514,3 +1524,246 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_gen_lookup = htab_of_map_gen_lookup,
 	.map_check_btf = map_check_no_btf,
 };
+
+/* inode_htab */
+
+static int inode_htab_map_alloc_check(union bpf_attr *attr)
+{
+	/* only allow root to create this type of map (for now), should be
+	 * removed when Landlock will be usable by unprivileged users */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* the key is a file descriptor */
+	if (attr->max_entries == 0 || attr->key_size != sizeof(int) ||
+	    (attr->map_flags & ~(BPF_F_RDONLY | BPF_F_WRONLY |
+				 BPF_F_RDONLY_PROG)) ||
+	    /* for now, force read-only map for eBPF programs because only
+	     * bpf_inode_map_lookup_elem() enable to access them */
+	    !(attr->map_flags & BPF_F_RDONLY_PROG) ||
+	    bpf_map_attr_numa_node(attr) != NUMA_NO_NODE)
+		return -EINVAL;
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
+		return -EMFILE;
+
+	/* decorelate UAPI from kernel API */
+	attr->key_size = sizeof(struct inode *);
+
+	return htab_map_alloc_check(attr);
+}
+
+static void inode_htab_put_key(void *key)
+{
+	struct inode **inode = key;
+
+	if ((*inode)->i_state & I_FREEING)
+		return;
+	iput(*inode);
+}
+
+/* called from syscall or (never) from eBPF program */
+static int map_get_next_no_key(struct bpf_map *map, void *key, void *next_key)
+{
+	/* do not leak a file descriptor */
+	return -ENOTSUPP;
+}
+
+/* must call iput(inode) after this call */
+static struct inode *inode_from_fd(int ufd, bool check_access)
+{
+	struct inode *ret;
+	struct fd f;
+	int deny;
+
+	f = fdget(ufd);
+	if (unlikely(!f.file))
+		return ERR_PTR(-EBADF);
+	/* TODO?: add this check when called from an eBPF program too (already
+	* checked by the LSM parent hooks anyway) */
+	if (unlikely(IS_PRIVATE(file_inode(f.file)))) {
+		ret = ERR_PTR(-EINVAL);
+		goto put_fd;
+	}
+	/* check if the FD is tied to a mount point */
+	/* TODO?: add this check when called from an eBPF program too */
+	if (unlikely(f.file->f_path.mnt->mnt_flags & MNT_INTERNAL)) {
+		ret = ERR_PTR(-EINVAL);
+		goto put_fd;
+	}
+	if (check_access) {
+		/*
+		* must be allowed to access attributes from this file to then
+		* be able to compare an inode to its map entry
+		*/
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
+/*
+ * The key is a FD when called from a syscall, but an inode address when called
+ * from an eBPF program.
+ */
+
+/* called from syscall */
+int bpf_inode_fd_htab_map_lookup_elem(struct bpf_map *map, int *key, void *value)
+{
+	void *ptr;
+	struct inode *inode;
+	int ret;
+
+	/* check inode access */
+	inode = inode_from_fd(*key, true);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	rcu_read_lock();
+	ptr = htab_map_lookup_elem(map, &inode);
+	iput(inode);
+	if (IS_ERR(ptr)) {
+		ret = PTR_ERR(ptr);
+	} else if (!ptr) {
+		ret = -ENOENT;
+	} else {
+		ret = 0;
+		copy_map_value(map, value, ptr);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+/* called from kernel */
+int bpf_inode_ptr_locked_htab_map_delete_elem(struct bpf_map *map,
+		struct inode **key, bool remove_in_inode)
+{
+	if (remove_in_inode)
+		landlock_inode_remove_map(*key, map);
+	return htab_map_delete_elem(map, key);
+}
+
+/* called from syscall */
+int bpf_inode_fd_htab_map_delete_elem(struct bpf_map *map, int *key)
+{
+	struct inode *inode;
+	int ret;
+
+	/* do not check inode access (similar to directory check) */
+	inode = inode_from_fd(*key, false);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	ret = bpf_inode_ptr_locked_htab_map_delete_elem(map, &inode, true);
+	iput(inode);
+	return ret;
+}
+
+/* called from syscall */
+int bpf_inode_fd_htab_map_update_elem(struct bpf_map *map, int *key, void *value,
+		u64 map_flags)
+{
+	struct inode *inode;
+	int ret;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	/* check inode access */
+	inode = inode_from_fd(*key, true);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	ret = htab_map_update_elem(map, &inode, value, map_flags);
+	if (!ret)
+		ret = landlock_inode_add_map(inode, map);
+	iput(inode);
+	return ret;
+}
+
+static void inode_htab_map_free(struct bpf_map *map)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct hlist_nulls_node *n;
+	struct hlist_nulls_head *head;
+	struct htab_elem *l;
+	int i;
+
+	for (i = 0; i < htab->n_buckets; i++) {
+		head = select_bucket(htab, i);
+		hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
+			landlock_inode_remove_map(*((struct inode **)l->key), map);
+		}
+	}
+	htab_map_free(map);
+}
+
+/* use the map_inode_lookup_elem() helper instead */
+static void *map_lookup_no_elem(struct bpf_map *map, void *key)
+{
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
+static int map_delete_no_elem(struct bpf_map *map, void *key)
+{
+	WARN_ON_ONCE(1);
+	return -ENOTSUPP;
+}
+
+static int map_update_no_elem(struct bpf_map *map, void *key, void *value,
+		u64 flags)
+{
+	WARN_ON_ONCE(1);
+	return -ENOTSUPP;
+}
+
+const struct bpf_map_ops htab_inode_ops = {
+	.map_alloc_check = inode_htab_map_alloc_check,
+	.map_alloc = htab_map_alloc,
+	.map_free = inode_htab_map_free,
+	.map_put_key = inode_htab_put_key,
+	.map_get_next_key = map_get_next_no_key,
+	.map_lookup_elem = map_lookup_no_elem,
+	.map_delete_elem = map_delete_no_elem,
+	.map_update_elem = map_update_no_elem,
+	.map_check_btf = map_check_no_btf,
+};
+
+/*
+ * We need a dedicated helper to deal with inode maps because the key is a
+ * pointer to an opaque data, only provided by the kernel.  This really act
+ * like a (physical or cryptographic) key, which is why it is also not allowed
+ * to get the next key with map_get_next_key().
+ */
+BPF_CALL_2(bpf_inode_map_lookup_elem, struct bpf_map *, map, void *, key)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return (unsigned long)htab_map_lookup_elem(map, &key);
+}
+
+const struct bpf_func_proto bpf_inode_map_lookup_elem_proto = {
+	.func		= bpf_inode_map_lookup_elem,
+	.gpl_only	= false,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_INODE,
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b2a8cb14f28e..e46441c42b68 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -801,6 +801,8 @@ static int map_lookup_elem(union bpf_attr *attr)
 	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
 		   map->map_type == BPF_MAP_TYPE_STACK) {
 		err = map->ops->map_peek_elem(map, value);
+	} else if (map->map_type == BPF_MAP_TYPE_INODE) {
+		err = bpf_inode_fd_htab_map_lookup_elem(map, key, value);
 	} else {
 		rcu_read_lock();
 		if (map->ops->map_lookup_elem_sys_only)
@@ -951,6 +953,10 @@ static int map_update_elem(union bpf_attr *attr)
 	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
 		   map->map_type == BPF_MAP_TYPE_STACK) {
 		err = map->ops->map_push_elem(map, value, attr->flags);
+	} else if (map->map_type == BPF_MAP_TYPE_INODE) {
+		rcu_read_lock();
+		err = bpf_inode_fd_htab_map_update_elem(map, key, value, attr->flags);
+		rcu_read_unlock();
 	} else {
 		rcu_read_lock();
 		err = map->ops->map_update_elem(map, key, value, attr->flags);
@@ -1006,7 +1012,10 @@ static int map_delete_elem(union bpf_attr *attr)
 	preempt_disable();
 	__this_cpu_inc(bpf_prog_active);
 	rcu_read_lock();
-	err = map->ops->map_delete_elem(map, key);
+	if (map->map_type == BPF_MAP_TYPE_INODE)
+		err = bpf_inode_fd_htab_map_delete_elem(map, key);
+	else
+		err = map->ops->map_delete_elem(map, key);
 	rcu_read_unlock();
 	__this_cpu_dec(bpf_prog_active);
 	preempt_enable();
@@ -1018,6 +1027,22 @@ static int map_delete_elem(union bpf_attr *attr)
 	return err;
 }
 
+int bpf_inode_ptr_unlocked_htab_map_delete_elem(struct bpf_map *map,
+						struct inode **key, bool remove_in_inode)
+{
+	int err;
+
+	preempt_disable();
+	__this_cpu_inc(bpf_prog_active);
+	rcu_read_lock();
+	err = bpf_inode_ptr_locked_htab_map_delete_elem(map, key, remove_in_inode);
+	rcu_read_unlock();
+	__this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+	maybe_wait_bpf_programs(map);
+	return err;
+}
+
 /* last field in 'union bpf_attr' used by this command */
 #define BPF_MAP_GET_NEXT_KEY_LAST_FIELD next_key
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 026c68cb9116..3972b9f02dac 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -400,6 +400,7 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
+	[PTR_TO_INODE]		= "inode",
 };
 
 static char slot_type_char[] = {
@@ -1846,6 +1847,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_INODE:
 		return true;
 	default:
 		return false;
@@ -3306,6 +3308,10 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
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
@@ -3511,6 +3517,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_sk_storage_delete)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_INODE:
+		if (func_id != BPF_FUNC_inode_map_lookup_elem)
+			goto error;
+		break;
 	default:
 		break;
 	}
@@ -3579,6 +3589,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
 			goto error;
 		break;
+	case BPF_FUNC_inode_map_lookup_elem:
+		if (map->map_type != BPF_MAP_TYPE_INODE)
+			goto error;
+		break;
 	default:
 		break;
 	}
diff --git a/security/landlock/common.h b/security/landlock/common.h
index b2ee018eb6fc..b0ba3f31ac7d 100644
--- a/security/landlock/common.h
+++ b/security/landlock/common.h
@@ -11,6 +11,7 @@
 
 #include <linux/bpf.h> /* enum bpf_attach_type */
 #include <linux/filter.h> /* bpf_prog */
+#include <linux/lsm_hooks.h> /* lsm_blob_sizes */
 #include <linux/refcount.h> /* refcount_t */
 #include <uapi/linux/landlock.h> /* LANDLOCK_TRIGGER_* */
 
@@ -23,6 +24,8 @@
 #define _LANDLOCK_TRIGGER_FS_PICK_LAST	LANDLOCK_TRIGGER_FS_PICK_WRITE
 #define _LANDLOCK_TRIGGER_FS_PICK_MASK	((_LANDLOCK_TRIGGER_FS_PICK_LAST << 1ULL) - 1)
 
+extern struct lsm_blob_sizes landlock_blob_sizes;
+
 enum landlock_hook_type {
 	LANDLOCK_HOOK_FS_PICK = 1,
 	LANDLOCK_HOOK_FS_WALK,
@@ -55,6 +58,17 @@ struct landlock_prog_set {
 	refcount_t usage;
 };
 
+struct landlock_inode_map {
+	struct list_head list;
+	struct rcu_head rcu_put;
+	struct bpf_map *map;
+	/*
+	 * It would be nice to remove the inode field, but it is necessary for
+	 * call_rcu() .
+	 */
+	struct inode *inode;
+};
+
 /**
  * get_hook_index - get an index for the programs of struct landlock_prog_set
  *
diff --git a/security/landlock/hooks_fs.c b/security/landlock/hooks_fs.c
index 3f81b7fc2938..8c9d6a333111 100644
--- a/security/landlock/hooks_fs.c
+++ b/security/landlock/hooks_fs.c
@@ -46,6 +46,12 @@ bool landlock_is_valid_access_fs_pick(int off, enum bpf_access_type type,
 		enum bpf_reg_type *reg_type, int *max_size)
 {
 	switch (off) {
+	case offsetof(struct landlock_ctx_fs_pick, inode):
+		if (type != BPF_READ)
+			return false;
+		*reg_type = PTR_TO_INODE;
+		*max_size = sizeof(u64);
+		return true;
 	default:
 		return false;
 	}
@@ -55,6 +61,12 @@ bool landlock_is_valid_access_fs_walk(int off, enum bpf_access_type type,
 		enum bpf_reg_type *reg_type, int *max_size)
 {
 	switch (off) {
+	case offsetof(struct landlock_ctx_fs_walk, inode):
+		if (type != BPF_READ)
+			return false;
+		*reg_type = PTR_TO_INODE;
+		*max_size = sizeof(u64);
+		return true;
 	default:
 		return false;
 	}
@@ -237,8 +249,79 @@ static int hook_sb_pivotroot(const struct path *old_path,
 			new_path->dentry->d_inode);
 }
 
+/* inode helpers */
+
+static inline struct list_head *inode_landlock(const struct inode *inode)
+{
+	return inode->i_security + landlock_blob_sizes.lbs_inode;
+}
+
+int landlock_inode_add_map(struct inode *inode, struct bpf_map *map)
+{
+	struct landlock_inode_map *inode_map;
+
+	inode_map = kzalloc(sizeof(*inode_map), GFP_ATOMIC);
+	if (!inode_map)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&inode_map->list);
+	inode_map->map = map;
+	inode_map->inode = inode;
+	list_add_tail(&inode_map->list, inode_landlock(inode));
+	return 0;
+}
+
+static void put_landlock_inode_map(struct rcu_head *head)
+{
+	struct landlock_inode_map *inode_map;
+	int err;
+
+	inode_map = container_of(head, struct landlock_inode_map, rcu_put);
+	err = bpf_inode_ptr_unlocked_htab_map_delete_elem(inode_map->map,
+			&inode_map->inode, false);
+	bpf_map_put(inode_map->map);
+	kfree(inode_map);
+}
+
+void landlock_inode_remove_map(struct inode *inode, const struct bpf_map *map)
+{
+	struct landlock_inode_map *inode_map;
+	bool found = false;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode_map, inode_landlock(inode), list) {
+		if (inode_map->map == map) {
+			found = true;
+			list_del_rcu(&inode_map->list);
+			kfree_rcu(inode_map, rcu_put);
+			break;
+		}
+	}
+	rcu_read_unlock();
+	WARN_ON(!found);
+}
+
 /* inode hooks */
 
+static int hook_inode_alloc_security(struct inode *inode)
+{
+	struct list_head *ll_inode = inode_landlock(inode);
+
+	INIT_LIST_HEAD(ll_inode);
+	return 0;
+}
+
+static void hook_inode_free_security(struct inode *inode)
+{
+	struct landlock_inode_map *inode_map;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode_map, inode_landlock(inode), list) {
+		list_del_rcu(&inode_map->list);
+		call_rcu(&inode_map->rcu_put, put_landlock_inode_map);
+	}
+	rcu_read_unlock();
+}
+
 /* a directory inode contains only one dentry */
 static int hook_inode_create(struct inode *dir, struct dentry *dentry,
 		umode_t mode)
@@ -517,6 +600,8 @@ static struct security_hook_list landlock_hooks[] = {
 	LSM_HOOK_INIT(sb_mount, hook_sb_mount),
 	LSM_HOOK_INIT(sb_pivotroot, hook_sb_pivotroot),
 
+	LSM_HOOK_INIT(inode_alloc_security, hook_inode_alloc_security),
+	LSM_HOOK_INIT(inode_free_security, hook_inode_free_security),
 	LSM_HOOK_INIT(inode_create, hook_inode_create),
 	LSM_HOOK_INIT(inode_link, hook_inode_link),
 	LSM_HOOK_INIT(inode_unlink, hook_inode_unlink),
diff --git a/security/landlock/init.c b/security/landlock/init.c
index 391e88bd4d3a..eec4467cb5ee 100644
--- a/security/landlock/init.c
+++ b/security/landlock/init.c
@@ -104,6 +104,18 @@ static const struct bpf_func_proto *bpf_landlock_func_proto(
 	default:
 		break;
 	}
+
+	switch (get_hook_type(prog)) {
+	case LANDLOCK_HOOK_FS_WALK:
+	case LANDLOCK_HOOK_FS_PICK:
+		switch (func_id) {
+		case BPF_FUNC_inode_map_lookup_elem:
+			return &bpf_inode_map_lookup_elem_proto;
+		default:
+			break;
+		}
+		break;
+	}
 	return NULL;
 }
 
@@ -123,6 +135,7 @@ static int __init landlock_init(void)
 }
 
 struct lsm_blob_sizes landlock_blob_sizes __lsm_ro_after_init = {
+	.lbs_inode = sizeof(struct list_head),
 };
 
 DEFINE_LSM(LANDLOCK_NAME) = {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7b7a4f6c3104..7a55535f5dc1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_INODE,
 };
 
 /* Note that tracing related programs such as
@@ -2714,6 +2715,14 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * void *bpf_inode_map_lookup_elem(struct bpf_map *map, const void *key)
+ *	Description
+ *		Perform a lookup in *map* for an entry associated to an inode
+ *		*key*.
+ *	Return
+ *		Map value associated to *key*, or **NULL** if no entry was
+ *		found.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2825,7 +2834,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(inode_map_lookup_elem),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 03c910d1f84c..98875221310d 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -250,6 +250,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 	case BPF_MAP_TYPE_XSKMAP:
 	case BPF_MAP_TYPE_SOCKHASH:
 	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
+	case BPF_MAP_TYPE_INODE:
 	default:
 		break;
 	}
-- 
2.22.0

