Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27F83D6FA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407297AbfFKTjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:39:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42816 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407038AbfFKTjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:39:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id l19so4924679pgh.9
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=9JhPHRJ//Liq2J1Eaumb7mcY6Y8fruxaazPTgysavQw=;
        b=WEvr1Yvx3xBXJPIevw99EkfCm3XMZliy5K4ruxr3hsZmQnfPPCbLiNvkdYa7Ark6nT
         YAlUKEgU4ER/VDUAG7dDaAzBJst6SUhQyfJxjNF+CR1ptKZxvB8ycIQw0ebMknH3NxZN
         vCzTjrBwUiOJzJMgi0Q6Jc31oSbttgzfPcEiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9JhPHRJ//Liq2J1Eaumb7mcY6Y8fruxaazPTgysavQw=;
        b=nQYtpfeMeNh1Ak15+LXM0IXCSGQAR3GjXRzDbghAk1kqGKTFIXydjMs7xnwP7PgmHr
         +EZjGaMKk/xZFQP7PblIXScg5j5TN/TGVn6PqzhPCLTsk+AA8DGuH05kjrRQWpC9WdMG
         VHDaiMJAZVTXSG2aiecE0fvPdbU6TgrCIj6hHY7FKwkSY6arRXZM2kUy3aKea4ZgCCJJ
         h3+ovAZLzRT446waOZ7m2tNKWdQvJzJPgrthN0SkoRvBujY+pMylp7IHyo6nhBV6hTCj
         V+6Q0OY6L1cZi4MuyesyfuRrm7sKF+6ZpZ3YakbYrpysNd2is/np8csJ+1iFf1WZWGYj
         G9cA==
X-Gm-Message-State: APjAAAW5BpwiVThXYMH5M0QgBL/XVcyffXXwKTMuSOCg2V4101xya0ly
        losShtcvFWyZ4QNZzvXycE/I0Q==
X-Google-Smtp-Source: APXvYqytxoLffkLW4Y6/AAKoA667Vfqq2DGA1AdkSkHE4QE2Rd6Spwj2C/XIimW04SoyPekb6m2WxQ==
X-Received: by 2002:a62:d45d:: with SMTP id u29mr17594797pfl.135.1560281941758;
        Tue, 11 Jun 2019 12:39:01 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:907:95d8:df34:7d03:729:feb7])
        by smtp.googlemail.com with ESMTPSA id l44sm5982611pje.29.2019.06.11.12.38.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 12:39:01 -0700 (PDT)
From:   Shyam Saini <shyam.saini@amarulasolutions.com>
To:     kernel-hardening@lists.openwall.com
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        keescook@chromium.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-ext4@vger.kernel.org,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, bpf@vger.kernel.org,
        kvm@vger.kernel.org, mayhs11saini@gmail.com,
        Shyam Saini <shyam.saini@amarulasolutions.com>
Subject: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF macro
Date:   Wed, 12 Jun 2019 01:08:36 +0530
Message-Id: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
and FIELD_SIZEOF which are used to calculate the size of a member of
structure, so to bring uniformity in entire kernel source tree lets use
FIELD_SIZEOF and replace all occurrences of other two macros with this.

For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
tools/testing/selftests/bpf/bpf_util.h and remove its defination from
include/linux/kernel.h

In favour of FIELD_SIZEOF, this patch also deprecates other two similar
macros sizeof_field and SIZEOF_FIELD.

For code compatibility reason, retain sizeof_field macro as a wrapper macro
to FIELD_SIZEOF

Signed-off-by: Shyam Saini <shyam.saini@amarulasolutions.com>
---
Changelog:

