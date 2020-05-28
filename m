Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988981E588E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgE1H0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:26:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:14682 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgE1HZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:43 -0400
IronPort-SDR: wEU4s4AnMyZhyuRX5ewBuHhhWHast6WCSk9jN/iBShF3Gv3Bf07+cX6BMP9b7DuC+wVc4Wv6DN
 7Pih6/2STCBQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:43 -0700
IronPort-SDR: EFSwT7iCjiOawqxhPs4v0NJIFkqHh3uRLNLR68rHp3ZEyz4Usi5a/M4jSUvU/KTQ9sjv++UnnA
 P9yU5ZD4oYJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831126"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:42 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: Don't allow VLAN stripping change when pvid set
Date:   Thu, 28 May 2020 00:25:31 -0700
Message-Id: <20200528072538.1621790-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently, if the PVID is set in the VLAN handling section of the VSI
context the driver still allows VLAN stripping to be enabled/disabled.
VLAN stripping should only be modifiable when the PVID is not set. Fix
this by preventing VLAN stripping modification when PVID is set.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f81bd4c30bbc..89962c14e31f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1812,6 +1812,12 @@ int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 	enum ice_status status;
 	int ret = 0;
 
+	/* do not allow modifying VLAN stripping when a port VLAN is configured
+	 * on this VSI
+	 */
+	if (vsi->info.pvid)
+		return 0;
+
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
 	if (!ctxt)
 		return -ENOMEM;
-- 
2.26.2

