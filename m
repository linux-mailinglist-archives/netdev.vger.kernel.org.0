Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6950147BA44
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhLUGvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:51:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:29910 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234763AbhLUGvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:51:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069468; x=1671605468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x+hVxeZMLnGg0tKEA5G1h/cQZHse87HAMdrWV1S3voM=;
  b=Oat1MnUNSK6xaYhOfUjSTfrIHQ/n1j9IeSGVFjbmImAESIh3QtzwY4Az
   aA/P/mkCsYE3d/CG3NfNHsnvdeBGCQvngd6JFtMX6yaXCPER/RNx1Hq8f
   ywaKUdwvFFImA3/vgFpP+k5pWhf/CAtdVf6XTCterV97FjjjGBzb+4Nt8
   YxF9T6Y91NejEdkrlZJfCY4NQFS1xgFd14eZy2qfNICMKGWjXCaLegRNz
   /2T467V3BZV7Ub08e5utGTMVElfjBtyIv7VfME6HEh9ksdW2gnDuy9ZZK
   NUjsxUqECxgGPE0hbLB9sW6s5EjUhdopxkyi+qgT8Jwjy4GYbPUHXTG9A
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107522"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107522"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119097"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:37 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 13/17] dlb: add port mmap support
Date:   Tue, 21 Dec 2021 00:50:43 -0600
Message-Id: <20211221065047.290182-14-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once a port is created, the application can mmap the corresponding DMA
memory and MMIO into user-space. This allows user-space applications to
do (performance-sensitive) enqueue and dequeue independent of the kernel
driver.

The mmap callback is only available through special port files: a producer
port (PP) file and a consumer queue (CQ) file. User-space gets an fd for
these files by calling a new ioctl, DLB_DOMAIN_CMD_GET_{LDB,
DIR}_PORT_{PP, CQ}_FD, and passing in a port ID. If the ioctl succeeds, the
returned fd can be used to mmap that port's PP/CQ.

Device reset requires first unmapping all user-space mappings, to prevent
applications from interfering with the reset operation. To this end, the
driver uses a single inode -- allocated when the first PP/CQ file is
created, and freed when the last such file is closed -- and attaches all
port files to this common inode, as done elsewhere in Linux (e.g. cxl,
dax).

Allocating this inode requires creating a pseudo-filesystem. The driver
initializes this FS when the inode is allocated, and frees the FS after the
inode is freed.

The driver doesn't use anon_inode_getfd() for these port mmap files because
the anon inode layer uses a single inode that is shared with other kernel
components -- calling unmap_mapping_range() on that shared inode would
likely break the kernel.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/Makefile       |   1 +
 drivers/misc/dlb/dlb_args.h     |  31 ++++++
 drivers/misc/dlb/dlb_configfs.c | 162 ++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_configfs.h |  70 ++++++++++++++
 drivers/misc/dlb/dlb_file.c     | 149 +++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_main.c     | 120 +++++++++++++++++++++++
 drivers/misc/dlb/dlb_main.h     |  24 +++++
 drivers/misc/dlb/dlb_resource.c | 109 +++++++++++++++++++++
 8 files changed, 666 insertions(+)
 create mode 100644 drivers/misc/dlb/dlb_file.c

diff --git a/drivers/misc/dlb/Makefile b/drivers/misc/dlb/Makefile
index 1567bfdfc7a7..c7a8a3235a4a 100644
--- a/drivers/misc/dlb/Makefile
+++ b/drivers/misc/dlb/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_INTEL_DLB) := dlb.o
 
 dlb-objs := dlb_main.o
 dlb-objs += dlb_pf_ops.o dlb_resource.o dlb_configfs.o
