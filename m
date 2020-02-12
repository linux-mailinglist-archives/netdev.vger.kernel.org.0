Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B53115B2C6
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgBLVeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:34:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:42952 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbgBLVeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:34:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 13:34:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="233911692"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga003.jf.intel.com with ESMTP; 12 Feb 2020 13:34:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 06/15] ice: Remove CONFIG_PCI_IOV wrap in ice_set_pf_caps
Date:   Wed, 12 Feb 2020 13:33:48 -0800
Message-Id: <20200212213357.2198911-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
References: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Remove unnecessary CONFIG_PCI_IOV wrapping in ice_set_pf_caps. None
of the data structures accessed within the block are wrapped with
this flag. When CONFIG_PCI_IOV is undefined, pf->num_vfs_supported
will be 0 anyway.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4075d5379b23..32fd3dc3c7c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2665,14 +2665,12 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 	if (func_caps->common_cap.dcb)
 		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
-#ifdef CONFIG_PCI_IOV
 	clear_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
 	if (func_caps->common_cap.sr_iov_1_1) {
 		set_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
 		pf->num_vfs_supported = min_t(int, func_caps->num_allocd_vfs,
 					      ICE_MAX_VF_COUNT);
 	}
-#endif /* CONFIG_PCI_IOV */
 	clear_bit(ICE_FLAG_RSS_ENA, pf->flags);
 	if (func_caps->common_cap.rss_table_size)
 		set_bit(ICE_FLAG_RSS_ENA, pf->flags);
-- 
2.24.1

