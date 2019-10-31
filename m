Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF04FEB99A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbfJaWR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:17:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:61777 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387435AbfJaWRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 18:17:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 15:17:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="199662508"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 Oct 2019 15:17:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net 4/7] i40e: Fix receive buffer starvation for AF_XDP
Date:   Thu, 31 Oct 2019 15:17:16 -0700
Message-Id: <20191031221719.14028-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
References: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus's fix to resolve a potential receive buffer starvation for AF_XDP
got applied to both the i40e_xsk_umem_enable/disable() functions, when it
should have only been applied to the "enable".  So clean up the undesired
code in the disable function.

CC: Magnus Karlsson <magnus.karlsson@intel.com>
Fixes: 1f459bdc2007 ("i40e: fix potential RX buffer starvation for AF_XDP")
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index b1c3227ae4ab..a05dfecdd9b4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -157,11 +157,6 @@ static int i40e_xsk_umem_disable(struct i40e_vsi *vsi, u16 qid)
 		err = i40e_queue_pair_enable(vsi, qid);
 		if (err)
 			return err;
-
-		/* Kick start the NAPI context so that receiving will start */
-		err = i40e_xsk_wakeup(vsi->netdev, qid, XDP_WAKEUP_RX);
-		if (err)
-			return err;
 	}
 
 	return 0;
-- 
2.21.0

