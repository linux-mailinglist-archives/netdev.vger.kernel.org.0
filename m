Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BE8525759
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358914AbiELVu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358913AbiELVuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:50:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D664B1C7
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652392223; x=1683928223;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gcfzZ3fpl14cUvzl9ndtmSAWGzZi2hTfIUfuJ5kfmq4=;
  b=SPbG/aKSb5LSMA/HaABsSkf49d5m+Blc3QmBXcHggdjr3Bd3RF79hmJJ
   /YtUfj9VV3+Ccz4ntNC5QN9fJhnWxb2Qh+F2iC2K7BvDvcTi/WUBB3T9N
   iIFoRVqcXlHam5IdFmYXQWRMZIqoDumKAAS+Kqga8DEGXuPYBizsDLm+A
   QtX5ZHOY2F6FKaBptz40dPtEf0Cuk0HkT/hJ4z2+Ebp2AqzWqn5RWJ2cH
   8H3hmT45FjA/O+3NY0NdLFYYf4IbzDSfaXkjG7i0H9CC/Z2gB/GFPvWQE
   bV/zNeeRwlQtGrxnFj5BjxAuhOt7nAgTQlyus3IBzWpTnQIOkvit2nZHW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="257689569"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="257689569"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:50:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="658813593"
Received: from ccmincem-mobl1.amr.corp.intel.com (HELO kdpelton-desk.amr.corp.intel.com) ([10.212.163.26])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:50:20 -0700
From:   Kyle Pelton <kyle.d.pelton@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, hayeswang@realtek.com,
        aaron.ma@canonical.com
Cc:     Kyle Pelton <kyle.d.pelton@linux.intel.com>
Subject: [PATCH] net: usb: r8152: Set default WOL options
Date:   Thu, 12 May 2022 14:50:13 -0700
Message-Id: <20220512215013.230647-1-kyle.d.pelton@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set default wake-on-lan options on probe to avoid state from previous
boot.

Fixes issue on some boots where wake-on-lan settings are incorrectly set
due to previous runtime-suspend activity. This causes spurious wakeups
while in suspend.

Signed-off-by: Kyle Pelton <kyle.d.pelton@linux.intel.com>
---
 drivers/net/usb/r8152.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ee41088c5251..a2b3c398beee 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3269,6 +3269,7 @@ static int rtl8152_set_features(struct net_device *dev,
 }
 
 #define WAKE_ANY (WAKE_PHY | WAKE_MAGIC | WAKE_UCAST | WAKE_BCAST | WAKE_MCAST)
+#define WAKE_DEFAULT (WAKE_PHY << 5)
 
 static u32 __rtl_get_wol(struct r8152 *tp)
 {
@@ -9717,10 +9718,12 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	intf->needs_remote_wakeup = 1;
 
-	if (!rtl_can_wakeup(tp))
+	if (!rtl_can_wakeup(tp)) {
 		__rtl_set_wol(tp, 0);
-	else
+	} else {
+		__rtl_set_wol(tp, WAKE_DEFAULT);
 		tp->saved_wolopts = __rtl_get_wol(tp);
+	}
 
 	tp->rtl_ops.init(tp);
 #if IS_BUILTIN(CONFIG_USB_RTL8152)
-- 
2.25.1