V1->V2
- Consolidate previous patch 1 and 2 into single patch
- For code compatibility reason, retain sizeof_field macro as a
  wrapper macro to FIELD_SIZEOF
 
 arch/arm64/include/asm/processor.h                 | 10 +++++-----
 arch/mips/cavium-octeon/executive/cvmx-bootmem.c   |  9 +--------
 drivers/gpu/drm/i915/gvt/scheduler.c               |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c |  4 ++--
 fs/befs/linuxvfs.c                                 |  2 +-
 fs/ext2/super.c                                    |  2 +-
 fs/ext4/super.c                                    |  2 +-
 fs/freevxfs/vxfs_super.c                           |  2 +-
 fs/orangefs/super.c                                |  2 +-
 fs/ufs/super.c                                     |  2 +-
 include/linux/kernel.h                             |  9 ---------
 include/linux/slab.h                               |  2 +-
 include/linux/stddef.h                             | 17 ++++++++++++++---
 kernel/fork.c                                      |  2 +-
 kernel/utsname.c                                   |  2 +-
 net/caif/caif_socket.c                             |  2 +-
 net/core/skbuff.c                                  |  2 +-
 net/ipv4/raw.c                                     |  2 +-
 net/ipv6/raw.c                                     |  2 +-
 net/sctp/socket.c                                  |  4 ++--
 tools/testing/selftests/bpf/bpf_util.h             | 22 +++++++++++++++++++---
 virt/kvm/kvm_main.c                                |  2 +-
 22 files changed, 58 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index fcd0e691b1ea..ace906d887cc 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -164,13 +164,13 @@ static inline void arch_thread_struct_whitelist(unsigned long *offset,
 						unsigned long *size)
 {
 	/* Verify that there is no padding among the whitelisted fields: */
-	BUILD_BUG_ON(sizeof_field(struct thread_struct, uw) !=
-		     sizeof_field(struct thread_struct, uw.tp_value) +
-		     sizeof_field(struct thread_struct, uw.tp2_value) +
-		     sizeof_field(struct thread_struct, uw.fpsimd_state));
+	BUILD_BUG_ON(FIELD_SIZEOF(struct thread_struct, uw) !=
+		     FIELD_SIZEOF(struct thread_struct, uw.tp_value) +
+		     FIELD_SIZEOF(struct thread_struct, uw.tp2_value) +
+		     FIELD_SIZEOF(struct thread_struct, uw.fpsimd_state));
 
 	*offset = offsetof(struct thread_struct, uw);
-	*size = sizeof_field(struct thread_struct, uw);
+	*size = FIELD_SIZEOF(struct thread_struct, uw);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
index ba8f82a29a81..44b506a14666 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
@@ -45,13 +45,6 @@ static struct cvmx_bootmem_desc *cvmx_bootmem_desc;
 /* See header file for descriptions of functions */
 
 /**
- * This macro returns the size of a member of a structure.
- * Logically it is the same as "sizeof(s::field)" in C++, but
- * C lacks the "::" operator.
- */
-#define SIZEOF_FIELD(s, field) sizeof(((s *)NULL)->field)
-
-/**
  * This macro returns a member of the
  * cvmx_bootmem_named_block_desc_t structure. These members can't
  * be directly addressed as they might be in memory not directly
@@ -65,7 +58,7 @@ static struct cvmx_bootmem_desc *cvmx_bootmem_desc;
 #define CVMX_BOOTMEM_NAMED_GET_FIELD(addr, field)			\
 	__cvmx_bootmem_desc_get(addr,					\
 		offsetof(struct cvmx_bootmem_named_block_desc, field),	\
-		SIZEOF_FIELD(struct cvmx_bootmem_named_block_desc, field))
+		FIELD_SIZEOF(struct cvmx_bootmem_named_block_desc, field))
 
 /**
  * This function is the implementation of the get macros defined
diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 0f919f0a43d4..820f95a52542 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -1243,7 +1243,7 @@ int intel_vgpu_setup_submission(struct intel_vgpu *vgpu)
 						  sizeof(struct intel_vgpu_workload), 0,
 						  SLAB_HWCACHE_ALIGN,
 						  offsetof(struct intel_vgpu_workload, rb_tail),
-						  sizeof_field(struct intel_vgpu_workload, rb_tail),
+						  FIELD_SIZEOF(struct intel_vgpu_workload, rb_tail),
 						  NULL);
 
 	if (!s->workloads) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 46baf3b44309..c0447bf07fbb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -49,13 +49,13 @@ struct mlxsw_sp_fid_8021d {
 };
 
 static const struct rhashtable_params mlxsw_sp_fid_ht_params = {
-	.key_len = sizeof_field(struct mlxsw_sp_fid, fid_index),
+	.key_len = FIELD_SIZEOF(struct mlxsw_sp_fid, fid_index),
 	.key_offset = offsetof(struct mlxsw_sp_fid, fid_index),
 	.head_offset = offsetof(struct mlxsw_sp_fid, ht_node),
 };
 
 static const struct rhashtable_params mlxsw_sp_fid_vni_ht_params = {
-	.key_len = sizeof_field(struct mlxsw_sp_fid, vni),
+	.key_len = FIELD_SIZEOF(struct mlxsw_sp_fid, vni),
 	.key_offset = offsetof(struct mlxsw_sp_fid, vni),
 	.head_offset = offsetof(struct mlxsw_sp_fid, vni_ht_node),
 };
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 462d096ff3e9..06ffd4829e2e 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -438,7 +438,7 @@ befs_init_inodecache(void)
 					SLAB_ACCOUNT),
 				offsetof(struct befs_inode_info,
 					i_data.symlink),
-				sizeof_field(struct befs_inode_info,
+				FIELD_SIZEOF(struct befs_inode_info,
 					i_data.symlink),
 				init_once);
 	if (befs_inode_cachep == NULL)
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1d7ab73b1014..d9a6c81f4a47 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -220,7 +220,7 @@ static int __init init_inodecache(void)
 				(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
 					SLAB_ACCOUNT),
 				offsetof(struct ext2_inode_info, i_data),
-				sizeof_field(struct ext2_inode_info, i_data),
+				FIELD_SIZEOF(struct ext2_inode_info, i_data),
 				init_once);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4079605d437a..b1b5856248bd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1148,7 +1148,7 @@ static int __init init_inodecache(void)
 				(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
 					SLAB_ACCOUNT),
 				offsetof(struct ext4_inode_info, i_data),
-				sizeof_field(struct ext4_inode_info, i_data),
+				FIELD_SIZEOF(struct ext4_inode_info, i_data),
 				init_once);
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index a89f68c3cbed..ffd22f85bbe0 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -329,7 +329,7 @@ vxfs_init(void)
 			sizeof(struct vxfs_inode_info), 0,
 			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
 			offsetof(struct vxfs_inode_info, vii_immed.vi_immed),
-			sizeof_field(struct vxfs_inode_info,
+			FIELD_SIZEOF(struct vxfs_inode_info,
 				vii_immed.vi_immed),
 			NULL);
 	if (!vxfs_inode_cachep)
diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index ee5efdc35cc1..30f625059ad9 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -646,7 +646,7 @@ int orangefs_inode_cache_initialize(void)
 					ORANGEFS_CACHE_CREATE_FLAGS,
 					offsetof(struct orangefs_inode_s,
 						link_target),
-					sizeof_field(struct orangefs_inode_s,
+					FIELD_SIZEOF(struct orangefs_inode_s,
 						link_target),
 					orangefs_inode_cache_ctor);
 
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3d247c0d92aa..1e8bcd950f6d 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1469,7 +1469,7 @@ static int __init init_inodecache(void)
 				(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
 					SLAB_ACCOUNT),
 				offsetof(struct ufs_inode_info, i_u1.i_symlink),
-				sizeof_field(struct ufs_inode_info,
+				FIELD_SIZEOF(struct ufs_inode_info,
 					i_u1.i_symlink),
 				init_once);
 	if (ufs_inode_cachep == NULL)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 74b1ee9027f5..4672391cdb5b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -79,15 +79,6 @@
  */
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
-/**
- * FIELD_SIZEOF - get the size of a struct's field
- * @t: the target struct
- * @f: the target struct's field
- * Return: the size of @f in the struct definition without having a
- * declared instance of @t.
- */
-#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-
 #define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
 
 #define DIV_ROUND_DOWN_ULL(ll, d) \
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 9449b19c5f10..8bdfdd389b37 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -175,7 +175,7 @@ void memcg_destroy_kmem_caches(struct mem_cgroup *);
 			sizeof(struct __struct),			\
 			__alignof__(struct __struct), (__flags),	\
 			offsetof(struct __struct, __field),		\
-			sizeof_field(struct __struct, __field), NULL)
+			FIELD_SIZEOF(struct __struct, __field), NULL)
 
 /*
  * Common kmalloc functions provided by all allocators
diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 998a4ba28eba..a5960e2b4a8b 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -20,12 +20,23 @@ enum {
 #endif
 
 /**
- * sizeof_field(TYPE, MEMBER)
+ * FIELD_SIZEOF - get the size of a struct's field
+ * @t: the target struct
+ * @f: the target struct's field
+ * Return: the size of @f in the struct definition without having a
+ * declared instance of @t.
+ */
+#define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
+
+/*
+ * For code compatibility
  *
+ * sizeof_field(TYPE, MEMBER)
  * @TYPE: The structure containing the field of interest
  * @MEMBER: The field to return the size of
  */
