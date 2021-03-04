Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0364E32C9C5
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244938AbhCDBMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:44723 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381692AbhCDBFy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:05:54 -0500
IronPort-SDR: tvXJh2VxUUY8LMN7r7CdvVUAyNnDEWMyx2Xd3gDClY3E38BnZ16vzsc/DzDt+1w2+9vCXKQ5VS
 dKFTbEpWtEGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="183934476"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="183934476"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 17:05:38 -0800
IronPort-SDR: 5imPCnHDlyF923ZVdrEXkAHXJ8u3/3QZsW4tQxt0seKJ4IX8mcqsxsbsdJETnFcuzvn9ZQDj8b
 xZycyW2Omv7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="367809984"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2021 17:05:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 3/3] ixgbe: Fix memleak in ixgbe_configure_clsu32
Date:   Wed,  3 Mar 2021 17:06:49 -0800
Message-Id: <20210304010649.1858916-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
References: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

When ixgbe_fdir_write_perfect_filter_82599() fails,
input allocated by kzalloc() has not been freed,
which leads to memleak.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index aa3b0a7ab786..ae1837331a8f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9565,8 +9565,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
 	ixgbe_atr_compute_perfect_hash_82599(&input->filter, mask);
 	err = ixgbe_fdir_write_perfect_filter_82599(hw, &input->filter,
 						    input->sw_idx, queue);
-	if (!err)
-		ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
+	if (err)
+		goto err_out_w_lock;
+
+	ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
 	spin_unlock(&adapter->fdir_perfect_lock);
 
 	if ((uhtid != 0x800) && (adapter->jump_tables[uhtid]))
-- 
2.26.2

