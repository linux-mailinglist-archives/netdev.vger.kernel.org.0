Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C557627B87D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgI1XyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:54:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:45507 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgI1XyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:54:05 -0400
IronPort-SDR: +72iW/WVWk6vVwO7pX/STc/r+VHc6EId6jZFP+OikOY1uXct8GqaCELqVVdDnpWZnX4vSrq1iI
 aaN2Szu4nINw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142086320"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142086320"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
IronPort-SDR: ykpo1GsHiOEA1xgbwkqZZqbYdirjfshkzrOcRTa13y81VN22O9H3ElbVJT4GVFjcllz63KOdNT
 fgSvGc5inPZw==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962097"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Gal Hammer <ghammer@redhat.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 02/15] igb: read PBA number from flash
Date:   Mon, 28 Sep 2020 14:50:05 -0700
Message-Id: <20200928215018.952991-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Hammer <ghammer@redhat.com>

Fixed flash presence check for 82576 controllers so the part
number string is read and displayed correctly.

Signed-off-by: Gal Hammer <ghammer@redhat.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e53ed2de5cce..368f950f68b1 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3532,7 +3532,9 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			  "Width x1" : "unknown"), netdev->dev_addr);
 	}
 
-	if ((hw->mac.type >= e1000_i210 ||
+	if ((hw->mac.type == e1000_82576 &&
+	     rd32(E1000_EECD) & E1000_EECD_PRES) ||
+	    (hw->mac.type >= e1000_i210 ||
 	     igb_get_flash_presence_i210(hw))) {
 		ret_val = igb_read_part_string(hw, part_str,
 					       E1000_PBANUM_LENGTH);
-- 
2.26.2