-#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+
+#define sizeof_field(TYPE, MEMBER) FIELD_SIZEOF(TYPE, MEMBER)
 
 /**
  * offsetofend(TYPE, MEMBER)
@@ -34,6 +45,6 @@ enum {
  * @MEMBER: The member within the structure to get the end offset of
  */
 #define offsetofend(TYPE, MEMBER) \
-	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
+	(offsetof(TYPE, MEMBER)	+ FIELD_SIZEOF(TYPE, MEMBER))
 
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 75675b9bf6df..ef40b95bf82c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2553,7 +2553,7 @@ void __init proc_caches_init(void)
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			offsetof(struct mm_struct, saved_auxv),
-			sizeof_field(struct mm_struct, saved_auxv),
+			FIELD_SIZEOF(struct mm_struct, saved_auxv),
 			NULL);
 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);
 	mmap_init();
diff --git a/kernel/utsname.c b/kernel/utsname.c
index f0e491193009..28257c571553 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -174,6 +174,6 @@ void __init uts_ns_init(void)
 			"uts_namespace", sizeof(struct uts_namespace), 0,
 			SLAB_PANIC|SLAB_ACCOUNT,
 			offsetof(struct uts_namespace, name),
-			sizeof_field(struct uts_namespace, name),
+			FIELD_SIZEOF(struct uts_namespace, name),
 			NULL);
 }
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 13ea920600ae..3306bbed77eb 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1033,7 +1033,7 @@ static int caif_create(struct net *net, struct socket *sock, int protocol,
 		.owner = THIS_MODULE,
 		.obj_size = sizeof(struct caifsock),
 		.useroffset = offsetof(struct caifsock, conn_req.param),
-		.usersize = sizeof_field(struct caifsock, conn_req.param)
+		.usersize = FIELD_SIZEOF(struct caifsock, conn_req.param)
 	};
 
 	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_NET_ADMIN))
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 47c1aa9ee045..816bea0c4a8e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3983,7 +3983,7 @@ void __init skb_init(void)
 					      0,
 					      SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 					      offsetof(struct sk_buff, cb),
