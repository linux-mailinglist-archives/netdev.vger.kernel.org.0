Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E8A316D86
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhBJR7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:59:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:60436 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233625AbhBJR6S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:58:18 -0500
IronPort-SDR: m6XZyldweA+veR+oJY9YBvJNpyz/vPW3YSsz1BSzGVJQhVZnpF/c3Tz230LWm0FUHm5rgVuoI+
 aItI2UhkbzSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236038"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236038"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:12 -0800
IronPort-SDR: 9UD4dErFmmgdy1UIR9/htgN7im+sO0gJQQQR8jjvU6h4f8opdFrfXUdwri034XoOvj06gQFikD
 UDLuzba3D+gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235794"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:11 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 14/20] dlb: add start domain ioctl
Date:   Wed, 10 Feb 2021 11:54:17 -0600
Message-Id: <20210210175423.1873-15-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ioctl to start a domain. Once a scheduling domain and its resources
have been configured, this ioctl is called to allow the domain's ports to
begin enqueueing to the device. Once started, the domain's resources cannot
be configured again until after the domain is reset.

This ioctl instructs the DLB device to start load-balancing operations.
It corresponds to rte_event_dev_start() function in DPDK' eventdev library.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/dlb_ioctl.c    |   3 +
 drivers/misc/dlb/dlb_main.h     |   4 ++
 drivers/misc/dlb/dlb_pf_ops.c   |   9 +++
 drivers/misc/dlb/dlb_resource.c | 116 ++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_resource.h |   4 ++
 include/uapi/linux/dlb.h        |  22 ++++++
 6 files changed, 158 insertions(+)

diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.c
index 6a311b969643..9b05344f03c8 100644
--- a/drivers/misc/dlb/dlb_ioctl.c
+++ b/drivers/misc/dlb/dlb_ioctl.c
@@ -51,6 +51,7 @@ DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_ldb_queue)
 DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_dir_queue)
 DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_ldb_queue_depth)
 DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_dir_queue_depth)
+DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(start_domain)
 
 /*
  * Port creation ioctls don't use the callback template macro.
@@ -322,6 +323,8 @@ long dlb_domain_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		return dlb_domain_ioctl_get_dir_port_pp_fd(dlb, dom, arg);
 	case DLB_IOC_GET_DIR_PORT_CQ_FD:
 		return dlb_domain_ioctl_get_dir_port_cq_fd(dlb, dom, arg);
+	case DLB_IOC_START_DOMAIN:
+		return dlb_domain_ioctl_start_domain(dlb, dom, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 477974e1a178..2f3096a45b1e 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -63,6 +63,10 @@ struct dlb_device_ops {
 			       struct dlb_create_dir_port_args *args,
 			       uintptr_t cq_dma_base,
 			       struct dlb_cmd_response *resp);
+	int (*start_domain)(struct dlb_hw *hw,
+			    u32 domain_id,
+			    struct dlb_start_domain_args *args,
+			    struct dlb_cmd_response *resp);
 	int (*get_num_resources)(struct dlb_hw *hw,
 				 struct dlb_get_num_resources_args *args);
 	int (*reset_domain)(struct dlb_hw *hw, u32 domain_id);
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index 02a188aa5a60..ce9d29b94a55 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -160,6 +160,14 @@ dlb_pf_create_dir_port(struct dlb_hw *hw, u32 id,
 				       resp, false, 0);
 }
 
+static int
+dlb_pf_start_domain(struct dlb_hw *hw, u32 id,
+		    struct dlb_start_domain_args *args,
+		    struct dlb_cmd_response *resp)
+{
+	return dlb_hw_start_domain(hw, id, args, resp, false, 0);
+}
+
 static int dlb_pf_get_num_resources(struct dlb_hw *hw,
 				    struct dlb_get_num_resources_args *args)
 {
@@ -232,6 +240,7 @@ struct dlb_device_ops dlb_pf_ops = {
 	.create_dir_queue = dlb_pf_create_dir_queue,
 	.create_ldb_port = dlb_pf_create_ldb_port,
 	.create_dir_port = dlb_pf_create_dir_port,
+	.start_domain = dlb_pf_start_domain,
 	.get_num_resources = dlb_pf_get_num_resources,
 	.reset_domain = dlb_pf_reset_domain,
 	.ldb_port_owned_by_domain = dlb_pf_ldb_port_owned_by_domain,
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 2659190527a7..ee95c93aac7b 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -1217,6 +1217,35 @@ dlb_verify_create_dir_port_args(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static int dlb_verify_start_domain_args(struct dlb_hw *hw, u32 domain_id,
+					struct dlb_cmd_response *resp,
+					bool vdev_req, unsigned int vdev_id,
+					struct dlb_hw_domain **out_domain)
+{
+	struct dlb_hw_domain *domain;
+
+	domain = dlb_get_domain_from_id(hw, domain_id, vdev_req, vdev_id);
+
+	if (!domain) {
+		resp->status = DLB_ST_INVALID_DOMAIN_ID;
+		return -EINVAL;
+	}
+
+	if (!domain->configured) {
+		resp->status = DLB_ST_DOMAIN_NOT_CONFIGURED;
+		return -EINVAL;
+	}
+
+	if (domain->started) {
+		resp->status = DLB_ST_DOMAIN_STARTED;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+
+	return 0;
+}
+
 static void dlb_configure_domain_credits(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
 {
@@ -2712,6 +2741,93 @@ static void dlb_domain_reset_ldb_port_registers(struct dlb_hw *hw,
 	}
 }
 
+static void dlb_log_start_domain(struct dlb_hw *hw, u32 domain_id,
+				 bool vdev_req, unsigned int vdev_id)
+{
+	DLB_HW_DBG(hw, "DLB start domain arguments:\n");
+	if (vdev_req)
+		DLB_HW_DBG(hw, "(Request from vdev %d)\n", vdev_id);
+	DLB_HW_DBG(hw, "\tDomain ID: %d\n", domain_id);
+}
+
+/**
+ * dlb_hw_start_domain() - start a scheduling domain
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @unused: unused.
+ * @resp: response structure.
+ * @vdev_req: indicates whether this request came from a vdev.
+ * @vdev_id: If vdev_req is true, this contains the vdev's ID.
+ *
+ * This function starts a scheduling domain, which allows applications to send
+ * traffic through it. Once a domain is started, its resources can no longer be
+ * configured (besides QID remapping and port enable/disable).
+ *
+ * A vdev can be either an SR-IOV virtual function or a Scalable IOV virtual
+ * device.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error.
+ *
+ * Errors:
+ * EINVAL - the domain is not configured, or the domain is already started.
+ */
+int
+dlb_hw_start_domain(struct dlb_hw *hw, u32 domain_id, void *unused,
+		    struct dlb_cmd_response *resp, bool vdev_req,
+		    unsigned int vdev_id)
+{
+	struct dlb_dir_pq_pair *dir_queue;
+	struct dlb_ldb_queue *ldb_queue;
+	struct dlb_hw_domain *domain;
+	int ret;
+
+	dlb_log_start_domain(hw, domain_id, vdev_req, vdev_id);
+
+	ret = dlb_verify_start_domain_args(hw, domain_id, resp,
+					   vdev_req, vdev_id, &domain);
+	if (ret)
+		return ret;
+
+	/*
+	 * Enable load-balanced and directed queue write permissions for the
+	 * queues this domain owns. Without this, the DLB will drop all
+	 * incoming traffic to those queues.
+	 */
+	list_for_each_entry(ldb_queue, &domain->used_ldb_queues, domain_list) {
+		u32 vasqid_v = 0;
+		unsigned int offs;
+
+		vasqid_v |= SYS_LDB_VASQID_V_VASQID_V;
+
+		offs = domain->id.phys_id * DLB_MAX_NUM_LDB_QUEUES +
+			ldb_queue->id.phys_id;
+
+		DLB_CSR_WR(hw, SYS_LDB_VASQID_V(offs), vasqid_v);
+	}
+
+	list_for_each_entry(dir_queue, &domain->used_dir_pq_pairs, domain_list) {
+		u32 vasqid_v = 0;
+		unsigned int offs;
+
+		vasqid_v |= SYS_DIR_VASQID_V_VASQID_V;
+
+		offs = domain->id.phys_id * DLB_MAX_NUM_DIR_PORTS +
+			dir_queue->id.phys_id;
+
+		DLB_CSR_WR(hw, SYS_DIR_VASQID_V(offs), vasqid_v);
+	}
+
+	dlb_flush_csr(hw);
+
+	domain->started = true;
+
+	resp->status = 0;
+
+	return 0;
+}
+
 static void
 __dlb_domain_reset_dir_port_registers(struct dlb_hw *hw,
 				      struct dlb_dir_pq_pair *port)
