Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790F730E8CC
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhBDApa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:45:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:40083 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234542AbhBDApH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:45:07 -0500
IronPort-SDR: 355zVrd135Zh7AGknIoE8XRI3JDNza/ICpDMu3dkkhJCtWDONOC2gWXqc53+U9uzuCz8DmjSs6
 rme7YM4E/Sng==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638236"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638236"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:14 -0800
IronPort-SDR: 2gaFeZ36vMF1Ecub6eoLv7BWa3tGN9G1ozV6Sv6d+eg4zTzJ3aMd+Y/XA2xK/2jtTCvoZBJJyP
 hwIzJ2eoGG+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687515"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nick Lowe <nick.lowe@gmail.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        David Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 12/15] igb: Enable RSS for Intel I211 Ethernet Controller
Date:   Wed,  3 Feb 2021 16:42:56 -0800
Message-Id: <20210204004259.3662059-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Lowe <nick.lowe@gmail.com>

The Intel I211 Ethernet Controller supports 2 Receive Side Scaling (RSS)
queues. It should not be excluded from having this feature enabled.

Via commit c883de9fd787 ("igb: rename igb define to be more generic")
E1000_MRQC_ENABLE_RSS_4Q was renamed to E1000_MRQC_ENABLE_RSS_MQ to
indicate that this is a generic bit flag to enable queues and not
a flag that is specific to devices that support 4 queues

The bit flag enables 2, 4 or 8 queues appropriately depending on the part.

Tested with a multicore CPU and frames were then distributed as expected.

This issue appears to have been introduced because of confusion caused
by the prior name.

Signed-off-by: Nick Lowe <nick.lowe@gmail.com>
Tested-by: David Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d6090faaa41d..23e50de94474 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4482,8 +4482,7 @@ static void igb_setup_mrqc(struct igb_adapter *adapter)
 		else
 			mrqc |= E1000_MRQC_ENABLE_VMDQ;
 	} else {
-		if (hw->mac.type != e1000_i211)
-			mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
+		mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
 	}
 	igb_vmm_control(adapter);
 
-- 
2.26.2

