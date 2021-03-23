Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBB5346E04
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhCXADw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:03:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:37587 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234343AbhCXADV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:03:21 -0400
IronPort-SDR: nZUAmeUiHCMVT7IPASoO2Y1sRx43xxf11TSE4H+NL8PgFbxlO4jkah6fCjxqNw5NK5ivEETTD8
 fTGv7nDz0AYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="170556540"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="170556540"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:21 -0700
IronPort-SDR: ASzLOHqIpcmuNAu/uKS8dMHFRRFLQfdgE2cMpjjxrGj0DleuatEu84/d7Bvpg4mUmtSvy5XhPC
 OPGvkN3bQQHg==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381542177"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.103.207])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:19 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v2 01/23] iidc: Introduce iidc.h
Date:   Tue, 23 Mar 2021 18:59:45 -0500
Message-Id: <20210324000007.1450-2-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210324000007.1450-1-shiraz.saleem@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Introduce a shared header file used by the 'ice' Intel networking driver
providing RDMA support and the 'irdma' driver to provide a private
interface.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 MAINTAINERS                    |   1 +
 include/linux/net/intel/iidc.h | 254 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 255 insertions(+)
 create mode 100644 include/linux/net/intel/iidc.h

diff --git a/MAINTAINERS b/MAINTAINERS
index d92f85c..2d2d4e7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8956,6 +8956,7 @@ F:	Documentation/networking/device_drivers/ethernet/intel/
 F:	drivers/net/ethernet/intel/
 F:	drivers/net/ethernet/intel/*/
 F:	include/linux/avf/virtchnl.h
+F:	include/linux/net/intel/iidc.h
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Maik Broemme <mbroemme@libmpq.org>
diff --git a/include/linux/net/intel/iidc.h b/include/linux/net/intel/iidc.h
new file mode 100644
index 00000000..9f9a7e2
--- /dev/null
+++ b/include/linux/net/intel/iidc.h
@@ -0,0 +1,254 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021, Intel Corporation. */
+
+#ifndef _IIDC_H_
+#define _IIDC_H_
+
+#include <linux/auxiliary_bus.h>
+#include <linux/dcbnl.h>
+#include <linux/device.h>
+#include <linux/if_ether.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+
+enum iidc_event_type {
+	IIDC_EVENT_BEFORE_MTU_CHANGE,
+	IIDC_EVENT_AFTER_MTU_CHANGE,
+	IIDC_EVENT_BEFORE_TC_CHANGE,
+	IIDC_EVENT_AFTER_TC_CHANGE,
+	IIDC_EVENT_DSCP_MAP_CHANGE,
+	IIDC_EVENT_CRIT_ERR,
+	IIDC_EVENT_NBITS		/* must be last */
+};
+
+enum iidc_res_type {
+	IIDC_INVAL_RES,
+	IIDC_VSI,
+	IIDC_VEB,
+	IIDC_EVENT_Q,
+	IIDC_EGRESS_CMPL_Q,
+	IIDC_CMPL_EVENT_Q,
+	IIDC_ASYNC_EVENT_Q,
+	IIDC_DOORBELL_Q,
+	IIDC_RDMA_QSETS_TXSCHED,
+};
+
+enum iidc_reset_type {
+	IIDC_PFR,
+	IIDC_CORER,
+	IIDC_GLOBR,
+};
+
+enum iidc_rdma_protocol {
+	IIDC_RDMA_PROTOCOL_IWARP,
+	IIDC_RDMA_PROTOCOL_ROCEV2,
+};
+
+enum iidc_rdma_limits_selector {
+	IIDC_RDMA_LIMITS_SEL_0,
+	IIDC_RDMA_LIMITS_SEL_1,
+	IIDC_RDMA_LIMITS_SEL_2,
+	IIDC_RDMA_LIMITS_SEL_3,
+	IIDC_RDMA_LIMITS_SEL_4,
+	IIDC_RDMA_LIMITS_SEL_5,
+	IIDC_RDMA_LIMITS_SEL_6,
+	IIDC_RDMA_LIMITS_SEL_7,
+};
+
+/* Struct to hold per DCB APP info */
+struct iidc_dcb_app_info {
+	u8  priority;
+	u8  selector;
+	u16 prot_id;
+};
+
+struct iidc_core_dev_info;
+
+#define IIDC_MAX_USER_PRIORITY		8
+#define IIDC_MAX_APPS			72
+#define IIDC_MAX_DSCP_MAPPING		64
+
+/* Struct to hold per RDMA Qset info */
+struct iidc_rdma_qset_params {
+	u32 teid;	/* qset TEID */
+	u16 qs_handle; /* RDMA driver provides this */
+	u16 vport_id; /* VSI index */
+	u8 tc; /* TC branch the QSet should belong to */
+	u8 reserved[3];
+};
+
+struct iidc_res_base {
+	/* Union for future provision e.g. other res_type */
+	union {
+		struct iidc_rdma_qset_params qsets;
+	} res;
+};
+
+struct iidc_res {
+	/* Type of resource. */
+	enum iidc_res_type res_type;
+	/* Count requested */
+	u16 cnt_req;
+
+	/* Number of resources allocated. Filled in by callee.
+	 * Based on this value, caller to fill up "resources"
+	 */
+	u16 res_allocated;
+
+	/* Unique handle to resources allocated. Zero if call fails.
+	 * Allocated by callee and for now used by caller for internal
+	 * tracking purpose.
+	 */
+	u32 res_handle;
+
+	/* Peer driver has to allocate sufficient memory, to accommodate
+	 * cnt_requested before calling this function.
+	 * Memory has to be zero initialized. It is input/output param.
+	 * As a result of alloc_res API, this structures will be populated.
+	 */
+	struct iidc_res_base res[1];
+};
+
+struct iidc_qos_info {
+	u64 tc_ctx;
+	u8 rel_bw;
+	u8 prio_type;
+	u8 egress_virt_up;
+	u8 ingress_virt_up;
+};
+
+struct iidc_dscp_map {
+	u16 dscp_val;
+	u8 tc;
+};
+
+/* Struct to hold QoS info */
+struct iidc_qos_params {
+	struct iidc_qos_info tc_info[IEEE_8021QAZ_MAX_TCS];
+	u8 up2tc[IIDC_MAX_USER_PRIORITY];
+	u8 vport_relative_bw;
+	u8 vport_priority_type;
+	u32 num_apps;
+	struct iidc_dcb_app_info apps[IIDC_MAX_APPS];
+	struct iidc_dscp_map dscp_maps[IIDC_MAX_DSCP_MAPPING];
+	u8 num_tc;
+};
+
+union iidc_event_info {
+	/* IIDC_EVENT_AFTER_TC_CHANGE */
+	struct iidc_qos_params port_qos;
+	/* IIDC_EVENT_CRIT_ERR */
+	u32 reg;
+};
+
+struct iidc_event {
+	DECLARE_BITMAP(type, IIDC_EVENT_NBITS);
+	union iidc_event_info info;
+};
+
+/* Following APIs are implemented by core PCI driver */
+struct iidc_core_ops {
+	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
+	 * completion queues, Tx/Rx queues, etc...
+	 */
+	int (*alloc_res)(struct iidc_core_dev_info *cdev_info,
+			 struct iidc_res *res,
+			 int partial_acceptable);
+	int (*free_res)(struct iidc_core_dev_info *cdev_info,
+			struct iidc_res *res);
+
+	int (*request_reset)(struct iidc_core_dev_info *cdev_info,
+			     enum iidc_reset_type reset_type);
+
+	int (*update_vport_filter)(struct iidc_core_dev_info *cdev_info,
+				   u16 vport_id, bool enable);
+	int (*vc_send)(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8 *msg,
+		       u16 len);
+};
+
+/* Following APIs are implemented by auxiliary drivers and invoked by core PCI
+ * driver
+ */
+struct iidc_auxiliary_ops {
+	/* This event_handler is meant to be a blocking call.  For instance,
+	 * when a BEFORE_MTU_CHANGE event comes in, the event_handler will not
+	 * return until the auxiliary driver is ready for the MTU change to
+	 * happen.
+	 */
+	void (*event_handler)(struct iidc_core_dev_info *cdev_info,
+			      struct iidc_event *event);
+
+	int (*vc_receive)(struct iidc_core_dev_info *cdev_info, u32 vf_id,
+			  u8 *msg, u16 len);
+};
+
+#define IIDC_RDMA_NAME	"intel_rdma"
+#define IIDC_RDMA_ID	0x00000010
+#define IIDC_MAX_NUM_AUX	4
+
+/* The const struct that instantiates cdev_info_id needs to be initialized
+ * in the .c with the macro ASSIGN_IIDC_INFO.
+ * For example:
+ * static const struct cdev_info_id cdev_info_ids[] = ASSIGN_IIDC_INFO;
+ */
+struct cdev_info_id {
+	char *name;
+	int id;
+};
+
+#define IIDC_RDMA_INFO   { .name = IIDC_RDMA_NAME,  .id = IIDC_RDMA_ID },
+
+#define ASSIGN_IIDC_INFO	\
+{				\
+	IIDC_RDMA_INFO		\
+}
+
+#define iidc_priv(x) ((x)->auxiliary_priv)
+
+/* Structure representing auxiliary driver tailored information about the core
+ * PCI dev, each auxiliary driver using the IIDC interface will have an
+ * instance of this struct dedicated to it.
+ */
+struct iidc_core_dev_info {
+	struct pci_dev *pdev; /* PCI device of corresponding to main function */
+	struct auxiliary_device *adev;
+	/* KVA / Linear address corresponding to BAR0 of underlying
+	 * pci_device.
+	 */
+	u8 __iomem *hw_addr;
+	int cdev_info_id;
+
+	u8 ftype;	/* PF(false) or VF (true) */
+
+	u16 vport_id;
+	enum iidc_rdma_protocol rdma_protocol;
+	enum iidc_rdma_limits_selector rdma_limits_sel;
+
+	struct iidc_qos_params qos_info;
+	struct net_device *netdev;
+
+	struct msix_entry *msix_entries;
+	u16 msix_count; /* How many vectors are reserved for this device */
+
+	/* Following struct contains function pointers to be initialized
+	 * by core PCI driver and called by auxiliary driver
+	 */
+	const struct iidc_core_ops *ops;
+};
+
+struct iidc_auxiliary_dev {
+	struct auxiliary_device adev;
+	struct iidc_core_dev_info *cdev_info;
+};
+
+/* structure representing the auxiliary driver. This struct is to be
+ * allocated and populated by the auxiliary driver's owner. The core PCI
+ * driver will access these ops by performing a container_of on the
+ * auxiliary_device->dev.driver.
+ */
+struct iidc_auxiliary_drv {
+	struct auxiliary_driver adrv;
+	struct iidc_auxiliary_ops *ops;
+};
+
+#endif /* _IIDC_H_*/
-- 
1.8.3.1

