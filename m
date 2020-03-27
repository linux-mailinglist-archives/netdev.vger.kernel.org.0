Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89A2196036
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgC0VIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:08:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:49302 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbgC0VIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 17:08:38 -0400
IronPort-SDR: khvnxIj+GJVQdxZ9CC6oaxMwI86UKq0JCJS5TBjSzxl84qjgoavyU/G7vEMTDNBd87poUekFvU
 PZv93tMBHWqg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 14:08:37 -0700
IronPort-SDR: 8C9jr+/FDejCy8MspIEsQXydnT7ti2mjJiLR+MWxe8dwoVYeb0mh2JQ80am9QxYV8t5WJ39OdI
 twvp9DkegMBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="358599957"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 27 Mar 2020 14:08:36 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        tanhuazhong <tanhuazhong@huawei.com>
Subject: [PATCH net-next] mlx4: fix "initializer element not constant" compiler error
Date:   Fri, 27 Mar 2020 14:08:35 -0700
Message-Id: <20200327210835.2576135-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit e8937681797c ("devlink: prepare to support region
operations") used the region_cr_space_str and region_fw_health_str
variables as initializers for the devlink_region_ops structures.

This can result in compiler errors:
drivers/net/ethernet/mellanox//mlx4/crdump.c:45:10: error: initializer
element is not constant
   .name = region_cr_space_str,
           ^
drivers/net/ethernet/mellanox//mlx4/crdump.c:45:10: note: (near
initialization for ‘region_cr_space_ops.name’)
drivers/net/ethernet/mellanox//mlx4/crdump.c:50:10: error: initializer
element is not constant
   .name = region_fw_health_str,

The variables were made to be "const char * const", indicating that both
the pointer and data were constant. This was enough to resolve this on
recent GCC (gcc (GCC) 9.2.1 20190827 (Red Hat 9.2.1-1) for this author).

Unfortunately this is not enough for older compilers to realize that the
variable can be treated as a constant expression.

Fix this by introducing macros for the string and use those instead of
the variable name in the region ops structures.

Reported-by: tanhuazhong <tanhuazhong@huawei.com>
Fixes: e8937681797c ("devlink: prepare to support region operations")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 2700628f1689..73eae80e1cb7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -38,16 +38,19 @@
 #define CR_ENABLE_BIT_OFFSET		0xF3F04
 #define MAX_NUM_OF_DUMPS_TO_STORE	(8)
 
-static const char * const region_cr_space_str = "cr-space";
-static const char * const region_fw_health_str = "fw-health";
+#define REGION_CR_SPACE "cr-space"
+#define REGION_FW_HEALTH "fw-health"
+
+static const char * const region_cr_space_str = REGION_CR_SPACE;
+static const char * const region_fw_health_str = REGION_FW_HEALTH;
 
 static const struct devlink_region_ops region_cr_space_ops = {
-	.name = region_cr_space_str,
+	.name = REGION_CR_SPACE,
 	.destructor = &kvfree,
 };
 
 static const struct devlink_region_ops region_fw_health_ops = {
-	.name = region_fw_health_str,
+	.name = REGION_FW_HEALTH,
 	.destructor = &kvfree,
 };
 
-- 
2.24.1

