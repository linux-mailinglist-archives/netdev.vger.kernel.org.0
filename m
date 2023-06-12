Return-Path: <netdev+bounces-10230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC7C72D138
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06F9D280E51
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C64F19E4B;
	Mon, 12 Jun 2023 20:58:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1200915493
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:58:06 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C110E49CA
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686603465; x=1718139465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/h2+CPsWTXxToiP47qCqfP8kaA4QSjM5C0Bm7Fp6Wb4=;
  b=PA6vFgoZE9qzGVada31CWcaF8UEd48EABAMzUhoHx+Z4gK9cyHuqAOLv
   W4jYmVQbtaE+MD0Xs22pNqqLjEJGW5w1FbMOlMyBmpHlY3NbtPvkyZrKl
   evWZe4d+GgRFNi203wiVQM08jaiGURHIB82rgZ7xnsz0SRBI/O1zLPiKQ
   idNQojrT+Qw2LsJ59WWhDAcmTAQ1jusKKy0kR2cxr2gdgvIXBSSp1oLJB
   YlLTBiGjjpLdO77LuRJEtXAYEUYCTT5/UfL6U/l5wZQCK3fJ2LCqa6goX
   /bisWNkyQ09Va8Rq2V7SAMs+D4cQ+LTDB9qAVP8goIBFMJMIE2t2oW7jq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="386548224"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="386548224"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 13:56:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885586130"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="885586130"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 12 Jun 2023 13:56:52 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	anthony.l.nguyen@intel.com,
	maciej.fijalkowski@intel.com
Subject: [PATCH net v3 3/3] igb: fix nvm.ops.read() error handling
Date: Mon, 12 Jun 2023 13:52:08 -0700
Message-Id: <20230612205208.115292-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230612205208.115292-1-anthony.l.nguyen@intel.com>
References: <20230612205208.115292-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Add error handling into igb_set_eeprom() function, in case
nvm.ops.read() fails just quit with error code asap.

Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 7d60da1b7bf4..319ed601eaa1 100644
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
@@ -841,6 +843,7 @@ static int igb_set_eeprom(struct net_device *netdev,
 		hw->nvm.ops.update(hw);
 
 	igb_set_fw_version(adapter);
+out:
 	kfree(eeprom_buff);
 	return ret_val;
 }
-- 
2.38.1


