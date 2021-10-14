Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A0342E11A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhJNSXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:23:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:62163 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233901AbhJNSXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 14:23:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="226531110"
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="226531110"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 11:21:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="717815822"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 14 Oct 2021 11:21:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, linux-rdma@vger.kernel.org,
        shiraz.saleem@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 4/4] ice: Print the api_patch as part of the fw.mgmt.api
Date:   Thu, 14 Oct 2021 11:19:53 -0700
Message-Id: <20211014181953.3538330-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
References: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when a user uses "devlink dev info", the fw.mgmt.api will be
the major.minor numbers as shown below:

devlink dev info pci/0000:3b:00.0
pci/0000:3b:00.0:
  driver ice
  serial_number 00-01-00-ff-ff-00-00-00
  versions:
      fixed:
        board.id K91258-000
      running:
        fw.mgmt 6.1.2
        fw.mgmt.api 1.7 <--- No patch number included
        fw.mgmt.build 0xd75e7d06
        fw.mgmt.srev 5
        fw.undi 1.2992.0
        fw.undi.srev 5
        fw.psid.api 3.10
        fw.bundle_id 0x800085cc
        fw.app.name ICE OS Default Package
        fw.app 1.3.27.0
        fw.app.bundle_id 0xc0000001
        fw.netlist 3.10.2000-3.1e.0
        fw.netlist.build 0x2a76e110
      stored:
        fw.mgmt.srev 5
        fw.undi 1.2992.0
        fw.undi.srev 5
        fw.psid.api 3.10
        fw.bundle_id 0x800085cc
        fw.netlist 3.10.2000-3.1e.0
        fw.netlist.build 0x2a76e110

There are many features in the driver that depend on the major, minor,
and patch version of the FW. Without the patch number in the output for
fw.mgmt.api debugging issues related to the FW API version is difficult.
Also, using major.minor.patch aligns with the existing firmware version
which uses a 3 digit value.

Fix this by making the fw.mgmt.api print the major.minor.patch
versions. Shown below is the result:

devlink dev info pci/0000:3b:00.0
pci/0000:3b:00.0:
  driver ice
  serial_number 00-01-00-ff-ff-00-00-00
  versions:
      fixed:
        board.id K91258-000
      running:
        fw.mgmt 6.1.2
        fw.mgmt.api 1.7.9 <--- patch number included
        fw.mgmt.build 0xd75e7d06
        fw.mgmt.srev 5
        fw.undi 1.2992.0
        fw.undi.srev 5
        fw.psid.api 3.10
        fw.bundle_id 0x800085cc
        fw.app.name ICE OS Default Package
        fw.app 1.3.27.0
        fw.app.bundle_id 0xc0000001
        fw.netlist 3.10.2000-3.1e.0
        fw.netlist.build 0x2a76e110
      stored:
        fw.mgmt.srev 5
        fw.undi 1.2992.0
        fw.undi.srev 5
        fw.psid.api 3.10
        fw.bundle_id 0x800085cc
        fw.netlist 3.10.2000-3.1e.0
        fw.netlist.build 0x2a76e110

Fixes: ff2e5c700e08 ("ice: add basic handler for devlink .info_get")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 Documentation/networking/devlink/ice.rst     | 9 +++++----
 drivers/net/ethernet/intel/ice/ice_devlink.c | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index a432dc419fa4..5d97cee9457b 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -30,10 +30,11 @@ The ``ice`` driver reports the following versions
         PHY, link, etc.
     * - ``fw.mgmt.api``
       - running
-      - 1.5
-      - 2-digit version number of the API exported over the AdminQ by the
-        management firmware. Used by the driver to identify what commands
-        are supported.
+      - 1.5.1
+      - 3-digit version number (major.minor.patch) of the API exported over
+        the AdminQ by the management firmware. Used by the driver to
+        identify what commands are supported. Historical versions of the
+        kernel only displayed a 2-digit version number (major.minor).
     * - ``fw.mgmt.build``
       - running
       - 0x305d955f
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 14afce82ef63..da7288bdc9a3 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -63,7 +63,8 @@ static int ice_info_fw_api(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u", hw->api_maj_ver, hw->api_min_ver);
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u", hw->api_maj_ver,
+		 hw->api_min_ver, hw->api_patch);
 
 	return 0;
 }
-- 
2.31.1

