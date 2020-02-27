Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C08172B7B
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgB0Wgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:36:43 -0500
Received: from mga18.intel.com ([134.134.136.126]:49955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbgB0Wgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 17:36:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 14:36:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="238568399"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 27 Feb 2020 14:36:41 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        ND Linux CI Server <nd.linux.ci.server@intel.com>,
        Allan@vger.kernel.org, Bruce W <bruce.w.allan@intel.com>
Subject: [PATCH] ice-shared: add macro specifying max NVM offset
Date:   Thu, 27 Feb 2020 14:36:30 -0800
Message-Id: <20200227223635.1021197-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200227223635.1021197-1-jacob.e.keller@intel.com>
References: <20200227223635.1021197-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ice_aq_read_nvm function uses a somewhat weird construction for
verifying that the incoming offset is valid. Replace this construction
with a simple greater-than expression, and define the maximum value
(24bits) in the ice_adminq_cmd.h

By providing a macro, the check becomes more clear. Additionally the
maximum offset can be used in other locations.

Change-Id: I50993e53aca7c073d6906f48f8c9a6ecc05248d4
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Title: ice-shared: add macro specifying max NVM offset
Change-type: ImplementationChange
Reviewed-on: https://git-amr-3.devtools.intel.com/gerrit/250507
Tested-by: ND Linux CI Server <nd.linux.ci.server@intel.com>
Reviewed-by: Allan, Bruce W <bruce.w.allan@intel.com>
---
 ice_adminq_cmd.h | 1 +
 ice_nvm.c        | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ice_adminq_cmd.h b/ice_adminq_cmd.h
index 38134e9dab11..fbbe676d1f7d 100644
--- a/ice_adminq_cmd.h
+++ b/ice_adminq_cmd.h
@@ -2778,6 +2778,7 @@ ICE_CHECK_PARAM_LEN(ice_aqc_sff_eeprom);
  * NVM Shadow RAM Dump commands (direct 0x0707)
  */
 struct ice_aqc_nvm {
+#define ICE_AQC_NVM_MAX_OFFSET		0xFFFFFF
 	__le16 offset_low;
 	u8 offset_high;
 #ifdef PREBOOT_SUPPORT
diff --git a/ice_nvm.c b/ice_nvm.c
index b075a05eb38f..0e6d8390deb8 100644
--- a/ice_nvm.c
+++ b/ice_nvm.c
@@ -35,8 +35,7 @@ ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
 
 	cmd = &desc.params.nvm;
 
-	/* In offset the highest byte must be zeroed. */
-	if (offset & 0xFF000000)
+	if (offset > ICE_AQC_NVM_MAX_OFFSET)
 		return ICE_ERR_PARAM;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_read);
-- 
2.25.0.368.g28a2d05eebfb