diff --git a/drivers/misc/dlb/dlb_resource.h b/drivers/misc/dlb/dlb_resource.h
index 8a3c37b6ab92..f4852d744dca 100644
--- a/drivers/misc/dlb/dlb_resource.h
+++ b/drivers/misc/dlb/dlb_resource.h
@@ -41,6 +41,10 @@ int dlb_hw_create_ldb_port(struct dlb_hw *hw, u32 domain_id,
 			   struct dlb_cmd_response *resp,
 			   bool vdev_req, unsigned int vdev_id);
 
+int dlb_hw_start_domain(struct dlb_hw *hw, u32 domain_id, void *unused,
+			struct dlb_cmd_response *resp,
+			bool vdev_req, unsigned int vdev_id);
+
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
 		     unsigned int vdev_id);
 
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
index 6b7eceecae8a..84a877ad6824 100644
--- a/include/uapi/linux/dlb.h
+++ b/include/uapi/linux/dlb.h
@@ -408,6 +408,23 @@ struct dlb_get_port_fd_args {
 	__u32 padding0;
 };
 
+/*
+ * DLB_DOMAIN_CMD_START_DOMAIN: Mark the end of the domain configuration. This
+ *	must be called before passing QEs into the device, and no configuration
+ *	ioctls can be issued once the domain has started. Sending QEs into the
+ *	device before calling this ioctl will result in undefined behavior.
+ * Input parameters:
+ * - (None)
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	ioctl request arg is invalid, the driver won't set status.
+ */
+struct dlb_start_domain_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+};
+
 enum dlb_domain_user_interface_commands {
 	DLB_DOMAIN_CMD_CREATE_LDB_QUEUE,
 	DLB_DOMAIN_CMD_CREATE_DIR_QUEUE,
@@ -419,6 +436,7 @@ enum dlb_domain_user_interface_commands {
 	DLB_DOMAIN_CMD_GET_LDB_PORT_CQ_FD,
 	DLB_DOMAIN_CMD_GET_DIR_PORT_PP_FD,
 	DLB_DOMAIN_CMD_GET_DIR_PORT_CQ_FD,
+	DLB_DOMAIN_CMD_START_DOMAIN,
 
 	/* NUM_DLB_DOMAIN_CMD must be last */
 	NUM_DLB_DOMAIN_CMD,
@@ -493,5 +511,9 @@ enum dlb_domain_user_interface_commands {
 		_IOWR(DLB_IOC_MAGIC,				\
 		      DLB_DOMAIN_CMD_GET_DIR_PORT_CQ_FD,	\
 		      struct dlb_get_port_fd_args)
+#define DLB_IOC_START_DOMAIN					\
+		_IOR(DLB_IOC_MAGIC,				\
+		     DLB_DOMAIN_CMD_START_DOMAIN,		\
+		     struct dlb_start_domain_args)
 
 #endif /* __DLB_H */
-- 
2.17.1

