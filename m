Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA171B1B5E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDUBtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 21:49:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:47086 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgDUBti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 21:49:38 -0400
IronPort-SDR: cqdN9qJQU6zu1opZ5RqsnDiuMFi02ntsyjUsNa59MQTZnGMN6E6EHeJhAVlNd8BLTs+g+FtyYX
 yieh0k0uV5jg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 18:49:35 -0700
IronPort-SDR: I040Ap4qDcHLtvWvbfJCZtiC1ef7wpyd56x3moOJ9o+GVeI8MXNanONBKoVmfreQIKxKD8OC9L
 zNH+6Abls2cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="291449667"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008.jf.intel.com with ESMTP; 20 Apr 2020 18:49:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Todd Fujinaka <todd.fujinaka@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/4] i40e: Add a check to see if MFS is set
Date:   Mon, 20 Apr 2020 18:49:32 -0700
Message-Id: <20200421014932.2743607-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
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
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4c414208a22a..3fdbfede0b87 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15347,6 +15347,15 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			i40e_stat_str(&pf->hw, err),
 			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
 
+	/* make sure the MFS hasn't been set lower than the default */
+#define MAX_FRAME_SIZE_DEFAULT 0x2600
+	for (i = 0; i < 4; i++) {
+		val = ((rd32(&pf->hw, I40E_PRTGL_SAH) & I40E_PRTGL_SAH_MFS_MASK)
+			>> I40E_PRTGL_SAH_MFS_SHIFT);
+		if (val < MAX_FRAME_SIZE_DEFAULT)
+			dev_warn(&pdev->dev, "MFS for port %x has been set below the default: %x\n", i, val);
+	}
+
 	/* Add a filter to drop all Flow control frames from any VSI from being
 	 * transmitted. By doing so we stop a malicious VF from sending out
 	 * PAUSE or PFC frames and potentially controlling traffic for other
-- 
2.25.3

