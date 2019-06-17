Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF71495EA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfFQXdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:33:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:25830 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbfFQXdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:33:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 16:33:22 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jun 2019 16:33:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/11] iavf: wait longer for close to complete
Date:   Mon, 17 Jun 2019 16:33:28 -0700
Message-Id: <20190617233336.18119-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
References: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

On some hardware/driver/architecture combinations, it may take longer
than 200msec for all close operations to be completed, causing a
spurious error message to be logged.

Increase the timeout value to 500msec to avoid this erroneous error.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 36f17d0c7a2e..9ce04a8c0d0f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3021,7 +3021,7 @@ static int iavf_close(struct net_device *netdev)
 
 	status = wait_event_timeout(adapter->down_waitqueue,
 				    adapter->state == __IAVF_DOWN,
-				    msecs_to_jiffies(200));
+				    msecs_to_jiffies(500));
 	if (!status)
 		netdev_warn(netdev, "Device resources not yet released\n");
 	return 0;
-- 
2.21.0

