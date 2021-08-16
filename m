Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF8C3EDAB4
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhHPQSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:18:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:27628 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhHPQSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 12:18:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="203046315"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="203046315"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 09:17:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="487524191"
Received: from amlin-018-053.igk.intel.com ([10.102.18.53])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2021 09:17:46 -0700
From:   Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        shuah@kernel.org, arkadiusz.kubalewski@intel.com, arnd@arndb.de,
        nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: [RFC net-next 4/7] net: add ioctl interface for recover reference clock on netdev
Date:   Mon, 16 Aug 2021 18:07:14 +0200
Message-Id: <20210816160717.31285-5-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously there was no similar interface. It is required for
configuration of Synchronous Ethernet (SyncE).

User must be able to enable or disable propagation of its
PHY recovered clock signal onto available output pin.
This allows the signal to be used as frequency reference signal
for different hardware chips.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 include/uapi/linux/net_synce.h | 21 +++++++++++++++++++++
 include/uapi/linux/sockios.h   |  4 ++++
 net/core/dev_ioctl.c           |  6 +++++-
 3 files changed, 30 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/net_synce.h

diff --git a/include/uapi/linux/net_synce.h b/include/uapi/linux/net_synce.h
new file mode 100644
index 000000000000..a482a7e43151
--- /dev/null
+++ b/include/uapi/linux/net_synce.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Userspace API for synchronous ethernet configuration
+ *
+ * Copyright (C) 2021 Intel Corporation
+ * Author: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
+ *
+ */
+#ifndef _NET_SYNCE_H
+#define _NET_SYNCE_H
+#include <linux/types.h>
+
+/*
+ * Structure used for passing data with SIOCSSYNCE and SIOCGSYNCE ioctls
+ */
+struct synce_ref_clk_cfg {
+	__u8 pin_id;
+	_Bool enable;
+};
+
+#endif /* _NET_SYNCE_H */
diff --git a/include/uapi/linux/sockios.h b/include/uapi/linux/sockios.h
index 7d1bccbbef78..32c7d4909c31 100644
--- a/include/uapi/linux/sockios.h
+++ b/include/uapi/linux/sockios.h
@@ -153,6 +153,10 @@
 #define SIOCSHWTSTAMP	0x89b0		/* set and get config		*/
 #define SIOCGHWTSTAMP	0x89b1		/* get config			*/
 
+/* synchronous ethernet config per physical function */
+#define SIOCSSYNCE	0x89c0		/* set and get config           */
+#define SIOCGSYNCE	0x89c1		/* get config                   */
+
 /* Device private ioctl calls */
 
 /*
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 0e87237fd871..fe21365c9492 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -406,7 +406,9 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		    cmd == SIOCGMIIREG ||
 		    cmd == SIOCSMIIREG ||
 		    cmd == SIOCSHWTSTAMP ||
-		    cmd == SIOCGHWTSTAMP) {
+		    cmd == SIOCGHWTSTAMP ||
+		    cmd == SIOCSSYNCE ||
+		    cmd == SIOCGSYNCE) {
 			err = dev_eth_ioctl(dev, ifr, cmd);
 		} else if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
@@ -577,6 +579,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 	case SIOCBRADDIF:
 	case SIOCBRDELIF:
 	case SIOCSHWTSTAMP:
+	case SIOCSSYNCE:
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		fallthrough;
@@ -605,6 +608,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 	default:
 		if (cmd == SIOCWANDEV ||
 		    cmd == SIOCGHWTSTAMP ||
+		    cmd == SIOCGSYNCE ||
 		    (cmd >= SIOCDEVPRIVATE &&
 		     cmd <= SIOCDEVPRIVATE + 15)) {
 			dev_load(net, ifr->ifr_name);
-- 
2.24.0

