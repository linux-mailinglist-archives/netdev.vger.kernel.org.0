Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAFF28664D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgJGRzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:55:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:18440 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbgJGRzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:55:00 -0400
IronPort-SDR: WXQUBEZF8MTIbVPwQwQNH/tBPAwx462ngsvkVVcc0hxfxZPAmzqnkmFaocjwxEB2bkU+he6owv
 qE41Ju4HVdKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="144957653"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="144957653"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
IronPort-SDR: zN9UA5sEFTImPk4Sz53uAlJGa8pxQgie3hOT+6OF+wNKLH/YQP8xmQ2I4coNchj+wQE4MRlZB3
 QssZ1PO9Jtmg==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="518935784"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 4/8] ice: add the DDP Track ID to devlink info
Date:   Wed,  7 Oct 2020 10:54:43 -0700
Message-Id: <20201007175447.647867-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Add "fw.app.bundle_id" to display the DDP Track ID of the active DDP
package. This id is similar to "fw.bundle_id" and is a unique identifier
for the DDP package that is loaded in the device. Each new DDP has
a unique Track ID generated for it, and the ID can be used to identify
and track the DDP package.

Add documentation for the new devlink info version.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 Documentation/networking/devlink/ice.rst     | 5 +++++
 drivers/net/ethernet/intel/ice/ice_devlink.c | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 8eb50ba41f1a..b165181d5d4d 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -69,6 +69,11 @@ The ``ice`` driver reports the following versions
       - The version of the DDP package that is active in the device. Note
         that both the name (as reported by ``fw.app.name``) and version are
         required to uniquely identify the package.
+    * - ``fw.app.bundle_id``
+      - 0xc0000001
+      - Unique identifier for the DDP package loaded in the device. Also
+        referred to as the DDP Track ID. Can be used to uniquely identify
+        the specific DDP package.
     * - ``fw.netlist``
       - running
       - 1.1.2000-6.7.0
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index ed04bae36f00..c73afa67c048 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -102,6 +102,13 @@ static int ice_info_ddp_pkg_version(struct ice_pf *pf, char *buf, size_t len)
 	return 0;
 }
 
+static int ice_info_ddp_pkg_bundle_id(struct ice_pf *pf, char *buf, size_t len)
+{
+	snprintf(buf, len, "0x%08x", pf->hw.active_track_id);
+
+	return 0;
+}
+
 static int ice_info_netlist_ver(struct ice_pf *pf, char *buf, size_t len)
 {
 	struct ice_netlist_ver_info *netlist = &pf->hw.netlist_ver;
@@ -146,6 +153,7 @@ static const struct ice_devlink_version {
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, ice_info_eetrack),
 	running("fw.app.name", ice_info_ddp_pkg_name),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_APP, ice_info_ddp_pkg_version),
+	running("fw.app.bundle_id", ice_info_ddp_pkg_bundle_id),
 	running("fw.netlist", ice_info_netlist_ver),
 	running("fw.netlist.build", ice_info_netlist_build),
 };
-- 
2.26.2

