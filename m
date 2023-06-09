Return-Path: <netdev+bounces-9599-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B1B729FDD
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DD7C28197F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54281200DD;
	Fri,  9 Jun 2023 16:15:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4994A17757
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:15:39 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F27F359C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686327338; x=1717863338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cPepQWlzZsaK6orMAe7HW0FNutCMdqMQPuFKOJdA/ls=;
  b=cyJ3yv/TdGmjaBFpEuRYsMblYfOvUOH+uVJJg54hlwVT5tRoh7MU599J
   8g9zz0L6Oa1Dgv4x86KJN1d7iyz4KVzzfhYNq1Me6Ew2RXuY69OlYXDXE
   9WsqEUGw8nhbjHlK7e8jY7ajJNudYkQjUIJhIeDmdb/UYvAzI0+R+91v0
   io84zLl2kWJCtr5RWz5PJuKkeZwP0VautjjpqtjhdLkg9QuEzYsMEOZJ4
   G6v2Ls5UrS8moP+pXNrhH42VNOqwYfvSlFmOfKmT4J/KMvO2YX9SAFSya
   UPDEyXMGG54uwHxrodqAaaePAHIcOMIJdpvdrt1N3X7tHi4lpuH82hUiY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="423511410"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="423511410"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:15:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="884645681"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="884645681"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 09 Jun 2023 09:15:37 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	anthony.l.nguyen@intel.com,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net v2 3/3] igb: fix nvm.ops.read() error handling
Date: Fri,  9 Jun 2023 09:10:58 -0700
Message-Id: <20230609161058.3485225-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
References: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Add error handling into igb_set_eeprom() function, in case
nvm.ops.read() fails just quit with error code asap.

Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 7d60da1b7bf4..99b6b21caa02 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -822,6 +822,8 @@ static int igb_set_eeprom(struct net_device *netdev,
 		 */
 		ret_val = hw->nvm.ops.read(hw, last_word, 1,
 				   &eeprom_buff[last_word - first_word]);
+		if (ret_val)
+			goto out;
 	}
 
 	/* Device's eeprom is always little-endian, word addressable */
@@ -839,7 +841,7 @@ static int igb_set_eeprom(struct net_device *netdev,
 	/* Update the checksum if nvm write succeeded */
 	if (ret_val == 0)
 		hw->nvm.ops.update(hw);
-
+out:
 	igb_set_fw_version(adapter);
 	kfree(eeprom_buff);
 	return ret_val;
-- 
2.38.1


