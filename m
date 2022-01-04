Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D41E484AD7
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiADWjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:39:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:28286 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235681AbiADWjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 17:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641335963; x=1672871963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vZ6ExC56UfKZQrlQo9qrpDtO57sE7ALL5to7k6p0iMc=;
  b=YgSju2SMsGMgo9+50NSrUBA+1346iN6FzGlLXOXHdPOOCY0J3Zcy+SRQ
   GhLTw+tMRuEch6+DQVy+gWuXKjSNySf5EbL/ZD5NDhm0SlzblXUpa9iev
   rmHr9Ci4arwDPuVJE1yVRSEFDoep3wErxBHhhcFX5Mpgu6gbaTFkkhVFx
   radFun23T4rKoTJ41mIVy/jTw3QDH9UFmUOkIpEyAw+dHd/jHx6freKva
   ooOL1KhI3dqSrI5qE/Z67GEJ+pezB5hEWwjihVTW0Lyw+3xpP/HrtaZzB
   Y5I/qnQu0yZbRWs1aL/L3aOmnXEDOB+Ey5+y1gMLhgtbuPtKnozSfsuqg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222305234"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="222305234"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 14:39:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="470312803"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2022 14:39:21 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 3/5] i40e: Fix for displaying message regarding NVM version
Date:   Tue,  4 Jan 2022 14:38:40 -0800
Message-Id: <20220104223842.2325297-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
References: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

When loading the i40e driver, it prints a message like: 'The driver for the
device detected a newer version of the NVM image v1.x than expected v1.y.
Please install the most recent version of the network driver.' This is
misleading as the driver is working as expected.

Fix that by removing the second part of message and changing it from
dev_info to dev_dbg.

Fixes: 4fb29bddb57f ("i40e: The driver now prints the API version in error message")
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e0c4d6113c02..17c3f6d69740 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15475,8 +15475,8 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (hw->aq.api_maj_ver == I40E_FW_API_VERSION_MAJOR &&
 	    hw->aq.api_min_ver > I40E_FW_MINOR_VERSION(hw))
-		dev_info(&pdev->dev,
-			 "The driver for the device detected a newer version of the NVM image v%u.%u than expected v%u.%u. Please install the most recent version of the network driver.\n",
+		dev_dbg(&pdev->dev,
+			"The driver for the device detected a newer version of the NVM image v%u.%u than v%u.%u.\n",
 			 hw->aq.api_maj_ver,
 			 hw->aq.api_min_ver,
 			 I40E_FW_API_VERSION_MAJOR,
-- 
2.31.1

