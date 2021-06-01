Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B77C3977F1
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 18:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhFAQ0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 12:26:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:25271 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233397AbhFAQ0L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 12:26:11 -0400
IronPort-SDR: PzbP5iHjuxqgsGpcy9iS3f6aio1cgmDZgTKKdLhlOsKV4YOYnB+C7g8eLvwluflBfKvRSSdIJN
 ljn2D+RVv/Zg==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="183263181"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="183263181"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 09:24:22 -0700
IronPort-SDR: 0F6nTHhkAQxwezTXxEcGAB7JBPUL5KP2QOwx8N0J450VKkEBK3U7ac4y+CoXqojD33hHvRHI8e
 qOPlVDHVhIMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="411292750"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jun 2021 09:24:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, anthony.l.nguyen@intel.com,
        shiraz.saleem@intel.com
Subject: [PATCH net-next v3 2/7] iidc: Introduce iidc.h
Date:   Tue,  1 Jun 2021 09:26:39 -0700
Message-Id: <20210601162644.1469616-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601162644.1469616-1-anthony.l.nguyen@intel.com>
References: <20210601162644.1469616-1-anthony.l.nguyen@intel.com>
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
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 MAINTAINERS                    |   1 +
 include/linux/net/intel/iidc.h | 100 +++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)
 create mode 100644 include/linux/net/intel/iidc.h

diff --git a/MAINTAINERS b/MAINTAINERS
index bd7aff0c120f..34d2bf36b5ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9130,6 +9130,7 @@ F:	Documentation/networking/device_drivers/ethernet/intel/
 F:	drivers/net/ethernet/intel/
 F:	drivers/net/ethernet/intel/*/
 F:	include/linux/avf/virtchnl.h
+F:	include/linux/net/intel/iidc.h
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Maik Broemme <mbroemme@libmpq.org>
diff --git a/include/linux/net/intel/iidc.h b/include/linux/net/intel/iidc.h
new file mode 100644
index 000000000000..e32f6712aee0
--- /dev/null
+++ b/include/linux/net/intel/iidc.h
@@ -0,0 +1,100 @@
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
+	IIDC_EVENT_CRIT_ERR,
+	IIDC_EVENT_NBITS		/* must be last */
+};
+
+enum iidc_reset_type {
+	IIDC_PFR,
+	IIDC_CORER,
+	IIDC_GLOBR,
+};
+
+#define IIDC_MAX_USER_PRIORITY		8
+
+/* Struct to hold per RDMA Qset info */
+struct iidc_rdma_qset_params {
+	/* Qset TEID returned to the RDMA driver in
+	 * ice_add_rdma_qset and used by RDMA driver
+	 * for calls to ice_del_rdma_qset
+	 */
+	u32 teid;	/* Qset TEID */
+	u16 qs_handle; /* RDMA driver provides this */
+	u16 vport_id; /* VSI index */
+	u8 tc; /* TC branch the Qset should belong to */
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
+/* Struct to pass QoS info */
+struct iidc_qos_params {
+	struct iidc_qos_info tc_info[IEEE_8021QAZ_MAX_TCS];
+	u8 up2tc[IIDC_MAX_USER_PRIORITY];
+	u8 vport_relative_bw;
+	u8 vport_priority_type;
+	u8 num_tc;
+};
+
+struct iidc_event {
+	DECLARE_BITMAP(type, IIDC_EVENT_NBITS);
+	u32 reg;
+};
+
+struct ice_pf;
+
+int ice_add_rdma_qset(struct ice_pf *pf, struct iidc_rdma_qset_params *qset);
+int ice_del_rdma_qset(struct ice_pf *pf, struct iidc_rdma_qset_params *qset);
+int ice_rdma_request_reset(struct ice_pf *pf, enum iidc_reset_type reset_type);
+int ice_rdma_update_vsi_filter(struct ice_pf *pf, u16 vsi_id, bool enable);
+void ice_get_qos_params(struct ice_pf *pf, struct iidc_qos_params *qos);
+
+#define IIDC_RDMA_ROCE_NAME	"roce"
+
+/* Structure representing auxiliary driver tailored information about the core
+ * PCI dev, each auxiliary driver using the IIDC interface will have an
+ * instance of this struct dedicated to it.
+ */
+
+struct iidc_auxiliary_dev {
+	struct auxiliary_device adev;
+	struct ice_pf *pf;
+};
+
+/* structure representing the auxiliary driver. This struct is to be
+ * allocated and populated by the auxiliary driver's owner. The core PCI
+ * driver will access these ops by performing a container_of on the
+ * auxiliary_device->dev.driver.
+ */
+struct iidc_auxiliary_drv {
+	struct auxiliary_driver adrv;
+	/* This event_handler is meant to be a blocking call.  For instance,
+	 * when a BEFORE_MTU_CHANGE event comes in, the event_handler will not
+	 * return until the auxiliary driver is ready for the MTU change to
+	 * happen.
+	 */
+	void (*event_handler)(struct ice_pf *pf, struct iidc_event *event);
+};
+
+#endif /* _IIDC_H_*/
-- 
2.26.2

