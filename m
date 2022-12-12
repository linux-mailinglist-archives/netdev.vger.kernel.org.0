Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FEB64A7D0
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 20:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiLLTCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 14:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbiLLTCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 14:02:00 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772B263E8
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670871639; x=1702407639;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6KQA314gdM9vFeajuuxznW0prMlmiT3V60QAL4tDdqY=;
  b=mk+c87XhIkAnA6PIf4YQaba89ARGb7VfaIlAi3B/0uQEMyzTL2cLe0QY
   WxhSbKafcXiMxOtcLBWRQIpnMMwet+nq4IY93sDN8OxdGRkR7tdtMFiDL
   7aXPoVe92S4qCevxgfPQLviyMZ/fuuVSGcGV8ptnNApTccmJ//jeoEYXJ
   wzMVKHUoT4J5CbvlUgPPcT2o9vhjsmK7ZQtebKNGvcr4VRTRLu0+GDWHI
   b8yLuVKHRFJ9qwcT3/7DGr0a7CTenaSEFQUXXGtKubpJh4sBdeX8ubHDk
   zQzEAXXkp1zBKpZXDba27fWocJusu8hMTVToTZciBorWnRINLwc/CaR/1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="316636685"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="316636685"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 11:00:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="755061726"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="755061726"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 12 Dec 2022 11:00:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        agraf@suse.de, akihiko.odaki@daynix.com, yan@daynix.com,
        gregkh@linuxfoundation.org, security@kernel.org
Subject: [PATCH net 1/1] igb: Initialize mailbox message for VF reset
Date:   Mon, 12 Dec 2022 11:00:31 -0800
Message-Id: <20221212190031.3983342-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a MAC address is not assigned to the VF, that portion of the message
sent to the VF is not set. The memory, however, is allocated from the
stack meaning that information may be leaked to the VM. Initialize the
message buffer to 0 so that no information is passed to the VM in this
case.

Fixes: 6ddbc4cf1f4d ("igb: Indicate failure on vf reset for empty mac address")
Reported-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f8e32833226c..473158c09f1d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7521,7 +7521,7 @@ static void igb_vf_reset_msg(struct igb_adapter *adapter, u32 vf)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	unsigned char *vf_mac = adapter->vf_data[vf].vf_mac_addresses;
-	u32 reg, msgbuf[3];
+	u32 reg, msgbuf[3] = {};
 	u8 *addr = (u8 *)(&msgbuf[1]);
 
 	/* process all the same items cleared in a function level reset */
-- 
2.35.1

