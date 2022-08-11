Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A0E58FF21
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiHKPSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbiHKPSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:18:01 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE41910AF
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 08:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660231080; x=1691767080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0fEKQjA1HCk9crC+7tHW1/TWCNPNYgFPRzpLwyPy/HM=;
  b=D251O83//E3g1kZzGgzOsEXk71ysto7+1LSD/nQnLHEtAXqTjtA42e5v
   deGBR2hNoy0eDA5SLGCiqtyvpDK48cAarBdeEWvRFb7tk4YsBrFzLUSAl
   O0DWQfYtRFIDNrjE8Ypl4cRsqyhI9IofnwFVMZILUc9f0eCi4DQd5NWSw
   +yg50qfwtm+BiEL4dWFwqWH/vmGPdR4643ayw1nv5u8hWRdNipVU2gIPO
   DbmFE8OQ7JQjg0bHl3J57ZO0jWb0baZgVHfI1rXBrMdkbbTJgQvh9LOER
   hMYjNKmu/6A7+1YZGSCjLak+m4bgw3Td3p5tca/KLIMoFmkQ967JjnEQB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="288941687"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="288941687"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 08:14:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="781634966"
Received: from jmhiguer-mobl.amr.corp.intel.com (HELO vcostago-mobl3.intel.com) ([10.212.17.132])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 08:13:59 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     jhogan@kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: [PATCH] igc: fix deadlock caused by taking RTNL in RPM resume path
Date:   Thu, 11 Aug 2022 12:13:42 -0300
Message-Id: <20220811151342.19059-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <4765029.31r3eYUQgx@saruman>
References: <4765029.31r3eYUQgx@saruman>
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

It was reported a RTNL deadlock in the igc driver that was causing
problems during suspend/resume.

The solution is similar to commit ac8c58f5b535 ("igb: fix deadlock
caused by taking RTNL in RPM resume path").

Reported-by: James Hogan <jhogan@kernel.org>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
Hi James,

Thanks to your investigation I found commit ac8c58f5b535, and it looks
like it could solve the issue you are seeing.

Could you please see if this patch helps. It's only compile and boot
tested.

Sorry the delay, I am travelling.

Cheers,


 drivers/net/ethernet/intel/igc/igc_main.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ebff0e04045d..5079dc581d8d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6600,7 +6600,7 @@ static void igc_deliver_wake_packet(struct net_device *netdev)
 	netif_rx(skb);
 }
 
-static int __maybe_unused igc_resume(struct device *dev)
+static int __maybe_unused __igc_resume(struct device *dev, bool rpm)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -6642,23 +6642,30 @@ static int __maybe_unused igc_resume(struct device *dev)
 
 	wr32(IGC_WUS, ~0);
 
-	rtnl_lock();
+	if (!rpm)
+		rtnl_lock();
 	if (!err && netif_running(netdev))
 		err = __igc_open(netdev, true);
 
 	if (!err)
 		netif_device_attach(netdev);
-	rtnl_unlock();
+	if (!rpm)
+		rtnl_unlock();
 
 	return err;
 }
 
 static int __maybe_unused igc_runtime_resume(struct device *dev)
 {
-	return igc_resume(dev);
+	return __igc_resume(dev, true);
 }
 
-static int __maybe_unused igc_suspend(struct device *dev)
+static int __maybe_unused igc_resume(struct device *dev)
+{
+	return __igc_resume(dev, false);
+}
+
+static int __maybe_unused __igc_suspend(struct device *dev)
 {
 	return __igc_shutdown(to_pci_dev(dev), NULL, 0);
 }
@@ -6719,7 +6726,7 @@ static pci_ers_result_t igc_io_error_detected(struct pci_dev *pdev,
  *  @pdev: Pointer to PCI device
  *
  *  Restart the card from scratch, as if from a cold-boot. Implementation
- *  resembles the first-half of the igc_resume routine.
+ *  resembles the first-half of the __igc_resume routine.
  **/
 static pci_ers_result_t igc_io_slot_reset(struct pci_dev *pdev)
 {
@@ -6758,7 +6765,7 @@ static pci_ers_result_t igc_io_slot_reset(struct pci_dev *pdev)
  *
  *  This callback is called when the error recovery driver tells us that
  *  its OK to resume normal operation. Implementation resembles the
- *  second-half of the igc_resume routine.
+ *  second-half of the __igc_resume routine.
  */
 static void igc_io_resume(struct pci_dev *pdev)
 {
-- 
2.37.1

