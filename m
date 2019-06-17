Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7A8495EE
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfFQXda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:33:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:25836 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbfFQXdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:33:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 16:33:24 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jun 2019 16:33:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/11] iavf: add call to iavf_[add|del]_cloud_filter
Date:   Mon, 17 Jun 2019 16:33:35 -0700
Message-Id: <20190617233336.18119-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
References: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Add call to iavf_add_cloud_filter and iavf_del_cloud_filter from
iavf_process_aq_command to clear aq_required
IAVF_FLAG_AQ_ADD_CLOUD_FILTER and IAVF_FLAG_AQ_DEL_CLOUD_FILTER bits.

aq_required IAVF_FLAG_AQ_DEL_CLOUD_FILTER bit is being set in
iavf_down and iavf_delete_clsflower, and are never cleared.

aq_required IAVF_FLAG_AQ_ADD_CLOUD_FILTER bit is being set in
iavf_handle_reset and iavf_configure_clsflower, and are never
cleared.

Since the aq_required is not zero, iavf_watchdog_task is setting the
queue_delayed_work to 20 msec instead of the longer delay.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 6d1bef219a7a..881561b36083 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1658,7 +1658,14 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
 		iavf_del_cloud_filter(adapter);
 		return 0;
 	}
-
+	if (adapter->aq_required & IAVF_FLAG_AQ_DEL_CLOUD_FILTER) {
+		iavf_del_cloud_filter(adapter);
+		return 0;
+	}
+	if (adapter->aq_required & IAVF_FLAG_AQ_ADD_CLOUD_FILTER) {
+		iavf_add_cloud_filter(adapter);
+		return 0;
+	}
 	return -EAGAIN;
 }
 
-- 
2.21.0