+dlb-objs += dlb_file.o
diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
index b54483bfa767..b16670e62370 100644
--- a/drivers/misc/dlb/dlb_args.h
+++ b/drivers/misc/dlb/dlb_args.h
@@ -189,6 +189,8 @@ struct dlb_get_dir_queue_depth_args {
 struct dlb_create_ldb_port_args {
 	/* Output parameters */
 	struct dlb_cmd_response response;
+	__u32 pp_fd;
+	__u32 cq_fd;
 	/* Input parameters */
 	__u16 cq_depth;
 	__u16 cq_depth_threshold;
@@ -216,12 +218,41 @@ struct dlb_create_ldb_port_args {
 struct dlb_create_dir_port_args {
 	/* Output parameters */
 	struct dlb_cmd_response response;
+	__u32 pp_fd;
+	__u32 cq_fd;
 	/* Input parameters */
 	__u16 cq_depth;
 	__u16 cq_depth_threshold;
 	__s32 queue_id;
 };
 
+/*
+ * dlb_get_port_fd_args: Used to get file descriptor to mmap a producer port
+ *	(PP) or a consumer queue (CQ)
+ *
+ *	The port must have been previously created in the device's configfs.
+ *	The fd is used to mmap the PP/CQ region.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: fd.
+ *
+ * Input parameters:
+ * @port_id: port ID.
+ */
+struct dlb_get_port_fd_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 port_id;
+};
+
+/*
+ * Mapping sizes for memory mapping the consumer queue (CQ) memory space, and
+ * producer port (PP) MMIO space.
+ */
 #define DLB_CQ_SIZE 65536
+#define DLB_PP_SIZE 4096
 
 #endif /* __DLB_ARGS_H */
diff --git a/drivers/misc/dlb/dlb_configfs.c b/drivers/misc/dlb/dlb_configfs.c
index 045d1dae2b7f..1401ad1a04de 100644
--- a/drivers/misc/dlb/dlb_configfs.c
+++ b/drivers/misc/dlb/dlb_configfs.c
@@ -45,6 +45,90 @@ DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(create_dir_queue)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_ldb_queue_depth)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_dir_queue_depth)
 
+static int dlb_create_port_fd(struct dlb *dlb,
+			      const char *prefix,
+			      u32 id,
+			      const struct file_operations *fops,
+			      int *fd,
+			      struct file **f)
+{
+	char *name;
+	int ret;
+
+	ret = get_unused_fd_flags(O_RDWR);
+	if (ret < 0)
+		return ret;
+
+	*fd = ret;
+
+	name = kasprintf(GFP_KERNEL, "%s:%d", prefix, id);
+	if (!name) {
+		put_unused_fd(*fd);
+		return -ENOMEM;
+	}
+
+	*f = dlb_getfile(dlb, O_RDWR | O_CLOEXEC, fops, name);
+
+	kfree(name);
+
+	if (IS_ERR(*f)) {
+		put_unused_fd(*fd);
+		return PTR_ERR(*f);
+	}
+
+	return 0;
+}
+
+static int dlb_domain_get_port_fd(struct dlb *dlb,
+				  struct dlb_domain *domain,
+				  u32 port_id,
+				  int *fd,
+				  const char *name,
+				  const struct file_operations *fops,
+				  bool is_ldb)
+{
+	struct dlb_port *port;
+	struct file *file;
+	int ret;
+
+	if (is_ldb && dlb_ldb_port_owned_by_domain(&dlb->hw, domain->id,
+						   port_id) != 1) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	if (!is_ldb && dlb_dir_port_owned_by_domain(&dlb->hw, domain->id,
+						    port_id) != 1) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	port = (is_ldb) ? &dlb->ldb_port[port_id] : &dlb->dir_port[port_id];
+
+	if (!port->valid) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	ret = dlb_create_port_fd(dlb, name, port_id, fops, fd, &file);
+	if (ret < 0)
+		goto end;
+
+	file->private_data = port;
+end:
+	/*
+	 * Save fd_install() until after the last point of failure. The domain
+	 * refcnt is decremented in the close callback.
+	 */
+	if (ret == 0) {
+		kref_get(&domain->refcnt);
+
+		fd_install(*fd, file);
+	}
+
+	return ret;
+}
+
 static int dlb_domain_configfs_create_ldb_port(struct dlb *dlb,
 					       struct dlb_domain *domain,
 					       void *karg)
