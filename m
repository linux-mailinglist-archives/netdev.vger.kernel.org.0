Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB61235349
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgHAQSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:19604 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgHAQSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:08 -0400
IronPort-SDR: dIBuAtc7U9mB/zWPdsPSYGxUN4EJgdbAH/c/M85d+XqpwSGevKyK/riFcJKuCkEGtatfNbmhlr
 AssnLYOoJFAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810842"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810842"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:07 -0700
IronPort-SDR: GIoWwSvo3173sZPuNUKLfzRv82y2oJZ2SgyNvxRZnzbrC16OP6ECxwowmKjCkCa78rTK2i0ZII
 2mQAIGfSyuVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457689"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Hulk Robot <hulkci@huawei.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 01/14] ice: mark PM functions as __maybe_unused
Date:   Sat,  1 Aug 2020 09:17:49 -0700
Message-Id: <20200801161802.867645-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

In certain configurations without power management support, the
following warnings happen:

drivers/net/ethernet/intel/ice/ice_main.c:4214:12: warning:
 'ice_resume' defined but not used [-Wunused-function]
 4214 | static int ice_resume(struct device *dev)
      |            ^~~~~~~~~~
drivers/net/ethernet/intel/ice/ice_main.c:4150:12: warning:
 'ice_suspend' defined but not used [-Wunused-function]
 4150 | static int ice_suspend(struct device *dev)
      |            ^~~~~~~~~~~

Mark these functions as __maybe_unused to make it clear to the
compiler that this is going to happen based on the configuration,
which is the standard for these types of functions.

Fixes: 769c500dcc1e ("ice: Add advanced power mgmt for WoL")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c0bde24ab344..bd2a2df25def 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4467,7 +4467,7 @@ static int ice_reinit_interrupt_scheme(struct ice_pf *pf)
  * Power Management callback to quiesce the device and prepare
  * for D3 transition.
  */
-static int ice_suspend(struct device *dev)
+static int __maybe_unused ice_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ice_pf *pf;
@@ -4531,7 +4531,7 @@ static int ice_suspend(struct device *dev)
  * ice_resume - PM callback for waking up from D3
  * @dev: generic device information structure
  */
-static int ice_resume(struct device *dev)
+static int __maybe_unused ice_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	enum ice_reset_req reset_type;
-- 
2.26.2

