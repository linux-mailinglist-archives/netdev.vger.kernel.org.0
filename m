Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60256204371
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbgFVWSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:18:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:11465 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbgFVWSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:18:22 -0400
IronPort-SDR: mDtU5E8u7ntlkY4JnER08jK33tkISbj3gVEXDzkfCmWGCPTZDlkGBPAuBgHgL984gzpUqED1Us
 4iS3kvsDsYTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="161973201"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="161973201"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:18:21 -0700
IronPort-SDR: Lw1sO+Gy9h7Vk+xjSHy/E4Kb5pROKHQbDXRrQIvxhQuQg3sYJRNMpfvQEujyVNCLXWsiH0G0ZL
 U/50HpUzeorA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="311075815"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jun 2020 15:18:20 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Todd Fujinaka <todd.fujinaka@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 5/9] i40e: Add a check to see if MFS is set
Date:   Mon, 22 Jun 2020 15:18:13 -0700
Message-Id: <20200622221817.2287549-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Todd Fujinaka <todd.fujinaka@intel.com>

A customer was chain-booting to provision his systems and one of the
steps was setting MFS. MFS isn't cleared by normal warm reboots
(clearing requires a GLOBR) and there was no indication of why Jumbo
Frame receives were failing.

Add a warning if MFS is set to anything lower than the default.

Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 77a6be8ee112..2e454b0d71ee 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15295,6 +15295,14 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			i40e_stat_str(&pf->hw, err),
 			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
 
+	/* make sure the MFS hasn't been set lower than the default */
+#define MAX_FRAME_SIZE_DEFAULT 0x2600
+	val = (rd32(&pf->hw, I40E_PRTGL_SAH) &
+	       I40E_PRTGL_SAH_MFS_MASK) >> I40E_PRTGL_SAH_MFS_SHIFT;
+	if (val < MAX_FRAME_SIZE_DEFAULT)
+		dev_warn(&pdev->dev, "MFS for port %x has been set below the default: %x\n",
+			 i, val);
+
 	/* Add a filter to drop all Flow control frames from any VSI from being
 	 * transmitted. By doing so we stop a malicious VF from sending out
 	 * PAUSE or PFC frames and potentially controlling traffic for other
-- 
2.26.2

