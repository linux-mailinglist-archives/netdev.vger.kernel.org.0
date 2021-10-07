Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C29426032
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbhJGXKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:53016 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhJGXKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="207199657"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="207199657"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344309"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@resnulli.us, ivecera@redhat.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 01/12] ice: support basic E-Switch mode control
Date:   Thu,  7 Oct 2021 16:06:09 -0700
Message-Id: <20211007230620.3413290-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Write set and get eswitch mode functions used by devlink
ops. Use new pf struct member eswitch_mode to track current
eswitch mode in driver.

Changing eswitch mode is only allowed when there are no
VFs created.

Create new file for eswitch related code.

Add config flag ICE_SWITCHDEV to allow user to choose if
switchdev support should be enabled or disabled.

Use case examples:
- show current eswitch mode ('legacy' is the default one)
[root@localhost]# devlink dev eswitch show pci/0000:03:00.1
pci/0000:03:00.1: mode legacy

- move to 'switchdev' mode
[root@localhost]# devlink dev eswitch set pci/0000:03:00.1 mode
switchdev
[root@localhost]# devlink dev eswitch show pci/0000:03:00.1
pci/0000:03:00.1: mode switchdev

- create 2 VFs
[root@localhost]# echo 2 > /sys/class/net/ens4f1/device/sriov_numvfs

- unsuccessful attempt to change eswitch mode while VFs are created
[root@localhost]# devlink dev eswitch set pci/0000:03:00.1 mode legacy
devlink answers: Operation not supported

- destroy VFs
[root@localhost]# echo 0 > /sys/class/net/ens4f1/device/sriov_numvfs

- restore 'legacy' mode
[root@localhost]# devlink dev eswitch set pci/0000:03:00.1 mode legacy
[root@localhost]# devlink dev eswitch show pci/0000:03:00.1
pci/0000:03:00.1: mode legacy

Co-developed-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/Kconfig           | 14 +++++
 drivers/net/ethernet/intel/ice/Makefile      |  1 +
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c |  3 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 62 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_eswitch.h | 35 +++++++++++
 6 files changed, 116 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch.h

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index ed8ea63bb172..0b274d8fa45b 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -313,6 +313,20 @@ config ICE
 	  To compile this driver as a module, choose M here. The module
 	  will be called ice.
 
+config ICE_SWITCHDEV
+	bool "Switchdev Support"
+	default y
+	depends on ICE && NET_SWITCHDEV
+	help
+	  Switchdev support provides internal SRIOV packet steering and switching.
+
+	  To enable it on running kernel use devlink tool:
+	  #devlink dev eswitch set pci/0000:XX:XX.X mode switchdev
+
+	  Say Y here if you want to use Switchdev in the driver.
+
+	  If unsure, say N.
+
 config FM10K
 	tristate "Intel(R) FM10000 Ethernet Switch Host Interface Support"
 	default n
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 4f538cdf42c1..0545594c80ba 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -33,3 +33,4 @@ ice-$(CONFIG_PTP_1588_CLOCK) += ice_ptp.o ice_ptp_hw.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
+ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 83413772b00c..1657f0cf10b1 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -439,6 +439,7 @@ struct ice_pf {
 
 	struct ice_vsi **vsi;		/* VSIs created by the driver */
 	struct ice_sw *first_sw;	/* first switch created by firmware */
+	u16 eswitch_mode;		/* current mode of eswitch */
 	/* Virtchnl/SR-IOV config info */
 	struct ice_vf *vf;
 	u16 num_alloc_vfs;		/* actual number of VFs allocated */
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index cae1cd97a1ef..69c9c165f987 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -4,6 +4,7 @@
 #include "ice.h"
 #include "ice_lib.h"
 #include "ice_devlink.h"
+#include "ice_eswitch.h"
 #include "ice_fw_update.h"
 
 /* context for devlink info version reporting */
@@ -423,6 +424,8 @@ ice_devlink_flash_update(struct devlink *devlink,
 
 static const struct devlink_ops ice_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
+	.eswitch_mode_get = ice_eswitch_mode_get,
+	.eswitch_mode_set = ice_eswitch_mode_set,
 	.info_get = ice_devlink_info_get,
 	.flash_update = ice_devlink_flash_update,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
new file mode 100644
index 000000000000..1370c41b77ab
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2019-2021, Intel Corporation. */
+
+#include "ice.h"
+#include "ice_eswitch.h"
+#include "ice_devlink.h"
+
+/**
+ * ice_eswitch_mode_set - set new eswitch mode
+ * @devlink: pointer to devlink structure
+ * @mode: eswitch mode to switch to
+ * @extack: pointer to extack structure
+ */
+int
+ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
+		     struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+
+	if (pf->eswitch_mode == mode)
+		return 0;
+
+	if (pf->num_alloc_vfs) {
+		dev_info(ice_pf_to_dev(pf), "Changing eswitch mode is allowed only if there is no VFs created");
+		NL_SET_ERR_MSG_MOD(extack, "Changing eswitch mode is allowed only if there is no VFs created");
+		return -EOPNOTSUPP;
+	}
+
+	switch (mode) {
+	case DEVLINK_ESWITCH_MODE_LEGACY:
+		dev_info(ice_pf_to_dev(pf), "PF %d changed eswitch mode to legacy",
+			 pf->hw.pf_id);
+		NL_SET_ERR_MSG_MOD(extack, "Changed eswitch mode to legacy");
+		break;
+	case DEVLINK_ESWITCH_MODE_SWITCHDEV:
+	{
+		dev_info(ice_pf_to_dev(pf), "PF %d changed eswitch mode to switchdev",
+			 pf->hw.pf_id);
+		NL_SET_ERR_MSG_MOD(extack, "Changed eswitch mode to switchdev");
+		break;
+	}
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unknown eswitch mode");
+		return -EINVAL;
+	}
+
+	pf->eswitch_mode = mode;
+	return 0;
+}
+
+/**
+ * ice_eswitch_mode_get - get current eswitch mode
+ * @devlink: pointer to devlink structure
+ * @mode: output parameter for current eswitch mode
+ */
+int ice_eswitch_mode_get(struct devlink *devlink, u16 *mode)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+
+	*mode = pf->eswitch_mode;
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.h b/drivers/net/ethernet/intel/ice/ice_eswitch.h
new file mode 100644
index 000000000000..1964b060562a
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2019-2021, Intel Corporation. */
+
+#ifndef _ICE_ESWITCH_H_
+#define _ICE_ESWITCH_H_
+
+#include <net/devlink.h>
+
+#ifdef CONFIG_ICE_SWITCHDEV
+int ice_eswitch_mode_get(struct devlink *devlink, u16 *mode);
+int
+ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
+		     struct netlink_ext_ack *extack);
+bool ice_is_eswitch_mode_switchdev(struct ice_pf *pf);
+#else /* CONFIG_ICE_SWITCHDEV */
+static inline int
+ice_eswitch_mode_get(struct devlink *devlink, u16 *mode)
+{
+	return DEVLINK_ESWITCH_MODE_LEGACY;
+}
+
+static inline int
+ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
+		     struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline bool
+ice_is_eswitch_mode_switchdev(struct ice_pf *pf)
+{
+	return false;
+}
+#endif /* CONFIG_ICE_SWITCHDEV */
+#endif /* _ICE_ESWITCH_H_ */
-- 
2.31.1