-					      sizeof_field(struct sk_buff, cb),
+					      FIELD_SIZEOF(struct sk_buff, cb),
 					      NULL);
 	skbuff_fclone_cache = kmem_cache_create("skbuff_fclone_cache",
 						sizeof(struct sk_buff_fclones),
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 0b8e06ca75d6..efa4c745f7b9 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -977,7 +977,7 @@ struct proto raw_prot = {
 	.unhash		   = raw_unhash_sk,
 	.obj_size	   = sizeof(struct raw_sock),
 	.useroffset	   = offsetof(struct raw_sock, filter),
-	.usersize	   = sizeof_field(struct raw_sock, filter),
+	.usersize	   = FIELD_SIZEOF(struct raw_sock, filter),
 	.h.raw_hash	   = &raw_v4_hashinfo,
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_raw_setsockopt,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 70693bc7ad9d..257c71e22d74 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1292,7 +1292,7 @@ struct proto rawv6_prot = {
 	.unhash		   = raw_unhash_sk,
 	.obj_size	   = sizeof(struct raw6_sock),
 	.useroffset	   = offsetof(struct raw6_sock, filter),
-	.usersize	   = sizeof_field(struct raw6_sock, filter),
+	.usersize	   = FIELD_SIZEOF(struct raw6_sock, filter),
 	.h.raw_hash	   = &raw_v6_hashinfo,
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_rawv6_setsockopt,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 39ea0a37af09..6b648a6033b9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9377,7 +9377,7 @@ struct proto sctp_prot = {
 	.useroffset  =  offsetof(struct sctp_sock, subscribe),
 	.usersize    =  offsetof(struct sctp_sock, initmsg) -
 				offsetof(struct sctp_sock, subscribe) +
-				sizeof_field(struct sctp_sock, initmsg),
+				FIELD_SIZEOF(struct sctp_sock, initmsg),
 	.sysctl_mem  =  sysctl_sctp_mem,
 	.sysctl_rmem =  sysctl_sctp_rmem,
 	.sysctl_wmem =  sysctl_sctp_wmem,
@@ -9419,7 +9419,7 @@ struct proto sctpv6_prot = {
 	.useroffset	= offsetof(struct sctp6_sock, sctp.subscribe),
 	.usersize	= offsetof(struct sctp6_sock, sctp.initmsg) -
 				offsetof(struct sctp6_sock, sctp.subscribe) +
-				sizeof_field(struct sctp6_sock, sctp.initmsg),
+				FIELD_SIZEOF(struct sctp6_sock, sctp.initmsg),
 	.sysctl_mem	= sysctl_sctp_mem,
 	.sysctl_rmem	= sysctl_sctp_rmem,
 	.sysctl_wmem	= sysctl_sctp_wmem,
diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
index a29206ebbd13..571c35aac90f 100644
--- a/tools/testing/selftests/bpf/bpf_util.h
+++ b/tools/testing/selftests/bpf/bpf_util.h
@@ -58,13 +58,29 @@ static inline unsigned int bpf_num_possible_cpus(void)
 # define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #endif
 
-#ifndef sizeof_field
-#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+/*
+ * FIELD_SIZEOF - get the size of a struct's field
+ * @t: the target struct
+ * @f: the target struct's field
+ * Return: the size of @f in the struct definition without having a
+ * declared instance of @t.
+ */
+#ifndef FIELD_SIZEOF
+#define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
 #endif
 
+/*
+ * For code compatibility
+ *
+ * sizeof_field(TYPE, MEMBER)
+ * @TYPE: The structure containing the field of interest
+ * @MEMBER: The field to return the size of
+ */
+#define sizeof_field(TYPE, MEMBER) FIELD_SIZEOF(TYPE, MEMBER)
+
 #ifndef offsetofend
 #define offsetofend(TYPE, MEMBER) \
-	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
+	(offsetof(TYPE, MEMBER)	+ FIELD_SIZEOF(TYPE, MEMBER))
 #endif
 
 #endif /* __BPF_UTIL__ */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ca54b09adf5b..e43e3a26f6ab 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4275,7 +4275,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		kmem_cache_create_usercopy("kvm_vcpu", vcpu_size, vcpu_align,
 					   SLAB_ACCOUNT,
 					   offsetof(struct kvm_vcpu, arch),
-					   sizeof_field(struct kvm_vcpu, arch),
+					   FIELD_SIZEOF(struct kvm_vcpu, arch),
 					   NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
-- 
2.11.0

