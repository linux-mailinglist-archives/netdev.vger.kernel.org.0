Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D7739E487
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhFGQxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:16640 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231415AbhFGQxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:53:05 -0400
IronPort-SDR: gjiH+xHnluAovy0MaPiBUsZnxgCMWBTZnjXBPjpRf+Qm/rT9i+7WxezxN+nssBa7f/jTYBM1FJ
 D9AjhcSu3lhQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="268516244"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="268516244"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:52 -0700
IronPort-SDR: Z7DUM3G5HUsJdr3X9ML8YF/LzWY/Dytkk9ReJcI11mRIyeX9XG6k1Yam11PBxZQqR/XPXcWaLi
 B9/+bWZvnITQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841217"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 01/15] virtchnl: Use pad byte in virtchnl_ether_addr to specify MAC type
Date:   Mon,  7 Jun 2021 09:53:11 -0700
Message-Id: <20210607165325.182087-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently, there is no way for a VF driver to specify that it wants to
change its device/primary unicast MAC address. This makes it
difficult/impossible for the PF driver to track the VF's device/primary
unicast MAC address, which is used for VM/VF reboot and displaying on
the host. Fix this by using 2 bits of a pad byte in the
virtchnl_ether_addr structure so the VF can specify what type of MAC
it's adding/deleting.

Below are the values that should be used by all VF drivers going
forward.

VIRTCHNL_ETHER_ADDR_LEGACY(0):
	- The type should only ever be 0 for legacy AVF drivers (i.e.
	  drivers that don't support the new type bits). The PF drivers
	  will track VF's device/primary unicast MAC, but this will only
	  be a best effort.

VIRTCHNL_ETHER_ADDR_PRIMARY(1):
	- This type should only be used when the VF is changing their
	  device/primary unicast MAC. It should be used for both delete
	  and add cases related to the device/primary unicast MAC.

VIRTCHNL_ETHER_ADDR_EXTRA(2):
	- This type should be used when the VF is adding and/or deleting
	  MAC addresses that are not the device/primary unicast MAC. For
	  example, extra unicast addresses and multicast addresses
	  assuming the PF supports "extra" addresses at all.

If a PF is parsing the type field of the virtchnl_ether_addr, then it
should use the VIRTCHNL_ETHER_ADDR_TYPE_MASK to mask the first two bits
of the type field since 0, 1, and 2 are the only valid values.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 565deea6ffe8..1fc07f3f99ab 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -412,9 +412,36 @@ VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_queue_select);
  * PF removes the filters and returns status.
  */
 
+/* VIRTCHNL_ETHER_ADDR_LEGACY
+ * Prior to adding the @type member to virtchnl_ether_addr, there were 2 pad
+ * bytes. Moving forward all VF drivers should not set type to
+ * VIRTCHNL_ETHER_ADDR_LEGACY. This is only here to not break previous/legacy
+ * behavior. The control plane function (i.e. PF) can use a best effort method
+ * of tracking the primary/device unicast in this case, but there is no
+ * guarantee and functionality depends on the implementation of the PF.
+ */
+
+/* VIRTCHNL_ETHER_ADDR_PRIMARY
+ * All VF drivers should set @type to VIRTCHNL_ETHER_ADDR_PRIMARY for the
+ * primary/device unicast MAC address filter for VIRTCHNL_OP_ADD_ETH_ADDR and
+ * VIRTCHNL_OP_DEL_ETH_ADDR. This allows for the underlying control plane
+ * function (i.e. PF) to accurately track and use this MAC address for
+ * displaying on the host and for VM/function reset.
+ */
+
+/* VIRTCHNL_ETHER_ADDR_EXTRA
+ * All VF drivers should set @type to VIRTCHNL_ETHER_ADDR_EXTRA for any extra
+ * unicast and/or multicast filters that are being added/deleted via
+ * VIRTCHNL_OP_DEL_ETH_ADDR/VIRTCHNL_OP_ADD_ETH_ADDR respectively.
+ */
 struct virtchnl_ether_addr {
 	u8 addr[ETH_ALEN];
-	u8 pad[2];
+	u8 type;
+#define VIRTCHNL_ETHER_ADDR_LEGACY	0
+#define VIRTCHNL_ETHER_ADDR_PRIMARY	1
+#define VIRTCHNL_ETHER_ADDR_EXTRA	2
+#define VIRTCHNL_ETHER_ADDR_TYPE_MASK	3 /* first two bits of type are valid */
+	u8 pad;
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(8, virtchnl_ether_addr);
-- 
2.26.2