@@ -132,6 +216,7 @@ static int dlb_domain_configfs_create_dir_port(struct dlb *dlb,
 	dlb->dir_port[response.id].cq_base = cq_base;
 	dlb->dir_port[response.id].cq_dma_base = cq_dma_base;
 	dlb->dir_port[response.id].valid = true;
+
 unlock:
 	if (ret && cq_dma_base)
 		dma_free_coherent(&dlb->pdev->dev,
@@ -200,6 +285,28 @@ static int dlb_configfs_create_sched_domain(struct dlb *dlb,
 	return ret;
 }
 
+/*
+ * Reset the file descriptors for the producer port and consumer queue. Used
+ * a port is closed.
+ *
+ */
+int dlb_configfs_reset_port_fd(struct dlb *dlb,
+			       struct dlb_domain *dlb_domain,
+			       int port_id)
+{
+	struct dlb_cfs_port *dlb_cfs_port;
+
+	dlb_cfs_port = dlb_configfs_get_port_from_id(dlb, dlb_domain, port_id);
+
+	if (!dlb_cfs_port)
+		return -EINVAL;
+
+	dlb_cfs_port->pp_fd = 0xffffffff;
+	dlb_cfs_port->cq_fd = 0xffffffff;
+
+	return 0;
+}
+
 /*
  * Configfs directory structure for dlb driver implementation:
  *
@@ -457,6 +564,52 @@ static ssize_t dlb_cfs_port_##name##_show(				\
 	return sprintf(page, "%llx\n", to_dlb_cfs_port(item)->name);	\
 }									\
 
+#define DLB_CONFIGFS_PORT_SHOW_FD(name)					\
+static ssize_t dlb_cfs_port_##name##_show(				\
+	struct config_item *item,					\
+	char *page)							\
+{									\
+	struct dlb_cfs_port *dlb_cfs_port = to_dlb_cfs_port(item);	\
+	char filename[16], prefix[16];					\
+	struct dlb_domain *domain;					\
+	struct dlb *dlb = NULL;						\
+	int port_id, is_ldb;						\
+	int fd, ret;							\
+									\
+	if (to_dlb_cfs_port(item)->name != 0xffffffff)			\
+		goto end;						\
+									\
+	ret = dlb_configfs_get_dlb_domain(dlb_cfs_port->domain_grp,	\
+					    &dlb, &domain);		\
+	if (ret)							\
+		return ret;						\
+									\
+	port_id = dlb_cfs_port->port_id;				\
+	is_ldb = dlb_cfs_port->is_ldb;					\
+									\
+	if (is_ldb)							\
+		sprintf(filename, "dlb_ldb");				\
+	else								\
+		sprintf(filename, "dlb_dir");				\
+									\
+	if (!strcmp(#name, "pp_fd")) {					\
+		sprintf(prefix, "%s_pp:", filename);			\
+		ret = dlb_domain_get_port_fd(dlb, domain, port_id,	\
+				&fd, prefix, &dlb_pp_fops, is_ldb);	\
+		dlb_cfs_port->pp_fd = fd;				\
+	} else {							\
+		sprintf(prefix, "%s_cq:", filename);			\
+		ret = dlb_domain_get_port_fd(dlb, domain, port_id,	\
+				&fd, prefix, &dlb_cq_fops, is_ldb);	\
+		dlb_cfs_port->cq_fd = fd;				\
+	}								\
+									\
+	if (ret)							\
+		return ret;						\
+end:									\
+	return sprintf(page, "%u\n", to_dlb_cfs_port(item)->name);	\
+}									\
+
 #define DLB_CONFIGFS_PORT_STORE(name)					\
 static ssize_t dlb_cfs_port_##name##_store(				\
 	struct config_item *item,					\
@@ -489,6 +642,8 @@ static ssize_t dlb_cfs_port_##name##_store(				\
 	return count;							\
 }									\
 
+DLB_CONFIGFS_PORT_SHOW_FD(pp_fd)
+DLB_CONFIGFS_PORT_SHOW_FD(cq_fd)
 DLB_CONFIGFS_PORT_SHOW(status)
 DLB_CONFIGFS_PORT_SHOW(port_id)
 DLB_CONFIGFS_PORT_SHOW(is_ldb)
@@ -556,6 +711,9 @@ static ssize_t dlb_cfs_port_create_store(struct config_item *item,
 		dlb_cfs_port->port_id = args.response.id;
 	}
 
+	dlb_cfs_port->pp_fd = 0xffffffff;
+	dlb_cfs_port->cq_fd = 0xffffffff;
+
 	if (ret) {
 		dev_err(dlb->dev,
 			"creat port %s failed: ret=%d\n",
@@ -566,6 +724,8 @@ static ssize_t dlb_cfs_port_create_store(struct config_item *item,
 	return count;
 }
 
+CONFIGFS_ATTR_RO(dlb_cfs_port_, pp_fd);
+CONFIGFS_ATTR_RO(dlb_cfs_port_, cq_fd);
 CONFIGFS_ATTR_RO(dlb_cfs_port_, status);
 CONFIGFS_ATTR_RO(dlb_cfs_port_, port_id);
 CONFIGFS_ATTR(dlb_cfs_port_, is_ldb);
@@ -576,6 +736,8 @@ CONFIGFS_ATTR(dlb_cfs_port_, create);
 CONFIGFS_ATTR(dlb_cfs_port_, queue_id);
 
 static struct configfs_attribute *dlb_cfs_port_attrs[] = {
+	&dlb_cfs_port_attr_pp_fd,
+	&dlb_cfs_port_attr_cq_fd,
 	&dlb_cfs_port_attr_status,
 	&dlb_cfs_port_attr_port_id,
 	&dlb_cfs_port_attr_is_ldb,
diff --git a/drivers/misc/dlb/dlb_configfs.h b/drivers/misc/dlb/dlb_configfs.h
index 06f4f93d4139..23874abfa42e 100644
--- a/drivers/misc/dlb/dlb_configfs.h
+++ b/drivers/misc/dlb/dlb_configfs.h
@@ -11,6 +11,8 @@ struct dlb_device_configfs {
 	struct dlb *dlb;
 };
 
+extern struct dlb_device_configfs dlb_dev_configfs[16];
+
 struct dlb_cfs_domain {
 	struct config_group group;
 	struct config_group *dev_grp;
@@ -56,6 +58,8 @@ struct dlb_cfs_port {
 	struct config_group *domain_grp;
 	unsigned int status;
 	unsigned int port_id;
+	unsigned int pp_fd;
+	unsigned int cq_fd;
 	/* Input parameters */
 	unsigned int is_ldb;
 	unsigned int cq_depth;
@@ -118,4 +122,70 @@ int dlb_configfs_get_dlb_domain(struct config_group *domain_grp,
 
 	return 0;
 }
+
+static inline struct config_item *to_item(struct list_head *entry)
+{
+	return container_of(entry, struct config_item, ci_entry);
+}
+
+/*
+ * Find configfs group for a port from a port_id.
+ *
+ */
+static inline
+struct dlb_cfs_port *dlb_configfs_get_port_from_id(struct dlb *dlb,
+					struct dlb_domain *dlb_domain,
+					int port_id)
+{
+	struct dlb_cfs_domain *dlb_cfs_domain = NULL;
+	struct dlb_cfs_port *dlb_cfs_port = NULL;
+	struct config_group *dev_grp;
+	struct list_head *entry;
+	int grp_found = 0;
+
+	dev_grp = &dlb_dev_configfs[dlb->id].dev_group;
+
+	list_for_each(entry, &dev_grp->cg_children) {
+		struct config_item *item = to_item(entry);
+
+		if (config_item_name(item))
+			dev_dbg(dlb->dev,
+				"%s: item = %s\n", __func__,
+				config_item_name(item));
+
+		dlb_cfs_domain = to_dlb_cfs_domain(item);
+
+		if (dlb_cfs_domain->domain_id == dlb_domain->id) {
+			grp_found = 1;
+			break;
+		}
+	}
+
+	if (!grp_found)
+		return NULL;
+
+	grp_found = 0;
+
+	list_for_each(entry, &dlb_cfs_domain->group.cg_children) {
+		struct config_item *item = to_item(entry);
+
+		if (strnstr(config_item_name(item), "port", 5)) {
+			dev_dbg(dlb->dev,
+				"%s: item = %s\n", __func__,
+				config_item_name(item));
+
+			dlb_cfs_port = to_dlb_cfs_port(item);
+
+			if (dlb_cfs_port->port_id == port_id) {
+				grp_found = 1;
+				break;
+			}
+		}
+	}
+
+	if (!grp_found)
+		return NULL;
+
+	return dlb_cfs_port;
+}
 #endif /* DLB_CONFIGFS_H */
diff --git a/drivers/misc/dlb/dlb_file.c b/drivers/misc/dlb/dlb_file.c
new file mode 100644
index 000000000000..310b86735353
--- /dev/null
+++ b/drivers/misc/dlb/dlb_file.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/pseudo_fs.h>
+
+#include "dlb_main.h"
+
+/*
+ * dlb tracks its memory mappings so it can revoke them when an FLR is
+ * requested and user-space cannot be allowed to access the device. To achieve
+ * that, the driver creates a single inode through which all driver-created
+ * files can share a struct address_space, and unmaps the inode's address space
+ * during the reset preparation phase. Since the anon inode layer shares its
+ * inode with multiple kernel components, we cannot use that here.
+ *
+ * Doing so requires a custom pseudo-filesystem to allocate the inode. The FS
+ * and the inode are allocated on demand when a file is created, and both are
+ * freed when the last such file is closed.
+ *
+ * This is inspired by other drivers (cxl, dax, mem) and the anon inode layer.
+ */
+static int dlb_fs_cnt;
+static struct vfsmount *dlb_vfs_mount;
+
+#define DLBFS_MAGIC 0x444C4232 /* ASCII for DLB */
+static int dlb_init_fs_context(struct fs_context *fc)
+{
+	return init_pseudo(fc, DLBFS_MAGIC) ? 0 : -ENOMEM;
+}
+
+static struct file_system_type dlb_fs_type = {
+	.name	 = "dlb",
+	.owner	 = THIS_MODULE,
+	.init_fs_context = dlb_init_fs_context,
+	.kill_sb = kill_anon_super,
+};
+
+/* Allocate an anonymous inode. Must hold the resource mutex while calling. */
+static struct inode *dlb_alloc_inode(struct dlb *dlb)
+{
+	struct inode *inode;
+	int ret;
+
+	/* Increment the pseudo-FS's refcnt and (if not already) mount it. */
+	ret = simple_pin_fs(&dlb_fs_type, &dlb_vfs_mount, &dlb_fs_cnt);
+	if (ret < 0) {
+		dev_err(dlb->dev,
+			"[%s()] Cannot mount pseudo filesystem: %d\n",
+			__func__, ret);
+		return ERR_PTR(ret);
+	}
+
+	dlb->inode_cnt++;
+
+	if (dlb->inode_cnt > 1) {
+		/*
+		 * Return the previously allocated inode. In this case, there
+		 * is guaranteed >= 1 reference and so ihold() is safe to call.
+		 */
+		ihold(dlb->inode);
+		return dlb->inode;
+	}
+
+	inode = alloc_anon_inode(dlb_vfs_mount->mnt_sb);
+	if (IS_ERR(inode)) {
+		dev_err(dlb->dev,
+			"[%s()] Cannot allocate inode: %ld\n",
+			__func__, PTR_ERR(inode));
+		dlb->inode_cnt = 0;
+		simple_release_fs(&dlb_vfs_mount, &dlb_fs_cnt);
+	}
+
+	dlb->inode = inode;
+
+	return inode;
+}
+
+/*
+ * Decrement the inode reference count and release the FS. Intended for
+ * unwinding dlb_alloc_inode(). Must hold the resource mutex while calling.
+ */
+static void dlb_free_inode(struct inode *inode)
+{
+	iput(inode);
+	simple_release_fs(&dlb_vfs_mount, &dlb_fs_cnt);
+}
+
+/*
+ * Release the FS. Intended for use in a file_operations release callback,
+ * which decrements the inode reference count separately. Must hold the
+ * resource mutex while calling.
+ */
+void dlb_release_fs(struct dlb *dlb)
+{
+	mutex_lock(&dlb_driver_mutex);
+
+	simple_release_fs(&dlb_vfs_mount, &dlb_fs_cnt);
+
+	dlb->inode_cnt--;
+
+	/* When the fs refcnt reaches zero, the inode has been freed */
+	if (dlb->inode_cnt == 0)
+		dlb->inode = NULL;
+
+	mutex_unlock(&dlb_driver_mutex);
+}
+
+/*
+ * Allocate a file with the requested flags, file operations, and name that
+ * uses the device's shared inode. Must hold the resource mutex while calling.
+ *
+ * Caller must separately allocate an fd and install the file in that fd.
+ */
+struct file *dlb_getfile(struct dlb *dlb,
+			 int flags,
+			 const struct file_operations *fops,
+			 const char *name)
+{
+	struct inode *inode;
+	struct file *f;
+
+	if (!try_module_get(THIS_MODULE))
+		return ERR_PTR(-ENOENT);
+
+	mutex_lock(&dlb_driver_mutex);
+
+	inode = dlb_alloc_inode(dlb);
+	if (IS_ERR(inode)) {
+		mutex_unlock(&dlb_driver_mutex);
+		module_put(THIS_MODULE);
+		return ERR_CAST(inode);
+	}
+
+	f = alloc_file_pseudo(inode, dlb_vfs_mount, name, flags, fops);
+	if (IS_ERR(f)) {
+		dlb_free_inode(inode);
+		mutex_unlock(&dlb_driver_mutex);
+		module_put(THIS_MODULE);
+		return f;
+	}
+
+	mutex_unlock(&dlb_driver_mutex);
+
+	return f;
+}
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 9e6168b27859..ce3cbe15e198 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -16,6 +16,9 @@
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel(R) Dynamic Load Balancer (DLB) Driver");
 
+/* The driver mutex protects data structures that used by multiple devices. */
+DEFINE_MUTEX(dlb_driver_mutex);
+
 static struct class *dlb_class;
 static struct cdev dlb_cdev;
 static dev_t dlb_devt;
@@ -226,6 +229,123 @@ const struct file_operations dlb_domain_fops = {
 	.release = dlb_domain_close,
 };
 
+static unsigned long dlb_get_pp_addr(struct dlb *dlb, struct dlb_port *port)
+{
+	unsigned long pgoff = dlb->hw.func_phys_addr;
+
+	if (port->is_ldb)
+		pgoff += DLB_LDB_PP_OFFSET(port->id);
+	else
+		pgoff += DLB_DIR_PP_OFFSET(port->id);
+
+	return pgoff;
+}
+
+static int dlb_pp_mmap(struct file *f, struct vm_area_struct *vma)
+{
+	struct dlb_port *port = f->private_data;
+	struct dlb_domain *domain = port->domain;
+	struct dlb *dlb = domain->dlb;
+	unsigned long pgoff;
+	pgprot_t pgprot;
+	int ret;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	if ((vma->vm_end - vma->vm_start) != DLB_PP_SIZE) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	pgprot = pgprot_noncached(vma->vm_page_prot);
+
+	pgoff = dlb_get_pp_addr(dlb, port);
+	ret = io_remap_pfn_range(vma,
+				 vma->vm_start,
+				 pgoff >> PAGE_SHIFT,
+				 vma->vm_end - vma->vm_start,
+				 pgprot);
+
+end:
+	mutex_unlock(&dlb->resource_mutex);
+
+	return ret;
+}
+
+static int dlb_cq_mmap(struct file *f, struct vm_area_struct *vma)
+{
+	struct dlb_port *port = f->private_data;
+	struct dlb_domain *domain = port->domain;
+	struct dlb *dlb = domain->dlb;
+	struct page *page;
+	int ret;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	if ((vma->vm_end - vma->vm_start) != DLB_CQ_SIZE) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	page = virt_to_page(port->cq_base);
+
+	ret = remap_pfn_range(vma,
+			      vma->vm_start,
+			      page_to_pfn(page),
+			      vma->vm_end - vma->vm_start,
+			      vma->vm_page_prot);
+end:
+	mutex_unlock(&dlb->resource_mutex);
+
+	return ret;
+}
+
+static void dlb_port_unmap(struct dlb *dlb, struct dlb_port *port)
+{
+	if (!port->cq_base) {
+		unmap_mapping_range(dlb->inode->i_mapping,
+				    (unsigned long)port->cq_base,
+				    DLB_CQ_SIZE, 1);
+	} else {
+		unmap_mapping_range(dlb->inode->i_mapping,
+				    dlb_get_pp_addr(dlb, port),
+				    DLB_PP_SIZE, 1);
+	}
+}
+
+static int dlb_port_close(struct inode *i, struct file *f)
+{
+	struct dlb_port *port = f->private_data;
+	struct dlb_domain *domain = port->domain;
+	struct dlb *dlb = domain->dlb;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	kref_put(&domain->refcnt, dlb_free_domain);
+
+	dlb_port_unmap(dlb, port);
+	dlb_configfs_reset_port_fd(dlb, domain, port->id);
+
+	/* Decrement the refcnt of the pseudo-FS used to allocate the inode */
+	dlb_release_fs(dlb);
+
+	mutex_unlock(&dlb->resource_mutex);
+
+	return 0;
+}
+
+const struct file_operations dlb_pp_fops = {
+	.owner   = THIS_MODULE,
+	.release = dlb_port_close,
+	.mmap    = dlb_pp_mmap,
+};
+
+const struct file_operations dlb_cq_fops = {
+	.owner   = THIS_MODULE,
+	.release = dlb_port_close,
+	.mmap    = dlb_cq_mmap,
+};
+
 /**********************************/
 /****** PCI driver callbacks ******/
 /**********************************/
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index fbfbc6e3fc87..b361cf55cd8a 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/bitfield.h>
+#include <linux/file.h>
 
 #include <uapi/linux/dlb.h>
 #include "dlb_args.h"
@@ -318,6 +319,8 @@ struct dlb_hw {
 #define DLB_NUM_FUNCS_PER_DEVICE (1 + DLB_MAX_NUM_VDEVS)
 #define DLB_MAX_NUM_DEVICES	 (DLB_MAX_NUM_PFS * DLB_NUM_FUNCS_PER_DEVICE)
 
+extern struct mutex dlb_driver_mutex;
+
 enum dlb_device_type {
 	DLB_PF,
 };
@@ -332,6 +335,8 @@ int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev);
 void dlb_pf_init_hardware(struct dlb *dlb);
 
 extern const struct file_operations dlb_domain_fops;
+extern const struct file_operations dlb_pp_fops;
+extern const struct file_operations dlb_cq_fops;
 
 struct dlb_port {
 	void *cq_base;
@@ -356,6 +361,11 @@ struct dlb {
 	struct file *f;
 	struct dlb_port ldb_port[DLB_MAX_NUM_LDB_PORTS];
 	struct dlb_port dir_port[DLB_MAX_NUM_DIR_PORTS];
+	/*
+	 * Anonymous inode used to share an address_space for all domain
+	 * device file mappings.
+	 */
+	struct inode *inode;
 	/*
 	 * The resource mutex serializes access to driver data structures and
 	 * hardware registers.
@@ -363,6 +373,7 @@ struct dlb {
 	struct mutex resource_mutex;
 	enum dlb_device_type type;
 	int id;
+	u32 inode_cnt;
 	dev_t dev_number;
 	u8 domain_reset_failed;
 };
@@ -576,6 +587,13 @@ static inline struct device *hw_to_dev(struct dlb_hw *hw)
 	return dlb->dev;
 }
 
+/* Prototypes for dlb_file.c */
+void dlb_release_fs(struct dlb *dlb);
+struct file *dlb_getfile(struct dlb *dlb,
+			 int flags,
+			 const struct file_operations *fops,
+			 const char *name);
+
 /* Prototypes for dlb_resource.c */
 int dlb_resource_init(struct dlb_hw *hw);
 void dlb_resource_free(struct dlb_hw *hw);
@@ -597,6 +615,8 @@ int dlb_hw_create_ldb_port(struct dlb_hw *hw, u32 domain_id,
 			   uintptr_t cq_dma_base,
 			   struct dlb_cmd_response *resp);
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id);
+int dlb_ldb_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id);
+int dlb_dir_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id);
 void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
 int dlb_hw_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
 			       struct dlb_get_ldb_queue_depth_args *args,
@@ -611,5 +631,9 @@ void dlb_hw_enable_sparse_dir_cq_mode(struct dlb_hw *hw);
 int dlb_configfs_create_device(struct dlb *dlb);
 int configfs_dlb_init(void);
 void configfs_dlb_exit(void);
+int dlb_configfs_reset_port_fd(struct dlb *dlb,
+			       struct dlb_domain *dlb_domain,
+			       int port_id);
+
 
 #endif /* __DLB_MAIN_H */
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index d1e1d1efe8c7..b5d75cb9be7a 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -210,6 +210,30 @@ static struct dlb_hw_domain *dlb_get_domain_from_id(struct dlb_hw *hw, u32 id)
 	return &hw->domains[id];
 }
 
