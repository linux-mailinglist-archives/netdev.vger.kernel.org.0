Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCA3451BD1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353732AbhKPAHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:07:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:18656 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353146AbhKPAFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:05:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220768899"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220768899"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163116"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nicholas Nunley <nicholas.d.nunley@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 04/10] iavf: don't clear a lock we don't hold
Date:   Mon, 15 Nov 2021 15:59:28 -0800
Message-Id: <20211115235934.880882-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicholas Nunley <nicholas.d.nunley@intel.com>

In iavf_configure_clsflower() the function will bail out if it is unable
to obtain the crit_section lock in a reasonable time. However, it will
clear the lock when exiting, so fix this.

Fixes: 640a8af5841f ("i40evf: Reorder configure_clsflower to avoid deadlock on error")
Signed-off-by: Nicholas Nunley <nicholas.d.nunley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index c23fff5a4bd9..28661e4425f1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3095,8 +3095,10 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 		return -ENOMEM;
 
 	while (!mutex_trylock(&adapter->crit_lock)) {
-		if (--count == 0)
-			goto err;
+		if (--count == 0) {
+			kfree(filter);
+			return err;
+		}
 		udelay(1);
 	}
 
-- 
2.31.1

