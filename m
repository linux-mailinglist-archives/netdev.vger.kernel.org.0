Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CED71F70A1
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgFKWvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:51:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:54985 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgFKWvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:51:05 -0400
IronPort-SDR: pew/jYRk7bC2v+t7ahjaVV+VGu4g+B/f/WgmonX9y2bmNGsfwuEzJRh1gwnoMtaJRIksDzNAmr
 PaOvUdDhf7ZQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 15:51:03 -0700
IronPort-SDR: JafyYG0zkE95m8qIM0noqL1Lk4v0nh30beHaBOQGZhE6nyjSPxRdKOoUbt1NPLva91ri72dLhD
 8AT8nuU1vraQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="296755905"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jun 2020 15:51:03 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 4/4] iavf: increase reset complete wait time
Date:   Thu, 11 Jun 2020 15:51:00 -0700
Message-Id: <20200611225100.326062-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
References: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

With an increased number of VFs, it's possible to encounter the following
issue during reset.

    iavf b8d4:00:02.0: Hardware reset detected
    iavf b8d4:00:02.0: Reset never finished (0)
    iavf b8d4:00:02.0: Reset task did not complete, VF disabled

Increase the reset complete wait count to allow for 128 VFs to complete
reset.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  4 ++++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 12 +++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 2d4ce6fdba1a..10b805ba03ee 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -219,6 +219,10 @@ struct iavf_cloud_filter {
 	bool add;		/* filter needs to be added */
 };
 
+#define IAVF_RESET_WAIT_MS 10
+#define IAVF_RESET_WAIT_DETECTED_COUNT 500
+#define IAVF_RESET_WAIT_COMPLETE_COUNT 2000
+
 /* board specific private data structure */
 struct iavf_adapter {
 	struct work_struct reset_task;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 06c481e9ac5c..fa82768e5eda 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2046,8 +2046,6 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	dev_info(&adapter->pdev->dev, "Reset task did not complete, VF disabled\n");
 }
 
-#define IAVF_RESET_WAIT_MS 10
-#define IAVF_RESET_WAIT_COUNT 500
 /**
  * iavf_reset_task - Call-back task to handle hardware reset
  * @work: pointer to work_struct
@@ -2101,20 +2099,20 @@ static void iavf_reset_task(struct work_struct *work)
 	adapter->flags |= IAVF_FLAG_RESET_PENDING;
 
 	/* poll until we see the reset actually happen */
-	for (i = 0; i < IAVF_RESET_WAIT_COUNT; i++) {
+	for (i = 0; i < IAVF_RESET_WAIT_DETECTED_COUNT; i++) {
 		reg_val = rd32(hw, IAVF_VF_ARQLEN1) &
 			  IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 		if (!reg_val)
 			break;
 		usleep_range(5000, 10000);
 	}
-	if (i == IAVF_RESET_WAIT_COUNT) {
+	if (i == IAVF_RESET_WAIT_DETECTED_COUNT) {
 		dev_info(&adapter->pdev->dev, "Never saw reset\n");
 		goto continue_reset; /* act like the reset happened */
 	}
 
 	/* wait until the reset is complete and the PF is responding to us */
-	for (i = 0; i < IAVF_RESET_WAIT_COUNT; i++) {
+	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
 		/* sleep first to make sure a minimum wait time is met */
 		msleep(IAVF_RESET_WAIT_MS);
 
@@ -2126,7 +2124,7 @@ static void iavf_reset_task(struct work_struct *work)
 
 	pci_set_master(adapter->pdev);
 
-	if (i == IAVF_RESET_WAIT_COUNT) {
+	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",
 			reg_val);
 		iavf_disable_vf(adapter);
@@ -3429,7 +3427,7 @@ static int iavf_check_reset_complete(struct iavf_hw *hw)
 	u32 rstat;
 	int i;
 
-	for (i = 0; i < 100; i++) {
+	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
 		rstat = rd32(hw, IAVF_VFGEN_RSTAT) &
 			     IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
 		if ((rstat == VIRTCHNL_VFR_VFACTIVE) ||
-- 
2.26.2