+static struct dlb_ldb_port *
+dlb_get_domain_ldb_port(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	if (id >= DLB_MAX_NUM_LDB_PORTS)
+		return NULL;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			if (!vdev_req && port->id == id)
+				return port;
+		}
+
+		list_for_each_entry(port, &domain->avail_ldb_ports[i], domain_list) {
+			if (!vdev_req && port->id == id)
+				return port;
+		}
+	}
+
+	return NULL;
+}
+
 static struct dlb_dir_pq_pair *
 dlb_get_domain_used_dir_pq(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
 {
@@ -226,6 +250,27 @@ dlb_get_domain_used_dir_pq(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
 	return NULL;
 }
 
+static struct dlb_dir_pq_pair *
+dlb_get_domain_dir_pq(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
+{
+	struct dlb_dir_pq_pair *port;
+
+	if (id >= DLB_MAX_NUM_DIR_PORTS)
+		return NULL;
+
+	list_for_each_entry(port, &domain->used_dir_pq_pairs, domain_list) {
+		if (!vdev_req && port->id == id)
+			return port;
+	}
+
+	list_for_each_entry(port, &domain->avail_dir_pq_pairs, domain_list) {
+		if (!vdev_req && port->id == id)
+			return port;
+	}
+
+	return NULL;
+}
+
 static struct dlb_ldb_queue *
 dlb_get_domain_ldb_queue(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
 {
@@ -3147,6 +3192,70 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
 	return dlb_domain_reset_software_state(hw, domain);
 }
 
+/**
+ * dlb_ldb_port_owned_by_domain() - query whether a port is owned by a domain
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @port_id: port ID.
+ *
+ * This function returns whether a load-balanced port is owned by a specified
+ * domain.
+ *
+ * Return:
+ * Returns 0 if false, 1 if true, <0 otherwise.
+ *
+ * EINVAL - Invalid domain or port ID, or the domain is not configured.
+ */
+int dlb_ldb_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_port *port;
+
+	domain = dlb_get_domain_from_id(hw, domain_id);
+
+	if (!domain || !domain->configured)
+		return -EINVAL;
+
+	port = dlb_get_domain_ldb_port(port_id, false, domain);
+
+	if (!port)
+		return -EINVAL;
+
+	return port->domain_id == domain->id;
+}
+
+/**
+ * dlb_dir_port_owned_by_domain() - query whether a port is owned by a domain
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @port_id: port ID.
+ *
+ * This function returns whether a directed port is owned by a specified
+ * domain.
+ *
+ * Return:
+ * Returns 0 if false, 1 if true, <0 otherwise.
+ *
+ * EINVAL - Invalid domain or port ID, or the domain is not configured.
+ */
+int dlb_dir_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id)
+{
+	struct dlb_dir_pq_pair *port;
+	struct dlb_hw_domain *domain;
+
+	domain = dlb_get_domain_from_id(hw, domain_id);
+
+	if (!domain || !domain->configured)
+		return -EINVAL;
+
+	port = dlb_get_domain_dir_pq(port_id, false, domain);
+
+	if (!port)
+		return -EINVAL;
+
+	return port->domain_id == domain->id;
+}
+
 /**
  * dlb_clr_pmcsr_disable() - power on bulk of DLB 2.0 logic
  * @hw: dlb_hw handle for a particular device.
-- 
2.27.0

