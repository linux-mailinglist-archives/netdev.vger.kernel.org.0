Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA10CAEFA9
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436859AbfIJQer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:34:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:21112 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436821AbfIJQel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 12:34:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 09:34:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="184223786"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 10 Sep 2019 09:34:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Colin Ian King <colin.king@canonical.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/14] net/ixgbevf: make array api static const, makes object smaller
Date:   Tue, 10 Sep 2019 09:34:33 -0700
Message-Id: <20190910163434.2449-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
References: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array API on the stack but instead make it
static const. Makes the object code smaller by 58 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  82969	   9763	    256	  92988	  16b3c	ixgbevf/ixgbevf_main.o

After:
   text	   data	    bss	    dec	    hex	filename
  82815	   9859	    256	  92930	  16b02	ixgbevf/ixgbevf_main.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 75e849a64db7..75e93ce2ed99 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2261,12 +2261,14 @@ static void ixgbevf_init_last_counter_stats(struct ixgbevf_adapter *adapter)
 static void ixgbevf_negotiate_api(struct ixgbevf_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
-	int api[] = { ixgbe_mbox_api_14,
-		      ixgbe_mbox_api_13,
-		      ixgbe_mbox_api_12,
-		      ixgbe_mbox_api_11,
-		      ixgbe_mbox_api_10,
-		      ixgbe_mbox_api_unknown };
+	static const int api[] = {
+		ixgbe_mbox_api_14,
+		ixgbe_mbox_api_13,
+		ixgbe_mbox_api_12,
+		ixgbe_mbox_api_11,
+		ixgbe_mbox_api_10,
+		ixgbe_mbox_api_unknown
+	};
 	int err, idx = 0;
 
 	spin_lock_bh(&adapter->mbx_lock);
-- 
2.21.0

