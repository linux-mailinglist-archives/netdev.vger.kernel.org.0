Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE110391DF5
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhEZRXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:23:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:18091 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234677AbhEZRXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:23:00 -0400
IronPort-SDR: s7ElHNsdkcN7hRIbaobCtExKBVRg+0HhKBWO75IBBhvNJIDA1EOYImjwBPTtgukUya8uBkPKDl
 BtAcxiUItOEw==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415786"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415786"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:27 -0700
IronPort-SDR: j3TCRiY+XUaqVMgXThZCk7jChuUoGDS5MmW5Gcw64RumUysEd5BW0FCHALRfTLt8qcO8aZFuLB
 3c4msWW8VgCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149194"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 02/11] intel: remove checker warning
Date:   Wed, 26 May 2021 10:23:37 -0700
Message-Id: <20210526172346.3515587-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The sparse checker (C=2) found an assignment where we were mixing
types when trying to convert from data read directly from the
device NVM, to an array in CPU order in-memory, which
unfortunately the driver tries to do in-place.

This is easily solved by using the swap operation instead of an
assignment, and is already proven in other Intel drivers to be
functionally correct and the same code, just without a sparse
warning.

The change is the same in all three drivers.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Warning Detail:
  CHECK   .../e1000/e1000_ethtool.c
.../e1000/e1000_ethtool.c:516:32: warning: incorrect type in assignment (different base types)
.../e1000/e1000_ethtool.c:516:32:    expected unsigned short [usertype]
.../e1000/e1000_ethtool.c:516:32:    got restricted __le16 [usertype]
  CHECK   .../igb/igb_ethtool.c
.../igb/igb_ethtool.c:834:32: warning: incorrect type in assignment (different base types)
.../igb/igb_ethtool.c:834:32:    expected unsigned short [usertype]
.../igb/igb_ethtool.c:834:32:    got restricted __le16 [usertype]
  CHECK   .../igc/igc_ethtool.c
.../igc/igc_ethtool.c:555:32: warning: incorrect type in assignment (different base types)
.../igc/igc_ethtool.c:555:32:    expected unsigned short [usertype]
.../igc/igc_ethtool.c:555:32:    got restricted __le16 [usertype]
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c     | 2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index f976e9daa3d8..3c51ee94fa00 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -513,7 +513,7 @@ static int e1000_set_eeprom(struct net_device *netdev,
 	memcpy(ptr, bytes, eeprom->len);
 
 	for (i = 0; i < last_word - first_word + 1; i++)
-		eeprom_buff[i] = cpu_to_le16(eeprom_buff[i]);
+		cpu_to_le16s(&eeprom_buff[i]);
 
 	ret_val = e1000_write_eeprom(hw, first_word,
 				     last_word - first_word + 1, eeprom_buff);
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 7545da216d8b..636a1b1fb7e1 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -831,7 +831,7 @@ static int igb_set_eeprom(struct net_device *netdev,
 	memcpy(ptr, bytes, eeprom->len);
 
 	for (i = 0; i < last_word - first_word + 1; i++)
-		eeprom_buff[i] = cpu_to_le16(eeprom_buff[i]);
+		cpu_to_le16s(&eeprom_buff[i]);
 
 	ret_val = hw->nvm.ops.write(hw, first_word,
 				    last_word - first_word + 1, eeprom_buff);
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 9722449d7633..2cb12431c371 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -554,7 +554,7 @@ static int igc_ethtool_set_eeprom(struct net_device *netdev,
 	memcpy(ptr, bytes, eeprom->len);
 
 	for (i = 0; i < last_word - first_word + 1; i++)
-		eeprom_buff[i] = cpu_to_le16(eeprom_buff[i]);
+		cpu_to_le16s(&eeprom_buff[i]);
 
 	ret_val = hw->nvm.ops.write(hw, first_word,
 				    last_word - first_word + 1, eeprom_buff);
-- 
2.26.2

