Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908EC31F308
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 00:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhBRX0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 18:26:10 -0500
Received: from mga12.intel.com ([192.55.52.136]:20118 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhBRXZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 18:25:49 -0500
IronPort-SDR: 4O7ZP0PMa6hm+X4zynVBdYmmVQxpZUDhR9u1vfzFTmBfAeeNQgh8azyg2DDA2oCK2lM4L/KXB7
 M0aA0xUnPUxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9899"; a="162823073"
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="162823073"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 15:24:08 -0800
IronPort-SDR: ZvDg/hXzDJVNFo12BcEZ8sb1ZCRYupIkjrc2KMOM9Ny8YR+xRAOBkQvDSUneEhq70NrhCAQiiw
 +ke3/NgG/brQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="581457646"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 18 Feb 2021 15:24:08 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 6/8] i40e: Fix VFs not created
Date:   Thu, 18 Feb 2021 15:25:02 -0800
Message-Id: <20210218232504.2422834-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
References: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

When creating VFs they were sometimes not getting resources.
It was caused by not executing i40e_reset_all_vfs due to
flag __I40E_VF_DISABLE being set on PF. Because of this
IAVF was never able to finish setup sequence never
getting reset indication from PF.
Changed test_and_set_bit __I40E_VF_DISABLE in
i40e_sync_filters_subtask to test_bit and removed clear_bit.
This function should not set this bit it should only check
if it hasn't been already set.

Fixes: a7542b876075 ("i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3505d641660b..2e22ab5a0f9a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2616,7 +2616,7 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 		return;
 	if (!test_and_clear_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state))
 		return;
-	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state)) {
+	if (test_bit(__I40E_VF_DISABLE, pf->state)) {
 		set_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state);
 		return;
 	}
@@ -2634,7 +2634,6 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 			}
 		}
 	}
-	clear_bit(__I40E_VF_DISABLE, pf->state);
 }
 
 /**
-- 
2.26.2

