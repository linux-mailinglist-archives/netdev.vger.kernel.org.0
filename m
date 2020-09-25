Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CF0279301
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgIYVJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:09:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:48591 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728155AbgIYVJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 17:09:42 -0400
IronPort-SDR: zqGq1UrPOirb/uXpC18ZDwvOkqp8tCHZe48eJwbzxx09EPrYokxZWMEhE12bBTAQ2aXJ4uBBUo
 8tBI0J5f4CHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="161724523"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="161724523"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 14:09:41 -0700
IronPort-SDR: c9HEeOGCAajgnu5uQcwtrfTkqkfNNSsYXzTWFF9attaR8LpKsC7VF0PezGmxiqO5QIk5u45Ot8
 H1wKHN0YCgDQ==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="291979267"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 14:09:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net v2 1/4] iavf: Fix incorrect adapter get in iavf_resume
Date:   Fri, 25 Sep 2020 14:09:27 -0700
Message-Id: <20200925210930.4049734-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
References: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

When calling iavf_resume there was a crash because wrong
function was used to get iavf_adapter and net_device pointers.
Changed how iavf_resume is getting iavf_adapter and net_device
pointers from pci_dev.

Fixes: 5eae00c57f5e ("i40evf: main driver core")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d870343cf689..cf539db79af9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3806,8 +3806,8 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 static int __maybe_unused iavf_resume(struct device *dev_d)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_d);
-	struct iavf_adapter *adapter = pci_get_drvdata(pdev);
-	struct net_device *netdev = adapter->netdev;
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct iavf_adapter *adapter = netdev_priv(netdev);
 	u32 err;
 
 	pci_set_master(pdev);
-- 
2.26.2

