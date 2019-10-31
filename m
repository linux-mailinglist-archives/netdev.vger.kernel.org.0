Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95E0EB99D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbfJaWRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:17:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:61777 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387423AbfJaWRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 18:17:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 15:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="199662504"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 Oct 2019 15:17:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Manfred Rudigier <manfred.rudigier@omicronenergy.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 3/7] igb: Fix constant media auto sense switching when no cable is connected
Date:   Thu, 31 Oct 2019 15:17:15 -0700
Message-Id: <20191031221719.14028-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
References: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manfred Rudigier <manfred.rudigier@omicronenergy.com>

At least on the i350 there is an annoying behavior that is maybe also
present on 82580 devices, but was probably not noticed yet as MAS is not
widely used.

If no cable is connected on both fiber/copper ports the media auto sense
code will constantly swap between them as part of the watchdog task and
produce many unnecessary kernel log messages.

The swap code responsible for this behavior (switching to fiber) should
not be executed if the current media type is copper and there is no signal
detected on the fiber port. In this case we can safely wait until the
AUTOSENSE_EN bit is cleared.

Signed-off-by: Manfred Rudigier <manfred.rudigier@omicronenergy.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 17a961c3d6e4..cf42278393e1 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2065,7 +2065,8 @@ static void igb_check_swap_media(struct igb_adapter *adapter)
 	if ((hw->phy.media_type == e1000_media_type_copper) &&
 	    (!(connsw & E1000_CONNSW_AUTOSENSE_EN))) {
 		swap_now = true;
-	} else if (!(connsw & E1000_CONNSW_SERDESD)) {
+	} else if ((hw->phy.media_type != e1000_media_type_copper) &&
+	    !(connsw & E1000_CONNSW_SERDESD)) {
 		/* copper signal takes time to appear */
 		if (adapter->copper_tries < 4) {
 			adapter->copper_tries++;
-- 
2.21.0

