Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1BC32005C
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 22:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhBSVgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 16:36:33 -0500
Received: from mga07.intel.com ([134.134.136.100]:25186 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhBSVg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 16:36:27 -0500
IronPort-SDR: /jOO6iyj5lzeqvZBC1BndD9UVPoriFnTp3FKEJUmYaggqFd33Duxs//bE8Mx/4s3flx1NJZUNu
 i5Vmb8W27KAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="248034137"
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="248034137"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 13:35:07 -0800
IronPort-SDR: GhyXLqyFZGVxyrC6cmIoHvToqHQ1AV0P+1jFaVd81eUB7rMunVYIpldfY2j9xd/Jd0Q3kZs/Tx
 eQy1DuxfD8eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="428012036"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Feb 2021 13:35:06 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net v2 6/8] i40e: Fix VFs not created
Date:   Fri, 19 Feb 2021 13:36:04 -0800
Message-Id: <20210219213606.2567536-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
References: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
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

