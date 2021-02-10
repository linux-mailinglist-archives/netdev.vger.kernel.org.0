Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D071316D87
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhBJSAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:00:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:60442 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhBJR63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:58:29 -0500
IronPort-SDR: fpu7w9CystjIt9HwOXrVIxqHU8Y6MM2R9/CdbLMk1oK+OiwJwCDN6o7r3c9ICIWsrQP2Okhsq5
 nDDTXTCVE54A==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236040"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236040"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:12 -0800
IronPort-SDR: pfjl1BD1eszT6z+iYFWCF9ZZMYzr1X8NkfWsG+7V8lz3oVKbSSQXfFp8oHajfYK0nU6Vzb9nuY
 uUQp+kNXYgrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235800"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:12 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 15/20] dlb: add queue map, unmap, and pending unmap operations
Date:   Wed, 10 Feb 2021 11:54:18 -0600
Message-Id: <20210210175423.1873-16-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the high-level code for queue map, unmap, and pending unmap query ioctl
commands and argument verification -- with stubs for the low-level register
accesses and the queue map/unmap state machine, to be filled in a later
commit.

The queue map/unmap in this commit refers to link/unlink between DLB's
load-balanced queues (internal) and consumer ports.See Documentation/
misc-devices/dlb.rst for details.

Load-balanced queues can be "mapped" to any number of load-balanced ports.
Once mapped, the port becomes a candidate to which the device can schedule
queue entries from the queue. If a port is unmapped from a queue, it is no
longer a candidate for scheduling from that queue.

The pending unmaps function queries how many unmap operations are
in-progress for a given port. These operations are asynchronous, so
multiple may be in-flight at any given time.

These operations support rte_event_port_link(), rte_event_port_unlink()
and rte_event_port_unlinks_in_progress() functions of DPDK's eventdev
library.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/dlb_ioctl.c    |   9 +
 drivers/misc/dlb/dlb_main.h     |  12 ++
 drivers/misc/dlb/dlb_pf_ops.c   |  25 +++
 drivers/misc/dlb/dlb_resource.c | 358 ++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_resource.h |  15 ++
 include/uapi/linux/dlb.h        |  83 ++++++++
 6 files changed, 502 insertions(+)

diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.c
index 9b05344f03c8..3ce6d3ef3706 100644
--- a/drivers/misc/dlb/dlb_ioctl.c
+++ b/drivers/misc/dlb/dlb_ioctl.c
@@ -52,6 +52,9 @@ DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_dir_queue)
 DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_ldb_queue_depth)
 DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_dir_queue_depth)
 DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(start_domain)
+DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(map_qid)
+DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(unmap_qid)
+DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(pending_port_unmaps)
 
 /*
  * Port creation ioctls don't use the callback template macro.
@@ -325,6 +328,12 @@ long dlb_domain_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		return dlb_domain_ioctl_get_dir_port_cq_fd(dlb, dom, arg);
 	case DLB_IOC_START_DOMAIN:
 		return dlb_domain_ioctl_start_domain(dlb, dom, arg);
+	case DLB_IOC_MAP_QID:
+		return dlb_domain_ioctl_map_qid(dlb, dom, arg);
+	case DLB_IOC_UNMAP_QID:
+		return dlb_domain_ioctl_unmap_qid(dlb, dom, arg);
+	case DLB_IOC_PENDING_PORT_UNMAPS:
+		return dlb_domain_ioctl_pending_port_unmaps(dlb, dom, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 2f3096a45b1e..5942fbf22cbb 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -67,6 +67,18 @@ struct dlb_device_ops {
 			    u32 domain_id,
 			    struct dlb_start_domain_args *args,
 			    struct dlb_cmd_response *resp);
+	int (*map_qid)(struct dlb_hw *hw,
+		       u32 domain_id,
+		       struct dlb_map_qid_args *args,
+		       struct dlb_cmd_response *resp);
+	int (*unmap_qid)(struct dlb_hw *hw,
+			 u32 domain_id,
+			 struct dlb_unmap_qid_args *args,
+			 struct dlb_cmd_response *resp);
+	int (*pending_port_unmaps)(struct dlb_hw *hw,
+				   u32 domain_id,
+				   struct dlb_pending_port_unmaps_args *args,
+				   struct dlb_cmd_response *resp);
 	int (*get_num_resources)(struct dlb_hw *hw,
 				 struct dlb_get_num_resources_args *args);
 	int (*reset_domain)(struct dlb_hw *hw, u32 domain_id);
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index ce9d29b94a55..0c32b30955cf 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -168,6 +168,28 @@ dlb_pf_start_domain(struct dlb_hw *hw, u32 id,
 	return dlb_hw_start_domain(hw, id, args, resp, false, 0);
 }
 
+static int
+dlb_pf_map_qid(struct dlb_hw *hw, u32 id, struct dlb_map_qid_args *args,
+	       struct dlb_cmd_response *resp)
+{
+	return dlb_hw_map_qid(hw, id, args, resp, false, 0);
+}
+
+static int
+dlb_pf_unmap_qid(struct dlb_hw *hw, u32 id, struct dlb_unmap_qid_args *args,
+		 struct dlb_cmd_response *resp)
+{
+	return dlb_hw_unmap_qid(hw, id, args, resp, false, 0);
+}
+
+static int
+dlb_pf_pending_port_unmaps(struct dlb_hw *hw, u32 id,
+			   struct dlb_pending_port_unmaps_args *args,
+			   struct dlb_cmd_response *resp)
+{
+	return dlb_hw_pending_port_unmaps(hw, id, args, resp, false, 0);
+}
+
 static int dlb_pf_get_num_resources(struct dlb_hw *hw,
 				    struct dlb_get_num_resources_args *args)
 {
@@ -241,6 +263,9 @@ struct dlb_device_ops dlb_pf_ops = {
 	.create_ldb_port = dlb_pf_create_ldb_port,
 	.create_dir_port = dlb_pf_create_dir_port,
 	.start_domain = dlb_pf_start_domain,
+	.map_qid = dlb_pf_map_qid,
+	.unmap_qid = dlb_pf_unmap_qid,
+	.pending_port_unmaps = dlb_pf_pending_port_unmaps,
 	.get_num_resources = dlb_pf_get_num_resources,
 	.reset_domain = dlb_pf_reset_domain,
 	.ldb_port_owned_by_domain = dlb_pf_ldb_port_owned_by_domain,
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index ee95c93aac7b..f39853fc664f 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -236,6 +236,32 @@ static struct dlb_hw_domain *dlb_get_domain_from_id(struct dlb_hw *hw, u32 id,
 	return NULL;
 }
 
+static struct dlb_ldb_port *
+dlb_get_domain_used_ldb_port(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	if (id >= DLB_MAX_NUM_LDB_PORTS)
+		return NULL;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			if ((!vdev_req && port->id.phys_id == id) ||
+			    (vdev_req && port->id.virt_id == id))
+				return port;
+		}
+
+		list_for_each_entry(port, &domain->avail_ldb_ports[i], domain_list) {
+			if ((!vdev_req && port->id.phys_id == id) ||
+			    (vdev_req && port->id.virt_id == id))
+				return port;
+		}
+	}
+
+	return NULL;
+}
+
 static struct dlb_ldb_port *
 dlb_get_domain_ldb_port(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
 {
@@ -1246,6 +1272,124 @@ static int dlb_verify_start_domain_args(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static int dlb_verify_map_qid_args(struct dlb_hw *hw, u32 domain_id,
+				   struct dlb_map_qid_args *args,
+				   struct dlb_cmd_response *resp,
+				   bool vdev_req, unsigned int vdev_id,
+				   struct dlb_hw_domain **out_domain,
+				   struct dlb_ldb_port **out_port,
+				   struct dlb_ldb_queue **out_queue)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	struct dlb_ldb_port *port;
+	int id;
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
+	id = args->port_id;
+
+	port = dlb_get_domain_used_ldb_port(id, vdev_req, domain);
+
+	if (!port || !port->configured) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	if (args->priority >= DLB_QID_PRIORITIES) {
+		resp->status = DLB_ST_INVALID_PRIORITY;
+		return -EINVAL;
+	}
+
+	queue = dlb_get_domain_ldb_queue(args->qid, vdev_req, domain);
+
+	if (!queue || !queue->configured) {
+		resp->status = DLB_ST_INVALID_QID;
+		return -EINVAL;
+	}
+
+	if (queue->domain_id.phys_id != domain->id.phys_id) {
+		resp->status = DLB_ST_INVALID_QID;
+		return -EINVAL;
+	}
+
+	if (port->domain_id.phys_id != domain->id.phys_id) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+	*out_queue = queue;
+	*out_port = port;
+
+	return 0;
+}
+
+static int dlb_verify_unmap_qid_args(struct dlb_hw *hw, u32 domain_id,
+				     struct dlb_unmap_qid_args *args,
+				     struct dlb_cmd_response *resp,
+				     bool vdev_req, unsigned int vdev_id,
+				     struct dlb_hw_domain **out_domain,
+				     struct dlb_ldb_port **out_port,
+				     struct dlb_ldb_queue **out_queue)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	struct dlb_ldb_port *port;
+	int id;
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
+	id = args->port_id;
+
+	port = dlb_get_domain_used_ldb_port(id, vdev_req, domain);
+
+	if (!port || !port->configured) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	if (port->domain_id.phys_id != domain->id.phys_id) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	queue = dlb_get_domain_ldb_queue(args->qid, vdev_req, domain);
+
+	if (!queue || !queue->configured) {
+		DLB_HW_ERR(hw, "[%s()] Can't unmap unconfigured queue %d\n",
+			   __func__, args->qid);
+		resp->status = DLB_ST_INVALID_QID;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+	*out_port = port;
+	*out_queue = queue;
+
+	return 0;
+}
+
 static void dlb_configure_domain_credits(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
 {
@@ -2191,6 +2335,163 @@ int dlb_hw_create_dir_port(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static void dlb_log_map_qid(struct dlb_hw *hw, u32 domain_id,
+			    struct dlb_map_qid_args *args,
+			    bool vdev_req, unsigned int vdev_id)
+{
+	DLB_HW_DBG(hw, "DLB map QID arguments:\n");
+	if (vdev_req)
+		DLB_HW_DBG(hw, "(Request from vdev %d)\n", vdev_id);
+	DLB_HW_DBG(hw, "\tDomain ID: %d\n",
+		   domain_id);
+	DLB_HW_DBG(hw, "\tPort ID:   %d\n",
+		   args->port_id);
+	DLB_HW_DBG(hw, "\tQueue ID:  %d\n",
+		   args->qid);
+	DLB_HW_DBG(hw, "\tPriority:  %d\n",
+		   args->priority);
+}
+
+/**
+ * dlb_hw_map_qid() - map a load-balanced queue to a load-balanced port
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: map QID arguments.
+ * @resp: response structure.
+ * @vdev_req: indicates whether this request came from a vdev.
+ * @vdev_id: If vdev_req is true, this contains the vdev's ID.
+ *
+ * This function configures the DLB to schedule QEs from the specified queue
+ * to the specified port. Each load-balanced port can be mapped to up to 8
+ * queues; each load-balanced queue can potentially map to all the
+ * load-balanced ports.
+ *
+ * A successful return does not necessarily mean the mapping was configured. If
+ * this function is unable to immediately map the queue to the port, it will
+ * add the requested operation to a per-port list of pending map/unmap
+ * operations, and (if it's not already running) launch a kernel thread that
+ * periodically attempts to process all pending operations. In a sense, this is
+ * an asynchronous function.
+ *
+ * This asynchronicity creates two views of the state of hardware: the actual
+ * hardware state and the requested state (as if every request completed
+ * immediately). If there are any pending map/unmap operations, the requested
+ * state will differ from the actual state. All validation is performed with
+ * respect to the pending state; for instance, if there are 8 pending map
+ * operations for port X, a request for a 9th will fail because a load-balanced
+ * port can only map up to 8 queues.
+ *
+ * A vdev can be either an SR-IOV virtual function or a Scalable IOV virtual
+ * device.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, invalid port or queue ID, or
+ *	    the domain is not configured.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_map_qid(struct dlb_hw *hw, u32 domain_id,
+		   struct dlb_map_qid_args *args,
+		   struct dlb_cmd_response *resp,
+		   bool vdev_req, unsigned int vdev_id)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	struct dlb_ldb_port *port;
+	int ret;
+
+	dlb_log_map_qid(hw, domain_id, args, vdev_req, vdev_id);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_map_qid_args(hw, domain_id, args, resp, vdev_req,
+				      vdev_id, &domain, &port, &queue);
+	if (ret)
+		return ret;
+
+	resp->status = 0;
+
+	return 0;
+}
+
+static void dlb_log_unmap_qid(struct dlb_hw *hw, u32 domain_id,
+			      struct dlb_unmap_qid_args *args,
+			      bool vdev_req, unsigned int vdev_id)
+{
+	DLB_HW_DBG(hw, "DLB unmap QID arguments:\n");
+	if (vdev_req)
+		DLB_HW_DBG(hw, "(Request from vdev %d)\n", vdev_id);
+	DLB_HW_DBG(hw, "\tDomain ID: %d\n",
+		   domain_id);
+	DLB_HW_DBG(hw, "\tPort ID:   %d\n",
+		   args->port_id);
+	DLB_HW_DBG(hw, "\tQueue ID:  %d\n",
+		   args->qid);
+	if (args->qid < DLB_MAX_NUM_LDB_QUEUES)
+		DLB_HW_DBG(hw, "\tQueue's num mappings:  %d\n",
+			   hw->rsrcs.ldb_queues[args->qid].num_mappings);
+}
+
+/**
+ * dlb_hw_unmap_qid() - Unmap a load-balanced queue from a load-balanced port
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: unmap QID arguments.
+ * @resp: response structure.
+ * @vdev_req: indicates whether this request came from a vdev.
+ * @vdev_id: If vdev_req is true, this contains the vdev's ID.
+ *
+ * This function configures the DLB to stop scheduling QEs from the specified
+ * queue to the specified port.
+ *
+ * A successful return does not necessarily mean the mapping was removed. If
+ * this function is unable to immediately unmap the queue from the port, it
+ * will add the requested operation to a per-port list of pending map/unmap
+ * operations, and (if it's not already running) launch a kernel thread that
+ * periodically attempts to process all pending operations. See
+ * dlb_hw_map_qid() for more details.
+ *
+ * A vdev can be either an SR-IOV virtual function or a Scalable IOV virtual
+ * device.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, invalid port or queue ID, or
+ *	    the domain is not configured.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_unmap_qid(struct dlb_hw *hw, u32 domain_id,
+		     struct dlb_unmap_qid_args *args,
+		     struct dlb_cmd_response *resp,
+		     bool vdev_req, unsigned int vdev_id)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	struct dlb_ldb_port *port;
+	int ret;
+
+	dlb_log_unmap_qid(hw, domain_id, args, vdev_req, vdev_id);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_unmap_qid_args(hw, domain_id, args, resp, vdev_req,
+					vdev_id, &domain, &port, &queue);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static u32 dlb_ldb_cq_inflight_count(struct dlb_hw *hw,
 				     struct dlb_ldb_port *port)
 {
@@ -2530,6 +2831,63 @@ int dlb_hw_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static void
+dlb_log_pending_port_unmaps_args(struct dlb_hw *hw,
+				 struct dlb_pending_port_unmaps_args *args,
+				 bool vdev_req, unsigned int vdev_id)
+{
+	DLB_HW_DBG(hw, "DLB unmaps in progress arguments:\n");
+	if (vdev_req)
+		DLB_HW_DBG(hw, "(Request from VF %d)\n", vdev_id);
+	DLB_HW_DBG(hw, "\tPort ID: %d\n", args->port_id);
+}
+
+/**
+ * dlb_hw_pending_port_unmaps() - returns the number of unmap operations in
+ *	progress.
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: number of unmaps in progress args
+ * @resp: response structure.
+ * @vdev_req: indicates whether this request came from a vdev.
+ * @vdev_id: If vdev_req is true, this contains the vdev's ID.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the number of unmaps in progress.
+ *
+ * Errors:
+ * EINVAL - Invalid port ID.
+ */
+int dlb_hw_pending_port_unmaps(struct dlb_hw *hw, u32 domain_id,
+			       struct dlb_pending_port_unmaps_args *args,
+			       struct dlb_cmd_response *resp,
+			       bool vdev_req, unsigned int vdev_id)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_port *port;
+
+	dlb_log_pending_port_unmaps_args(hw, args, vdev_req, vdev_id);
+
+	domain = dlb_get_domain_from_id(hw, domain_id, vdev_req, vdev_id);
+
+	if (!domain) {
+		resp->status = DLB_ST_INVALID_DOMAIN_ID;
+		return -EINVAL;
+	}
+
+	port = dlb_get_domain_used_ldb_port(args->port_id, vdev_req, domain);
+	if (!port || !port->configured) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	resp->id = port->num_pending_removals;
+
+	return 0;
+}
+
 static u32 dlb_ldb_queue_depth(struct dlb_hw *hw, struct dlb_ldb_queue *queue)
 {
 	u32 aqed, ldb, atm;
diff --git a/drivers/misc/dlb/dlb_resource.h b/drivers/misc/dlb/dlb_resource.h
index f4852d744dca..e3de9eb94d5d 100644
--- a/drivers/misc/dlb/dlb_resource.h
+++ b/drivers/misc/dlb/dlb_resource.h
@@ -45,6 +45,16 @@ int dlb_hw_start_domain(struct dlb_hw *hw, u32 domain_id, void *unused,
 			struct dlb_cmd_response *resp,
 			bool vdev_req, unsigned int vdev_id);
 
+int dlb_hw_map_qid(struct dlb_hw *hw, u32 domain_id,
+		   struct dlb_map_qid_args *args,
+		   struct dlb_cmd_response *resp,
+		   bool vdev_req, unsigned int vdev_id);
+
+int dlb_hw_unmap_qid(struct dlb_hw *hw, u32 domain_id,
+		     struct dlb_unmap_qid_args *args,
+		     struct dlb_cmd_response *resp,
+		     bool vdev_req, unsigned int vdev_id);
+
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
 		     unsigned int vdev_id);
 
