Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A743B575459
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbiGNSCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbiGNSCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:02:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C062167C8B
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657821729; x=1689357729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R+MZVfyc8kSK0iDH7cdged1WPS7964asH3HDL0OLcuU=;
  b=bXmKh/kky/lqIHV8utksFs862ZthaM20KhKjU+EipS/+fPoY+L3Sr43P
   WJ0Et/eMyBjyXpql6P1DNBV8Hp6igGOr4H7i720BTkW9r+lY3Tdv9C+y+
   4/F0yLSXCNQnYEMxz85aA/9d0tHuhab1UJHoEOXLPPTgDyhaz29a4VA1c
   8q5anQJqFJAV3jB8cvOCzlRqSN57o1V2P72r2wusWYUU3G7hL7Wzjonob
   UUOBT7VgsgEmAVarB9aIcin23+PUL8xwOFpXfSqGIioINMlgOl4h58Nte
   PuYmYr/PnAXzJdoqj5GoGoztxHmqx92PT3kbHtQRpBWv6rgOuDlfAHLhT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="283151245"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="283151245"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:01:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="842235645"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2022 11:01:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Chia-Lin Kao <acelan.kao@canonical.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 1/3] e1000e: Enable GPT clock before sending message to CSME
Date:   Thu, 14 Jul 2022 10:58:55 -0700
Message-Id: <20220714175857.933537-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
References: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

On corporate (CSME) ADL systems, the Ethernet Controller may stop working
("HW unit hang") after exiting from the s0ix state. The reason is that
CSME misses the message sent by the host. Enabling the dynamic GPT clock
solves this problem. This clock is cleared upon HW initialization.

Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Reviewed-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index fa06f68c8c80..c64102b29862 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6494,6 +6494,10 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
 	    hw->mac.type >= e1000_pch_adp) {
+		/* Keep the GPT clock enabled for CSME */
+		mac_data = er32(FEXTNVM);
+		mac_data |= BIT(3);
+		ew32(FEXTNVM, mac_data);
 		/* Request ME unconfigure the device from S0ix */
 		mac_data = er32(H2ME);
 		mac_data &= ~E1000_H2ME_START_DPG;
-- 
2.35.1

