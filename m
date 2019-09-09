Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42FEDAE12F
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389827AbfIIWsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:48:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:40892 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389358AbfIIWsL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 18:48:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 15:48:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,487,1559545200"; 
   d="scan'208";a="175121741"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 09 Sep 2019 15:48:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 11/15] i40e: Implement debug macro hw_dbg using dev_dbg
Date:   Mon,  9 Sep 2019 15:47:58 -0700
Message-Id: <20190909224802.29595-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190909224802.29595-1-jeffrey.t.kirsher@intel.com>
References: <20190909224802.29595-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>

There are several uses of hw_dbg in the code, producing no output. This
patch implements it using dev_debug.

Initially the intention was to implement it using netdev_dbg, analogously
to what is done in ixgbe for instance. That approach was avoided due to
some early usages of hw_dbg, like i40e_pf_reset, before the VSI structure
initialization causing NULL pointer dereference during the driver probe if
the debug messages were turned on as soon as the module is probed.

v2:
 - Use dev_dbg instead of pr_debug, and take advantage of dev_name
instead of crafting pretty much the same device name locally as suggested
by Jakub Kicinski.

Signed-off-by: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    | 1 +
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

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
index a07574bff550..c302ef2524f8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
@@ -18,7 +18,10 @@
  * actual OS primitives
  */
 
-#define hw_dbg(hw, S, A...)	do {} while (0)
+#define hw_dbg(hw, S, A...)							\
+do {										\
+	dev_dbg(&((struct i40e_pf *)hw->back)->pdev->dev, S, ##A);		\
+} while (0)
 
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
-- 
2.21.0