@@ -70,6 +80,11 @@ int dlb_hw_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
 			       struct dlb_cmd_response *resp,
 			       bool vdev_req, unsigned int vdev_id);
 
+int dlb_hw_pending_port_unmaps(struct dlb_hw *hw, u32 domain_id,
+			       struct dlb_pending_port_unmaps_args *args,
+			       struct dlb_cmd_response *resp,
+			       bool vdev_req, unsigned int vdev_id);
+
 void dlb_hw_enable_sparse_ldb_cq_mode(struct dlb_hw *hw);
 
 void dlb_hw_enable_sparse_dir_cq_mode(struct dlb_hw *hw);
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
index 84a877ad6824..37eccb6ec230 100644
--- a/include/uapi/linux/dlb.h
+++ b/include/uapi/linux/dlb.h
@@ -34,6 +34,8 @@ enum dlb_error {
 	DLB_ST_INVALID_CQ_DEPTH,
 	DLB_ST_INVALID_HIST_LIST_DEPTH,
 	DLB_ST_INVALID_DIR_QUEUE_ID,
+	DLB_ST_INVALID_PRIORITY,
+	DLB_ST_NO_QID_SLOTS_AVAILABLE,
 };
 
 struct dlb_cmd_response {
@@ -425,6 +427,72 @@ struct dlb_start_domain_args {
 	struct dlb_cmd_response response;
 };
 
+/*
+ * DLB_DOMAIN_CMD_MAP_QID: Map a load-balanced queue to a load-balanced port.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	ioctl request arg is invalid, the driver won't set status.
+ *
+ * Input parameters:
+ * @port_id: Load-balanced port ID.
+ * @qid: Load-balanced queue ID.
+ * @priority: Queue->port service priority.
+ * @padding0: Reserved for future use.
+ */
+struct dlb_map_qid_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 port_id;
+	__u32 qid;
+	__u32 priority;
+	__u32 padding0;
+};
+
+/*
+ * DLB_DOMAIN_CMD_UNMAP_QID: Unmap a load-balanced queue to a load-balanced
+ *	port.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	ioctl request arg is invalid, the driver won't set status.
+ *
+ * Input parameters:
+ * @port_id: Load-balanced port ID.
+ * @qid: Load-balanced queue ID.
+ */
+struct dlb_unmap_qid_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 port_id;
+	__u32 qid;
+};
+
+/*
+ * DLB_DOMAIN_CMD_PENDING_PORT_UNMAPS: Get number of queue unmap operations in
+ *	progress for a load-balanced port.
+ *
+ *	Note: This is a snapshot; the number of unmap operations in progress
+ *	is subject to change at any time.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	ioctl request arg is invalid, the driver won't set status.
+ * @response.id: number of unmaps in progress.
+ *
+ * Input parameters:
+ * @port_id: Load-balanced port ID.
+ */
+struct dlb_pending_port_unmaps_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 port_id;
+	__u32 padding0;
+};
+
 enum dlb_domain_user_interface_commands {
 	DLB_DOMAIN_CMD_CREATE_LDB_QUEUE,
 	DLB_DOMAIN_CMD_CREATE_DIR_QUEUE,
@@ -437,6 +505,9 @@ enum dlb_domain_user_interface_commands {
 	DLB_DOMAIN_CMD_GET_DIR_PORT_PP_FD,
 	DLB_DOMAIN_CMD_GET_DIR_PORT_CQ_FD,
 	DLB_DOMAIN_CMD_START_DOMAIN,
+	DLB_DOMAIN_CMD_MAP_QID,
+	DLB_DOMAIN_CMD_UNMAP_QID,
+	DLB_DOMAIN_CMD_PENDING_PORT_UNMAPS,
 
 	/* NUM_DLB_DOMAIN_CMD must be last */
 	NUM_DLB_DOMAIN_CMD,
@@ -515,5 +586,17 @@ enum dlb_domain_user_interface_commands {
 		_IOR(DLB_IOC_MAGIC,				\
 		     DLB_DOMAIN_CMD_START_DOMAIN,		\
 		     struct dlb_start_domain_args)
+#define DLB_IOC_MAP_QID						\
+		_IOWR(DLB_IOC_MAGIC,				\
+		      DLB_DOMAIN_CMD_MAP_QID,			\
+		      struct dlb_map_qid_args)
+#define DLB_IOC_UNMAP_QID					\
+		_IOWR(DLB_IOC_MAGIC,				\
+		      DLB_DOMAIN_CMD_UNMAP_QID,			\
+		      struct dlb_unmap_qid_args)
+#define DLB_IOC_PENDING_PORT_UNMAPS				\
+		_IOWR(DLB_IOC_MAGIC,				\
+		      DLB_DOMAIN_CMD_PENDING_PORT_UNMAPS,	\
+		      struct dlb_pending_port_unmaps_args)
 
 #endif /* __DLB_H */
-- 
2.17.1

