Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12DA99FABE
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfH1GoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:44:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:35209 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfH1GoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:44:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 23:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="171443813"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 23:44:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] i40e: Implement debug macro hw_dbg using pr_debug
Date:   Tue, 27 Aug 2019 23:44:03 -0700
Message-Id: <20190828064407.30168-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>

There are several uses of hw_dbg in the code, producing no output. This
patch implements it using pr_debug.

Initially the intention was to implement it using netdev_dbg, analogously
to what is done in ixgbe for instance. That approach was avoided due to
some early usages of hw_dbg, like i40e_pf_reset, before the VSI structure
initialization causing NULL pointer dereference during the driver probe if
the dbg messages were turned on as soon as the module is probed.

Signed-off-by: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    | 1 +
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  | 7 ++++++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 46e649c09f72..d37c6e0e5f08 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include "i40e.h"
 #include "i40e_type.h"
 #include "i40e_adminq.h"
 #include "i40e_prototype.h"
diff --git a/drivers/net/ethernet/intel/i40e/i40e_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
index 19ce93d7fd0a..163ee8c6311c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include "i40e.h"
 #include "i40e_osdep.h"
 #include "i40e_register.h"
 #include "i40e_status.h"
diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
index a07574bff550..c0c9ce3eab23 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
@@ -18,7 +18,12 @@
  * actual OS primitives
  */
 
-#define hw_dbg(hw, S, A...)	do {} while (0)
+#define hw_dbg(hw, S, A...)							\
+do {										\
+	int domain = pci_domain_nr(((struct i40e_pf *)(hw)->back)->pdev->bus);	\
+	pr_debug("i40e %04x:%02x:%02x.%x " S, domain, (hw)->bus.bus_id,		\
+		 (hw)->bus.device, (hw)->bus.func, ## A);			\
+} while (0)
 
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
-- 
2.21.0

