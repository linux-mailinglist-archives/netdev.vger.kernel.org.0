Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9E9590754
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 22:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbiHKUZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 16:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235595AbiHKUZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 16:25:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641F098CB9
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 13:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660249539; x=1691785539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tw3DtI9D0ivig9Qt69fqzEvmz+8m4FAUQXopFv/RsAg=;
  b=RNeJpny/oTFoG4qinukjw3IYBosOHykjCUnyHnOATaP10OLzg9DV7W6S
   GlPVurbgaJlEWL32hHjSSvvNlZ4Hc/URrYTWHIfATqjVJWgadd/pyqa7h
   T8xhErEUyxTe+1AlYcBvHJibJ5MvcUw+vnzldbdWB3QBOSv7+B8GfyTW1
   71nCYi+KOmdC1bPhGX9Fm8OIe+v4BhKc+G4I74sMd16cQrU2Vb2RDpgCk
   nWb+sa02uknroVN6dxiRDiCw+Z1rm2yGfM60+Jokp7ryz++nTKN5DA060
   CVArBrTQP9ENC7+xG/ois0TZVz8+P6Jcl1icT+MeAi5ObwB0cBLGYQOa/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="377746460"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="377746460"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 13:25:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="673835234"
Received: from blynch1-mobl1.amr.corp.intel.com (HELO vcostago-mobl3.intel.com) ([10.209.105.53])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 13:25:35 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     jhogan@kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: [WIP v2] igc: fix deadlock caused by taking RTNL in RPM resume path
Date:   Thu, 11 Aug 2022 17:25:24 -0300
Message-Id: <20220811202524.78323-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220811151342.19059-1-vinicius.gomes@intel.com>
References: <20220811151342.19059-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Sorry for the noise earlier, my kernel config didn't have runtime PM
enabled.


 drivers/net/ethernet/intel/igc/igc_main.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ebff0e04045d..9b0d4becfcfc 100644
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
@@ -6642,20 +6642,27 @@ static int __maybe_unused igc_resume(struct device *dev)
 
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
+}
+
+static int __maybe_unused igc_resume(struct device *dev)
+{
+	return __igc_resume(dev, false);
 }
 
 static int __maybe_unused igc_suspend(struct device *dev)
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

