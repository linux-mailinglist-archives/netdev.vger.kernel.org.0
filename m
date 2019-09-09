Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9672AE134
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390026AbfIIWsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:48:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:40893 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389337AbfIIWsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 18:48:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 15:48:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,487,1559545200"; 
   d="scan'208";a="175121743"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 09 Sep 2019 15:48:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 12/15] i40e: Remove EMPR traces from debugfs facility
Date:   Mon,  9 Sep 2019 15:47:59 -0700
Message-Id: <20190909224802.29595-13-jeffrey.t.kirsher@intel.com>
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

Since commit
'5098850c9b9b ("i40e/i40evf: i40e_register.h updates")'
it is no longer possible to trigger an EMP Reset from debugfs, but it's
possible to request it either way, to end up with a bad reset request:

echo empr > /sys/kernel/debug/i40e/0002\:01\:00.1/command
i40e 0002:01:00.1: debugfs: forcing EMPR
i40e 0002:01:00.1: bad reset request 0x00010000

So let's remove this piece of code and show the available valid commands
as it is when any invalid command is issued.

Signed-off-by: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         | 1 -
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 3e535d3263b3..f1a1bd324b50 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -131,7 +131,6 @@ enum i40e_state_t {
 	__I40E_PF_RESET_REQUESTED,
 	__I40E_CORE_RESET_REQUESTED,
 	__I40E_GLOBAL_RESET_REQUESTED,
-	__I40E_EMP_RESET_REQUESTED,
 	__I40E_EMP_RESET_INTR_RECEIVED,
 	__I40E_SUSPENDED,
 	__I40E_PTP_TX_IN_PROGRESS,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 41232898d8ae..99ea543dd245 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -1125,10 +1125,6 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 		dev_info(&pf->pdev->dev, "debugfs: forcing GlobR\n");
 		i40e_do_reset_safe(pf, BIT(__I40E_GLOBAL_RESET_REQUESTED));
 
-	} else if (strncmp(cmd_buf, "empr", 4) == 0) {
-		dev_info(&pf->pdev->dev, "debugfs: forcing EMPR\n");
-		i40e_do_reset_safe(pf, BIT(__I40E_EMP_RESET_REQUESTED));
-
 	} else if (strncmp(cmd_buf, "read", 4) == 0) {
 		u32 address;
 		u32 value;
-- 
2.21.0

