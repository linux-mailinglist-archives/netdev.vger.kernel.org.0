Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F951DC795
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgEUH2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 03:28:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:34925 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbgEUH2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 03:28:02 -0400
IronPort-SDR: uxl5cRZ9r8lsXXF9qf8sh1cSp8QVcsTe6VSWwN9XcVKNQOtlVGRSWulFZiuhNY35OG2lb7kS3L
 1L6RlexoaGIw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 00:28:02 -0700
IronPort-SDR: DFOGtizIgpuw4MPdRMFQ12kOjPRG88bM7vw5xKiVs2I4Lxvfkj8KWdlu8XZ4k5yzfahYnY6M9r
 2tCM/FL9PGrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="343758695"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga001.jf.intel.com with ESMTP; 21 May 2020 00:28:00 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        stable <stable@vger.kernel.org>,
        Maxim Zhukov <mussitantesmortem@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] e1000: Do not perform reset in reset_task if we are already down
Date:   Thu, 21 May 2020 00:27:48 -0700
Message-Id: <20200521072758.440264-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
References: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

We are seeing a deadlock in e1000 down when NAPI is being disabled. Looking
over the kernel function trace of the system it appears that the interface
is being closed and then a reset is hitting which deadlocks the interface
as the NAPI interface is already disabled.

To prevent this from happening I am disabling the reset task when
__E1000_DOWN is already set. In addition code has been added so that we set
the __E1000_DOWN while holding the __E1000_RESET flag in e1000_close in
order to guarantee that the reset task will not run after we have started
the close call.

CC: stable <stable@vger.kernel.org>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: Maxim Zhukov <mussitantesmortem@gmail.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 05bc6e216bca..d9fa4600f745 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -542,8 +542,13 @@ void e1000_reinit_locked(struct e1000_adapter *adapter)
 	WARN_ON(in_interrupt());
 	while (test_and_set_bit(__E1000_RESETTING, &adapter->flags))
 		msleep(1);
-	e1000_down(adapter);
-	e1000_up(adapter);
+
+	/* only run the task if not already down */
+	if (!test_bit(__E1000_DOWN, &adapter->flags)) {
+		e1000_down(adapter);
+		e1000_up(adapter);
+	}
+
 	clear_bit(__E1000_RESETTING, &adapter->flags);
 }
 
@@ -1433,10 +1438,15 @@ int e1000_close(struct net_device *netdev)
 	struct e1000_hw *hw = &adapter->hw;
 	int count = E1000_CHECK_RESET_COUNT;
 
-	while (test_bit(__E1000_RESETTING, &adapter->flags) && count--)
+	while (test_and_set_bit(__E1000_RESETTING, &adapter->flags) && count--)
 		usleep_range(10000, 20000);
 
-	WARN_ON(test_bit(__E1000_RESETTING, &adapter->flags));
+	WARN_ON(count < 0);
+
+	/* signal that we're down so that the reset task will no longer run */
+	set_bit(__E1000_DOWN, &adapter->flags);
+	clear_bit(__E1000_RESETTING, &adapter->flags);
+
 	e1000_down(adapter);
 	e1000_power_down_phy(adapter);
 	e1000_free_irq(adapter);
-- 
2.26.2

