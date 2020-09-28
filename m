Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96B127B3CC
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgI1R7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:32952 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgI1R72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:28 -0400
IronPort-SDR: CRI/K/ZQ9Zmurs8ENG/qyBYWWEldaCyNOOqdqmyzHeC5RmHIgKLjUB2PfCx5y5m/jDvoeSVt14
 j113Hv/+vkRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810263"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810263"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:21 -0700
IronPort-SDR: aooQcxjs12mdrikAuyDEL2xcFIQpwNjBZWLv0PoPd+G13mag+PHtwafJmCbCluMWdv2gIg4LAF
 jMo/yxD5UzuQ==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505372"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Gal Hammer <ghammer@redhat.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 02/15] igb: read PBA number from flash
Date:   Mon, 28 Sep 2020 10:58:55 -0700
Message-Id: <20200928175908.318502-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
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
index 73125d11460f..d5c65850826e 100644
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

