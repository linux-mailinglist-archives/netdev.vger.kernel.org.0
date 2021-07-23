Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C371A3D3E29
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhGWQ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:26:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:18036 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGWQ0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:26:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="210027946"
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="210027946"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 10:07:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="502586216"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jul 2021 10:07:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Subject: [PATCH net 2/5] i40e: Fix firmware LLDP agent related warning
Date:   Fri, 23 Jul 2021 10:10:20 -0700
Message-Id: <20210723171023.296927-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
References: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Make warning meaningful for the user.

Previously the trace:
"Starting FW LLDP agent failed: error: I40E_ERR_ADMIN_QUEUE_ERROR, I40E_AQ_RC_EAGAIN"
was produced when user tried to start Firmware LLDP agent,
just after it was stopped with sequence:
ethtool --set-priv-flags <dev> disable-fw-lldp on
ethtool --set-priv-flags <dev> disable-fw-lldp off
(without any delay between the commands)
At that point the firmware is still processing stop command, the behavior
is expected.

Fixes: c1041d070437 ("i40e: Missing response checks in driver when starting/stopping FW LLDP")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 3e822bad4851..d9e26f9713a5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5294,6 +5294,10 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 					dev_warn(&pf->pdev->dev,
 						 "Device configuration forbids SW from starting the LLDP agent.\n");
 					return -EINVAL;
+				case I40E_AQ_RC_EAGAIN:
+					dev_warn(&pf->pdev->dev,
+						 "Stop FW LLDP agent command is still being processed, please try again in a second.\n");
+					return -EBUSY;
 				default:
 					dev_warn(&pf->pdev->dev,
 						 "Starting FW LLDP agent failed: error: %s, %s\n",
-- 
2.26.2

